import 'package:dio/dio.dart';
import 'package:icreat_dct/6_util/logger.dart';

class EsourceDioInterceptor extends Interceptor {
  EsourceDioInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept'] =
        'application/json, text/javascript, */*; q=0.01';
    options.headers['Content-Type'] = 'application/json';
    Logger.debug('options ${options.headers}');
    super.onRequest(options, handler);
  }
}
