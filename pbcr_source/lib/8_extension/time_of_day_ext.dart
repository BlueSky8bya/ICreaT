import 'package:flutter/material.dart';

extension TimeOfDayExt on TimeOfDay {
  String get ampm {
    if (hour < 12) {
      return '오전';
    } else {
      return '오후';
    }
  }

  (int, int) get hourMinute12 {
    if (hour == 0) {
      return (12, minute);
    } else if (hour > 12) {
      return (hour - 12, minute);
    } else {
      return (hour, minute);
    }
  }
}