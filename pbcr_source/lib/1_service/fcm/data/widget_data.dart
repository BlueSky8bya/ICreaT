import 'package:flutter/material.dart';

typedef WidgetGenerator = Widget Function();

class WidgetData {
  WidgetData({
    required this.builder,
    this.argument,
  });

  final WidgetGenerator builder;
  dynamic argument;
}

class TimeForDisplay {
  final String second;
  final String minute;
  final String hour;

  TimeForDisplay({
    required this.second,
    required this.minute,
    required this.hour,
  });

  @override
  String toString() =>
      'TimeForDisplay(second: $second, minute: $minute, hour: $hour)';
}
