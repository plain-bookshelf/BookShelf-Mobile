import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 이메일 인증 화면 상태
class EmailVerifyState {
  final int remainingSeconds;
  final String code;

  const EmailVerifyState({required this.remainingSeconds, required this.code});

  factory EmailVerifyState.initial() =>
      const EmailVerifyState(remainingSeconds: 300, code: '');

  EmailVerifyState copyWith({int? remainingSeconds, String? code}) =>
      EmailVerifyState(
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

/// 이메일 인증 Notifier
///
/// - 페이지 진입 시 타이머 자동 시작
/// - [ref.onDispose]: 페이지 이탈 시 타이머 자동 취소
class EmailVerifyNotifier extends Notifier<EmailVerifyState> {
  Timer? _timer;

  @override
  EmailVerifyState build() {
    ref.onDispose(() => _timer?.cancel());
    _startTimer();
    return EmailVerifyState.initial();
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
    state = EmailVerifyState.initial();
    _startTimer();
  }
}

final emailVerifyProvider =
    NotifierProvider.autoDispose<EmailVerifyNotifier, EmailVerifyState>(
      EmailVerifyNotifier.new,
    );
