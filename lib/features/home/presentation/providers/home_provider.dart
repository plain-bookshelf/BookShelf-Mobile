import 'package:bookshelf_mobile/core/network/api_error.dart';
import 'package:bookshelf_mobile/core/network/auth_session_provider.dart';
import 'package:bookshelf_mobile/features/home/data/repositories/home_repository_impl.dart';
import 'package:bookshelf_mobile/features/home/domain/entities/main_book.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 세션에서 accessToken을 꺼낸다. 없으면 [MissingSessionException].
///
/// 빈 리스트를 반환하면 화면에 "도서가 없습니다."가 떠서
/// 인증 문제가 데이터 없음으로 보이므로 예외로 구분한다.
String _requireAccessToken(Ref ref) {
  final accessToken = ref.watch(authSessionProvider).accessToken;
  if (accessToken == null || accessToken.isEmpty) {
    throw const MissingSessionException();
  }
  return accessToken;
}

/// POPULAR 도서 목록
final popularBooksProvider = FutureProvider<List<MainBook>>((ref) async {
  return ref.watch(homeRepositoryProvider).getMainBooks(
        accessToken: _requireAccessToken(ref),
        bookFindType: BookFindType.POPULAR,
      );
});

/// RECENT 도서 목록
final recentBooksProvider = FutureProvider<List<MainBook>>((ref) async {
  return ref.watch(homeRepositoryProvider).getMainBooks(
        accessToken: _requireAccessToken(ref),
        bookFindType: BookFindType.RECENT,
      );
});
