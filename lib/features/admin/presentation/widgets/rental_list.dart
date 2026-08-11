import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/features/admin/domain/entities/rental_request.dart';
import 'package:bookshelf_mobile/features/admin/presentation/widgets/rental_request_item.dart';
import 'package:flutter/material.dart';

// ── 대여 요청 목록 ─────────────────────────────────────────────────────────────
class RentalList extends StatelessWidget {
  final List<RentalRequest> requests;
  final ValueChanged<String> onApprove;
  final ValueChanged<String> onCancel;

  const RentalList({
    super.key,
    required this.requests,
    required this.onApprove,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: requests.length,
      separatorBuilder: (_, _) =>
          const Divider(height: 1, color: AppColors.borderLight),
      itemBuilder: (context, index) {
        final request = requests[index];
        return RentalRequestItem(
          request: request,
          onApprove: () => onApprove(request.id),
          onCancel: () => onCancel(request.id),
        );
      },
    );
  }
}
