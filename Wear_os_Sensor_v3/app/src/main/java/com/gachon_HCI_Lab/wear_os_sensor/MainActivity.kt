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
import androidx.core.content.IntentCompat
import androidx.core.content.PackageManagerCompat
import androidx.core.content.UnusedAppRestrictionsConstants
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import com.example.wear_os_sensor_v2.R
import com.gachon_HCI_Lab.wear_os_sensor.util.step.Permissions
import com.gachon_HCI_Lab.wear_os_sensor.util.step.StepsReader
import com.gachon_HCI_Lab.wear_os_sensor.util.step.StepsReaderUtil
import com.google.android.libraries.healthdata.HealthDataService

class MainActivity : AppCompatActivity() {
    private val ALL_PERMISSIONS_REQUEST_CODE = 1100

    override fun onCreate(savedInstanceState: Bundle?) {
        // [2026-06-30] 이유: 이전 시도(설정 자동실행)가 진입을 깨졌을 때 log.txt로 원인을 짚기 어려웠음 → startup 전 구간에 로그 삽입.
        // 목적: 각 단계가 어디까지 진행됐는지 logcat에서 추적 가능하게 함. 크래시 시 ExceptionHandler가 full stacktrace를 같은 태그로 남김.
        Log.i(TAG, "onCreate: start (savedInstanceState=${savedInstanceState != null})")

        // [2026-06-30] 이유: 우리 핸들러가 기존 기본 핸들러를 삼켜버려 logcat에 깔끔한 FATAL 스택이 안 남던 문제 +
        //   override 시그니처 nullability 경고. | 목적: full stacktrace를 우리 태그로 남기고, 기존 기본 핸들러로 체이닝해 정상 크래시 처리.
        val defaultHandler = Thread.getDefaultUncaughtExceptionHandler()
        Thread.setDefaultUncaughtExceptionHandler(ExceptionHandler(defaultHandler))

        installSplashScreen()
        Log.i(TAG, "onCreate: splash installed")
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        Log.i(TAG, "onCreate: setContentView done")

        // [2026-06-30] 이유: 기존엔 ConnectFragment를 서비스가 foreground 실행 중일 때만 추가해, 첫 실행 시 버튼 화면이 안 뜨고 터치도 안 됐음.
        // 목적: 콜드 스타트에 항상 ConnectFragment를 먼저 표시(첫 프레임을 그려 스플래시가 닫히도록). ConnectFragment가 서비스 상태를 보고 Start/Stop을 스스로 결정함.
        if (savedInstanceState == null) {
            supportFragmentManager.beginTransaction()
                .replace(R.id.fragment_container, ConnectFragment())
                .commit()
            Log.i(TAG, "onCreate: ConnectFragment committed")
        }

        // 헬스 클라이언트 초기화(걸음 데이터). 어떤 실패든 앱 진입을 막지 않도록 모든 예외를 삼킨다.
        try {
            Log.i(TAG, "onCreate: health init begin")
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
            Log.i(TAG, "onCreate: health init end")
        } catch (e: Exception) {
            Log.e(TAG, "onCreate: health init failed", e)
        }

        // [2026-06-30] 런타임 권한(센서/활동/BT/알림)을 첫 실행에 한 번에 요청한다.
        val requested = requestAllPermissions()
        Log.i(TAG, "onCreate: requestAllPermissions requested=$requested")

        // [2026-06-30] 이유: '사용하지 않을 때 앱 활동 일시정지(app hibernation)' 해제를 앱 진입 시 유도(2번 방식 재시도).
        //   과거 onCreate 동기 실행이 첫 프레임 전에 설정으로 튀어 스플래시 멈춤을 유발했음.
        // 목적: ① 권한을 요청했으면 그 콜백 후에, ② 요청할 게 없었으면 첫 프레임 그린 뒤(decorView.post)로 지연 실행해 스플래시를 막지 않음.
        if (!requested) {
            window.decorView.post {
                Log.i(TAG, "onCreate: no permission request -> guide via decorView.post")
                guideUnusedAppRestrictions()
            }
        }
        Log.i(TAG, "onCreate: end")
    }

    /**
     * [2026-06-30] 런타임 권한을 한 번에 묶어 요청한다. 실제로 요청 다이얼로그를 띄웠으면 true.
     */
    private fun requestAllPermissions(): Boolean {
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
        Log.i(TAG, "requestAllPermissions: toRequest=$toRequest")
        if (toRequest.isNotEmpty()) {
            ActivityCompat.requestPermissions(this, toRequest.toTypedArray(), ALL_PERMISSIONS_REQUEST_CODE)
            return true
        }
        return false
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode != ALL_PERMISSIONS_REQUEST_CODE) return
        // [2026-06-30] 각 권한 허용/거부 결과를 로그로 남겨, 권한 미허용에서 비롯된 후속 크래시를 추적 가능하게 함.
        permissions.forEachIndexed { i, p ->
            val granted = grantResults.getOrNull(i) == PackageManager.PERMISSION_GRANTED
            Log.i(TAG, "onRequestPermissionsResult: $p granted=$granted")
        }
        Log.i(TAG, "onRequestPermissionsResult: guiding unused-app-restrictions after permission flow")
        guideUnusedAppRestrictions()
    }

    /**
     * [2026-06-30] '사용하지 않을 때 앱 활동 일시정지(unused app restrictions / app hibernation)' 해제를 안내한다.
     * - raw 인텐트(ACTION_AUTO_REVOKE_PERMISSIONS) 직접 사용 시 Wear OS에서 엉뚱한 화면으로 라우팅 → AndroidX 헬퍼로 위임.
     * - getUnusedAppRestrictionsStatus로 상태를 먼저 확인해, 이미 꺼져 있거나 미지원이면 설정 화면을 띄우지 않는다.
     * - 모든 단계에 로그를 남기고, 어떤 실패든 try/catch로 삼켜 앱 진입을 막지 않는다.
     */
    private fun guideUnusedAppRestrictions() {
        Log.i(TAG, "guideUnusedAppRestrictions: enter")
        try {
            val future = PackageManagerCompat.getUnusedAppRestrictionsStatus(this)
            future.addListener({
                try {
                    val status = future.get()
                    Log.i(TAG, "guideUnusedAppRestrictions: status=$status")
                    when (status) {
                        UnusedAppRestrictionsConstants.ERROR ->
                            Log.w(TAG, "guideUnusedAppRestrictions: ERROR (상태 확인 실패)")
                        UnusedAppRestrictionsConstants.FEATURE_NOT_AVAILABLE ->
                            Log.i(TAG, "guideUnusedAppRestrictions: 기기 미지원 - 안내 생략")
                        UnusedAppRestrictionsConstants.DISABLED ->
                            Log.i(TAG, "guideUnusedAppRestrictions: 이미 해제됨 - 안내 불필요")
                        else -> {
                            // API_30_BACKPORT / API_30 / API_31 = 제한이 켜져 있음 → 해제 설정 화면으로 유도
                            Log.i(TAG, "guideUnusedAppRestrictions: ENABLED($status) - 설정 화면 실행")
                            val intent = IntentCompat.createManageUnusedAppRestrictionsIntent(this, packageName)
                            startActivity(intent)
                            Log.i(TAG, "guideUnusedAppRestrictions: startActivity OK")
                        }
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "guideUnusedAppRestrictions: 콜백 처리 실패", e)
                }
            }, ContextCompat.getMainExecutor(this))
        } catch (e: Exception) {
            Log.e(TAG, "guideUnusedAppRestrictions: 상태 조회 실패", e)
        }
    }

    // [2026-06-30] 기존 기본 핸들러로 체이닝해 정상 크래시 처리를 유지하면서, full stacktrace를 우리 태그로 logcat에 남긴다.
    inner class ExceptionHandler(
        private val defaultHandler: Thread.UncaughtExceptionHandler?
    ) : Thread.UncaughtExceptionHandler {
        override fun uncaughtException(t: Thread, e: Throwable) {
            Log.e(TAG, "UNCAUGHT EXCEPTION in thread '${t.name}'", e)
            defaultHandler?.uncaughtException(t, e)
        }
    }

    companion object {
        private const val TAG = "WearStartup"
    }
}
