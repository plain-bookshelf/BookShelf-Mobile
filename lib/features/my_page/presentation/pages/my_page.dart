import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/network/auth_session_provider.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/core/widgets/app_bottom_nav_bar.dart';
import 'package:bookshelf_mobile/core/widgets/app_main_app_bar.dart';
import 'package:bookshelf_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:bookshelf_mobile/features/my_page/presentation/providers/my_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MyPage extends ConsumerStatefulWidget {
  const MyPage({super.key});

  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(myPageProvider.notifier).fetch());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myPageProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppMainAppBar(),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state.errorMessage!,
                          style: const TextStyle(color: AppColors.grey600)),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () =>
                            ref.read(myPageProvider.notifier).fetch(),
                        child: const Text('다시 시도'),
                      ),
                    ],
                  ),
                )
              : ListView(
                  children: [
                    _ProfileSection(
                      profileImage: state.data?.profileImage ?? '',
                      name: state.data?.nickname ?? '',
                      rentalTitle: state.data?.mostLittleLeftRentalTitle,
                      rentalDaysLeft: state.data?.mostLittleLeftRentalDate,
                    ),
                    const Divider(height: 1, color: AppColors.borderLight),
                    _StatsRow(
                      rentalCount: state.data?.rentedBookCount ?? 0,
                      reservationCount: state.data?.reservedBookCount ?? 0,
                      overdueCount: state.data?.overdueBookCount ?? 0,
                    ),
                    const Divider(height: 1, color: AppColors.borderLight),
                    const SizedBox(height: 8),
                    _MenuTile(
                      icon: Icons.receipt_long_outlined,
                      label: '대여 내역',
                      onTap: () => context.push(AppRoutes.rentalHistory),
                    ),
                    const SizedBox(height: 8),
                    const Divider(height: 1, color: AppColors.borderLight),
                    const SizedBox(height: 8),
                    _MenuTile(
                      icon: Icons.logout,
                      label: '로그아웃',
                      color: AppColors.errorNormal,
                      onTap: () => _showLogoutDialog(context, ref),
                    ),
                    _MenuTile(
                      icon: Icons.person_remove_outlined,
                      label: '탈퇴하기',
                      color: AppColors.errorNormal,
                      onTap: () => _showWithdrawDialog(context, ref),
                    ),
                  ],
                ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 4),
    );
  }
}

// ─────────────────────────────────────────
// 프로필 섹션
// ─────────────────────────────────────────
class _ProfileSection extends StatelessWidget {
  final String profileImage;
  final String name;
  final String? rentalTitle;
  final int? rentalDaysLeft;

  const _ProfileSection({
    required this.profileImage,
    required this.name,
    this.rentalTitle,
    this.rentalDaysLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.grey200,
            backgroundImage: profileImage.isNotEmpty
                ? NetworkImage(profileImage)
                : null,
            child: profileImage.isEmpty
                ? Icon(Icons.person, size: 48, color: Colors.grey.shade400)
                : null,
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark),
          ),
          if (rentalTitle != null && rentalDaysLeft != null) ...[
            const SizedBox(height: 6),
            Text(
              '\'$rentalTitle\' 반납까지 $rentalDaysLeft일 남았습니다.',
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey600),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// 통계 Row
// ─────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final int rentalCount;
  final int reservationCount;
  final int overdueCount;

  const _StatsRow({
    required this.rentalCount,
    required this.reservationCount,
    required this.overdueCount,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          _StatItem(label: '대여 중인 책', count: rentalCount),
          const VerticalDivider(width: 1, color: AppColors.borderLight),
          _StatItem(label: '예약한 책', count: reservationCount),
          const VerticalDivider(width: 1, color: AppColors.borderLight),
          _StatItem(label: '연체한 책', count: overdueCount),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int count;

  const _StatItem({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Text('$count권',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark)),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey600)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// 메뉴 타일
// ─────────────────────────────────────────
class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = AppColors.textDark,
  });

  bool get _isDestructive => color == AppColors.errorNormal;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color, size: 22),
      title: Text(label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w500, color: color)),
      trailing: _isDestructive
          ? null
          : const Icon(Icons.arrow_forward_ios,
              size: 14, color: AppColors.grey500),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
    );
  }
}

// ─────────────────────────────────────────
// 다이얼로그
// ─────────────────────────────────────────
void _showLogoutDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (_) => _ConfirmDialog(
      title: '로그아웃 하시겠습니까?',
      cancelLabel: '취소',
      confirmLabel: '로그아웃',
      confirmColor: AppColors.successNormal,
      onConfirm: () async {
        context.pop();
        try {
          final accessToken = ref.read(authSessionProvider).accessToken ?? '';
          await ref
              .read(authRepositoryProvider)
              .logout(accessToken: accessToken);
        } catch (_) {
          // 로그아웃 실패해도 로컬 토큰은 초기화
        } finally {
          if (context.mounted) {
            await ref.read(authSessionProvider.notifier).clear();
            if (context.mounted) context.go(AppRoutes.login);
          }
        }
      },
    ),
  );
}

void _showWithdrawDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (_) => _WithdrawDialog(
      onConfirm: () async {
        context.pop();
        try {
          final accessToken = ref.read(authSessionProvider).accessToken ?? '';
          await ref
              .read(authRepositoryProvider)
              .deleteAccount(accessToken: accessToken);
          if (!context.mounted) return;
          await ref.read(authSessionProvider.notifier).clear();
          if (!context.mounted) return;
          context.go(AppRoutes.login);
        } catch (e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('회원 탈퇴에 실패했습니다. 다시 시도해주세요.'),
              backgroundColor: AppColors.errorNormal,
            ),
          );
        }
      },
    ),
  );
}

// ── 회원탈퇴 전용 다이얼로그 ──────────────────────────────────────────────────
// "동의합니다"를 직접 입력해야 탈퇴 버튼이 활성화됩니다.
class _WithdrawDialog extends StatefulWidget {
  final Future<void> Function() onConfirm;

  const _WithdrawDialog({required this.onConfirm});

  @override
  State<_WithdrawDialog> createState() => _WithdrawDialogState();
}

class _WithdrawDialogState extends State<_WithdrawDialog> {
  final _controller = TextEditingController();
  bool _canConfirm = false;

  static const _confirmKeyword = '동의합니다';

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final matches = _controller.text == _confirmKeyword;
      if (matches != _canConfirm) setState(() => _canConfirm = matches);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      actionsPadding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      title: const Text(
        '회원탈퇴 하시겠습니까?',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 안내 문구
          Text(
            '회원 탈퇴를 진행하시기 위해\n"$_confirmKeyword"를 입력해주세요',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.grey600,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // 입력 필드
          TextField(
            controller: _controller,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textDark,
            ),
            decoration: InputDecoration(
              hintText: _confirmKeyword,
              hintStyle: const TextStyle(
                fontSize: 15,
                color: AppColors.grey400,
              ),
              filled: true,
              fillColor: AppColors.grey100,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppColors.errorNormal,
                  width: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
      actions: [
        Row(
          children: [
            // 취소
            Expanded(
              child: TextButton(
                onPressed: () => context.pop(),
                child: const Text(
                  '취소',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey600,
                  ),
                ),
              ),
            ),
            // 회원탈퇴 (동의합니다 입력 시 활성화)
            Expanded(
              child: TextButton(
                onPressed: _canConfirm ? widget.onConfirm : null,
                child: Text(
                  '회원탈퇴',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: _canConfirm
                        ? AppColors.errorNormal
                        : AppColors.grey400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ConfirmDialog extends StatelessWidget {
  final String title;
  final String cancelLabel;
  final String confirmLabel;
  final Color confirmColor;
  final Future<void> Function() onConfirm;

  const _ConfirmDialog({
    required this.title,
    required this.cancelLabel,
    required this.confirmLabel,
    required this.confirmColor,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(title,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark)),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(cancelLabel,
              style: const TextStyle(
                  color: AppColors.grey600, fontWeight: FontWeight.w500)),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text(confirmLabel,
              style: TextStyle(
                  color: confirmColor, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}
