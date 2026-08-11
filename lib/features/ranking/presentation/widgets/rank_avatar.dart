import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

// ── 아바타 + 순위 배지 ────────────────────────────────────────────────────────
class RankAvatar extends StatelessWidget {
  final double avatarRadius;
  final int rank;
  final Color badgeColor;
  final String? avatarUrl;
  final bool showCrown;

  const RankAvatar({
    super.key,
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
          backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
          child: avatarUrl == null
              ? Icon(
                  Icons.person,
                  size: avatarRadius * 0.8,
                  color: AppColors.grey500,
                )
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
