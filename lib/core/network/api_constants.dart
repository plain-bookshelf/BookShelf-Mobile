/// API 엔드포인트 상수
abstract class ApiConstants {
  /// TODO: 실제 서버 주소로 변경
  static const baseUrl = 'https://bookmaru.dsmhs.kr';

  // ── Auth ──────────────────────────────────────
  static const signUpMember = '/api/member/signup-member';
  static const signUpOfficial = '/api/member/signup-official';
  static const signUpSocial = '/api/memeber/signup-social';
}
