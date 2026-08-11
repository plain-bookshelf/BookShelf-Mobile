import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class BookImagePlaceholder extends StatelessWidget {
  const BookImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        color: AppColors.grey300,
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Icon(Icons.book, color: AppColors.grey600, size: 32),
    );
  }
}
