import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

// ── AI 아바타 ─────────────────────────────────────────────────────────────────
class AiAvatar extends StatelessWidget {
  const AiAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: AppColors.successNormal,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.auto_awesome, size: 16, color: AppColors.white),
    );
  }
}
