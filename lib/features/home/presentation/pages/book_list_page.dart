import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/network/api_error.dart';
import 'package:bookshelf_mobile/core/widgets/app_bottom_nav_bar.dart';
import 'package:bookshelf_mobile/core/widgets/app_main_app_bar.dart';
import 'package:bookshelf_mobile/core/widgets/home_ai_tab_bar.dart';
import 'package:bookshelf_mobile/features/home/domain/entities/main_book.dart';
import 'package:bookshelf_mobile/features/home/presentation/providers/home_provider.dart';
import 'package:bookshelf_mobile/features/home/presentation/widgets/book_list_grid_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookListPage extends ConsumerStatefulWidget {
  final BookFindType bookFindType;

  const BookListPage({super.key, required this.bookFindType});

  @override
  ConsumerState<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends ConsumerState<BookListPage> {
  late BookFindType _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.bookFindType;
  }

  @override
  Widget build(BuildContext context) {
    final asyncBooks = _selectedType == BookFindType.POPULAR
        ? ref.watch(popularBooksProvider)
        : ref.watch(recentBooksProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppMainAppBar(
        bottom: HomeAiTabBar(currentTab: HomeAiTab.home),
      ),
      body: Column(
        children: [
          // 상단 배너 이미지 (원본 비율 412:148 유지)
          Image.asset(
            'assets/images/top.png',
            width: double.infinity,
            height: MediaQuery.of(context).size.width * 148 / 412,
            fit: BoxFit.cover,
          ),

          // 인기순 / 최신순 전환 (< 아이콘, > 아이콘)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 이전 탭 (최신순 → 인기순)
                if (_selectedType == BookFindType.RECENT)
                  IconButton(
                    onPressed: () =>
                        setState(() => _selectedType = BookFindType.POPULAR),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.textDark,
                    ),
                  )
                else
                  const SizedBox(width: 48),
                // 현재 탭 제목
                Text(
                  _selectedType == BookFindType.POPULAR
                      ? '인기순 책 100권'
                      : '최신순 책 100권',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                // 다음 탭 (인기순 → 최신순)
                if (_selectedType == BookFindType.POPULAR)
                  IconButton(
                    onPressed: () =>
                        setState(() => _selectedType = BookFindType.RECENT),
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textDark,
                    ),
                  )
                else
                  const SizedBox(width: 48),
              ],
            ),
          ),

          // 책 목록
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
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 12,
                            childAspectRatio: 110 / 190,
                          ),
                      itemCount: books.length,
                      itemBuilder: (context, index) =>
                          BookListGridCard(book: books[index]),
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }
}
