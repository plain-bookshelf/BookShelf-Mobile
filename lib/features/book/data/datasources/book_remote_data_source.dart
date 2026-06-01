import 'package:bookshelf_mobile/core/network/api_client.dart';
import 'package:bookshelf_mobile/features/book/data/models/book_detail_model.dart';
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
}

final bookRemoteDataSourceProvider = Provider<BookRemoteDataSource>(
  (ref) => BookRemoteDataSource(ref.watch(dioProvider)),
);
