import 'package:bookshelf_mobile/features/notification/data/datasources/notification_remote_data_source.dart';
import 'package:bookshelf_mobile/features/notification/domain/entities/app_notification.dart';
import 'package:bookshelf_mobile/features/notification/domain/repositories/notification_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remote;

  const NotificationRepositoryImpl(this._remote);

  @override
  Future<List<AppNotification>> getNotifications({
    required String accessToken,
    int page = 0,
    int size = 20,
  }) async {
    final model = await _remote.getNotifications(
      accessToken: accessToken,
      page: page,
      size: size,
    );
    return model.content.map((e) => e.toEntity()).toList();
  }
}

final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => NotificationRepositoryImpl(
    ref.watch(notificationRemoteDataSourceProvider),
  ),
);
