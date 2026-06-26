import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/core/widgets/app_bottom_nav_bar.dart';
import 'package:bookshelf_mobile/features/search/domain/entities/search_book.dart';
import 'package:bookshelf_mobile/features/search/presentation/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSubmitted(String value) {
    if (value.trim().isEmpty) return;
    _focusNode.unfocus();
    ref.read(searchProvider.notifier).search(value);
  }

  void _onClear() {
    _textController.clear();
    _focusNode.requestFocus();
    ref.read(searchProvider.notifier).clearQuery();
  }

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
          : _ResultBody(searchState: searchState),
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

// ── Result Body ───────────────────────────────────────────────────────────────
class _ResultBody extends ConsumerWidget {
  final SearchState searchState;

  const _ResultBody({required this.searchState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (searchState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.successNormal),
      );
    }

    if (searchState.status == SearchStatus.failure) {
      return _ErrorState(
        onRetry: () =>
            ref.read(searchProvider.notifier).search(searchState.query),
      );
    }

    return _BookResultTab(
      books: searchState.bookResults,
      isLastPage: searchState.isLastPage,
      isLoadingMore: searchState.isLoadingMore,
      onLoadMore: () => ref.read(searchProvider.notifier).loadMore(),
    );
  }
}

// ── 도서 탭: 2열 그리드 + 무한 스크롤 ────────────────────────────────────────
class _BookResultTab extends StatefulWidget {
  final List<SearchBook> books;
  final bool isLastPage;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;

  const _BookResultTab({
    required this.books,
    required this.isLastPage,
    required this.isLoadingMore,
    required this.onLoadMore,
  });

  @override
  State<_BookResultTab> createState() => _BookResultTabState();
}

class _BookResultTabState extends State<_BookResultTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.books.isEmpty) {
      return const _EmptyState(message: '검색된 도서가 없습니다.');
    }

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 12,
        childAspectRatio: 110 / 190,
      ),
      itemCount: widget.books.length + (widget.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == widget.books.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(color: AppColors.successNormal),
            ),
          );
        }
        return _BookCard(book: widget.books[index]);
      },
    );
  }
}

class _BookCard extends StatelessWidget {
  final SearchBook book;

  const _BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.bookDetailOf(book.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: book.imageUrl.isNotEmpty
                  ? Image.network(
                      book.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const _CoverPlaceholder(),
                    )
                  : const _CoverPlaceholder(),
            ),
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
    return Container(
      width: double.infinity,
      color: AppColors.grey200,
      child: const Center(
        child: Icon(Icons.book_outlined, size: 36, color: AppColors.grey400),
      ),
    );
  }
}

// ── 에러 상태 ─────────────────────────────────────────────────────────────────
class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 56, color: AppColors.grey300),
          const SizedBox(height: 16),
          const Text(
            '검색에 실패했습니다.',
            style: AppTextStyles.body2SemiBold,
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: onRetry,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.successNormal,
              side: const BorderSide(color: AppColors.successNormal),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }
}

// ── 빈 상태 ───────────────────────────────────────────────────────────────────
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
