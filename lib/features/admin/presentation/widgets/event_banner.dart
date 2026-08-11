import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

// ── 이벤트 배너 버튼 ───────────────────────────────────────────────────────────
class EventBanner extends StatelessWidget {
  const EventBanner({super.key});

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
