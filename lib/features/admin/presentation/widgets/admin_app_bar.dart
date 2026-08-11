import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ── AppBar ────────────────────────────────────────────────────────────────────
class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AdminAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const Icon(
            Icons.menu_book_rounded,
            color: AppColors.successNormal,
            size: 28,
          ),
          const SizedBox(width: 8),
          Text('책마루', style: AppTextStyles.appTitle),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search, color: AppColors.textDark, size: 22),
        ),
        IconButton(
          onPressed: () => context.push(AppRoutes.notifications),
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.textDark,
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
