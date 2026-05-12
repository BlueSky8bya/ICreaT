import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icreat_dct/0_data/model/ble/ble_body_composition_model.dart';
import 'package:icreat_dct/1_service/measurement_service.dart';
import 'package:icreat_dct/3_view/navbar/measurement/data/measurement_type.dart';
import 'package:icreat_dct/3_view/navbar/measurement/bluetooth/components/result_measurement_view_model.dart';

class WeightResultViewModel extends ResultMeasurementViewModel {
  final String _itemGroupKey;
  final BodyComposition bodyComposition;
  final MeasurementService _measurementService;

  WeightResultViewModel(
    this.bodyComposition,
    this._itemGroupKey,
    super._healthService,
    this._measurementService,
  );

  final MeasurementType type = MeasurementType.bodyWeight;

  String get weight => bodyComposition.weight.toStringAsFixed(1);
  String get weightUnit => 'kg';

  @override
  void onInit() {
    super.onInit();
    completeInit();
  }


  bool _saveResult(BuildContext context) {
    _measurementService.addWeight(
      _itemGroupKey,
      weight: bodyComposition.weight,
    );
    return true;
  }

  void saveResult(BuildContext context) {
    saveOmronResult(
      context: context,
      type: type,
      measureTime: bodyComposition.measureTime,
      bodyComposition: bodyComposition,
    );
    final isSuccess = _saveResult(context);
    if (isSuccess) {
      context.pop();
    }
  }
}
