import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/features/my_page/presentation/widgets/stat_item.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────
// 통계 Row
// ─────────────────────────────────────────
class StatsRow extends StatelessWidget {
  final int rentalCount;
  final int reservationCount;
  final int overdueCount;

  const StatsRow({
    super.key,
    required this.rentalCount,
    required this.reservationCount,
    required this.overdueCount,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          StatItem(label: '대여 중인 책', count: rentalCount),
          const VerticalDivider(width: 1, color: AppColors.borderLight),
          StatItem(label: '예약한 책', count: reservationCount),
          const VerticalDivider(width: 1, color: AppColors.borderLight),
          StatItem(label: '연체한 책', count: overdueCount),
        ],
      ),
    );
  }
}
