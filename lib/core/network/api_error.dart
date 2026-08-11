import 'package:dio/dio.dart';

/// 로그인 세션(accessToken)이 없어 요청 자체를 보낼 수 없는 상태.
///
/// "서버가 빈 목록을 반환한 경우"와 구분하기 위해 존재한다.
/// 빈 리스트로 뭉개면 인증 문제가 "데이터 없음"으로 보여 원인 파악이 불가능하다.
class MissingSessionException implements Exception {
  const MissingSessionException();

  @override
  String toString() => 'MissingSessionException: accessToken이 없습니다.';
}

/// 예외를 사용자에게 보여줄 한 줄 메시지로 변환한다.
///
/// 서버 에러 응답은 `{"code":..., "message":"...", "status":..., "path":...}`
/// 형태이므로 `message`를 우선 사용하고, 없으면 상황별 기본 문구로 대체한다.
/// `e.toString()`(DioException 전체 덤프)이 화면에 노출되지 않도록 하는 것이 목적.
String parseApiErrorMessage(
  Object error, {
  String fallback = '요청을 처리하지 못했습니다. 잠시 후 다시 시도해주세요.',
}) {
  if (error is MissingSessionException) {
    return '로그인 정보가 없습니다. 다시 로그인해주세요.';
  }
  if (error is! DioException) return fallback;

  final message = _serverMessage(error.response?.data);
  if (message != null) return message;

  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return '서버 응답이 지연되고 있습니다. 잠시 후 다시 시도해주세요.';
    case DioExceptionType.connectionError:
      return '네트워크에 연결할 수 없습니다. 인터넷 상태를 확인해주세요.';
    case DioExceptionType.badResponse:
      final status = error.response?.statusCode;
      if (status != null && status >= 500) {
        return '서버에 문제가 발생했습니다. 잠시 후 다시 시도해주세요.';
      }
      return fallback;
    case DioExceptionType.cancel:
    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
      return fallback;
  }
}

/// 응답 body에서 `message` 필드를 꺼낸다. 형태가 다르면 null.
String? _serverMessage(dynamic data) {
  if (data is Map) {
    final message = data['message'];
    if (message is String && message.trim().isNotEmpty) return message.trim();
  }
  return null;
}
