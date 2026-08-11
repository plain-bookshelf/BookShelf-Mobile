import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

// ── 댓글 입력창 ───────────────────────────────────────────────────────────────
class CommentInput extends StatelessWidget {
  final TextEditingController controller;
  final bool canSubmit;
  final VoidCallback onSubmit;

  const CommentInput({
    super.key,
    required this.controller,
    required this.canSubmit,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        10,
        16,
        10 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.borderLight)),
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              // 텍스트 입력
              Expanded(
                child: TextField(
                  controller: controller,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => onSubmit(),
                  decoration: const InputDecoration(
                    hintText: '댓글을 입력해주세요',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: AppColors.grey500,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  style: AppTextStyles.body2,
                ),
              ),
              // 전송 버튼
              GestureDetector(
                onTap: canSubmit ? onSubmit : null,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(
                    Icons.send_rounded,
                    size: 22,
                    color: canSubmit
                        ? AppColors.successNormal
                        : AppColors.grey400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
