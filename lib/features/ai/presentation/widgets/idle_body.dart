import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

// ── 빈 화면 ───────────────────────────────────────────────────────────────────
class IdleBody extends StatelessWidget {
  const IdleBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: 30,
                color: AppColors.successNormal,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '마루AI와의 대화를 시작해보세요',
              style: TextStyle(fontSize: 15, color: AppColors.grey500),
            ),
          ],
        ),
      ),
    );
  }
}
