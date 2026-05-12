import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import 'package:icreat_dct/0_data/model/crf/crf_item_group_model.dart';
import 'package:icreat_dct/0_data/model/type/crf_data_type.dart';
import 'package:icreat_dct/0_data/model/type/crf_input_type.dart';
import 'package:icreat_dct/6_util/collection.dart';

import '../../../6_util/logger.dart';
import '../form_view_type.dart';
import 'crf_converter.dart';
import 'form_answer_state.dart';

typedef FormInitSummary = ({
  String itemUid,
  String answer,
  CrfDataType dataType,
  CrfInputType inputType,
});

typedef ItemGroup = ({
  String itemGroupUid,
  String itemGroupName,
  String itemGroupComments,
  List<String> itemUidList
});

bool isNullableInputType(CrfInputType t) {
  return t == CrfInputType.checkBox;
}

class FormStatusManager {

  final List<ItemGroup> _itemGroupList = [];
  final Map<String, FormQuestion> _formQuestionMap = {}; // key = itemUid

  final Map<String, bool> _baseEnableMap = {}; // key = itemUid or itemGroupUid
  late List<FormEnableStatus> _overlayEnableList = []; // element = { key = itemUid }

  final FormAnswerStateManager _formAnswerStateManager = FormAnswerStateManager();

  // getters

  int get numPage => _itemGroupList.length;
  int get numTotalQuestion => _formQuestionMap.length;
  int get numAnswer => _formAnswerStateManager.answeredList.where((el) => isEnabled(el)).length;
  Map<String, String> get answerMap => _formAnswerStateManager.answerMap;
  List<String> get orderedUidList {
    List<String> res = [];
    for (var itemGroup in _itemGroupList) {
      res.addAll(itemGroup.itemUidList);
    }
    return res;
  }

  // functions

  (List<FormInitSummary>, Map<String, String>) init(
    List<CRFItemGroupModel> itemGroupList,
    List<String> disabledListByEditCheck,
  ) {

    Set<String> uidSet = {};
    final List<FormInitSummary> formSummaryList = [];

    for (var itemGroup in itemGroupList) {
      final itemGroupUid = itemGroup.group.itemGroupUid;
      uidSet.add(itemGroupUid);

      List<String> itemUidListInGroup = [];

      for(var item in itemGroup.itemList) {
        if (item.itemGroupUid != itemGroupUid) { // not belong to here
          continue;
        }

        itemUidListInGroup.add(item.itemUid);
        uidSet.add(item.itemUid);

        var answer = item.itemValue;
        if (answer != null || item.inputType == CrfInputType.checkBox) {
          formSummaryList.add((
            itemUid: item.itemUid,
            answer: answer ?? "",
            dataType: item.dataType,
            inputType: item.inputType
          ));
        }

        TextEditingController? controller;

        var formQuestion = CRFConverter.toFormQuestion(item);
        if (formQuestion.type.needTextController) {
          controller = TextEditingController(text: answer ?? "");
        }

        if (item.inputType == CrfInputType.checkBox) {
          _formAnswerStateManager.addNewState(item.itemUid,
            prevAnswer: answer ?? "",
            currAnswer: answer ?? "",
            textController: controller,
          );
        } else {
          _formAnswerStateManager.addNewState(item.itemUid,
            prevAnswer: answer,
            currAnswer: answer,
            textController: controller,
          );
        }

        _formQuestionMap.putIfAbsent(item.itemUid, () => formQuestion);
      }

      _itemGroupList.add((
        itemGroupUid: itemGroupUid,
        itemGroupName: itemGroup.group.itemGroupName,
        itemGroupComments: itemGroup.group.comments ?? '',
        itemUidList: itemUidListInGroup
      ));
    }

    for (var k in uidSet.toList()) {
      _baseEnableMap[k] = disabledListByEditCheck.contains(k) ? false : true; // hide only disabled items in force
    }

    return (formSummaryList, _formAnswerStateManager.answerMap);
  }

  (Set<int>, Set<String>) findRelatedEnabledLayerIndex(String trigger, [int basePoint = 0]) {
    int eventPoint = -1;
    for (int i = basePoint; i < _overlayEnableList.length; ++i) {
      if (_overlayEnableList[i].itemUid == trigger) {
        eventPoint = i;
        break;
      }
    }

    if (eventPoint < 0) {
      return ({}, {});
    }

    Set<int> resIndices = { eventPoint };
    Set<String> resIds = { trigger };

    List<String> enabledListByTrigger = _overlayEnableList[eventPoint].list.toList(); // copy

    for (var subTrigger in enabledListByTrigger) {
      if (trigger != subTrigger) { // for safe
        var (subIndexSet, subIdSet) = findRelatedEnabledLayerIndex(subTrigger, eventPoint);
        resIndices.addAll(subIndexSet);
        resIds.addAll(subIdSet);
      }
    }

    return (resIndices, resIds);
  }

  Set<String> removeOverlayEnabledList(String trigger) {
    final (indexSetToRemove, idSetToReset) = findRelatedEnabledLayerIndex(trigger);
    _overlayEnableList = removeElementsAtIndices(_overlayEnableList, indexSetToRemove);

    return idSetToReset;
  }

  Set<String> updateOverlayEnabledList(String trigger, {
    required List<String> enabledList,
    required List<String> disabledList
  }) {
    final idSetToReset = removeOverlayEnabledList(trigger); // remove previous overlay by trigger

    var n = FormEnableStatus(trigger);
    n.setEnabledList(enabledList);
    n.setDisabledList(disabledList);

    _overlayEnableList.add(n); // add overlay top by trigger

    return idSetToReset;
  }

  List<String> getEnabledItemUidList() {
    List<String> res = [];
    for (var k in _formQuestionMap.keys) {
      if (isEnabled(k)) {
        res.add(k);
      }
    }

    //Logger.debug("enabledQuestionList = $res");

    return res;
  }

  Map<String, String> getEnabledAnswerMap() {
    Map<String,String> res = {};
    var enabledList = getEnabledItemUidList();

    for (var ans in _formAnswerStateManager.answerMap.entries) {
      if (enabledList.contains(ans.key)) {
        res[ans.key] = ans.value;
      }
    }

    return res;
  }

  bool isEnabled(String key) { // key = itemUid or itemGroupUid
    bool? res;

    // from top to bottom
    for(int i = _overlayEnableList.length - 1; i >= 0; --i) {
      if (_overlayEnableList[i].hasKey(key)) { // upper status
        res = _overlayEnableList[i].isEnabled(key);
        break;
      }
    }

    if (res != null) {
      return res;
    }

    return _baseEnableMap[key] ?? false;
  }

  FormQuestion? getFormQuestionByKey(String itemUid) {
    return _formQuestionMap[itemUid];
  }

  int getGroupIndex(String itemUid) {
    return _itemGroupList.indexWhere((el) => el.itemUidList.contains(itemUid));
  }

  List<FormQuestion> getFormQuestionListByGroup(String itemGroupUid) {
    List<FormQuestion> res = [];
    var itemGroup = _itemGroupList.firstWhereOrNull((el) => el.itemGroupUid == itemGroupUid);
    for (var itemUid in (itemGroup?.itemUidList ?? [])) {
      if(_formQuestionMap.containsKey(itemUid)) {
        res.add(_formQuestionMap[itemUid]!);
      }
    }

    return res;
  }

  (String, String) getSectionTitleDesc(int index) {
    if (0 <= index && index < _itemGroupList.length) {
      return (_itemGroupList[index].itemGroupName, _itemGroupList[index].itemGroupComments);
    }
    return ("","");
  }

  List<FormQuestion> getFormQuestionListByGroupIndex(int index) {
    List<FormQuestion> res = [];
    if (0 <= index && index < _itemGroupList.length) {
      for (var itemUid in _itemGroupList[index].itemUidList) {
        if(_formQuestionMap.containsKey(itemUid)) {
          res.add(_formQuestionMap[itemUid]!);
        }
      }
    }
    return res;
  }

  List<FormSubmitPreviewGroup> getAnswerListForPreview() {
    List<FormSubmitPreviewGroup> res = [];
    var ansMap = _formAnswerStateManager.answerMap; // key = itemUid, value = answer
    for (var itemGroup in _itemGroupList) {
      List<FormSubmitPreview> itemList = [];
      for (var itemUid in itemGroup.itemUidList) {
        if (_formQuestionMap.containsKey(itemUid)) {
          var formQuestion = _formQuestionMap[itemUid]!;

          String ans = ansMap[itemUid] ?? '';
          if (formQuestion.type.isCheckBox) { // checkbox == nullable
            if (ans.isEmpty) {
              ans = "선택안함";
            } else if (formQuestion.options.isNotEmpty) {
              // TODO: parsing multiple selection
            }
          } else { // not checkbox
            if (formQuestion.options.isNotEmpty) {
              ans = formQuestion.options.firstWhereOrNull((el) => el.key == ans)?.text ?? ans;
            }
          }

          if (ans.isNotEmpty && formQuestion.model.measurementUnit != null && formQuestion.model.measurementUnit!.isNotEmpty) {
            ans = "$ans ${formQuestion.model.measurementUnit!}";
          }

          itemList.add(FormSubmitPreview(
            itemUid: itemUid,
            question: '${formQuestion.title} ${formQuestion.description}',
            answer: ans,
            isEnabled: isEnabled(itemUid),
          ));
        }
      }
      res.add(FormSubmitPreviewGroup(
        itemGroupUid: itemGroup.itemGroupUid,
        itemGroupName: itemGroup.itemGroupName,
        itemList: itemList,
      ));
    }

    return res;
  }

  /// 현재 입력된 값 가져오기
  String? getCurrentAnswer(String itemUid) {
    return _formAnswerStateManager.getAnswer(itemUid);
  }

  /// 주어진 값을 현재 입력된 값으로 설정
  void setAnswer(String itemUid, String answer, {
    required List<String> enabled,
    required List<String> disabled,
  }) {
    _formAnswerStateManager.setAnswer(itemUid, answer);

    final idSetToReset = updateOverlayEnabledList(itemUid,
        enabledList: enabled,
        disabledList: disabled,
    );

    for (var idToReset in idSetToReset.toList()) {
      if (itemUid != idToReset) {
        _formAnswerStateManager.clear(idToReset);
      }
    }
  }

  TextEditingController textController(String itemUid) {
    return _formAnswerStateManager.getTextController(itemUid) ?? TextEditingController();
  }

  void disposeTextControllers() {
    _formAnswerStateManager.disposeAllTextControllers();
  }

  (Map<String, dynamic>, String) toEsourceRequest({
    required String studyOid,
    required String siteId,
    required String personId,
    required String personNm,
    required String visitOccurrenceId,
    required String visitDetailId,
    required String formName,
    String transMode = 'New',
    String serviceId = 'iCReaT_DCT',
  }) {

    Map<String, Map<String, String>> psMap = {}; // repeatKey 기준으로 item 분리

    for (var formQuestion in _formQuestionMap.values) {
      var value = _formAnswerStateManager.getAnswer(formQuestion.key);
      if (value == null || value.isEmpty) { // 빈 값은 제외
        continue;
      }

      var repeatKey = formQuestion.model.itemGroupRepeatkey.toString();
      var itemName = formQuestion.model.itemName;

      psMap.putIfAbsent(repeatKey, () => {});
      psMap[repeatKey]![itemName] = value;
    }

    List<Map<String,String>> psList = [];
    for (var group in psMap.entries) {
      if (group.value.isNotEmpty) {
        Map<String,String> entry = {};
        entry['itemgroup_repeatkey'] = group.key;
        for (var item in group.value.entries) {
          entry[item.key] = item.value;
        }
        psList.add(entry);
      }
    }

    var serviceUUID = Uuid().v4();

    Map<String, dynamic> request = {
      "serviceId": serviceId,
      "header": {
        "serviceUUID": serviceUUID,
        "serviceType": "DataService",
        "serviceMode": "Development",
        "transMode": transMode,
        "rowsPerPage": 1
      },
      "data": [{
        "study_oid": studyOid,
        "site_id": siteId,
        "person_id": personId,
        "person_nm": personNm,
        "visit_occurrence_id": visitOccurrenceId,
        "visit_detail_id": visitDetailId,
        "crf": [
          {
            "form_name": formName,
            "form_repeatkey": "1",
            "PS": psList
          }
        ]
      }]
    };

    return (request, serviceUUID);
  }
}
