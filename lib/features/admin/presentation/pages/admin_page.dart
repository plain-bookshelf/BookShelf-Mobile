import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:bookshelf_mobile/core/widgets/admin_bottom_nav_bar.dart';
import 'package:bookshelf_mobile/features/admin/presentation/providers/admin_provider.dart';
import 'package:bookshelf_mobile/features/admin/presentation/widgets/admin_app_bar.dart';
import 'package:bookshelf_mobile/features/admin/presentation/widgets/event_banner.dart';
import 'package:bookshelf_mobile/features/admin/presentation/widgets/rental_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── AdminPage ─────────────────────────────────────────────────────────────────
class AdminPage extends ConsumerWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const AdminAppBar(),
      body: Stack(
        children: [
          _buildBody(state, ref),
          if (state.hasActiveEvent) const EventBanner(),
        ],
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildBody(AdminState state, WidgetRef ref) {
    return switch (state.status) {
      AdminStatus.loading => const Center(
        child: CircularProgressIndicator(color: AppColors.successNormal),
      ),
      AdminStatus.failure => const Center(
        child: Text('데이터를 불러올 수 없습니다.', style: AppTextStyles.caption1),
      ),
      AdminStatus.loaded =>
        state.isEmpty
            ? const Center(
                child: Text(
                  '대기 중인 대여 요청이 없습니다.',
                  style: AppTextStyles.caption1,
                ),
              )
            : RentalList(
                requests: state.rentalRequests,
                onApprove: (id) =>
                    ref.read(adminProvider.notifier).approveRental(id),
                onCancel: (id) =>
                    ref.read(adminProvider.notifier).cancelRental(id),
              ),
    };
  }
}
