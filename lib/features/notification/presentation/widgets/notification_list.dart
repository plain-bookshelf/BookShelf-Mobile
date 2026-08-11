import 'package:bookshelf_mobile/features/notification/domain/entities/app_notification.dart';
import 'package:bookshelf_mobile/features/notification/presentation/widgets/notification_card.dart';
import 'package:flutter/material.dart';

// ── 알림 목록 ─────────────────────────────────────────────────────────────────
class NotificationList extends StatelessWidget {
  final List<AppNotification> notifications;
  final ValueChanged<AppNotification> onTap;

  const NotificationList({
    super.key,
    required this.notifications,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) => NotificationCard(
        notification: notifications[index],
        onTap: () => onTap(notifications[index]),
      ),
    );
  }
}
