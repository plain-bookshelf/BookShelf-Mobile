import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// 회원가입 역할 선택 카드 (학생 / 관리자)
class RoleCard extends StatelessWidget {
  final String rolePicture;
  final String role;
  final bool selected;
  final VoidCallback? onTap;

  const RoleCard({
    super.key,
    required this.rolePicture,
    required this.role,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: selected ? AppColors.successLight : AppColors.grey200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.successNormal : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(rolePicture, width: 72, height: 72),
            const SizedBox(height: 12),
            Text(
              role,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.successDark : AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
