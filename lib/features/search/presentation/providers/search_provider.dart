import 'package:bookshelf_mobile/core/network/api_error.dart';
import 'package:bookshelf_mobile/core/network/auth_session_provider.dart';
import 'package:bookshelf_mobile/features/search/data/repositories/search_repository_impl.dart';
import 'package:bookshelf_mobile/features/search/domain/entities/search_book.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SearchStatus { idle, loading, success, failure }

class SearchState {
  final String query;
  final SearchStatus status;
  final List<String> recentSearches;
  final List<SearchBook> bookResults;
  final int currentPage;
  final bool isLastPage;
  final bool isLoadingMore;
  final String? errorMessage;

  const SearchState({
    this.query = '',
    this.status = SearchStatus.idle,
    this.recentSearches = const [],
    this.bookResults = const [],
    this.currentPage = 0,
    this.isLastPage = true,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  bool get hasQuery => query.trim().isNotEmpty;
  bool get isLoading => status == SearchStatus.loading;
  bool get isIdle => status == SearchStatus.idle;

  SearchState copyWith({
    String? query,
    SearchStatus? status,
    List<String>? recentSearches,
    List<SearchBook>? bookResults,
    int? currentPage,
    bool? isLastPage,
    bool? isLoadingMore,
    String? errorMessage,
  }) =>
      SearchState(
        query: query ?? this.query,
        status: status ?? this.status,
        recentSearches: recentSearches ?? this.recentSearches,
        bookResults: bookResults ?? this.bookResults,
        currentPage: currentPage ?? this.currentPage,
        isLastPage: isLastPage ?? this.isLastPage,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        errorMessage: errorMessage,
      );
}

class SearchNotifier extends Notifier<SearchState> {
  @override
  SearchState build() => const SearchState();

  Future<void> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    state = state.copyWith(
      query: trimmed,
      status: SearchStatus.loading,
      bookResults: [],
      currentPage: 0,
      isLastPage: true,
      errorMessage: null,
    );

    try {
      final accessToken =
          ref.read(authSessionProvider).accessToken ?? '';
      final result = await ref.read(searchRepositoryProvider).search(
            accessToken: accessToken,
            keyword: trimmed,
            page: 0,
          );

      final updated = [
        trimmed,
        ...state.recentSearches.where((s) => s != trimmed),
      ];

      state = state.copyWith(
        status: SearchStatus.success,
        bookResults: result.books,
        currentPage: 0,
        isLastPage: result.isLastPage,
        recentSearches: updated,
      );
    } catch (e) {
      state = state.copyWith(
        status: SearchStatus.failure,
        errorMessage: parseApiErrorMessage(e, fallback: '검색에 실패했습니다.'),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLastPage || state.isLoadingMore || state.isLoading) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.currentPage + 1;
      final accessToken =
          ref.read(authSessionProvider).accessToken ?? '';
      final result = await ref.read(searchRepositoryProvider).search(
            accessToken: accessToken,
            keyword: state.query,
            page: nextPage,
          );

      state = state.copyWith(
        bookResults: [...state.bookResults, ...result.books],
        currentPage: nextPage,
        isLastPage: result.isLastPage,
        isLoadingMore: false,
      );
    } catch (_) {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  void clearQuery() => state = state.copyWith(
        query: '',
        status: SearchStatus.idle,
        bookResults: [],
        currentPage: 0,
        isLastPage: true,
        errorMessage: null,
      );

  void removeRecentSearch(String query) => state = state.copyWith(
        recentSearches: state.recentSearches.where((s) => s != query).toList(),
      );

  void clearRecentSearches() => state = state.copyWith(recentSearches: []);
}

final searchProvider =
    NotifierProvider<SearchNotifier, SearchState>(SearchNotifier.new);
