import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:icreat_dct/0_data/model/fcm/fcm_device_register_req.dart';
import 'package:icreat_dct/0_data/dto/auth/login_req.dart';
import 'package:icreat_dct/0_data/dto/auth/login_result_res.dart';
import 'package:icreat_dct/1_service/secure_storage_service.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  Future<Response<dynamic>> dioPostWithSession({required String path, Map<String, dynamic>? data}) async {
    final sessionCookie = await SecureStorageService().getSessionToken();
    return await _dio.post(path,
      data: data,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Dct-Session-Id': sessionCookie,
        },
      ),
    );
  }

  Future<LoginResultRes> login(LoginReq loginReq) async {
    final result = await _dio.post('/api/login',
      data: jsonEncode(loginReq.toJson()),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (result.data is String) {
      return LoginResultRes.fromJson(jsonDecode(result.data));
    }

    return LoginResultRes.fromJson(result.data);
  }

  // --- FCM ---

  Future<void> registerFCMDevice(FcmDeviceRegisterReq req) async {
    await dioPostWithSession(
      path: '/api/device/register',
      data: req.toJson()
    );
  }

  Future<void> unregisterFCMDevice(String deviceToken) async {
    await dioPostWithSession(
      path: '/api/device/unregister',
      data: {
        'device_token': deviceToken
      },
    );
  }

  Future<void> updateFCMDevice(FcmDeviceRegisterReq req) async {
    await dioPostWithSession(
      path: '/api/device/update',
      data: req.toJson(),
    );
  }

  Future<void> deactivateFCMDevice(String deviceToken) async {
    await dioPostWithSession(
      path: '/api/device/deactivate',
      data: {
        'device_token': deviceToken
      },
    );
  }

  /// 테스트 용도?
  Future<List<Map<String, dynamic>>> getFCMDeviceList(String studyNo, String pid) async {
    final response = await dioPostWithSession(
      path: '/api/device/getDeviceList',
      data: {
        'stdy_no': studyNo,
        'pid': pid,
      },
    );

    if (response.data is String) {
      return jsonDecode(response.data);
    }

    return response.data;
  }
}
