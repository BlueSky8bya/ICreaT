import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:icreat_dct/1_service/ble/ble_callback.dart';
import 'package:icreat_dct/1_service/ble/ble_device_service.dart';
import 'package:icreat_dct/0_data/model/ble/ble_types.dart';
import 'package:icreat_dct/0_data/model/ble/ble_temperature_model.dart';
import 'package:icreat_dct/6_util/logger.dart';

class TemperatureDeviceService extends BleDeviceService {
  TemperatureBleCallback? _temperatureCallback;
  set temperatureCallback(TemperatureBleCallback? value) {
    _temperatureCallback = value;
    callback = value;
  }

  StreamSubscription? _temperatureSubscription;

  @override
  List<Guid> get scanWithSerices => [BleServiceType.temperature.uuid];

  @override
  bool scanFilter(ScanResult scanResult) =>
      scanResult.device.platformName == 'THERMOCARE';

  @override
  Future<void> readyToGetData() async {
    Logger.info('start readyToGetData');
    await _getBattery();
    await _eraseData();
    await _listenTemperature();
  }

  Future<void> _getBattery() async {
    final batteryCharact =
        getCharact(BleServiceType.battery, BatteryCharactType.batteryLevel());

    final batteryBytes = await batteryCharact?.read();
    if (batteryBytes != null) _parseBatteryBytes(batteryBytes);
  }

  void _parseBatteryBytes(List<int> batteryBytes) {
    Logger.info(
        'batteryBytes length = ${batteryBytes.length}, bytes = $batteryBytes');
    final battery = batteryBytes.toBatteryValue();

    if (battery != null) {
      _temperatureCallback?.onNewBattery?.call(battery);
    }
  }

  Future<void> _eraseData() async {
    final eraseDataCharact = getCharact(
      BleServiceType.temperature,
      TemperatureCharactType.cntDataAndDataErase(),
    );

    await eraseDataCharact?.write([0x00, 0x01]);
  }

  Future<void> _listenTemperature() async {
    final measurementCharact = getCharact(
        BleServiceType.temperature, TemperatureCharactType.measurement());

    await _temperatureSubscription?.cancel();
    _temperatureSubscription =
        measurementCharact?.lastValueStream.listen(_parseTemperatureBytes);

    await measurementCharact?.setNotifyValue(true);
  }

  void _parseTemperatureBytes(List<int> bytes) {
    Logger.info('temperature length = ${bytes.length}, bytes = $bytes');
    if (bytes.length == 13) {
      final temperature = BleTemperature.fromBytes(bytes: bytes);
      Logger.info('temperature = $temperature');
      _temperatureCallback?.onNewTemperature?.call(temperature);
    }
  }

  @override
  void processOnDisconnected() {
    return;
  }

  @override
  Future<void> dispose() async {
    await super.dispose();
    _temperatureSubscription?.cancel();
    _temperatureSubscription = null;
    temperatureCallback = null;
  }
}
