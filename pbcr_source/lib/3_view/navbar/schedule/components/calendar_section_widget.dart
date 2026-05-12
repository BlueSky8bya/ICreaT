import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:icreat_dct/3_view/components/bottom_sheet/base_cmn_bottom_sheet_button_item.dart';
import 'package:icreat_dct/3_view/components/bottom_sheet/cmn_bottom_sheet.dart';
import 'package:icreat_dct/3_view/components/button/base/button_color_set.dart';
import 'package:icreat_dct/3_view/components/button/opacity_widget_button.dart';
import 'package:icreat_dct/3_view/components/button/solid_button.dart';
import 'package:icreat_dct/3_view/components/calendar/components/day_tile/event_day_tile_builder.dart';
import 'package:icreat_dct/3_view/components/calendar/components/day_tile/weekly_day_tile_builder.dart';
import 'package:icreat_dct/3_view/components/calendar/monthly_calendar.dart';
import 'package:icreat_dct/3_view/components/constants/box_shadows.dart';
import 'package:icreat_dct/3_view/components/constants/svg_icons.dart';
import 'package:icreat_dct/3_view/navbar/schedule/schedule_view_model.dart';
import 'package:icreat_dct/8_extension/date_time_ext.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';


class CalendarSectionWidget extends StatelessWidget {
  final ScheduleViewModel controller;

  const CalendarSectionWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: BoxShadows.shadow2,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => CalendarHeader(
                  focusedDate: controller.selectedDate,
                  onTapToday: controller.onTapToday,
                  onTapMonthlyCalendar: () {
                    CMNBottomSheet.showBottomSheet(
                      context,
                      title: '월간 일정',
                      content: Obx(
                        () => Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 16,
                          children: [
                            Text(
                              '${controller.focusedDate.year}년 ${controller.focusedDate.month}월',
                              style:
                                  TextStyles.body1.bold.primaryColor(context),
                            ),
                            MonthlyCalendarWidget(
                              focusedDay: controller.focusedDate,
                              selectedDay: controller.focusedDate,
                              firstDay: controller.schedulePeriod.start,
                              lastDay: controller.schedulePeriod.end,
                              dayTileBuilder: EventDayTileBuilder(
                                getSchedule: controller.getSchedules,
                              ),
                              onDaySelected: controller.onDaySelected,
                              onFocusedDayChanged:
                                  controller.onFocusedDayChanged,
                            ),
                          ],
                        ),
                      ),
                      buttonList: [
                        BaseCMNBottomSheetButtonItem(
                          text: '닫기',
                          onTap: () {
                            context.pop();
                          },
                        ),
                        BaseCMNBottomSheetButtonItem(
                          text: '선택',
                          colorSet: ButtonColorSet.primary,
                          onTap: () {
                            controller.onTapDateSelected();
                            context.pop();
                          },
                        ),
                      ],
                    );
                  },
                )),
            const SizedBox(height: 8),
            Obx(() => MonthlyCalendarWidget(
                  key: Key(controller.scheduleListUpdateKey),
                  firstDay: controller.schedulePeriod.start,
                  lastDay: controller.schedulePeriod.end,
                  selectedDay: controller.selectedDate,
                  focusedDay: controller.focusedDate,
                  onDaySelected: controller.onDaySelectedWeek,
                  onFocusedDayChanged: controller.onFocusedDayChangedWeek,
                  calendarFormat: CalendarFormat.week,
                  dayTileBuilder: WeeklyDayTileBuilder(
                    getSchedule: controller.getSchedules,
                  ),
                )),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class CalendarHeader extends StatelessWidget {
  final DateTime focusedDate;
  final VoidCallback onTapToday;
  final VoidCallback onTapMonthlyCalendar;

  const CalendarHeader({
    super.key,
    required this.focusedDate,
    required this.onTapToday,
    required this.onTapMonthlyCalendar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(focusedDate.toKoreanYMD(), style: TextStyles.body1.semiBold),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 12,
            children: [
              OpacityWidgetButton.noDebounce(
                onTap: (_) => onTapMonthlyCalendar(),
                child: SvgIcons.calendar.iconBuilder(
                  size: 24,
                  color: context.textPrimary,
                ),
              ),
              SolidButton(
                text: '오늘',
                onTap: onTapToday,
              ).outline(context),
            ],
          ),
        ],
      ),
    );
  }
}
