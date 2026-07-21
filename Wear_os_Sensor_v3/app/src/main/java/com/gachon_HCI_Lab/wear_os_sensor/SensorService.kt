package com.gachon_HCI_Lab.wear_os_sensor

import android.annotation.SuppressLint
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import com.example.wear_os_sensor.SensorViewModel
import com.example.wear_os_sensor_v2.R
import com.gachon_HCI_Lab.wear_os_sensor.model.Constant
import com.gachon_HCI_Lab.wear_os_sensor.model.SensorModel
import com.gachon_HCI_Lab.wear_os_sensor.util.PpgUtil
import com.gachon_HCI_Lab.wear_os_sensor.util.connect.BluetoothConnect
import com.gachon_HCI_Lab.wear_os_sensor.util.step.StepsReaderUtil
import java.nio.ByteBuffer
import java.nio.ByteOrder

class SensorService : Service(), SensorEventListener {

    private lateinit var sensorViewModel: SensorViewModel
    private var dataSender: BluetoothConnect = BluetoothConnect
    val intent = Intent("com.example.ACTION_SERVICE_STOPPED")
    val ppg = PpgUtil(this)

    private lateinit var vibrator: Vibrator

    // [추가 1] 스레드 중복 생성 방지용 플래그
    @Volatile private var isServiceRunning = false
    private var mainThread: Thread? = null

    // [추가 2] 워치 CPU 수면 방지용 WakeLock
    private var wakeLock: PowerManager.WakeLock? = null

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val vibratorManager = getSystemService(VIBRATOR_MANAGER_SERVICE) as VibratorManager
            vibratorManager.defaultVibrator
        } else {
            getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        }
    }

    @SuppressLint("WakelockTimeout")
    fun startForground() {
        // 이미 실행 중이면 스레드를 또 만들지 않고 무시! (스레드 폭발 방지)
        if (isServiceRunning) return

        isServiceRunning = true
        setForground()

        // 워치 CPU가 잠들지 않도록 멱살 잡기
        val powerManager = getSystemService(POWER_SERVICE) as PowerManager
        wakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "WearOsSensor::WakeLock")
        wakeLock?.acquire()

        sensorViewModel = SensorViewModel(getSystemService(SENSOR_SERVICE) as SensorManager, this)
        sensorViewModel.register()

        // 하나의 스레드에서 연결 -> 전송 -> 끊기면 재연결을 모두 순차적으로 처리합니다.
        mainThread = Thread {
            runSensorLoop()
        }
        mainThread?.start()
    }

    private fun runSensorLoop() {
        // 1. 최초 연결 시도
        var connected = false
        try {
            dataSender.connect()
            connected = true
            ppg.start()
        } catch (_: Exception) {
            // 실패하면 바로 무한 재연결 루프로 진입
            handleReconnectLoop()
        }

        // 2. 정상 전송 루프
        while (isServiceRunning) {
            try {
                if (SensorModel.sendData.size >= 40) {
                    val sendBinary = createSendData()
                    StepsReaderUtil.readSteps()

                    dataSender.sendData(sendBinary)
                    Thread.sleep(500)
                } else {
                    Thread.sleep(100) // CPU 과부하 방지
                }
            } catch (_: Exception) {
                // 끊어짐 감지! (전송 실패)
                Log.e("SensorService", "블루투스 끊어짐! 재연결 모드 돌입")
                ppg.destroy()
                SensorModel.sendData.clear()
                dataSender.disconnect()

                // (중요) UI에 에러 방송을 보내면 사용자가 버튼을 또 누르므로 방송 생략하고 조용히 재연결 시도
                handleReconnectLoop()
            }
        }
    }

    private fun handleReconnectLoop() {
        var success = false
        var attempts = 0
        while (isServiceRunning && !success) {
            try {
                Log.v("SensorService", "3초 후 새 소켓으로 재연결 시도...")
                Thread.sleep(3000)

                // [2026-07-21] 이유: 폰 앱 재시작으로 RFCOMM 채널이 바뀌었는데 캐시된 옛 채널로만 시도하다 영원히 못 붙는 상황 방지
                //   | 목적: 실패가 누적되면(5회마다) SDP 캐시를 강제 갱신.
                attempts++
                if (attempts % 5 == 0) dataSender.refreshSdpCache()

                dataSender.connect() // 새 소켓을 가져와서 연결
                success = true
                Log.v("SensorService", "자동 재연결 성공!")

                // 진동 알림 후 다시 센서 측정 시작
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    vibrator.vibrate(VibrationEffect.createOneShot(1000, VibrationEffect.DEFAULT_AMPLITUDE))
                } else {
                    vibrator.vibrate(1000)
                }

                ppg.start() // 초록 불 다시 켜기
            } catch (_: Exception) {
                // 실패하면 다시 while 루프를 돌며 3초 대기
            }
        }
    }

    // [2026-06-30] 이유: STOP 버튼 종료(stopService)가 onStartCommand를 안 거쳐 PPG LED OFF 누락 | 목적: 정리 로직을 onDestroy의 멱등 cleanup()으로 일원화
    fun stopForground() {
        // 실제 정리는 onDestroy()에서 일괄 수행한다(stopService 등 모든 종료 경로 커버).
        LocalBroadcastManager.getInstance(applicationContext).sendBroadcast(intent)
        stopSelf()
    }

    // 멱등 정리: 센서 루프 중단 + PPG 리스너 해제(녹색 LED OFF) + BT 해제 + WakeLock 반납.
    @Volatile private var cleaned = false
    private fun cleanup() {
        if (cleaned) return
        cleaned = true
        isServiceRunning = false
        ppg.destroy() // 녹색 LED OFF
        if (::sensorViewModel.isInitialized) sensorViewModel.unRegister()
        dataSender.disconnect()
        wakeLock?.let { if (it.isHeld) it.release() }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent != null) {
            when (intent.action) {
                Constant.ACTION_START_LOCATION_SERVICE -> startForground()
                Constant.ACTION_STOP_LOCATION_SERVICE -> stopForground()
            }
        }
        return START_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
        // stopService(워치 STOP 버튼)는 onStartCommand를 거치지 않고 바로 onDestroy로 오므로,
        // PPG 리스너 해제(녹색 LED OFF)를 반드시 여기서 한다.
        cleanup()

        vibrator.vibrate(VibrationEffect.createOneShot(1000, VibrationEffect.DEFAULT_AMPLITUDE))

        val builder = NotificationCompat.Builder(this, "measuring_service_channel")
            .setContentTitle("서비스가 중단되었습니다")
            .setContentText("측정이 중지되었습니다.")
            .setSmallIcon(R.drawable.component_19)
            .setPriority(NotificationCompat.PRIORITY_HIGH)

        val manager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        manager.notify(2, builder.build())
    }

    override fun onSensorChanged(event: SensorEvent?) {
        if (event == null || !isServiceRunning) return
        val byteData = sensorViewModel.sensorValue(event)

        // 큐 폭발 방지: 큐가 너무 많이 쌓이면 오래된 데이터는 버리고 새 데이터를 받습니다.
        if (SensorModel.sendData.size > 500) {
            SensorModel.sendData.poll()
        }
        SensorModel.sendData.offer(byteData)
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}

    fun setForground() {
        val notificationIntent = Intent(this, MainActivity::class.java)
        notificationIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_NEW_TASK)
        val pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, PendingIntent.FLAG_IMMUTABLE)

        val builder: NotificationCompat.Builder = if (Build.VERSION.SDK_INT >= 26) {
            val channelId = "measuring_service_channel"
            val channel = NotificationChannel(channelId, "Measuring Service Channel", NotificationManager.IMPORTANCE_DEFAULT)
            (getSystemService(NOTIFICATION_SERVICE) as NotificationManager).createNotificationChannel(channel)
            NotificationCompat.Builder(this, channelId)
        } else {
            NotificationCompat.Builder(this)
        }

        builder.setContentTitle("데이터 수집 중")
            .setContentIntent(pendingIntent)

        startForeground(1, builder.build())
    }

    private fun createSendData(): ByteBuffer {
        val byteBuffer = ByteBuffer.allocate(960)
        byteBuffer.order(ByteOrder.LITTLE_ENDIAN)
        (0..39).forEach { _ ->
            val buffer = SensorModel.sendData.take()
            byteBuffer.put(buffer)
        }
        byteBuffer.position(0)
        return byteBuffer
    }
}