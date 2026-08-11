import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/core/widgets/network_book_cover.dart';
import 'package:bookshelf_mobile/features/home/domain/entities/main_book.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookListGridCard extends StatelessWidget {
  final MainBook book;
  const BookListGridCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.bookDetailOf(book.id.toString())),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworkBookCover(
            imageUrl: book.bookImage,
            width: double.infinity,
            height: 140,
          ),
          const SizedBox(height: 6),
          Text(
            book.title ?? '제목 없음',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),
          if (book.author != null)
            Text(
              book.author!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: AppColors.grey600),
            ),
        ],
      ),
    );
  }
}
