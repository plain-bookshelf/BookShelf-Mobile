import 'package:bookshelf_mobile/features/book/domain/entities/book.dart';

/// Book 도메인 엔티티의 데이터 모델
class BookModel extends Book {
  const BookModel({
    required super.id,
    required super.title,
    required super.author,
    required super.genre,
    required super.publisher,
    required super.publishYear,
    required super.status,
    super.rating,
    super.reviewCount,
    super.description,
    super.coverUrl,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) => BookModel(
        id: json['id'] as String,
        title: json['title'] as String,
        author: json['author'] as String,
        genre: json['genre'] as String,
        publisher: json['publisher'] as String,
        publishYear: json['publishYear'] as int,
        status: BookStatus.values.byName(json['status'] as String),
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        reviewCount: json['reviewCount'] as int? ?? 0,
        description: json['description'] as String?,
        coverUrl: json['coverUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'author': author,
        'genre': genre,
        'publisher': publisher,
        'publishYear': publishYear,
        'status': status.name,
        'rating': rating,
        'reviewCount': reviewCount,
        'description': description,
        'coverUrl': coverUrl,
      };
}
