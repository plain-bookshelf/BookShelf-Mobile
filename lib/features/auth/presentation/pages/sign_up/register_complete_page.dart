import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/core/widgets/app_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterCompletePage extends StatelessWidget {
  const RegisterCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              const Text(
                '회원가입이\n완료되었어요!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              const Text(
                '이제 책마루에서 원하는 책을\n자유롭게 대여해보세요.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF777777),
                  height: 1.6,
                ),
              ),
              const Spacer(),
              AppElevatedButton(
                onPressed: () => context.go(AppRoutes.login),
                label: '로그인하러 가기',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
