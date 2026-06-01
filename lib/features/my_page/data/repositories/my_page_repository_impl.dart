import 'package:bookshelf_mobile/features/my_page/data/datasources/my_page_remote_data_source.dart';
import 'package:bookshelf_mobile/features/my_page/domain/entities/my_page_info.dart';
import 'package:bookshelf_mobile/features/my_page/domain/repositories/my_page_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyPageRepositoryImpl implements MyPageRepository {
  final MyPageRemoteDataSource _remote;

  const MyPageRepositoryImpl(this._remote);

  @override
  Future<MyPageInfo> getMyPage({required String accessToken}) async {
    final model = await _remote.getMyPage(accessToken: accessToken);
    return model.toEntity();
  }
}

final myPageRepositoryProvider = Provider<MyPageRepository>(
  (ref) => MyPageRepositoryImpl(ref.watch(myPageRemoteDataSourceProvider)),
);
