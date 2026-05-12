import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 네비게이션 방법을 정의하는 열거형
/// 각 방법은 다른 네비게이션 동작을 수행합니다
enum NavigatingMethod {
  /// 현재 스택을 모두 제거하고 새로운 라우트로 이동
  go,
  /// 현재 스택 위에 새로운 라우트를 추가
  push,
  /// 현재 라우트를 새로운 라우트로 교체
  replacement,
  /// 현재 스택을 모두 제거하고 새로운 라우트로 이동 (pushReplacementNamed 사용)
  pushReplacement,
  /// 이전 라우트로 돌아가기
  pop,
}

/// 네비게이션 결과를 나타내는 클래스
class NavigationResult<T> {
  final bool success;
  final T? data;
  final String? error;

  const NavigationResult({
    required this.success,
    this.data,
    this.error,
  });

  factory NavigationResult.success([T? data]) => NavigationResult(
        success: true,
        data: data,
      );

  factory NavigationResult.error(String error) => NavigationResult(
        success: false,
        error: error,
      );
}

/// NavigatingMethod에 대한 확장 메서드
extension NavigationMethodExt on NavigatingMethod {
  /// 타입 안전한 네비게이션을 수행합니다
  /// 
  /// [context] - BuildContext
  /// [name] - 라우트 이름
  /// [pathParameters] - 경로 파라미터
  /// [queryParameters] - 쿼리 파라미터
  /// [extra] - 추가 데이터 (타입 안전성을 위해 제네릭 사용)
  /// 
  /// Returns: NavigationResult&lt;T&gt; - 네비게이션 결과
  Future<NavigationResult<T>> navigateTo<T>({
    required BuildContext context,
    required String name,
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    T? extra,
  }) async {
    try {
      switch (this) {
        case NavigatingMethod.go:
          context.goNamed(
            name,
            pathParameters: pathParameters,
            queryParameters: queryParameters,
            extra: extra,
          );
          return NavigationResult.success();

        case NavigatingMethod.push:
          final result = await context.pushNamed<T>(
            name,
            pathParameters: pathParameters,
            queryParameters: queryParameters,
            extra: extra,
          );
          return NavigationResult.success(result);

        case NavigatingMethod.pushReplacement:
          context.pushReplacementNamed(
            name,
            pathParameters: pathParameters,
            queryParameters: queryParameters,
            extra: extra,
          );
          return NavigationResult.success();

        case NavigatingMethod.replacement:
          context.replaceNamed(
            name,
            pathParameters: pathParameters,
            queryParameters: queryParameters,
            extra: extra,
          );
          return NavigationResult.success();

        case NavigatingMethod.pop:
          final result = context.pop<T>() as T?;
          return NavigationResult.success(result);
      }
    } catch (e) {
      return NavigationResult.error('Navigation failed: ${e.toString()}');
    }
  }

  /// 간단한 네비게이션을 위한 헬퍼 메서드
  /// 에러 처리가 필요 없는 경우 사용
  void navigateToSimple({
    required BuildContext context,
    required String name,
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) {
    switch (this) {
      case NavigatingMethod.go:
        context.goNamed(
          name,
          pathParameters: pathParameters,
          queryParameters: queryParameters,
          extra: extra,
        );
        break;
      case NavigatingMethod.push:
        context.pushNamed(
          name,
          pathParameters: pathParameters,
          queryParameters: queryParameters,
          extra: extra,
        );
        break;
      case NavigatingMethod.pushReplacement:
        context.pushReplacementNamed(
          name,
          pathParameters: pathParameters,
          queryParameters: queryParameters,
          extra: extra,
        );
        break;
      case NavigatingMethod.replacement:
        context.replaceNamed(
          name,
          pathParameters: pathParameters,
          queryParameters: queryParameters,
          extra: extra,
        );
        break;
      case NavigatingMethod.pop:
        context.pop();
        break;
    }
  }
}
