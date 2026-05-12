import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:icreat_dct/1_service/ble/ble_callback.dart';
import 'package:icreat_dct/0_data/model/ble/ble_types.dart';
import 'package:icreat_dct/0_data/model/ble/ble_blood_pressure_model.dart';
import 'package:icreat_dct/1_service/ble/omron_device_service.dart';
import 'package:icreat_dct/6_util/logger.dart';
import 'package:icreat_dct/8_extension/int_list_ext.dart';
import 'package:icreat_dct/8_extension/string_ext.dart';

class BloodPressureDeviceService extends OmronDeviceService {
  BloodPressureBleCallback? _bpCallback;
  set bpCallback(BloodPressureBleCallback? value) {
    _bpCallback = value;
    callback = value;
  }

  BleBloodPressure? _bloodPressure;
  StreamSubscription? _bloodPressureSubscription;

  @override
  bool scanFilter(ScanResult scanResult) =>
      scanResult.advertisementData.serviceUuids.any(
        (srv) =>
            srv.toString().equalIgnoreCase(
                BleServiceType.bloodPressure.uuid.toString()) ||
            srv.toString().equalIgnoreCase(BleServiceType.bloodPressure.code),
      );

  @override
  List<Guid> get scanWithSerices => [BleServiceType.bloodPressure.uuid];

  @override
  Future<void> readyToGetData() async {
    // Current Time에 대해 구독을 하면 혈압 측정을 구독할 때 데이터가 넘어와서 오류가 발생하는 경우가 있다.
    // await listenCurrentTime();
    await _listenBloodPressure();
  }

  Future<void> _listenBloodPressure() {
    _bloodPressureSubscription?.cancel();

    return listenCharact(
      serviceType: BleServiceType.bloodPressure,
      charactType: BloodPressureCharactType.measurement(),
      setSubscription: (subscription) =>
          _bloodPressureSubscription = subscription,
      onListen: _parseBloodPressureBytes,
    );
  }

  void _parseBloodPressureBytes(List<int> bytes) {
    Logger.info('bloodPressureBytes data = ${bytes.toHexStringList()}');
    if (bytes.length >= 18) {
      _bloodPressure = BleBloodPressure.fromBytes(bytes: bytes);
      Logger.info('bloodPressure = $_bloodPressure');
    }
  }

  @override
  void processOnDisconnected() {
    if (_bloodPressure != null) {
      if (_bloodPressure!.measureTime == zeroTime) {
        _bloodPressure!.measureTime = DateTime.now();
      } else if (timeOffset != null) {
        _bloodPressure!.measureTime =
            _bloodPressure!.measureTime.add(timeOffset!);
      }
      _bpCallback?.onNewBloodPressure?.call(_bloodPressure!);
    }
  }

  @override
  Future<void> dispose() async {
    await super.dispose();
    bpCallback = null;
    _bloodPressureSubscription?.cancel();
    _bloodPressureSubscription = null;
  }
}
