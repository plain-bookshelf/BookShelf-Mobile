import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/features/ranking/presentation/providers/ranking_provider.dart';
import 'package:bookshelf_mobile/features/ranking/presentation/widgets/podium.dart';
import 'package:bookshelf_mobile/features/ranking/presentation/widgets/rank_list_item.dart';
import 'package:flutter/material.dart';

// ── 랭킹 본문 ─────────────────────────────────────────────────────────────────
class RankingBody extends StatelessWidget {
  final RankingState state;

  const RankingBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // 1~3위 포디움
        SliverToBoxAdapter(child: Podium(topThree: state.topThree)),
        // 구분선
        const SliverToBoxAdapter(
          child: Divider(height: 1, color: AppColors.borderLight),
        ),
        // 4위 이하 리스트
        SliverList.separated(
          itemCount: state.rest.length,
          separatorBuilder: (_, _) =>
              const Divider(height: 1, color: AppColors.borderLight),
          itemBuilder: (context, index) =>
              RankListItem(user: state.rest[index]),
        ),
      ],
    );
  }
}
