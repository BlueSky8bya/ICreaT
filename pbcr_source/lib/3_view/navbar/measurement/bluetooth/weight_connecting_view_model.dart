import 'dart:async';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:icreat_dct/1_service/ble/ble_callback.dart';
import 'package:icreat_dct/0_data/model/ble/ble_body_composition_model.dart';
import 'package:icreat_dct/1_service/ble/devices/sig_weight_device.dart';
import 'package:icreat_dct/3_view/navbar/measurement/data/measurement_guide_image.dart';
import 'package:icreat_dct/3_view/navbar/measurement/bluetooth/device_connecting_view_model.dart';
import 'package:icreat_dct/4_router/common_navigator.dart';
import 'package:icreat_dct/6_util/logger.dart';

enum GuideType { measure, connection }

extension GuideTypeExt on GuideType {
  List<String> get imageSources {
    switch (this) {
      case GuideType.measure:
        return MeasurementGuideImage.weightGuides;
      case GuideType.connection:
        return MeasurementGuideImage.weightConnectGuides;
    }
  }
}

class WeightConnectingViewModel extends DeviceConnectingViewModel {
  final String _itemGroupKey;
  WeightConnectingViewModel(
    super.context,
    this._itemGroupKey,
    super.measureModel,
    super.healthService,
  );

  SigWeightDeviceService? _device;
  @override
  String get deviceName => '체중계';

  final PageController pageController = PageController();
  final RxBool isConnecting = false.obs;
  RxBool isReadingCompleted = false.obs;

  Rx<GuideType> guideType = Rx(GuideType.measure);

  CarouselSliderController sliderController = CarouselSliderController();

  @override
  void onInit() async {
    // isReadingCompleted =
    //     (await measureModel.getIsWeightGuideReadingCompleted()).obs;
    super.onInit();
  }

  @override
  void actionForBleAvailable() {
    _device = SigWeightDeviceService();
    bleDevice = _device;
    _device?.weightCallback = _makeCallback();

    completeInit();
  }

  WeightBleCallback _makeCallback() => WeightBleCallback(
        onChangeState: onChangeState,
        onEmptyData: errorConnect,
        onNewBodyComposition: _onNewBodyComposition,
        getLatestSeqNum: () => 1,
        setLatestSeqNum: (int seqNum) {
          return Future.value();
        },
        // getLatestSeqNum: _getLatestSeqNum,
        // setLatestSeqNum: _setLatestSeqNum,
      );

  @override
  void actionForConnected() {
    _device?.readyToGetData();
  }

  @override
  void errorConnect() {
    context.pop();
    showToast(context,
        msg: '$deviceName 연결 과정에서 오류가 발생했어요. 직접 기록하는 화면으로 이동합니다.');
  }

  void _onNewBodyComposition(BodyComposition bodyComposition) {
    ignoreDisconnect = true;
    Logger.info('get bodyComposition : $bodyComposition');
    CommonNavigator.toBwBluetoothResult(
      context,
      bodyComposition: bodyComposition,
      itemGroupKey: _itemGroupKey,
    );
  }

  void moveToPage(int idx) {
    pageController.animateToPage(
      idx,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
  }

  void startConnect() {
    scanTimer = Timer(const Duration(seconds: 30), errorConnect);
    _device?.startConnect();
    isConnecting.value = true;
    guideType.value = GuideType.connection;
    sliderController.animateToPage(0);
  }

  void tryConnect() {
    isConnecting.value = true;
    _device?.startConnect();
  }

  void onSliderPageChanged(int index) {
    if (guideType.value == GuideType.measure && !isReadingCompleted.value) {
      if (index + 1 == GuideType.measure.imageSources.length) {
        isReadingCompleted.value = true;
      }
    }
  }
}

enum PairingGuideStep { userInfo, powerOn, bluetooth, pairing }

enum MeasureGuideStep { powerOn, measureStart, measure, measureComplete }
