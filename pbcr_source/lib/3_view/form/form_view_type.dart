import 'package:icreat_dct/0_data/model/crf/crf_item_model.dart';
import 'package:icreat_dct/8_extension/string_ext.dart';
import 'package:icreat_dct/0_data/model/type/crud_type.dart';

enum FormSelectType {
  radio,
  checkbox,
  dropdown,
  text,
  number,
  decimal,
  date,
  multilineText,
  measurement,
  ;

  bool get needTextController => this == text || this == number || this == decimal || this == multilineText;
  bool get isCheckBox => this == checkbox;
}

class FormEnableStatus {
  final String itemUid; // trigger key
  final Map<String, bool> overlay = {}; // key = target itemUid, value = status

  FormEnableStatus(this.itemUid);

  List<String> get enabledList => overlay.entries.where((el) => el.value == true).map((el) => el.key).toList();
  List<String> get disabledList => overlay.entries.where((el) => el.value == false).map((el) => el.key).toList();
    List<String> get list => overlay.keys.toList();

  clearList() {
    overlay.clear();
  }

  setEnabledList(List<String> enabledList) {
    for (final k in enabledList) {
      overlay[k] = true;
    }
  }

  setDisabledList(List<String> disabledList) {
    for (final k in disabledList) {
      overlay[k] = false;
    }
  }

  hasKey(String key) {
    return overlay.containsKey(key);
  }

  isEnabled(String key) {
    return overlay[key] ?? false;
  }
}

class FormOption {
  final String key;
  final String text;

  const FormOption({required this.key, required this.text});
}

// 설계서에서는 Question은 여러개의 Select를 포함할 수 있도록 하고 있으나,
// 여기 구현에서는 하나의 Question에 하나의 Select만 포함하게 설계 되어 있다.

class FormQuestion {
  final String key;
  final String title;
  final String description;
  final FormSelectType type;
  final List<FormOption> options;
  final String? placeholder;
  final String? suffix;
  final String? commentHeader;
  final String? commentBody;

  final CRFItemModel model;

  const FormQuestion({
    required this.key,
    required this.title,
    required this.description,
    required this.type,
    required this.options,
    required this.model,
    this.suffix,
    this.placeholder,
    this.commentHeader,
    this.commentBody,
  });

  bool get hasComment => !commentHeader.isNullOrEmpty || !commentBody.isNullOrEmpty;
}

class FormSubmitPreviewGroup {
  final String itemGroupUid;
  final String itemGroupName;

  final List<FormSubmitPreview> itemList;

  FormSubmitPreviewGroup({
    required this.itemGroupUid,
    required this.itemGroupName,
    required this.itemList
  });
}

class FormSubmitPreview {
  final String itemUid;
  final String question;
  String answer;
  bool isEnabled;
  bool isMandatory;

  FormSubmitPreview({
    required this.itemUid,
    required this.question,
    this.answer = '',
    this.isEnabled = false,
    this.isMandatory = false
  });
}

class FormViewModelOption {
  final String studyOid;
  final String studyEventSeq;
  final String studyEventDataSeq;
  final String studyEventName; // =visitOccurrenceId
  final String formSeq;
  final String formVersionSeq;
  final String formDataSeq;
  final String formName;
  final DateTime scheduledAt;

  /// 일정 새로고침 시 사용되는 날짜
  final DateTime dateKey;
  final CrudType crudType;

  FormViewModelOption({
    required this.studyOid,
    required this.studyEventSeq,
    required this.studyEventDataSeq,
    required this.studyEventName,
    required this.formName,
    required this.formSeq,
    required this.formVersionSeq,
    required this.formDataSeq,
    required this.dateKey,
    required this.crudType,
    required this.scheduledAt,
  });
}