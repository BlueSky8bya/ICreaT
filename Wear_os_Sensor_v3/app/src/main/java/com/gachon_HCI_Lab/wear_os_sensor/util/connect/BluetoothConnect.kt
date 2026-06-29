package com.gachon_HCI_Lab.wear_os_sensor.util.connect

import android.annotation.SuppressLint
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothManager
import android.bluetooth.BluetoothSocket
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.util.Log
import com.gachon_HCI_Lab.wear_os_sensor.util.step.StepsReaderUtil
import java.io.IOException
import java.io.OutputStream
import java.lang.reflect.Method
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.util.*

@SuppressLint("StaticFieldLeak")
object BluetoothConnect {
    private var bluetoothManager: BluetoothManager? = null
    private lateinit var mBluetoothAdapter: BluetoothAdapter
    private lateinit var pairedDvices: Set<BluetoothDevice>
    private lateinit var mBluetoothDevice: BluetoothDevice
    private var mBluetoothSocket: BluetoothSocket? = null
    private lateinit var mOutputStream: OutputStream
    private lateinit var context: Context
    var deviceName: String = ""

    fun constructor(context: Context){
        BluetoothConnect.context = context
        bluetoothManager = context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        mBluetoothAdapter = bluetoothManager!!.adapter
    }

    @SuppressLint("MissingPermission")
    fun searchDevice(): String {
        // [2026-06-30] 이유: bondedDevices/기기명 접근은 Android 12+에서 BLUETOOTH_CONNECT 런타임 권한 필요 →
        //   권한 허용 전 ConnectFragment.onCreateView가 호출하면 SecurityException으로 앱 크래시(logcat 00:56 확인)
        //   | 목적: 권한 미허용·BT 접근 실패 시 크래시 대신 "error" 반환해 ConnectFragment가 Search 상태로 안전 폴백
        return try {
            pairedDvices = mBluetoothAdapter.bondedDevices
            val connected = getParingBluetoothDevice(pairedDvices) ?: return "error"
            // [2026-06-30] 이유: connected.toString()이 Android 12+/Wear OS에서 마스킹 주소(XX:XX:XX:XX:70:FC)를
            //   반환해 getRemoteDevice()가 IllegalArgumentException으로 앱 크래시 | 목적: 이미 가진 페어링 기기 객체를 직접 사용
            mBluetoothDevice = connected
            deviceName = connected.name
            connected.name
        } catch (e: Exception) {
            Log.e("BluetoothConnect", "Bluetooth 권한 없음 또는 기기 검색 실패", e)
            "error"
        }
    }

    @SuppressLint("MissingPermission")
    @Throws(IOException::class)
    fun connect(): String {
        try {
            // [수정 핵심] 기존에 닫힌 소켓 찌꺼기가 있다면 확실히 버리고, 무조건 새 소켓을 생성!
            if (mBluetoothSocket != null) {
                try { mBluetoothSocket?.close() } catch (_: Exception) {}
            }
            val uuid = UUID.fromString("00001101-0000-1000-8000-00805f9b34fb")
            mBluetoothSocket = mBluetoothDevice.createRfcommSocketToServiceRecord(uuid)

            Thread.sleep(100)
            mBluetoothSocket?.connect()
            mOutputStream = mBluetoothSocket!!.outputStream
            return "Success"
        } catch (e: IOException) {
            Log.e("BluetoothConnect", "소켓 생성/연결 실패", e)
            throw IOException()
        }
    }

    @Throws(Exception::class)
    fun sendData(byteSensorData: ByteBuffer){
        val byteBuffer = ByteBuffer.allocate(968)
        byteBuffer.order(ByteOrder.LITTLE_ENDIAN)
        val byteArray = createByteArrayForSensorAndBatteryData(byteBuffer, byteSensorData)
        mOutputStream.write(byteArray)
        handleBluetoothError()
    }

    fun disconnect() {
        try {
            mBluetoothSocket?.close()
        } catch (e: IOException) {
            Log.e("Bluetooth Connection", "Error closing socket", e)
        }
    }

    @SuppressLint("MissingPermission")
    private fun getParingBluetoothDevice(pairedDevice: Set<BluetoothDevice>): BluetoothDevice? {
        try {
            for (bluetoothDevice: BluetoothDevice in pairedDevice) {
                if (isConnected(bluetoothDevice) as Boolean) {
                    return bluetoothDevice
                }
            }
        } catch (_: Exception) {}
        return null
    }

    private fun createByteArrayForSensorAndBatteryData(byteBuffer:ByteBuffer, byteSensorData: ByteBuffer): ByteArray{
        byteBuffer.putInt(getBatteryPercentage())
        byteBuffer.putInt(StepsReaderUtil.stepCount.toInt())
        byteBuffer.put(byteSensorData)
        return byteBuffer.array()
    }

    private fun isConnected(device: BluetoothDevice): Any? {
        val m: Method = device.javaClass.getMethod("isConnected")
        return m.invoke(device)
    }

    private fun getBatteryPercentage(): Int {
        val batteryIntent = context.registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
        val level = batteryIntent?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) ?: -1
        val scale = batteryIntent?.getIntExtra(BatteryManager.EXTRA_SCALE, -1) ?: -1
        return level * 100 / scale
    }

    private fun handleBluetoothError(){
        if(mBluetoothSocket == null || !mBluetoothSocket!!.isConnected){
            throw Exception()
        }
    }
}