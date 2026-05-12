import 'package:g_json/g_json.dart';

import 'crf_validation_query.dart';

class ValidationEditCheckList {
  final List<ValidationEditCheck> editCheckList;

  ValidationEditCheckList({
    required this.editCheckList
  });

  List<ValidationEditCheck> get list => editCheckList;

  factory ValidationEditCheckList.fromJSON(String formSeq, JSON json) {
    List<ValidationEditCheck> editCheckList = [];
    for(var each in json["editCheckList"].listValue) {
      editCheckList.add(ValidationEditCheck.fromJSON(formSeq, each));
    }
    return ValidationEditCheckList(
        editCheckList: editCheckList
    );
  }
}

class ValidationEditCheck {
  final ValidationType type;
  final List<ValidationQuery> queryList;
  final List<String> affectedItemUidList;
  final String itemUid;
  final bool isMandatory;
  final String min;
  final String max;
  final bool prerequisite;
  final String msgOnFailure;

  final String formSeq;

  ValidationEditCheck({
    required this.type,
    required this.queryList,
    required this.affectedItemUidList,
    required this.itemUid,
    required this.isMandatory,
    required this.min,
    required this.max,
    required this.prerequisite,
    required this.msgOnFailure,
    required this.formSeq,
  });

  factory ValidationEditCheck.fromJSON(String formSeq, JSON json) {
    List<ValidationQuery> queryList = [];
    for (var eachQuery in json["query"].listValue) {
      var q = ValidationQuery.fromJSON(eachQuery);
      queryList.add(q);
    }

    return ValidationEditCheck(
      type: ValidationType.fromString(json["type"].stringValue),
      queryList: queryList,
      affectedItemUidList: json['affected_item_uid_list'].stringValue.split(','),
      itemUid: json["item_uid"].stringValue,
      isMandatory: json["is_mandatory"].booleanValue,
      min: json["min"].stringValue,
      max: json["max"].stringValue,
      prerequisite: json["prerequisite"].booleanValue,
      msgOnFailure: json["msg_on_failure"].stringValue,
      formSeq: formSeq,
    );
  }
}