import 'package:bookshelf_mobile/features/book/domain/entities/book.dart';

/// 검색 결과 도메인 엔티티
class SearchResult {
  final List<Book> books;
  final List<String> libraries;

  const SearchResult({
    this.books = const [],
    this.libraries = const [],
  });

  bool get hasBooks => books.isNotEmpty;
  bool get hasLibraries => libraries.isNotEmpty;

  static const empty = SearchResult();
}
