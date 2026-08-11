import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/core/widgets/app_elevated_button.dart';
import 'package:bookshelf_mobile/core/widgets/error_dialog.dart';
import 'package:bookshelf_mobile/core/widgets/library_search_field.dart';
import 'package:bookshelf_mobile/core/widgets/step_app_bar.dart';
import 'package:bookshelf_mobile/features/affiliation/presentation/providers/affiliation_provider.dart';
import 'package:bookshelf_mobile/features/auth/presentation/providers/sign_up_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FindLibraryPage extends ConsumerStatefulWidget {
  final bool isAdmin;
  const FindLibraryPage({super.key, this.isAdmin = false});

  @override
  ConsumerState<FindLibraryPage> createState() => _FindLibraryPageState();
}

class _FindLibraryPageState extends ConsumerState<FindLibraryPage> {
  final _searchController = TextEditingController();
  String? _selectedLibrary;

  int get _totalSteps => widget.isAdmin ? 4 : 3;

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

  Future<void> _onNext() async {
    final notifier = ref.read(signUpProvider.notifier);
    notifier.setAffiliationName(_selectedLibrary!);

    if (widget.isAdmin) {
      // 관리자는 인증코드 확인 후 가입
      context.push(AppRoutes.registerAuthCode);
      return;
    }

    // 일반 유저: API 호출
    final success = await notifier.submit();
    if (!mounted) return;

    if (success) {
      context.push(AppRoutes.registerComplete);
    } else {
      final error = ref.read(signUpProvider).errorMessage;
      await showErrorDialog(
        context,
        title: '회원가입 실패',
        message: error ?? '회원가입에 실패했습니다.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final affiliationsAsync = ref.watch(affiliationsProvider);
    final allLibraries =
        affiliationsAsync.value?.map((a) => a.name).toList() ?? [];
    final results = _filteredFrom(allLibraries);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: StepAppBar(
        showStep: true,
        currentStep: 3,
        totalSteps: _totalSteps,
      ),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                '소속 도서관 입력',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              const Text(
                '회원가입하고 책마루에 가입하세요',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey600,
                ),
              ),
              const SizedBox(height: 32),
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
              Consumer(
                builder: (context, ref, _) {
                  final isLoading = ref.watch(
                    signUpProvider.select((s) => s.isLoading),
                  );
                  return AppElevatedButton(
                    onPressed: _selectedLibrary != null && !isLoading
                        ? () => _onNext()
                        : null,
                    label: isLoading
                        ? '처리 중...'
                        : (widget.isAdmin ? '다음' : '완료'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
