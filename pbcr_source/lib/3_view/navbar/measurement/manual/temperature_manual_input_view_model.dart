import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:icreat_dct/1_service/measurement_service.dart';
import 'package:icreat_dct/3_view/components/base_view_model.dart';

class TemperatureManualInputViewModel extends BaseViewModel {
  final MeasurementService _measurementService;
  final String _itemGroupKey;

  TemperatureManualInputViewModel(
    this._itemGroupKey,
    this._measurementService,
  );

  TextEditingController tc = TextEditingController();

  @override
  void onClose() {
    disposeTc();

    super.onClose();
  }

  void disposeTc() {
    tc.dispose();
  }

  bool _saveTemperature(BuildContext context) {
    final temperature = double.tryParse(tc.text);
    if (temperature == null) {
      showToast(context, msg: '체온을 입력해주세요.');
      return false;
    }

    _measurementService.addTemperature(
      _itemGroupKey,
      temperature: temperature,
    );
    return true;
  }

  void saveTemperature(BuildContext context) {
    final isSuccess = _saveTemperature(context);
    if (isSuccess) {
      context.pop();
    }
  }
}
