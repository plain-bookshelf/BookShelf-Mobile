import 'dart:io';

import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/network/api_error.dart';
import 'package:bookshelf_mobile/core/network/auth_session_provider.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/core/widgets/app_bottom_nav_bar.dart';
import 'package:bookshelf_mobile/core/widgets/app_main_app_bar.dart';
import 'package:bookshelf_mobile/core/widgets/error_dialog.dart';
import 'package:bookshelf_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:bookshelf_mobile/features/my_page/presentation/providers/my_page_provider.dart';
import 'package:bookshelf_mobile/features/my_page/presentation/widgets/confirm_dialog.dart';
import 'package:bookshelf_mobile/features/my_page/presentation/widgets/menu_tile.dart';
import 'package:bookshelf_mobile/features/my_page/presentation/widgets/nickname_dialog.dart';
import 'package:bookshelf_mobile/features/my_page/presentation/widgets/profile_section.dart';
import 'package:bookshelf_mobile/features/my_page/presentation/widgets/stats_row.dart';
import 'package:bookshelf_mobile/features/my_page/presentation/widgets/withdraw_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

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
                  Text(
                    state.errorMessage!,
                    style: const TextStyle(color: AppColors.grey600),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => ref.read(myPageProvider.notifier).fetch(),
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            )
          : ListView(
              children: [
                ProfileSection(
                  profileImage: state.data?.profileImage ?? '',
                  name: state.data?.nickname ?? '',
                  rentalTitle: state.data?.mostLittleLeftRentalTitle,
                  rentalDaysLeft: state.data?.mostLittleLeftRentalDate,
                  isUploadingImage: state.isUploadingImage,
                  onTapProfileImage: () => _showProfileEditSheet(
                    context,
                    ref,
                    state.data?.nickname ?? '',
                  ),
                ),
                const Divider(height: 1, color: AppColors.borderLight),
                StatsRow(
                  rentalCount: state.data?.rentedBookCount ?? 0,
                  reservationCount: state.data?.reservedBookCount ?? 0,
                  overdueCount: state.data?.overdueBookCount ?? 0,
                ),
                const Divider(height: 1, color: AppColors.borderLight),
                const SizedBox(height: 8),
                MenuTile(
                  icon: Icons.receipt_long_outlined,
                  label: '대여 내역',
                  onTap: () => context.push(AppRoutes.rentalHistory),
                ),
                MenuTile(
                  icon: Icons.favorite_border,
                  label: '좋아요한 책',
                  onTap: () => context.push(AppRoutes.likedBooks),
                ),
                const SizedBox(height: 8),
                const Divider(height: 1, color: AppColors.borderLight),
                const SizedBox(height: 8),
                MenuTile(
                  icon: Icons.logout,
                  label: '로그아웃',
                  color: AppColors.errorNormal,
                  onTap: () => _showLogoutDialog(context, ref),
                ),
                MenuTile(
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

void _showProfileEditSheet(
  BuildContext context,
  WidgetRef ref,
  String currentNickname,
) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(
              Icons.photo_camera_outlined,
              color: AppColors.textDark,
            ),
            title: const Text(
              '사진 변경',
              style: TextStyle(fontSize: 15, color: AppColors.textDark),
            ),
            onTap: () {
              context.pop();
              _pickAndUploadImage(context, ref);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_outlined, color: AppColors.textDark),
            title: const Text(
              '이름 설정',
              style: TextStyle(fontSize: 15, color: AppColors.textDark),
            ),
            onTap: () {
              context.pop();
              _showNicknameDialog(context, ref, currentNickname);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.apartment_outlined,
              color: AppColors.textDark,
            ),
            title: const Text(
              '소속 변경',
              style: TextStyle(fontSize: 15, color: AppColors.textDark),
            ),
            onTap: () {
              context.pop();
              context.push(AppRoutes.affiliationChange);
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}

void _showNicknameDialog(
  BuildContext context,
  WidgetRef ref,
  String currentNickname,
) {
  showDialog(
    context: context,
    builder: (_) => NicknameDialog(
      currentNickname: currentNickname,
      onCheckDuplicate: (nickname) =>
          ref.read(myPageProvider.notifier).validNickname(nickname),
      onConfirm: (newNickname) async {
        final success = await ref
            .read(myPageProvider.notifier)
            .updateNickname(newNickname);
        if (!context.mounted) return;
        context.pop();
        if (!success) {
          final error = ref.read(myPageProvider).errorMessage;
          await showErrorDialog(
            context,
            title: '이름 변경 실패',
            message: error ?? '이름 변경에 실패했습니다. 다시 시도해주세요.',
          );
        }
      },
    ),
  );
}

Future<void> _pickAndUploadImage(BuildContext context, WidgetRef ref) async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 85,
  );
  if (picked == null) return;

  final file = File(picked.path);
  await ref.read(myPageProvider.notifier).uploadProfileImage(file);

  if (!context.mounted) return;
  final error = ref.read(myPageProvider).errorMessage;
  if (error != null) {
    await showErrorDialog(
      context,
      title: '프로필 이미지 변경 실패',
      message: error,
    );
  }
}

// ─────────────────────────────────────────
// 다이얼로그
// ─────────────────────────────────────────
void _showLogoutDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (_) => ConfirmDialog(
      title: '로그아웃 하시겠습니까?',
      cancelLabel: '취소',
      confirmLabel: '로그아웃',
      confirmColor: AppColors.errorNormal,
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
    builder: (_) => WithdrawDialog(
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
          await showErrorDialog(
            context,
            title: '회원 탈퇴 실패',
            message: parseApiErrorMessage(
              e,
              fallback: '회원 탈퇴에 실패했습니다. 다시 시도해주세요.',
            ),
          );
        }
      },
    ),
  );
}
