import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

// ── Loading ───────────────────────────────────────────────────────────────────
class LoadingBody extends StatelessWidget {
  const LoadingBody({super.key});

  @override
  Widget build(BuildContext context) => const Center(
    child: CircularProgressIndicator(color: AppColors.successNormal),
  );
}
