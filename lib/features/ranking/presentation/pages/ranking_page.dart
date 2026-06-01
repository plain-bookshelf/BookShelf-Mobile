import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:bookshelf_mobile/core/widgets/app_bottom_nav_bar.dart';
import 'package:bookshelf_mobile/core/widgets/app_main_app_bar.dart';
import 'package:bookshelf_mobile/features/ranking/domain/entities/ranking_user.dart';
import 'package:bookshelf_mobile/features/ranking/presentation/providers/ranking_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── 배지 색상 상수 ────────────────────────────────────────────────────────────
const _goldColor   = Color(0xFFFFB800);
const _silverColor = Color(0xFFB0B8C1);
const _bronzeColor = Color(0xFFCD7F32);

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
        RankingStatus.loaded => _RankingBody(state: state),
      },
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
    );
  }
}

// ── 랭킹 본문 ─────────────────────────────────────────────────────────────────
class _RankingBody extends StatelessWidget {
  final RankingState state;

  const _RankingBody({required this.state});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // 1~3위 포디움
        SliverToBoxAdapter(
          child: _Podium(topThree: state.topThree),
        ),
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
              _RankListItem(user: state.rest[index]),
        ),
      ],
    );
  }
}

// ── 포디움 (1~3위) ────────────────────────────────────────────────────────────
class _Podium extends StatelessWidget {
  final List<RankingUser> topThree;

  const _Podium({required this.topThree});

  // 순서: 2위(왼쪽) - 1위(가운데) - 3위(오른쪽)
  RankingUser? _userAt(int rank) =>
      topThree.where((u) => u.rank == rank).firstOrNull;

  @override
  Widget build(BuildContext context) {
    final first  = _userAt(1);
    final second = _userAt(2);
    final third  = _userAt(3);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2위
          Expanded(
            child: _PodiumItem(
              user: second,
              rank: 2,
              avatarRadius: 40,
              topPadding: 28,
              badgeColor: _silverColor,
            ),
          ),
          // 1위 (가장 높고 큼)
          Expanded(
            child: _PodiumItem(
              user: first,
              rank: 1,
              avatarRadius: 48,
              topPadding: 0,
              badgeColor: _goldColor,
              showCrown: true,
            ),
          ),
          // 3위
          Expanded(
            child: _PodiumItem(
              user: third,
              rank: 3,
              avatarRadius: 34,
              topPadding: 44,
              badgeColor: _bronzeColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ── 포디움 아이템 ─────────────────────────────────────────────────────────────
class _PodiumItem extends StatelessWidget {
  final RankingUser? user;
  final int rank;
  final double avatarRadius;
  final double topPadding;
  final Color badgeColor;
  final bool showCrown;

  const _PodiumItem({
    required this.user,
    required this.rank,
    required this.avatarRadius,
    required this.topPadding,
    required this.badgeColor,
    this.showCrown = false,
  });

  @override
  Widget build(BuildContext context) {
    if (user == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 아바타 + 순위 배지
          _RankAvatar(
            avatarRadius: avatarRadius,
            rank: rank,
            badgeColor: badgeColor,
            avatarUrl: user!.avatarUrl,
            showCrown: showCrown,
          ),
          const SizedBox(height: 8),
          // 이름
          Text(
            user!.userName,
            style: AppTextStyles.caption1
                .copyWith(color: AppColors.textDark, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          // 권수 배지
          _BookCountBadge(count: user!.bookCount),
        ],
      ),
    );
  }
}

// ── 아바타 + 순위 배지 ────────────────────────────────────────────────────────
class _RankAvatar extends StatelessWidget {
  final double avatarRadius;
  final int rank;
  final Color badgeColor;
  final String? avatarUrl;
  final bool showCrown;

  const _RankAvatar({
    required this.avatarRadius,
    required this.rank,
    required this.badgeColor,
    this.avatarUrl,
    this.showCrown = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // 아바타 원
        CircleAvatar(
          radius: avatarRadius,
          backgroundColor: AppColors.grey300,
          backgroundImage:
              avatarUrl != null ? NetworkImage(avatarUrl!) : null,
          child: avatarUrl == null
              ? Icon(Icons.person, size: avatarRadius * 0.8,
                  color: AppColors.grey500)
              : null,
        ),
        // 순위 배지 (우하단)
        Positioned(
          right: 0,
          bottom: -2,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 1.5),
            ),
            alignment: Alignment.center,
            child: Text(
              '$rank',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── 권수 배지 ─────────────────────────────────────────────────────────────────
class _BookCountBadge extends StatelessWidget {
  final int count;

  const _BookCountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.successLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$count권',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.successDark,
        ),
      ),
    );
  }
}

// ── 4위 이하 리스트 아이템 ────────────────────────────────────────────────────
class _RankListItem extends StatelessWidget {
  final RankingUser user;

  const _RankListItem({required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // 순위 번호
          SizedBox(
            width: 24,
            child: Text(
              '${user.rank}',
              style: AppTextStyles.body2SemiBold,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          // 아바타
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.grey300,
            backgroundImage:
                user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
            child: user.avatarUrl == null
                ? const Icon(Icons.person, size: 20, color: AppColors.grey500)
                : null,
          ),
          const SizedBox(width: 12),
          // 이름 + 소속
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.userName, style: AppTextStyles.body2SemiBold),
                if (user.institution != null)
                  Text(user.institution!, style: AppTextStyles.caption2),
              ],
            ),
          ),
          // 권수
          Text('${user.bookCount}권', style: AppTextStyles.body2SemiBold),
        ],
      ),
    );
  }
}
