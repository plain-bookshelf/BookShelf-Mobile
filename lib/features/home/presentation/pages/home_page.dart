import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/network/api_error.dart';
import 'package:bookshelf_mobile/core/widgets/app_bottom_nav_bar.dart';
import 'package:bookshelf_mobile/core/widgets/app_main_app_bar.dart';
import 'package:bookshelf_mobile/features/home/domain/entities/main_book.dart';
import 'package:bookshelf_mobile/features/home/presentation/providers/home_provider.dart';
import 'package:bookshelf_mobile/features/home/presentation/widgets/home_book_grid_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // 인기순 / 최신순 전환 (기본: 인기순)
  BookFindType _selectedType = BookFindType.POPULAR;

  @override
  Widget build(BuildContext context) {
    final asyncBooks = _selectedType == BookFindType.POPULAR
        ? ref.watch(popularBooksProvider)
        : ref.watch(recentBooksProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppMainAppBar(),
      body: Column(
        children: [
          // 상단 배너 이미지 (원본 비율 412:148 유지)
          Image.asset(
            'assets/images/top.png',
            width: double.infinity,
            height: MediaQuery.of(context).size.width * 148 / 412,
            fit: BoxFit.cover,
          ),

          // 인기순 / 최신순 전환 (< 아이콘, > 아이콘) — 그 자리에서 전환
          // 양옆 고정폭 + 가운데 Expanded 로 제목을 항상 정중앙에 고정
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                // 이전 탭 (최신순 → 인기순)
                SizedBox(
                  width: 32,
                  child: _selectedType == BookFindType.RECENT
                      ? IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => setState(
                            () => _selectedType = BookFindType.POPULAR,
                          ),
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            size: 18,
                            color: AppColors.textDark,
                          ),
                        )
                      : null,
                ),
                // 현재 탭 제목 (정중앙)
                Expanded(
                  child: Center(
                    child: Text(
                      _selectedType == BookFindType.POPULAR
                          ? '인기순 책 100권'
                          : '최신순 책 100권',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ),
                // 다음 탭 (인기순 → 최신순)
                SizedBox(
                  width: 32,
                  child: _selectedType == BookFindType.POPULAR
                      ? IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => setState(
                            () => _selectedType = BookFindType.RECENT,
                          ),
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                            color: AppColors.textDark,
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),

          // 책 그리드 (3열)
          Expanded(
            child: asyncBooks.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text(
                  parseApiErrorMessage(e, fallback: '도서 목록을 불러오지 못했습니다.'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.errorNormal),
                ),
              ),
              data: (books) => books.isEmpty
                  ? const Center(child: Text('도서가 없습니다.'))
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 12,
                            childAspectRatio: 110 / 190,
                          ),
                      itemCount: books.length,
                      itemBuilder: (context, index) =>
                          HomeBookGridCard(book: books[index]),
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }
}
