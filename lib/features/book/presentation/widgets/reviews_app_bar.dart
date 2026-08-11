import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

// ── AppBar ────────────────────────────────────────────────────────────────────
class ReviewsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBack;

  const ReviewsAppBar({super.key, required this.onBack});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: GestureDetector(
        onTap: onBack,
        child: const Icon(
          Icons.arrow_back_ios_new,
          size: 18,
          color: AppColors.grey600,
        ),
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppColors.borderLight),
      ),
    );
  }
}
