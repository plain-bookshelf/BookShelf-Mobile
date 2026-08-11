import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/features/my_page/domain/entities/lending_info.dart';
import 'package:bookshelf_mobile/features/my_page/presentation/widgets/cover_placeholder.dart';
import 'package:bookshelf_mobile/features/my_page/presentation/widgets/lending_badge.dart';
import 'package:bookshelf_mobile/features/my_page/presentation/widgets/lending_tab.dart';
import 'package:flutter/material.dart';

// ── 아이템 ────────────────────────────────────────────────────────────────────
class LendingItem extends StatelessWidget {
  final LendingBook book;
  final LendingTab tab;

  const LendingItem({super.key, required this.book, required this.tab});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 표지 썸네일
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: book.bookImage.isNotEmpty
              ? Image.network(
                  book.bookImage,
                  width: 56,
                  height: 76,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const CoverPlaceholder(),
                )
              : const CoverPlaceholder(),
        ),
        const SizedBox(width: 16),
        // 제목
        Expanded(
          child: Text(
            book.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ),
        const SizedBox(width: 12),
        // 우측 배지
        LendingBadge(book: book, tab: tab),
      ],
    );
  }
}
