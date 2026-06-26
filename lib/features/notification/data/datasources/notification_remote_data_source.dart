import 'package:bookshelf_mobile/core/network/api_client.dart';
import 'package:bookshelf_mobile/features/notification/data/models/notification_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _kNotification = '/api/notification';

class NotificationRemoteDataSource {
  final Dio _dio;

  const NotificationRemoteDataSource(this._dio);

  /// GET /api/notification
  Future<NotificationPageModel> getNotifications({
    required String accessToken,
    int page = 0,
    int size = 20,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      _kNotification,
      queryParameters: {'page': page, 'size': size},
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    final raw = response.data!['data'];
    final data = raw is Map<String, dynamic>
        ? raw
        : Map<String, dynamic>.from(raw as Map);
    return NotificationPageModel.fromJson(data);
  }
}

final notificationRemoteDataSourceProvider =
    Provider<NotificationRemoteDataSource>(
  (ref) => NotificationRemoteDataSource(ref.watch(dioProvider)),
);
