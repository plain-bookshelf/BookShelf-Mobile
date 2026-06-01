import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:bookshelf_mobile/features/notification/domain/entities/app_notification.dart';
import 'package:bookshelf_mobile/features/notification/presentation/providers/notification_provider.dart';
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
      appBar: _DetailAppBar(onBack: () => context.pop()),
      body: notification == null
          ? const Center(
              child: Text('알림을 찾을 수 없습니다.', style: AppTextStyles.caption1),
            )
          : _DetailBody(notification: notification),
    );
  }
}

// ── AppBar ────────────────────────────────────────────────────────────────────
class _DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBack;

  const _DetailAppBar({required this.onBack});

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

// ── 상세 본문 ─────────────────────────────────────────────────────────────────
class _DetailBody extends StatelessWidget {
  final AppNotification notification;

  const _DetailBody({required this.notification});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목
          Text(notification.title, style: AppTextStyles.heading2),
          const SizedBox(height: 10),
          // 본문
          Text(
            notification.body,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.grey700,
              height: 1.6,
            ),
          ),
          // 도서 표지 (coverUrl 있을 때만)
          if (notification.coverUrl != null) ...[
            const SizedBox(height: 28),
            Center(
              child: _BookCover(coverUrl: notification.coverUrl!),
            ),
          ],
        ],
      ),
    );
  }
}

// ── 도서 표지 이미지 ──────────────────────────────────────────────────────────
class _BookCover extends StatelessWidget {
  final String coverUrl;

  const _BookCover({required this.coverUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        coverUrl,
        width: 200,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const SizedBox(
            width: 200,
            height: 280,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.successNormal),
            ),
          );
        },
        errorBuilder: (_, _, _) => Container(
          width: 200,
          height: 280,
          decoration: BoxDecoration(
            color: AppColors.grey200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Icon(Icons.book_outlined, size: 48, color: AppColors.grey400),
          ),
        ),
      ),
    );
  }
}
