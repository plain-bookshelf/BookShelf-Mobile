import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/features/my_page/domain/entities/liked_book.dart';
import 'package:bookshelf_mobile/features/my_page/presentation/widgets/liked_book_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LikedBookCard extends StatelessWidget {
  final LikedBook book;
  const LikedBookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        AppRoutes.bookDetailOf(book.bookAffiliationId.toString()),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: book.bookImage.isNotEmpty
                ? Image.network(
                    book.bookImage,
                    width: double.infinity,
                    height: 140,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const LikedBookPlaceholder(),
                  )
                : const LikedBookPlaceholder(),
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
        ],
      ),
    );
  }
}
