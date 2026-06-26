import 'package:bookshelf_mobile/features/search/data/datasources/search_remote_data_source.dart';
import 'package:bookshelf_mobile/features/search/domain/entities/search_book.dart';
import 'package:bookshelf_mobile/features/search/domain/entities/search_result.dart';
import 'package:bookshelf_mobile/features/search/domain/repositories/search_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource _remote;

  const SearchRepositoryImpl(this._remote);

  @override
  Future<SearchResult> search({
    required String accessToken,
    required String keyword,
    int page = 0,
    int size = 12,
  }) async {
    final model = await _remote.search(
      accessToken: accessToken,
      keyword: keyword,
      page: page,
      size: size,
    );
    return SearchResult(
      books: model.content
          .map((e) => SearchBook(
                id: e.bookAffiliationId.toString(),
                imageUrl: e.bookImage,
              ))
          .toList(),
      isLastPage: model.isLastPage,
    );
  }
}

final searchRepositoryProvider = Provider<SearchRepository>(
  (ref) => SearchRepositoryImpl(ref.watch(searchRemoteDataSourceProvider)),
);
