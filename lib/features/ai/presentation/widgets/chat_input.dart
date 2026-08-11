import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

// ── 채팅 입력창 ───────────────────────────────────────────────────────────────
class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final VoidCallback onSend;

  const ChatInput({
    super.key,
    required this.controller,
    required this.enabled,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final canSend = enabled && value.text.trim().isNotEmpty;
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(top: BorderSide(color: AppColors.borderLight)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: TextField(
                    controller: controller,
                    enabled: enabled,
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: canSend ? (_) => onSend() : null,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textDark,
                    ),
                    decoration: const InputDecoration(
                      hintText: '질문할 내용을 입력하세요...',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: AppColors.grey400,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: canSend ? onSend : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: canSend
                        ? AppColors.successNormal
                        : AppColors.grey300,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.send_rounded,
                    size: 18,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
