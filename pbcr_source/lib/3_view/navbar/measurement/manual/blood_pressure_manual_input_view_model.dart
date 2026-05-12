import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:icreat_dct/1_service/measurement_service.dart';
import 'package:icreat_dct/3_view/components/base_view_model.dart';

enum BpInputType {
  systolic,
  diastolic,
  pulse;

  String get name {
    switch (this) {
      case BpInputType.systolic:
        return '수축기';
      case BpInputType.diastolic:
        return '이완기';
      case BpInputType.pulse:
        return '맥박';
    }
  }

  String get suffix {
    switch (this) {
      case BpInputType.systolic:
        return 'mmHg';
      case BpInputType.diastolic:
        return 'mmHg';
      case BpInputType.pulse:
        return 'bpm';
    }
  }

  int get minValue {
    switch (this) {
      case BpInputType.systolic:
        return 0;
      case BpInputType.diastolic:
        return 0;
      case BpInputType.pulse:
        return 0;
    }
  }

  int get maxValue {
    switch (this) {
      case BpInputType.systolic:
        return 300;
      case BpInputType.diastolic:
        return 250;
      case BpInputType.pulse:
        return 300;
    }
  }
}

class BloodPressureManualInputViewModel extends BaseViewModel {
  final MeasurementService _measurementService;
  final String _itemGroupKey;

  BloodPressureManualInputViewModel(
    this._itemGroupKey,
    this._measurementService,
  );

  Map<BpInputType, TextEditingController> tcMap = {
    BpInputType.systolic: TextEditingController(),
    BpInputType.diastolic: TextEditingController(),
    BpInputType.pulse: TextEditingController(),
  };

  Map<BpInputType, FocusNode> focusNodeMap = {
    BpInputType.systolic: FocusNode(),
    BpInputType.diastolic: FocusNode(),
    BpInputType.pulse: FocusNode(),
  };

  final RxString _errMsg = ''.obs;

  String get errMsg => _errMsg.value;

  @override
  void onClose() {
    disposeTc();

    super.onClose();
  }

  void disposeTc() {
    tcMap.forEach((key, value) {
      value.dispose();
    });
  }

  void handleValueChange(BpInputType type, String value) {
    // sys랑 dia 입력되었을 때 검사
    switch (type) {
      case BpInputType.systolic:
        if (tcMap[BpInputType.diastolic]!.text.isNotEmpty) {
          checkMaxMinValue(type);
          _checkSystolicIsUnderThanDiastolic();
        }
        break;
      case BpInputType.diastolic:
        if (tcMap[BpInputType.systolic]!.text.isNotEmpty) {
          checkMaxMinValue(type);
          _checkSystolicIsUnderThanDiastolic();
        }
        break;
      case BpInputType.pulse:
        checkMaxMinValue(type);
        break;
    }
  }

  void checkMaxMinValue(BpInputType type) {
    if (tcMap[type]!.text.isEmpty) return;

    final value = int.parse(tcMap[type]!.text);
    final max = type.maxValue;
    final min = type.minValue;

    if (value > max) {
      tcMap[type]!.text = max.toString();
      tcMap[type]!.selection = TextSelection.fromPosition(
        TextPosition(offset: max.toString().length),
      );
    } else if (value < min) {
      tcMap[type]!.text = min.toString();
      tcMap[type]!.selection = TextSelection.fromPosition(
        TextPosition(offset: min.toString().length),
      );
    }
  }

  bool _checkSystolicIsUnderThanDiastolic() {
    final systolic = int.tryParse(tcMap[BpInputType.systolic]!.text);
    final diastolic = int.tryParse(tcMap[BpInputType.diastolic]!.text);

    if (systolic == null || diastolic == null) {
      return false;
    }

    if (systolic < diastolic) {
      _errMsg.value = '수축기는 이완기보다 크거나 같아야 합니다.';
      return false;
    }

    _errMsg.value = '';
    return true;
  }

  bool _saveBloodPressure(BuildContext context) {
    final systolic = int.tryParse(tcMap[BpInputType.systolic]!.text);
    final diastolic = int.tryParse(tcMap[BpInputType.diastolic]!.text);
    final pulse = int.tryParse(tcMap[BpInputType.pulse]!.text);

    if (systolic == null || diastolic == null || pulse == null) {
      showToast(context, msg: '혈압을 입력해주세요.');
      return false;
    }

    if (!_checkSystolicIsUnderThanDiastolic()) {
      return false;
    }

    _measurementService.addBp(
      _itemGroupKey,
      systole: systolic,
      diastole: diastolic,
      pulse: pulse,
    );
    return true;
  }

  void saveBloodPressure(BuildContext context) {
    final isSuccess = _saveBloodPressure(context);
    if (isSuccess) {
      context.pop();
    }
  }
}
