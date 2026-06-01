import 'package:bookshelf_mobile/core/network/auth_session_provider.dart';
import 'package:bookshelf_mobile/features/book/data/datasources/book_remote_data_source.dart';
import 'package:bookshelf_mobile/features/book/data/models/book_detail_model.dart';
import 'package:bookshelf_mobile/features/book/domain/entities/book.dart';
import 'package:bookshelf_mobile/features/book/domain/entities/review.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── 로딩 상태 열거 ────────────────────────────────────────────────────────────
enum BookDetailStatus { loading, loaded, failure }

// ── BookDetailState ──────────────────────────────────────────────────────────
class BookDetailState {
  final BookDetailStatus status;
  final Book? book;
  final BookDetailModel? detail; // API 원본 데이터
  final List<Review> reviews;
  final List<Book> recommendations;
  final bool isWishlisted;
  final bool isDescriptionExpanded;
  final String? toastMessage;

  const BookDetailState({
    this.status = BookDetailStatus.loading,
    this.book,
    this.detail,
    this.reviews = const [],
    this.recommendations = const [],
    this.isWishlisted = false,
    this.isDescriptionExpanded = false,
    this.toastMessage,
  });

  bool get isLoaded => status == BookDetailStatus.loaded;
  bool get isAvailable => book?.status == BookStatus.available;

  // toastMessage를 명시적으로 null 로 설정하기 위해 sentinel 사용
  static const _omit = Object();

  BookDetailState copyWith({
    BookDetailStatus? status,
    Book? book,
    BookDetailModel? detail,
    List<Review>? reviews,
    List<Book>? recommendations,
    bool? isWishlisted,
    bool? isDescriptionExpanded,
    Object? toastMessage = _omit,
  }) =>
      BookDetailState(
        status: status ?? this.status,
        book: book ?? this.book,
        detail: detail ?? this.detail,
        reviews: reviews ?? this.reviews,
        recommendations: recommendations ?? this.recommendations,
        isWishlisted: isWishlisted ?? this.isWishlisted,
        isDescriptionExpanded:
            isDescriptionExpanded ?? this.isDescriptionExpanded,
        toastMessage: identical(toastMessage, _omit)
            ? this.toastMessage
            : toastMessage as String?,
      );
}

// ── 더미 데이터 ──────────────────────────────────────────────────────────────
const _dummyReviews = [
  Review(
    id: '1',
    reviewerName: '이*현 님',
    content: '저자가 재미있고 책이 좋아요',
    likeCount: 25,
    isLiked: true,
  ),
  Review(
    id: '2',
    reviewerName: '이*현 님',
    content: '저자가 재미있고 책이 좋아요',
    likeCount: 0,
    isLiked: false,
  ),
  Review(
    id: '3',
    reviewerName: '이*현 님',
    content: '저자가 재미있고 책이 좋아요',
    likeCount: 0,
    isLiked: false,
  ),
  Review(
    id: '4',
    reviewerName: '이*현 님',
    content: '저자가 재미있고 책이 좋아요',
    likeCount: 0,
    isLiked: false,
  ),
];

const _dummyRecommendations = [
  Book(
    id: '10',
    title: '화색인간',
    author: '박화성',
    genre: '소설',
    publisher: '문학동네',
    publishYear: 2020,
    status: BookStatus.available,
  ),
  Book(
    id: '11',
    title: '채식주의자',
    author: '한강',
    genre: '소설',
    publisher: '창비',
    publishYear: 2007,
    status: BookStatus.rented,
  ),
  Book(
    id: '12',
    title: '파친코',
    author: '이민진',
    genre: '소설',
    publisher: '문학사상',
    publishYear: 2017,
    status: BookStatus.available,
  ),
  Book(
    id: '13',
    title: '아몬드',
    author: '손원평',
    genre: '소설',
    publisher: '창비',
    publishYear: 2017,
    status: BookStatus.available,
  ),
];

// ── BookDetailNotifier ───────────────────────────────────────────────────────
// Riverpod 3: family 는 NotifierProvider.family((arg) => Notifier(arg)) 패턴 사용
// FamilyNotifier 는 Riverpod 3 에서 제거됨
class BookDetailNotifier extends Notifier<BookDetailState> {
  /// bookId 는 NotifierProvider.family 의 create 함수에서 생성자로 주입됨
  final String bookId;
  bool _mounted = true;

  BookDetailNotifier(this.bookId);

  @override
  BookDetailState build() {
    ref.onDispose(() => _mounted = false);
    Future.microtask(() => _loadDetail(bookId));
    return const BookDetailState(status: BookDetailStatus.loading);
  }

  // ── 데이터 로드 ────────────────────────────────────────────────────────────
  Future<void> _loadDetail(String id) async {
    try {
      final accessToken = ref.read(authSessionProvider).accessToken ?? '';
      final detail = await ref
          .read(bookRemoteDataSourceProvider)
          .getBookDetail(bookId: id, accessToken: accessToken);

      if (!_mounted) return;

      final info = detail.bookInfo;
      final genreNames = detail.genres.map((g) => g.genreName).join(', ');
      final book = Book(
        id: id,
        title: info.title,
        author: info.author,
        genre: genreNames,
        publisher: info.publisher,
        publishYear: int.tryParse(info.publicationDate.split('-').first) ?? 0,
        status:
            detail.isEnableRental ? BookStatus.available : BookStatus.rented,
        description: info.introduction,
        coverUrl: info.bookImage.isNotEmpty ? info.bookImage : null,
      );

      state = BookDetailState(
        status: BookDetailStatus.loaded,
        book: book,
        detail: detail,
        isWishlisted: detail.isLiked,
        reviews: _dummyReviews, // TODO: 댓글 API 연동 시 교체
        recommendations: _dummyRecommendations, // TODO: 추천 API 연동 시 교체
      );
    } catch (e) {
      if (!_mounted) return;
      state = state.copyWith(status: BookDetailStatus.failure);
    }
  }

  // ── 위시리스트 토글 ────────────────────────────────────────────────────────
  void toggleWishlist() =>
      state = state.copyWith(isWishlisted: !state.isWishlisted);

  // ── 줄거리 전체보기 토글 ──────────────────────────────────────────────────
  void toggleDescription() => state = state.copyWith(
        isDescriptionExpanded: !state.isDescriptionExpanded,
      );

  // ── 리뷰 좋아요 토글 ──────────────────────────────────────────────────────
  void toggleReviewLike(String reviewId) {
    final updated = state.reviews.map((r) {
      if (r.id != reviewId) return r;
      return r.copyWith(
        isLiked: !r.isLiked,
        likeCount: r.isLiked ? r.likeCount - 1 : r.likeCount + 1,
      );
    }).toList();
    state = state.copyWith(reviews: updated);
  }

  // ── 대여 요청 ─────────────────────────────────────────────────────────────
  Future<void> requestRental() async {
    // TODO: BookRepository.requestRental 연동
    await Future.delayed(const Duration(milliseconds: 500));
    if (!_mounted) return;
    state = state.copyWith(
      toastMessage: '대여 요청이 성공적으로 완료되었어요!',
    );
  }

  // ── 예약 요청 ─────────────────────────────────────────────────────────────
  Future<void> requestReservation() async {
    // TODO: BookRepository.requestReservation 연동
    await Future.delayed(const Duration(milliseconds: 500));
    if (!_mounted) return;
    state = state.copyWith(
      toastMessage: '예약이 성공적으로 완료되었어요!',
    );
  }

  // ── 리뷰 추가 ─────────────────────────────────────────────────────────────
  void addReview(String content) {
    if (content.trim().isEmpty) return;
    final newReview = Review(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      reviewerName: '나',
      content: content.trim(),
      likeCount: 0,
      isLiked: false,
    );
    state = state.copyWith(reviews: [...state.reviews, newReview]);
  }

  // ── 토스트 초기화 ──────────────────────────────────────────────────────────
  void clearToast() => state = state.copyWith(toastMessage: null);
}

// Riverpod 3 family: create 함수가 ArgT를 받아 Notifier 인스턴스를 직접 생성
final bookDetailProvider =
    NotifierProvider.family<BookDetailNotifier, BookDetailState, String>(
  (arg) => BookDetailNotifier(arg),
);
