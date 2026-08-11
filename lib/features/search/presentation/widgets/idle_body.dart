import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:bookshelf_mobile/features/search/presentation/widgets/recent_search_item.dart';
import 'package:flutter/material.dart';

// ── Idle Body: 최근 검색어 ────────────────────────────────────────────────────
class IdleBody extends StatelessWidget {
  final List<String> recentSearches;
  final ValueChanged<String> onTap;
  final ValueChanged<String> onRemove;
  final VoidCallback onClearAll;

  const IdleBody({
    super.key,
    required this.recentSearches,
    required this.onTap,
    required this.onRemove,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('최근 검색어', style: AppTextStyles.body2SemiBold),
              if (recentSearches.isNotEmpty)
                GestureDetector(
                  onTap: onClearAll,
                  child: const Text(
                    '전체 삭제',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.grey500,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (recentSearches.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text('최근 검색어가 없습니다.', style: AppTextStyles.caption1),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: recentSearches.length,
              itemBuilder: (context, index) {
                final query = recentSearches[index];
                return RecentSearchItem(
                  query: query,
                  onTap: () => onTap(query),
                  onRemove: () => onRemove(query),
                );
              },
            ),
          ),
      ],
    );
  }
}
