import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 앱 전체 공용 하단 네비게이션 바
///
/// [currentIndex] : 0 검색 · 1 AI · 2 홈 · 3 랭킹 · 4 마이페이지
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavBar({super.key, required this.currentIndex});

  static const _routes = [
    AppRoutes.search,
    AppRoutes.ai,
    AppRoutes.home,
    AppRoutes.ranking,
    AppRoutes.myPage,
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
          if (index != currentIndex) context.go(_routes[index]);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
          BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome), label: 'AI'),
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events_outlined), label: '랭킹'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: '마이페이지'),
        ],
      ),
    );
  }
}
