import 'package:flutter/widgets.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';


class FormAnswerState {
  final String? prevAnswer; // 기존에 제출된 이전 답변(읽기 모드, 수정 모드)
  final String? currAnswer; // 현재 입력중인 답변(수정 모드, 생성 모드)
  final TextEditingController? textController;

  FormAnswerState({
    required this.prevAnswer,
    required this.currAnswer,
    required this.textController,
  });
}

class FormAnswerStateManager {
  // key = item_uid, value = 객관식인 경우 FormOption의 key, 주관식인 경우 내용
  final RxMap<String, FormAnswerState> _answerStateMap = RxMap();

  Map<String, String> get answerMap {
    return Map<String, String>.fromEntries(
      _answerStateMap.entries
          .where((el) => el.value.currAnswer != null)
          .map((el) => MapEntry(el.key, el.value.currAnswer!)),
    );
  }

  List<String> get answeredList => _answerStateMap.entries
      .where((el) => el.value.currAnswer != null)
      .map((el) => el.key)
      .toList();

  void addNewState(String itemUid, {
    String? prevAnswer,
    String? currAnswer,
    TextEditingController? textController,
  }){
    //Logger.debug("added answerStateMap $itemUid");
    _answerStateMap[itemUid] = FormAnswerState(
      prevAnswer: prevAnswer,
      currAnswer: currAnswer,
      textController: textController,
    );
  }

  void clear(String itemUid) {
    if (_answerStateMap.containsKey(itemUid)) {

      var tc = _answerStateMap[itemUid]!.textController;
      tc?.clear();

      _answerStateMap[itemUid] = FormAnswerState(
        prevAnswer: _answerStateMap[itemUid]!.prevAnswer,
        currAnswer: null,
        textController: tc,
      );
    }
  }

  void setAnswer(String itemUid, String answer) {
    if (_answerStateMap.containsKey(itemUid)) {
      _answerStateMap[itemUid] = FormAnswerState(
        prevAnswer: _answerStateMap[itemUid]!.prevAnswer,
        currAnswer: answer,
        textController: _answerStateMap[itemUid]!.textController,
      );
    }
  }

  String? getAnswer(String itemUid) {
    return _answerStateMap[itemUid]?.currAnswer;
  }

  TextEditingController? getTextController(String itemUid) {
    return _answerStateMap[itemUid]?.textController;
  }

  void disposeAllTextControllers() {
    _answerStateMap.forEach((key,el) {
      el.textController?.dispose();
    });
  }
}

