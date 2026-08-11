import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// 소속 도서관 검색 입력창 (회원가입 · 소속 변경 화면 공용)
class LibrarySearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const LibrarySearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      style: const TextStyle(color: AppColors.textDark, fontSize: 16),
      decoration: InputDecoration(
        hintText: '소속 도서관 검색',
        hintStyle: const TextStyle(color: AppColors.grey500, fontSize: 14),
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.grey500,
          size: 20,
        ),
        filled: true,
        fillColor: AppColors.grey200,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.successNormal),
        ),
      ),
    );
  }
}

/// 소속 도서관 검색 결과 목록 (회원가입 · 소속 변경 화면 공용)
class LibrarySearchResultList extends StatelessWidget {
  final List<String> results;
  final String query;
  final String? selectedLibrary;
  final ValueChanged<String> onSelect;

  const LibrarySearchResultList({
    super.key,
    required this.results,
    required this.query,
    required this.selectedLibrary,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: results.length,
        separatorBuilder: (_, _) => const Divider(
          height: 1,
          color: AppColors.grey300,
          indent: 16,
          endIndent: 16,
        ),
        itemBuilder: (context, index) {
          final library = results[index];
          final isSelected = selectedLibrary == library;

          return InkWell(
            onTap: () => onSelect(library),
            borderRadius: BorderRadius.vertical(
              top: index == 0 ? const Radius.circular(8) : Radius.zero,
              bottom: index == results.length - 1
                  ? const Radius.circular(8)
                  : Radius.zero,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: _HighlightText(
                text: library,
                query: query,
                isSelected: isSelected,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HighlightText extends StatelessWidget {
  final String text;
  final String query;
  final bool isSelected;

  const _HighlightText({
    required this.text,
    required this.query,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = isSelected ? AppColors.successNormal : AppColors.textDark;

    if (query.isEmpty || !text.contains(query)) {
      return Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: baseColor,
        ),
      );
    }

    final index = text.indexOf(query);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: text.substring(0, index),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: baseColor,
            ),
          ),
          TextSpan(
            text: text.substring(index, index + query.length),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: baseColor,
            ),
          ),
          TextSpan(
            text: text.substring(index + query.length),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: baseColor,
            ),
          ),
        ],
      ),
    );
  }
}
