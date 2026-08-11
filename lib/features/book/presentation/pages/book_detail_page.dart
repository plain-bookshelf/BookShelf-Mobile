import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:bookshelf_mobile/core/widgets/error_dialog.dart';
import 'package:bookshelf_mobile/features/book/presentation/providers/book_detail_provider.dart';
import 'package:bookshelf_mobile/features/book/presentation/widgets/action_bar.dart';
import 'package:bookshelf_mobile/features/book/presentation/widgets/detail_app_bar.dart';
import 'package:bookshelf_mobile/features/book/presentation/widgets/failure_body.dart';
import 'package:bookshelf_mobile/features/book/presentation/widgets/loaded_body.dart';
import 'package:bookshelf_mobile/features/book/presentation/widgets/loading_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ── BookDetailPage ────────────────────────────────────────────────────────────
class BookDetailPage extends ConsumerStatefulWidget {
  final String bookId;

  const BookDetailPage({super.key, required this.bookId});

  @override
  ConsumerState<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends ConsumerState<BookDetailPage> {
  // 토스트/에러 메시지 변화 감지 후 표시 (성공 → 스낵바, 실패 → 에러 모달)
  void _onStateChanged(BookDetailState? prev, BookDetailState next) {
    final error = next.errorMessage;
    if (error != null && prev?.errorMessage != error) {
      // 표시 후 상태에서 에러 초기화
      ref.read(bookDetailProvider(widget.bookId).notifier).clearError();
      showErrorDialog(context, message: error);
    }

    final message = next.toastMessage;
    if (message == null) return;
    if (prev?.toastMessage == message) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.caption1.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.textDark,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: '닫기',
          textColor: AppColors.grey400,
          // SnackBarAction 은 기본적으로 누르면 스낵바를 닫는다.
          // 토스트 상태는 표시 직후(아래) 이미 초기화되므로 별도 작업 불필요.
          onPressed: () {},
        ),
      ),
    );
    // 표시 후 상태에서 토스트 초기화
    ref.read(bookDetailProvider(widget.bookId).notifier).clearToast();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<BookDetailState>(
      bookDetailProvider(widget.bookId),
      _onStateChanged,
    );

    final state = ref.watch(bookDetailProvider(widget.bookId));
    final notifier = ref.read(bookDetailProvider(widget.bookId).notifier);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: DetailAppBar(
        title: state.book?.title ?? '',
        isWishlisted: state.isWishlisted,
        onBack: () => context.pop(),
        onToggleWishlist: notifier.toggleWishlist,
      ),
      body: switch (state.status) {
        BookDetailStatus.loading => const LoadingBody(),
        BookDetailStatus.failure => const FailureBody(),
        BookDetailStatus.loaded => LoadedBody(
          state: state,
          bookId: widget.bookId,
          onToggleDescription: notifier.toggleDescription,
          onToggleReviewLike: notifier.toggleReviewLike,
        ),
      },
      bottomNavigationBar: state.book != null
          ? ActionBar(
              book: state.book!,
              onRental: notifier.requestRental,
              onReservation: notifier.requestReservation,
            )
          : null,
    );
  }
}
