import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:icreat_dct/0_data/model/local_notification/week_day.dart';
import 'package:icreat_dct/0_data/dto/local_notification/local_notification_rule_create_req.dart';
import 'package:icreat_dct/1_service/local_notification_service.dart';
import 'package:icreat_dct/3_view/components/bottom_sheet/base_cmn_bottom_sheet_button_item.dart';
import 'package:icreat_dct/3_view/components/bottom_sheet/cmn_bottom_sheet.dart';
import 'package:icreat_dct/3_view/components/base_view_model.dart';

import 'components/notification_repeat_list_view.dart';

class LocalNotificationViewModel extends BaseViewModel {
  final LocalNotificationService _localNotificationService;

  LocalNotificationViewModel(this._localNotificationService);

  // state
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  TextEditingController get titleController => _titleController;
  TextEditingController get descriptionController => _descriptionController;

  final Rx<TimeOfDay> _selectedTimeOfDay = TimeOfDay.now().obs;
  TimeOfDay get selectedTimeOfDay => _selectedTimeOfDay.value;

  final RxSet<WeekDay> _selectedWeekDays = WeekDay.values.toSet().obs;
  Set<WeekDay> get selectedWeekDays => _selectedWeekDays.toSet();

  Future<void> _createLocalNotificationRule(BuildContext context) async {
    final req = _makePayload();

    final result = await _localNotificationService.scheduleNotiRule(
      title: req.title,
      description: req.description,
      startDate: req.startDate,
      endDate: req.endDate,
      timeOfDay: req.timeOfDay,
      weekdays: req.weekdays,
    );

    result
      ..onFailure((e) {})
      ..onSuccess((value) {
        if (value == LocalNotificationServiceResultCode.success) {
          context.pop();
        }
        if (value ==
            LocalNotificationServiceResultCode.maxNotiRuleCountExceeded) {
          showToast(context, msg: '알림은 최대 ${LocalNotificationService.maxNotiRuleCount}개까지 설정할 수 있습니다.');
        }
      });
  }

  LocalNotificationRuleCreateReq _makePayload() {
    return LocalNotificationRuleCreateReq(
      title: _titleController.text,
      description: _descriptionController.text,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 365)),
      timeOfDay: selectedTimeOfDay,
      weekdays: selectedWeekDays.map((e) => e.weekdayNumber).toList(),
    );
  }

  bool validate() {
    if (_titleController.text.isEmpty) {
      return false;
    }
    if (_descriptionController.text.isEmpty) {
      return false;
    }
    return true;
  }

  // action

  void setScheduleTime(TimeOfDay timeOfDay) {
    _selectedTimeOfDay.value = timeOfDay;
  }

  void openRepeatSetting(BuildContext context) {
    CMNBottomSheet.showBottomSheet(
      context,
      title: '반복 설정',
      content: Obx(
        () => WeekDayRepeatSelector(
          selectedWeekDays: selectedWeekDays,
          onTapWeekDay: toggleWeekDay,
        ),
      ),
      buttonList: [
        BaseCMNBottomSheetButtonItem(
          text: '닫기',
          onTap: () => context.pop(),
        ),
      ],
    );
  }

  void toggleWeekDay(WeekDay weekDay) {
    if (_selectedWeekDays.contains(weekDay)) {
      _selectedWeekDays.remove(weekDay);
    } else {
      _selectedWeekDays.add(weekDay);
    }
  }

  void createLocalNotificationRule(BuildContext context) {
    if (!validate()) {
      return;
    }
    _createLocalNotificationRule(context);
  }
}
