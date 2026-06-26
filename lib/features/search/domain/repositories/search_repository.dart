import 'package:bookshelf_mobile/features/search/domain/entities/search_result.dart';

abstract interface class SearchRepository {
  Future<SearchResult> search({
    required String accessToken,
    required String keyword,
    int page = 0,
    int size = 12,
  });
}
