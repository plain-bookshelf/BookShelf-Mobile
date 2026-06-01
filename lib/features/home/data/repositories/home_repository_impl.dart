import 'package:bookshelf_mobile/features/home/data/datasources/home_remote_data_source.dart';
import 'package:bookshelf_mobile/features/home/domain/entities/main_book.dart';
import 'package:bookshelf_mobile/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remote;

  const HomeRepositoryImpl(this._remote);

  @override
  Future<List<MainBook>> getMainBooks({
    required String accessToken,
    required BookFindType bookFindType,
  }) async {
    final model = await _remote.getMainBooks(
      accessToken: accessToken,
      bookFindType: bookFindType,
    );
    return model.toEntityList();
  }
}

final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => HomeRepositoryImpl(ref.watch(homeRemoteDataSourceProvider)),
);
