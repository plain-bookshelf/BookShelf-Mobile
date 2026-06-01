/// 사용자 도메인 엔티티
class User {
  final String id;
  final String email;
  final String name;
  final bool isAdmin;
  final int? rentalDaysLeft;
  final String? accessToken;
  final String? refreshToken;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.isAdmin,
    this.rentalDaysLeft,
    this.accessToken,
    this.refreshToken,
  });
}
