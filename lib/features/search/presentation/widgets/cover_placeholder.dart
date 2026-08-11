import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CoverPlaceholder extends StatelessWidget {
  const CoverPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.grey200,
      child: const Center(
        child: Icon(Icons.book_outlined, size: 36, color: AppColors.grey400),
      ),
    );
  }
}
