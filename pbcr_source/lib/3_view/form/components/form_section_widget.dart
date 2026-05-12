import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

import '../form_view_type.dart';
import 'form_question_widget.dart';

class FormSectionWidget extends StatelessWidget {
  final TextEditingController Function(String) getTextController;
  final String? Function(String) getAnswer;
  final Set<String> enabledQuestionSet;
  final Function(String, String) onChangeAnswer;
  final Function(String) onTapQuestion;
  final bool isReadOnly;
  final bool Function(String) isMandatory;
  final String title;
  final String description;
  final String highlighted;

  final List<FormQuestion> formQuestionList;

  const FormSectionWidget({
    super.key,
    required this.formQuestionList,
    required this.getTextController,
    this.isReadOnly = false,
    required this.onChangeAnswer,
    required this.getAnswer,
    required this.onTapQuestion,
    required this.isMandatory,
    required this.enabledQuestionSet,
    this.title = '',
    this.description = '',
    this.highlighted = ''
  });

  // List<FormQuestion> get enabledFormQuestionList {
  //   return formQuestionList.where((el) => enabledQuestionSet.contains(el.key)).toList();
  // }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(isReadOnly)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withAlpha(30),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text("제출 완료되어, 내용을 수정할 수 없습니다.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.redAccent)
                ),
              )
            ),
          if(title.isNotEmpty || description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  if(title.isNotEmpty)
                    Text(title, style: TextStyles.body1.semiBold.primaryColor(context)),
                  if(description.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.withAlpha(30),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(description.replaceAll('\\n', '\n'), style: TextStyles.body2.primaryColor(context)),
                    )
                ]
              )
            ),
            ...formQuestionList.map((formQuestion) => FormQuestionWidget(
              formQuestion: formQuestion,
              answer: getAnswer(formQuestion.key),
              textController: getTextController(formQuestion.key),
              isReadOnly: isReadOnly,
              isEnabled: enabledQuestionSet.contains(formQuestion.key),
              isMandatory: isMandatory(formQuestion.key),
              isHighlighted: formQuestion.key == highlighted,
              onChangeAnswer: onChangeAnswer,
              onTap: onTapQuestion,
            ))
        ],
      ),
    );
  }
}
