package com.gachon_HCI_Lab.wear_os_sensor.util

import android.content.Context
import android.content.pm.PackageManager
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.core.app.ActivityCompat
import com.gachon_HCI_Lab.wear_os_sensor.model.SDKSensor
import com.gachon_HCI_Lab.wear_os_sensor.util.SDKSensor.PpgGreenTrackerEvent
import com.gachon_HCI_Lab.wear_os_sensor.util.SDKSensor.PpgIrTrackerEvent
import com.gachon_HCI_Lab.wear_os_sensor.util.SDKSensor.PpgRedTrackerEvent
import com.samsung.android.service.health.tracking.ConnectionListener
import com.samsung.android.service.health.tracking.HealthTracker
import com.samsung.android.service.health.tracking.HealthTrackerException
import com.samsung.android.service.health.tracking.HealthTrackingService
import com.samsung.android.service.health.tracking.data.HealthTrackerType

class PpgUtil {
    private val TAG: String = "ppg"
    private val permissions = arrayOf("android.permission.BODY_SENSORS")

    private var context: Context? = null

    private var healthTrackingService: HealthTrackingService? = null

    private var ppgTrackers: HashMap<HealthTracker, HealthTracker.TrackerEventListener> = hashMapOf()

    private val handler = Handler(Looper.myLooper()!!)

    private val connectionListener: ConnectionListener = object : ConnectionListener {
        override fun onConnectionSuccess() {
            try {
                Log.i("qwe", SDKSensor.getCheckedSensorList().toString())

                for(ppgType: Any in SDKSensor.getCheckedSensorList()){
                    ppgTrackers.put(
                        healthTrackingService!!.getHealthTracker(ppgType as HealthTrackerType?),
                        when {
                            ppgType == HealthTrackerType.PPG_RED -> PpgRedTrackerEvent
                            ppgType == HealthTrackerType.PPG_IR -> PpgIrTrackerEvent
                            ppgType == HealthTrackerType.PPG_GREEN -> PpgGreenTrackerEvent
                            else -> null
                        } as HealthTracker.TrackerEventListener
                    )
                }

                for((ppgTracker, event) in ppgTrackers!!){
                        ppgTracker.setEventListener(event)
                    if(event == PpgGreenTrackerEvent)
                        ppgTracker.flush()
                }

            } catch (e: IllegalArgumentException) {
                //
            }
        }

        override fun onConnectionEnded() {}

        override fun onConnectionFailed(e: HealthTrackerException) {
            if (e.hasResolution()) {}
        }
    }

    constructor(context: Context){
        this.context = context
    }

    fun start(){
        if (checkPermission(this.context, this.permissions)) {
            Log.i("", "onCreate Permission granted")
            healthTrackingService = HealthTrackingService(connectionListener, this.context)
            healthTrackingService!!.connectService()
        } else {
            Log.i("", "onCreate Permission not granted")
        }
    }

    // [2026-06-30] 이유: 워치 STOP 후에도 PPG 녹색 LED가 켜진 채 남는 문제 | 목적: 멱등 정리로 리스너 해제·LED OFF 보장(여러 번 호출/null 안전)
    // 멱등(여러 번 호출돼도 안전). PPG 리스너를 해제해 녹색 LED를 끈다.
    fun destroy(){
        for((ppgTracker, _) in ppgTrackers){
            try { ppgTracker.unsetEventListener() } catch (_: Exception) {}
        }
        ppgTrackers.clear()
        try { healthTrackingService?.disconnectService() } catch (_: Exception) {}
        healthTrackingService = null
    }

    private fun checkPermission(context: Context?, permissions: Array<String>): Boolean {
        for (permission in permissions) {
            if (context == null || ActivityCompat.checkSelfPermission(context, permission!!) == PackageManager.PERMISSION_DENIED) {
                Log.i(TAG, "checkPermission : PERMISSION_DENIED : " + "permission")
                return false
            } else {
                Log.i(TAG, "checkPermission : PERMISSION_GRANTED : " + "permission")
            }
        }
        return true
    }

}