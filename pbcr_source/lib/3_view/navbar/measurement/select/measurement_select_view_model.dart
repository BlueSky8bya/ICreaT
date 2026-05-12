import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icreat_dct/3_view/components/base_view_model.dart';
import 'package:icreat_dct/3_view/navbar/measurement/data/measurement_type.dart';
import 'package:icreat_dct/4_router/common_navigator.dart';
import 'package:icreat_dct/4_router/navigation_method.dart';

class MeasurementSelectViewModel extends BaseViewModel {
  final MeasurementType _measurementType;
  final String _itemGroupKey;

  MeasurementSelectViewModel(this._measurementType, this._itemGroupKey);

  String get appbarTitle => _measurementType.label;

  // 네비게이션

  void handleNavigateToManual(BuildContext context) {
    switch (_measurementType) {
      case MeasurementType.bloodPressure:
        CommonNavigator.toBpManual(
          context,
          mode: NavigatingMethod.pushReplacement,
          itemGroupKey: _itemGroupKey,
        );
        break;
      case MeasurementType.temperature:
        CommonNavigator.toBtManual(
          context,
          mode: NavigatingMethod.pushReplacement,
          itemGroupKey: _itemGroupKey,
        );
        break;
      case MeasurementType.bodyWeight:
        CommonNavigator.toBwManual(
          context,
          mode: NavigatingMethod.pushReplacement,
          itemGroupKey: _itemGroupKey,
        );
        break;
      case MeasurementType.sleep:
        break;
      case MeasurementType.step:
        break;
    }
  }

  void handleNavigateToBluetooth(BuildContext context) {
    switch (_measurementType) {
      case MeasurementType.bloodPressure:
        CommonNavigator.toBpBluetooth(
          context,
          mode: NavigatingMethod.pushReplacement,
          itemGroupKey: _itemGroupKey,
        );
        break;
      case MeasurementType.temperature:
        CommonNavigator.toBtBluetooth(
          context,
          mode: NavigatingMethod.pushReplacement,
          itemGroupKey: _itemGroupKey,
        );
        break;
      case MeasurementType.bodyWeight:
        CommonNavigator.toBwBluetooth(
          context,
          mode: NavigatingMethod.pushReplacement,
          itemGroupKey: _itemGroupKey,
        );
        break;
      case MeasurementType.sleep:
        break;
      case MeasurementType.step:
        break;
    }
  }

  void handlePop(BuildContext context) {
    context.pop();
  }
}
