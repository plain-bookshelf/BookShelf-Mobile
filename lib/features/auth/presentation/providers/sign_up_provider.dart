import 'package:bookshelf_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── 상태 ──────────────────────────────────────────────────────────────────────
class SignUpState {
  final String username;
  final String email;
  final String password;
  final String affiliationName;
  final String verificationCode;
  final bool isAdmin;
  final bool isLoading;
  final String? errorMessage;

  const SignUpState({
    this.username = '',
    this.email = '',
    this.password = '',
    this.affiliationName = '',
    this.verificationCode = '',
    this.isAdmin = false,
    this.isLoading = false,
    this.errorMessage,
  });

  SignUpState copyWith({
    String? username,
    String? email,
    String? password,
    String? affiliationName,
    String? verificationCode,
    bool? isAdmin,
    bool? isLoading,
    String? errorMessage,
  }) =>
      SignUpState(
        username: username ?? this.username,
        email: email ?? this.email,
        password: password ?? this.password,
        affiliationName: affiliationName ?? this.affiliationName,
        verificationCode: verificationCode ?? this.verificationCode,
        isAdmin: isAdmin ?? this.isAdmin,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage,
      );
}

// ── Notifier ──────────────────────────────────────────────────────────────────
class SignUpNotifier extends Notifier<SignUpState> {
  bool _mounted = true;

  @override
  SignUpState build() {
    ref.onDispose(() => _mounted = false);
    return const SignUpState();
  }

  void setUsername(String v) => state = state.copyWith(username: v);
  void setEmail(String v) => state = state.copyWith(email: v);
  void setPassword(String v) => state = state.copyWith(password: v);
  void setAffiliationName(String v) => state = state.copyWith(affiliationName: v);
  void setVerificationCode(String v) => state = state.copyWith(verificationCode: v);
  void setIsAdmin({required bool isAdmin}) =>
      state = state.copyWith(isAdmin: isAdmin);

  /// POST /signup-member 호출
  ///
  /// 성공 → true, 실패 → false (state.errorMessage 에 오류 메시지 설정)
  Future<bool> submit() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await ref.read(authRepositoryProvider).register(
            username: state.username,
            email: state.email,
            password: state.password,
            affiliationName: state.affiliationName,
            verificationCode: state.verificationCode,
          );
      if (!_mounted) return false;
      state = state.copyWith(isLoading: false);
      return true;
    } on DioException catch (e) {
      if (!_mounted) return false;
      state = state.copyWith(
        isLoading: false,
        errorMessage: _parseError(e),
      );
      return false;
    } catch (_) {
      if (!_mounted) return false;
      state = state.copyWith(
        isLoading: false,
        errorMessage: '회원가입에 실패했습니다. 다시 시도해주세요.',
      );
      return false;
    }
  }

  String _parseError(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['message'] != null) {
      return data['message'] as String;
    }
    return '회원가입에 실패했습니다. 다시 시도해주세요.';
  }
}

final signUpProvider =
    NotifierProvider<SignUpNotifier, SignUpState>(SignUpNotifier.new);
