
import 'package:icreat_dct/1_service/ble/ble_device_service.dart';
import 'package:icreat_dct/8_extension/double_ext.dart';
import 'package:icreat_dct/8_extension/int_list_ext.dart';

class BodyComposition {
  static const double _weightKiloResolution = 0.005;
  static const double _weightPoundResolution = 0.01;
  static const double heightResoulution = 0.1;

  static const int measurementOmronProtocol1Length = 19;
  static const int measurementOmronProtocol2Length = 16;
  static const int measurementSIGProtocolLength = 11;
  static const double _kjTokcalResolution = 4.184;

  static const int measurementUnitBitFlag = 0;

  BodyComposition({
    required this.weight,
    this.bmi,
    required this.measureTime,
    this.bodyFatPercentage,
    this.basalMetabolism,
    this.skeletalMusclePercentage,
    this.visceralFatLevel,
    this.bodyAge,
  });
  final double weight;
  final double? bmi;
  DateTime measureTime;
  final double? bodyFatPercentage; // 체지방률
  final int? basalMetabolism; // 기초대사량
  final double? skeletalMusclePercentage; // 골격근
  final int? visceralFatLevel; // 내장지방 레벨
  final int? bodyAge; // 신체나이

  factory BodyComposition.fromBytesSIGProtocol({required List<int> bytes}) =>
      BodyComposition(
          weight: (isKilogramUnit(_parseValue(bytes, 0, 1)))
              ? (_parseValue(bytes, 1, 3) * _weightKiloResolution).roundUp(1)
              : (_parseValue(bytes, 1, 3) * _weightPoundResolution).roundUp(1),
          measureTime: bytes.sublist(3, 10).toCurrentTime());

  factory BodyComposition.fromBytesOmronProtocol({required List<int> bytes}) =>
      BodyComposition(
        weight: (_parseValue(bytes, 5, 7) * _weightKiloResolution).roundUp(1),
        bmi: (_parseValue(bytes, 15, 17) * 0.1).roundUp(1),
        measureTime: bytes.sublist(7, 14).toCurrentTime(),
        bodyFatPercentage: (_parseValue(bytes, 24, 26) * 0.1).roundUp(1),
        basalMetabolism:
            (_parseValue(bytes, 26, 28) / _kjTokcalResolution).round(),
        skeletalMusclePercentage: (_parseValue(bytes, 28, 30) * 0.1).roundUp(1),
        visceralFatLevel: bytes[30],
        bodyAge: bytes[31],
      );

  factory BodyComposition.fromManualRecord({
    required double weight,
    DateTime? measureTime,
  }) =>
      BodyComposition(
        weight: weight,
        measureTime: measureTime ?? DateTime.now(),
      );

  BodyComposition.empty()
      : weight = 0,
        bmi = 0,
        bodyFatPercentage = 0,
        basalMetabolism = 0,
        skeletalMusclePercentage = 0,
        visceralFatLevel = 0,
        measureTime = DateTime.now(),
        bodyAge = 0;

  static bool isKilogramUnit(int flagByte) {
    return (flagByte >> measurementUnitBitFlag) & 1 == 0;
  }

  static int _parseValue(List<int> bytes, int startIdx, int endIdx) =>
      bytes.sublist(startIdx, endIdx).toIntValue(isLittleEndian: true);

  @override
  String toString() {
    return 'BodyComposition(measureTime: $measureTime, weight: $weight, bmi: $bmi, bodyFatPercentage: $bodyFatPercentage, basalMetabolism: $basalMetabolism, skeletalMusclePercentage: $skeletalMusclePercentage, visceralFatLevel: $visceralFatLevel, bodyAge: $bodyAge)';
  }
}