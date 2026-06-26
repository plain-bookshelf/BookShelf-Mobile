import 'package:bookshelf_mobile/features/search/domain/entities/search_book.dart';

class SearchResult {
  final List<SearchBook> books;
  final bool isLastPage;

  const SearchResult({
    this.books = const [],
    this.isLastPage = true,
  });

  bool get hasBooks => books.isNotEmpty;

  static const empty = SearchResult();
}
