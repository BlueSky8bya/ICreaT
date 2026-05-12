import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:icreat_dct/0_data/dto/notification/delete_notification_req.dart';
import 'package:icreat_dct/0_data/dto/notification/get_notifications_req.dart';
import 'package:icreat_dct/0_data/dto/notification/get_notifications_res.dart';
import 'package:icreat_dct/0_data/dto/notification/mark_notification_read_req.dart';
import 'package:icreat_dct/1_service/secure_storage_service.dart';

class NotificationRepository {
  final Dio _dio;

  NotificationRepository(this._dio);

  Future<Response<dynamic>> dioPostWithSessionCookie(String path, {required dynamic data}) async {
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

  Future<GetNotificationsRes> getNotifications(GetNotificationsReq request) async {
    final response = await dioPostWithSessionCookie(
      '/api/getNotifications',
      data: jsonEncode(request.toJson()),
    );

    if (response.data is String) {
      return GetNotificationsRes.fromJson(jsonDecode(response.data));
    }
    return GetNotificationsRes.fromJson(response.data);
  }

  Future<Map<String, dynamic>> getNotificationDetail(String notificationId) async {
    final response = await dioPostWithSessionCookie(
      '/api/getNotificationDetail',
      data: {
        'notification_id': notificationId,
      },
    );
    if (response.data is String) {
      return jsonDecode(response.data);
    }
    return response.data;
  }

  Future<Map<String, dynamic>> markNotificationAsRead(MarkNotificationReadReq request) async {
    final response = await dioPostWithSessionCookie(
      '/api/markNotificationAsRead',
      data: jsonEncode(request.toJson()),
    );
    if (response.data is String) {
      return jsonDecode(response.data);
    }
    return response.data;
  }

  Future<Map<String, dynamic>> markNotificationsAsRead(MarkNotificationsReadReq request) async {
    final response = await dioPostWithSessionCookie(
      '/api/markNotificationsAsRead',
      data: jsonEncode(request.toJson()),
    );
    if (response.data is String) {
      return jsonDecode(response.data);
    }
    return response.data;
  }

  Future<Map<String, dynamic>> deleteNotification(DeleteNotificationReq request) async {
    final response = await dioPostWithSessionCookie(
      '/api/deleteNotification',
      data: jsonEncode(request.toJson()),
    );
    if (response.data is String) {
      return jsonDecode(response.data);
    }
    return response.data;
  }

  Future<Map<String, dynamic>> deleteNotifications(DeleteNotificationsReq request) async {
    final response = await dioPostWithSessionCookie(
      '/api/deleteNotifications',
      data: jsonEncode(request.toJson()),
    );
    if (response.data is String) {
      return jsonDecode(response.data);
    }
    return response.data;
  }
}
