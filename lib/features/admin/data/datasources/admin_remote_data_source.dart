import 'package:bookshelf_mobile/core/network/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminRemoteDataSource {
  final Dio _dio;

  const AdminRemoteDataSource(this._dio);

  /// PATCH /api/manager/approve/{bookDetailId} — 관리자 대여 요청 승인
  Future<void> approveRental({
    required String bookDetailId,
    required String accessToken,
  }) async {
    await _dio.patch<void>(
      '/api/manager/approve/$bookDetailId',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
  }
}

final adminRemoteDataSourceProvider = Provider<AdminRemoteDataSource>(
  (ref) => AdminRemoteDataSource(ref.watch(dioProvider)),
);
