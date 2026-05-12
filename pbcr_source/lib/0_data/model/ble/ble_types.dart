
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleType {
  final String _value;
  const BleType._(this._value);

  Guid get uuid => Guid(_value);
}

extension _BleStringExt on String {
  static const bleStandardPrefixUUID = '0000';
  static const bleStandardSuffixUUID = '-0000-1000-8000-00805F9B34FB';
  static const thermocareSuffixUUID = '-0000-2000-4200-D3E2ADFBE7EF';

  String get standardUUID =>
      '$bleStandardPrefixUUID$this$bleStandardSuffixUUID';
  String get thermocareUUID =>
      '$bleStandardPrefixUUID$this$thermocareSuffixUUID';
}

enum BleServiceType {
  gap,
  deviceInfo,
  time,
  battery,
  temperature,
  bloodPressure,
  weightScale,
  bodyComposition,
  userData,
  omoronOption,
}

extension BleServiceTypeExt on BleServiceType {
  Guid get uuid {
    switch (this) {
      case BleServiceType.gap:
        return BleType._('1800'.standardUUID).uuid;
      case BleServiceType.deviceInfo:
        return BleType._('180A'.standardUUID).uuid;
      case BleServiceType.time:
        return BleType._('1805'.standardUUID).uuid;
      case BleServiceType.battery:
        return BleType._('180F'.standardUUID).uuid;
      case BleServiceType.temperature:
        return BleType._('1809'.standardUUID).uuid;
      case BleServiceType.bloodPressure:
        return BleType._('1810'.standardUUID).uuid;
      case BleServiceType.weightScale:
        return BleType._('181D'.standardUUID).uuid;
      case BleServiceType.bodyComposition:
        return BleType._('181B'.standardUUID).uuid;
      case BleServiceType.userData:
        return BleType._('181C'.standardUUID).uuid;
      case BleServiceType.omoronOption:
        return const BleType._('5DF5E817-A945-4F81-89C0-3D4E9759C07C').uuid;
    }
  }

  String get code {
    switch (this) {
      case BleServiceType.bloodPressure:
        return '1810';
      case BleServiceType.weightScale:
        return '181D';
      default:
        return '';
    }
  }
}

class GAPCharactType extends CharactType {
  GAPCharactType.manufacturerName() : super(number: '2A00'.standardUUID);
}

class DeviceInfoCharactType extends CharactType {
  DeviceInfoCharactType.manufacturerName() : super(number: '2A29'.standardUUID);
  DeviceInfoCharactType.modelName() : super(number: '2A24'.standardUUID);
  DeviceInfoCharactType.serialNumber() : super(number: '2A25'.standardUUID);
  DeviceInfoCharactType.hardwareRevision() : super(number: '2A27'.standardUUID);
  DeviceInfoCharactType.firmwareRevision() : super(number: '2A26'.standardUUID);
  DeviceInfoCharactType.softwareRevision() : super(number: '2A28'.standardUUID);
  DeviceInfoCharactType.systemId() : super(number: '2A23'.standardUUID);
  DeviceInfoCharactType.certificationData()
      : super(number: '2A2A'.standardUUID);
}

class TimeCharactType extends CharactType {
  TimeCharactType.currentTime() : super(number: '2A2B'.standardUUID);
}

class BatteryCharactType extends CharactType {
  BatteryCharactType.batteryLevel() : super(number: '2A19'.standardUUID);
}

class TemperatureCharactType extends CharactType {
  TemperatureCharactType.measurement() : super(number: '2A1C'.standardUUID);
  TemperatureCharactType.measurementType() : super(number: '2A1D'.standardUUID);
  TemperatureCharactType.sensorDataRead()
      : super(number: '2A75'.thermocareUUID);
  TemperatureCharactType.sensorDataAck() : super(number: '2A76'.thermocareUUID);
  TemperatureCharactType.currentUser() : super(number: '2A78'.thermocareUUID);
  TemperatureCharactType.userList() : super(number: '2A79'.thermocareUUID);
  TemperatureCharactType.sensorCalibration()
      : super(number: '2A74'.thermocareUUID);
  TemperatureCharactType.cntDataAndDataErase()
      : super(number: '2A81'.thermocareUUID);
  TemperatureCharactType.alwaysOn() : super(number: '2A82'.thermocareUUID);
}

class BloodPressureCharactType extends CharactType {
  BloodPressureCharactType.feature() : super(number: '2A49'.standardUUID);
  BloodPressureCharactType.measurement() : super(number: '2A35'.standardUUID);
}

class WeightScaleCharactType extends CharactType {
  WeightScaleCharactType.feature() : super(number: '2A9E'.standardUUID);
  WeightScaleCharactType.measurement() : super(number: '2A9D'.standardUUID);
}

class BodyCompositionCharactType extends CharactType {
  BodyCompositionCharactType.feature() : super(number: '2A9B'.standardUUID);
  BodyCompositionCharactType.measurement() : super(number: '2A9C'.standardUUID);
}

class UserDataCharactType extends CharactType {
  UserDataCharactType.userControlPoint() : super(number: '2A9F'.standardUUID);
  UserDataCharactType.dbChangeIncrement() : super(number: '2A99'.standardUUID);
  UserDataCharactType.userIndex() : super(number: '2A9A'.standardUUID);
  UserDataCharactType.dateOfBirth() : super(number: '2A85'.standardUUID);
  UserDataCharactType.gender() : super(number: '2A8C'.standardUUID);
  UserDataCharactType.height() : super(number: '2A8E'.standardUUID);
}

class OmoronOptionCharactType extends CharactType {
  OmoronOptionCharactType.recordAccessControlPoint()
      : super(number: '2A52'.standardUUID);
  OmoronOptionCharactType.omronMeasurement()
      : super(number: '8FF2DDFB-4A52-4CE5-85A4-D2F97917792A');
}

abstract class CharactType {
  final String number;
  CharactType({
    required this.number,
  });

  Guid get uuid => BleType._(number).uuid;
}
