import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:icreat_dct/1_service/ble/ble_callback.dart';
import 'package:icreat_dct/1_service/ble/ble_device_service.dart';
import 'package:icreat_dct/0_data/model/ble/ble_types.dart';
import 'package:icreat_dct/1_service/ble/bluetooth_characteristic.dart';
import 'package:icreat_dct/0_data/model/ble/ble_body_composition_model.dart';
import 'package:icreat_dct/1_service/ble/omron_device_service.dart';
import 'package:icreat_dct/6_util/logger.dart';
import 'package:icreat_dct/8_extension/int_ext.dart';
import 'package:icreat_dct/8_extension/int_list_ext.dart';
import 'package:icreat_dct/8_extension/string_ext.dart';

class SigWeightDeviceService extends OmronDeviceService {
  WeightBleCallback? _weightCallback;

  set weightCallback(WeightBleCallback? value) {
    _weightCallback = value;
    callback = value;
  }

  BodyComposition? _bodyComposition;
  StreamSubscription? _weightSubscription;

  @override
  Future<void> readyToGetData() async {
    await _setCurrentTime();
    await _listenWeight();
  }

  @override
  bool scanFilter(ScanResult scanResult) =>
      scanResult.advertisementData.serviceUuids.any(
        (srv) =>
            srv
                .toString()
                .equalIgnoreCase(BleServiceType.weightScale.uuid.toString()) ||
            srv.toString().equalIgnoreCase(BleServiceType.weightScale.code),
      );

  @override
  List<Guid> get scanWithSerices => [BleServiceType.weightScale.uuid];

  Future<void> _listenWeight() {
    _weightSubscription?.cancel();
    return listenCharact(
      serviceType: BleServiceType.weightScale,
      charactType: WeightScaleCharactType.measurement(),
      setSubscription: (subscription) => _weightSubscription = subscription,
      onListen: _parseWeight,
    );
  }

  void _parseWeight(List<int> bytes) {
    Logger.info('weightBytes data = ${bytes.toHexStringList()}');
    if (bytes.length >= BodyComposition.measurementSIGProtocolLength) {
      _bodyComposition = BodyComposition.fromBytesSIGProtocol(bytes: bytes);
      Logger.info('weight = $_bodyComposition');
    }
  }

  @override
  void processOnDisconnected() {
    if (_weightCallback != null) {
      if (_bodyComposition == null) {
        _weightCallback?.onEmptyData?.call();
        return;
      }
      if (_bodyComposition!.measureTime == zeroTime) {
        _bodyComposition!.measureTime = DateTime.now();
      } else if (timeOffset != null) {
        _bodyComposition!.measureTime =
            _bodyComposition!.measureTime.add(timeOffset!);
      }
      _weightCallback?.onNewBodyComposition?.call(_bodyComposition!);
    }
  }

  @override
  Future<void> dispose() async {
    await super.dispose();
    weightCallback = null;
    _weightSubscription?.cancel();
    _weightSubscription = null;
  }

  Future<void> _setCurrentTime() async {
    await BleDeviceService.delayWrite();
    final timeCharact = getCharact(
      BleServiceType.time,
      TimeCharactType.currentTime(),
    );

    await timeCharact?.writeWithLog(
      data: [..._getCurTimeBytes(), 0, 0, 1],
      logTitle: 'set current time',
    );
  }

    List<int> _getCurTimeBytes() {
    final now = DateTime.now();
    return [
      ...now.year.toByteList(2, isLittleEndian: true),
      now.month,
      now.day,
      now.hour,
      now.minute,
      now.second
    ];
  }
}
