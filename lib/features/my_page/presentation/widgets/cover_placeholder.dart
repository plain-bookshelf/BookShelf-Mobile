import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CoverPlaceholder extends StatelessWidget {
  const CoverPlaceholder({super.key});

  @override
  Widget build(BuildContext context) => Container(
    width: 56,
    height: 76,
    decoration: BoxDecoration(
      color: AppColors.grey300,
      borderRadius: BorderRadius.circular(4),
    ),
    child: const Icon(Icons.book, color: AppColors.grey600, size: 24),
  );
}
