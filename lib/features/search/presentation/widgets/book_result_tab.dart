import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/features/search/domain/entities/search_book.dart';
import 'package:bookshelf_mobile/features/search/presentation/widgets/book_card.dart';
import 'package:bookshelf_mobile/features/search/presentation/widgets/empty_state.dart';
import 'package:flutter/material.dart';

// ── 도서 탭: 2열 그리드 + 무한 스크롤 ────────────────────────────────────────
class BookResultTab extends StatefulWidget {
  final List<SearchBook> books;
  final bool isLastPage;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;

  const BookResultTab({
    super.key,
    required this.books,
    required this.isLastPage,
    required this.isLoadingMore,
    required this.onLoadMore,
  });

  @override
  State<BookResultTab> createState() => _BookResultTabState();
}

class _BookResultTabState extends State<BookResultTab> {
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
      return const EmptyState(message: '검색된 도서가 없습니다.');
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
        return BookCard(book: widget.books[index]);
      },
    );
  }
}
