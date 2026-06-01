import 'package:bookshelf_mobile/features/book/domain/entities/book.dart';
import 'package:bookshelf_mobile/features/book/domain/entities/review.dart';
import 'package:bookshelf_mobile/features/book/domain/repositories/book_repository.dart';

/// BookRepository 구현체 (Data Layer)
/// TODO: 실제 API 연동 시 RemoteDataSource 주입
class BookRepositoryImpl implements BookRepository {
  const BookRepositoryImpl();

  @override
  Future<List<Book>> getPopularBooks() {
    throw UnimplementedError();
  }

  @override
  Future<List<Book>> getNewBooks() {
    throw UnimplementedError();
  }

  @override
  Future<List<Book>> getBooksByGenre(String genre) {
    throw UnimplementedError();
  }

  @override
  Future<List<Book>> searchBooks(String query) {
    throw UnimplementedError();
  }

  @override
  Future<Book> getBookDetail(String id) {
    throw UnimplementedError();
  }

  @override
  Future<List<Review>> getBookReviews(String bookId) {
    throw UnimplementedError();
  }

  @override
  Future<List<Book>> getRecommendations(String bookId) {
    throw UnimplementedError();
  }

  @override
  Future<void> requestRental(String bookId) {
    throw UnimplementedError();
  }

  @override
  Future<void> requestReservation(String bookId) {
    throw UnimplementedError();
  }

  @override
  Future<void> toggleWishlist(String bookId, {required bool isWishlisted}) {
    throw UnimplementedError();
  }
}
