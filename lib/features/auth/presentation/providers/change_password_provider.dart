import 'package:bookshelf_mobile/core/network/api_error.dart';
import 'package:bookshelf_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangePasswordState {
  final bool isLoading;
  final String? errorMessage;

  const ChangePasswordState({
    this.isLoading = false,
    this.errorMessage,
  });

  ChangePasswordState copyWith({bool? isLoading, String? errorMessage}) =>
      ChangePasswordState(
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage,
      );
}

class ChangePasswordNotifier extends Notifier<ChangePasswordState> {
  @override
  ChangePasswordState build() => const ChangePasswordState();

  /// PATCH /password-reset (비밀번호 찾기 경로 → register_token 사용)
  Future<bool> resetPassword({
    required String registerToken,
    required String email,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await ref.read(authRepositoryProvider).resetPassword(
            registerToken: registerToken,
            email: email,
            newPassword: newPassword,
          );
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: parseApiErrorMessage(
          e,
          fallback: '비밀번호 재설정에 실패했습니다. 다시 시도해주세요.',
        ),
      );
      return false;
    }
  }
}

final changePasswordProvider =
    NotifierProvider<ChangePasswordNotifier, ChangePasswordState>(
  ChangePasswordNotifier.new,
);
