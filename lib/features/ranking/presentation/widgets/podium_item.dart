import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:bookshelf_mobile/features/ranking/domain/entities/ranking_user.dart';
import 'package:bookshelf_mobile/features/ranking/presentation/widgets/book_count_badge.dart';
import 'package:bookshelf_mobile/features/ranking/presentation/widgets/rank_avatar.dart';
import 'package:flutter/material.dart';

// ── 포디움 아이템 ─────────────────────────────────────────────────────────────
class PodiumItem extends StatelessWidget {
  final RankingUser? user;
  final int rank;
  final double avatarRadius;
  final double topPadding;
  final Color badgeColor;
  final bool showCrown;

  const PodiumItem({
    super.key,
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
          RankAvatar(
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
            style: AppTextStyles.caption1.copyWith(
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          // 권수 배지
          BookCountBadge(count: user!.bookCount),
        ],
      ),
    );
  }
}
