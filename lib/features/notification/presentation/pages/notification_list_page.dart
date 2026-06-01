import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/features/notification/domain/entities/app_notification.dart';
import 'package:bookshelf_mobile/features/notification/presentation/providers/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ── NotificationListPage ──────────────────────────────────────────────────────
class NotificationListPage extends ConsumerWidget {
  const NotificationListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _NotificationAppBar(onBack: () => context.pop()),
      body: switch (state.status) {
        NotificationStatus.loading => const Center(
            child: CircularProgressIndicator(color: AppColors.successNormal),
          ),
        NotificationStatus.failure => const Center(
            child: Text('알림을 불러올 수 없습니다.', style: AppTextStyles.caption1),
          ),
        NotificationStatus.loaded => state.notifications.isEmpty
            ? const Center(
                child:
                    Text('알림이 없습니다.', style: AppTextStyles.caption1),
              )
            : _NotificationList(
                notifications: state.notifications,
                onTap: (notification) {
                  ref
                      .read(notificationProvider.notifier)
                      .markAsRead(notification.id);
                  context.push(
                    AppRoutes.notificationDetailOf(notification.id),
                  );
                },
              ),
      },
    );
  }
}

// ── AppBar ────────────────────────────────────────────────────────────────────
class _NotificationAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onBack;

  const _NotificationAppBar({required this.onBack});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: GestureDetector(
        onTap: onBack,
        child: const Icon(
          Icons.arrow_back_ios_new,
          size: 18,
          color: AppColors.grey600,
        ),
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppColors.borderLight),
      ),
    );
  }
}

// ── 알림 목록 ─────────────────────────────────────────────────────────────────
class _NotificationList extends StatelessWidget {
  final List<AppNotification> notifications;
  final ValueChanged<AppNotification> onTap;

  const _NotificationList({
    required this.notifications,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) => _NotificationCard(
        notification: notifications[index],
        onTap: () => onTap(notifications[index]),
      ),
    );
  }
}

// ── 알림 카드 ─────────────────────────────────────────────────────────────────
class _NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderNormal),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목 + 읽음 dot
            Row(
              children: [
                Expanded(
                  child: Text(
                    notification.title,
                    style: AppTextStyles.body2SemiBold,
                  ),
                ),
                if (!notification.isRead)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.successNormal,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            // 미리보기 본문 (한 줄, 말줄임)
            Text(
              notification.body,
              style: AppTextStyles.caption1,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
