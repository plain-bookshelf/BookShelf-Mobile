import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/features/book/presentation/widgets/cover_placeholder.dart';
import 'package:flutter/material.dart';

// ── 도서 표지 ─────────────────────────────────────────────────────────────────
const _coverHeight = 280.0;

class CoverSection extends StatelessWidget {
  final String? coverUrl;

  const CoverSection({super.key, this.coverUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: _coverHeight,
      color: AppColors.grey100,
      child: coverUrl != null
          ? Image.network(
              coverUrl!,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const CoverPlaceholder(),
            )
          : const CoverPlaceholder(),
    );
  }
}
