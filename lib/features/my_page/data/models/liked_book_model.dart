import 'package:bookshelf_mobile/features/my_page/domain/entities/liked_book.dart';

/// GET /myPage/like-book 응답의 단일 책 모델
class LikedBookModel {
  final int bookAffiliationId;
  final String title;
  final String bookImage;

  const LikedBookModel({
    required this.bookAffiliationId,
    required this.title,
    required this.bookImage,
  });

  factory LikedBookModel.fromJson(Map<String, dynamic> json) => LikedBookModel(
        bookAffiliationId: json['book_affiliation_id'] as int? ?? 0,
        title: json['title'] as String? ?? '',
        bookImage: json['book_image'] as String? ?? '',
      );

  LikedBook toEntity() => LikedBook(
        bookAffiliationId: bookAffiliationId,
        title: title,
        bookImage: bookImage,
      );
}
