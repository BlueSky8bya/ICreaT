import 'dart:async';
import 'dart:collection';

import 'package:icreat_dct/8_extension/string_ext.dart';
import 'package:synchronized/synchronized.dart';

import '../form_view_type.dart';

typedef ProcFunc = Future<bool> Function(FormQuestion, String);
typedef FetchQuestionFunc = FormQuestion? Function(String);

class FormAnswerOnSubmit {
  final String itemUid;
  final String answer;

  FormAnswerOnSubmit({
    required this.itemUid,
    required this.answer
  });
}

class FormAnswerQueueManager {
  final Queue<FormAnswerOnSubmit> _queue = Queue<FormAnswerOnSubmit>();
  final Lock _lock = Lock();

  void push(String? itemUid, dynamic answer) {
    if (!itemUid.isNullOrEmpty) {
      _queue.add(FormAnswerOnSubmit(
        itemUid: itemUid!,
        answer: answer.toString(),
      ));
    }
  }

  (String, String, bool) pop() {
    if (_queue.isEmpty) {
      return ("","", false);
    }
    var el = _queue.removeFirst();
    return (el.itemUid, el.answer, true);
  }

  Future<bool> processFirst(FetchQuestionFunc fetchFormQuestion, List<ProcFunc> procFuncList) async {
    var (itemUid, answer, ok) = pop();
    if (!ok){
      return false; // no more task in queue
    }

    for (var procFunc in procFuncList) {
      var formQuestion = fetchFormQuestion(itemUid);
      if (formQuestion == null) {
        break;
      }

      if (!await procFunc(formQuestion, answer)) { // if return false abort
        break;
      }
    }

    return true;
  }

  Future<int> processAll({
    required FetchQuestionFunc fetchFormQuestion,
    required List<ProcFunc> procFuncList,
  }) async {
    return _lock.synchronized(() async {
      int numTask = 0;
      while(await processFirst(fetchFormQuestion, procFuncList)) {
        numTask++;
      }
      return numTask;
    });
  }
}