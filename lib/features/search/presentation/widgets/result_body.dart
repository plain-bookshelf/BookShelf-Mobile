import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/features/search/presentation/providers/search_provider.dart';
import 'package:bookshelf_mobile/features/search/presentation/widgets/book_result_tab.dart';
import 'package:bookshelf_mobile/features/search/presentation/widgets/error_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Result Body ───────────────────────────────────────────────────────────────
class ResultBody extends ConsumerWidget {
  final SearchState searchState;

  const ResultBody({super.key, required this.searchState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (searchState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.successNormal),
      );
    }

    if (searchState.status == SearchStatus.failure) {
      return ErrorState(
        onRetry: () =>
            ref.read(searchProvider.notifier).search(searchState.query),
      );
    }

    return BookResultTab(
      books: searchState.bookResults,
      isLastPage: searchState.isLastPage,
      isLoadingMore: searchState.isLoadingMore,
      onLoadMore: () => ref.read(searchProvider.notifier).loadMore(),
    );
  }
}
