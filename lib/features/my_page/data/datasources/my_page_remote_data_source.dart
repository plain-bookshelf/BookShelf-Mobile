import 'package:bookshelf_mobile/core/network/api_client.dart';
import 'package:bookshelf_mobile/features/my_page/data/models/my_page_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _kMyPage = '/myPage';

class MyPageRemoteDataSource {
  final Dio _dio;

  const MyPageRemoteDataSource(this._dio);

  /// GET /mypage
  Future<MyPageModel> getMyPage({required String accessToken}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      _kMyPage,
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
final raw = response.data!['data'];
    final data = raw is Map<String, dynamic>
        ? raw
        : Map<String, dynamic>.from(raw as Map);
    return MyPageModel.fromJson(data);
  }
}

final myPageRemoteDataSourceProvider = Provider<MyPageRemoteDataSource>(
  (ref) => MyPageRemoteDataSource(ref.watch(dioProvider)),
);
