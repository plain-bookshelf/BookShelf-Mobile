import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────
// 메뉴 타일
// ─────────────────────────────────────────
class MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const MenuTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = AppColors.textDark,
  });

  bool get _isDestructive => color == AppColors.errorNormal;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color, size: 22),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
      trailing: _isDestructive
          ? null
          : const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.grey500,
            ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
    );
  }
}
