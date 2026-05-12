import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:icreat_dct/1_service/measurement_service.dart';
import 'package:icreat_dct/3_view/components/base_view_model.dart';

class WeightManualInputViewModel extends BaseViewModel {
  final MeasurementService _measurementService;
  final String _itemGroupKey;

  WeightManualInputViewModel(
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

  bool _saveWeight(BuildContext context) {
    final weight = double.tryParse(tc.text);
    if (weight == null) {
      showToast(context, msg: '몸무게를 입력해주세요.');
      return false;
    }

    _measurementService.addWeight(
      _itemGroupKey,
      weight: weight,
    );
    return true;
  }

  void saveWeight(BuildContext context) {
    final isSuccess = _saveWeight(context);
    if (isSuccess) {
      context.pop();
    }
  }
}
