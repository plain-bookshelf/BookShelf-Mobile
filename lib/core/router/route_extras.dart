// go_router extra 전달 타입 모음
//
// 온보딩 상태(장르·독서시간)는 OnboardingNotifier로 관리하므로
// ReadingTimeExtra / RecommendExtra 는 제거되었습니다.

/// 이메일 인증 페이지로 전달하는 extra
class EmailVerifyExtra {
  final String email;
  final bool isAdmin;

  const EmailVerifyExtra({required this.email, this.isAdmin = false});
}

/// 비밀번호 찾기 인증 페이지로 전달하는 extra
class FindPasswordVerifyExtra {
  final String email;

  const FindPasswordVerifyExtra({required this.email});
}

/// 비밀번호 변경 페이지로 전달하는 extra
/// [registerToken] : /find-password 에서 받은 토큰 (비밀번호 찾기 경로)
class ChangePasswordExtra {
  final String registerToken;
  final String email;

  const ChangePasswordExtra({required this.registerToken, required this.email});
}
