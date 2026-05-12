import 'package:icreat_dct/0_data/model/crf/crf_item_model.dart';
import 'package:icreat_dct/0_data/model/crf/crf_form_info_model.dart';
import 'package:icreat_dct/0_data/model/crf/crf_code_model.dart';
import 'package:icreat_dct/0_data/model/type/crf_data_type.dart';
import 'package:icreat_dct/0_data/model/type/crf_input_type.dart';

import '../form_view_type.dart';

class CRFConverter {
  static List<FormQuestion> toFormQuestionList(CFRFormInfoModel eCRF) {
    final formQuestionList = <FormQuestion>[];
    for (var itemGroup in eCRF.itemGroupList) {
      for (var item in itemGroup.itemList) {
        formQuestionList.add(toFormQuestion(item));
      }
    }

    return formQuestionList;
  }

  static Map<String, String?> getSavedAnswer(CFRFormInfoModel eCRF) {

    final Map<String, String?> savedAnswer = {};

    for (final group in eCRF.itemGroupList) {
      for (final item in group.itemList) {
        final answer = item.itemValue;
        savedAnswer[item.itemUid] = answer;
      }
    }

    return savedAnswer;
  }

  static FormQuestion toFormQuestion(CRFItemModel itemModel) {
    return FormQuestion(
      key: itemModel.itemUid,
      title: itemModel.itemNameLabel,
      description: '',
      type: toFormSelectType(itemModel.inputType, itemModel.dataType),
      options: itemModel.itemCodeList.map(toFormOption).toList(),
      placeholder: itemModel.defaultPlaceholder,
      suffix: itemModel.measurementUnit,
      model: itemModel,
      commentHeader: itemModel.commentHeader,
      commentBody: itemModel.commentBody
    );
  }

  static FormSelectType toFormSelectType(CrfInputType inputType, CrfDataType dataType) {
    switch (inputType) {
      case CrfInputType.textBox:
        if (dataType == CrfDataType.float) {
          return FormSelectType.decimal;
        } else {
          return FormSelectType.text;
        }
      case CrfInputType.date:
        return FormSelectType.date;
      case CrfInputType.calculate:
        // TODO: 계산 타입 추가
        return FormSelectType.text;
      case CrfInputType.comments:
        return FormSelectType.multilineText;
      case CrfInputType.radio:
        return FormSelectType.radio;
      case CrfInputType.dropDown:
        return FormSelectType.dropdown;
      case CrfInputType.checkBox:
        return FormSelectType.checkbox;
      case CrfInputType.measurementBpSys:
      case CrfInputType.measurementBpDia:
      case CrfInputType.measurementBpPulse:
      case CrfInputType.measurementBodyTemperature:
      case CrfInputType.measurementBodyWeight:
      case CrfInputType.measurementSleepStart:
      case CrfInputType.measurementSleepEnd:
      case CrfInputType.measurementSleepDuration:
      case CrfInputType.measurementStep:
        return FormSelectType.measurement;
      case CrfInputType.unknown:
      default:
        return FormSelectType.text;
    }
  }

  static FormOption toFormOption(CRFCodeModel itemCodeModel) {
    return FormOption(
      key: itemCodeModel.code,
      text: itemCodeModel.name,
    );
  }
}
