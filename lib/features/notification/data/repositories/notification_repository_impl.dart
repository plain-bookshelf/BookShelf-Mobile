import 'package:bookshelf_mobile/features/notification/domain/entities/app_notification.dart';
import 'package:bookshelf_mobile/features/notification/domain/repositories/notification_repository.dart';

/// NotificationRepository 구현체 (Data Layer)
/// TODO: 실제 API 연동 시 RemoteDataSource 주입
class NotificationRepositoryImpl implements NotificationRepository {
  const NotificationRepositoryImpl();

  @override
  Future<List<AppNotification>> getNotifications() {
    throw UnimplementedError();
  }

  @override
  Future<void> markAsRead(String id) {
    throw UnimplementedError();
  }

  @override
  Future<void> markAllAsRead() {
    throw UnimplementedError();
  }
}
