/// 애플리케이션의 모든 라우트 타입을 정의하는 열거형
/// 각 라우트는 고유한 경로와 이름을 가집니다
enum RouteType {
  // ==================== 인증 관련 라우트 ====================
  /// 스플래시 화면
  splash,
  /// 로그인 화면
  login,
  /// QR 스캔 화면
  qrScan,

  // ==================== 메인 탭 라우트 ====================
  /// 일정 화면
  schedule,
  /// 측정 화면
  measurement,
  /// 알림 화면
  alarm,
  /// 내 정보 화면
  myInfo,

  // ==================== 측정 관련 라우트 ====================
  /// 측정 입력 선택 화면
  measurementInputSelect,
  
  // 혈압 측정
  /// 혈압 수동 입력 화면
  measurementBpManual,
  /// 혈압 블루투스 연결 화면
  measurementConnectBp,
  /// 혈압 측정 결과 화면
  measurementBpResult,

  // 체온 측정
  /// 체온 수동 입력 화면
  measurementBtManual,
  /// 체온 블루투스 연결 화면
  measurementConnectBt,
  /// 체온 측정 결과 화면
  measurementBtResult,

  // 체중 측정
  /// 체중 수동 입력 화면
  measurementBwManual,
  /// 체중 블루투스 연결 화면
  measurementConnectBw,
  /// 체중 측정 결과 화면
  measurementBwResult,

  // ==================== 통계 관련 라우트 ====================
  /// 수면 통계 화면
  sleepStatistics,
  /// 걸음 수 통계 화면
  stepStatistics,

  // ==================== 폼 관련 라우트 ====================
  /// 폼 화면
  form,

  // ==================== 로컬 알림 관련 라우트 ====================
  /// 로컬 알림 목록 화면
  localNotificationList,
  /// 로컬 알림 추가 화면
  localNotificationAdd,

  // ==================== 도움말 관련 라우트 ====================
  /// 앱 사용 매뉴얼 화면
  appManual,
  /// 동의서 화면
  consent,
}

/// 라우트 경로 상수 정의
class RoutePaths {
  // 인증 관련 경로
  static const String splash = '/splash';
  static const String login = '/login';
  static const String qrScan = 'qr-scan';

  // 메인 탭 경로
  static const String schedule = '/schedule';
  static const String alarm = '/alarm';
  static const String measurement = '/measurement';
  static const String myInfo = '/my-info';

  // 측정 관련 경로
  static const String measurementInputSelect = '/measurement-input-select';
  static const String measurementBpManual = '/bp-manual';
  static const String measurementConnectBp = '/bp-bluetooth';
  static const String measurementBpResult = '/result';
  static const String measurementBtManual = '/bt-manual';
  static const String measurementConnectBt = '/bt-bluetooth';
  static const String measurementBtResult = '/result';
  static const String measurementBwManual = '/bw-manual';
  static const String measurementConnectBw = '/bw-bluetooth';
  static const String measurementBwResult = '/result';

  // 통계 관련 경로
  static const String sleepStatistics = '/statistics/sleep';
  static const String stepStatistics = '/statistics/step';

  // 폼 관련 경로
  static const String form = '/form';

  // 로컬 알림 관련 경로
  static const String localNotificationList = '/local-notification/list';
  static const String localNotificationAdd = '/local-notification/add';

  // 도움말 관련 경로
  static const String appManual = '/app-manual';
  static const String consent = '/icf-document';
}

/// RouteType에 대한 확장 메서드
extension RouteTypeExt on RouteType {
  /// 라우트의 경로를 반환합니다
  String get path {
    switch (this) {
      // 인증 관련
      case RouteType.splash:
        return RoutePaths.splash;
      case RouteType.login:
        return RoutePaths.login;
      case RouteType.qrScan:
        return RoutePaths.qrScan;

      // 메인 탭
      case RouteType.schedule:
        return RoutePaths.schedule;
      case RouteType.alarm:
        return RoutePaths.alarm;
      case RouteType.measurement:
        return RoutePaths.measurement;
      case RouteType.myInfo:
        return RoutePaths.myInfo;

      // 측정 관련
      case RouteType.measurementInputSelect:
        return RoutePaths.measurementInputSelect;
      case RouteType.measurementBpManual:
        return RoutePaths.measurementBpManual;
      case RouteType.measurementConnectBp:
        return RoutePaths.measurementConnectBp;
      case RouteType.measurementBpResult:
        return RoutePaths.measurementBpResult;
      case RouteType.measurementBtManual:
        return RoutePaths.measurementBtManual;
      case RouteType.measurementConnectBt:
        return RoutePaths.measurementConnectBt;
      case RouteType.measurementBtResult:
        return RoutePaths.measurementBtResult;
      case RouteType.measurementBwManual:
        return RoutePaths.measurementBwManual;
      case RouteType.measurementConnectBw:
        return RoutePaths.measurementConnectBw;
      case RouteType.measurementBwResult:
        return RoutePaths.measurementBwResult;

      // 통계 관련
      case RouteType.sleepStatistics:
        return RoutePaths.sleepStatistics;
      case RouteType.stepStatistics:
        return RoutePaths.stepStatistics;

      // 폼 관련
      case RouteType.form:
        return RoutePaths.form;

      // 로컬 알림 관련
      case RouteType.localNotificationList:
        return RoutePaths.localNotificationList;
      case RouteType.localNotificationAdd:
        return RoutePaths.localNotificationAdd;

      // 도움말 관련
      case RouteType.appManual:
        return RoutePaths.appManual;
      case RouteType.consent:
        return RoutePaths.consent;
    }
  }

  /// 라우트의 이름을 반환합니다
  String get name => toString().split('.').last;

  /// 라우트가 인증이 필요한지 확인합니다
  /// TODO: 인증 관련 로직 추가
  bool get requiresAuth {
    return false;
    // switch (this) {
    //   case RouteType.splash:
    //   case RouteType.login:
    //   case RouteType.qrScan:
    //     return false;
    //   default:
    //     return true;
    // }
  }

  /// 라우트가 탭 라우트인지 확인합니다
  bool get isTabRoute {
    switch (this) {
      case RouteType.schedule:
      case RouteType.measurement:
      case RouteType.alarm:
      case RouteType.myInfo:
        return true;
      default:
        return false;
    }
  }

  /// 라우트가 측정 관련 라우트인지 확인합니다
  bool get isMeasurementRoute {
    switch (this) {
      case RouteType.measurementInputSelect:
      case RouteType.measurementBpManual:
      case RouteType.measurementConnectBp:
      case RouteType.measurementBpResult:
      case RouteType.measurementBtManual:
      case RouteType.measurementConnectBt:
      case RouteType.measurementBtResult:
      case RouteType.measurementBwManual:
      case RouteType.measurementConnectBw:
      case RouteType.measurementBwResult:
        return true;
      default:
        return false;
    }
  }
}
