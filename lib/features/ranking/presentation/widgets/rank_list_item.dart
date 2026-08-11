import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:bookshelf_mobile/features/ranking/domain/entities/ranking_user.dart';
import 'package:flutter/material.dart';

// ── 4위 이하 리스트 아이템 ────────────────────────────────────────────────────
class RankListItem extends StatelessWidget {
  final RankingUser user;

  const RankListItem({super.key, required this.user});

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
            backgroundImage: user.avatarUrl != null
                ? NetworkImage(user.avatarUrl!)
                : null,
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
