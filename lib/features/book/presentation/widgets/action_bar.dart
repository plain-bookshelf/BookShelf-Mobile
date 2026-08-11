import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:bookshelf_mobile/features/book/domain/entities/book.dart';
import 'package:flutter/material.dart';

// ── 하단 액션 바 ───────────────────────────────────────────────────────────────
class ActionBar extends StatelessWidget {
  final Book book;
  final Future<void> Function() onRental;
  final Future<void> Function() onReservation;

  const ActionBar({
    super.key,
    required this.book,
    required this.onRental,
    required this.onReservation,
  });

  @override
  Widget build(BuildContext context) {
    final isAvailable = book.status == BookStatus.available;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.borderLight)),
        ),
        child: SizedBox(
          height: 52,
          width: double.infinity,
          child: isAvailable
              ? ElevatedButton(
                  onPressed: onRental,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.successNormal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('대여 요청', style: AppTextStyles.button),
                )
              : OutlinedButton(
                  onPressed: onReservation,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.successNormal),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    '예약',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.successNormal,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
