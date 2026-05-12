import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:icreat_dct/1_service/fcm/base/base_fcm_service.dart';
import 'package:icreat_dct/1_service/fcm/base/base_push_data.dart';
import 'package:icreat_dct/1_service/fcm/cmn_notification_util.dart';
import 'package:icreat_dct/1_service/fcm/cmn_push_util.dart';
import 'package:icreat_dct/1_service/fcm/data/default_push_data.dart';
import 'package:icreat_dct/0_data/model/fcm/fcm_device_register_req.dart';
import 'package:icreat_dct/2_repository/auth_repository.dart';
import 'package:icreat_dct/2_repository/pref_repository.dart';
import 'package:icreat_dct/6_util/device_info.dart';
import 'package:icreat_dct/6_util/logger.dart';

class CMNFcmService extends BaseFcmService {
  CMNFcmService({
    required this.prefHelper,
    required this.deviceInfo,
    required CMNNotificationUtil notificationUtil,
    required CMNPushUtil pushUtil,
    required this.authRepository,
  }) : super(
          notiUtil: notificationUtil,
          pushUtil: pushUtil,
        );

  final PrefRepository prefHelper;
  final DeviceInfo deviceInfo;
  final AuthRepository authRepository;

  @override
  void initListenOnBackgroundMsg() {
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMsg);
  }

  @pragma('vm:entry-point')
  static Future<void> _onBackgroundMsg(
    RemoteMessage fcmMsg,
  ) async {
    Logger.info('remoteMessage data = ${fcmMsg.data}', tag: 'FCM');

    final pushUtil = CMNPushUtil();
    var pushData = pushUtil.getPushDataFromFcmMsg(fcmMsg);

    if (pushData != null) {
      processWhenRecvPush(
        pushData: pushData as DefaultPushData,
      );
    }
  }

  static void processWhenRecvPush({
    required DefaultPushData pushData,
  }) async {}

  @override
  void actionWhenRecvPush(BasePushData pushData) => processWhenRecvPush(
        pushData: pushData as DefaultPushData,
      );

  @override
  String? get savedFcmToken => prefHelper.fcmToken;

  @override
  Future<void> saveFcmToken(String? newToken) async {
    if (newToken == null) return;
    Logger.info('new token = $newToken', tag: tag);
    await prefHelper.setFcmToken(newToken);

    final studyNo = prefHelper.projectId;
    final pid = prefHelper.pid;

    await authRepository.registerFCMDevice(FcmDeviceRegisterReq(
      studyNo: studyNo,
      pid: pid,
      deviceToken: newToken,
      deviceModel: deviceInfo.deviceModel,
      osVersion: deviceInfo.osVersion,
    ));
  }

  // TODO: 추후 구현
  // Future<RequestResult<void>> _updateFcmToken({
  //   required String userUid,
  //   required String newToken,
  // }) =>
  //     handleRequest(() async {
  //       final dio = Dio()
  //         ..options.baseUrl = BuildConfig.crzApiAddr
  //         ..options.connectTimeout = const Duration(seconds: 10) // 10s
  //         ..options.receiveTimeout = const Duration(seconds: 10) // 10s
  //         ..options.headers['Version'] = Constant.careeaseApiVersion
  //         ..options.headers['Accept'] = 'application/json'
  //         ..options.headers['Authorization'] = HiveStorage.accessToken
  //         ..interceptors.add(DioHelper.logInterceptor);

  //       final deviceId = deviceInfo.deviceId;
  //       final deviceModel = deviceInfo.deviceModel;
  //       try {
  //         await dio.post(
  //           'v4/users/$userUid/fcm-token',
  //           data: jsonEncode(
  //             RefreshFcmTokenReq(
  //               deviceId: deviceId,
  //               fcmToken: newToken,
  //               deviceModel: deviceModel,
  //             ),
  //           ),
  //         );
  //       } catch (e, s) {
  //         Logger.error('updateFcmToken ERROR', e: e, s: s);
  //       }
  //     });
}
