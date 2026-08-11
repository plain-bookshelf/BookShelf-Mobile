import 'package:bookshelf_mobile/core/network/api_client.dart';
import 'package:bookshelf_mobile/features/affiliation/data/models/affiliation_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _kAffiliationView = '/affiliation/view';

class AffiliationRemoteDataSource {
  final Dio _dio;

  const AffiliationRemoteDataSource(this._dio);

  /// GET /affiliation/view — 전체 소속(도서관) 목록 조회
  Future<List<AffiliationModel>> getAffiliations() async {
    final response = await _dio.get<Map<String, dynamic>>(_kAffiliationView);
    final data = response.data!['data'] as Map<String, dynamic>;
    final result = data['affiliation_view_result'] as Map<String, dynamic>;
    final list = result['affiliations'] as List<dynamic>? ?? [];
    return list
        .map((e) => AffiliationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

final affiliationRemoteDataSourceProvider =
    Provider<AffiliationRemoteDataSource>(
      (ref) => AffiliationRemoteDataSource(ref.watch(dioProvider)),
    );
