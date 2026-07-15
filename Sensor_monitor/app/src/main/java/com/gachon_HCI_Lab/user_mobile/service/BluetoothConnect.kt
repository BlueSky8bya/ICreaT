package com.gachon_HCI_Lab.user_mobile.service

import android.annotation.SuppressLint
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothServerSocket
import android.bluetooth.BluetoothSocket
import android.util.Log
import com.gachon_HCI_Lab.user_mobile.common.CsvController
import com.gachon_HCI_Lab.user_mobile.common.SocketState
import com.gachon_HCI_Lab.user_mobile.common.SocketStateEvent
import com.gachon_HCI_Lab.user_mobile.common.ThreadState
import com.gachon_HCI_Lab.user_mobile.common.ThreadStateEvent
import org.greenrobot.eventbus.EventBus
import java.io.IOException
import java.io.InputStream
import java.util.*

object BluetoothConnect {
    private var serverSocket: BluetoothServerSocket? = null
    private lateinit var bluetoothAdapter: BluetoothAdapter
    private var socket: BluetoothSocket? = null
    private lateinit var inputStream: InputStream
    private var isRunning: Boolean = true

    private val SOCKET_NAME = "server"
    private val MY_UUID = UUID.fromString("00001101-0000-1000-8000-00805f9b34fb")

    fun createBluetoothAdapter(bluetoothAdapter: BluetoothAdapter){
        this.bluetoothAdapter = bluetoothAdapter
    }

    @SuppressLint("MissingPermission")
    fun createSeverSocket() {
        // [2026-07-15] 이유: 이전 리스너 미정리 시 유령 SDP 레코드가 남아 워치가 accept() 없는 죽은 채널에 연결됨(워치 초록불+모바일 NONE) | 목적: 재생성 전 이전 리스너 close (Sensor_monitor 707e45a 이식)
        closeServerSocket()
        serverSocket = bluetoothAdapter.listenUsingRfcommWithServiceRecord(SOCKET_NAME, MY_UUID)
        CsvController.writeLog("SERVER_SOCKET: 새 리스닝 소켓 생성 (이전 소켓 정리 완료)")
    }

    @Throws(IOException::class)
    fun createBluetoothSocket() {
        try {
            isRunning = true
            closeSocket() // [2026-07-15] 이유: 직전 연결의 클라이언트 소켓 잔재 누수 | 목적: accept 전 정리
            socket = (serverSocket ?: throw IOException("server socket not created")).accept()
            Log.d("socketConnect", socket.toString())
            Thread.sleep(300)
        } catch (e: IOException) {
            EventBus.getDefault().post(ThreadStateEvent(ThreadState.STOP))
            throw IOException()
        }
    }

    fun createInputStream(): InputStream {
        inputStream = socket!!.inputStream
        EventBus.getDefault().post(SocketStateEvent(SocketState.CONNECT))
        isRunning = true
        return inputStream
    }

    fun closeServerSocket() {
        try {
            serverSocket?.close()
        } catch (_: Exception) {}
        serverSocket = null
    }

    fun closeSocket() {
        try {
            socket?.close()
        } catch (_: Exception) {}
        socket = null
    }

    fun isBluetoothRunning(): Boolean {
        return isRunning
    }

    fun stopRunning(){
        // [추적 1] 누군가 통신 중지 명령을 내림
        CsvController.writeLog("BLUETOOTH_CONNECT: 누군가 stopRunning()을 호출했습니다!")

        // [추적 2] 범인(호출자)의 위치를 역추적해서 로그에 남김
        val callerTrace = Exception().stackTrace.take(3).joinToString(" <- ") { it.methodName }
        CsvController.writeLog("STOP_CALLER: $callerTrace")

        isRunning = false;
    }

    fun isConnected(): Boolean {
        return socket?.isConnected == true
    }
}
