import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:bookshelf_mobile/features/book/domain/entities/review.dart';
import 'package:bookshelf_mobile/features/book/presentation/providers/book_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ── ReviewsPage ───────────────────────────────────────────────────────────────
class ReviewsPage extends ConsumerStatefulWidget {
  final String bookId;

  const ReviewsPage({super.key, required this.bookId});

  @override
  ConsumerState<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends ConsumerState<ReviewsPage> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    _inputController.removeListener(_onInputChanged);
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onInputChanged() {
    final hasText = _inputController.text.trim().isNotEmpty;
    if (hasText != _canSubmit) setState(() => _canSubmit = hasText);
  }

  void _submit() {
    if (!_canSubmit) return;
    ref
        .read(bookDetailProvider(widget.bookId).notifier)
        .addReview(_inputController.text);
    _inputController.clear();
    // 새 리뷰가 추가된 뒤 목록 하단으로 스크롤
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookDetailProvider(widget.bookId));

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _ReviewsAppBar(onBack: () => context.pop()),
      body: Column(
        children: [
          // 리뷰 목록
          Expanded(
            child: state.reviews.isEmpty
                ? const _EmptyReviews()
                : _ReviewList(
                    reviews: state.reviews,
                    scrollController: _scrollController,
                    onLike: (id) => ref
                        .read(bookDetailProvider(widget.bookId).notifier)
                        .toggleReviewLike(id),
                  ),
          ),
          // 댓글 입력창
          _CommentInput(
            controller: _inputController,
            canSubmit: _canSubmit,
            onSubmit: _submit,
          ),
        ],
      ),
    );
  }
}

// ── AppBar ────────────────────────────────────────────────────────────────────
class _ReviewsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBack;

  const _ReviewsAppBar({required this.onBack});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: GestureDetector(
        onTap: onBack,
        child: const Icon(
          Icons.arrow_back_ios_new,
          size: 18,
          color: AppColors.grey600,
        ),
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppColors.borderLight),
      ),
    );
  }
}

// ── 리뷰 목록 ─────────────────────────────────────────────────────────────────
class _ReviewList extends StatelessWidget {
  final List<Review> reviews;
  final ScrollController scrollController;
  final ValueChanged<String> onLike;

  const _ReviewList({
    required this.reviews,
    required this.scrollController,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: reviews.length,
      separatorBuilder: (_, _) =>
          const Divider(height: 1, color: AppColors.borderLight),
      itemBuilder: (context, index) {
        final review = reviews[index];
        return _ReviewItem(
          review: review,
          onLike: () => onLike(review.id),
        );
      },
    );
  }
}

// ── 리뷰 아이템 ───────────────────────────────────────────────────────────────
class _ReviewItem extends StatelessWidget {
  final Review review;
  final VoidCallback onLike;

  const _ReviewItem({required this.review, required this.onLike});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 리뷰 내용 (이름 + 본문)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(review.reviewerName, style: AppTextStyles.body2SemiBold),
                const SizedBox(height: 4),
                Text(review.content, style: AppTextStyles.caption1),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // 좋아요 버튼
          GestureDetector(
            onTap: onLike,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                review.isLiked ? Icons.favorite : Icons.favorite_border,
                size: 20,
                color: review.isLiked
                    ? AppColors.successNormal
                    : AppColors.grey400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 빈 상태 ───────────────────────────────────────────────────────────────────
class _EmptyReviews extends StatelessWidget {
  const _EmptyReviews();

  @override
  Widget build(BuildContext context) => const Center(
        child: Text('아직 리뷰가 없습니다.', style: AppTextStyles.caption1),
      );
}

// ── 댓글 입력창 ───────────────────────────────────────────────────────────────
class _CommentInput extends StatelessWidget {
  final TextEditingController controller;
  final bool canSubmit;
  final VoidCallback onSubmit;

  const _CommentInput({
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
