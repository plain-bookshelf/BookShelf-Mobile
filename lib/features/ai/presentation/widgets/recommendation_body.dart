import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/features/ai/presentation/providers/ai_provider.dart';
import 'package:bookshelf_mobile/features/ai/presentation/widgets/book_thumbnail.dart';
import 'package:flutter/material.dart';

// ── 추천 결과 뷰 ──────────────────────────────────────────────────────────────
class RecommendationBody extends StatelessWidget {
  final AiState state;
  final VoidCallback onReset;

  const RecommendationBody({
    super.key,
    required this.state,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.white,
      child: CustomScrollView(
        slivers: [
          // 헤더
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${state.userName}님을 위한 추천 책',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.hasBooks
                        ? '${state.userName}님을 위해 이런 책을 준비했어요'
                        : '읽고 싶은 책을 찾지 못했어요',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.grey600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 책 그리드 or 빈 상태
          if (state.hasBooks)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              sliver: SliverGrid.count(
                crossAxisCount: 3,
                childAspectRatio: 0.62,
                mainAxisSpacing: 16,
                crossAxisSpacing: 12,
                children: state.recommendedBooks
                    .map((book) => BookThumbnail(book: book))
                    .toList(),
              ),
            )
          else
            const SliverFillRemaining(
              child: Center(
                child: Text(
                  '읽고 싶은 책 중에는\n책을 찾지 못했어요',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: AppColors.grey500),
                ),
              ),
            ),

          // 다시 물어보기 버튼
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
              child: OutlinedButton(
                onPressed: onReset,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.successNormal,
                  side: const BorderSide(color: AppColors.successNormal),
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '다시 물어보기',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
