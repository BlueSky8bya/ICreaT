package kr.caresquare.pbcr.channel

import android.Manifest
import android.bluetooth.BluetoothManager
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kr.caresquare.pbcr.MainActivity
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class BluetoothChannel(private val activity: MainActivity, flutterEngine: FlutterEngine) :
    MethodChannel.MethodCallHandler {
    private val channel = MethodChannel(
        flutterEngine.dartExecutor.binaryMessenger,
        BLUETOOTH_CHANNEL
    )

    private var permissionResult: MethodChannel.Result? = null

    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.Main).launch {
            when (call.method) {
                METHOD_POWER_ON -> powerOn(result)
                METHOD_REQUEST_PERMISSION -> requestPermission(result)
                else -> result.notImplemented()
            }
        }
    }

    private fun powerOn(result: MethodChannel.Result) {
        val isEnable =
            (activity.applicationContext.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager).adapter.isEnabled
        result.success(isEnable)
    }

    private fun requestPermission(result: MethodChannel.Result) {
        permissionResult = null

        val permissions = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) listOf(
            Manifest.permission.BLUETOOTH_SCAN,
            Manifest.permission.BLUETOOTH_CONNECT
        ) else listOf(Manifest.permission.ACCESS_FINE_LOCATION)

        when {
            permissions.map {
                ContextCompat.checkSelfPermission(activity, it)
            }.all { it == PackageManager.PERMISSION_GRANTED } -> {
                result.success(true)
            }
            permissions.map {
                ActivityCompat.shouldShowRequestPermissionRationale(activity, it)
            }.all { it } -> {
                result.success(false)
            }
            else -> {
                permissionResult = result
                ActivityCompat.requestPermissions(
                    activity, permissions.toTypedArray(),
                    REQ_CODE
                )
            }
        }
    }

    fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        if (requestCode == REQ_CODE) {
            permissionResult?.success(grantResults.all { it == PackageManager.PERMISSION_GRANTED })
            permissionResult = null
        }
    }

    companion object {
        private const val BLUETOOTH_CHANNEL = "kr.caresquare.pbcr/bluetooth"
        private const val METHOD_POWER_ON = "powerOn"
        private const val METHOD_REQUEST_PERMISSION = "requestPermission"
        private const val REQ_CODE = 7777
    }
}