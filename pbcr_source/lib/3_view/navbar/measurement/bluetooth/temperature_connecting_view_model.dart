import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreat_dct/1_service/ble/ble_callback.dart';
import 'package:icreat_dct/1_service/ble/devices/temperature_device.dart';
import 'package:icreat_dct/3_view/navbar/measurement/bluetooth/device_connecting_view_model.dart';
import 'package:icreat_dct/4_router/common_navigator.dart';

class TemperatureConnectingViewModel extends DeviceConnectingViewModel {
  final String _itemGroupKey;
  TemperatureConnectingViewModel(
    super.context,
    this._itemGroupKey,
    super.bleService,
    super.permissionService,
  );

  TemperatureDeviceService? _device;
  @override
  String get deviceName => '체온계';
  final RxDouble dotsPosition = (0.0).obs;
  final CarouselController carouselController = CarouselController();

  @override
  void actionForBleAvailable() {
    _device = TemperatureDeviceService();
    bleDevice = _device;

    _device?.callback = BleCallback(onChangeState: onChangeState);
    _device?.startConnect();
    completeInit();
  }

  @override
  void actionForConnected() {
    _device?.callback = null;
    needBleDispose = false;
    CommonNavigator.toBtBluetoothResult(
      context,
      device: _device!,
      itemGroupKey: _itemGroupKey,
    );
  }

  bool onChangeScroll(ScrollNotification scrollNotification) {
    final metrics = scrollNotification.metrics;
    if (metrics is PageMetrics && metrics.page != null) {
      dotsPosition.value = metrics.page!;
    }
    return false;
  }
}
