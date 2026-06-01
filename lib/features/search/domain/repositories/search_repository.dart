import 'package:bookshelf_mobile/features/search/domain/entities/search_result.dart';

/// 검색 Repository 인터페이스 (Domain Layer)
abstract interface class SearchRepository {
  /// 쿼리로 도서·도서관 통합 검색
  Future<SearchResult> search(String query);

  /// 최근 검색어 목록 조회
  Future<List<String>> getRecentSearches();

  /// 최근 검색어 추가
  Future<void> addRecentSearch(String query);

  /// 최근 검색어 단건 삭제
  Future<void> removeRecentSearch(String query);

  /// 최근 검색어 전체 삭제
  Future<void> clearRecentSearches();
}
