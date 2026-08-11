import 'package:bookshelf_mobile/core/network/api_constants.dart';
import 'package:bookshelf_mobile/core/network/auth_interceptor.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 공통 BaseOptions + 개발용 로그 인터셉터를 갖춘 Dio 인스턴스 생성
Dio _buildDio(
  String baseUrl, {
  bool followRedirects = true,
  int? maxRedirectStatus,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: const {'Content-Type': 'application/json'},
      followRedirects: followRedirects,
      validateStatus: maxRedirectStatus == null
          ? null
          : (status) => status != null && status < maxRedirectStatus,
    ),
  );

  // 개발용 로그 인터셉터 (TODO: release 빌드에서 제거)
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: true,
    ),
  );

  return dio;
}

/// 메인 서버(baseUrl1) Dio 싱글톤 인스턴스를 제공하는 Riverpod Provider
final dioProvider = Provider<Dio>((ref) {
  // 302를 직접 감지하기 위해 자동 리다이렉트 비활성화
  final dio = _buildDio(
    ApiConstants.baseUrl1,
    followRedirects: false,
    maxRedirectStatus: 400,
  );
  dio.interceptors.insert(0, AuthInterceptor(ref, appRouter));
  return dio;
});

/// 추천(ML) 서버(baseUrl2) Dio 싱글톤 인스턴스를 제공하는 Riverpod Provider
/// 메인 서버와 별도의 서버 IP를 쓰기 때문에 baseUrl이 다르고,
/// 로그인 세션과 무관한 서버라 AuthInterceptor는 붙이지 않음
final recommendDioProvider = Provider<Dio>(
  (ref) => _buildDio(ApiConstants.baseUrl2),
);
