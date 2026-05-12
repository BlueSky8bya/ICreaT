import 'package:dio/dio.dart';

class DioLogInterceptor extends LogInterceptor {
  /// 에러는 조건검사 예외 무조건 허용
  final bool allowAllErrors;

  /// GET, POST, PUT, DELETE만 허용 여부
  late final List<String> _allowedMethods;

  /// 로그 출력 조건 검사 후 해당 문자열이 있을 경우 출력하지 않음
  /// https://domain.com/path/asd 가 있으면
  /// https://domain.com 는 무시하고 /path/asd만 조건 검사의 대상
  late final List<String> _ignoredPaths;

  DioLogInterceptor({
    super.request = true,
    super.requestHeader = true,
    super.requestBody = false,
    super.responseHeader = true,
    super.responseBody = false,
    super.error = true,
    super.logPrint,
    this.allowAllErrors = true,
    List<String> allowedMethods = const ['GET', 'POST', 'PUT', 'DELETE'],
    List<String> ignoredPaths = const [],
  }) {
    _allowedMethods = allowedMethods;
    _ignoredPaths = ignoredPaths;
  }

  @override
  void onRequest(RequestOptions options,RequestInterceptorHandler handler) {
    if (!_checkIsPrintAllowedOnRequest(options)) {
      handler.next(options);
      return;
    }

    logPrint('*** Request ***');
    _printKV('uri', options.uri);
    _printKV('baseUrl', options.baseUrl);
    _printKV('path', options.path);

    if (request) {
      _printKV('method', options.method);
      _printKV('responseType', options.responseType.toString());
      _printKV('followRedirects', options.followRedirects);
      _printKV('persistentConnection', options.persistentConnection);
      _printKV('connectTimeout', options.connectTimeout);
      _printKV('sendTimeout', options.sendTimeout);
      _printKV('receiveTimeout', options.receiveTimeout);
      _printKV(
        'receiveDataWhenStatusError',
        options.receiveDataWhenStatusError,
      );
      _printKV('extra', options.extra);
    }
    if (requestHeader) {
      logPrint('headers:');
      options.headers.forEach((key, v) => _printKV(' $key', v));
    }
    if (requestBody) {
      logPrint('data:');
      _printAll(options.data);
    }
    logPrint('');

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {

    if (!_checkIsPrintAllowedOnResponse(response)) {
      handler.next(response);
      return;
    }

    logPrint('*** Response ***');
    _printResponse(response);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!_checkIsPrintAllowedOnError(err)) {
      handler.next(err);
      return;
    }

    if (error) {
      logPrint('*** DioException ***:');
      logPrint('uri: ${err.requestOptions.uri}');
      logPrint('$err');
      if (err.response != null) {
        _printResponse(err.response!);
      }
      logPrint('');
    }

    handler.next(err);
  }

  bool _checkIsPrintAllowedOnRequest(
    RequestOptions options,
  ) {
    return _checkIsAllowedMethod(options.method) &&
        !_checkIsIgnoredPath(options.path);
  }

  bool _checkIsPrintAllowedOnResponse(
    Response response,
  ) {
    return _checkIsAllowedMethod(response.requestOptions.method) &&
        !_checkIsIgnoredPath(response.requestOptions.path);
  }

  bool _checkIsPrintAllowedOnError(
    DioException err,
  ) {
    if (allowAllErrors) return true;

    return _checkIsAllowedMethod(err.requestOptions.method) &&
        !_checkIsIgnoredPath(err.requestOptions.path);
  }

  bool _checkIsAllowedMethod(String method) {
    return _allowedMethods.contains(method);
  }

  // path가 disallowedPaths에 포함되어 있는지 확인
  bool _checkIsIgnoredPath(String path) {
    return _ignoredPaths.any((ignoredString) => path.contains(ignoredString));
  }

  void _printResponse(Response response) {
    _printKV('uri', response.requestOptions.uri);
    if (responseHeader) {
      _printKV('statusCode', response.statusCode);
      if (response.isRedirect == true) {
        _printKV('redirect', response.realUri);
      }

      logPrint('headers:');
      response.headers.forEach((key, v) => _printKV(' $key', v.join('\r\n\t')));
    }
    if (responseBody) {
      logPrint('Response Text:');
      _printAll(response.toString());
    }
    logPrint('');
  }

  void _printKV(String key, Object? v) {
    logPrint('$key: $v');
  }

  void _printAll(msg) {
    msg.toString().split('\n').forEach(logPrint);
  }
}
