import 'package:flutter/services.dart';
import 'package:icreat_dct/6_util/device_info.dart';
import 'package:icreat_dct/6_util/logger.dart';

class BluetoothChannel {
  static const MethodChannel _channel =
      MethodChannel('kr.caresquare.pbcr/bluetooth');
  static const _methodRequestPermission = 'requestPermission';
  static const _methodGetPermission = 'getPermission';
  static const _methodAlertPowerOn = 'alertPowerOn';
  static const _methodPowerOn = 'powerOn';

  static const _iOSAuthNotDetermined = 0;
  static const _iOSAuthAllowedAlways = 3;

  static Future<bool> requestPowerOn() async {
    try {
      if (DeviceInfo.isAndroid) {
        bool? isEnabled = await _channel.invokeMethod<bool>(_methodPowerOn);
        Logger.info('isEnabled = $isEnabled');
        await Future.delayed(const Duration(milliseconds: 400));
        return isEnabled ?? false;
      } else {
        await _channel.invokeMethod<bool>(_methodAlertPowerOn);
        return false;
      }
    } catch (e, s) {
      Logger.error('powerOn error', e: e, s: s);
      return false;
    }
  }

  static Future<bool> checkPermission() async {
    try {
      bool? isGranted;
      if (DeviceInfo.isAndroid) {
        isGranted = await _channel.invokeMethod<bool>(_methodRequestPermission);
      } else {
        isGranted = await _requestAndGetiOSPermission();
      }
      Logger.info('isGranted = $isGranted');
      return isGranted ?? false;
    } catch (e, s) {
      Logger.error('requestPermission error', e: e, s: s);
      return false;
    }
  }

  static Future<bool> _requestAndGetiOSPermission() async {
    int iosBleAuthCode = _iOSAuthNotDetermined;

    while (true) {
      iosBleAuthCode = await _channel.invokeMethod<int>(_methodGetPermission) ??
          _iOSAuthNotDetermined;

      if (iosBleAuthCode == _iOSAuthNotDetermined) {
        await Future.delayed(const Duration(seconds: 1));
      } else {
        break;
      }
    }
    return iosBleAuthCode == _iOSAuthAllowedAlways;
  }
}
