import 'dart:async';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';
import 'package:icreat_dct/1_service/ble/ble_callback.dart';
import 'package:icreat_dct/1_service/ble/devices/blood_pressure_device.dart';
import 'package:icreat_dct/0_data/model/dto/blood_pressure/blood_pressure_dto.dart';
import 'package:icreat_dct/3_view/navbar/measurement/data/measurement_guide_image.dart';
import 'package:icreat_dct/3_view/navbar/measurement/bluetooth/device_connecting_view_model.dart';
import 'package:icreat_dct/4_router/common_navigator.dart';
import 'package:icreat_dct/4_router/navigation_method.dart';
import 'package:icreat_dct/6_util/logger.dart';
import 'package:icreat_dct/6_util/overlay_util.dart';

enum GuideType { measure, connection, manual }

extension GuideTypeExt on GuideType {
  List<String> get imageSources {
    switch (this) {
      case GuideType.measure:
        return MeasurementGuideImage.bloodPressureGuides;
      case GuideType.connection:
        return MeasurementGuideImage.bloodPressureConnectGuides;
      case GuideType.manual:
        return MeasurementGuideImage.bloodPressureManualGuides;
    }
  }
}

class BloodPressureConnectingViewModel extends DeviceConnectingViewModel {
  final String _itemGroupKey;
  
  BloodPressureConnectingViewModel(
    super.context,
    this._itemGroupKey,
    super.bleService,
    super.permissionService,
  );

  BloodPressureDeviceService? _device;
  @override
  String get deviceName => '혈압계';

  RxBool isConnecting = false.obs;
  RxBool isReadingCompleted = false.obs;

  Rx<GuideType> guideType = Rx(GuideType.measure);

  CarouselSliderController sliderController = CarouselSliderController();

  @override
  void actionForBleAvailable() {
    _device = BloodPressureDeviceService();
    bleDevice = _device;

    _device?.bpCallback = _makeBPCallback();

    completeInit();
  }

  BloodPressureBleCallback _makeBPCallback() => BloodPressureBleCallback(
        onChangeState: onChangeState,
        onNewBloodPressure: (bloodPressure) {
          final bpModel = BloodPressureDTO().toDomain(bloodPressure);

          ignoreDisconnect = true;
          Logger.info('get bp : $bloodPressure');
          CommonNavigator.toBpBluetoothResult(
            context,
            bpModel: bpModel,
            mode: NavigatingMethod.pushReplacement,
            itemGroupKey: _itemGroupKey,
          );
        },
      );

  void startConnect() {
    scanTimer = Timer(const Duration(seconds: 30), errorConnect);
    _device?.startConnect();
    isConnecting.value = true;
    guideType.value = GuideType.connection;
    sliderController.animateToPage(0);
  }

  @override
  void errorConnect() {
    OverlayUtil.showErrorToast(
      context,
      msg: '$deviceName 연결 과정에서 오류가 발생했어요. 직접 기록하는 화면으로 이동합니다.',
    );

    CommonNavigator.toBpManual(
      context,
      itemGroupKey: _itemGroupKey,
    );
  }

  @override
  void actionForConnected() {
    _device?.readyToGetData();
  }

  void onSliderPageChanged(int index) {
    if (guideType.value == GuideType.measure && !isReadingCompleted.value) {
      if (index + 1 == GuideType.measure.imageSources.length) {
        isReadingCompleted.value = true;
      }
    }
  }
}
