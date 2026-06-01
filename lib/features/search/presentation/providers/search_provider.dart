import 'package:bookshelf_mobile/features/book/domain/entities/book.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── 검색 상태 열거 ──────────────────────────────────────────────────────────
enum SearchStatus { idle, loading, success, failure }

// ── SearchState ─────────────────────────────────────────────────────────────
class SearchState {
  final String query;
  final SearchStatus status;
  final List<String> recentSearches;
  final List<Book> bookResults;
  final List<String> libraryResults;

  const SearchState({
    this.query = '',
    this.status = SearchStatus.idle,
    this.recentSearches = const [],
    this.bookResults = const [],
    this.libraryResults = const [],
  });

  bool get hasQuery => query.trim().isNotEmpty;
  bool get isLoading => status == SearchStatus.loading;
  bool get isIdle => status == SearchStatus.idle;

  SearchState copyWith({
    String? query,
    SearchStatus? status,
    List<String>? recentSearches,
    List<Book>? bookResults,
    List<String>? libraryResults,
  }) =>
      SearchState(
        query: query ?? this.query,
        status: status ?? this.status,
        recentSearches: recentSearches ?? this.recentSearches,
        bookResults: bookResults ?? this.bookResults,
        libraryResults: libraryResults ?? this.libraryResults,
      );
}

// ── 더미 데이터 ──────────────────────────────────────────────────────────────
const _dummyBooks = [
  Book(
    id: '1',
    title: '오늘도 소심한 고양이',
    author: '김소심',
    genre: '에세이',
    publisher: '문학동네',
    publishYear: 2022,
    status: BookStatus.available,
    rating: 4.5,
    reviewCount: 128,
  ),
  Book(
    id: '2',
    title: '파친코',
    author: '이민진',
    genre: '소설',
    publisher: '문학사상',
    publishYear: 2017,
    status: BookStatus.rented,
    rating: 4.8,
    reviewCount: 2041,
  ),
  Book(
    id: '3',
    title: '채식주의자',
    author: '한강',
    genre: '소설',
    publisher: '창비',
    publishYear: 2007,
    status: BookStatus.available,
    rating: 4.6,
    reviewCount: 891,
  ),
  Book(
    id: '4',
    title: '아몬드',
    author: '손원평',
    genre: '소설',
    publisher: '창비',
    publishYear: 2017,
    status: BookStatus.reserved,
    rating: 4.4,
    reviewCount: 532,
  ),
  Book(
    id: '5',
    title: '82년생 김지영',
    author: '조남주',
    genre: '소설',
    publisher: '민음사',
    publishYear: 2016,
    status: BookStatus.available,
    rating: 4.3,
    reviewCount: 1204,
  ),
  Book(
    id: '6',
    title: '클루지',
    author: '게리 마커스',
    genre: '인문',
    publisher: '갤리온',
    publishYear: 2008,
    status: BookStatus.available,
    rating: 4.1,
    reviewCount: 76,
  ),
];

const _dummyLibraries = [
  '서울 강남구립 도서관',
  '마포구립 도서관',
  '종로구립 도서관',
];

// ── SearchNotifier ───────────────────────────────────────────────────────────
class SearchNotifier extends Notifier<SearchState> {
  @override
  SearchState build() => const SearchState(
        recentSearches: ['파친코', '한강', '채식주의자'],
      );

  // 검색 실행
  Future<void> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    state = state.copyWith(
      query: trimmed,
      status: SearchStatus.loading,
    );

    // TODO: 실제 API 연동 시 SearchRepository.search(trimmed) 호출
    await Future.delayed(const Duration(milliseconds: 400));

    final books = _dummyBooks
        .where((b) =>
            b.title.contains(trimmed) ||
            b.author.contains(trimmed) ||
            b.genre.contains(trimmed))
        .toList();

    final libraries = _dummyLibraries
        .where((l) => l.contains(trimmed))
        .toList();

    // 최근 검색어 추가 (중복 제거 후 맨 앞에 삽입)
    final updated = [
      trimmed,
      ...state.recentSearches.where((s) => s != trimmed),
    ];

    state = state.copyWith(
      status: SearchStatus.success,
      bookResults: books,
      libraryResults: libraries,
      recentSearches: updated,
    );
  }

  // 쿼리 초기화 → idle 상태로 복귀
  void clearQuery() => state = state.copyWith(
        query: '',
        status: SearchStatus.idle,
        bookResults: [],
        libraryResults: [],
      );

  // 최근 검색어 단건 삭제
  void removeRecentSearch(String query) => state = state.copyWith(
        recentSearches: state.recentSearches.where((s) => s != query).toList(),
      );

  // 최근 검색어 전체 삭제
  void clearRecentSearches() =>
      state = state.copyWith(recentSearches: []);
}

final searchProvider =
    NotifierProvider<SearchNotifier, SearchState>(SearchNotifier.new);
