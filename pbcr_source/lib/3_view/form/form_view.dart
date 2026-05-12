import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/3_view/components/appbar/common_app_bar.dart';
import 'package:icreat_dct/3_view/components/button/solid_button.dart';
import 'package:icreat_dct/3_view/components/constants/svg_icons.dart';
import 'package:icreat_dct/3_view/components/layout/bottom_section.dart';
import 'package:icreat_dct/3_view/components/layout/safe_scaffold.dart';
import 'package:icreat_dct/3_view/components/wrapper/init_wrap.dart';
import 'package:icreat_dct/3_view/components/wrapper/opacity_progress_wrap.dart';

import 'components/fading_list_view_widget.dart';
import 'components/form_progress_widget.dart';
import 'components/form_section_widget.dart';
import 'form_view_model.dart';

class FormView extends GetView<FormViewModel> {
  const FormView({super.key});

  @override
  Widget build(BuildContext context) {
    return InitWrap(
      controller: controller,
      builder: () => OpacityProgressWrap(
        controller: controller,
        child: SafeScaffold(
          appBar: CommonAppBar.title(
            context,
            title: '폼',
            actions: [
              Obx(() => IconButton(
                onPressed: controller.onPressedRotButton,
                icon: Transform.rotate(
                  angle: controller.isHorizontalScroll ? 0 : math.pi / 2,
                  child: SvgIcons.arrowRange.iconBuilder(
                    size: 24,
                    color: context.textPrimary,
                  ),
                ),
              )),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => FormProgressWidget(
                numSection: controller.numPage,
                numCurrentSection: (controller.currentPageIndex + 1),
                numQuestion: controller.numQuestion,
                numTotalQuestion: controller.numTotalQuestion,
                numAnswer: controller.numAnswer,
              )),
              const SizedBox(height: 2),
              Expanded(
                child: Obx(() => PageView.builder(
                  controller: controller.pageController,
                  itemCount: controller.numPage,
                  scrollDirection: controller.isHorizontalScroll ? Axis.horizontal : Axis.vertical,
                  itemBuilder: (_, index) { // index == page
                    final formQuestionList = controller.getQuestionListByGroupIndex(index);
                    final (title, desc) = controller.getSectionTitleDesc(index);
                    return Obx(() => FadingListViewWidget(
                      threshold: 20,
                      children: [FormSectionWidget(
                        key: ValueKey(controller.sectionWidgetKey),
                        isReadOnly: controller.isReadOnly,
                        formQuestionList: formQuestionList,
                        title: title,
                        description: desc,
                        getTextController: controller.getTextController,
                        onChangeAnswer: controller.onChangeAnswer,
                        getAnswer: controller.getAnswer,
                        onTapQuestion: controller.onTapFormQuestion,
                        enabledQuestionSet: controller.enabledQuestionSet,
                        isMandatory: controller.isMandatory,
                        highlighted: controller.highlightedItemUid,
                      )]));
                  },
                )),
              ),
              Obx(() => BottomSection(
                isHorizontal: true,
                children: [
                  SolidButton(
                    leadingIcon: Icon(Icons.chevron_left, color: Colors.white, size: 16),
                    text: "이전 페이지",
                    color: Colors.blueAccent.withAlpha(220),
                    highlightColor: Colors.blueAccent,
                    onTap: controller.isFirstPage ? null : controller.moveToPrev,
                  ).expand.large,
                  if (!controller.isLastPage)
                    SolidButton(
                      followingIcon: Icon(Icons.chevron_right, color: Colors.white, size: 16),
                      text: "다음 페이지",
                      color: Colors.blueAccent.withAlpha(220),
                      highlightColor: Colors.blueAccent,
                      onTap: controller.moveToNext,
                    ).expand.large,
                  if (controller.isLastPage && controller.isReadOnly)
                    SolidButton(
                      followingIcon: Icon(Icons.chevron_right, color: Colors.white, size: 16),
                      text: "다음 페이지",
                      color: Colors.blueAccent.withAlpha(220),
                      highlightColor: Colors.blueAccent,
                      onTap: null,
                    ).expand.large,
                  if (controller.isLastPage && !controller.isReadOnly)
                    SolidButton(
                      text: controller.submitButtonText,
                      onTap: controller.onTapPreview,
                    ).expand.large,
                  ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
