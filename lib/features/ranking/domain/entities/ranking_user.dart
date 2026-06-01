/// 랭킹 사용자 도메인 엔티티
class RankingUser {
  final int rank;
  final String userName;
  final String? institution; // 소속 (4위 이하에서 표시)
  final int bookCount;       // 대여한 책 수
  final String? avatarUrl;

  const RankingUser({
    required this.rank,
    required this.userName,
    required this.bookCount,
    this.institution,
    this.avatarUrl,
  });

  bool get isTopThree => rank <= 3;
}
