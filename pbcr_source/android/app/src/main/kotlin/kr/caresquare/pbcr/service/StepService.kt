package kr.caresquare.pbcr.service

import android.Manifest
import android.app.KeyguardManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.*
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleService
import androidx.lifecycle.LiveData
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import kr.caresquare.pbcr.channel.PhrChannel
import kr.caresquare.pbcr.MainActivity
import kr.caresquare.pbcr.R
import kr.caresquare.pbcr.ext.getBitmapFromVectorDrawable
import kr.caresquare.pbcr.models.ScreenType
import kr.caresquare.pbcr.noti.NotiChannel
import kr.caresquare.pbcr.noti.NotiHelper
import kr.caresquare.pbcr.phr.PhrRepo
import kr.caresquare.pbcr.receiver.RestartStepServiceReceiver
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock


class StepService : LifecycleService(), SensorEventListener {
    private val tag = this::class.java.name
    private var dateChangedReceiver: BroadcastReceiver? = null
    private var refreshStepSensorReceiver: BroadcastReceiver? = null
    private var sensorThread: HandlerThread? = null
    private val notiHelper: NotiHelper by lazy { NotiHelper(this) }
    private val phrRepo: PhrRepo by lazy { PhrRepo.getInstance(this) }
    private var livedataListStepCnt: LiveData<Long?>? = null
    private var prevStepCnt: Float? = null
    private val addStepMutex = Mutex()
    private var lastScreenOn = false
    private var screenReceiver: BroadcastReceiver? = null
    private var powerManager: PowerManager? = null
    private var keyguardManager: KeyguardManager? = null
    private var isGranted = true

    override fun onBind(intent: Intent): IBinder? {
        super.onBind(intent)
        return null
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        super.onStartCommand(intent, flags, startId)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) initForegroundService()
        initReceiver()
        if (availableStepSensor()) initSensor()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            isGranted = checkStepIsGranted()
        }

        return START_STICKY
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    private fun checkStepIsGranted(): Boolean = ContextCompat.checkSelfPermission(
        this,
        Manifest.permission.ACTIVITY_RECOGNITION
    ) == PackageManager.PERMISSION_GRANTED

    private fun availableStepSensor(): Boolean {
        return packageManager.hasSystemFeature(PackageManager.FEATURE_SENSOR_STEP_COUNTER)
    }

    private fun initReceiver() {
        dateChangedReceiver = DateChangedReceiver()
        registerReceiver(dateChangedReceiver, IntentFilter(Intent.ACTION_DATE_CHANGED))

        powerManager = getSystemService(POWER_SERVICE) as? PowerManager
        keyguardManager = getSystemService(KEYGUARD_SERVICE) as? KeyguardManager
        screenReceiver = ScreenReceiver()
        registerReceiver(screenReceiver, IntentFilter().apply {
            addAction(Intent.ACTION_USER_PRESENT)
            addAction(Intent.ACTION_SCREEN_OFF)
            addAction(Intent.ACTION_SCREEN_ON)
        })

        refreshStepSensorReceiver = RefreshStepSensorReceiver()
        LocalBroadcastManager.getInstance(applicationContext).registerReceiver(
            refreshStepSensorReceiver!!,
            IntentFilter(ACTION_REFRESH_STEP_SENSOR)
        )

        val restartStepServiceBR = RestartStepServiceReceiver()
        applicationContext.registerReceiver(restartStepServiceBR, IntentFilter().apply {
            addAction(Intent.ACTION_MY_PACKAGE_REPLACED)
            addAction(Intent.ACTION_BOOT_COMPLETED)
        })
    }

    private fun initSensor() {
        sensorThread?.quit()
        val sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        val stepCounter = sensorManager.getDefaultSensor(Sensor.TYPE_STEP_COUNTER)

        sensorThread = HandlerThread("SensorThread").also {
            it.start()
            sensorManager.registerListener(
                this,
                stepCounter,
                SensorManager.SENSOR_DELAY_NORMAL,
                Handler(it.looper)
            )
        }
    }

    private fun initForegroundService() {
        startForeground(
            NotiHelper.NOTIFICATION_ID_STEP,
            makeNotification(getString(R.string.format_step, 0))?.build()
        )
        resetUpdateNotification(this)
    }

    private fun resetUpdateNotification(context: Context) = CoroutineScope(Dispatchers.Main).launch {
        val curStepCnt = phrRepo.getTodayStepCnt()
        if (ActivityCompat.checkSelfPermission(
                context,
                Manifest.permission.POST_NOTIFICATIONS
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            notiHelper.notify(
                NotiHelper.NOTIFICATION_ID_STEP,
                makeNotification(getString(R.string.format_step, curStepCnt))
            )
        }


        livedataListStepCnt?.removeObservers(this@StepService)
        livedataListStepCnt = phrRepo.getTodayStepCntLD()
        livedataListStepCnt!!.observe(this@StepService) { cntSum ->
            notiHelper.notify(
                NotiHelper.NOTIFICATION_ID_STEP,
                makeNotification(getString(R.string.format_step, cntSum ?: 0))
            )
        }
    }

    private fun makeNotification(titleText: String): NotificationCompat.Builder? {
        val intent = Intent(applicationContext, MainActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
//            data = Uri.parse(getString(R.string.deeplink_step))
            putExtra(EXTRA_NAME_STEP_NOTIFICATION, EXTRA_VALUE_STEP_NOTIFICATION)
        }

        val flag = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }

        val pendingIntent: PendingIntent =
            PendingIntent.getActivity(
                applicationContext,
                NotiHelper.NOTI_PENDING_STEP,
                intent,
                flag
            )

        return notiHelper.getBaseNotificationBuilder(
            channelId = NotiChannel.STEP.id,
            title = if (isGranted) titleText else "권한 필요",
//            body =
//            if (isGranted) getString(R.string.step_service_msg_body, 6000)
//            else "걸음 수를 측정하도록 권한을 허용하려면 누르세요.",
            body = "오늘의 걸음 수",
            isNotSilent = false,
            icon = getBitmapFromVectorDrawable(applicationContext, R.drawable.ic_icon),
            priority = NotificationCompat.PRIORITY_HIGH
        ).apply {
            this.setContentIntent(pendingIntent)
            this.setOnlyAlertOnce(true)
            this.setShowWhen(false)
            this.setOngoing(true)
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}

    override fun onSensorChanged(event: SensorEvent) {
        CoroutineScope(Dispatchers.IO).launch {
            addStepMutex.withLock {
                if (prevStepCnt == null) {
                    prevStepCnt = event.values[0]
                } else {
                    val addedCnt = (event.values[0] - prevStepCnt!!).toLong()
                    prevStepCnt = event.values[0]
                    if (addedCnt <= 0) return@launch

                    phrRepo.addStep(addedCnt)
                    phrRepo.insertMotion(addedCnt)
                }

                LocalBroadcastManager.getInstance(applicationContext).sendBroadcast(Intent(PhrChannel.ACTION_SEND_TODAY_STEP_CNT))
            }
        }
    }

    override fun onDestroy() {
        livedataListStepCnt?.removeObservers(this@StepService)
        notiHelper.cancel(NotiHelper.NOTIFICATION_ID_STEP)
        stopService()
        super.onDestroy()
    }

    private fun stopService() {
        if (availableStepSensor()) sensorThread?.quit()
        dateChangedReceiver?.let { unregisterReceiver(it) }
        screenReceiver?.let { unregisterReceiver(it) }
        refreshStepSensorReceiver?.let {
            LocalBroadcastManager.getInstance(applicationContext).unregisterReceiver(it)
        }
        livedataListStepCnt?.removeObservers(this)
    }

    inner class DateChangedReceiver : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                resetUpdateNotification(context)
            }
        }
    }

    inner class RefreshStepSensorReceiver : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            Log.d(tag, "RefreshStepSensorReceiver onReceive")
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                val newIsGranted = checkStepIsGranted()
                if (isGranted != newIsGranted) {
                    isGranted = newIsGranted
                    initSensor()
                    resetUpdateNotification(context)
                }
            }
        }
    }

    inner class ScreenReceiver : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            CoroutineScope(Dispatchers.IO).launch {
                val isLock = keyguardManager?.isKeyguardLocked ?: false

                when (intent.action) {
                    Intent.ACTION_USER_PRESENT -> {
                        Log.d(tag, "ACTION_USER_PRESENT")
                        if (!isLock) {
                            val isScreenOn = powerManager?.isInteractive ?: true
                            if (isScreenOn || lastScreenOn) {
                                phrRepo.insertScreen(ScreenType.ON)
                                lastScreenOn = isScreenOn
                            }
                        } else {
                            phrRepo.insertScreen(ScreenType.SEMI_ON)
                        }
                    }
                    Intent.ACTION_SCREEN_ON -> {
                        Log.d(tag, "ACTION_SCREEN_ON")
                        if (!isLock) phrRepo.insertScreen(ScreenType.ON)
                        else phrRepo.insertScreen(ScreenType.SEMI_ON)
                        lastScreenOn = true
                    }
                    Intent.ACTION_SCREEN_OFF -> {
                        Log.d(tag, "ACTION_SCREEN_OFF")
                        phrRepo.insertScreen(ScreenType.OFF)
                        lastScreenOn = false
                    }
                }
            }
        }
    }

    companion object {
        const val ACTION_REFRESH_STEP_SENSOR = "ACTION_REFRESH_STEP_SENSOR"
        const val EXTRA_NAME_STEP_NOTIFICATION = "type"
        const val EXTRA_VALUE_STEP_NOTIFICATION = "stepNotification"
    }
}
