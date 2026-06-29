package com.gachon_HCI_Lab.wear_os_sensor

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
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

        // [2026-06-30] 이유: 첫 실행에 권한을 따로 묻고 일시중지·배터리 설정은 앱 목록을 수동으로 들어가야 했음.
        // 목적: 런타임 권한을 한 번에 요청. 시스템 설정 유도(앱 일시중지 해제·배터리 최적화 제외)는 onCreate 동기 경로에서 startActivity 하면 첫 프레임 전에 화면이 튀어 스플래시가 멈추므로, 첫 프레임이 그려진 뒤(decorView.post) 또는 권한 콜백에서 띄운다.
        val pendingPermissions = requestAllPermissions()
        if (pendingPermissions == 0) {
            window.decorView.post { guideSystemSettingsOnce() }
        }
    }

    /**
     * [2026-06-30] 런타임 권한을 한 번에 묶어 요청한다. 반환값 = 이번에 요청한 권한 수(0이면 모두 허용 상태).
     */
    private fun requestAllPermissions(): Int {
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
        return toRequest.size
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == ALL_PERMISSIONS_REQUEST_CODE) {
            // 권한 처리 끝난 뒤에 시스템 설정 안내를 띄워야 화면이 겹치지 않음.
            guideSystemSettingsOnce()
        }
    }

    /**
     * [2026-06-30] 시스템 설정 유도(자동 토글은 OS상 불가, 안내 인텐트만). 1회만 실행.
     * - 배터리 최적화 제외: 백그라운드에서 앱이 죽지 않도록.
     * - 미사용 시 앱 일시중지(자동 권한 회수) 해제: 장기 측정 중 권한이 회수되지 않도록.
     * 삼성 헬스 플랫폼 [Dev mode]는 삼성 시스템 토글이라 API가 없어 수동으로 남는다.
     */
    private fun guideSystemSettingsOnce() {
        val prefs = getSharedPreferences("wear_setup", MODE_PRIVATE)
        if (prefs.getBoolean("system_guide_shown", false)) return
        prefs.edit().putBoolean("system_guide_shown", true).apply()

        // 미사용 시 앱 일시중지(자동 권한 회수) 해제 안내 (Android 11+)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            try {
                startActivity(Intent(Intent.ACTION_AUTO_REVOKE_PERMISSIONS).apply {
                    data = Uri.parse("package:$packageName")
                })
            } catch (e: Exception) {
                Log.w("MainActivity", "auto-revoke intent failed: ${e.message}")
            }
        }

        // 배터리 최적화 제외 요청
        try {
            startActivity(Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
                data = Uri.parse("package:$packageName")
            })
        } catch (e: Exception) {
            Log.w("MainActivity", "battery optimization intent failed: ${e.message}")
        }
    }

    inner class ExceptionHandler : Thread.UncaughtExceptionHandler {
        override fun uncaughtException(p0: Thread?, p1: Throwable?) {
            Log.d("Exception", "비정상 종료")
            p1?.printStackTrace()
        }
    }
}
