import 'package:bookshelf_mobile/core/network/api_client.dart';
import 'package:bookshelf_mobile/features/book/data/models/book_detail_model.dart';
import 'package:bookshelf_mobile/features/book/data/models/comment_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookRemoteDataSource {
  final Dio _dio;

  const BookRemoteDataSource(this._dio);

  /// GET /book/{bookAffiliationId}
  Future<BookDetailModel> getBookDetail({
    required String bookId,
    required String accessToken,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/book/$bookId',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    final raw = response.data!['data'];
    final data = raw is Map<String, dynamic>
        ? raw
        : Map<String, dynamic>.from(raw as Map);
    return BookDetailModel.fromJson(data);
  }

  /// GET /book/{bookAffiliationId}/comment
  Future<CommentPageModel> getBookComments({
    required String bookId,
    required String accessToken,
    int page = 0,
    int size = 20,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/book/$bookId/comment',
      queryParameters: {'page': page, 'size': size},
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    final raw = response.data!['data'];
    final data = raw is Map<String, dynamic>
        ? raw
        : Map<String, dynamic>.from(raw as Map);
    return CommentPageModel.fromJson(data);
  }

  /// POST /api/comment/{bookAffiliationId}/write — 댓글 작성
  Future<void> writeComment({
    required String bookId,
    required String accessToken,
    required String comment,
  }) async {
    await _dio.post<void>(
      '/api/comment/$bookId/write',
      data: {'comment': comment},
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
  }

  /// 댓글 좋아요 / 취소
  /// - 좋아요: POST /api/comment/{commentId}/like
  /// - 취소:  POST /api/comment/{commentId}/unlike
  Future<void> setCommentLike({
    required String commentId,
    required String accessToken,
    required bool liked,
  }) async {
    await _dio.post<void>(
      '/api/comment/$commentId/${liked ? 'like' : 'unlike'}',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
  }

  /// 책 좋아요(위시리스트) / 취소
  /// - 좋아요: POST   /api/bookDetail/{bookAffiliationId}/like
  /// - 취소:  DELETE /api/bookDetail/{bookAffiliationId}/unlike
  Future<void> setBookLike({
    required String bookId,
    required String accessToken,
    required bool liked,
  }) async {
    final options = Options(headers: {'Authorization': 'Bearer $accessToken'});
    if (liked) {
      await _dio.post<void>('/api/bookDetail/$bookId/like', options: options);
    } else {
      await _dio.delete<void>('/api/bookDetail/$bookId/unlike', options: options);
    }
  }

  /// POST /api/{bookAffiliationId}/rental — 책 대여
  Future<void> requestRental({
    required String bookId,
    required String accessToken,
  }) async {
    await _dio.post<void>(
      '/api/$bookId/rental',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
  }

  /// POST /api/{bookAffiliationId}/reservation — 책 예약
  Future<void> requestReservation({
    required String bookId,
    required String accessToken,
  }) async {
    await _dio.post<void>(
      '/api/$bookId/reservation',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
  }
}

final bookRemoteDataSourceProvider = Provider<BookRemoteDataSource>(
  (ref) => BookRemoteDataSource(ref.watch(dioProvider)),
);
