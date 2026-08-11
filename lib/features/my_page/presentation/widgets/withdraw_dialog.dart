import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ── 회원탈퇴 전용 다이얼로그 ──────────────────────────────────────────────────
// "동의합니다"를 직접 입력해야 탈퇴 버튼이 활성화됩니다.
class WithdrawDialog extends StatefulWidget {
  final Future<void> Function() onConfirm;

  const WithdrawDialog({super.key, required this.onConfirm});

  @override
  State<WithdrawDialog> createState() => _WithdrawDialogState();
}

class _WithdrawDialogState extends State<WithdrawDialog> {
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
            style: const TextStyle(fontSize: 15, color: AppColors.textDark),
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
