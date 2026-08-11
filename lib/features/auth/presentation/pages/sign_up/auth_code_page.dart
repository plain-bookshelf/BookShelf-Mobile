import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/core/widgets/app_elevated_button.dart';
import 'package:bookshelf_mobile/core/widgets/app_text_field.dart';
import 'package:bookshelf_mobile/core/widgets/error_dialog.dart';
import 'package:bookshelf_mobile/core/widgets/step_app_bar.dart';
import 'package:bookshelf_mobile/features/auth/presentation/providers/sign_up_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AuthCodePage extends ConsumerStatefulWidget {
  const AuthCodePage({super.key});

  @override
  ConsumerState<AuthCodePage> createState() => _AuthCodePageState();
}

class _AuthCodePageState extends ConsumerState<AuthCodePage> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final notifier = ref.read(signUpProvider.notifier);
    notifier.setVerificationCode(_codeController.text.trim());

    final success = await notifier.submit();
    if (!mounted) return;

    if (success) {
      context.push(AppRoutes.registerComplete);
    } else {
      final error = ref.read(signUpProvider).errorMessage;
      await showErrorDialog(
        context,
        title: '회원가입 실패',
        message: error ?? '회원가입에 실패했습니다.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(signUpProvider.select((s) => s.isLoading));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const StepAppBar(showStep: true, currentStep: 4, totalSteps: 4),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text('인증 코드',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              const Text('관리자 인증 코드를 입력해주세요',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF777777))),
              const SizedBox(height: 32),
              AppTextField(
                hintText: '코드 입력',
                controller: _codeController,
                onChanged: (_) => setState(() {}),
              ),
              const Spacer(),
              AppElevatedButton(
                onPressed: _codeController.text.isNotEmpty && !isLoading
                    ? () => _onSubmit()
                    : null,
                label: isLoading ? '처리 중...' : '완료',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
