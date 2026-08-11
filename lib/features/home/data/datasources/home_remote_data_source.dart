import 'package:bookshelf_mobile/core/network/api_client.dart';
import 'package:bookshelf_mobile/features/home/data/models/main_book_model.dart';
import 'package:bookshelf_mobile/features/home/domain/entities/main_book.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _kMainBook = '/main/book';

class HomeRemoteDataSource {
  final Dio _dio;

  const HomeRemoteDataSource(this._dio);

  /// GET /main/book
  ///
  /// [bookFindType] : POPULAR | RECENT
  Future<MainBookListModel> getMainBooks({
    required String accessToken,
    required BookFindType bookFindType,
    String platformType = 'ANDROID',
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      _kMainBook,
      queryParameters: {
        'bookFindType': bookFindType.name,
        'platformType': platformType,
      },
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    final raw = response.data?['data'];
    // data가 List로 바로 오는 경우와 { content, is_last_page } Map으로 오는 경우 모두 처리
    if (raw is List) {
      return MainBookListModel.fromJson({
        'content': raw,
        'is_last_page': true,
      });
    }
    if (raw is Map) {
      return MainBookListModel.fromJson(Map<String, dynamic>.from(raw));
    }
    // null 이거나 List/Map 이 아니면 응답 형식이 바뀐 것 — 빈 목록으로 뭉개지 않는다
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
      error:
          'GET $_kMainBook 응답의 data 필드가 List/Map이 아닙니다: ${raw.runtimeType}',
    );
  }
}

final homeRemoteDataSourceProvider = Provider<HomeRemoteDataSource>(
  (ref) => HomeRemoteDataSource(ref.watch(dioProvider)),
);
