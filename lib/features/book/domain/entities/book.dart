/// 도서 대여 상태
enum BookStatus { available, rented, reserved }

/// 도서 도메인 엔티티
class Book {
  final String id;
  final String title;
  final String author;
  final String genre;
  final String publisher;
  final int publishYear;
  final BookStatus status;
  final double rating;
  final int reviewCount;
  final String? description;
  final String? coverUrl;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.publisher,
    required this.publishYear,
    required this.status,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.description,
    this.coverUrl,
  });

  bool get isAvailable => status == BookStatus.available;
}
