import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:icreat_dct/2_repository/pref_repository.dart';
import 'package:icreat_dct/5_channel/bluetooth_channel.dart';
import 'package:icreat_dct/6_util/device_info.dart';
import 'package:icreat_dct/6_util/logger.dart';

enum BleCheckResult {
  success, // 성공
  unsupportedDevice, // BLE 미지원 기기
  permissionDenied, // 권한 거부
  bluetoothOff, // 블루투스 꺼짐
  locationOff; // (안드로이드) 위치 서비스 꺼짐

  bool get isAvailable => this == BleCheckResult.success;
}

class BleService {
  final PrefRepository _prefRepo;

  BleService(this._prefRepo);

  static bool _needToInit = true;

  String? get weightDeviceID => _prefRepo.weightDeviceID;

  Future<void> setWeightDeviceID(String? id) =>
      _prefRepo.setWeightDeviceID(id);

  Future<void> _init() async {
    if (DeviceInfo.isIOS && _needToInit) {
      _needToInit = false;
      Logger.debug('ble init');
      await FlutterBluePlus.isSupported;
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  Future<BleCheckResult> checkAvailableBle() async {
    await _init();

    final isAvailableDevice =
        DeviceInfo.isIOS || await FlutterBluePlus.isSupported;

    if (!isAvailableDevice) {
      return BleCheckResult.unsupportedDevice;
    }

    final result = await _checkAndRequestBlePermission();

    if (result == BleCheckResult.permissionDenied) {
      return BleCheckResult.permissionDenied;
    }

    final isOnBle = ((await FlutterBluePlus.adapterState.first) ==
        BluetoothAdapterState.on);
    Logger.info('ble isOn = $isOnBle');
    if (!isOnBle) {
      final isEnabled = await BluetoothChannel.requestPowerOn();
      Logger.info('ble request powerOn result = $isEnabled');
      return isEnabled ? BleCheckResult.success : BleCheckResult.bluetoothOff;
    }

    // if (DeviceInfo.isAndroid) {
    //   final isOnLocation = await _permissionHelper.isOnLocation();
    //   Logger.info('location isOn = $isOnLocation');
    //   if (!isOnLocation) {
    //     return BleCheckResult.locationOff;
    //   }
    // }

    return BleCheckResult.success;
  }

  Future<BleCheckResult> _checkAndRequestBlePermission() async {
    final isGranted = await BluetoothChannel.checkPermission();
    Logger.info('ble permission is granted ? $isGranted');

    return isGranted ? BleCheckResult.success : BleCheckResult.permissionDenied;
  }

  int get weightDeviceLatestSeqNum => _prefRepo.weightDeviceLatestSeqNum;

  Future<void> setWeightDeviceLatestSeqNum(int seqNum) =>
      _prefRepo.setWeightDeviceLatestSeqNum(seqNum);
}
