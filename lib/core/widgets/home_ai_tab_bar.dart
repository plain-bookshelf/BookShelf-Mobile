import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 홈(도서 추천) ↔ 마루AI 탭 전환 바
///
/// [currentTab] 으로 어떤 탭이 활성 상태인지 전달합니다.
/// AppMainAppBar 의 bottom 파라미터에 전달하세요.
enum HomeAiTab { home, ai }

class HomeAiTabBar extends StatelessWidget implements PreferredSizeWidget {
  final HomeAiTab currentTab;

  /// 탭 전환을 라우팅 대신 로컬에서 처리하고 싶을 때 사용.
  /// null 이면 기존처럼 해당 라우트로 이동합니다.
  final ValueChanged<HomeAiTab>? onChanged;

  const HomeAiTabBar({super.key, required this.currentTab, this.onChanged});

  @override
  Size get preferredSize => const Size.fromHeight(46);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: HomeAiTab.values.map((tab) {
        final isActive = tab == currentTab;
        final label = tab == HomeAiTab.home ? '도서 추천' : '마루AI';
        final route = tab == HomeAiTab.home ? AppRoutes.home : AppRoutes.ai;

        return Expanded(
          child: GestureDetector(
            onTap: () {
              if (isActive) return;
              if (onChanged != null) {
                onChanged!(tab);
              } else {
                context.go(route);
              }
            },
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 44,
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isActive
                            ? AppColors.successNormal
                            : AppColors.grey500,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 2,
                  color: isActive
                      ? AppColors.successNormal
                      : AppColors.borderLight,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
