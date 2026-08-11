import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/features/book/presentation/providers/book_detail_provider.dart';
import 'package:bookshelf_mobile/features/book/presentation/widgets/cover_section.dart';
import 'package:bookshelf_mobile/features/book/presentation/widgets/description_section.dart';
import 'package:bookshelf_mobile/features/book/presentation/widgets/meta_section.dart';
import 'package:bookshelf_mobile/features/book/presentation/widgets/recommendation_section.dart';
import 'package:bookshelf_mobile/features/book/presentation/widgets/review_section.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ── Loaded Body ───────────────────────────────────────────────────────────────
class LoadedBody extends StatelessWidget {
  final BookDetailState state;
  final String bookId;
  final VoidCallback onToggleDescription;
  final ValueChanged<String> onToggleReviewLike;

  const LoadedBody({
    super.key,
    required this.state,
    required this.bookId,
    required this.onToggleDescription,
    required this.onToggleReviewLike,
  });

  @override
  Widget build(BuildContext context) {
    final book = state.book!;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 도서 표지
          CoverSection(coverUrl: book.coverUrl),
          // 도서 기본 정보
          MetaSection(book: book, detail: state.detail),
          const Divider(height: 1, color: AppColors.borderLight),
          // 줄거리
          DescriptionSection(
            description: book.description ?? '줄거리 정보가 없습니다.',
            isExpanded: state.isDescriptionExpanded,
            onToggle: onToggleDescription,
          ),
          const Divider(height: 1, color: AppColors.borderLight),
          // 리뷰
          ReviewSection(
            reviews: state.reviews,
            onLike: onToggleReviewLike,
            onViewAll: () => context.push(AppRoutes.bookReviewsOf(bookId)),
          ),
          const Divider(height: 1, color: AppColors.borderLight),
          // 추천 도서
          RecommendationSection(books: state.recommendations),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
