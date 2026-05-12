package kr.caresquare.pbcr

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import kr.caresquare.pbcr.channel.BluetoothChannel
import kr.caresquare.pbcr.channel.PhrChannel
import kr.caresquare.pbcr.noti.NotiHelper
import kr.caresquare.pbcr.service.StepService

class MainActivity: FlutterActivity() {
    private lateinit var bluetoothChannel: BluetoothChannel
    private lateinit var phrChannel: PhrChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        NotiHelper.createNotificationChannel(applicationContext)

        bluetoothChannel = BluetoothChannel(this, flutterEngine)
        phrChannel = PhrChannel(applicationContext, flutterEngine)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (intent.getStringExtra(StepService.EXTRA_NAME_STEP_NOTIFICATION) ==
                        StepService.EXTRA_VALUE_STEP_NOTIFICATION
        ) {
            phrChannel.clickStepNotification()
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        bluetoothChannel.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }
}