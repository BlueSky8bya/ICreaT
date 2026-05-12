import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:icreat_dct/1_service/auth_service.dart';
import 'package:icreat_dct/3_view/form/form_view.dart';
import 'package:icreat_dct/3_view/form/form_view_model.dart';
import 'package:icreat_dct/3_view/login/login_view.dart';
import 'package:icreat_dct/3_view/login/login_view_model.dart';
import 'package:icreat_dct/3_view/login/qr/qr_scan_view.dart';
import 'package:icreat_dct/3_view/login/qr/qr_scan_view_model.dart';
import 'package:icreat_dct/3_view/navbar/myinfo/consent/consent_view.dart';
import 'package:icreat_dct/3_view/navbar/myinfo/consent/consent_view_model.dart';
import 'package:icreat_dct/3_view/navbar/myinfo/local_notification/local_notification_add_view.dart';
import 'package:icreat_dct/3_view/navbar/myinfo/local_notification/local_notification_add_view_model.dart';
import 'package:icreat_dct/3_view/navbar/myinfo/local_notification/local_notification_list_view.dart';
import 'package:icreat_dct/3_view/navbar/myinfo/local_notification/local_notification_list_view_model.dart';
import 'package:icreat_dct/3_view/navbar/myinfo/app_manual/app_manual_view.dart';
import 'package:icreat_dct/3_view/navbar/myinfo/app_manual/app_manual_view_model.dart';
import 'package:icreat_dct/3_view/splash/splash_view.dart';
import 'package:icreat_dct/3_view/splash/splash_view_model.dart';
import 'package:icreat_dct/3_view/form/form_view_type.dart';
import 'package:icreat_dct/4_router/route_type.dart';
import 'package:icreat_dct/4_router/routes/init_measurement_routes.dart';
import 'package:icreat_dct/4_router/routes/init_tab_routes.dart';
import 'package:icreat_dct/4_router/router_manager.dart';


/// 애플리케이션의 라우터를 초기화하고 설정합니다
/// 
/// Returns: GoRouter - 설정된 라우터 인스턴스
GoRouter initRouter(GlobalKey<NavigatorState> rootNavKey) {
  // 네비게이션 키들을 생성
  //final rootNavKey = GlobalKey<NavigatorState>();
  final shellNavKey = GlobalKey<NavigatorState>();

  // 라우터를 생성
  final router = GoRouter(
    navigatorKey: rootNavKey,
    initialLocation: RouteType.splash.path,
    // 에러 페이지 처리
    errorBuilder: (context, state) => _buildErrorPage(context, state),
    // 리다이렉트 처리
    redirect: _handleRedirect,
    routes: [
      // ==================== 인증 관련 라우트 ====================
      _buildSplashRoute(),
      _buildLoginRoutes(),
      
      // ==================== 메인 탭 라우트 ====================
      ...initTabRoutes(rootNavKey, shellNavKey),
      
      // ==================== 측정 관련 라우트 ====================
      ...initMeasurementRoutes(rootNavKey),
      
      // ==================== 폼 관련 라우트 ====================
      _buildFormRoute(),
      
      // ==================== 로컬 알림 관련 라우트 ====================
      ..._buildLocalNotificationRoutes(),
      
      // ==================== 도움말 관련 라우트 ====================
      _buildAppManualRoute(),
      _buildConsentRoute(),
    ],
  );

  // RouterManager 초기화
  RouterManager.initialize(router);

  return router;
}

/// 스플래시 라우트를 생성합니다
GoRoute _buildSplashRoute() {
  return GoRoute(
    path: RouteType.splash.path,
    name: RouteType.splash.name,
    builder: (context, state) => GetBuilder(
      init: SplashViewModel(context),
      builder: (context) => const SplashView(),
    ),
  );
}

/// 로그인 관련 라우트들을 생성합니다
GoRoute _buildLoginRoutes() {
  return GoRoute(
    path: RouteType.login.path,
    name: RouteType.login.name,
    builder: (context, state) => GetBuilder(
      init: LoginViewModel(Get.find(), Get.find()),
      builder: (context) => const LoginView(),
    ),
    routes: [
      GoRoute(
        path: RouteType.qrScan.path,
        name: RouteType.qrScan.name,
        builder: (context, state) => GetBuilder(
          init: QrScanViewModel(context, Get.find()),
          builder: (context) => const QrScanView(),
        ),
      ),
    ],
  );
}

/// 폼 라우트를 생성합니다
GoRoute _buildFormRoute() {
  return GoRoute(
    path: RouteType.form.path,
    name: RouteType.form.name,
    builder: (context, state) {
      // 타입 안전성을 위한 검증
      final formViewModelArgs = state.extra as FormViewModelOption?;
      if (formViewModelArgs == null) {
        throw ArgumentError('FormViewModelArgs가 필요합니다.');
      }

      return GetBuilder(
        init: FormViewModel(
          context,
          formViewModelArgs,
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find(),
        ),
        builder: (context) => const FormView(),
      );
    },
  );
}

/// 로컬 알림 관련 라우트들을 생성합니다
List<GoRoute> _buildLocalNotificationRoutes() {
  return [
    GoRoute(
      path: RouteType.localNotificationList.path,
      name: RouteType.localNotificationList.name,
      builder: (context, state) => GetBuilder<LocalNotificationListViewModel>(
        init: LocalNotificationListViewModel(Get.find()),
        builder: (context) => const LocalNotificationListView(),
      ),
    ),
    GoRoute(
      path: RouteType.localNotificationAdd.path,
      name: RouteType.localNotificationAdd.name,
      builder: (context, state) => GetBuilder<LocalNotificationViewModel>(
        init: LocalNotificationViewModel(Get.find()),
        builder: (context) => const LocalNotificationAddView(),
      ),
    ),
  ];
}

/// 앱 매뉴얼 라우트를 생성합니다
GoRoute _buildAppManualRoute() {
  return GoRoute(
    path: RouteType.appManual.path,
    name: RouteType.appManual.name,
    builder: (context, state) => GetBuilder<AppManualViewModel>(
      init: AppManualViewModel(),
      builder: (context) => const AppManualView(),
    ),
  );
}

/// 앱 매뉴얼 라우트를 생성합니다
GoRoute _buildConsentRoute() {
  return GoRoute(
    path: RouteType.consent.path,
    name: RouteType.consent.name,
    builder: (context, state) => GetBuilder<ConsentViewModel>(
      init: ConsentViewModel(Get.find()),
      builder: (context) => const ConsentView(),
    ),
  );
}



/// 리다이렉트 처리를 위한 함수
/// 인증이 필요한 라우트에 대한 접근을 제어합니다
String? _handleRedirect(BuildContext context, GoRouterState state) {
  // 인증 상태 확인 (실제 구현에서는 인증 서비스를 사용해야 함)
  final isAuthenticated = Get.find<AuthService>().isLogin;
  
  // 현재 라우트가 인증이 필요한지 확인
  final currentRoute = RouteType.values.firstWhere(
    (route) => route.path == state.matchedLocation,
    orElse: () => RouteType.splash,
  );

  // 인증이 필요한 라우트에 접근하려고 하는데 인증되지 않은 경우
  if (currentRoute.requiresAuth && !isAuthenticated) {
    return RouteType.login.path;
  }

  // 이미 인증된 사용자가 로그인 페이지에 접근하려는 경우
  if (currentRoute == RouteType.login && isAuthenticated) {
    return RouteType.schedule.path;
  }

  // 리다이렉트가 필요하지 않은 경우
  return null;
}

/// 에러 페이지를 생성합니다
Widget _buildErrorPage(BuildContext context, GoRouterState state) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('오류'),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            '페이지를 찾을 수 없습니다',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            '요청한 경로: ${state.uri.path}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go(RouteType.splash.path),
            child: const Text('홈으로 돌아가기'),
          ),
        ],
      ),
    ),
  );
}
