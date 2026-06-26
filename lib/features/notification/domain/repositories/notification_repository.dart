import 'package:bookshelf_mobile/features/notification/domain/entities/app_notification.dart';

abstract interface class NotificationRepository {
  Future<List<AppNotification>> getNotifications({
    required String accessToken,
    int page = 0,
    int size = 20,
  });
}
