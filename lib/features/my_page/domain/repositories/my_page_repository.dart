import 'package:bookshelf_mobile/features/my_page/domain/entities/affiliation_change_result.dart';
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

  Future<void> updateNickname({
    required String accessToken,
    required String newNickname,
  });

  /// 닉네임 중복 확인. 사용 가능하면 정상 반환, 이미 사용중이면 예외를 던짐
  Future<void> validNickname({
    required String accessToken,
    required String nickname,
  });

  Future<AffiliationChangeResult> updateAffiliation({
    required String accessToken,
    required String newAffiliationName,
  });
}
