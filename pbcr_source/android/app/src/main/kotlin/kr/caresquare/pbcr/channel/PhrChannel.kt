package kr.caresquare.pbcr.channel

import android.app.ActivityManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.util.Log
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kr.caresquare.pbcr.phr.PhrRepo
import kr.caresquare.pbcr.service.StepService
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class PhrChannel(private val context: Context, flutterEngine: FlutterEngine) :
        MethodChannel.MethodCallHandler {
    private val tag = this::class.java.name
    private val phrRepo = PhrRepo.getInstance(context)
    private var stepSensorActivateReceiver: BroadcastReceiver? = null
    private val channel: MethodChannel =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PHR_CHANNEL)

    init {
        channel.setMethodCallHandler(this)
        stepSensorActivateReceiver = StepSensorActivateReceiver()
        LocalBroadcastManager.getInstance(context)
                .registerReceiver(
                        stepSensorActivateReceiver!!,
                        IntentFilter(ACTION_SEND_TODAY_STEP_CNT)
                )
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.Main).launch {
            when (call.method) {
                METHOD_INIT -> {
                    val status = checkRunServiceAndStart()
                    result.success(status)
                }
                METHOD_CLOSE -> {
                    val isSuccess = stopStepService()
                    result.success(isSuccess)
                }
                METHOD_GET_STEP_CNT_FOR_PERIOD -> {
                    val from = (call.argument<Int>("from") ?: 0).toLong()
                    val to = (call.argument<Int>("to") ?: 0).toLong()
                    result.success(phrRepo.getStepCntForPeriod(from, to))
                }
                METHOD_GET_STEP_DATA_FOR_PERIOD -> {
                    val from = (call.argument<Int>("from") ?: 0).toLong()
                    val to = (call.argument<Int>("to") ?: 0).toLong()
                    result.success(phrRepo.getStepDataForPeriod(from, to))
                }
                METHOD_GET_NEED_POST_STEP_LIST -> {
                    result.success(phrRepo.getNeedPostStepList())
                }
                METHOD_UPDATE_POSTED_STEP -> {
                    try {
                        val timeList = (call.argument<List<Int>>("time_list") ?: listOf()).map { it.toLong() }
                        Log.d(tag, "METHOD_UPDATE_POSTED_STEP : getData = $timeList")
                        phrRepo.updatePostedStep(timeList)
                        phrRepo.deleteCompleteStepData()
                        result.success(null)
                    } catch (e: Exception) {
                        result.error(
                                "ERROR : METHOD_UPDATE_POSTED_STEP",
                                e.stackTraceToString(),
                                null
                        )
                    }
                }
                METHOD_GET_NEED_POST_SLEEP_LIST -> {
                    result.success(phrRepo.getNeedPostSleepList())
                }
                METHOD_GET_SLEEP_DATA_FOR_PERIOD -> {
                    phrRepo.calcSleep()
                    val from = (call.argument<Int>("from") ?: 0).toLong()
                    val to = (call.argument<Int>("to") ?: 0).toLong()
                    result.success(phrRepo.getSleepDataForPeriod(from, to))
                }
                METHOD_UPDATE_POSTED_SLEEP -> {
                    try {
                        val deleteTime = (call.argument<Int>("delete_time") ?: 0).toLong()
                        Log.d(tag, "METHOD_UPDATE_POSTED_SLEEP : deleteTime = $deleteTime")
                        phrRepo.deleteCompleteSleepData(deleteTime)
                        result.success(null)
                    } catch (e: Exception) {
                        result.error(
                                "ERROR : METHOD_UPDATE_POSTED_SLEEP",
                                e.stackTraceToString(),
                                null
                        )
                    }
                }
                METHOD_REFRESH_STEP_SENSOR -> {
                    LocalBroadcastManager.getInstance(context)
                            .sendBroadcast(Intent(StepService.ACTION_REFRESH_STEP_SENSOR))
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun checkRunServiceAndStart(): String =
            if (!isServiceRunning(StepService::class.java)) {
                val intent = Intent(context.applicationContext, StepService::class.java)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    context.applicationContext.startForegroundService(intent)
                } else {
                    context.applicationContext.startService(intent)
                }
                "service start!"
            } else {
                "service is running"
            }

    private fun stopStepService(): Boolean =
            try {
                context.stopService(Intent(context.applicationContext, StepService::class.java))
                true
            } catch (e: Exception) {
                Log.e(tag, e.stackTraceToString())
                false
            }

    private fun isServiceRunning(serviceClass: Class<*>): Boolean {
        val manager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        for (service in manager.getRunningServices(Int.MAX_VALUE)) {
            if (serviceClass.name == service.service.className) {
                return true
            }
        }
        return false
    }

    fun clickStepNotification() {
        channel.invokeMethod(METHOD_REFRESH_CLICK_STEP_NOTI, null)
    }

    fun getStepDataWhenDetect(stepData: List<String>) {
        channel.invokeMethod(METHOD_GET_TODAY_STEP_CNT_WHEN_DETECT, stepData)
    }

    inner class StepSensorActivateReceiver : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            CoroutineScope(Dispatchers.Main).launch {
                val curStepData: List<String> = phrRepo.getTodayStepData()
                getStepDataWhenDetect(curStepData)
            }
        }
    }

    companion object {
        private const val PHR_CHANNEL = "io.lokks.careease/phr"
        private const val METHOD_INIT = "initService"
        private const val METHOD_CLOSE = "closeService"
        private const val METHOD_GET_STEP_CNT_FOR_PERIOD = "getStepCntForPeriod"
        private const val METHOD_GET_STEP_DATA_FOR_PERIOD = "getStepDataForPeriod"
        private const val METHOD_GET_NEED_POST_STEP_LIST = "getNeedPostStepList"
        private const val METHOD_UPDATE_POSTED_STEP = "updatePostedStep"
        private const val METHOD_CALC_SLEEP = "calcSleep"
        private const val METHOD_GET_NEED_POST_SLEEP_LIST = "getNeedPostSleepList"
        private const val METHOD_GET_SLEEP_DATA_FOR_PERIOD = "getSleepDataForPeriod"
        private const val METHOD_UPDATE_POSTED_SLEEP = "updatePostedSleep"
        private const val METHOD_REFRESH_STEP_SENSOR = "refreshStepSensor"
        private const val METHOD_REFRESH_CLICK_STEP_NOTI = "clickStepNotification"
        private const val METHOD_GET_TODAY_STEP_CNT_WHEN_DETECT = "getTodayStepDataWhenDetect"
        const val ACTION_SEND_TODAY_STEP_CNT = "ACTION_SEND_TODAY_STEP_CNT"
    }
}
