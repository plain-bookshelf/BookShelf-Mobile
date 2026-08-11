import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/core/widgets/network_book_cover.dart';
import 'package:bookshelf_mobile/features/book/domain/entities/book.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ── 책 썸네일 ─────────────────────────────────────────────────────────────────
class BookThumbnail extends StatelessWidget {
  final Book book;

  const BookThumbnail({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.bookDetailOf(book.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: NetworkBookCover(
              imageUrl: book.coverUrl,
              width: double.infinity,
              showPlaceholderIcon: false,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            book.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),
          Text(
            book.author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: AppColors.grey500),
          ),
        ],
      ),
    );
  }
}
