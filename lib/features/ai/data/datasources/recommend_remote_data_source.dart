import 'package:bookshelf_mobile/core/network/api_client.dart';
import 'package:bookshelf_mobile/features/ai/data/models/recommended_book_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _kRecommendBooks = '/recommend_books';

/// 추천(ML) 서버 원격 데이터 소스
class RecommendRemoteDataSource {
  final Dio _dio;

  const RecommendRemoteDataSource(this._dio);

  /// GET /recommend_books
  Future<List<RecommendedBookModel>> getRecommendedBooks({
    required String memberId,
    int limit = 20,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      _kRecommendBooks,
      queryParameters: {'member_id': memberId, 'limit': limit},
    );
    final books = response.data!['books'] as List<dynamic>? ?? [];
    return books
        .map((e) => RecommendedBookModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

final recommendRemoteDataSourceProvider = Provider<RecommendRemoteDataSource>(
  (ref) => RecommendRemoteDataSource(ref.watch(recommendDioProvider)),
);
