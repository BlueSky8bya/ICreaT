import 'package:flutter/material.dart';

import 'package:icreat_dct/4_router/route_type.dart';

enum NavBarType {
  schedule,
  measurement,
  alarm,
  myInfo,
}

extension NavBarTypeExt on NavBarType {
  String get label {
    switch (this) {
      case NavBarType.schedule:
        return '일정';
      case NavBarType.measurement:
        return '측정';
      case NavBarType.alarm:
        return '알림';
      case NavBarType.myInfo:
        return '내 정보';
    }
  }

  String get name {
    switch (this) {
      case NavBarType.schedule:
        return RouteType.schedule.name;
      case NavBarType.measurement:
        return RouteType.measurement.name;
      case NavBarType.alarm:
        return RouteType.alarm.name;
      case NavBarType.myInfo:
        return RouteType.myInfo.name;
    }
  }

  Widget get unselectedIcon {
    switch (this) {
      case NavBarType.schedule:
        return const Icon(Icons.event_available_outlined);
      case NavBarType.measurement:
        return const Icon(Icons.favorite_border);
      case NavBarType.alarm:
        return const Icon(Icons.notifications_none);
      case NavBarType.myInfo:
        return const Icon(Icons.person_outline);
    }
  }

  Widget get selectedIcon {
    switch (this) {
      case NavBarType.schedule:
        return const Icon(Icons.event_available_rounded);
      case NavBarType.measurement:
        return const Icon(Icons.favorite);
      case NavBarType.alarm:
        return const Icon(Icons.notifications);
      case NavBarType.myInfo:
        return const Icon(Icons.person);
    }
  }

  static NavBarType getNavbarTapFromPath(String fullPath) {
    if (fullPath.contains(RouteType.schedule.path)) {
      return NavBarType.schedule;
    }

    if (fullPath.contains(RouteType.measurement.path)) {
      return NavBarType.measurement;
    }

    if (fullPath.contains(RouteType.alarm.path)) {
      return NavBarType.alarm;
    }

    if (fullPath.contains(RouteType.myInfo.path)) {
      return NavBarType.myInfo;
    }
    return NavBarType.schedule;
  }
}
