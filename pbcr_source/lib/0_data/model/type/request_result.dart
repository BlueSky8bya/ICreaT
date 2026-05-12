import 'package:dio/dio.dart';

import 'package:icreat_dct/6_util/logger.dart';

class RequestResult<T> {
  RequestResult._();

  bool isSuccess() => this is Success;

  bool isFailure() => this is Failure;

  Future<void> onAction({
    Function(T value)? onSuccess,
    Function(CustomException e)? onError,
  }) async {
    if (isSuccess()) {
      await onSuccess?.call((this as Success).value);
    } else {
      await onError?.call((this as Failure).error);
    }
  }

  RequestResult<T> onSuccess(Function(T value) action) {
    if (isSuccess()) action((this as Success).value);
    return this;
  }

  RequestResult<T> onFailure(Function(CustomException e) action) {
    if (isFailure()) action((this as Failure).error);
    return this;
  }

  T? getOrNull() {
    if (isSuccess()) return (this as Success).value;
    return null;
  }

  T getOrThrow() {
    if (isSuccess()) {
      return (this as Success).value;
    } else {
      throw (this as Failure).error;
    }
  }

  T getOrElse(T Function(Object e) onFailure) {
    if (isSuccess()) {
      return (this as Success).value;
    } else {
      return onFailure((this as Failure).error);
    }
  }

  factory RequestResult.success(T value) = Success;

  factory RequestResult.failure(CustomException e) = Failure;
}

class Success<T> extends RequestResult<T> {
  final T value;

  Success(this.value) : super._();
}

class Failure<T> extends RequestResult<T> {
  final CustomException error;

  Failure(this.error) : super._();
}

class CustomException {
  final CustomExceptionType type;
  final Object exception;
  final StackTrace stackTrace;
  final String msg;

  CustomException({
    required this.type,
    required this.exception,
    required this.stackTrace,
    required this.msg,
  });

  @override
  String toString() {
    return 'CustomException(type: $type, exception: $exception, stackTrace: $stackTrace, msg: $msg)';
  }
}

enum CustomExceptionType { api, handled, warn, unknown }

Future<RequestResult<T>> handleRequest<T>(Future<T> Function() requestFunc) async {
  try {
    return RequestResult.success(await requestFunc());
  } catch (e, s) {
    Logger.debug("$e $s");
    if (e is DioException) {
      return RequestResult.failure(
        CustomException(
          type: CustomExceptionType.api,
          exception: e,
          stackTrace: s,
          msg: 'API 에러',
        ),
      );
    } else {
      return RequestResult.failure(
        CustomException(
          type: CustomExceptionType.unknown,
          exception: e,
          stackTrace: s,
          msg: 'Unknown Exception...',
        ),
      );
    }
  }
}

/// 서버 응답을 처리하는 통합 함수
/// 네트워크 오류와 서버 응답 오류를 모두 처리합니다.
Future<RequestResult<T>> handleServerRequest<T>({
  required Future<Map<String, dynamic>> Function() requestFunc,
  required T Function(Map<String, dynamic>) onSuccess,
  String? errorMessage,
}) async {
  try {
    final response = await requestFunc();
    final resultMessage = response['_RSLT_MSG'] as String? ?? '';
    
    if (resultMessage.isEmpty) {
      return RequestResult.success(onSuccess(response));
    } else {
      final message = response['_RSLT_MSG'] as String? ?? errorMessage ?? '요청에 실패했습니다.';
      return RequestResult.failure(
        CustomException(
          type: CustomExceptionType.api,
          exception: Exception('Server error: $resultMessage'),
          stackTrace: StackTrace.current,
          msg: message,
        ),
      );
    }
  } catch (e, s) {
    if (e is DioException) {
      return RequestResult.failure(
        CustomException(
          type: CustomExceptionType.api,
          exception: e,
          stackTrace: s,
          msg: 'API 에러',
        ),
      );
    } else {
      return RequestResult.failure(
        CustomException(
          type: CustomExceptionType.unknown,
          exception: e,
          stackTrace: s,
          msg: 'Unknown Exception...',
        ),
      );
    }
  }
}
