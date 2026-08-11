import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class LikedBooksErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  const LikedBooksErrorView({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.grey400),
          const SizedBox(height: 12),
          const Text(
            '목록을 불러오지 못했어요',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '잠시 후 다시 시도해주세요.',
            style: TextStyle(fontSize: 13, color: AppColors.grey500),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: onRetry,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.successNormal,
              side: const BorderSide(color: AppColors.successNormal),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }
}
