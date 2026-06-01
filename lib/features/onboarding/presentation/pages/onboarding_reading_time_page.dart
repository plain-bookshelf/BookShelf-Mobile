import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:bookshelf_mobile/core/network/auth_session_provider.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/core/widgets/app_elevated_button.dart';
import 'package:bookshelf_mobile/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnboardingReadingTimePage extends ConsumerWidget {
  const OnboardingReadingTimePage({super.key});

  Future<void> _pickTime(BuildContext context, WidgetRef ref) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked == null) return;

    // API 형식: HH:mm:ss
    final formatted =
        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}:00';
    ref.read(onboardingProvider.notifier).selectTime(formatted);
  }

  Future<void> _onNext(BuildContext context, WidgetRef ref) async {
    final accessToken = ref.read(authSessionProvider).accessToken ?? '';
    final success =
        await ref.read(onboardingProvider.notifier).submitReadingTime(accessToken);

    if (!context.mounted) return;

    if (success) {
      context.push(AppRoutes.onboardingRecommend);
    } else {
      final error = ref.read(onboardingProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? '시간 등록에 실패했습니다.'),
          backgroundColor: AppColors.errorNormal,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              const Text('주로 언제 책을\n읽으시나요?', style: AppTextStyles.heading1),
              const SizedBox(height: 12),
              const Text('몇 가지만 알려주면 맞춤 책을 준비할게요',
                  style: AppTextStyles.body2),
              const SizedBox(height: 32),
              // 시간 피커 트리거 필드
              GestureDetector(
                onTap: () => _pickTime(context, ref),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(8),
                    border: state.selectedTime != null
                        ? Border.all(
                            color: AppColors.successNormal, width: 1.5)
                        : null,
                  ),
                  child: Text(
                    state.selectedTime ?? '시간대 선택',
                    style: AppTextStyles.body2.copyWith(
                      color: state.selectedTime != null
                          ? AppColors.textDark
                          : AppColors.grey400,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              AppElevatedButton(
                onPressed: state.canProceedTime && !state.isLoading
                    ? () => _onNext(context, ref)
                    : null,
                label: state.isLoading ? '처리 중...' : '다음',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
