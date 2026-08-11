import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

// ── 줄거리 ────────────────────────────────────────────────────────────────────
const _descriptionMaxLines = 4;

class DescriptionSection extends StatelessWidget {
  final String description;
  final bool isExpanded;
  final VoidCallback onToggle;

  const DescriptionSection({
    super.key,
    required this.description,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('줄거리', style: AppTextStyles.body1SemiBold),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.grey700,
              height: 1.7,
            ),
            maxLines: isExpanded ? null : _descriptionMaxLines,
            overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onToggle,
            child: Text(
              isExpanded ? '접기' : '전체보기',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.grey500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
