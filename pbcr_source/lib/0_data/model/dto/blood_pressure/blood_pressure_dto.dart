import 'package:icreat_dct/0_data/model/ble/ble_blood_pressure_model.dart';
import 'package:icreat_dct/0_data/model/dto/dto.dart';
import 'package:icreat_dct/0_data/model/measurement/blood_pressure_model.dart';

class BloodPressureDTO implements DTO<BleBloodPressure, BloodPressureModel> {
  @override
  BloodPressureModel toDomain(BleBloodPressure data) {
    return BloodPressureModel(
      systole: data.systolic,
      diastole: data.diastolic,
      pulse: data.pulseRate,
      recordedAt: data.measureTime,
    );
  }

  @override
  BleBloodPressure fromDomain(BloodPressureModel domain) {
    return BleBloodPressure(
      systolic: domain.systole,
      diastolic: domain.diastole,
      pulseRate: domain.pulse,
      measureTime: domain.recordedAt,
    );
  }
}