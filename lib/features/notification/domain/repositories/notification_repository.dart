import 'package:bookshelf_mobile/features/notification/domain/entities/app_notification.dart';

/// 알림 Repository 인터페이스 (Domain Layer)
abstract interface class NotificationRepository {
  /// 전체 알림 목록 조회
  Future<List<AppNotification>> getNotifications();

  /// 알림 읽음 처리
  Future<void> markAsRead(String id);

  /// 전체 읽음 처리
  Future<void> markAllAsRead();
}
