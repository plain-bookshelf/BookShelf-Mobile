import 'package:dio/dio.dart';

/// Set-Cookie 헤더에서 [key] 쿠키 값을 추출
String? extractSetCookieValue(Response<dynamic> response, String key) {
  final cookies = response.headers['set-cookie'];
  if (cookies == null) return null;
  for (final cookie in cookies) {
    final match = RegExp('$key=([^;]+)').firstMatch(cookie);
    if (match != null) return match.group(1);
  }
  return null;
}
