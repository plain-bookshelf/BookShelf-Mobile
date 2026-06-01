/// GET /book/{bookAffiliationId} 응답 모델
class BookDetailModel {
  final String affiliationName;
  final BookInfoModel bookInfo;
  final bool isEnableRental;
  final List<BookGenreModel> genres;
  final bool isLiked;

  const BookDetailModel({
    required this.affiliationName,
    required this.bookInfo,
    required this.isEnableRental,
    required this.genres,
    required this.isLiked,
  });

  factory BookDetailModel.fromJson(Map<String, dynamic> json) => BookDetailModel(
        affiliationName: json['affiliation_name'] as String? ?? '',
        bookInfo: BookInfoModel.fromJson(
            json['book_info'] as Map<String, dynamic>),
        isEnableRental: json['is_enable_rental'] as bool? ?? false,
        genres: (json['genres'] as List<dynamic>? ?? [])
            .map((e) => BookGenreModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        isLiked: json['is_liked'] as bool? ?? false,
      );
}

class BookInfoModel {
  final String title;
  final String author;
  final String publicationDate;
  final String introduction;
  final String bookImage;
  final String publisher;

  const BookInfoModel({
    required this.title,
    required this.author,
    required this.publicationDate,
    required this.introduction,
    required this.bookImage,
    required this.publisher,
  });

  factory BookInfoModel.fromJson(Map<String, dynamic> json) => BookInfoModel(
        title: json['title'] as String? ?? '',
        author: json['author'] as String? ?? '',
        publicationDate: json['publication_date'] as String? ?? '',
        introduction: json['introduction'] as String? ?? '',
        bookImage: json['book_image'] as String? ?? '',
        publisher: json['publisher'] as String? ?? '',
      );
}

class BookGenreModel {
  final int bookId;
  final int genreId;
  final String genreName;

  const BookGenreModel({
    required this.bookId,
    required this.genreId,
    required this.genreName,
  });

  factory BookGenreModel.fromJson(Map<String, dynamic> json) {
    final genre = json['genre'] as Map<String, dynamic>;
    return BookGenreModel(
      bookId: json['book_id'] as int? ?? 0,
      genreId: genre['id'] as int? ?? 0,
      genreName: genre['genre_name'] as String? ?? '',
    );
  }
}
