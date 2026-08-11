import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kAccessToken = 'access_token';
const _kRefreshToken = 'refresh_token';
const _kUsername = 'username';
const _kAffiliationName = 'affiliation_name';

// main()에서 미리 읽은 토큰을 ProviderScope override로 주입
final storedAccessTokenProvider = Provider<String?>((ref) => null);
final storedRefreshTokenProvider = Provider<String?>((ref) => null);
final storedUsernameProvider = Provider<String?>((ref) => null);
final storedAffiliationNameProvider = Provider<String?>((ref) => null);

class AuthSession {
  final String? accessToken;
  final String? refreshToken;

  /// 로그인 아이디 (이메일 형식). 추천 API의 member_id 파라미터 등에 사용
  final String? username;

  /// 현재 소속(도서관) 이름
  final String? affiliationName;

  const AuthSession({
    this.accessToken,
    this.refreshToken,
    this.username,
    this.affiliationName,
  });

  AuthSession copyWith({
    String? accessToken,
    String? refreshToken,
    String? username,
    String? affiliationName,
  }) => AuthSession(
    accessToken: accessToken ?? this.accessToken,
    refreshToken: refreshToken ?? this.refreshToken,
    username: username ?? this.username,
    affiliationName: affiliationName ?? this.affiliationName,
  );
}

class AuthSessionNotifier extends Notifier<AuthSession> {
  @override
  AuthSession build() {
    final accessToken = ref.watch(storedAccessTokenProvider);
    final refreshToken = ref.watch(storedRefreshTokenProvider);
    final username = ref.watch(storedUsernameProvider);
    final affiliationName = ref.watch(storedAffiliationNameProvider);
    return AuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      username: username,
      affiliationName: affiliationName,
    );
  }

  Future<void> setTokens({
    required String accessToken,
    String? refreshToken,
    String? username,
    String? affiliationName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setString(_kAccessToken, accessToken),
      if (refreshToken != null) prefs.setString(_kRefreshToken, refreshToken),
      if (username != null) prefs.setString(_kUsername, username),
      if (affiliationName != null)
        prefs.setString(_kAffiliationName, affiliationName),
    ]);
    state = state.copyWith(
      accessToken: accessToken,
      refreshToken: refreshToken,
      username: username,
      affiliationName: affiliationName,
    );
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove(_kAccessToken),
      prefs.remove(_kRefreshToken),
      prefs.remove(_kUsername),
      prefs.remove(_kAffiliationName),
    ]);
    state = const AuthSession();
  }
}

final authSessionProvider = NotifierProvider<AuthSessionNotifier, AuthSession>(
  AuthSessionNotifier.new,
);
