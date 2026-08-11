import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/features/my_page/domain/entities/lending_info.dart';
import 'package:bookshelf_mobile/features/my_page/presentation/widgets/lending_item.dart';
import 'package:bookshelf_mobile/features/my_page/presentation/widgets/lending_tab.dart';
import 'package:flutter/material.dart';

// ── 리스트 ────────────────────────────────────────────────────────────────────
class LendingList extends StatelessWidget {
  final List<LendingBook> books;
  final LendingTab tab;

  const LendingList({super.key, required this.books, required this.tab});

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return const Center(
        child: Text(
          '내역이 없습니다.',
          style: TextStyle(fontSize: 14, color: AppColors.grey500),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: books.length,
      separatorBuilder: (_, _) =>
          const Divider(height: 24, color: AppColors.borderLight),
      itemBuilder: (_, index) => LendingItem(book: books[index], tab: tab),
    );
  }
}
