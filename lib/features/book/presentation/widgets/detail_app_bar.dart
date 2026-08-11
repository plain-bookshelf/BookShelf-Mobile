import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

// ── AppBar ────────────────────────────────────────────────────────────────────
class DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isWishlisted;
  final VoidCallback onBack;
  final VoidCallback onToggleWishlist;

  const DetailAppBar({
    super.key,
    required this.title,
    required this.isWishlisted,
    required this.onBack,
    required this.onToggleWishlist,
  });

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
      title: Text(
        title,
        style: AppTextStyles.body2SemiBold,
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        IconButton(
          onPressed: onToggleWishlist,
          icon: Icon(
            isWishlisted ? Icons.favorite : Icons.favorite_border,
            color: isWishlisted ? AppColors.errorNormal : AppColors.grey600,
            size: 22,
          ),
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppColors.borderLight),
      ),
    );
  }
}
