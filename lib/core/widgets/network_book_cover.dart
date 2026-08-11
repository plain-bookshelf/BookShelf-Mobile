import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// 책 표지 이미지 (네트워크 로드 실패 시 회색 플레이스홀더로 대체)
class NetworkBookCover extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool showPlaceholderIcon;

  const NetworkBookCover({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius = 6,
    this.showPlaceholderIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: (imageUrl?.isNotEmpty ?? false)
          ? Image.network(
              imageUrl!,
              width: width,
              height: height,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _placeholder(),
            )
          : _placeholder(),
    );
  }

  Widget _placeholder() => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: AppColors.grey300,
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    child: showPlaceholderIcon
        ? const Icon(Icons.book, color: AppColors.grey600, size: 36)
        : null,
  );
}
