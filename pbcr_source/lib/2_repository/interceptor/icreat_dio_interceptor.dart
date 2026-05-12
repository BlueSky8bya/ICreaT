import 'package:dio/dio.dart';
import 'package:icreat_dct/1_service/event_bus_service.dart';
import 'package:icreat_dct/6_util/logger.dart';

class IcreatDioInterceptor extends Interceptor {

  IcreatDioInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers['Accept'] = 'application/json, text/javascript, */*; q=0.01';
    options.headers['Content-Type'] = 'application/json';
    Logger.debug('options ${options.headers}');
    handler.next(options);
  }

  /// 세션 만료 시 로그인 화면으로 이동하는 로직 onError
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      EventBusService().fire(EventSessionExpired());
    }
    super.onError(err, handler);
  }

  /// 세션 만료 시 로그인 화면으로 이동하는 로직 onResponse
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {

    if (response.data is Map<String, dynamic>) {
      if (response.data['_error_cd'] == 'AE') {
        EventBusService().fire(EventSessionExpired());
      }
    }

    super.onResponse(response, handler);
  }

}
