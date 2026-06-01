import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/core/widgets/app_bottom_nav_bar.dart';
import 'package:bookshelf_mobile/core/widgets/app_main_app_bar.dart';
import 'package:bookshelf_mobile/core/widgets/home_ai_tab_bar.dart';
import 'package:bookshelf_mobile/features/ai/domain/entities/ai_message.dart';
import 'package:bookshelf_mobile/features/ai/presentation/providers/ai_provider.dart';
import 'package:bookshelf_mobile/features/book/domain/entities/book.dart';
import 'package:bookshelf_mobile/features/home/presentation/widgets/book_recommend_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
                    AiStatus.idle => const _IdleBody(),
                    AiStatus.chatting => _ChatBody(
                        state: state,
                        scrollController: _scrollController,
                      ),
                    AiStatus.recommended => _RecommendationBody(
                        state: state,
                        onReset: ref.read(aiProvider.notifier).reset,
                      ),
                  },
                ),
                if (state.status != AiStatus.recommended)
                  _ChatInput(
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

// ── 빈 화면 ───────────────────────────────────────────────────────────────────
class _IdleBody extends StatelessWidget {
  const _IdleBody();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome,
                  size: 30, color: AppColors.successNormal),
            ),
            const SizedBox(height: 16),
            const Text(
              '마루AI와의 대화를 시작해보세요',
              style: TextStyle(fontSize: 15, color: AppColors.grey500),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 채팅 뷰 ───────────────────────────────────────────────────────────────────
class _ChatBody extends StatelessWidget {
  final AiState state;
  final ScrollController scrollController;

  const _ChatBody({required this.state, required this.scrollController});

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
            return const _TypingIndicator();
          }
          return _ChatBubble(message: state.messages[index]);
        },
      ),
    );
  }
}

// ── 채팅 버블 ─────────────────────────────────────────────────────────────────
class _ChatBubble extends StatelessWidget {
  final AiMessage message;

  const _ChatBubble({required this.message});

  bool get _isAi => message.role == AiMessageRole.ai;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          _isAi ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isAi) ...[
          const _AiAvatar(),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                      )
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

// ── AI 아바타 ─────────────────────────────────────────────────────────────────
class _AiAvatar extends StatelessWidget {
  const _AiAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: AppColors.successNormal,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.auto_awesome, size: 16, color: AppColors.white),
    );
  }
}

// ── 타이핑 인디케이터 ─────────────────────────────────────────────────────────
class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _AiAvatar(),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 4,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              3,
              (i) => Padding(
                padding: EdgeInsets.only(left: i == 0 ? 0 : 4),
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppColors.grey400,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── 추천 결과 뷰 ──────────────────────────────────────────────────────────────
class _RecommendationBody extends StatelessWidget {
  final AiState state;
  final VoidCallback onReset;

  const _RecommendationBody({
    required this.state,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.white,
      child: CustomScrollView(
        slivers: [
          // 헤더
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${state.userName}님을 위한 추천 책',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.hasBooks
                        ? '${state.userName}님을 위해 이런 책을 준비했어요'
                        : '읽고 싶은 책을 찾지 못했어요',
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.grey600),
                  ),
                ],
              ),
            ),
          ),

          // 책 그리드 or 빈 상태
          if (state.hasBooks)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              sliver: SliverGrid.count(
                crossAxisCount: 3,
                childAspectRatio: 0.62,
                mainAxisSpacing: 16,
                crossAxisSpacing: 12,
                children: state.recommendedBooks
                    .map((book) => _BookThumbnail(book: book))
                    .toList(),
              ),
            )
          else
            const SliverFillRemaining(
              child: Center(
                child: Text(
                  '읽고 싶은 책 중에는\n책을 찾지 못했어요',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: AppColors.grey500),
                ),
              ),
            ),

          // 다시 물어보기 버튼
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
              child: OutlinedButton(
                onPressed: onReset,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.successNormal,
                  side: const BorderSide(color: AppColors.successNormal),
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '다시 물어보기',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 책 썸네일 ─────────────────────────────────────────────────────────────────
class _BookThumbnail extends StatelessWidget {
  final Book book;

  const _BookThumbnail({required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.bookDetailOf(book.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            book.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),
          Text(
            book.author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: AppColors.grey500),
          ),
        ],
      ),
    );
  }
}

// ── 채팅 입력창 ───────────────────────────────────────────────────────────────
class _ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final VoidCallback onSend;

  const _ChatInput({
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
            border: Border(
                top: BorderSide(color: AppColors.borderLight)),
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
                        fontSize: 14, color: AppColors.textDark),
                    decoration: const InputDecoration(
                      hintText: '질문할 내용을 입력하세요...',
                      hintStyle: TextStyle(
                          fontSize: 14, color: AppColors.grey400),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
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
                  child: const Icon(Icons.send_rounded,
                      size: 18, color: AppColors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
