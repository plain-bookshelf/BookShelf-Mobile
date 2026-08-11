import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:bookshelf_mobile/features/book/domain/entities/review.dart';
import 'package:bookshelf_mobile/features/book/presentation/widgets/review_preview_item.dart';
import 'package:flutter/material.dart';

// ── 리뷰 ──────────────────────────────────────────────────────────────────────
const _reviewPreviewCount = 4;

class ReviewSection extends StatelessWidget {
  final List<Review> reviews;
  final ValueChanged<String> onLike;
  final VoidCallback onViewAll;

  const ReviewSection({
    super.key,
    required this.reviews,
    required this.onLike,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final preview = reviews.take(_reviewPreviewCount).toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('리뷰', style: AppTextStyles.body1SemiBold),
          const SizedBox(height: 4),
          ...preview.map(
            (r) => ReviewPreviewItem(review: r, onLike: () => onLike(r.id)),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: onViewAll,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  '전체보기',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
