import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:bookshelf_mobile/features/book/domain/entities/review.dart';
import 'package:flutter/material.dart';

// ── 리뷰 미리보기 아이템 (도서 상세 페이지 리뷰 섹션용) ─────────────────────────
class ReviewPreviewItem extends StatelessWidget {
  final Review review;
  final VoidCallback onLike;

  const ReviewPreviewItem({
    super.key,
    required this.review,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  review.reviewerName,
                  style: AppTextStyles.body2SemiBold,
                ),
              ),
              // 좋아요 수 + 하트
              GestureDetector(
                onTap: onLike,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (review.likeCount > 0) ...[
                      Text(
                        '${review.likeCount}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: review.isLiked
                              ? AppColors.successNormal
                              : AppColors.grey500,
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                    Icon(
                      review.isLiked ? Icons.favorite : Icons.favorite_border,
                      size: 18,
                      color: review.isLiked
                          ? AppColors.successNormal
                          : AppColors.grey400,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(review.content, style: AppTextStyles.caption1),
        ],
      ),
    );
  }
}
