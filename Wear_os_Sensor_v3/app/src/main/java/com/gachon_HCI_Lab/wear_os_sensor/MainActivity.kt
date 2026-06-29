package com.gachon_HCI_Lab.wear_os_sensor

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import com.example.wear_os_sensor_v2.R
import com.gachon_HCI_Lab.wear_os_sensor.util.step.Permissions
import com.gachon_HCI_Lab.wear_os_sensor.util.step.StepsReader
import com.gachon_HCI_Lab.wear_os_sensor.util.step.StepsReaderUtil
import com.google.android.libraries.healthdata.HealthDataService

class MainActivity : AppCompatActivity() {
    private val ALL_PERMISSIONS_REQUEST_CODE = 1100

    override fun onCreate(savedInstanceState: Bundle?) {
        installSplashScreen()
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        Thread.setDefaultUncaughtExceptionHandler(ExceptionHandler())

        // [2026-06-30] 이유: 기존엔 ConnectFragment를 서비스가 foreground 실행 중일 때만 추가해, 첫 실행 시 버튼 화면이 안 뜨고 터치도 안 됐음.
        // 목적: 콜드 스타트에 항상 ConnectFragment를 먼저 표시(첫 프레임을 그려 스플래시가 닫히도록). ConnectFragment가 서비스 상태를 보고 Start/Stop을 스스로 결정함.
        if (savedInstanceState == null) {
            supportFragmentManager.beginTransaction()
                .replace(R.id.fragment_container, ConnectFragment())
                .commit()
        }

        // 헬스 클라이언트 초기화(걸음 데이터). 어떤 실패든 앱 진입을 막지 않도록 모든 예외를 삼킨다.
        try {
            val healthDataClient = HealthDataService.getClient(this)
            StepsReaderUtil.addContext(this)
            StepsReader.addHealthDataClient(healthDataClient)
            Permissions.addHealthDataClietn(healthDataClient)
            StepsReaderUtil.readStepsWithPermissionsCheck()
            if (!HealthDataService.isHealthDataApiSupported()) {
                Toast.makeText(
                    this,
                    "Health Platform not available, make sure you're on Samsung device running Android Watch 4 and above",
                    Toast.LENGTH_LONG
                ).show()
            }
        } catch (e: Exception) {
            Log.e("MainActivity", "Health client init failed: ${e.message}")
        }

        // [2026-06-30] 런타임 권한(센서/활동/BT/알림)을 첫 실행에 한 번에 요청해, 앱 목록을 수동으로 들어가지 않아도 되게 한다.
        // 주의: 배터리 최적화·앱 일시중지 등 '시스템 설정 화면'을 onCreate/권한콜백에서 startActivity로 자동 실행하면
        //       Wear OS에서 엉뚱한 설정 화면으로 라우팅되거나 첫 진입을 깨뜨려, 자동 실행은 하지 않는다(필요 시 수동 안내).
        requestAllPermissions()
    }

    /**
     * [2026-06-30] 런타임 권한을 한 번에 묶어 요청한다.
     */
    private fun requestAllPermissions() {
        val needed = mutableListOf(
            Manifest.permission.BODY_SENSORS,
            Manifest.permission.ACTIVITY_RECOGNITION,
            Manifest.permission.BLUETOOTH_CONNECT,
            Manifest.permission.BLUETOOTH_SCAN
        )
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            needed.add(Manifest.permission.POST_NOTIFICATIONS)
        }
        val toRequest = needed.filter {
            ContextCompat.checkSelfPermission(this, it) != PackageManager.PERMISSION_GRANTED
        }
        if (toRequest.isNotEmpty()) {
            ActivityCompat.requestPermissions(this, toRequest.toTypedArray(), ALL_PERMISSIONS_REQUEST_CODE)
        }
    }

    inner class ExceptionHandler : Thread.UncaughtExceptionHandler {
        override fun uncaughtException(p0: Thread?, p1: Throwable?) {
            Log.d("Exception", "비정상 종료")
            p1?.printStackTrace()
        }
    }
}
