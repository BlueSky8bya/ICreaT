import 'package:dio/dio.dart';
import 'package:dio_mock_interceptor/dio_mock_interceptor.dart';
import 'package:flutter/foundation.dart';

import 'package:icreat_dct/6_util/logger.dart';
import 'package:icreat_dct/build_config.dart';

import 'interceptor/dio_log_interceptor.dart';
import 'interceptor/auth_dio_interceptor.dart';
import 'interceptor/esource_dio_interceptor.dart';
import 'interceptor/icreat_dio_interceptor.dart';

class DioFactory {
  static final LogInterceptor logInterceptor = DioLogInterceptor(
    requestBody: false,
    responseBody: false, // disable to print response body
    allowedMethods: [
      'GET',
      'POST',
      'PUT',
      'DELETE',
    ],
    ignoredPaths: [],
    logPrint: (obj) => Logger.api('$obj'),
  );

  static AuthDioInterceptor authDioInterceptor = AuthDioInterceptor();

  static IcreatDioInterceptor icreatDioInterceptor = IcreatDioInterceptor();

  static EsourceDioInterceptor esourceDioInterceptor = EsourceDioInterceptor();

  static final MockInterceptor mockInterceptor = MockInterceptor();

  static Dio getDioClientForAuth() {
    var dio = Dio()
      ..options.baseUrl = BuildConfig.apiBaseUrl
      ..options.connectTimeout = const Duration(seconds: 10) // 10s
      ..options.receiveTimeout = const Duration(seconds: 10) // 10s
      ..interceptors.add(authDioInterceptor);

    if (!kReleaseMode) {
      dio.interceptors.add(logInterceptor);
      if (BuildConfig.enableMocking) {
        dio.interceptors.add(mockInterceptor);
      }
    }

    return dio;
  }

  static Dio getDioClientForApi() {
    var dio = Dio()
      ..options.baseUrl = BuildConfig.apiBaseUrl
      ..options.connectTimeout = const Duration(seconds: 10) // 10s
      ..options.receiveTimeout = const Duration(seconds: 10) // 10s
      ..interceptors.add(logInterceptor)
      ..interceptors.add(icreatDioInterceptor);

    if (!kReleaseMode) {
      dio.interceptors.add(logInterceptor);
      if (BuildConfig.enableMocking) {
        dio.interceptors.add(mockInterceptor);
      }
    }

    return dio;
  }

  static Dio getDioClientForEsource() {
    var dio = Dio()
      ..options.baseUrl = BuildConfig.esourceApiBaseUrl
      ..options.connectTimeout = const Duration(seconds: 10) // 10s
      ..options.receiveTimeout = const Duration(seconds: 10) // 10s
      ..interceptors.add(logInterceptor)
      ..interceptors.add(esourceDioInterceptor);

    if (!kReleaseMode) {
      dio.interceptors.add(logInterceptor);
      if (BuildConfig.enableMocking) {
        dio.interceptors.add(mockInterceptor);
      }
    }

    return dio;
  }
}
