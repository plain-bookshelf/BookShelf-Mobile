import 'package:bookshelf_mobile/core/network/auth_session_provider.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AuthInterceptor extends Interceptor {
  final Ref _ref;
  final GoRouter _router;

  AuthInterceptor(this._ref, this._router);

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 302이고 Location 헤더가 /login을 가리키면 토큰 만료로 판단
    if (response.statusCode == 302) {
      final location = response.headers.value('location') ?? '';
      if (location.contains('/login')) {
        _handleUnauthorized();
        // 이후 처리 중단 (에러로 전환)
        handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );
        return;
      }
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;
    final location = err.response?.headers.value('location') ?? '';

    if (statusCode == 401 ||
        (statusCode == 302 && location.contains('/login'))) {
      _handleUnauthorized();
    }

    handler.next(err);
  }

  Future<void> _handleUnauthorized() async {
    await _ref.read(authSessionProvider.notifier).clear();
    _router.go(AppRoutes.login);
  }
}
