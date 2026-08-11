import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:bookshelf_mobile/features/admin/domain/entities/rental_request.dart';
import 'package:bookshelf_mobile/features/admin/presentation/widgets/action_button.dart';
import 'package:flutter/material.dart';

// ── 대여 요청 아이템 ───────────────────────────────────────────────────────────
class RentalRequestItem extends StatelessWidget {
  final RentalRequest request;
  final VoidCallback onApprove;
  final VoidCallback onCancel;

  const RentalRequestItem({
    super.key,
    required this.request,
    required this.onApprove,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          // 학번/이름 + 도서명
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(request.userLabel, style: AppTextStyles.body2SemiBold),
                const SizedBox(height: 2),
                Text(request.bookLabel, style: AppTextStyles.caption1),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // 액션 버튼 영역
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ActionButton(label: '대여', filled: true, onPressed: onApprove),
              const SizedBox(width: 8),
              ActionButton(label: '취소', filled: false, onPressed: onCancel),
            ],
          ),
        ],
      ),
    );
  }
}
