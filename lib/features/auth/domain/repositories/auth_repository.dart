import 'package:bookshelf_mobile/features/auth/domain/entities/user.dart';

/// 인증 Repository 인터페이스 (Domain Layer)
abstract interface class AuthRepository {
  /// 로그인
  Future<User> login({required String username, required String password});

  /// 토큰 재발급
  Future<User> reissue({required String refreshToken});

  /// 회원가입 인증 이메일 발송 (codeType=VERIFICATION_EMAIL)
  Future<void> sendVerificationEmail(String email);

  /// 비밀번호 찾기 이메일 발송 (codeType=FIND_PASSWORD)
  Future<void> sendFindPasswordEmail(String email);

  /// 이메일 인증 코드 확인
  Future<void> verifyEmailCode({required String email, required String code});

  /// 회원가입
  /// [isAdmin] : true면 관계자(관리자) 가입(/signup-official), false면 일반 회원가입(/signup-member)
  Future<User> register({
    required String username,
    required String email,
    required String password,
    required String affiliationName,
    required String verificationCode,
    bool isAdmin = false,
  });

  /// 회원 탈퇴
  Future<void> deleteAccount({required String accessToken});

  /// 로그아웃
  Future<void> logout({required String accessToken});

  /// 비밀번호 찾기 인증 코드 확인 → register_token 반환
  Future<String> findPassword({
    required String email,
    required String verificationCode,
  });

  /// 비밀번호 재설정 이메일 발송
  Future<void> sendPasswordResetEmail(String email);

  /// 비밀번호 재설정 (비밀번호 찾기 경로, register_token 사용)
  Future<void> resetPassword({
    required String registerToken,
    required String email,
    required String newPassword,
  });

  /// 비밀번호 변경 (로그인 상태, 기존 비밀번호 사용)
  Future<void> changePassword({
    required String accessToken,
    required String existingPassword,
    required String newPassword,
  });
}
