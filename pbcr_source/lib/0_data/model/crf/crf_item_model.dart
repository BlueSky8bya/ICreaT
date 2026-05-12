import 'package:icreat_dct/0_data/model/type/crf_data_type.dart';
import 'package:icreat_dct/0_data/model/type/crf_input_type.dart';

import 'crf_code_model.dart';

class CRFItemModel {
  final int orderNumber;
  final int itemSeq;
  final String itemUid;
  final String itemOid;
  final String itemName;
  final String itemNameLabel;
  final int itemGroupRepeatkey;
  final CrfDataType dataType;
  final CrfInputType inputType;
  final String? itemLength;
  final String? commentHeader;
  final String? commentBody;
  final String? originItemValue;
  final String? measurementUnit;

  final String? itemValue;
  final String? codeList;

  // 그룹
  final int itemGroupKey;
  final String itemGroupUid;
  final String itemGroupOid;

  CRFItemModel({
    required this.orderNumber,
    required this.itemSeq,
    required this.itemUid,
    required this.itemOid,
    required this.itemName,
    required this.itemNameLabel,
    required this.itemGroupRepeatkey,
    required this.dataType,
    required this.inputType,
    this.itemLength,
    this.commentHeader,
    this.commentBody,
    this.originItemValue,
    this.measurementUnit,
    required this.itemValue,
    this.codeList,
    required this.itemGroupKey,
    required this.itemGroupUid,
    required this.itemGroupOid,
  });

  List<CRFCodeModel> get itemCodeList => CRFCodeModel.fromString(codeList ?? '');

  String get defaultPlaceholder {
    switch(inputType){
      case CrfInputType.textBox:
        return '내용을 입력해주세요.';
      case CrfInputType.date:
        return '날짜를 선택해주세요.';
      case CrfInputType.calculate:
        return '내용을 입력해주세요.';
      case CrfInputType.comments:
        return '내용을 입력해주세요.';
      case CrfInputType.radio:
        return '문항을 선택해주세요.';
      case CrfInputType.dropDown:
        return '문항을 선택해주세요.';
      case CrfInputType.checkBox:
        return '문항을 선택해주세요.';
      case CrfInputType.measurementBpSys:
        return '수축기 혈압을 입력해주세요.';
      case CrfInputType.measurementBpDia:
        return '이완기 혈압을 입력해주세요.';
      case CrfInputType.measurementBpPulse:
        return '맥박을 입력해주세요.';
      case CrfInputType.measurementBodyTemperature:
        return '체온을 입력해주세요.';
      case CrfInputType.measurementBodyWeight:
        return '체중을 입력해주세요.';
      case CrfInputType.measurementSleepStart:
        return '수면 시작 시간을 입력해주세요.';
      case CrfInputType.measurementSleepEnd:
        return '수면 종료 시간을 입력해주세요.';
      case CrfInputType.measurementSleepDuration:
        return '수면 시간을 입력해주세요.';
      case CrfInputType.measurementStep:
        return '걸음 수를 입력해주세요.';
      default:
        return "";
    }
  }
}
