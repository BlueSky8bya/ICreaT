package kr.caresquare.pbcr.receiver


import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import kr.caresquare.pbcr.data.PrefHelperKt
import kr.caresquare.pbcr.service.StepService

class RestartStepServiceReceiver : BroadcastReceiver() {
    private val tag = this::class.java.name

    override fun onReceive(context: Context, intent: Intent) {
        val prefHelper = PrefHelperKt.getInstance(context)

        if (prefHelper.uid.isNotEmpty()) {
            val stepServiceIntent = Intent(context.applicationContext, StepService::class.java)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(stepServiceIntent)
            } else {
                context.startService(stepServiceIntent)
            }
        }
    }
}