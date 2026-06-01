import 'package:bookshelf_mobile/features/book/domain/entities/book.dart';
import 'package:bookshelf_mobile/features/book/domain/entities/review.dart';

/// 도서 Repository 인터페이스 (Domain Layer)
abstract interface class BookRepository {
  /// 인기 도서 목록 조회
  Future<List<Book>> getPopularBooks();

  /// 신간 도서 목록 조회
  Future<List<Book>> getNewBooks();

  /// 장르별 도서 목록 조회
  Future<List<Book>> getBooksByGenre(String genre);

  /// 도서 검색
  Future<List<Book>> searchBooks(String query);

  /// 도서 상세 조회
  Future<Book> getBookDetail(String id);

  /// 도서 리뷰 목록 조회
  Future<List<Review>> getBookReviews(String bookId);

  /// 추천 도서 목록 조회
  Future<List<Book>> getRecommendations(String bookId);

  /// 대여 요청
  Future<void> requestRental(String bookId);

  /// 예약 요청
  Future<void> requestReservation(String bookId);

  /// 위시리스트 추가/해제
  Future<void> toggleWishlist(String bookId, {required bool isWishlisted});
}
