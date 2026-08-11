import 'package:bookshelf_mobile/core/network/api_error.dart';
import 'package:bookshelf_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 온보딩 흐름 전체 상태
class OnboardingState {
  final Set<String> selectedGenres;
  final String? selectedTime;
  final bool isLoading;
  final String? errorMessage;

  const OnboardingState({
    this.selectedGenres = const {},
    this.selectedTime,
    this.isLoading = false,
    this.errorMessage,
  });

  OnboardingState copyWith({
    Set<String>? selectedGenres,
    String? selectedTime,
    bool? isLoading,
    String? errorMessage,
  }) =>
      OnboardingState(
        selectedGenres: selectedGenres ?? this.selectedGenres,
        selectedTime: selectedTime ?? this.selectedTime,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage,
      );

  bool get canProceedGenre => selectedGenres.isNotEmpty;
  bool get canProceedTime =>
      selectedTime != null && selectedTime!.trim().isNotEmpty;
}

/// 온보딩 Notifier
///
/// 장르 선택 → 독서 시간 선택 → 추천 화면까지 상태 공유
class OnboardingNotifier extends Notifier<OnboardingState> {
  bool _mounted = true;

  @override
  OnboardingState build() {
    ref.onDispose(() => _mounted = false);
    return const OnboardingState();
  }

  void toggleGenre(String genre) {
    final updated = Set<String>.from(state.selectedGenres);
    if (updated.contains(genre)) {
      updated.remove(genre);
    } else {
      updated.add(genre);
    }
    state = state.copyWith(selectedGenres: updated);
  }

  void selectTime(String time) => state = state.copyWith(selectedTime: time);

  /// POST /often-read-book-time
  ///
  /// 성공 → true, 실패 → false (state.errorMessage 에 오류 메시지 설정)
  Future<bool> submitReadingTime(String accessToken) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await ref.read(authRemoteDataSourceProvider).setReadingTime(
            accessToken: accessToken,
            time: state.selectedTime!,
          );
      if (!_mounted) return false;
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      if (!_mounted) return false;
      state = state.copyWith(
        isLoading: false,
        errorMessage: parseApiErrorMessage(
          e,
          fallback: '시간 등록에 실패했습니다. 다시 시도해주세요.',
        ),
      );
      return false;
    }
  }

  void reset() => state = const OnboardingState();
}

final onboardingProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(
  OnboardingNotifier.new,
);
