import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreat_dct/3_view/components/appbar/common_app_bar.dart';
import 'package:icreat_dct/3_view/components/button/solid_button.dart';
import 'package:icreat_dct/3_view/components/constants/box_shadows.dart';
import 'package:icreat_dct/3_view/components/layout/safe_scaffold.dart';
import 'package:icreat_dct/3_view/components/picker/time_picker.dart';
import 'package:icreat_dct/3_view/components/text_field/outline_text_field.dart';
import 'package:icreat_dct/3_view/navbar/myinfo/local_notification/local_notification_add_view_model.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

class LocalNotificationAddView extends GetView<LocalNotificationViewModel> {
  const LocalNotificationAddView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeScaffold(
        appBar: CommonAppBar.title(context, title: '알림 추가'),
        backgroundColor: context.bgPrimaryHoverPressed,
        child: Column(
          spacing: 16,
          children: [
            ScrollTimePicker(
              initialTime: controller.selectedTimeOfDay,
              onTimeChanged: (time) => controller.setScheduleTime(time),
              minuteInterval: 1,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: context.bgPrimary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  boxShadow: BoxShadows.shadow4,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            spacing: 16,
                            children: [
                              OutlineTextField(
                                controller: controller.titleController,
                                label: Text('제목',
                                    style: TextStyles.body2.medium
                                        .tertiaryColor(context)),
                                maxLines: 1,
                                maxLength: 20,
                              ),
                              OutlineTextField(
                                controller: controller.descriptionController,
                                label: Text('설명',
                                    style: TextStyles.body2.medium
                                        .tertiaryColor(context)),
                                maxLines: 3,
                                maxLength: 100,
                              ),
                              SolidButton(
                                onTap: () => controller.openRepeatSetting(
                                  context,
                                ),
                                text: '반복 설정',
                              ).expand.large.tertiary(context),
                            ],
                          ),
                        ),
                      ),
                      SolidButton(
                        onTap: () =>
                            controller.createLocalNotificationRule(context),
                        text: '알림 추가',
                      ).expand.large,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
