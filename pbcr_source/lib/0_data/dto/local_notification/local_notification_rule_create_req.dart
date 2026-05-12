import 'package:flutter/material.dart';

class LocalNotificationRuleCreateReq {
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final TimeOfDay timeOfDay;
  final List<int> weekdays;

  LocalNotificationRuleCreateReq({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.timeOfDay,
    required this.weekdays,
  });
}