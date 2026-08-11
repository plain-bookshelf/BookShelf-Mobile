import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/features/book/domain/entities/review.dart';
import 'package:bookshelf_mobile/features/book/presentation/widgets/review_item.dart';
import 'package:flutter/material.dart';

// ── 리뷰 목록 ─────────────────────────────────────────────────────────────────
class ReviewList extends StatelessWidget {
  final List<Review> reviews;
  final ScrollController scrollController;
  final ValueChanged<String> onLike;

  const ReviewList({
    super.key,
    required this.reviews,
    required this.scrollController,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: reviews.length,
      separatorBuilder: (_, _) =>
          const Divider(height: 1, color: AppColors.borderLight),
      itemBuilder: (context, index) {
        final review = reviews[index];
        return ReviewItem(review: review, onLike: () => onLike(review.id));
      },
    );
  }
}
