import 'package:flutter/material.dart';
import 'package:icreat_dct/8_extension/date_time_ext.dart';
import 'package:icreat_dct/theme/theme_color.dart';
import 'package:icreat_dct/theme/theme_color_hue.dart';

class DateTextColorUtil {
  static const ThemeColor _weekdayColor = ThemeColorHue.textPrimary;
  static const ThemeColor _saterdayColor = ThemeColorHue.textInfo;
  static const ThemeColor _sundayColor = ThemeColorHue.textDanger;
  static const ThemeColor _holidayColor = ThemeColorHue.textDanger;

  static Color getDateColor(DateTime date, BuildContext context) {
    if (HolidayManager.isHoliday(date)) {
      return _holidayColor.getColor(context);
    }
    if (date.weekday == DateTime.saturday) {
      return _saterdayColor.getColor(context);
    }
    if (date.weekday == DateTime.sunday) {
      return _sundayColor.getColor(context);
    }
    return _weekdayColor.getColor(context);
  }
}

class HolidayManager {
  /// 공휴일을 저장하는 리스트
  /// 형식은 무조건 hour, minute, second가 0인 DateTime이어야 한다.
  static final List<DateTime> _holidayList = [];

  /// date를 받아서 hour, minute, second를 0으로 만들어서 _holidayList에 추가한다.
  static bool isHoliday(DateTime date) {
    return _holidayList.contains(date.toLocalize());
  }
}
