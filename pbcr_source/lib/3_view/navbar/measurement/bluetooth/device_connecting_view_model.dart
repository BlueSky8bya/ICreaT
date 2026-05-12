import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:icreat_dct/1_service/ble/ble_device_service.dart';
import 'package:icreat_dct/1_service/permission_service.dart';
import 'package:icreat_dct/3_view/components/snackbar/snackbar_widget.dart';
import 'package:icreat_dct/3_view/components/base_view_model.dart';
import 'package:icreat_dct/1_service/ble_service.dart';
import 'package:icreat_dct/6_util/device_info.dart';
import 'package:icreat_dct/6_util/logger.dart';
import 'package:icreat_dct/6_util/overlay_util.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class DeviceConnectingViewModel extends BaseViewModel {
  final BuildContext context;

  final BleService bleService;
  final PermissionService permissionService;

  DeviceConnectingViewModel(this.context, this.bleService, this.permissionService);

  Timer? scanTimer;
  Timer? connectTimer;
  BleDeviceService? bleDevice;
  bool needBleDispose = true;
  bool ignoreDisconnect = false;

  @override
  void onInit() {
    super.onInit();
    permissionService.requestBluetoothRequirements(context).then((value) {
      if (!value) {
        if (context.mounted) {
          context.pop();
          return;
        }
      }
      _init();
    });
  }

  void _init() async {
    final result = await checkBle();
    if (result.isAvailable) {
      actionForBleAvailable();
    } else {
      if (context.mounted) {
        context.pop();
      }
    }
  }

  @protected
  void actionForBleAvailable();

  void onChangeState(BluetoothConnectionState state) {
    if (state == BluetoothConnectionState.connected) {
      connectTimer?.cancel();
      actionForConnected();
      // } else if (state == BluetoothConnectionState.connecting) {
      //   scanTimer?.cancel();
      //   connectTimer = Timer(const Duration(seconds: 30), errorConnect);
    } else {
      if (!ignoreDisconnect) {
        Logger.warn('$deviceName 연결 과정 이상 상태 : state = $state');
        errorConnect();
      }
    }
  }

  @protected
  void actionForConnected();

  @protected
  void errorConnect() {
    // showToast('$deviceName 연결 과정에서 오류가 발생했어요\n다시 시도해주세요');
    context.pop();
  }

  @protected
  String get deviceName;

  @override
  void onClose() {
    scanTimer?.cancel();
    connectTimer?.cancel();
    if (needBleDispose) {
      bleDevice?.callback = null;
      bleDevice?.dispose();
    }
    super.onClose();
  }

  Future<BleCheckResult> checkBle() async {
    final result = await bleService.checkAvailableBle();

    Logger.debug('ble check result = $result');

    switch (result) {
      case BleCheckResult.success:
        // BLE 사용 가능 - 다음 로직 수행
        break;
      case BleCheckResult.unsupportedDevice:
        // ToastHelper.showToast('디바이스에서 블루투스 기능을 제공하지 않습니다.');
        break;
      case BleCheckResult.permissionDenied:
        _showPermissionSnackbar();
        break;
      case BleCheckResult.bluetoothOff:
        // ToastHelper.showToast('블루투스를 켠 후 다시 시도해주세요');
        break;
      case BleCheckResult.locationOff:
        // ToastHelper.showToast('위치 사용을 켠 후 다시 시도해주세요');
        break;
    }
    return result;
  }

  void _showPermissionSnackbar() {
    final permissionStr = DeviceInfo.isAndroid ? '위치' : '블루투스';
    OverlayUtil.showSnackBar(
      context,
      title: '기기 연결을 위해 $permissionStr 권한이 필요합니다.',
      type: SnackBarType.error,
      action: SnackBarAction(
        label: '설정',
        onPressed: () => openAppSettings(),
      ),
      showCloseIcon: false,
    );
  }
}
