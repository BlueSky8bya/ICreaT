package com.gachon_HCI_Lab.user_mobile.common

import android.content.Context
import android.os.Environment
import android.util.Log
import com.gachon_HCI_Lab.user_mobile.sensor.model.AbstractSensor
import com.gachon_HCI_Lab.user_mobile.sensor.model.OneAxisData
import com.gachon_HCI_Lab.user_mobile.sensor.model.ThreeAxisData
import com.opencsv.CSVWriter
import java.io.*
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.TimeZone

object CsvController {
    private const val TAG = "CsvController"

    // DCT 전용 데이터 루트. 원본 앱(sensor_data)과 분리해 폴더 공유로 인한
    // 파일 소유권 충돌(로그 append 실패)·데이터 교차오염을 방지.
    const val ROOT_DIR = "sensor_data_DCT"

    // 앱 컨텍스트. 로그를 앱 전용 외부저장(getExternalFilesDir)에 쓰기 위해 필요.
    // ApplicationCrashService.onCreate()에서 init()으로 주입한다.
    private var appContext: Context? = null

    fun init(context: Context) {
        appContext = context.applicationContext
    }

    // 로그/파일명 시각은 기기 시간대와 무관하게 항상 한국시간(KST)으로 기록.
    // 주의: 서버 전송 timestamp는 epoch(System.currentTimeMillis)라 시간대 영향 없음 — 별개.
    val KST: TimeZone = TimeZone.getTimeZone("Asia/Seoul")

    // KST 고정 SimpleDateFormat 생성 헬퍼.
    fun kstFormat(pattern: String): SimpleDateFormat =
        SimpleDateFormat(pattern, Locale.getDefault()).apply { timeZone = KST }

    /**
     * 앱의 주요 이벤트나 에러를 파일로 남기는 함수
     */
    fun writeLog(message: String) {
        try {
            // 로그는 앱 전용 외부저장(/Android/data/<pkg>/files/logs)에 저장.
            // MediaStore 색인을 타지 않아 수동 폴더 삭제로 인한 색인 desync/EEXIST가 없다.
            // appContext 미주입(초기화 전) 시에만 기존 Download 경로로 폴백.
            val base = appContext?.getExternalFilesDir(null) ?: File(getDownloadPath(), ROOT_DIR)
            val logDir = File(base, "logs")

            if (!logDir.exists()) {
                val created = logDir.mkdirs()
                if (!created) {
                    Log.e(TAG, "Log directory creation failed")
                    return
                }
            }

            val sdf = kstFormat("yyyy-MM-dd HH:mm:ss")
            val timestamp = sdf.format(Date())

            // [수정] 로그 파일명 날짜 포맷도 yyMMdd로 통일 (예: app_debug_log_260319.txt)
            val dateStr = kstFormat("yyMMdd").format(Date())
            val fileName = "app_debug_log_${dateStr}.txt"
            val logFile = File(logDir, fileName)

            FileWriter(logFile, true).buffered().use { writer ->
                writer.appendLine("[$timestamp] $message")
            }
        } catch (e: Exception) {
            Log.e(TAG, "CRITICAL: Log file write failed: ${e.message}", e)
        }
    }

    // [2026-06-29] 워치 배터리 로컬 타임라인 기록용 상태.
    private var lastLoggedBattery: Int? = null
    private var lastBatteryLogTime: Long = 0L
    private const val BATTERY_HEARTBEAT_MS = 10 * 60 * 1000L // 값 정체 시에도 10분마다 1줄

    /**
     * [2026-06-29] 워치 배터리를 전용 CSV에 고해상도로 기록한다.
     * 이유: 서버 전송은 30분 단위라 텀이 길고, 디버그 로그에 묻혀 가독성이 낮음.
     * 목적: Downloads/sensor_data_DCT/battery/watch_battery_YYMMDD.csv 에 timestamp,battery 타임라인 적재.
     * 효율: 값이 바뀔 때만(또는 10분 정체 시 1줄) 기록 → 파일 작고 읽기 쉬움.
     */
    fun logBattery(battery: Int) {
        if (battery < 0 || battery > 100) return // 비정상값(scale=-1 등) 제외
        val now = System.currentTimeMillis()
        val changed = battery != lastLoggedBattery
        val heartbeat = now - lastBatteryLogTime >= BATTERY_HEARTBEAT_MS
        if (!changed && !heartbeat) return
        try {
            val dir = File(getDownloadPath(), "$ROOT_DIR/battery")
            if (!dir.exists() && !dir.mkdirs()) {
                Log.e(TAG, "battery dir creation failed")
                return
            }
            val dateStr = kstFormat("yyMMdd").format(Date())
            val file = File(dir, "watch_battery_${dateStr}.csv")
            val isNew = !file.exists()
            val ts = kstFormat("yyyy-MM-dd HH:mm:ss").format(Date())
            FileWriter(file, true).buffered().use { writer ->
                if (isNew) writer.appendLine("timestamp,battery")
                writer.appendLine("$ts,$battery")
            }
            lastLoggedBattery = battery
            lastBatteryLogTime = now
        } catch (e: Exception) {
            Log.e(TAG, "battery log write failed: ${e.message}", e)
        }
    }

    fun getDownloadPath(): File {
        return Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
    }

    fun getSensorDirectory(sensorName: String): File {
        val sensorType = sensorName.split("_").getOrNull(0) ?: "Unknown"
        val basePath = getDownloadPath()
        val sensorDataDir = File(basePath, ROOT_DIR)
        if (!sensorDataDir.exists()) sensorDataDir.mkdirs()

        val dir = File(sensorDataDir, sensorType)
        if (!dir.exists()) {
            dir.mkdirs()
            writeLog("DIRECTORY_CREATED: $sensorType")
        }
        return dir
    }

    /**
     * 파편 파일명 생성 로직
     * yyyyMMdd -> yyMMdd로 변경하여 병합 로직과 일관성 유지
     * (예: Accelerometer_260319_204501.csv)
     */
    private fun setFileName(sensorName: String): String {
        val sdf = kstFormat("yyMMdd_HHmmss")
        val date = sdf.format(Date())
        return "${sensorName}_${date}.csv"
    }

    fun csvSave(sensorName: String, abstractSensorSet: List<AbstractSensor>) {
        val sensorFolder = getSensorDirectory(sensorName)
        val fileName = setFileName(sensorName)
        val file = File(sensorFolder, fileName)

        val headerData = when {
            abstractSensorSet.all { it is OneAxisData } -> arrayOf("time", "value")
            abstractSensorSet.all { it is ThreeAxisData } -> arrayOf("time", "x", "y", "z")
            else -> arrayOf("time", "value")
        }

        try {
            // UTF-8 BOM 추가 없이 순수 UTF-8로 저장 (분석 툴 호환성 고려)
            val writer = CSVWriter(BufferedWriter(OutputStreamWriter(FileOutputStream(file, true), "UTF-8")))

            writer.use { w ->
                if (file.length() == 0L) {
                    w.writeNext(headerData)
                }

                for (sensor in abstractSensorSet) {
                    w.writeNext(convertSensorToStringArray(sensor))
                }
                w.flush()
            }
        } catch (e: Exception) {
            Log.e(TAG, "CSV 저장 실패: ${e.message}")
            writeLog("ERROR: CSV 저장 실패 ($sensorName) - ${e.message}")
        }
    }

    private fun convertSensorToStringArray(abstractSensor: AbstractSensor): Array<String> {
        val time = abstractSensor.time.toString()
        return when (abstractSensor) {
            is OneAxisData -> arrayOf(time, abstractSensor.value.toString())
            is ThreeAxisData -> arrayOf(time, abstractSensor.xValue.toString(), abstractSensor.yValue.toString(), abstractSensor.zValue.toString())
            else -> emptyArray()
        }
    }
}