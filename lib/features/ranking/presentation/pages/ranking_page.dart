import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:bookshelf_mobile/core/widgets/app_bottom_nav_bar.dart';
import 'package:bookshelf_mobile/core/widgets/app_main_app_bar.dart';
import 'package:bookshelf_mobile/features/ranking/presentation/providers/ranking_provider.dart';
import 'package:bookshelf_mobile/features/ranking/presentation/widgets/ranking_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── RankingPage ───────────────────────────────────────────────────────────────
class RankingPage extends ConsumerWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(rankingProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const AppMainAppBar(),
      body: switch (state.status) {
        RankingStatus.loading => const Center(
          child: CircularProgressIndicator(color: AppColors.successNormal),
        ),
        RankingStatus.failure => const Center(
          child: Text('랭킹을 불러올 수 없습니다.', style: AppTextStyles.caption1),
        ),
        RankingStatus.loaded => RankingBody(state: state),
      },
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
    );
  }
}
