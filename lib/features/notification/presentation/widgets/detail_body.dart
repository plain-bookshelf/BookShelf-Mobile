import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:bookshelf_mobile/features/notification/domain/entities/app_notification.dart';
import 'package:bookshelf_mobile/features/notification/presentation/widgets/book_cover.dart';
import 'package:flutter/material.dart';

// ── 상세 본문 ─────────────────────────────────────────────────────────────────
class DetailBody extends StatelessWidget {
  final AppNotification notification;

  const DetailBody({super.key, required this.notification});

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
            Center(child: BookCover(coverUrl: notification.coverUrl!)),
          ],
        ],
      ),
    );
  }
}
