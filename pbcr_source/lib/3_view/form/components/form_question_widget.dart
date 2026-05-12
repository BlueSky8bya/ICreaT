import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';

import 'package:icreat_dct/3_view/form/components/form_select_checkbox_widget.dart';
import 'package:icreat_dct/3_view/form/components/form_select_date_widget.dart';
import 'package:icreat_dct/3_view/form/components/form_select_dropdown_widget.dart';
import 'package:icreat_dct/3_view/form/components/form_select_measurement_widget.dart';
import 'package:icreat_dct/3_view/form/components/form_select_radio_widget.dart';
import 'package:icreat_dct/3_view/form/components/form_select_text_area_widget.dart';
import 'package:icreat_dct/8_extension/string_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

import '../form_view_type.dart';

class FormQuestionWidget extends StatelessWidget {
  final FormQuestion formQuestion;
  final String? answer;
  final bool isReadOnly;
  final bool isEnabled;
  final Function(String, String) onChangeAnswer;
  final Function(String) onTap;
  final TextEditingController textController;
  final bool isMandatory;
  final bool isHighlighted;

  const FormQuestionWidget({
    super.key,
    required this.formQuestion,
    required this.textController,
    this.answer,
    required this.onChangeAnswer,
    required this.onTap,
    this.isReadOnly = false,
    this.isEnabled = false,
    this.isMandatory = false,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: (isEnabled && isHighlighted) ? Colors.red.withAlpha(20) : Colors.transparent,
      padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
      child: Row(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 24,
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            color: isEnabled ? Colors.blue.shade300 : Colors.black26,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(9, 0, 18, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 8,
                children: [
                  FormQuestionTitleWidget(
                    title: formQuestion.title,
                    description: formQuestion.description,
                    isMandatory: isMandatory,
                    isEnabled: isEnabled,
                  ),
                  if (isEnabled)
                    ...[
                      FormQuestionDetailWidget(
                        formQuestion: formQuestion,
                        textController: textController,
                        answer: answer,
                        isReadOnly: isReadOnly,
                        onChangeAnswer: (ans) async {
                          await onChangeAnswer(formQuestion.key, ans);
                        },
                        onTap: onTap,
                        debounce: 600,
                      ),
                      if (formQuestion.hasComment)
                        Text.rich(TextSpan(
                          style: TextStyle(color: Colors.black54, fontSize: 12, height: 1.3),
                          children: [
                            TextSpan(text: "※ "),
                            if (!formQuestion.commentHeader.isNullOrEmpty)
                              TextSpan(text: "${formQuestion.commentHeader!} ",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: formQuestion.commentBody ?? ''),
                          ]
                        ))
                    ],
                ]),
            ),
          )
        ],
      ));
  }
}

class FormQuestionTitleWidget extends StatelessWidget {
  final String title;
  final String description;
  final bool isMandatory;
  final bool isEnabled;

  const FormQuestionTitleWidget(
      {super.key,
      required this.title,
      this.description = '',
      this.isMandatory = false,
      this.isEnabled = false});

  bool get hasDescription => description.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        if (isEnabled) ...[
          Text.rich(TextSpan(
            style: TextStyles.body1.primaryColor(context),
            children: [
              TextSpan(text: title),
              if (isMandatory)
                TextSpan(text: ' *', style: TextStyle(color: Colors.redAccent)),
            ])),
          if (hasDescription)
            Text(description, style: TextStyles.body2.secondaryColor(context)),
        ] else ...[
          Text(title, style: TextStyles.body1.disabledColor(context)),
          if (hasDescription)
            Text(description, style: TextStyles.body2.disabledColor(context)),
        ]
      ],
    );
  }
}

class FormQuestionDetailWidget extends StatelessWidget {
  final FormQuestion formQuestion;
  final TextEditingController textController;

  final String? answer;
  final int debounce;

  final bool isReadOnly;
  final Future<void> Function(String) onChangeAnswer;
  final Function(String) onTap;

  const FormQuestionDetailWidget({
    super.key,
    required this.formQuestion,
    required this.textController,
    required this.onChangeAnswer,
    this.answer,
    this.isReadOnly = false,
    this.debounce = 0,
    required this.onTap,
  });

  void onChangeAnswerWithDebounce(dynamic value) {
    EasyDebounce.debounce('answer-debouncer', Duration(milliseconds: debounce),
        () async {
      await onChangeAnswer(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (formQuestion.type) {
      case FormSelectType.radio:
        return FormSelectRadioWidget(
          isReadOnly: isReadOnly,
          options: formQuestion.options,
          selectedOptionKey: answer,
          onChangeAnswer: onChangeAnswer,
        );
      case FormSelectType.checkbox:
        return FormSelectCheckboxWidget(
          isReadOnly: isReadOnly,
          options: formQuestion.options,
          selectedOptionKey: answer,
          onChangeAnswer: onChangeAnswer,
        );
      case FormSelectType.dropdown:
        return FormSelectDropdownWidget(
          isReadOnly: isReadOnly,
          options: formQuestion.options,
          selectedOptionKey: answer,
          onChangeAnswer: onChangeAnswer,
        );
      case FormSelectType.text:
        return FormSelectTextAreaWidget(
          isReadOnly: isReadOnly,
          controller: textController,
          textAreaType: TextAreaType.normal,
          onChangeAnswer: onChangeAnswerWithDebounce,
          hintText: formQuestion.placeholder,
          suffix: formQuestion.suffix,
        );
      case FormSelectType.multilineText:
        return FormSelectTextAreaWidget(
          isReadOnly: isReadOnly,
          controller: textController,
          textAreaType: TextAreaType.multiline,
          onChangeAnswer: onChangeAnswerWithDebounce,
          hintText: formQuestion.placeholder,
          suffix: formQuestion.suffix,
        );
      case FormSelectType.number:
        return FormSelectTextAreaWidget(
          isReadOnly: isReadOnly,
          controller: textController,
          textAreaType: TextAreaType.number,
          onChangeAnswer: onChangeAnswerWithDebounce,
          maxLength: 6,
          hintText: formQuestion.placeholder,
          suffix: formQuestion.suffix,
        );
      case FormSelectType.decimal:
        return FormSelectTextAreaWidget(
          isReadOnly: isReadOnly,
          controller: textController,
          textAreaType: TextAreaType.decimal,
          onChangeAnswer: onChangeAnswerWithDebounce,
          maxLength: 6,
          hintText: formQuestion.placeholder,
          suffix: formQuestion.suffix,
        );
      case FormSelectType.date:
        return FormSelectDateWidget(
          isReadOnly: isReadOnly,
          selectedDate: answer,
          onChangeAnswer: onChangeAnswer,
          hintText: formQuestion.placeholder,
        );
      case FormSelectType.measurement:
        return FormSelectMeasurementWidget(
          isReadOnly: isReadOnly,
          onChangeAnswer: onChangeAnswer,
          selectedAnswer: answer,
          onTap: () => onTap(formQuestion.key),
          placeholder: formQuestion.placeholder,
          suffix: formQuestion.suffix,
        );
    }
  }
}
