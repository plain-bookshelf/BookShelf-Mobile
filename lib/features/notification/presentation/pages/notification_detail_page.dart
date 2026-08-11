import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:bookshelf_mobile/features/notification/presentation/providers/notification_provider.dart';
import 'package:bookshelf_mobile/features/notification/presentation/widgets/detail_app_bar.dart';
import 'package:bookshelf_mobile/features/notification/presentation/widgets/detail_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ── NotificationDetailPage ────────────────────────────────────────────────────
class NotificationDetailPage extends ConsumerWidget {
  final String notificationId;

  const NotificationDetailPage({super.key, required this.notificationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notification = ref.watch(
      notificationProvider.select(
        (s) => s.notifications.where((n) => n.id == notificationId).firstOrNull,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: DetailAppBar(onBack: () => context.pop()),
      body: notification == null
          ? const Center(
              child: Text('알림을 찾을 수 없습니다.', style: AppTextStyles.caption1),
            )
          : DetailBody(notification: notification),
    );
  }
}
