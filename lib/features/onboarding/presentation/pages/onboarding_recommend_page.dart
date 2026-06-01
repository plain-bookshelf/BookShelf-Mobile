import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/core/widgets/app_elevated_button.dart';
import 'package:bookshelf_mobile/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnboardingRecommendPage extends ConsumerWidget {
  const OnboardingRecommendPage({super.key});

  static const _dummyBooks = [
    '책 제목 1', '책 제목 2', '책 제목 3',
    '책 제목 4', '책 제목 5', '책 제목 6',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);

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
              const Text('책마루님을 위한\n추천 책이에요!',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      height: 1.4)),
              const SizedBox(height: 12),
              Text(
                '${state.selectedGenres.join(', ')} 장르를 골랐군요 :)',
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey600),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: GridView.builder(
                  itemCount: _dummyBooks.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.68,
                  ),
                  itemBuilder: (context, index) =>
                      _BookCard(title: _dummyBooks[index]),
                ),
              ),
              const SizedBox(height: 20),
              AppElevatedButton(
                onPressed: () => context.push(AppRoutes.onboardingComplete),
                label: '다음',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  final String title;
  const _BookCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.grey300,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(8)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }
}
