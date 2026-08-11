import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/features/ai/presentation/providers/ai_provider.dart';
import 'package:bookshelf_mobile/features/ai/presentation/widgets/chat_bubble.dart';
import 'package:bookshelf_mobile/features/ai/presentation/widgets/typing_indicator.dart';
import 'package:flutter/material.dart';

// ── 채팅 뷰 ───────────────────────────────────────────────────────────────────
class ChatBody extends StatelessWidget {
  final AiState state;
  final ScrollController scrollController;

  const ChatBody({
    super.key,
    required this.state,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final itemCount = state.messages.length + (state.isTyping ? 1 : 0);

    return ColoredBox(
      color: AppColors.white,
      child: ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        itemCount: itemCount,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == state.messages.length) {
            return const TypingIndicator();
          }
          return ChatBubble(message: state.messages[index]);
        },
      ),
    );
  }
}
