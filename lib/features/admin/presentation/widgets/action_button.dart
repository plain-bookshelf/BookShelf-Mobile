import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

// ── 액션 버튼 (대여 / 취소) ────────────────────────────────────────────────────
class ActionButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    required this.label,
    required this.filled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    const shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );
    const labelStyle = TextStyle(fontSize: 13, fontWeight: FontWeight.w600);

    if (filled) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.successNormal,
          foregroundColor: AppColors.white,
          shape: shape,
          elevation: 0,
          minimumSize: const Size(60, 36),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(label, style: labelStyle),
      );
    }

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.grey300),
        foregroundColor: AppColors.grey600,
        shape: shape,
        minimumSize: const Size(60, 36),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label, style: labelStyle),
    );
  }
}
