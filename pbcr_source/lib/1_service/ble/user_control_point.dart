import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:icreat_dct/1_service/ble/bluetooth_characteristic.dart';
import 'package:icreat_dct/8_extension/int_ext.dart';

class UserControlPoint {
  UserControlPoint(this.characteristic);
  final BluetoothCharacteristic characteristic;

  static const int _defaultUserIdx = 1;
  static const int _defaultConsent = 0x020E;

  static const _writeDuration = Duration(milliseconds: 200);
  static Future<void> delayWrite() => Future.delayed(_writeDuration);

  Future<void> registerUser() async {
    await delayWrite();
    await characteristic.writeWithLog(
      data: [
        UCPOpCode.registerUser.code,
        _defaultUserIdx,
        ..._defaultConsent.toByteList(2, isLittleEndian: true),
      ],
      logTitle: 'register user',
    );
  }

  Future<void> checkUserAuth() async {
    await delayWrite();
    await characteristic.writeWithLog(
      data: [
        UCPOpCode.consent.code,
        _defaultUserIdx,
        ..._defaultConsent.toByteList(2, isLittleEndian: true),
      ],
      logTitle: 'check user auth',
    );
  }

  Future<void> deleteUserData() async {
    await delayWrite();
    await characteristic.writeWithLog(
      data: [UCPOpCode.deleteUser.code],
      logTitle: 'delete user data',
    );
  }
}

enum UCPOpCode { consent, deleteUser, response, registerUser }

extension UCPOpCodeExt on UCPOpCode {
  static const int _consentCode = 0x02;
  static const int _deleteUserCode = 0x03;
  static const int _responseCode = 0x20;
  static const int _registerUserCode = 0x40;

  static UCPOpCode? parseFromCode(int value) {
    switch (value) {
      case _consentCode:
        return UCPOpCode.consent;
      case _deleteUserCode:
        return UCPOpCode.deleteUser;
      case _responseCode:
        return UCPOpCode.response;
      case _registerUserCode:
        return UCPOpCode.registerUser;
      default:
        return null;
    }
  }

  int get code {
    switch (this) {
      case UCPOpCode.consent:
        return _consentCode;
      case UCPOpCode.deleteUser:
        return _deleteUserCode;
      case UCPOpCode.response:
        return _responseCode;
      case UCPOpCode.registerUser:
        return _registerUserCode;
    }
  }

  String get text {
    switch (this) {
      case UCPOpCode.consent:
        return 'AuthCode 체크';
      case UCPOpCode.deleteUser:
        return 'Delete User';
      case UCPOpCode.response:
        return 'Response';
      case UCPOpCode.registerUser:
        return 'Register User';
    }
  }
}

enum UCPResCode { success, opCodeNotSupported, invalidParam, fail, notAuth }

extension UCPResCodeExt on UCPResCode {
  static const int _successCode = 0x01;
  static const int _notSupportedCode = 0x02;
  static const int _invalidParameterCode = 0x03;
  static const int _failCode = 0x04;
  static const int _notAuthCode = 0x05;

  static UCPResCode? parseFromCode(int value) {
    switch (value) {
      case _successCode:
        return UCPResCode.success;
      case _notSupportedCode:
        return UCPResCode.opCodeNotSupported;
      case _invalidParameterCode:
        return UCPResCode.invalidParam;
      case _failCode:
        return UCPResCode.fail;
      case _notAuthCode:
        return UCPResCode.notAuth;
      default:
        return null;
    }
  }

  int get code {
    switch (this) {
      case UCPResCode.success:
        return _successCode;
      case UCPResCode.opCodeNotSupported:
        return _notSupportedCode;
      case UCPResCode.invalidParam:
        return _invalidParameterCode;
      case UCPResCode.fail:
        return _failCode;
      case UCPResCode.notAuth:
        return _notAuthCode;
    }
  }

  String get text {
    switch (this) {
      case UCPResCode.success:
        return '성공';
      case UCPResCode.opCodeNotSupported:
        return '요청 opration 지원 안 함';
      case UCPResCode.invalidParam:
        return '잘못된 parameter';
      case UCPResCode.fail:
        return '실패';
      case UCPResCode.notAuth:
        return '인증 실패';
    }
  }

  bool get isSuccess => this == UCPResCode.success;
}

