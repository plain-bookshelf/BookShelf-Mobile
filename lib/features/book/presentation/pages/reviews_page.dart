import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/features/book/presentation/providers/book_detail_provider.dart';
import 'package:bookshelf_mobile/features/book/presentation/widgets/comment_input.dart';
import 'package:bookshelf_mobile/features/book/presentation/widgets/empty_reviews.dart';
import 'package:bookshelf_mobile/features/book/presentation/widgets/review_list.dart';
import 'package:bookshelf_mobile/features/book/presentation/widgets/reviews_app_bar.dart';
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

  Future<void> _submit() async {
    if (!_canSubmit) return;
    final text = _inputController.text;
    _inputController.clear();
    await ref.read(bookDetailProvider(widget.bookId).notifier).addReview(text);
    // 댓글 등록 후 목록 하단으로 스크롤
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
      appBar: ReviewsAppBar(onBack: () => context.pop()),
      body: Column(
        children: [
          // 리뷰 목록
          Expanded(
            child: state.reviews.isEmpty
                ? const EmptyReviews()
                : ReviewList(
                    reviews: state.reviews,
                    scrollController: _scrollController,
                    onLike: (id) => ref
                        .read(bookDetailProvider(widget.bookId).notifier)
                        .toggleReviewLike(id),
                  ),
          ),
          // 댓글 입력창
          CommentInput(
            controller: _inputController,
            canSubmit: _canSubmit,
            onSubmit: _submit,
          ),
        ],
      ),
    );
  }
}
