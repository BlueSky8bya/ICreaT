import 'dart:math';
import 'dart:typed_data';

import 'package:icreat_dct/8_extension/int_list_ext.dart';

class BleTemperature {
  BleTemperature({
    required this.isCelsius,
    required this.recordValue,
  });
  final bool isCelsius;
  final double recordValue;

  factory BleTemperature.fromBytes({
    required List<int> bytes,
  }) =>
      BleTemperature(
        isCelsius: (bytes[0] & 0x01) == 0,
        recordValue: _parseValue(bytes),
      );

  factory BleTemperature.fromManualRecord(double value) => BleTemperature(
        isCelsius: true,
        recordValue: value,
      );

  BleTemperature.empty()
      : isCelsius = true,
        recordValue = 0;

  static double _parseValue(List<int> bytes) {
    final valueBytes = bytes.getRange(1, 5).toList();
    final bd = ByteData(1)..setInt8(0, valueBytes[3]);
    final exponent = bd.getInt8(0);

    valueBytes.removeAt(3);
    final base = valueBytes.toIntValue(isLittleEndian: true);
    final temperatureStr =
        (base * pow(10, exponent)).toDouble().toStringAsFixed(1);

    return double.parse(temperatureStr);
  }

  String get unitString => isCelsius ? '\u00B0C' : '\u00B0F';

  @override
  String toString() =>
      'Temperature(isCelsius: $isCelsius, recordValue: $recordValue)';
}