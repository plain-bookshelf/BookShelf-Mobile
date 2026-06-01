/// 앱 전체 실패(Failure) 타입
sealed class Failure {
  final String message;
  const Failure(this.message);
}

/// 서버/네트워크 오류
final class ServerFailure extends Failure {
  const ServerFailure([super.message = '서버 오류가 발생했습니다.']);
}

/// 인증 오류 (토큰 만료, 권한 없음 등)
final class AuthFailure extends Failure {
  const AuthFailure([super.message = '인증에 실패했습니다.']);
}

/// 네트워크 연결 오류
final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = '네트워크를 확인해주세요.']);
}

/// 입력값 오류
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// 예상치 못한 오류
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = '알 수 없는 오류가 발생했습니다.']);
}
