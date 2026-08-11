import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/widgets/app_bottom_nav_bar.dart';
import 'package:bookshelf_mobile/core/widgets/app_main_app_bar.dart';
import 'package:bookshelf_mobile/core/widgets/home_ai_tab_bar.dart';
import 'package:bookshelf_mobile/features/ai/presentation/providers/ai_provider.dart';
import 'package:bookshelf_mobile/features/ai/presentation/widgets/chat_body.dart';
import 'package:bookshelf_mobile/features/ai/presentation/widgets/chat_input.dart';
import 'package:bookshelf_mobile/features/ai/presentation/widgets/idle_body.dart';
import 'package:bookshelf_mobile/features/ai/presentation/widgets/recommendation_body.dart';
import 'package:bookshelf_mobile/features/home/presentation/widgets/book_recommend_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AiPage extends ConsumerStatefulWidget {
  const AiPage({super.key});

  @override
  ConsumerState<AiPage> createState() => _AiPageState();
}

class _AiPageState extends ConsumerState<AiPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  // 상단 탭: 도서 추천 / 마루AI (라우팅 대신 로컬 전환)
  HomeAiTab _tab = HomeAiTab.home;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text;
    _controller.clear();
    ref.read(aiProvider.notifier).sendMessage(text);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiProvider);

    // 새 메시지 추가 시 스크롤 최하단
    ref.listen<AiState>(aiProvider, (prev, next) {
      if (next.messages.length != (prev?.messages.length ?? 0)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.grey100,
      appBar: AppMainAppBar(
        bottom: HomeAiTabBar(
          currentTab: _tab,
          onChanged: (tab) => setState(() => _tab = tab),
        ),
      ),
      body: _tab == HomeAiTab.home
          // ── 도서 추천 탭 (기존 홈 내용) ──
          ? const BookRecommendView()
          // ── 마루AI 탭 (채팅) ──
          : Column(
              children: [
                Expanded(
                  child: switch (state.status) {
                    AiStatus.idle => const IdleBody(),
                    AiStatus.chatting => ChatBody(
                      state: state,
                      scrollController: _scrollController,
                    ),
                    AiStatus.recommended => RecommendationBody(
                      state: state,
                      onReset: ref.read(aiProvider.notifier).reset,
                    ),
                  },
                ),
                if (state.status != AiStatus.recommended)
                  ChatInput(
                    controller: _controller,
                    enabled: !state.isTyping,
                    onSend: _sendMessage,
                  ),
              ],
            ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
    );
  }
}
