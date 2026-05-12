import 'package:get/get.dart';

import 'package:icreat_dct/0_data/model/auth/login_result.dart';
import 'package:icreat_dct/0_data/model/type/request_result.dart';
import 'package:icreat_dct/0_data/dto/auth/login_req.dart';
import 'package:icreat_dct/0_data/dto/auth/login_result_res.dart';
import 'package:icreat_dct/1_service/event_bus_service.dart';
import 'package:icreat_dct/1_service/secure_storage_service.dart';
import 'package:icreat_dct/2_repository/auth_repository.dart';
import 'package:icreat_dct/2_repository/pref_repository.dart';
import 'package:icreat_dct/6_util/logger.dart';

enum AuthState {
  beforeLogIn,
  inLogingIn,
  loggedIn,
  inClearing;
}

class AuthService {

  final AuthRepository _authRepo;
  final PrefRepository _prefRepo;

  late final Rx<AuthState> _authState = AuthState.beforeLogIn.obs;

  AuthService(this._authRepo, this._prefRepo) {

    // register event handlers
    EventBusService().subscribe<EventSubjectLoggedIn>((event){
      _authState.value = AuthState.loggedIn;
    });

    EventBusService().subscribe<EventSessionExpired>((event) async {
      Logger.debug("event handle: $EventSessionExpired on AuthService");
      _authState.value = AuthState.inClearing;

      await _unregisterFCMDevice();
      await SecureStorageService().clear();

      _authState.value = AuthState.beforeLogIn;
    });
  }

  bool get isLogin {
    return _authState.value == AuthState.inLogingIn;
  }

  Future<void> saveDctSessionId(String dctSessionId) async {
    SecureStorageService().saveSessionToken(dctSessionId);
  }

  Future<String?> getDctSessionId() async {
    return await SecureStorageService().getSessionToken();
  }

  Future<RequestResult<LoginResult>> login(LoginReq loginReq) =>
      handleRequest(() async {
        _authState.value = AuthState.inLogingIn;
        final result = await _authRepo.login(loginReq);
        return result.toModel();
      });

  /// Unregister FCM device
  Future<RequestResult<void>> _unregisterFCMDevice() =>
      handleRequest(() async {
        final fcmToken = _prefRepo.fcmToken;
        if (fcmToken == null) {
          throw CustomException(
            type: CustomExceptionType.unknown,
            exception: Exception('FCM token is null'),
            stackTrace: StackTrace.current,
            msg: 'FCM token is null',
          );
        }
        await _authRepo.unregisterFCMDevice(fcmToken);
      });
}
