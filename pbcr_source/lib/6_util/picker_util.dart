import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:go_router/go_router.dart';
import 'package:icreat_dct/3_view/components/bottom_sheet/base_cmn_bottom_sheet_button_item.dart';
import 'package:icreat_dct/3_view/components/bottom_sheet/cmn_bottom_sheet.dart';
import 'package:icreat_dct/3_view/components/button/base/button_color_set.dart';
import 'package:icreat_dct/3_view/components/calendar/monthly_calendar.dart';
import 'package:icreat_dct/constants.dart';

class PickerUtil {
  static Future<DateTime?> showDatePicker(
    BuildContext context, {
    required DateTime initFocusedDate,
    DateTime? initSelectedDate,
  }) async {
    final Rx<DateTime?> selectedDate = Rx(initSelectedDate);
    final Rx<DateTime?> focusedDate = Rx(initFocusedDate);

    final result = (await CMNBottomSheet.showBottomSheet(
          context,
          title: '월간 일정',
          content: MonthlyCalendarWidget(
            focusedDay: initFocusedDate,
            selectedDay: initSelectedDate,
            firstDay: Constants.FIRST_DATETIME,
            lastDay: Constants.LAST_DATETIME,
            onFocusedDayChanged: (value) => focusedDate.value = value,
            onDaySelected: (value) => selectedDate.value = value,
          ),
          buttonList: [
            BaseCMNBottomSheetButtonItem(
              text: '닫기',
              onTap: () => context.pop(false),
            ),
            BaseCMNBottomSheetButtonItem(
              text: '선택',
              colorSet: ButtonColorSet.primary,
              onTap: () => context.pop(true),
            ),
          ],
        ) ??
        false);

    return result ? selectedDate.value : null;
  }
}
