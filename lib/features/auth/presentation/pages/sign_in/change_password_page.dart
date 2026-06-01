import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/network/auth_session_provider.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/core/widgets/app_elevated_button.dart';
import 'package:bookshelf_mobile/core/widgets/app_text_field.dart';
import 'package:bookshelf_mobile/features/auth/presentation/providers/change_password_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  final String registerToken;
  final String email;

  const ChangePasswordPage({
    super.key,
    required this.registerToken,
    required this.email,
  });

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  bool get _isNewPasswordValid {
    final pw = _newController.text;
    if (pw.length < 10 || pw.length > 20) return false;
    return RegExp(r'[a-zA-Z]').hasMatch(pw) &&
        RegExp(r'[!@#$%^&*(),.?":{}|<>_\-\\\/\[\]~`+=;]').hasMatch(pw);
  }

  bool get _isMatch =>
      _confirmController.text.isNotEmpty &&
      _newController.text == _confirmController.text;

  bool get _canSubmit => _isNewPasswordValid && _isMatch;

  String? get _newPasswordError {
    if (_newController.text.isEmpty) return null;
    return _isNewPasswordValid ? null : '10~20자리, 영문, 특수문자를 포함해주세요';
  }

  String? get _confirmError {
    if (_confirmController.text.isEmpty) return null;
    return _isMatch ? null : '비밀번호가 일치하지 않습니다';
  }

  Future<void> _onSubmit() async {
    final success = await ref.read(changePasswordProvider.notifier).resetPassword(
          registerToken: widget.registerToken,
          email: widget.email,
          newPassword: _newController.text,
        );

    if (!mounted) return;

    if (success) {
      await showDialog<void>(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          content: const Text('비밀번호가 재설정됐습니다.\n다시 로그인해주세요.'),
          actions: [
            TextButton(
              onPressed: () async {
                await ref.read(authSessionProvider.notifier).clear();
                if (!dialogCtx.mounted) return;
                dialogCtx.go(AppRoutes.login);
              },
              child: const Text('확인'),
            ),
          ],
        ),
      );
    } else {
      final error = ref.read(changePasswordProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? '비밀번호 재설정에 실패했습니다.'),
          backgroundColor: AppColors.errorNormal,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(changePasswordProvider.select((s) => s.isLoading));

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
              const Text('비밀번호 재설정',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              const Text('새 비밀번호를 입력해주세요',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey600)),
              const SizedBox(height: 32),
              AppTextField(
                hintText: '10자리 ~ 20자리, 영문, 특수문자 포함',
                controller: _newController,
                obscureText: true,
                errorText: _newPasswordError,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              AppTextField(
                hintText: '새 비밀번호 재입력',
                controller: _confirmController,
                obscureText: true,
                errorText: _confirmError,
                onChanged: (_) => setState(() {}),
              ),
              const Spacer(),
              AppElevatedButton(
                onPressed: _canSubmit && !isLoading ? () => _onSubmit() : null,
                label: isLoading ? '처리 중...' : '변경 완료',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
