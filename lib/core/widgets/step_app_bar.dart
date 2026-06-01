import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 회원가입 / 비밀번호 찾기 등의 단계형 AppBar
///
/// [showStep] : 우측에 "현재단계 / 전체단계" 텍스트 표시 여부
/// [currentStep] : 현재 단계 번호
/// [totalSteps] : 전체 단계 수
class StepAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showStep;
  final int? currentStep;
  final int totalSteps;

  const StepAppBar({
    super.key,
    this.showStep = false,
    this.currentStep,
    this.totalSteps = 3,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => context.pop(),
        child: const Icon(
          Icons.arrow_back_ios_new,
          size: 18,
          color: Color(0xFF7E7E7E),
        ),
      ),
      actions: [
        if (showStep && currentStep != null)
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text(
              '$currentStep / $totalSteps',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
