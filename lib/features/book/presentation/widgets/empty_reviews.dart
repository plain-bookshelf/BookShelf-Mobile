import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

// ── 빈 상태 ───────────────────────────────────────────────────────────────────
class EmptyReviews extends StatelessWidget {
  const EmptyReviews({super.key});

  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('아직 리뷰가 없습니다.', style: AppTextStyles.caption1));
}
