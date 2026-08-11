import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/core/router/route_extras.dart';
import 'package:bookshelf_mobile/core/widgets/app_elevated_button.dart';
import 'package:bookshelf_mobile/core/widgets/app_text_field.dart';
import 'package:bookshelf_mobile/core/widgets/step_app_bar.dart';
import 'package:bookshelf_mobile/features/auth/presentation/providers/sign_up_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EmailInputPage extends ConsumerStatefulWidget {
  final bool isAdmin;

  const EmailInputPage({super.key, this.isAdmin = false});

  @override
  ConsumerState<EmailInputPage> createState() => _EmailInputPageState();
}

class _EmailInputPageState extends ConsumerState<EmailInputPage> {
  final _controller = TextEditingController();

  int get _totalSteps => widget.isAdmin ? 4 : 3;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onNext() {
    final email = _controller.text.trim();
    final notifier = ref.read(signUpProvider.notifier);
    notifier.setIsAdmin(isAdmin: widget.isAdmin);
    notifier.setEmail(email);
    // username은 이메일과 동일하게 사용
    notifier.setUsername(email);

    context.push(
      AppRoutes.registerEmailVerify,
      extra: EmailVerifyExtra(email: email, isAdmin: widget.isAdmin),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              Text(
                widget.isAdmin ? '이메일 또는 아이디 생성' : '이메일 받기',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '회원가입하고 책마루에 가입하세요!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF777777),
                ),
              ),
              const SizedBox(height: 32),
              AppTextField(
                inputFormatters: [],
                hintText: widget.isAdmin ? '이메일 또는 아이디 입력' : '이메일 입력',
                controller: _controller,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => setState(() {}),
              ),
              const Spacer(),
              AppElevatedButton(
                onPressed: _controller.text.isNotEmpty ? _onNext : null,
                label: '다음',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
