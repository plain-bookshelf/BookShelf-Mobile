import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/network/api_error.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/core/router/route_extras.dart';
import 'package:bookshelf_mobile/core/widgets/app_elevated_button.dart';
import 'package:bookshelf_mobile/core/widgets/app_text_field.dart';
import 'package:bookshelf_mobile/core/widgets/error_dialog.dart';
import 'package:bookshelf_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter/material.dart';
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
      setState(() => _isLoading = false);
      await showErrorDialog(
        context,
        title: '이메일 발송 실패',
        message: parseApiErrorMessage(
          e,
          fallback: '이메일 발송에 실패했습니다. 다시 시도해주세요.',
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
          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: Color(0xFF7E7E7E),
          ),
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
              const Text(
                '비밀번호 찾기',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              const Text(
                '가입한 이메일 주소를 입력해주세요',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey600,
                ),
              ),
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
