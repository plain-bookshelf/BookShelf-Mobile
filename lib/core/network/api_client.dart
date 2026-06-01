import 'package:bookshelf_mobile/core/network/api_constants.dart';
import 'package:bookshelf_mobile/core/network/auth_interceptor.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dio 싱글톤 인스턴스를 제공하는 Riverpod Provider
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: const {'Content-Type': 'application/json'},
      followRedirects: false,        // 302를 직접 감지하기 위해 자동 리다이렉트 비활성화
      validateStatus: (status) => status != null && status < 400,
    ),
  );

  dio.interceptors.add(AuthInterceptor(ref, appRouter));

  // 개발용 로그 인터셉터 (TODO: release 빌드에서 제거)
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
    requestHeader: true,
    responseHeader: true,
  ));

  return dio;
});
