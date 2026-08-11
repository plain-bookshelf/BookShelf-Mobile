import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/network/auth_session_provider.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/core/widgets/app_elevated_button.dart';
import 'package:bookshelf_mobile/core/widgets/app_text_field.dart';
import 'package:bookshelf_mobile/core/widgets/error_dialog.dart';
import 'package:bookshelf_mobile/core/widgets/social_login_button.dart';
import 'package:bookshelf_mobile/features/auth/presentation/providers/login_provider.dart';
import 'package:bookshelf_mobile/features/auth/presentation/widgets/social_divider.dart';
import 'package:bookshelf_mobile/features/auth/presentation/widgets/text_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _usernameController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty;

  Future<void> _onLogin() async {
    final user = await ref
        .read(loginProvider.notifier)
        .login(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        );

    if (!mounted) return;

    if (user != null) {
      // access_token + refresh_token + username(이메일) + affiliationName 저장
      await ref
          .read(authSessionProvider.notifier)
          .setTokens(
            accessToken: user.accessToken ?? '',
            refreshToken: user.refreshToken,
            username: user.id,
            affiliationName: user.affiliationName,
          );
      if (!mounted) return;
      context.go(AppRoutes.home);
    } else {
      final error = ref.read(loginProvider).errorMessage;
      await showErrorDialog(
        context,
        title: '로그인 실패',
        message: error ?? '로그인에 실패했습니다.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loginProvider.select((s) => s.isLoading));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.17),
              const Text(
                '안녕하세요 :)\n책 대여 서비스 책마루에요',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              const Text(
                '로그인하고 책마루를 시작해보세요',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF777777),
                ),
              ),
              const SizedBox(height: 41),
              AppTextField(
                hintText: '이메일 입력',
                controller: _usernameController,
                keyboardType: TextInputType.emailAddress,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              AppTextField(
                hintText: '비밀번호 입력',
                controller: _passwordController,
                obscureText: _obscurePassword,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.grey500,
                    size: 22,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 32),
              AppElevatedButton(
                onPressed: _canSubmit && !isLoading ? () => _onLogin() : null,
                label: isLoading ? '로그인 중...' : '로그인',
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextLink(
                    label: '회원가입',
                    onTap: () => context.push(AppRoutes.register),
                  ),
                  const SizedBox(width: 50),
                  TextLink(
                    label: '비밀번호 찾기',
                    onTap: () => context.push(AppRoutes.findPassword),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const SocialDivider(),
              const SizedBox(height: 20),
              SocialLoginButton(
                logoAsset: 'assets/images/logo/kakao_logo.png',
                label: '카카오로 로그인',
                backgroundColor: const Color(0xFFFEE500),
              ),
              const SizedBox(height: 12),
              SocialLoginButton(
                logoAsset: 'assets/images/logo/naver_logo.png',
                label: '네이버로 로그인',
                backgroundColor: const Color(0xFF03C75A),
                textColor: Colors.white,
              ),
              const SizedBox(height: 12),
              SocialLoginButton(
                logoAsset: 'assets/images/logo/google_logo.png',
                label: '구글로 로그인',
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
