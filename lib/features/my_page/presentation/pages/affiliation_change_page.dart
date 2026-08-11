import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/network/auth_session_provider.dart';
import 'package:bookshelf_mobile/core/widgets/app_elevated_button.dart';
import 'package:bookshelf_mobile/core/widgets/error_dialog.dart';
import 'package:bookshelf_mobile/core/widgets/library_search_field.dart';
import 'package:bookshelf_mobile/features/affiliation/presentation/providers/affiliation_provider.dart';
import 'package:bookshelf_mobile/features/my_page/presentation/providers/my_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AffiliationChangePage extends ConsumerStatefulWidget {
  const AffiliationChangePage({super.key});

  @override
  ConsumerState<AffiliationChangePage> createState() =>
      _AffiliationChangePageState();
}

class _AffiliationChangePageState extends ConsumerState<AffiliationChangePage> {
  final _searchController = TextEditingController();
  String? _selectedLibrary;
  bool _isSubmitting = false;

  List<String> _filteredFrom(List<String> allLibraries) {
    final query = _searchController.text.trim();
    if (query.isEmpty) return [];
    return allLibraries.where((lib) => lib.contains(query)).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectLibrary(String library) {
    setState(() {
      _selectedLibrary = library;
      _searchController.text = library;
    });
    FocusScope.of(context).unfocus();
  }

  Future<void> _onSubmit() async {
    if (_selectedLibrary == null) return;
    setState(() => _isSubmitting = true);

    final success = await ref
        .read(myPageProvider.notifier)
        .updateAffiliation(_selectedLibrary!);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      context.pop();
    } else {
      final error = ref.read(myPageProvider).errorMessage;
      await showErrorDialog(
        context,
        title: '소속 변경 실패',
        message: error ?? '소속 변경에 실패했습니다.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final affiliationsAsync = ref.watch(affiliationsProvider);
    final allLibraries =
        affiliationsAsync.value?.map((a) => a.name).toList() ?? [];
    final results = _filteredFrom(allLibraries);
    final currentAffiliationName = ref
        .watch(authSessionProvider)
        .affiliationName;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          '소속 변경',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              if (currentAffiliationName != null &&
                  currentAffiliationName.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '현재 소속',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.grey600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentAffiliationName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
              const Text(
                '새 소속 도서관 검색',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              const Text(
                '변경할 소속 도서관을 검색하고 선택해주세요',
                style: TextStyle(fontSize: 14, color: AppColors.grey600),
              ),
              const SizedBox(height: 24),
              LibrarySearchField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
              ),
              if (affiliationsAsync.isLoading) ...[
                const SizedBox(height: 8),
                const Text(
                  '도서관 목록을 불러오는 중입니다...',
                  style: TextStyle(fontSize: 13, color: AppColors.grey500),
                ),
              ] else if (affiliationsAsync.hasError) ...[
                const SizedBox(height: 8),
                const Text(
                  '도서관 목록을 불러오지 못했습니다.',
                  style: TextStyle(fontSize: 13, color: AppColors.errorNormal),
                ),
              ] else if (results.isNotEmpty) ...[
                const SizedBox(height: 8),
                LibrarySearchResultList(
                  results: results,
                  query: _searchController.text.trim(),
                  selectedLibrary: _selectedLibrary,
                  onSelect: _selectLibrary,
                ),
              ],
              const Spacer(),
              AppElevatedButton(
                onPressed: _selectedLibrary != null && !_isSubmitting
                    ? _onSubmit
                    : null,
                label: _isSubmitting ? '처리 중...' : '변경하기',
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
