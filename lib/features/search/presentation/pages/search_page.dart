import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/widgets/app_bottom_nav_bar.dart';
import 'package:bookshelf_mobile/features/search/presentation/providers/search_provider.dart';
import 'package:bookshelf_mobile/features/search/presentation/widgets/idle_body.dart';
import 'package:bookshelf_mobile/features/search/presentation/widgets/result_body.dart';
import 'package:bookshelf_mobile/features/search/presentation/widgets/search_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSubmitted(String value) {
    if (value.trim().isEmpty) return;
    _focusNode.unfocus();
    ref.read(searchProvider.notifier).search(value);
  }

  void _onClear() {
    _textController.clear();
    _focusNode.requestFocus();
    ref.read(searchProvider.notifier).clearQuery();
  }

  void _onRecentTap(String query) {
    _textController.text = query;
    _textController.selection = TextSelection.fromPosition(
      TextPosition(offset: query.length),
    );
    ref.read(searchProvider.notifier).search(query);
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: SearchAppBar(
        controller: _textController,
        focusNode: _focusNode,
        hasQuery: searchState.hasQuery,
        onSubmitted: _onSubmitted,
        onClear: _onClear,
      ),
      body: searchState.isIdle
          ? IdleBody(
              recentSearches: searchState.recentSearches,
              onTap: _onRecentTap,
              onRemove: (q) =>
                  ref.read(searchProvider.notifier).removeRecentSearch(q),
              onClearAll: () =>
                  ref.read(searchProvider.notifier).clearRecentSearches(),
            )
          : ResultBody(searchState: searchState),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
    );
  }
}
