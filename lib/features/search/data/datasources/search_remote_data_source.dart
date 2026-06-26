import 'dart:io';

import 'package:bookshelf_mobile/core/network/api_client.dart';
import 'package:bookshelf_mobile/features/search/data/models/search_book_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _kSearch = '/search';

class SearchRemoteDataSource {
  final Dio _dio;

  const SearchRemoteDataSource(this._dio);

  /// GET /search
  Future<SearchPageModel> search({
    required String accessToken,
    required String keyword,
    int page = 0,
    int size = 12,
  }) async {
    final platformType = Platform.isAndroid
        ? 'ANDROID'
        : Platform.isIOS
            ? 'IOS'
            : 'WEB';

    final response = await _dio.get<Map<String, dynamic>>(
      _kSearch,
      queryParameters: {
        'platformType': platformType,
        'page': page,
        'size': size,
        'keyword': keyword,
      },
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    final raw = response.data!['data'];
    final data = raw is Map<String, dynamic>
        ? raw
        : Map<String, dynamic>.from(raw as Map);
    return SearchPageModel.fromJson(data);
  }
}

final searchRemoteDataSourceProvider = Provider<SearchRemoteDataSource>(
  (ref) => SearchRemoteDataSource(ref.watch(dioProvider)),
);
