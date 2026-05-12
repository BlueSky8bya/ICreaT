import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:icreat_dct/3_view/components/box/outline_box_widget.dart';
import 'package:icreat_dct/3_view/components/bottom_sheet/base_cmn_bottom_sheet_button_item.dart';
import 'package:icreat_dct/3_view/components/bottom_sheet/cmn_bottom_sheet.dart';
import 'package:icreat_dct/3_view/components/button/base/button_color_set.dart';
import 'package:icreat_dct/3_view/components/calendar/monthly_calendar.dart';
import 'package:icreat_dct/8_extension/date_time_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

import 'package:icreat_dct/constants.dart';


class FormSelectDateWidget extends StatelessWidget {
  final String? selectedDate;
  final bool isReadOnly;
  final Function(String) onChangeAnswer;
  final String? hintText;
  final String dateFormat;

  final Rxn<DateTime> selectedDateInAction = Rxn<DateTime>(null);
  final Rx<DateTime> focusedDateInAction = DateTime.now().obs;

  FormSelectDateWidget(
      {super.key,
      this.selectedDate,
      required this.onChangeAnswer,
      this.isReadOnly = false,
      this.hintText,
      this.dateFormat = "yyyy-MM-dd"});

  DateTime? get selectedDateTime =>
      selectedDate != null ? DateTime.tryParse(selectedDate!) : null;

  String get _displayText =>
      (selectedDateTime == null) ? '날짜를 선택해주세요' : selectedDateTime!.toDashYMD();

  @override
  Widget build(BuildContext context) {
    return OutlineBoxWidget(
      onTap: isReadOnly ? null : () => showDatePicker(context),
      child: Row(
        children: [
          if (selectedDate == null && hintText != null)
            Text(hintText!, style: TextStyles.body2.tertiaryColor(context)),
          if (selectedDate != null) Text(_displayText),
        ],
      ),
    );
  }

  void showDatePicker(BuildContext context) {
    selectedDateInAction.value = selectedDateTime;

    CMNBottomSheet.showBottomSheet(
      context,
      title: '날짜 선택',
      content: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              MonthlyCalendarWidget(
                focusedDay: focusedDateInAction.value,
                selectedDay: selectedDateInAction.value,
                firstDay: Constants.FIRST_DATETIME,
                lastDay: Constants.LAST_DATETIME,
                showHeader: true,
                onDaySelected: (date) {
                  selectedDateInAction.value = date.toLocalize();
                },
                onFocusedDayChanged: (date) {
                  focusedDateInAction.value = date.toLocalize();
                },
              ),
            ],
          )),
      buttonList: [
        BaseCMNBottomSheetButtonItem(
          text: '닫기',
          onTap: () {
            context.pop(false);
          },
        ),
        BaseCMNBottomSheetButtonItem(
          text: '선택',
          colorSet: ButtonColorSet.primary,
          onTap: () {
            if (selectedDateInAction.value != null) {
              onChangeAnswer(
                  DateFormat(dateFormat).format(selectedDateInAction.value!));
            }
            context.pop(true);
          },
        ),
      ],
    );
  }
}
