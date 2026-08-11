import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:bookshelf_mobile/features/book/domain/entities/book.dart';
import 'package:bookshelf_mobile/features/book/presentation/widgets/recommend_card.dart';
import 'package:flutter/material.dart';

// ── 추천 도서 ─────────────────────────────────────────────────────────────────
class RecommendationSection extends StatelessWidget {
  final List<Book> books;

  const RecommendationSection({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 20),
            child: Text('추천', style: AppTextStyles.body1SemiBold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 20),
              itemCount: books.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) =>
                  RecommendCard(book: books[index]),
            ),
          ),
        ],
      ),
    );
  }
}
