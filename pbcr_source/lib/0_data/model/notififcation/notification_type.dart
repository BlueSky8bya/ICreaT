import 'package:flutter/material.dart';

enum NotificationType {
  visit,
  general,
  system,
  push,
  reminder,
  urgent,
  followUp,
  announcement;

  String get title {
    switch (this) {
      case NotificationType.visit:
        return '방문';
      case NotificationType.general:
        return '일반';
      case NotificationType.system:
        return '시스템';
      case NotificationType.push:
        return '푸시';
      case NotificationType.reminder:
        return '알림';
      case NotificationType.urgent:
        return '긴급';
      case NotificationType.followUp:
        return '후속';
      case NotificationType.announcement:
        return '공지';
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationType.visit:
        return Icons.calendar_today;
      case NotificationType.general:
        return Icons.info;
      case NotificationType.system:
        return Icons.settings;
      case NotificationType.push:
        return Icons.notifications;
      case NotificationType.reminder:
        return Icons.alarm;
      case NotificationType.urgent:
        return Icons.priority_high;
      case NotificationType.followUp:
        return Icons.follow_the_signs;
      case NotificationType.announcement:
        return Icons.announcement;
    }
  }

  static NotificationType fromString(String value) {
    switch (value.toUpperCase()) {
      case 'VISIT':
        return NotificationType.visit;
      case 'GENERAL':
        return NotificationType.general;
      case 'SYSTEM':
        return NotificationType.system;
      case 'PUSH':
        return NotificationType.push;
      case 'REMINDER':
        return NotificationType.reminder;
      case 'ANNOUNCEMENT':
        return NotificationType.announcement;
      default:
        return NotificationType.general;
    }
  }

  String toServerString() {
    switch (this) {
      case NotificationType.visit:
        return 'VISIT';
      case NotificationType.general:
        return 'GENERAL';
      case NotificationType.system:
        return 'SYSTEM';
      case NotificationType.push:
        return 'PUSH';
      case NotificationType.reminder:
        return 'REMINDER';
      case NotificationType.urgent:
        return 'URGENT';
      case NotificationType.followUp:
        return 'FOLLOW_UP';
      case NotificationType.announcement:
        return 'ANNOUNCEMENT';
    }
  }
}
