import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icreat_dct/1_service/measurement_service.dart';
import 'package:icreat_dct/0_data/model/measurement/blood_pressure_model.dart';
import 'package:icreat_dct/3_view/navbar/measurement/data/measurement_type.dart';
import 'package:icreat_dct/3_view/navbar/measurement/bluetooth/components/result_measurement_view_model.dart';

class BloodPressureResultViewModel extends ResultMeasurementViewModel {
  final BloodPressureModel _bloodPressureModel;
  final MeasurementService _measurementService;
  final String _itemGroupKey;

  BloodPressureResultViewModel(
    this._bloodPressureModel,
    this._itemGroupKey,
    super._healthService,
    this._measurementService,
  );

  BloodPressureModel get bloodPressureModel => _bloodPressureModel;
  final MeasurementType type = MeasurementType.bloodPressure;

  /// --- actions ---

  bool _saveResult(BuildContext context) {
    _measurementService.addBp(
      _itemGroupKey,
      systole: _bloodPressureModel.systole,
      diastole: _bloodPressureModel.diastole,
      pulse: _bloodPressureModel.pulse,
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
