import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/features/ai/domain/entities/ai_message.dart';
import 'package:bookshelf_mobile/features/ai/presentation/widgets/ai_avatar.dart';
import 'package:flutter/material.dart';

// ── 채팅 버블 ─────────────────────────────────────────────────────────────────
class ChatBubble extends StatelessWidget {
  final AiMessage message;

  const ChatBubble({super.key, required this.message});

  bool get _isAi => message.role == AiMessageRole.ai;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: _isAi
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isAi) ...[const AiAvatar(), const SizedBox(width: 8)],
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _isAi ? AppColors.white : AppColors.successNormal,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(_isAi ? 4 : 16),
                topRight: Radius.circular(_isAi ? 16 : 4),
                bottomLeft: const Radius.circular(16),
                bottomRight: const Radius.circular(16),
              ),
              boxShadow: _isAi
                  ? const [
                      BoxShadow(
                        color: Color(0x0F000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              message.content,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: _isAi ? AppColors.textDark : AppColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
