import 'package:flutter/material.dart';
import 'package:icreat_dct/0_data/model/ble/ble_body_composition_model.dart';
import 'package:icreat_dct/0_data/dto/auth/qr_scan_result_res.dart';
import 'package:icreat_dct/1_service/ble/devices/temperature_device.dart';
import 'package:icreat_dct/0_data/model/measurement/blood_pressure_model.dart';
import 'package:icreat_dct/3_view/navbar/measurement/data/measurement_type.dart';
import 'package:icreat_dct/4_router/navigation_method.dart';
import 'package:icreat_dct/4_router/route_type.dart';

import 'package:icreat_dct/3_view/form/form_view_type.dart';

/// 애플리케이션 전체에서 사용하는 공통 네비게이션 메서드들을 제공하는 클래스
/// 타입 안전성과 일관된 네비게이션 경험을 보장합니다
class CommonNavigator {
  const CommonNavigator._();

  // ==================== 메인 네비게이션 ====================

  /// 메인 화면으로 네비게이션합니다
  ///
  /// [context] - BuildContext
  /// [mode] - 네비게이션 방법 (기본값: pushReplacement)
  ///
  /// Returns: NavigationResult - 네비게이션 결과
  static Future<NavigationResult<void>> toMain(
    BuildContext context, {
    NavigatingMethod mode = NavigatingMethod.pushReplacement,
  }) async {
    return mode.navigateTo(
      context: context,
      name: RouteType.schedule.name,
    );
  }

  /// 로그인 화면으로 네비게이션합니다
  ///
  /// [context] - BuildContext
  /// [mode] - 네비게이션 방법 (기본값: pushReplacement)
  ///
  /// Returns: NavigationResult - 네비게이션 결과
  static Future<NavigationResult<void>> toLogin(
    BuildContext context, {
    NavigatingMethod mode = NavigatingMethod.pushReplacement,
  }) async {
    return mode.navigateTo(
      context: context,
      name: RouteType.login.name,
    );
  }

  /// QR 스캔 화면으로 네비게이션합니다
  ///
  /// [context] - BuildContext
  /// [mode] - 네비게이션 방법 (기본값: push)
  ///
  /// Returns: NavigationResult - 네비게이션 결과
  static Future<NavigationResult<QrScanResultRes>> toQrScan(
    BuildContext context, {
    NavigatingMethod mode = NavigatingMethod.push,
  }) async {
    return mode.navigateTo<QrScanResultRes>(
      context: context,
      name: RouteType.qrScan.name,
    );
  }

  // ==================== 측정 관련 네비게이션 ====================

  /// 측정 입력 선택 화면으로 네비게이션합니다
  ///
  /// [context] - BuildContext
  /// [measurementType] - 측정 타입
  /// [itemGroupKey] - eCRF에서 같은 itemGroupKey를 찾아서 데이터를 채워주기 위한 용도
  /// [mode] - 네비게이션 방법 (기본값: push)
  ///
  /// Returns: NavigationResult - 네비게이션 결과
  static Future<NavigationResult<void>> toMeasurementSelect(
    BuildContext context, {
    required MeasurementType measurementType,
    String itemGroupKey = '',
    NavigatingMethod mode = NavigatingMethod.push,
  }) async {
    return mode.navigateTo<int>(
      context: context,
      name: RouteType.measurementInputSelect.name,
      queryParameters: {
        'itemGroupKey': itemGroupKey,
      },
      extra: measurementType.index,
    );
  }

  // ==================== 혈압 측정 네비게이션 ====================

  /// 혈압 수동 입력 화면으로 네비게이션합니다
  static Future<NavigationResult<void>> toBpManual(
    BuildContext context, {
    String itemGroupKey = '',
    NavigatingMethod mode = NavigatingMethod.pushReplacement,
  }) async {
    return mode.navigateTo(
      context: context,
      name: RouteType.measurementBpManual.name,
      queryParameters: {
        'itemGroupKey': itemGroupKey,
      },
    );
  }

  /// 혈압 블루투스 연결 화면으로 네비게이션합니다
  static Future<NavigationResult<void>> toBpBluetooth(
    BuildContext context, {
    String itemGroupKey = '',
    NavigatingMethod mode = NavigatingMethod.pushReplacement,
  }) async {
    return mode.navigateTo(
      context: context,
      name: RouteType.measurementConnectBp.name,
      queryParameters: {
        'itemGroupKey': itemGroupKey,
      },
    );
  }

  /// 혈압 블루투스 측정 결과 화면으로 네비게이션합니다
  static Future<NavigationResult<void>> toBpBluetoothResult(
    BuildContext context, {
    required BloodPressureModel bpModel,
    String itemGroupKey = '',
    NavigatingMethod mode = NavigatingMethod.pushReplacement,
  }) async {
    return mode.navigateTo<BloodPressureModel>(
      context: context,
      name: RouteType.measurementBpResult.name,
      extra: bpModel,
      queryParameters: {
        'itemGroupKey': itemGroupKey,
      },
    );
  }

  // ==================== 체온 측정 네비게이션 ====================

  /// 체온 블루투스 연결 화면으로 네비게이션합니다
  static Future<NavigationResult<void>> toBtBluetooth(
    BuildContext context, {
    String itemGroupKey = '',
    NavigatingMethod mode = NavigatingMethod.pushReplacement,
  }) async {
    return mode.navigateTo(
      context: context,
      name: RouteType.measurementConnectBt.name,
      queryParameters: {
        'itemGroupKey': itemGroupKey,
      },
    );
  }

  /// 체온 블루투스 측정 결과 화면으로 네비게이션합니다
  static Future<NavigationResult<void>> toBtBluetoothResult(
    BuildContext context, {
    required TemperatureDeviceService device,
    String itemGroupKey = '',
    NavigatingMethod mode = NavigatingMethod.pushReplacement,
  }) async {
    return mode.navigateTo<TemperatureDeviceService>(
      context: context,
      name: RouteType.measurementBtResult.name,
      extra: device,
      queryParameters: {
        'itemGroupKey': itemGroupKey,
      },
    );
  }

  /// 체온 수동 입력 화면으로 네비게이션합니다
  static Future<NavigationResult<void>> toBtManual(
    BuildContext context, {
    String itemGroupKey = '',
    NavigatingMethod mode = NavigatingMethod.pushReplacement,
  }) async {
    return mode.navigateTo(
      context: context,
      name: RouteType.measurementBtManual.name,
      queryParameters: {
        'itemGroupKey': itemGroupKey,
      },
    );
  }

  // ==================== 체중 측정 네비게이션 ====================

  /// 체중 블루투스 연결 화면으로 네비게이션합니다
  static Future<NavigationResult<void>> toBwBluetooth(
    BuildContext context, {
    String itemGroupKey = '',
    NavigatingMethod mode = NavigatingMethod.pushReplacement,
  }) async {
    return mode.navigateTo(
      context: context,
      name: RouteType.measurementConnectBw.name,
      queryParameters: {
        'itemGroupKey': itemGroupKey,
      },
    );
  }

  /// 체중 블루투스 측정 결과 화면으로 네비게이션합니다
  static Future<NavigationResult<void>> toBwBluetoothResult(
    BuildContext context, {
    required BodyComposition bodyComposition,
    String itemGroupKey = '',
    NavigatingMethod mode = NavigatingMethod.pushReplacement,
  }) async {
    return mode.navigateTo<BodyComposition>(
      context: context,
      name: RouteType.measurementBwResult.name,
      extra: bodyComposition,
      queryParameters: {
        'itemGroupKey': itemGroupKey,
      },
    );
  }

  /// 체중 수동 입력 화면으로 네비게이션합니다
  static Future<NavigationResult<void>> toBwManual(
    BuildContext context, {
    String itemGroupKey = '',
    NavigatingMethod mode = NavigatingMethod.pushReplacement,
  }) async {
    return mode.navigateTo(
      context: context,
      name: RouteType.measurementBwManual.name,
      queryParameters: {
        'itemGroupKey': itemGroupKey,
      },
    );
  }

  // ==================== 통계 관련 네비게이션 ====================

  /// 수면 통계 화면으로 네비게이션합니다
  static Future<NavigationResult<void>> toSleepStatistics(
    BuildContext context, {
    NavigatingMethod mode = NavigatingMethod.push,
  }) async {
    return mode.navigateTo(
      context: context,
      name: RouteType.sleepStatistics.name,
    );
  }

  /// 걸음 수 통계 화면으로 네비게이션합니다
  static Future<NavigationResult<void>> toStepStatistics(
    BuildContext context, {
    NavigatingMethod mode = NavigatingMethod.push,
  }) async {
    return mode.navigateTo(
      context: context,
      name: RouteType.stepStatistics.name,
    );
  }

  // ==================== 폼 관련 네비게이션 ====================

  /// 폼 화면으로 네비게이션합니다
  static Future<NavigationResult<void>> toForm(
    BuildContext context, {
    required FormViewModelOption option,
    NavigatingMethod mode = NavigatingMethod.push,
  }) async {
    return mode.navigateTo<FormViewModelOption>(
      context: context,
      name: RouteType.form.name,
      extra: option,
    );
  }

  // ==================== 로컬 알림 관련 네비게이션 ====================

  /// 로컬 알림 목록 화면으로 네비게이션합니다
  static Future<NavigationResult<void>> toLocalNotificationList(
    BuildContext context, {
    NavigatingMethod mode = NavigatingMethod.push,
  }) async {
    return mode.navigateTo(
      context: context,
      name: RouteType.localNotificationList.name,
    );
  }

  /// 로컬 알림 추가 화면으로 네비게이션합니다
  static Future<NavigationResult<void>> toLocalNotificationAdd(
    BuildContext context, {
    NavigatingMethod mode = NavigatingMethod.push,
  }) async {
    return mode.navigateTo(
      context: context,
      name: RouteType.localNotificationAdd.name,
    );
  }

  // ==================== 도움말 관련 네비게이션 ====================

  /// 앱 사용 매뉴얼 화면으로 네비게이션합니다
  static Future<NavigationResult<void>> toAppManual(
    BuildContext context, {
    NavigatingMethod mode = NavigatingMethod.push,
  }) async {
    return mode.navigateTo(
      context: context,
      name: RouteType.appManual.name,
    );
  }

  // ==================== 헬퍼 메서드 ====================

  /// 간단한 네비게이션을 위한 헬퍼 메서드들
  /// 에러 처리가 필요 없는 경우 사용

  static void toMainSimple(
    BuildContext context, {
    NavigatingMethod mode = NavigatingMethod.pushReplacement,
  }) {
    mode.navigateToSimple(
      context: context,
      name: RouteType.schedule.name,
    );
  }

  static void toLoginSimple(
    BuildContext context, {
    NavigatingMethod mode = NavigatingMethod.pushReplacement,
  }) {
    mode.navigateToSimple(
      context: context,
      name: RouteType.login.name,
    );
  }

  static void toQrScanSimple(
    BuildContext context, {
    NavigatingMethod mode = NavigatingMethod.push,
  }) {
    mode.navigateToSimple(
      context: context,
      name: RouteType.qrScan.name,
    );
  }

  static void toAppManualSimple(
    BuildContext context, {
    NavigatingMethod mode = NavigatingMethod.push,
  }) {
    mode.navigateToSimple(
      context: context,
      name: RouteType.appManual.name,
    );
  }

  static void toConsentViewSimple(
      BuildContext context, {
        NavigatingMethod mode = NavigatingMethod.push,
      }) {
    mode.navigateToSimple(
      context: context,
      name: RouteType.consent.name,
    );
  }
}
