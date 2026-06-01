import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/core/widgets/app_elevated_button.dart';
import 'package:bookshelf_mobile/core/widgets/app_text_field.dart';
import 'package:bookshelf_mobile/core/widgets/step_app_bar.dart';
import 'package:bookshelf_mobile/features/auth/presentation/providers/sign_up_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PasswordPage extends ConsumerStatefulWidget {
  final bool isAdmin;
  const PasswordPage({super.key, this.isAdmin = false});

  @override
  ConsumerState<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends ConsumerState<PasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  int get _totalSteps => widget.isAdmin ? 4 : 3;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  bool get _isPasswordValid {
    final pw = _passwordController.text;
    if (pw.length < 10 || pw.length > 20) return false;
    return RegExp(r'[a-zA-Z]').hasMatch(pw) &&
        RegExp(r'[!@#$%^&*(),.?":{}|<>_\-\\\/\[\]~`+=;]').hasMatch(pw);
  }

  bool get _isMatch =>
      _confirmController.text.isNotEmpty &&
      _passwordController.text == _confirmController.text;

  bool get _canNext => _isPasswordValid && _isMatch;

  String? get _passwordError {
    if (_passwordController.text.isEmpty) return null;
    return _isPasswordValid ? null : '10~20자리, 영문, 특수문자를 포함해주세요';
  }

  String? get _confirmError {
    if (_confirmController.text.isEmpty) return null;
    return _isMatch ? null : '비밀번호가 일치하지 않습니다';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: StepAppBar(
        showStep: true,
        currentStep: 2,
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
              const Text('비밀번호 생성',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              const Text('회원가입하고 책마루에 가입하세요',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF777777))),
              const SizedBox(height: 32),
              AppTextField(
                hintText: '10자리 ~ 20자리, 영문, 특수문자 포함',
                controller: _passwordController,
                obscureText: true,
                errorText: _passwordError,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              AppTextField(
                hintText: '비밀번호 재입력',
                controller: _confirmController,
                obscureText: true,
                errorText: _confirmError,
                onChanged: (_) => setState(() {}),
              ),
              const Spacer(),
              AppElevatedButton(
                onPressed: _canNext
                    ? () {
                        // provider에 비밀번호 저장
                        ref
                            .read(signUpProvider.notifier)
                            .setPassword(_passwordController.text);
                        context.push(
                          AppRoutes.registerLibrary,
                          extra: widget.isAdmin,
                        );
                      }
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
