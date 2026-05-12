import 'package:flutter/material.dart';
import 'package:icreat_dct/0_data/model/ble/ble_body_composition_model.dart';
import 'package:icreat_dct/0_data/model/measurement/blood_pressure_model.dart';
import 'package:icreat_dct/1_service/health_service.dart';
import 'package:icreat_dct/3_view/components/base_view_model.dart';
import 'package:icreat_dct/3_view/navbar/measurement/data/measurement_type.dart';
import 'package:icreat_dct/4_router/common_navigator.dart';
import 'package:icreat_dct/4_router/navigation_method.dart';

class ResultMeasurementViewModel extends BaseViewModel {
  ResultMeasurementViewModel(this._healthService);
  final HealthService _healthService;

  void saveOmronResult({
    required MeasurementType type,
    required DateTime measureTime,
    required BuildContext context,
    BodyComposition? bodyComposition,
    BloodPressureModel? bloodPressure,
  }) async {
    final before10Min = DateTime.now().subtract(const Duration(minutes: 10));
    if (measureTime.isBefore(before10Min)) {
      _showDialogForErrorMeasureTime(context);
    } else {}
  }

  void _showDialogForErrorMeasureTime(BuildContext context) {
    // ShortDialog(
    //   title: '예전에 측정한 기록이에요',
    //   content: Text.rich(
    //     TextSpan(
    //       text: '최근에 측정한 값만 저장할 수 있어요\n',
    //       children: [
    //         TextSpan(text: '다시 측정', style: TextStyles.body.bold),
    //         const TextSpan(text: ' 버튼을 눌러주세요'),
    //       ],
    //     ),
    //     textAlign: TextAlign.center,
    //   ),
    //   isAlert: true,
    //   isMultiBtn: false,
    // ).show(context);
  }
  void retry(BuildContext context, MeasurementType type) {
    switch (type) {
      case MeasurementType.temperature:
        CommonNavigator.toBtBluetooth(
          context,
          mode: NavigatingMethod.pushReplacement,
        );
        break;
      case MeasurementType.bloodPressure:
        CommonNavigator.toBpBluetooth(
          context,
          mode: NavigatingMethod.pushReplacement,
        );
        break;
      case MeasurementType.bodyWeight:
        CommonNavigator.toBwBluetooth(
          context,
          mode: NavigatingMethod.pushReplacement,
        );
        break;
      case MeasurementType.sleep:
        break;
      case MeasurementType.step:
        break;
    }
  }
}
