import 'package:bookshelf_mobile/features/my_page/data/datasources/my_page_remote_data_source.dart';
import 'package:bookshelf_mobile/features/my_page/domain/entities/affiliation_change_result.dart';
import 'package:bookshelf_mobile/features/my_page/domain/entities/lending_info.dart';
import 'package:bookshelf_mobile/features/my_page/domain/entities/liked_book.dart';
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

  @override
  Future<LendingInfo> getLendingInfo({required String accessToken}) async {
    final model = await _remote.getLendingInfo(accessToken: accessToken);
    return model.toEntity();
  }

  @override
  Future<List<LikedBook>> getLikedBooks({required String accessToken}) async {
    final models = await _remote.getLikedBooks(accessToken: accessToken);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<String> uploadProfileImage({
    required String accessToken,
    required String filePath,
    required String fileName,
    required String contentType,
    required int fileSize,
  }) => _remote.uploadProfileImage(
    accessToken: accessToken,
    filePath: filePath,
    fileName: fileName,
    contentType: contentType,
    fileSize: fileSize,
  );

  @override
  Future<void> updateNickname({
    required String accessToken,
    required String newNickname,
  }) => _remote.updateNickname(
    accessToken: accessToken,
    newNickname: newNickname,
  );

  @override
  Future<void> validNickname({
    required String accessToken,
    required String nickname,
  }) => _remote.validNickname(accessToken: accessToken, nickname: nickname);

  @override
  Future<AffiliationChangeResult> updateAffiliation({
    required String accessToken,
    required String newAffiliationName,
  }) async {
    final model = await _remote.updateAffiliation(
      accessToken: accessToken,
      newAffiliationName: newAffiliationName,
    );
    return model.toEntity();
  }
}

final myPageRepositoryProvider = Provider<MyPageRepository>(
  (ref) => MyPageRepositoryImpl(ref.watch(myPageRemoteDataSourceProvider)),
);
