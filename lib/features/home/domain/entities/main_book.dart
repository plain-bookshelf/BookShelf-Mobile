/// /main/book 응답의 개별 도서 엔티티
class MainBook {
  final int id;
  final String bookImage;
  final String? title;
  final String? author;
  final List<String>? genreList;

  const MainBook({
    required this.id,
    required this.bookImage,
    this.title,
    this.author,
    this.genreList,
  });
}

// ignore: constant_identifier_names
enum BookFindType { POPULAR, RECENT }
