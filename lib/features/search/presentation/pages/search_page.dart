import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/core/widgets/app_bottom_nav_bar.dart';
import 'package:bookshelf_mobile/features/book/domain/entities/book.dart';
import 'package:bookshelf_mobile/features/search/presentation/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ── 탭 상수 ──────────────────────────────────────────────────────────────────
const _tabs = ['도서', '도서관'];

// ── SearchPage ───────────────────────────────────────────────────────────────
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // 검색 실행
  void _onSubmitted(String value) {
    if (value.trim().isEmpty) return;
    _focusNode.unfocus();
    ref.read(searchProvider.notifier).search(value);
  }

  // 검색어 초기화
  void _onClear() {
    _textController.clear();
    _focusNode.requestFocus();
    ref.read(searchProvider.notifier).clearQuery();
  }

  // 최근 검색어 탭 → 필드에 채우고 바로 검색
  void _onRecentTap(String query) {
    _textController.text = query;
    _textController.selection = TextSelection.fromPosition(
      TextPosition(offset: query.length),
    );
    ref.read(searchProvider.notifier).search(query);
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _SearchAppBar(
        controller: _textController,
        focusNode: _focusNode,
        hasQuery: searchState.hasQuery,
        onSubmitted: _onSubmitted,
        onClear: _onClear,
      ),
      body: searchState.isIdle
          ? _IdleBody(
              recentSearches: searchState.recentSearches,
              onTap: _onRecentTap,
              onRemove: (q) =>
                  ref.read(searchProvider.notifier).removeRecentSearch(q),
              onClearAll: () =>
                  ref.read(searchProvider.notifier).clearRecentSearches(),
            )
          : _ResultBody(
              tabController: _tabController,
              searchState: searchState,
            ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
    );
  }
}

// ── 검색 AppBar ──────────────────────────────────────────────────────────────
class _SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasQuery;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  const _SearchAppBar({
    required this.controller,
    required this.focusNode,
    required this.hasQuery,
    required this.onSubmitted,
    required this.onClear,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      leading: GestureDetector(
        onTap: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(AppRoutes.home);
          }
        },
        child: const Icon(
          Icons.arrow_back_ios_new,
          size: 18,
          color: AppColors.grey600,
        ),
      ),
      title: TextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: true,
        textInputAction: TextInputAction.search,
        onSubmitted: onSubmitted,
        decoration: const InputDecoration(
          hintText: '도서명 또는 저자명 검색',
          hintStyle: AppTextStyles.caption1,
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        style: AppTextStyles.body2,
      ),
      actions: [
        if (hasQuery)
          IconButton(
            onPressed: onClear,
            icon: const Icon(Icons.close, size: 20, color: AppColors.grey600),
          ),
        const SizedBox(width: 4),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppColors.borderLight),
      ),
    );
  }
}

// ── Idle Body: 최근 검색어 ────────────────────────────────────────────────────
class _IdleBody extends StatelessWidget {
  final List<String> recentSearches;
  final ValueChanged<String> onTap;
  final ValueChanged<String> onRemove;
  final VoidCallback onClearAll;

  const _IdleBody({
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
        // 헤더
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
        // 목록
        if (recentSearches.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                '최근 검색어가 없습니다.',
                style: AppTextStyles.caption1,
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: recentSearches.length,
              itemBuilder: (context, index) {
                final query = recentSearches[index];
                return _RecentSearchItem(
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

class _RecentSearchItem extends StatelessWidget {
  final String query;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _RecentSearchItem({
    required this.query,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.history, size: 18, color: AppColors.grey400),
            const SizedBox(width: 12),
            Expanded(
              child: Text(query, style: AppTextStyles.body2),
            ),
            GestureDetector(
              onTap: onRemove,
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.close, size: 16, color: AppColors.grey400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Result Body: 도서/도서관 탭 ───────────────────────────────────────────────
class _ResultBody extends StatelessWidget {
  final TabController tabController;
  final SearchState searchState;

  const _ResultBody({
    required this.tabController,
    required this.searchState,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 탭 바
        Container(
          color: AppColors.white,
          child: TabBar(
            controller: tabController,
            labelColor: AppColors.successNormal,
            unselectedLabelColor: AppColors.grey500,
            indicatorColor: AppColors.successNormal,
            indicatorWeight: 2,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            tabs: _tabs.map((t) => Tab(text: t)).toList(),
          ),
        ),
        const Divider(height: 1, color: AppColors.borderLight),
        // 탭 뷰
        Expanded(
          child: searchState.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.successNormal,
                  ),
                )
              : TabBarView(
                  controller: tabController,
                  children: [
                    _BookResultTab(books: searchState.bookResults),
                    _LibraryResultTab(
                        libraries: searchState.libraryResults,
                        query: searchState.query),
                  ],
                ),
        ),
      ],
    );
  }
}

// ── 도서 탭: 2열 그리드 ──────────────────────────────────────────────────────
class _BookResultTab extends StatelessWidget {
  final List<Book> books;

  const _BookResultTab({required this.books});

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return const _EmptyState(message: '검색된 도서가 없습니다.');
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 12,
        childAspectRatio: 0.62,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) => _BookCard(book: books[index]),
    );
  }
}

class _BookCard extends StatelessWidget {
  final Book book;

  const _BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.bookDetailOf(book.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 표지
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.grey200,
                borderRadius: BorderRadius.circular(6),
              ),
              child: book.coverUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        book.coverUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            const _CoverPlaceholder(),
                      ),
                    )
                  : const _CoverPlaceholder(),
            ),
          ),
          const SizedBox(height: 8),
          // 상태 배지
          _StatusBadge(status: book.status),
          const SizedBox(height: 4),
          // 제목
          Text(
            book.title,
            style: AppTextStyles.body2SemiBold,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          // 저자
          Text(
            book.author,
            style: AppTextStyles.caption2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _CoverPlaceholder extends StatelessWidget {
  const _CoverPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(Icons.book_outlined, size: 36, color: AppColors.grey400),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final BookStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      BookStatus.available => _Badge(
          label: '대여가능',
          textColor: AppColors.successDark,
          bgColor: AppColors.successLight,
        ),
      BookStatus.rented => const _Badge(
          label: '대여중',
          textColor: AppColors.grey600,
          bgColor: AppColors.grey200,
        ),
      BookStatus.reserved => const _Badge(
          label: '예약중',
          textColor: AppColors.grey600,
          bgColor: AppColors.grey200,
        ),
    };
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color textColor;
  final Color bgColor;

  const _Badge({
    required this.label,
    required this.textColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

// ── 도서관 탭 ────────────────────────────────────────────────────────────────
class _LibraryResultTab extends StatelessWidget {
  final List<String> libraries;
  final String query;

  const _LibraryResultTab({
    required this.libraries,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    if (libraries.isEmpty) {
      return _EmptyState(message: '"$query"에 해당하는\n도서관이 없습니다.');
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: libraries.length,
      separatorBuilder: (_, _) =>
          const Divider(height: 1, color: AppColors.borderLight),
      itemBuilder: (context, index) => _LibraryItem(name: libraries[index]),
    );
  }
}

class _LibraryItem extends StatelessWidget {
  final String name;

  const _LibraryItem({required this.name});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.successLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.location_city_outlined,
          size: 20,
          color: AppColors.successDark,
        ),
      ),
      title: Text(name, style: AppTextStyles.body2),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: AppColors.grey400,
      ),
    );
  }
}

// ── 빈 상태 공용 위젯 ─────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 56,
            color: AppColors.grey300,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption1,
          ),
        ],
      ),
    );
  }
}
