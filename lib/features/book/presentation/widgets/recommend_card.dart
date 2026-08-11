import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/features/book/domain/entities/book.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecommendCard extends StatelessWidget {
  final Book book;

  const RecommendCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.bookDetailOf(book.id)),
      child: SizedBox(
        width: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 표지
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.grey200,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: book.coverUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          book.coverUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const Icon(
                            Icons.book_outlined,
                            color: AppColors.grey400,
                            size: 28,
                          ),
                        ),
                      )
                    : const Center(
                        child: Icon(
                          Icons.book_outlined,
                          color: AppColors.grey400,
                          size: 28,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              book.title,
              style: AppTextStyles.caption2,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
