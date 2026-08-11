import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:bookshelf_mobile/features/book/data/models/book_detail_model.dart';
import 'package:bookshelf_mobile/features/book/domain/entities/book.dart';
import 'package:bookshelf_mobile/features/book/presentation/widgets/genre_chip.dart';
import 'package:flutter/material.dart';

// ── 도서 기본 정보 ─────────────────────────────────────────────────────────────
class MetaSection extends StatelessWidget {
  final Book book;
  final BookDetailModel? detail;

  const MetaSection({super.key, required this.book, this.detail});

  @override
  Widget build(BuildContext context) {
    final genres = detail?.genres ?? [];
    final publicationDate = detail?.bookInfo.publicationDate ?? '';
    final affiliationName = detail?.affiliationName ?? '';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목
          Text(book.title, style: AppTextStyles.heading3),
          const SizedBox(height: 6),
          // 저자
          Text(book.author, style: AppTextStyles.caption1),
          const SizedBox(height: 4),
          // 출판사 • 출판일
          Text(
            [
              if (book.publisher.isNotEmpty) book.publisher,
              if (publicationDate.isNotEmpty) publicationDate,
            ].join(' • '),
            style: AppTextStyles.caption2,
          ),
          if (affiliationName.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(affiliationName, style: AppTextStyles.caption2),
          ],
          // 장르 chip
          if (genres.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: genres
                  .map((g) => GenreChip(label: g.genreName))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
