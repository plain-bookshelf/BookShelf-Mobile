import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kAccessToken = 'access_token';
const _kRefreshToken = 'refresh_token';

// main()에서 미리 읽은 토큰을 ProviderScope override로 주입
final storedAccessTokenProvider = Provider<String?>((ref) => null);
final storedRefreshTokenProvider = Provider<String?>((ref) => null);

class AuthSession {
  final String? accessToken;
  final String? refreshToken;

  const AuthSession({this.accessToken, this.refreshToken});

  AuthSession copyWith({String? accessToken, String? refreshToken}) =>
      AuthSession(
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
      );
}

class AuthSessionNotifier extends Notifier<AuthSession> {
  @override
  AuthSession build() {
    final accessToken = ref.watch(storedAccessTokenProvider);
    final refreshToken = ref.watch(storedRefreshTokenProvider);
    return AuthSession(accessToken: accessToken, refreshToken: refreshToken);
  }

  Future<void> setTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAccessToken, accessToken);
    if (refreshToken != null) {
      await prefs.setString(_kRefreshToken, refreshToken);
    }
    state = state.copyWith(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kAccessToken);
    await prefs.remove(_kRefreshToken);
    state = const AuthSession();
  }
}

final authSessionProvider =
    NotifierProvider<AuthSessionNotifier, AuthSession>(AuthSessionNotifier.new);
