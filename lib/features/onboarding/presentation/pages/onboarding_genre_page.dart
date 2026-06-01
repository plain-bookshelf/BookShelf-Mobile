import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/core/widgets/app_elevated_button.dart';
import 'package:bookshelf_mobile/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnboardingGenrePage extends ConsumerWidget {
  const OnboardingGenrePage({super.key});

  static const _genres = [
    '로맨스', '판타지', '추리', '공포/스릴러',
    '역사', '자기개발', '소설', '시/에세이',
    '인문', '과학', '경제/경영', '만화',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              const Text('어떤 장르의 책을\n좋아하나요?',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      height: 1.4)),
              const SizedBox(height: 12),
              const Text('좋아하는 장르를 선택해주세요 (복수 선택 가능)',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey600)),
              const SizedBox(height: 32),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _genres.map((genre) {
                  final isSelected = state.selectedGenres.contains(genre);
                  return GestureDetector(
                    onTap: () => notifier.toggleGenre(genre),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.successNormal
                            : AppColors.grey200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        genre,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? AppColors.white
                              : AppColors.textDark,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const Spacer(),
              AppElevatedButton(
                onPressed: state.canProceedGenre
                    ? () => context.push(AppRoutes.onboardingTime)
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
