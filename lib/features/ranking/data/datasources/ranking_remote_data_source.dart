import 'package:bookshelf_mobile/core/network/api_client.dart';
import 'package:bookshelf_mobile/features/ranking/data/models/ranking_user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RankingRemoteDataSource {
  final Dio _dio;

  const RankingRemoteDataSource(this._dio);

  /// GET /ranking
  Future<List<RankingUserModel>> getRankings({
    required String accessToken,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/ranking',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    final list = response.data!['data'] as List<dynamic>? ?? [];
    return list
        .map((e) => RankingUserModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

final rankingRemoteDataSourceProvider = Provider<RankingRemoteDataSource>(
  (ref) => RankingRemoteDataSource(ref.watch(dioProvider)),
);
