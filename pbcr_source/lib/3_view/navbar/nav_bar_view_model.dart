import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:icreat_dct/1_service/fcm_device_service.dart';
import 'package:icreat_dct/1_service/local_notification_service.dart';
import 'package:icreat_dct/1_service/permission_service.dart';
import 'package:icreat_dct/1_service/common/fgbg_service.dart';
import 'package:icreat_dct/1_service/health_service.dart';
import 'package:icreat_dct/1_service/event_bus_service.dart';
import 'package:icreat_dct/3_view/components/base_view_model.dart';
import 'package:icreat_dct/4_router/common_navigator.dart';
import 'package:icreat_dct/4_router/navigation_method.dart';
import 'package:icreat_dct/4_router/router_manager.dart';
import 'package:icreat_dct/6_util/device_info.dart';
import 'package:icreat_dct/6_util/logger.dart';

import 'nav_bar_type.dart';

class NavBarViewModel extends BaseViewModel {
  final BuildContext _context;

  final FgBgService _fgBgService;
  final HealthService _healthService;
  final PermissionService _permissionService = PermissionService();
  final LocalNotificationService _localNotificationService;
  final FCMDeviceService _fcmDeviceService;

  final List<StreamSubscription> _eventSubscribeList = [];
  final PageStorageBucket _pageStorageBucket = PageStorageBucket();
  final Rx<NavBarType> curTab = NavBarType.schedule.obs;
  final List<NavBarType> _tabList = [
    NavBarType.schedule,
    NavBarType.alarm,
    NavBarType.myInfo,
  ];

  NavBarViewModel(
    this._context,
    this._fgBgService,
    this._healthService,
    this._localNotificationService,
    this._fcmDeviceService,
  );

  List<NavBarType> get tabList => _tabList;
  PageStorageBucket get pageStorageBucket => _pageStorageBucket;

  @override
  void onInit() {
    super.onInit();

    // init router
    curTab.value = parseTabFromPath(RouterManager.instance.fullPath);
    RouterManager.instance.addListener(() {
      _onRouteChanged();
    });

    // init fgbg service
    _fgBgService.addListener((fgbgType) {
        if (fgbgType == FGBGType.foreground) {
          // _initPhrService();
          _localNotificationService.scheduleRemainingNotifications();
          _fcmDeviceService.updateDeviceRegistration();
        }
      },
    );

    // event bus subscribe
    _eventSubscribeList.add(EventBusService().subscribe<EventSessionExpired>((event) {
      Logger.debug("event handle: $EventSessionExpired on NavBarViewModel");
      if (_context.mounted) {
        showToast(_context, msg: '로그인 유지 기간이 지났습니다. 다시 로그인해주세요.');
        CommonNavigator.toLogin(_context, mode: NavigatingMethod.go);
      }
    }));

    _localNotificationService.initialize();

    // 애니메이션 끊김 방지
    Future.delayed(const Duration(seconds: 1), () {
      // _initPhrService();
    });

    // fcm 토큰 등록
    _fcmDeviceService.registerDevice();
  }

  @override
  void onClose() {
    RouterManager.instance.removeListener(() => _onRouteChanged());
    EventBusService().unsubscribeAll(_eventSubscribeList);
    super.onClose();
  }

  /// TODO : 추후 수면, 걸음 기능 복구해야하는 경우 사용하는 곳에서 주석 해제할 것
  void _initPhrService() async {
    if (DeviceInfo.isAndroid) {
      final hasPermissions =
          await _permissionService.requestRequiredPermissions(_context);

      if (hasPermissions) {
        _healthService.initPhrService();
      }
    } else {
      await _healthService.requestHealthAuth();
    }
  }

  void _onRouteChanged() {
    curTab.value = parseTabFromPath(RouterManager.instance.fullPath);
  }

  NavBarType parseTabFromPath(String fullPath) {
    return NavBarTypeExt.getNavbarTapFromPath(fullPath);
  }

  void onTapNavigate(BuildContext context, NavBarType type) {
    context.goNamed(type.name);
  }
}
