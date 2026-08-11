import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:bookshelf_mobile/features/book/domain/entities/review.dart';
import 'package:flutter/material.dart';

// ── 리뷰 아이템 ───────────────────────────────────────────────────────────────
class ReviewItem extends StatelessWidget {
  final Review review;
  final VoidCallback onLike;

  const ReviewItem({super.key, required this.review, required this.onLike});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 리뷰 내용 (이름 + 본문)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(review.reviewerName, style: AppTextStyles.body2SemiBold),
                const SizedBox(height: 4),
                Text(review.content, style: AppTextStyles.caption1),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // 좋아요 버튼
          GestureDetector(
            onTap: onLike,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                review.isLiked ? Icons.favorite : Icons.favorite_border,
                size: 20,
                color: review.isLiked
                    ? AppColors.successNormal
                    : AppColors.grey400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
