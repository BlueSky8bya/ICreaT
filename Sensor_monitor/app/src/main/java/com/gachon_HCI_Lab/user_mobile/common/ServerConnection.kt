package com.gachon_HCI_Lab.user_mobile.common

import android.app.Activity
import android.content.Intent
import android.util.Log
import com.gachon_HCI_Lab.user_mobile.activity.SensorActivity
import okhttp3.*
import org.json.JSONObject
import java.io.*
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.concurrent.TimeUnit

abstract class ServerConnection {
    companion object {
        private const val TAG = "Server Connection"
        // [Phase 0] 베데스다 multipart 업로드 엔드포인트.
        // 주의: 가이드(§2)의 "/iCReaT_DCT/invoke/..." 경로는 prefix 오류로 404(200+HTML)였음.
        // 실제 동작 경로는 루트 "/invoke/..." (curl로 200 + status:success, DB 적재 검증 완료).
        private const val REQUEST_URL = "https://icreatdct.btsd.io/invoke/DCT/Sensor/uploadCsv"

        // 클라이언트를 싱글톤으로 관리 (메모리 효율)
        private val client = OkHttpClient.Builder()
            .connectTimeout(30, TimeUnit.SECONDS)
            .writeTimeout(30, TimeUnit.SECONDS)
            .readTimeout(30, TimeUnit.SECONDS)
            .build()

        /**
         * [enterSensor] 진입 함수.
         * 베데스다는 무인증(a) 정책이며 로그인/세션 API가 없으므로 네트워크 로그인을 수행하지 않는다.
         * [2026-07-09] 이유: QR 로그인 Phase 1 — TEST 하드코딩 기본값이 남으면 스캔 없이 테스트 ID로 업로드될 위험. | 목적: studyId/subjectId를 호출부(QR 스캔/캐시)가 반드시 명시하도록 기본값 제거.
         */
        fun enterSensor(
            deviceID: String,
            studyId: String,
            subjectId: String,
            context: Activity
        ) {
            CacheManager.saveCacheFile(context, "$studyId|$subjectId", "login.txt")

            val intent = Intent(context, SensorActivity::class.java).apply {
                putExtra("DeviceID", deviceID)
                putExtra("studyId", studyId)
                putExtra("subjectId", subjectId)
            }
            context.startActivity(intent)
            context.finish()
        }

        /**
         * [postFile] AcceptService에서 호출하는 함수
         */
        fun postFile(
            file: File,
            studyId: String,
            subjectId: String,
            battery: String,
            timestamp: String,
            onResult: (Boolean) -> Unit
        ) {
            val requestBody = MultipartBody.Builder()
                .setType(MultipartBody.FORM)
                .addFormDataPart("csvfile", file.name, RequestBody.create(MediaType.parse("text/csv"), file))
                .addFormDataPart("studyId", studyId)
                .addFormDataPart("subjectId", subjectId)
                .addFormDataPart("battery", battery)
                .addFormDataPart("timestamp", timestamp)
                .build()

            val request = Request.Builder().url(REQUEST_URL).post(requestBody).build()

            client.newCall(request).enqueue(object : Callback {
                override fun onFailure(call: Call, e: IOException) {
                    val errorMessage = "Network Error: ${e.message}"
                    Log.e(TAG, errorMessage)
                    saveErrorLog(errorMessage)
                    onResult(false)
                }

                override fun onResponse(call: Call, response: Response) {
                    // 베데스다 서버는 잘못된 경로에도 HTTP 200 + HTML 에러 페이지를 반환한다.
                    // 따라서 HTTP 코드만이 아니라 응답 body의 JSON status=="success"까지 확인해야 한다.
                    val bodyStr = try { response.body()?.string() ?: "" } catch (e: Exception) { "" }
                    val success = response.isSuccessful && isSuccessBody(bodyStr)
                    if (success) {
                        Log.d(TAG, "전송 성공: ${response.code()}")
                        onResult(true)
                    } else {
                        saveErrorLog("Server Error: code=${response.code()} body=${bodyStr.take(300)}")
                        onResult(false)
                    }
                    response.close()
                }
            })
        }

        /**
         * 응답 body가 베데스다 성공 규격(JSON status=="success")인지 확인.
         * HTML 에러 페이지 등 JSON이 아니면 파싱 실패 → false.
         */
        private fun isSuccessBody(body: String): Boolean {
            return try {
                JSONObject(body).optString("status") == "success"
            } catch (e: Exception) {
                false
            }
        }

        fun saveErrorLog(errorMessage: String) {
            CsvController.writeLog("SERVER_ERROR: $errorMessage")
        }
    }
}