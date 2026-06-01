import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 일반 사용자 메인 화면 공용 AppBar
///
/// 홈·랭킹·마이페이지 등 책마루 로고 + 검색 + 알림 버튼이 필요한
/// 모든 메인 화면에서 재사용합니다.
///
/// [bottom] 을 전달하면 기본 구분선 대신 해당 위젯이 AppBar 하단에 표시됩니다.
/// 홈·AI 페이지에서 [HomeAiTabBar] 를 전달해 탭 전환 UI를 구성하세요.
class AppMainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final PreferredSizeWidget? bottom;

  const AppMainAppBar({super.key, this.bottom});

  static const _divider = PreferredSize(
    preferredSize: Size.fromHeight(1),
    child: Divider(height: 1, color: AppColors.borderLight),
  );

  @override
  Size get preferredSize {
    final bottomHeight = (bottom ?? _divider).preferredSize.height;
    return Size.fromHeight(kToolbarHeight + bottomHeight);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 20,
      title: Row(
        children: [
          const Icon(Icons.menu_book_rounded,
              color: AppColors.successNormal, size: 26),
          const SizedBox(width: 6),
          Text('책마루', style: AppTextStyles.appTitle),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => context.push(AppRoutes.search),
          icon: const Icon(Icons.search, color: AppColors.textDark, size: 22),
        ),
        IconButton(
          onPressed: () => context.push(AppRoutes.notifications),
          icon: const Icon(Icons.notifications_outlined,
              color: AppColors.textDark, size: 22),
        ),
      ],
      bottom: bottom ?? _divider,
    );
  }
}
