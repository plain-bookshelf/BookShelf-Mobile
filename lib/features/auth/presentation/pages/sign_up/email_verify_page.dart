import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/core/widgets/app_elevated_button.dart';
import 'package:bookshelf_mobile/core/widgets/app_text_field.dart';
import 'package:bookshelf_mobile/core/widgets/step_app_bar.dart';
import 'package:bookshelf_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:bookshelf_mobile/features/auth/presentation/providers/email_verify_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EmailVerifyPage extends ConsumerStatefulWidget {
  final String email;
  final bool isAdmin;

  const EmailVerifyPage({
    super.key,
    required this.email,
    this.isAdmin = false,
  });

  @override
  ConsumerState<EmailVerifyPage> createState() => _EmailVerifyPageState();
}

class _EmailVerifyPageState extends ConsumerState<EmailVerifyPage> {
  final _controller = TextEditingController();

  int get _totalSteps => widget.isAdmin ? 4 : 3;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _sendEmail());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendEmail() async {
    try {
      await ref
          .read(authRepositoryProvider)
          .sendVerificationEmail(widget.email);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('인증 이메일 발송에 실패했습니다. 재전송을 눌러주세요.')),
      );
    }
  }

  Future<void> _onNext(String code) async {
    try {
      await ref.read(authRepositoryProvider).verifyEmailCode(
            email: widget.email,
            code: code,
          );
      if (!mounted) return;
      context.push(AppRoutes.registerPassword, extra: widget.isAdmin);
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
    final timerState = ref.watch(emailVerifyProvider);
    final notifier = ref.read(emailVerifyProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: StepAppBar(
        showStep: true,
        currentStep: 1,
        totalSteps: _totalSteps,
      ),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text('인증코드 입력',
                  style: TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              const Text('회원가입하고 책마루에 가입하세요!',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey600)),
              const SizedBox(height: 32),
              AppTextField(
                hintText: '인증번호 입력',
                controller: _controller,
                keyboardType: TextInputType.number,
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
                      onTap: () {
                        _controller.clear();
                        notifier.resend();
                        _sendEmail();
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
