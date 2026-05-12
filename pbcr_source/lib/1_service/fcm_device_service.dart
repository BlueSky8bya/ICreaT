import 'package:icreat_dct/0_data/model/fcm/fcm_device_register_req.dart';
import 'package:icreat_dct/0_data/model/type/request_result.dart';
import 'package:icreat_dct/2_repository/auth_repository.dart';
import 'package:icreat_dct/2_repository/pref_repository.dart';
import 'package:icreat_dct/6_util/device_info.dart';

class FCMDeviceService {
  final AuthRepository _authRepo;
  final DeviceInfo _deviceInfo;
  final PrefRepository _prefRepo;

  FCMDeviceService(
    this._authRepo,
    this._deviceInfo,
    this._prefRepo,
  );

  /// Register device with FCM token
  Future<RequestResult<void>> registerDevice() => handleRequest(() async {
        final fcmToken = _prefRepo.fcmToken;
        final studyNo = _prefRepo.projectId;
        final pid = _prefRepo.pid ?? '';

        if (fcmToken == null) {
          throw CustomException(
            type: CustomExceptionType.unknown,
            exception: Exception('FCM token is null'),
            stackTrace: StackTrace.current,
            msg: 'FCM token is null',
          );
        }

        final req = FcmDeviceRegisterReq(
          studyNo: studyNo,
          pid: pid,
          deviceType: DeviceInfo.isIOS ? 'IOS' : 'ANDROID',
          deviceToken: fcmToken,
          deviceModel: deviceModel,
          osVersion: osVersion,
        );
        return _authRepo.registerFCMDevice(req);
      });

  /// Unregister device
  Future<RequestResult<void>> unregisterDevice() => handleRequest(() async {
        final fcmToken = _prefRepo.fcmToken;
        if (fcmToken == null) {
          throw CustomException(
            type: CustomExceptionType.unknown,
            exception: Exception('FCM token is null'),
            stackTrace: StackTrace.current,
            msg: 'FCM token is null',
          );
        }
        return _authRepo.unregisterFCMDevice(fcmToken);
      });

  /// Update device registration
  Future<RequestResult<void>> updateDeviceRegistration() =>
      handleRequest(() async {
        final fcmToken = _prefRepo.fcmToken;
        final studyNo = _prefRepo.projectId;
        final pid = _prefRepo.pid ?? '';

        if (fcmToken == null) {
          throw CustomException(
            type: CustomExceptionType.unknown,
            exception: Exception('FCM token is null'),
            stackTrace: StackTrace.current,
            msg: 'FCM token is null',
          );
        }
        final req = FcmDeviceRegisterReq(
          studyNo: studyNo,
          pid: pid,
          deviceToken: fcmToken,
          deviceType: DeviceInfo.isIOS ? 'IOS' : 'ANDROID',
          deviceModel: deviceModel,
          osVersion: osVersion,
        );
        return _authRepo.updateFCMDevice(req);
      });

  /// FCM 비활성화
  Future<RequestResult<void>> deactivateFCMDevice() => handleRequest(() async {
        final fcmToken = _prefRepo.fcmToken;
        if (fcmToken == null) {
          throw CustomException(
            type: CustomExceptionType.unknown,
            exception: Exception('FCM token is null'),
            stackTrace: StackTrace.current,
            msg: 'FCM token is null',
          );
        }
        return _authRepo.deactivateFCMDevice(fcmToken);
      });

  /// Get device list for current user
  Future<RequestResult<List<Map<String, dynamic>>>> getDeviceList(
          String studyNo, String pid) =>
      handleRequest(() async {
        return _authRepo.getFCMDeviceList(studyNo, pid);
      });

  /// Helper method to get device model
  String get deviceModel => _deviceInfo.deviceModel;

  /// Helper method to get OS version
  String get osVersion => _deviceInfo.osVersion;
}
