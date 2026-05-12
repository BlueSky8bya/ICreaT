import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

class FormStatusChipWidget extends StatelessWidget {
  final String label;
  final Color? color;

  const FormStatusChipWidget({
    super.key,
    required this.label,
    this.color = const Color(0x6082B1FF), // blueAccent with alpha(0x60)
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: color,
      visualDensity: VisualDensity(horizontal: 0.0, vertical: -4),
      padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
      labelPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        side: BorderSide(color: Colors.black.withAlpha(0), width: 0.0),
      ),
      label: Text(
        label,
        style: TextStyles.body2.primaryColor(context),
      ),
    );
  }
}

class FormProgressWidget extends StatelessWidget {
  final int numSection;
  final int numQuestion;
  final int numCurrentSection;
  final int numTotalQuestion;
  final int numAnswer;

  const FormProgressWidget({
    super.key,
    required this.numSection,
    required this.numQuestion,
    required this.numTotalQuestion,
    required this.numCurrentSection,
    required this.numAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(8, 0, 0, 4),
                child: Row(spacing: 4, children: [
                  if (numSection > 1)
                    FormStatusChipWidget(
                      label: "현재 $numCurrentSection",
                      color: Colors.redAccent.withAlpha(0x40)),
                  FormStatusChipWidget(
                    label: "전체쪽 $numSection",
                    color: Colors.redAccent.withAlpha(0x40))
                ]),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 8, 4),
                child: Row(spacing: 4, children: [
                  FormStatusChipWidget(label: "응답 $numAnswer"),
                  FormStatusChipWidget(label: "활성 $numQuestion"),
                  FormStatusChipWidget(label: "전체 $numTotalQuestion"),
                ])),
            ],
          ),
          (numSection > 1)
              ? StepProgressIndicator(
                totalSteps: numSection,
                currentStep: numCurrentSection,
                selectedColor: Colors.blueAccent.withAlpha(60),
                unselectedColor: Colors.black.withAlpha(40),
                padding: 0.5,
                size: 2)
              : SizedBox(height: 2)
        ],
      ));
  }
}
