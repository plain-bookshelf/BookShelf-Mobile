import 'package:bookshelf_mobile/features/search/domain/entities/search_result.dart';
import 'package:bookshelf_mobile/features/search/domain/repositories/search_repository.dart';

/// SearchRepository 구현체 (Data Layer)
/// TODO: 실제 API 연동 시 RemoteDataSource 주입
class SearchRepositoryImpl implements SearchRepository {
  const SearchRepositoryImpl();

  @override
  Future<SearchResult> search(String query) {
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getRecentSearches() {
    throw UnimplementedError();
  }

  @override
  Future<void> addRecentSearch(String query) {
    throw UnimplementedError();
  }

  @override
  Future<void> removeRecentSearch(String query) {
    throw UnimplementedError();
  }

  @override
  Future<void> clearRecentSearches() {
    throw UnimplementedError();
  }
}
