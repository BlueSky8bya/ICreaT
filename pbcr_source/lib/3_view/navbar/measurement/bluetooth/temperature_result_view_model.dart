import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:icreat_dct/1_service/ble/ble_callback.dart';
import 'package:icreat_dct/0_data/model/ble/ble_temperature_model.dart';
import 'package:icreat_dct/1_service/ble/devices/temperature_device.dart';
import 'package:icreat_dct/1_service/measurement_service.dart';
import 'package:icreat_dct/3_view/navbar/measurement/data/measurement_type.dart';
import 'package:icreat_dct/3_view/navbar/measurement/bluetooth/components/result_measurement_view_model.dart';
import 'package:icreat_dct/6_util/logger.dart';

class TemperatureResultViewModel extends ResultMeasurementViewModel {
  final MeasurementService _measurementService;
  final String _itemGroupKey;

  TemperatureResultViewModel(
    this.device,
    this._itemGroupKey,
    super._healthService,
    this._measurementService,
  );

  final MeasurementType type = MeasurementType.temperature;
  late final TemperatureDeviceService device;
  final Rx<BleTemperature> temperature = BleTemperature.empty().obs;
  final RxInt battery = 0.obs;
  final RxBool isConnected = true.obs;
  bool _needBleDisepose = true;

  // --- states ---
  bool get isDisconnected => !isConnected.value;

  @override
  void onInit() {
    super.onInit();
    _initDevice();
  }

  void _initDevice() {
    device.temperatureCallback = _makeCallback();
    device.readyToGetData();
  }

  TemperatureBleCallback _makeCallback() => TemperatureBleCallback(
        onChangeState: _onChangeState,
        onNewBattery: (battery) => this.battery.value = battery,
        onNewTemperature: (temperature) => this.temperature.value = temperature,
      );

  void _onChangeState(BluetoothConnectionState state) async {
    Logger.debug('체온 ViewModel onChageState = $state');
    if (state == BluetoothConnectionState.disconnected && _needBleDisepose) {
      _needBleDisepose = false;
      await device.dispose();
      isConnected.value = false;
      // showToast('체온계와 연결이 끊어졌어요\n계속해서 측정을 하려면 다시 연결해주세요');
    }
  }

  @override
  void onClose() {
    if (_needBleDisepose) {
      _needBleDisepose = false;
      device.dispose();
    }
    super.onClose();
  }

  bool _saveResult(BuildContext context) {
    final temperature = this.temperature.value;
    _measurementService.addTemperature(
      _itemGroupKey,
      temperature: temperature.recordValue,
    );
    return true;
  }

  void saveResult(BuildContext context) {
    final isSuccess = _saveResult(context);
    if (isSuccess) {
      context.pop();
    }
  }
}
