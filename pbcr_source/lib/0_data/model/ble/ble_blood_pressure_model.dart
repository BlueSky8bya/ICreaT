import 'package:flutter/foundation.dart';
import 'package:icreat_dct/1_service/ble/ble_device_service.dart';

class BleBloodPressure {
  BleBloodPressure({
    required this.systolic,
    required this.diastolic,
    this.meanArterialPressure,
    required this.pulseRate,
    required this.measureTime,
    this.error,
  });
  final int systolic;
  final int diastolic;
  final int? meanArterialPressure;
  final int pulseRate;
  DateTime measureTime;
  final BloodPressureError? error;

  factory BleBloodPressure.fromBytes({required List<int> bytes}) => BleBloodPressure(
        systolic: _parseValue(bytes.sublist(1, 3)),
        diastolic: _parseValue(bytes.sublist(3, 5)),
        meanArterialPressure: _parseValue(bytes.sublist(5, 7)),
        measureTime: bytes.sublist(7, 14).toCurrentTime(),
        pulseRate: _parseValue(bytes.sublist(14, 16)),
        error: _parseError(bytes),
      );

  factory BleBloodPressure.fromManualRecord({
    required int systolic,
    required int diastolic,
    required int pulseRate,
    DateTime? measureTime,
  }) =>
      BleBloodPressure(
        systolic: systolic,
        diastolic: diastolic,
        pulseRate: pulseRate,
        measureTime: measureTime ?? DateTime.now(),
      );

  BleBloodPressure.empty()
      : systolic = 0,
        diastolic = 0,
        meanArterialPressure = 0,
        pulseRate = 0,
        measureTime = DateTime.now(),
        error = BloodPressureError(
          errBodyMovement: false,
          errLooseCuff: false,
          errIrregularPulse: false,
          errMeasurementPosition: false,
        );

  static int _parseValue(List<int> bytes) {
    final bd = ByteData(2)
      ..setInt8(0, bytes[0])
      ..setInt8(1, bytes[1]);
    return bd.getInt16(0, Endian.little);
  }

  static BloodPressureError _parseError(List<int> bytes) {
    int flagByte;
    if (bytes.length == 18) {
      flagByte = bytes.last;
    } else {
      final bd = ByteData(2)
        ..setInt8(0, bytes[17])
        ..setInt8(1, bytes[18]);
      flagByte = bd.getInt16(0, Endian.little);
    }
    final errBodyMovement = (flagByte & 1) > 0;
    final errLooseCuff = (flagByte & 2) > 0;
    final errIrregularPulse = (flagByte & 4) > 0;
    final errMeasurementPosition = (flagByte & 32) > 0;

    return BloodPressureError(
      errBodyMovement: errBodyMovement,
      errLooseCuff: errLooseCuff,
      errIrregularPulse: errIrregularPulse,
      errMeasurementPosition: errMeasurementPosition,
    );
  }

  @override
  String toString() {
    return 'BloodPressure(measureTime: $measureTime, systolic: $systolic, diastolic: $diastolic, meanArterialPressure: $meanArterialPressure, pulseRate: $pulseRate, error: $error)';
  }
}

class BloodPressureError {
  final bool errBodyMovement;
  final bool errLooseCuff;
  final bool errIrregularPulse;
  final bool errMeasurementPosition;

  BloodPressureError({
    required this.errBodyMovement,
    required this.errLooseCuff,
    required this.errIrregularPulse,
    required this.errMeasurementPosition,
  });

  bool get hasError =>
      errBodyMovement ||
      errLooseCuff ||
      errIrregularPulse ||
      errMeasurementPosition;

  @override
  String toString() {
    return 'BloodPressureError(errBodyMovement: $errBodyMovement, errLooseCuff: $errLooseCuff, errIrregularPulse: $errIrregularPulse, errMeasurementPosition: $errMeasurementPosition)';
  }
}
