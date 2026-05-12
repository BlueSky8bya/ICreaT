import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:icreat_dct/0_data/model/ble/ble_body_composition_model.dart';
import 'package:icreat_dct/1_service/ble/devices/temperature_device.dart';
import 'package:icreat_dct/0_data/model/measurement/blood_pressure_model.dart';
import 'package:icreat_dct/3_view/navbar/measurement/data/measurement_type.dart';
import 'package:icreat_dct/3_view/navbar/measurement/bluetooth/blood_pressure_result_view.dart';
import 'package:icreat_dct/3_view/navbar/measurement/bluetooth/blood_pressure_result_view_model.dart';
import 'package:icreat_dct/3_view/navbar/measurement/bluetooth/blood_pressure_connecting_view.dart';
import 'package:icreat_dct/3_view/navbar/measurement/bluetooth/blood_pressure_connecting_view_model.dart';
import 'package:icreat_dct/3_view/navbar/measurement/bluetooth/weight_connecting_view.dart';
import 'package:icreat_dct/3_view/navbar/measurement/bluetooth/weight_connecting_view_model.dart';
import 'package:icreat_dct/3_view/navbar/measurement/bluetooth/temperature_connecting_view.dart';
import 'package:icreat_dct/3_view/navbar/measurement/bluetooth/temperature_connecting_view_model.dart';
import 'package:icreat_dct/3_view/navbar/measurement/bluetooth/temperature_result_view.dart';
import 'package:icreat_dct/3_view/navbar/measurement/bluetooth/temperature_result_view_model.dart';
import 'package:icreat_dct/3_view/navbar/measurement/bluetooth/weight_result_view.dart';
import 'package:icreat_dct/3_view/navbar/measurement/bluetooth/weight_result_view_model.dart';
import 'package:icreat_dct/3_view/navbar/measurement/manual/blood_pressure_manual_input_view.dart';
import 'package:icreat_dct/3_view/navbar/measurement/manual/blood_pressure_manual_input_view_model.dart';
import 'package:icreat_dct/3_view/navbar/measurement/manual/temperature_manual_input_view.dart';
import 'package:icreat_dct/3_view/navbar/measurement/manual/temperature_manual_input_view_model.dart';
import 'package:icreat_dct/3_view/navbar/measurement/manual/weight_manual_input_view.dart';
import 'package:icreat_dct/3_view/navbar/measurement/manual/weight_manual_input_view_model.dart';
import 'package:icreat_dct/3_view/navbar/measurement/select/measurement_select_view.dart';
import 'package:icreat_dct/3_view/navbar/measurement/select/measurement_select_view_model.dart';
import 'package:icreat_dct/3_view/navbar/measurement/statistics/sleep_statistics_view.dart';
import 'package:icreat_dct/3_view/navbar/measurement/statistics/sleep_statistics_view_model.dart';
import 'package:icreat_dct/3_view/navbar/measurement/statistics/step_statistics_view.dart';
import 'package:icreat_dct/3_view/navbar/measurement/statistics/step_statistics_view_model.dart';
import 'package:icreat_dct/4_router/route_type.dart';

/// 측정 관련 라우트들을 초기화하고 반환합니다
/// 
/// [rootNavKey] - 루트 네비게이터 키
/// 
/// Returns: List&lt;RouteBase&gt; - 측정 라우트 리스트
List<RouteBase> initMeasurementRoutes(
  GlobalKey<NavigatorState> rootNavKey,
) {
  return [
    _buildMeasurementInputSelectRoute(rootNavKey),
    _buildSleepStatisticsRoute(rootNavKey),
    _buildStepStatisticsRoute(rootNavKey),
  ];
}

/// 측정 입력 선택 라우트를 생성합니다
GoRoute _buildMeasurementInputSelectRoute(GlobalKey<NavigatorState> rootNavKey) {
  return GoRoute(
    path: RouteType.measurementInputSelect.path,
    name: RouteType.measurementInputSelect.name,
    parentNavigatorKey: rootNavKey,
    builder: (context, state) {
      // 타입 안전성을 위한 검증
      final measurementTypeIndex = state.extra as int?;
      if (measurementTypeIndex == null || 
          measurementTypeIndex < 0 || 
          measurementTypeIndex >= MeasurementType.values.length) {
        throw ArgumentError('유효하지 않은 측정 타입 인덱스입니다: $measurementTypeIndex');
      }

      final measurementType = MeasurementType.values[measurementTypeIndex];
      final itemGroupKey = state.uri.queryParameters['itemGroupKey'] ?? '';

      return GetBuilder(
        init: MeasurementSelectViewModel(
          measurementType,
          itemGroupKey,
        ),
        builder: (controller) => const MeasurementSelectView(),
      );
    },
    routes: [
      // ==================== 혈압 측정 라우트 ====================
      ..._buildBloodPressureRoutes(rootNavKey),
      
      // ==================== 체온 측정 라우트 ====================
      ..._buildTemperatureRoutes(rootNavKey),
      
      // ==================== 체중 측정 라우트 ====================
      ..._buildWeightRoutes(rootNavKey),
    ],
  );
}

/// 혈압 측정 관련 라우트들을 생성합니다
List<GoRoute> _buildBloodPressureRoutes(GlobalKey<NavigatorState> rootNavKey) {
  return [
    GoRoute(
      path: RouteType.measurementConnectBp.path,
      name: RouteType.measurementConnectBp.name,
      parentNavigatorKey: rootNavKey,
      builder: (context, state) {
        final itemGroupKey = state.uri.queryParameters['itemGroupKey'] ?? '';
        
        return GetBuilder(
          init: BloodPressureConnectingViewModel(
            context,
            itemGroupKey,
            Get.find(),
            Get.find(),
          ),
          builder: (controller) => const BloodPressureConnectingView(),
        );
      },
      routes: [
        GoRoute(
          path: RouteType.measurementBpResult.path,
          name: RouteType.measurementBpResult.name,
          parentNavigatorKey: rootNavKey,
          builder: (context, state) {
            // 타입 안전성을 위한 검증
            final bp = state.extra as BloodPressureModel?;
            if (bp == null) {
              throw ArgumentError('BloodPressureModel이 필요합니다.');
            }

            final itemGroupKey = state.uri.queryParameters['itemGroupKey'] ?? '';
            
            return GetBuilder(
              init: BloodPressureResultViewModel(
                bp,
                itemGroupKey,
                Get.find(),
                Get.find(),
              ),
              builder: (controller) => const BloodPressureResultView(),
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: RouteType.measurementBpManual.path,
      name: RouteType.measurementBpManual.name,
      parentNavigatorKey: rootNavKey,
      builder: (context, state) {
        final itemGroupKey = state.uri.queryParameters['itemGroupKey'] ?? '';
        
        return GetBuilder(
          init: BloodPressureManualInputViewModel(
            itemGroupKey,
            Get.find(),
          ),
          builder: (controller) => const BloodPressureManualInputView(),
        );
      },
    ),
  ];
}

/// 체온 측정 관련 라우트들을 생성합니다
List<GoRoute> _buildTemperatureRoutes(GlobalKey<NavigatorState> rootNavKey) {
  return [
    GoRoute(
      path: RouteType.measurementConnectBt.path,
      name: RouteType.measurementConnectBt.name,
      parentNavigatorKey: rootNavKey,
      builder: (context, state) {
        final itemGroupKey = state.uri.queryParameters['itemGroupKey'] ?? '';
        
        return GetBuilder(
          init: TemperatureConnectingViewModel(
            context,
            itemGroupKey,
            Get.find(),
            Get.find(),
          ),
          builder: (controller) => const TemperatureConnectingView(),
        );
      },
      routes: [
        GoRoute(
          path: RouteType.measurementBtResult.path,
          name: RouteType.measurementBtResult.name,
          parentNavigatorKey: rootNavKey,
          builder: (context, state) {
            // 타입 안전성을 위한 검증
            final device = state.extra as TemperatureDeviceService?;
            if (device == null) {
              throw ArgumentError('TemperatureDeviceService가 필요합니다.');
            }

            final itemGroupKey = state.uri.queryParameters['itemGroupKey'] ?? '';
            
            return GetBuilder(
              init: TemperatureResultViewModel(
                device,
                itemGroupKey,
                Get.find(),
                Get.find(),
              ),
              builder: (controller) => const TemperatureResultView(),
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: RouteType.measurementBtManual.path,
      name: RouteType.measurementBtManual.name,
      parentNavigatorKey: rootNavKey,
      builder: (context, state) {
        final itemGroupKey = state.uri.queryParameters['itemGroupKey'] ?? '';
        
        return GetBuilder(
          init: TemperatureManualInputViewModel(
            itemGroupKey,
            Get.find(),
          ),
          builder: (controller) => const TemperatureManualInputView(),
        );
      },
    ),
  ];
}

/// 체중 측정 관련 라우트들을 생성합니다
List<GoRoute> _buildWeightRoutes(GlobalKey<NavigatorState> rootNavKey) {
  return [
    GoRoute(
      path: RouteType.measurementConnectBw.path,
      name: RouteType.measurementConnectBw.name,
      parentNavigatorKey: rootNavKey,
      builder: (context, state) {
        final itemGroupKey = state.uri.queryParameters['itemGroupKey'] ?? '';
        
        return GetBuilder(
          init: WeightConnectingViewModel(
            context,
            itemGroupKey,
            Get.find(),
            Get.find(),
          ),
          builder: (controller) => const WeightConnectingView(),
        );
      },
      routes: [
        GoRoute(
          path: RouteType.measurementBwResult.path,
          name: RouteType.measurementBwResult.name,
          parentNavigatorKey: rootNavKey,
          builder: (context, state) {
            // 타입 안전성을 위한 검증
            final weight = state.extra as BodyComposition?;
            if (weight == null) {
              throw ArgumentError('BodyComposition이 필요합니다.');
            }

            final itemGroupKey = state.uri.queryParameters['itemGroupKey'] ?? '';
            
            return GetBuilder(
              init: WeightResultViewModel(
                weight,
                itemGroupKey,
                Get.find(),
                Get.find(),
              ),
              builder: (controller) => const WeightResultView(),
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: RouteType.measurementBwManual.path,
      name: RouteType.measurementBwManual.name,
      parentNavigatorKey: rootNavKey,
      builder: (context, state) {
        final itemGroupKey = state.uri.queryParameters['itemGroupKey'] ?? '';
        
        return GetBuilder(
          init: WeightManualInputViewModel(
            itemGroupKey,
            Get.find(),
          ),
          builder: (controller) => const WeightManualInputView(),
        );
      },
    ),
  ];
}

/// 수면 통계 라우트를 생성합니다
GoRoute _buildSleepStatisticsRoute(GlobalKey<NavigatorState> rootNavKey) {
  return GoRoute(
    path: RouteType.sleepStatistics.path,
    name: RouteType.sleepStatistics.name,
    parentNavigatorKey: rootNavKey,
    builder: (context, state) => GetBuilder(
      init: SleepStatisticsViewModel(Get.find(), Get.find()),
      builder: (controller) => const SleepStatisticsView(),
    ),
  );
}

/// 걸음 수 통계 라우트를 생성합니다
GoRoute _buildStepStatisticsRoute(GlobalKey<NavigatorState> rootNavKey) {
  return GoRoute(
    path: RouteType.stepStatistics.path,
    name: RouteType.stepStatistics.name,
    parentNavigatorKey: rootNavKey,
    builder: (context, state) => GetBuilder(
      init: StepStatisticsViewModel(
        Get.find(),
        Get.find(),
      ),
      builder: (controller) => const StepStatisticsView(),
    ),
  );
}
