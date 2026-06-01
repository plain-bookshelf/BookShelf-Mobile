import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/core/widgets/app_elevated_button.dart';
import 'package:bookshelf_mobile/core/widgets/step_app_bar.dart';
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

  static const _allLibraries = [
    '대덕소프트웨어마이스터고',
    '대덕소프트웨어마이스터고등학교',
    '대덕소프트웨어마이스터고 분관',
    '서울과학기술대학교 도서관',
    '부산대학교 중앙도서관',
    '연세대학교 학술정보원',
    '고려대학교 중앙도서관',
    '한국과학기술원 도서관',
  ];

  List<String> get _filteredLibraries {
    final query = _searchController.text.trim();
    if (query.isEmpty) return [];
    return _allLibraries.where((lib) => lib.contains(query)).toList();
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? '회원가입에 실패했습니다.'),
          backgroundColor: AppColors.errorNormal,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredLibraries;

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
              const Text('소속 도서관 입력',
                  style: TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              const Text('회원가입하고 책마루에 가입하세요',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey600)),
              const SizedBox(height: 32),
              _SearchField(controller: _searchController, onChanged: (_) => setState(() {})),
              if (results.isNotEmpty) ...[
                const SizedBox(height: 8),
                _SearchResultList(
                  results: results,
                  query: _searchController.text.trim(),
                  selectedLibrary: _selectedLibrary,
                  onSelect: _selectLibrary,
                ),
              ],
              const Spacer(),
              Consumer(
                builder: (context, ref, _) {
                  final isLoading =
                      ref.watch(signUpProvider.select((s) => s.isLoading));
                  return AppElevatedButton(
                    onPressed: _selectedLibrary != null && !isLoading
                        ? () => _onNext()
                        : null,
                    label: isLoading ? '처리 중...' : (widget.isAdmin ? '다음' : '완료'),
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

// ─────────────────────────────────────────
// 검색 필드
// ─────────────────────────────────────────
class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchField({required this.controller, required this.onChanged});

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
        prefixIcon: const Icon(Icons.search, color: AppColors.grey500, size: 20),
        filled: true,
        fillColor: AppColors.grey200,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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

// ─────────────────────────────────────────
// 검색 결과 목록
// ─────────────────────────────────────────
class _SearchResultList extends StatelessWidget {
  final List<String> results;
  final String query;
  final String? selectedLibrary;
  final ValueChanged<String> onSelect;

  const _SearchResultList({
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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

// ─────────────────────────────────────────
// 검색어 하이라이트 텍스트
// ─────────────────────────────────────────
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
      return Text(text,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w400, color: baseColor));
    }

    final index = text.indexOf(query);
    return Text.rich(TextSpan(children: [
      TextSpan(
          text: text.substring(0, index),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: baseColor)),
      TextSpan(
          text: text.substring(index, index + query.length),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: baseColor)),
      TextSpan(
          text: text.substring(index + query.length),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: baseColor)),
    ]));
  }
}
