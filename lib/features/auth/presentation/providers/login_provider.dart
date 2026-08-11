import 'package:bookshelf_mobile/core/network/api_error.dart';
import 'package:bookshelf_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:bookshelf_mobile/features/auth/domain/entities/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginState {
  final bool isLoading;
  final String? errorMessage;
  final User? user;

  const LoginState({
    this.isLoading = false,
    this.errorMessage,
    this.user,
  });

  LoginState copyWith({bool? isLoading, String? errorMessage, User? user}) =>
      LoginState(
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage,
        user: user ?? this.user,
      );
}

class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  /// POST /login
  ///
  /// 성공 → User (accessToken 포함), 실패 → null (state.errorMessage 설정)
  Future<User?> login({
    required String username,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await ref.read(authRepositoryProvider).login(
            username: username,
            password: password,
          );
      state = state.copyWith(isLoading: false, user: user);
      return user;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: parseApiErrorMessage(
          e,
          fallback: '로그인에 실패했습니다. 다시 시도해주세요.',
        ),
      );
      return null;
    }
  }
}

final loginProvider =
    NotifierProvider<LoginNotifier, LoginState>(LoginNotifier.new);
