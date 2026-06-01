import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 관리자 전용 하단 네비게이션 바 (6탭)
///
/// [currentIndex] : 0 검색 · 1 AI · 2 홈 · 3 관리 · 4 순위 · 5 마이
class AdminBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const AdminBottomNavBar({super.key, required this.currentIndex});

  static const _items = <_NavItem>[
    _NavItem(icon: Icons.search,           label: '검색',  route: AppRoutes.search),
    _NavItem(icon: Icons.auto_awesome,     label: 'AI',    route: null),
    _NavItem(icon: Icons.home_outlined,    label: '홈',    route: AppRoutes.home),
    _NavItem(icon: Icons.manage_accounts,  label: '관리',  route: AppRoutes.admin),
    _NavItem(icon: Icons.emoji_events_outlined, label: '순위', route: AppRoutes.ranking),
    _NavItem(icon: Icons.person_outline,   label: '마이',  route: AppRoutes.myPage),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.borderLight)),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.successNormal,
        unselectedItemColor: AppColors.grey500,
        selectedLabelStyle:
            const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        backgroundColor: AppColors.white,
        elevation: 0,
        onTap: (index) {
          final route = _items[index].route;
          if (route != null && index != currentIndex) context.go(route);
        },
        items: _items
            .map(
              (item) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                label: item.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

/// 탭 메타데이터 — route 가 null 이면 미구현 탭(탭 시 무반응)
class _NavItem {
  final IconData icon;
  final String label;
  final String? route;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}
