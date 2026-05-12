import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:icreat_dct/3_view/navbar/myinfo/myinfo_view_model.dart';
import 'package:icreat_dct/3_view/navbar/notification/notification_view.dart';
import 'package:icreat_dct/3_view/navbar/measurement/measurement_view.dart';
import 'package:icreat_dct/3_view/navbar/measurement/measurement_view_model.dart';
import 'package:icreat_dct/3_view/navbar/myinfo/myinfo_view.dart';
import 'package:icreat_dct/3_view/navbar/nav_bar_view.dart';
import 'package:icreat_dct/3_view/navbar/nav_bar_view_model.dart';
import 'package:icreat_dct/3_view/navbar/notification/notification_view_model.dart';
import 'package:icreat_dct/3_view/navbar/schedule/schedule_view.dart';
import 'package:icreat_dct/3_view/navbar/schedule/schedule_view_model.dart';
import 'package:icreat_dct/4_router/route_type.dart';

/// 탭 라우트들을 초기화하고 반환합니다
///
/// [rootNavKey] - 루트 네비게이터 키
/// [shellNavKey] - 셸 네비게이터 키
///
/// Returns: List&lt;RouteBase&gt; - 탭 라우트 리스트
List<RouteBase> initTabRoutes(
  GlobalKey<NavigatorState> rootNavKey,
  GlobalKey<NavigatorState> shellNavKey,
) {
  return [
    ShellRoute(
      builder: (context, state, child) => GetBuilder(
        init: NavBarViewModel(
          context,
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find(),
        ),
        builder: (context) => NavBarView(child: child),
      ),
      routes: [
        _buildScheduleRoute(shellNavKey),
        _buildMeasurementRoute(shellNavKey),
        _buildAlarmRoute(shellNavKey),
        _buildMyInfoRoute(shellNavKey),
      ],
      parentNavigatorKey: rootNavKey,
      navigatorKey: shellNavKey,
    ),
  ];
}

/// 일정 탭 라우트를 생성합니다
GoRoute _buildScheduleRoute(GlobalKey<NavigatorState> shellNavKey) {
  return GoRoute(
    path: RouteType.schedule.path,
    name: RouteType.schedule.name,
    parentNavigatorKey: shellNavKey,
    pageBuilder: (context, state) => NoTransitionPage(
      child: GetBuilder<ScheduleViewModel>(
        init: ScheduleViewModel(
          Get.find(),
          Get.find(),
          Get.find(),
        ),
        autoRemove: false,
        builder: (controller) => const ScheduleView(),
      ),
    ),
  );
}

/// 측정 탭 라우트를 생성합니다
GoRoute _buildMeasurementRoute(GlobalKey<NavigatorState> shellNavKey) {
  return GoRoute(
    path: RouteType.measurement.path,
    name: RouteType.measurement.name,
    parentNavigatorKey: shellNavKey,
    pageBuilder: (context, state) => NoTransitionPage(
      child: GetBuilder<MeasurementViewModel>(
        init: MeasurementViewModel(
          Get.find(),
          Get.find(),
        ),
        autoRemove: false,
        builder: (controller) => const MeasurementView(),
      ),
    ),
  );
}

/// 알림 탭 라우트를 생성합니다
GoRoute _buildAlarmRoute(GlobalKey<NavigatorState> shellNavKey) {
  return GoRoute(
    path: RouteType.alarm.path,
    name: RouteType.alarm.name,
    parentNavigatorKey: shellNavKey,
    pageBuilder: (context, state) => NoTransitionPage(
      child: GetBuilder<NotificationViewModel>(
        init: NotificationViewModel(
          Get.find(),
          Get.find(),
        ),
        autoRemove: false,
        builder: (controller) => const NotificationView(),
      ),
    ),
  );
}

/// 내 정보 탭 라우트를 생성합니다
GoRoute _buildMyInfoRoute(GlobalKey<NavigatorState> shellNavKey) {
  return GoRoute(
    path: RouteType.myInfo.path,
    name: RouteType.myInfo.name,
    parentNavigatorKey: shellNavKey,
    pageBuilder: (context, state) => NoTransitionPage(
      child: GetBuilder<MyInfoViewModel>(
        init: MyInfoViewModel(Get.find()),
        autoRemove: false,
        builder: (controller) => const MyInfoView(),
      ),
    ),
  );
}
