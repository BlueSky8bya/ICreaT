
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:icreat_dct/0_data/model/ble/ble_blood_pressure_model.dart';
import 'package:icreat_dct/0_data/model/ble/ble_body_composition_model.dart';
import 'package:icreat_dct/0_data/model/ble/ble_temperature_model.dart';

typedef BleStateCallback = Function(BluetoothConnectionState state);

class BleCallback {
  BleCallback({
    required this.onChangeState,
    this.onEmptyData,
  });

  BleStateCallback? onChangeState;
  Function()? onEmptyData;
}

class WeightBleCallback extends BleCallback {
  WeightBleCallback({
    required super.onChangeState,
    super.onEmptyData,
    this.onNewBodyComposition,
    this.onSuccessPairing,
    required this.getLatestSeqNum,
    required this.setLatestSeqNum,
  });

  Function(BodyComposition bodyComposition)? onNewBodyComposition;
  Function(bool isSuccess, String deviceId)? onSuccessPairing;
  final int Function() getLatestSeqNum;
  final Future<void> Function(int seqNum) setLatestSeqNum;
}

class BloodPressureBleCallback extends BleCallback {
  BloodPressureBleCallback({
    required super.onChangeState,
    this.onNewBloodPressure,
  });

  Function(BleBloodPressure bloodPressure)? onNewBloodPressure;
}

class TemperatureBleCallback extends BleCallback {
  TemperatureBleCallback({
    required super.onChangeState,
    this.onNewBattery,
    this.onNewTemperature,
  });

  Function(BleTemperature temperature)? onNewTemperature;
  Function(int battery)? onNewBattery;
}
