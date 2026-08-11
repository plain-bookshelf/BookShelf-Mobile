import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/features/notification/presentation/providers/notification_provider.dart';
import 'package:bookshelf_mobile/features/notification/presentation/widgets/notification_app_bar.dart';
import 'package:bookshelf_mobile/features/notification/presentation/widgets/notification_list.dart';
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
      appBar: NotificationAppBar(onBack: () => context.pop()),
      body: switch (state.status) {
        NotificationStatus.loading => const Center(
          child: CircularProgressIndicator(color: AppColors.successNormal),
        ),
        NotificationStatus.failure => const Center(
          child: Text('알림을 불러올 수 없습니다.', style: AppTextStyles.caption1),
        ),
        NotificationStatus.loaded =>
          state.notifications.isEmpty
              ? const Center(
                  child: Text('알림이 없습니다.', style: AppTextStyles.caption1),
                )
              : NotificationList(
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
