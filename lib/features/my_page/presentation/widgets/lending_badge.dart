import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/features/my_page/domain/entities/lending_info.dart';
import 'package:bookshelf_mobile/features/my_page/presentation/widgets/lending_tab.dart';
import 'package:flutter/material.dart';

// ── 배지 ──────────────────────────────────────────────────────────────────────
class LendingBadge extends StatelessWidget {
  final LendingBook book;
  final LendingTab tab;

  // 경고(임박) 색상 — AppColors에 warning 없어서 인라인 정의
  static const _warnBg = Color(0xFFFFF3E0);
  static const _warnFg = Color(0xFFD97706);

  const LendingBadge({super.key, required this.book, required this.tab});

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    final String label;

    switch (tab) {
      case LendingTab.rental:
        final d = book.leftRentalDate ?? 0;
        if (d <= 0) {
          bg = _warnBg;
          fg = _warnFg;
          label = '오늘 반납';
        } else if (d <= 3) {
          bg = _warnBg;
          fg = _warnFg;
          label = 'D-$d';
        } else {
          bg = AppColors.successLight;
          fg = AppColors.successDark;
          label = 'D-$d';
        }
      case LendingTab.reservation:
        bg = AppColors.successLight;
        fg = AppColors.successDark;
        label = '${book.rank ?? '-'}번째 대기';
      case LendingTab.overdue:
        bg = AppColors.errorLight;
        fg = AppColors.errorNormal;
        label = '연체 ${book.overdueDate ?? 0}일';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }
}
