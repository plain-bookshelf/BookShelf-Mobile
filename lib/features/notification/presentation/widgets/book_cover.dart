import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

// ── 도서 표지 이미지 ──────────────────────────────────────────────────────────
class BookCover extends StatelessWidget {
  final String coverUrl;

  const BookCover({super.key, required this.coverUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        coverUrl,
        width: 200,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const SizedBox(
            width: 200,
            height: 280,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.successNormal),
            ),
          );
        },
        errorBuilder: (_, _, _) => Container(
          width: 200,
          height: 280,
          decoration: BoxDecoration(
            color: AppColors.grey200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Icon(
              Icons.book_outlined,
              size: 48,
              color: AppColors.grey400,
            ),
          ),
        ),
      ),
    );
  }
}
