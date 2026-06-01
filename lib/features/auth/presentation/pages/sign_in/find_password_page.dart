import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/core/router/route_extras.dart';
import 'package:bookshelf_mobile/core/widgets/app_elevated_button.dart';
import 'package:bookshelf_mobile/core/widgets/app_text_field.dart';
import 'package:bookshelf_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:bookshelf_mobile/features/auth/presentation/providers/find_password_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ─────────────────────────────────────────
// Step 1: 이메일 입력
// ─────────────────────────────────────────
class FindPasswordPage extends ConsumerStatefulWidget {
  const FindPasswordPage({super.key});

  @override
  ConsumerState<FindPasswordPage> createState() => _FindPasswordPageState();
}

class _FindPasswordPageState extends ConsumerState<FindPasswordPage> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onSend() async {
    setState(() => _isLoading = true);
    try {
      await ref
          .read(authRepositoryProvider)
          .sendFindPasswordEmail(_emailController.text.trim());
      if (!mounted) return;
      context.push(
        AppRoutes.findPasswordVerify,
        extra: FindPasswordVerifyExtra(email: _emailController.text.trim()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('이메일 발송에 실패했습니다. 다시 시도해주세요.'),
          backgroundColor: AppColors.errorNormal,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(Icons.arrow_back_ios_new,
              size: 18, color: Color(0xFF7E7E7E)),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text('비밀번호 찾기',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              const Text('가입한 이메일 주소를 입력해주세요',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey600)),
              const SizedBox(height: 32),
              AppTextField(
                hintText: '이메일 입력',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => setState(() {}),
              ),
              const Spacer(),
              AppElevatedButton(
                onPressed: _emailController.text.isNotEmpty && !_isLoading
                    ? () => _onSend()
                    : null,
                label: _isLoading ? '발송 중...' : '인증번호 발송',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Step 2: 인증번호 확인 (Riverpod 타이머)
// ─────────────────────────────────────────
class FindPasswordVerifyPage extends ConsumerStatefulWidget {
  final String email;

  const FindPasswordVerifyPage({super.key, required this.email});

  @override
  ConsumerState<FindPasswordVerifyPage> createState() =>
      _FindPasswordVerifyPageState();
}

class _FindPasswordVerifyPageState
    extends ConsumerState<FindPasswordVerifyPage> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _onNext(String code) async {
    try {
      final registerToken = await ref
          .read(authRepositoryProvider)
          .findPassword(email: widget.email, verificationCode: code);
      if (!mounted) return;
      context.push(
        AppRoutes.changePassword,
        extra: ChangePasswordExtra(
          registerToken: registerToken,
          email: widget.email,
        ),
      );
    } on DioException catch (e) {
      if (!mounted) return;
      final data = e.response?.data;
      final message = data is Map ? data['message'] as String? : null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message ?? '인증코드가 올바르지 않습니다.'),
          backgroundColor: AppColors.errorNormal,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('인증에 실패했습니다. 다시 시도해주세요.'),
          backgroundColor: AppColors.errorNormal,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(findPasswordVerifyProvider);
    final notifier = ref.read(findPasswordVerifyProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(Icons.arrow_back_ios_new,
              size: 18, color: Color(0xFF7E7E7E)),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text('인증번호 확인',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Text(
                widget.email,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.successNormal),
              ),
              const SizedBox(height: 32),
              AppTextField(
                hintText: '인증번호 입력',
                controller: _codeController,
                onChanged: (v) {
                  notifier.updateCode(v);
                  setState(() {});
                },
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    timerState.timerText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.errorNormal,
                    ),
                  ),
                ),
                suffixIconConstraints: const BoxConstraints(minHeight: 0),
              ),
              const Spacer(),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('인증번호가 오지 않는다면 ',
                        style: TextStyle(
                            fontSize: 14, color: AppColors.grey600)),
                    GestureDetector(
                      onTap: () async {
                        _codeController.clear();
                        notifier.resend();
                        try {
                          await ref
                              .read(authRepositoryProvider)
                              .sendFindPasswordEmail(widget.email);
                        } catch (_) {}
                      },
                      child: const Text('재전송',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.successNormal)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppElevatedButton(
                onPressed: timerState.canSubmit
                    ? () => _onNext(timerState.code)
                    : null,
                label: '다음',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
