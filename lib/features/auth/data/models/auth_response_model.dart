/// POST /signup-member, POST /login 응답 data 필드 모델
class AuthResponseModel {
  final String username;
  final String nickname;
  final String accessToken;
  final String authority;
  final String platformType;
  final String affiliationName;
  final String profileImage;
  final String oauthProvider;
  final String refreshToken;

  const AuthResponseModel({
    required this.username,
    required this.nickname,
    required this.accessToken,
    required this.authority,
    required this.platformType,
    required this.affiliationName,
    required this.profileImage,
    required this.oauthProvider,
    required this.refreshToken,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      AuthResponseModel(
        username: json['username'] as String? ?? '',
        nickname: json['nickname'] as String? ?? '',
        accessToken: json['access_token'] as String? ?? '',
        authority: json['authority'] as String? ?? '',
        platformType: json['platform_type'] as String? ?? '',
        affiliationName: json['affiliation_name'] as String? ?? '',
        profileImage: json['profile_image'] as String? ?? '',
        oauthProvider: json['oauth_provider'] as String? ?? '',
        refreshToken: json['refresh_token'] as String? ?? '',
      );

  /// ROLE_ADMIN 이면 관리자
  bool get isAdmin => authority == 'ROLE_ADMIN';
}
