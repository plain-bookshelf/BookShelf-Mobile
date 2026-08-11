import 'package:bookshelf_mobile/features/book/domain/entities/book.dart';

/// GET /recommend_books 응답의 개별 도서 모델
class RecommendedBookModel {
  final int id;
  final String title;
  final String img;
  final double dis;

  const RecommendedBookModel({
    required this.id,
    required this.title,
    required this.img,
    required this.dis,
  });

  factory RecommendedBookModel.fromJson(Map<String, dynamic> json) =>
      RecommendedBookModel(
        id: json['id'] as int? ?? 0,
        title: json['title'] as String? ?? '',
        img: json['img'] as String? ?? '',
        dis: (json['dis'] as num?)?.toDouble() ?? 0.0,
      );

  /// 추천 API는 표지/제목만 내려주므로 나머지 필드는 기본값으로 채움
  Book toEntity() => Book(
    id: id.toString(),
    title: title,
    author: '',
    genre: '',
    publisher: '',
    publishYear: 0,
    status: BookStatus.available,
    coverUrl: img,
  );
}
