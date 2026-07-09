package com.gachon_HCI_Lab.user_mobile.activity

import android.Manifest
import android.annotation.SuppressLint
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.PowerManager
import android.provider.Settings
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.gachon_HCI_Lab.user_mobile.common.BTManager
import com.gachon_HCI_Lab.user_mobile.common.CacheManager
import com.gachon_HCI_Lab.user_mobile.common.ServerConnection
import com.gachon_HCI_Lab.user_mobile.databinding.ActivityLoginBinding
import androidx.core.net.toUri
import androidx.core.content.edit
import com.journeyapps.barcodescanner.ScanContract
import com.journeyapps.barcodescanner.ScanOptions
import org.json.JSONObject

class LoginActivity : AppCompatActivity() {
    private lateinit var binding: ActivityLoginBinding
    private var isShowingDialog = false
    private val PREFS_NAME = "AppSetupPrefs"

    // [2026-07-09] 이유: QR 로그인 Phase 1 — 하드코딩 대신 QR 스캔으로 대상자 매칭. | 목적: 스캔/캐시로 확보한 studyId/subjectId를 진입 시 전달.
    private var studyId: String? = null
    private var subjectId: String? = null
    private var patName: String? = null

    // zxing 스캔 런처. CaptureActivity가 CAMERA 런타임 권한 요청을 자체 처리한다.
    private val qrScanLauncher = registerForActivityResult(ScanContract()) { result ->
        result.contents?.let { handleQrResult(it) }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityLoginBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // 직전 스캔 결과 복원 (enterSensor가 "studyId|subjectId"로 저장한 캐시) → 셋업 완료 후 자동 로그인
        CacheManager.loadCacheFile(this, "login.txt")?.split("|")?.let {
            if (it.size == 2 && it[0].isNotBlank() && it[1].isNotBlank()) {
                studyId = it[0]
                subjectId = it[1]
            }
        }
    }

    override fun onResume() {
        super.onResume()
        if (isShowingDialog) return

        val pm = getSystemService(POWER_SERVICE) as PowerManager
        val isBatteryOptimized = pm.isIgnoringBatteryOptimizations(packageName)
        val prefs = getSharedPreferences(PREFS_NAME, MODE_PRIVATE)
        val isHibernationGuideShown = prefs.getBoolean("hibernation_shown", false)

        // [순차적 가이드 로직] - 앞 단계가 완료되지 않으면 절대 뒤로 넘어가지 않음
        when {
            // [1단계] 배터리 최적화 제외 설정
            !isBatteryOptimized -> {
                showBatteryOptimizationDialog()
            }
            // [2단계] 사용하지 않는 앱 관리 (1회만 유도)
            !isHibernationGuideShown -> {
                showAppHibernationDialog()
            }
            // [3단계] 필수 시스템 권한 (위치, 블루투스 등) 일괄 요청
            !hasRequiredPermissions() -> {
                requestRequiredPermissions()
            }
            // [4단계] 모든 세팅 완료 -> 기기 ID 획득 및 로그인 활성화
            else -> {
                val deviceID = fetchDeviceID()
                setupLoginLogic(deviceID)
            }
        }
    }

    private fun hasRequiredPermissions(): Boolean {
        val permissions = mutableListOf(
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.ACCESS_COARSE_LOCATION
        )
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            permissions.add(Manifest.permission.BLUETOOTH_CONNECT)
            permissions.add(Manifest.permission.BLUETOOTH_SCAN)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            permissions.add(Manifest.permission.POST_NOTIFICATIONS)
        }
        return permissions.all {
            ContextCompat.checkSelfPermission(this, it) == PackageManager.PERMISSION_GRANTED
        }
    }

    private fun requestRequiredPermissions() {
        val permissions = mutableListOf(
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.ACCESS_COARSE_LOCATION
        )
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            permissions.add(Manifest.permission.BLUETOOTH_CONNECT)
            permissions.add(Manifest.permission.BLUETOOTH_SCAN)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            permissions.add(Manifest.permission.POST_NOTIFICATIONS)
        }
        ActivityCompat.requestPermissions(this, permissions.toTypedArray(), 100)
    }

    @SuppressLint("BatteryLife")
    private fun showBatteryOptimizationDialog() {
        isShowingDialog = true
        AlertDialog.Builder(this)
            .setTitle("연결 무중단 설정")
            .setMessage("정교한 데이터 수집을 위해 시스템의 배터리 최적화 제외가 필요합니다.\n\n이어지는 시스템 안내 팝업에서 반드시 '허용'을 눌러주세요.")
            .setPositiveButton("설정하기") { _, _ ->
                isShowingDialog = false
                try {
                    val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
                        data = "package:$packageName".toUri()
                    }
                    startActivity(intent)
                } catch (_: Exception) {
                    val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                        data = "package:$packageName".toUri()
                    }
                    startActivity(intent)
                }
            }
            .setCancelable(false)
            .show()
    }

    private fun showAppHibernationDialog() {
        isShowingDialog = true
        AlertDialog.Builder(this)
            .setTitle("장기 수집 안정화")
            .setMessage("앱을 열지 않는 시간에도 권한이 취소되지 않도록 설정합니다.\n\n화면 하단의 '사용하지 않는 앱 관리' 항목을 비활성화(OFF)해 주세요.")
            .setPositiveButton("이동하기") { _, _ ->
                isShowingDialog = false

                // [핵심] 설정창으로 보냈다는 기록을 남김 (다시 안 띄우기 위해)
                getSharedPreferences(PREFS_NAME, MODE_PRIVATE)
                    .edit { putBoolean("hibernation_shown", true) }

                val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                    data = Uri.fromParts("package", packageName, null)
                }
                startActivity(intent)

                // [삭제됨] 여기서 겹침을 유발하던 ServerConnection.login 삭제!
            }
            .setCancelable(false)
            .show()
    }

    private fun setupLoginLogic(deviceID: String) {
        // 베데스다 무인증(a) 정책: 별도 로그인 API가 없으므로 네트워크 로그인 없이 진입한다.
        // [2026-07-09] 이유: 시작 버튼 별도 조작은 불필요한 단계. | 목적: 캐시 있으면 즉시 자동 로그인, 없으면 QR 스캔 성공 즉시 자동 로그인 — 화면엔 QR 버튼만.
        val sId = studyId
        val subId = subjectId
        if (!sId.isNullOrBlank() && !subId.isNullOrBlank()) {
            binding.tvScanResult.text = "Study $sId / Subject $subId — 자동 로그인"
            ServerConnection.enterSensor(deviceID = deviceID, studyId = sId, subjectId = subId, context = this)
            return
        }
        binding.qrScanBtn.setOnClickListener {
            launchQrScan()
        }
    }

    private fun launchQrScan() {
        val options = ScanOptions().apply {
            setDesiredBarcodeFormats(ScanOptions.QR_CODE)
            setPrompt("iCReaT 대상자 QR을 스캔하세요")
            setBeepEnabled(false)
            setOrientationLocked(true)
            // [2026-07-09] 이유: zxing 기본 CaptureActivity는 가로 고정. | 목적: 세로 고정 스캔 화면 사용.
            setCaptureActivity(PortraitCaptureActivity::class.java)
        }
        qrScanLauncher.launch(options)
    }

    /**
     * QR 내용 파싱. pbcr(iCReaT DCT)과 동일 JSON 규격 공유:
     * { "stdy_no": Study ID, "subject_id": Subject ID, "organ_cd": 기관코드, "pat_name": 대상자명 }
     * 비-JSON/필드 누락 QR은 무시(토스트만). pat_name은 화면 표시용으로만 쓰고 저장하지 않는다.
     * [2026-07-09] 스캔 성공 시 별도 버튼 없이 즉시 자동 로그인(enterSensor).
     */
    private fun handleQrResult(contents: String) {
        try {
            val json = JSONObject(contents)
            val scannedStudyId = json.getString("stdy_no")
            val scannedSubjectId = json.getString("subject_id")
            if (scannedStudyId.isBlank() || scannedSubjectId.isBlank()) {
                throw IllegalArgumentException("empty id field")
            }
            studyId = scannedStudyId
            subjectId = scannedSubjectId
            patName = json.optString("pat_name", "")

            val nameSuffix = patName?.takeIf { it.isNotBlank() }?.let { " ($it)" } ?: ""
            binding.tvScanResult.text = "Study $scannedStudyId / Subject $scannedSubjectId$nameSuffix — 자동 로그인"
            ServerConnection.enterSensor(
                deviceID = fetchDeviceID(),
                studyId = scannedStudyId,
                subjectId = scannedSubjectId,
                context = this
            )
        } catch (_: Exception) {
            Toast.makeText(this, "iCReaT 대상자 QR이 아닙니다", Toast.LENGTH_SHORT).show()
        }
    }

    private fun fetchDeviceID(): String {
        val connectedDevices = BTManager.connectedDevices(this)
        val connectedDevice = BTManager.getConnectedDevice(this, connectedDevices)
        return BTManager.getUUID(this, connectedDevice)
    }
}