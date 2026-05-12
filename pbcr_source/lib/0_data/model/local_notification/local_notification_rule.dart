import 'package:flutter/material.dart';
import 'package:icreat_dct/8_extension/date_time_ext.dart';

class LocalNotificationRule {
  final int id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final TimeOfDay timeOfDay;

  /// 요일 모드일 때
  /// 1: 월요일, 2: 화요일, 3: 수요일, 4: 목요일, 5: 금요일, 6: 토요일, 7: 일요일
  final List<int> weekdays;

  /// 알림 규칙 생성 시 startDate, endDate는 시간을 제외한 날짜만 저장한다.
  /// 시간은 timeOfDay에 저장한다.
  LocalNotificationRule({
    required this.id,
    required this.title,
    required this.description,
    required DateTime startDate,
    required DateTime endDate,
    required this.timeOfDay,
    required this.weekdays,
  })  : startDate = startDate.toLocalize(),
        endDate = endDate.toLocalize();

  @override
  String toString() {
    return 'LocalNotificationRule(id: $id, title: $title, description: $description, startDate: $startDate, endDate: $endDate, timeOfDay: $timeOfDay, weekdays: $weekdays)';
  }
}
