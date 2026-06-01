import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 비밀번호 찾기 인증 화면 상태
class FindPasswordVerifyState {
  final int remainingSeconds;
  final String code;

  const FindPasswordVerifyState({
    required this.remainingSeconds,
    required this.code,
  });

  factory FindPasswordVerifyState.initial() =>
      const FindPasswordVerifyState(remainingSeconds: 300, code: '');

  FindPasswordVerifyState copyWith({int? remainingSeconds, String? code}) =>
      FindPasswordVerifyState(
        remainingSeconds: remainingSeconds ?? this.remainingSeconds,
        code: code ?? this.code,
      );

  bool get isExpired => remainingSeconds == 0;
  bool get canSubmit => code.isNotEmpty && !isExpired;

  String get timerText {
    final min = remainingSeconds ~/ 60;
    final sec = remainingSeconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }
}

/// 비밀번호 찾기 인증 Notifier
class FindPasswordVerifyNotifier extends Notifier<FindPasswordVerifyState> {
  Timer? _timer;

  @override
  FindPasswordVerifyState build() {
    ref.onDispose(() => _timer?.cancel());
    _startTimer();
    return FindPasswordVerifyState.initial();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (state.remainingSeconds == 0) {
        t.cancel();
      } else {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      }
    });
  }

  void updateCode(String code) => state = state.copyWith(code: code);

  void resend() {
    state = FindPasswordVerifyState.initial();
    _startTimer();
  }
}

final findPasswordVerifyProvider =
    NotifierProvider<FindPasswordVerifyNotifier, FindPasswordVerifyState>(
  FindPasswordVerifyNotifier.new,
);
