import 'package:dio/dio.dart';
import 'package:icreat_dct/6_util/logger.dart';

class AuthDioInterceptor extends Interceptor {
  AuthDioInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers['Accept'] = 'application/json, text/javascript, */*; q=0.01';
    options.headers['Content-Type'] = 'application/json';
    Logger.debug('options ${options.headers}');
    handler.next(options);
  }
}
