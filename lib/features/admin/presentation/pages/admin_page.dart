import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/core/widgets/admin_bottom_nav_bar.dart';
import 'package:bookshelf_mobile/features/admin/domain/entities/rental_request.dart';
import 'package:bookshelf_mobile/features/admin/presentation/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ── AdminPage ─────────────────────────────────────────────────────────────────
class AdminPage extends ConsumerWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const _AdminAppBar(),
      body: Stack(
        children: [
          _buildBody(state, ref),
          if (state.hasActiveEvent) const _EventBanner(),
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
      AdminStatus.loaded => state.isEmpty
          ? const Center(
              child: Text('대기 중인 대여 요청이 없습니다.', style: AppTextStyles.caption1),
            )
          : _RentalList(
              requests: state.rentalRequests,
              onApprove: (id) =>
                  ref.read(adminProvider.notifier).approveRental(id),
              onCancel: (id) =>
                  ref.read(adminProvider.notifier).cancelRental(id),
            ),
    };
  }
}

// ── AppBar ────────────────────────────────────────────────────────────────────
class _AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AdminAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const Icon(Icons.menu_book_rounded,
              color: AppColors.successNormal, size: 28),
          const SizedBox(width: 8),
          Text('책마루', style: AppTextStyles.appTitle),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search, color: AppColors.textDark, size: 22),
        ),
        IconButton(
          onPressed: () => context.push(AppRoutes.notifications),
          icon: const Icon(Icons.notifications_none_rounded,
              color: AppColors.textDark, size: 22),
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppColors.borderLight),
      ),
    );
  }
}

// ── 대여 요청 목록 ─────────────────────────────────────────────────────────────
class _RentalList extends StatelessWidget {
  final List<RentalRequest> requests;
  final ValueChanged<String> onApprove;
  final ValueChanged<String> onCancel;

  const _RentalList({
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
        return _RentalRequestItem(
          request: request,
          onApprove: () => onApprove(request.id),
          onCancel: () => onCancel(request.id),
        );
      },
    );
  }
}

// ── 대여 요청 아이템 ───────────────────────────────────────────────────────────
class _RentalRequestItem extends StatelessWidget {
  final RentalRequest request;
  final VoidCallback onApprove;
  final VoidCallback onCancel;

  const _RentalRequestItem({
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
              _ActionButton(
                label: '대여',
                filled: true,
                onPressed: onApprove,
              ),
              const SizedBox(width: 8),
              _ActionButton(
                label: '취소',
                filled: false,
                onPressed: onCancel,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── 액션 버튼 (대여 / 취소) ────────────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.filled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    const shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );
    const labelStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
    );

    if (filled) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.successNormal,
          foregroundColor: AppColors.white,
          shape: shape,
          elevation: 0,
          minimumSize: const Size(60, 36),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(label, style: labelStyle),
      );
    }

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.grey300),
        foregroundColor: AppColors.grey600,
        shape: shape,
        minimumSize: const Size(60, 36),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label, style: labelStyle),
    );
  }
}

// ── 이벤트 배너 버튼 ───────────────────────────────────────────────────────────
class _EventBanner extends StatelessWidget {
  const _EventBanner();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16,
      bottom: 16,
      child: ElevatedButton(
        onPressed: () {
          // TODO: 이벤트 상세 페이지 이동
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.successNormal,
          foregroundColor: AppColors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        child: const Text(
          '이벤트 상세 확인',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
