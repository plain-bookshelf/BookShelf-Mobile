import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/core/widgets/app_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingCompletePage extends StatelessWidget {
  const OnboardingCompletePage({super.key});

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
              const Text('이제 시작해볼까요?',
                  style: TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              const Text(
                '취향에 맞는 책이 준비됐어요.\n지금 바로 책마루를 시작해보세요!',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF777777),
                    height: 1.6),
              ),
              const Spacer(),
              AppElevatedButton(
                onPressed: () => context.go(AppRoutes.home),
                label: '시작하기',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
