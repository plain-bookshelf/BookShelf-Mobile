import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/core/widgets/app_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingStartPage extends StatelessWidget {
  const OnboardingStartPage({super.key});

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
                '어떤 책을\n좋아하시나요?',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              const Text(
                '취향에 맞는 도서를 추천해드릴게요.\n몇 가지 질문에 답해주세요!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF777777),
                  height: 1.6,
                ),
              ),
              const Spacer(),
              AppElevatedButton(
                onPressed: () => context.push(AppRoutes.onboardingGenre),
                label: '시작하기',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
