import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

// ── Failure ───────────────────────────────────────────────────────────────────
class FailureBody extends StatelessWidget {
  const FailureBody({super.key});

  @override
  Widget build(BuildContext context) => const Center(
    child: Text('도서 정보를 불러올 수 없습니다.', style: AppTextStyles.caption1),
  );
}
