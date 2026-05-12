package com.gachon_HCI_Lab.wear_os_sensor.model

import com.gachon_HCI_Lab.wear_os_sensor.recyclerView.Item
import java.nio.ByteBuffer
import java.util.concurrent.LinkedBlockingQueue

object SensorModel {
    private val checkedSensorList: ArrayList<Item> = arrayListOf()
    private var availableSensorList: ArrayList<Int> = arrayListOf()

    // [수정 핵심] 큐에 한계치(용량)를 설정하여 무한정 쌓여 메모리가 터지는 현상(OOM) 원천 차단
    var sendData: LinkedBlockingQueue<ByteBuffer> = LinkedBlockingQueue(1000)

    fun setAvailableSensorList(availableSensorList: ArrayList<Int>){
        SensorModel.availableSensorList = availableSensorList
    }

    fun getAvailableSensorList(): ArrayList<Int>{
        return availableSensorList
    }

    fun getCheckedSensorList():ArrayList<Item>{
        return checkedSensorList
    }
}