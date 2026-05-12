import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreat_dct/0_data/model/local_notification/week_day.dart';
import 'package:icreat_dct/3_view/components/appbar/common_app_bar.dart';
import 'package:icreat_dct/3_view/components/button/solid_button.dart';
import 'package:icreat_dct/3_view/components/layout/bottom_section.dart';
import 'package:icreat_dct/3_view/components/layout/safe_scaffold.dart';
import 'package:icreat_dct/3_view/navbar/myinfo/local_notification/local_notification_list_view_model.dart';
import 'package:icreat_dct/8_extension/time_of_day_ext.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

class LocalNotificationListView
    extends GetView<LocalNotificationListViewModel> {
  const LocalNotificationListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      appBar: CommonAppBar.title(
        context,
        title: '알림 목록',
        actions: [
          // 추가
          IconButton(
            onPressed: () => controller.navigateToAdd(context),
            icon: const Icon(Icons.add),
          ),
          // 삭제
          IconButton(
            onPressed: () => controller.toggleDeleteMode(),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(
                  () => Column(
                    spacing: 16,
                    children: [
                      ...controller.localNotifications
                          .map((e) => _NotificationCard(
                                id: e.id,
                                title: e.title,
                                description: e.description,
                                weekDays: e.weekdays
                                    .map((e) => WeekDay.fromInt(e))
                                    .toList(),
                                scheduledTime: e.timeOfDay,
                                isDeleteMode: controller.isDeleteMode,
                                isDeleteChecked:
                                    controller.selectedIds.contains(e.id),
                                onTapDeleteCheck: () =>
                                    controller.toggleDeleteCheck(e.id),
                                // onTapCard: () => controller.navigateToEdit(context, e),
                              )),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Obx(() {
            if (!controller.isDeleteMode) {
              return const SizedBox.shrink();
            }
            return BottomSection(
              isHorizontal: true,
              children: [
                SolidButton(
                  onTap: () => controller.toggleDeleteMode(),
                  text: '취소',
                ).expand.large.tertiary(context),
                SolidButton(
                  onTap: () => controller.deleteNotification(context),
                  text: '삭제',
                ).expand.large.error(context),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final int id;
  final String title;
  final String description;
  final List<WeekDay> weekDays;
  final TimeOfDay scheduledTime;

  final bool isDeleteMode;
  final bool isDeleteChecked;

  final VoidCallback? onTapDeleteCheck;

  const _NotificationCard({
    required this.id,
    required this.title,
    required this.description,
    required this.weekDays,
    required this.scheduledTime,
    required this.isDeleteMode,
    required this.isDeleteChecked,
    this.onTapDeleteCheck,
  });

  BoxDecoration _boxDecoration(BuildContext context) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: context.borderPrimary,
      ),
    );
  }

  String get _ampm => scheduledTime.ampm;
  String get _hourMinute12 {
    final (int hour, int minute) = scheduledTime.hourMinute12;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _boxDecoration(context),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDeleteMode ? onTapDeleteCheck : null,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 16,
              children: [
                // 체크박스
                if (isDeleteMode)
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: isDeleteChecked,
                      onChanged: (value) => onTapDeleteCheck?.call(),
                      shape: CircleBorder(),
                      activeColor: context.textDanger,
                      checkColor: Colors.white,
                      side: BorderSide(
                        color: context.textDanger,
                      ),
                    ),
                  ),
                // 아이템 정보
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        spacing: 4,
                        children: [
                          Text(_ampm,
                              style: TextStyles.headline3.bold
                                  .primaryColor(context)),
                          Text(_hourMinute12,
                              style: TextStyles.headline1
                                  .primaryColor(context)),
                        ],
                      ),
                      Text(weekDays
                          .sorted((a, b) => a.index.compareTo(b.index))
                          .map((e) => e.shortName)
                          .join(', ')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
