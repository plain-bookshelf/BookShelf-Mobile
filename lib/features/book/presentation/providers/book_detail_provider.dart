import 'package:bookshelf_mobile/core/network/auth_session_provider.dart';
import 'package:bookshelf_mobile/features/book/data/datasources/book_remote_data_source.dart';
import 'package:dio/dio.dart';
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

      // 댓글 로드 (실패해도 상세 화면은 표시)
      List<Review> reviews = const [];
      try {
        final commentPage = await ref
            .read(bookRemoteDataSourceProvider)
            .getBookComments(bookId: id, accessToken: accessToken);
        reviews = commentPage.content.map((c) => c.toReview()).toList();
      } catch (_) {
        reviews = const [];
      }

      if (!_mounted) return;

      state = BookDetailState(
        status: BookDetailStatus.loaded,
        book: book,
        detail: detail,
        isWishlisted: detail.isLiked,
        reviews: reviews,
        recommendations: _dummyRecommendations, // TODO: 추천 API 연동 시 교체
      );
    } catch (e) {
      if (!_mounted) return;
      state = state.copyWith(status: BookDetailStatus.failure);
    }
  }

  // ── 위시리스트 토글 ────────────────────────────────────────────────────────
  Future<void> toggleWishlist() async {
    final previous = state.isWishlisted;
    final willLike = !previous;
    // 낙관적 업데이트
    state = state.copyWith(isWishlisted: willLike);

    try {
      final accessToken = ref.read(authSessionProvider).accessToken ?? '';
      await ref.read(bookRemoteDataSourceProvider).setBookLike(
            bookId: bookId,
            accessToken: accessToken,
            liked: willLike,
          );
    } catch (_) {
      // 실패 시 이전 상태로 롤백
      if (!_mounted) return;
      state = state.copyWith(isWishlisted: previous);
    }
  }

  // ── 줄거리 전체보기 토글 ──────────────────────────────────────────────────
  void toggleDescription() => state = state.copyWith(
        isDescriptionExpanded: !state.isDescriptionExpanded,
      );

  // ── 리뷰 좋아요 토글 ──────────────────────────────────────────────────────
  Future<void> toggleReviewLike(String reviewId) async {
    final previous = state.reviews;
    final index = previous.indexWhere((r) => r.id == reviewId);
    if (index == -1) return;
    final willLike = !previous[index].isLiked;

    // 낙관적 업데이트
    final updated = previous.map((r) {
      if (r.id != reviewId) return r;
      return r.copyWith(
        isLiked: willLike,
        likeCount: willLike ? r.likeCount + 1 : r.likeCount - 1,
      );
    }).toList();
    state = state.copyWith(reviews: updated);

    try {
      final accessToken = ref.read(authSessionProvider).accessToken ?? '';
      await ref.read(bookRemoteDataSourceProvider).setCommentLike(
            commentId: reviewId,
            accessToken: accessToken,
            liked: willLike,
          );
    } catch (_) {
      // 실패 시 이전 상태로 롤백
      if (!_mounted) return;
      state = state.copyWith(reviews: previous);
    }
  }

  // ── 대여 요청 ─────────────────────────────────────────────────────────────
  Future<void> requestRental() async {
    try {
      final accessToken = ref.read(authSessionProvider).accessToken ?? '';
      await ref
          .read(bookRemoteDataSourceProvider)
          .requestRental(bookId: bookId, accessToken: accessToken);
      if (!_mounted) return;
      // 대여 성공 → 상세 정보 갱신(대여 가능 상태 반영) 후 토스트
      await _loadDetail(bookId);
      if (!_mounted) return;
      state = state.copyWith(toastMessage: '책 대여에 성공했어요!');
    } on DioException catch (e) {
      if (!_mounted) return;
      state = state.copyWith(
        toastMessage: _serverMessage(e) ?? '대여에 실패했어요. 잠시 후 다시 시도해주세요.',
      );
    } catch (_) {
      if (!_mounted) return;
      state = state.copyWith(
        toastMessage: '대여에 실패했어요. 잠시 후 다시 시도해주세요.',
      );
    }
  }

  /// 서버 에러 응답({code, message, status, path})에서 message 추출
  String? _serverMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return null;
  }

  // ── 예약 요청 ─────────────────────────────────────────────────────────────
  Future<void> requestReservation() async {
    try {
      final accessToken = ref.read(authSessionProvider).accessToken ?? '';
      await ref
          .read(bookRemoteDataSourceProvider)
          .requestReservation(bookId: bookId, accessToken: accessToken);
      if (!_mounted) return;
      // 예약 성공 → 상세 정보 갱신 후 토스트
      await _loadDetail(bookId);
      if (!_mounted) return;
      state = state.copyWith(toastMessage: '책 예약에 성공했어요!');
    } on DioException catch (e) {
      if (!_mounted) return;
      state = state.copyWith(
        toastMessage: _serverMessage(e) ?? '예약에 실패했어요. 잠시 후 다시 시도해주세요.',
      );
    } catch (_) {
      if (!_mounted) return;
      state = state.copyWith(
        toastMessage: '예약에 실패했어요. 잠시 후 다시 시도해주세요.',
      );
    }
  }

  // ── 댓글 작성 ─────────────────────────────────────────────────────────────
  Future<void> addReview(String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;

    try {
      final accessToken = ref.read(authSessionProvider).accessToken ?? '';

      // 1) 댓글 작성 API 호출
      await ref.read(bookRemoteDataSourceProvider).writeComment(
            bookId: bookId,
            accessToken: accessToken,
            comment: trimmed,
          );
      if (!_mounted) return;

      // 2) 작성 성공 → 목록 재조회 시도 (실패해도 작성 성공 토스트는 유지)
      try {
        final commentPage = await ref
            .read(bookRemoteDataSourceProvider)
            .getBookComments(bookId: bookId, accessToken: accessToken);
        if (!_mounted) return;
        state = state.copyWith(
          reviews: commentPage.content.map((c) => c.toReview()).toList(),
        );
      } catch (_) {
        // 서버 오류 등으로 목록 재조회 실패 시 기존 목록 유지
      }

      if (!_mounted) return;
      state = state.copyWith(toastMessage: '댓글이 등록되었습니다.');
    } on DioException catch (e) {
      if (!_mounted) return;
      state = state.copyWith(
        toastMessage: _serverMessage(e) ?? '댓글 등록에 실패했어요.',
      );
    } catch (_) {
      if (!_mounted) return;
      state = state.copyWith(toastMessage: '댓글 등록에 실패했어요.');
    }
  }

  // ── 토스트 초기화 ──────────────────────────────────────────────────────────
  void clearToast() => state = state.copyWith(toastMessage: null);
}

// Riverpod 3 family: create 함수가 ArgT를 받아 Notifier 인스턴스를 직접 생성
final bookDetailProvider =
    NotifierProvider.family<BookDetailNotifier, BookDetailState, String>(
  (arg) => BookDetailNotifier(arg),
);
