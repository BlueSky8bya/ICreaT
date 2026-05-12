import 'package:flutter/material.dart';

import 'package:icreat_dct/3_view/components/button/solid_button.dart';
import 'package:icreat_dct/3_view/components/layout/bottom_section.dart';
import 'package:icreat_dct/3_view/components/dialog/confirm_dialog.dart';

import '../form_view_type.dart';

class FormReviewSectionWidget extends StatelessWidget {
  final FormSubmitPreviewGroup section;

  const FormReviewSectionWidget({
    super.key,
    required this.section,
  });

  bool get hasContent => section.itemList.any((el) => el.isEnabled);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (section.itemGroupName.isNotEmpty)
          ...[
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(section.itemGroupName),
            ),
            SizedBox(height: 4)
          ],
          Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: Colors.black26,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 16,
                children: [
                  if (!hasContent)
                    Text('(작성 내용 없음)', style: TextStyle(color: Colors.grey)),
                  for (var question in section.itemList)
                    if (question.isEnabled)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: 4,
                        children: [
                          Text.rich(TextSpan(
                            children: [
                              TextSpan(text: question.question),
                              if (question.isMandatory)
                                TextSpan(text: ' *', style: TextStyle(color: Colors.redAccent)),
                            ]
                          )),
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: (question.answer.isEmpty) ? Text('(작성 내용 없음)', style: TextStyle(color: Colors.grey)) : Text(question.answer),
                          ),
                        ],
                      ),
                ],
              ),
            )
          ),
        ]
      ),
    );
  }
}

class FormReviewDialog extends StatelessWidget {
  final BuildContext context;
  final VoidCallback? onSubmit;
  final VoidCallback? onCancel;
  final List<FormSubmitPreviewGroup> answerList;

  const FormReviewDialog({
    super.key,
    required this.context,
    required this.answerList,
    this.onSubmit,
    this.onCancel,
  });

  void onSubmitInner() {
    Navigator.pop(context);
    onSubmit?.call();
  }

  void onCancelInner() {
    Navigator.pop(context);
    onCancel?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.white,
      insetAnimationCurve: Curves.easeOut,
      insetAnimationDuration: Duration.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            leading: Icon(Icons.spellcheck, size: 32),
            textColor: Colors.black87,
            title: Text('수행 내역 검토'),
            subtitle: Text('아래 수행 내역을 검토해주세요.'),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 8,
                children: answerList.map((el) => FormReviewSectionWidget(section: el)).toList()
              ),
            ),
          ),
          BottomSection(
            isHorizontal: true,
            children: [
              SolidButton(
                text: '취소',
                color: Colors.black12,
                highlightColor: Colors.black26,
                textColor: Colors.black45,
                onTap: onCancelInner
              ).expand.large,
              SolidButton(
                text: '제출',
                onTap: () => showDialog<String>(
                  context: context,
                  barrierColor: Colors.transparent,
                  builder: (BuildContext _) {
                    return ConfirmDialog(
                      title: "제출하시겠습니까?",
                      message: "수행 내역을 제출하시겠습니까?",
                      ok: "제출합니다.",
                      onOk: onSubmitInner,
                    );
                  }
                ),
              ).expand.large
            ]
          ),
        ],
      ),
    );
  }
}