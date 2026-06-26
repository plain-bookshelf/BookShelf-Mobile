import 'package:bookshelf_mobile/features/my_page/domain/entities/lending_info.dart';
import 'package:bookshelf_mobile/features/my_page/domain/entities/liked_book.dart';
import 'package:bookshelf_mobile/features/my_page/domain/entities/my_page_info.dart';

abstract interface class MyPageRepository {
  Future<MyPageInfo> getMyPage({required String accessToken});

  Future<LendingInfo> getLendingInfo({required String accessToken});

  Future<List<LikedBook>> getLikedBooks({required String accessToken});

  Future<String> uploadProfileImage({
    required String accessToken,
    required String filePath,
    required String fileName,
    required String contentType,
    required int fileSize,
  });
}
