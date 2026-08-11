/// PATCH /api/member/affiliation-change 응답 엔티티
///
/// 소속 변경 성공 시 서버가 새 access_token(+refresh_token)을 함께 내려줌
class AffiliationChangeResult {
  final String affiliationName;
  final String accessToken;
  final String? refreshToken;

  const AffiliationChangeResult({
    required this.affiliationName,
    required this.accessToken,
    this.refreshToken,
  });
}
