import 'package:bookshelf_mobile/core/network/auth_session_provider.dart';
import 'package:bookshelf_mobile/features/home/data/repositories/home_repository_impl.dart';
import 'package:bookshelf_mobile/features/home/domain/entities/main_book.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// POPULAR 도서 목록
final popularBooksProvider = FutureProvider<List<MainBook>>((ref) async {
  final accessToken = ref.watch(authSessionProvider).accessToken;
  debugPrint('[home] accessToken = $accessToken');
  if (accessToken == null || accessToken.isEmpty) return [];
  return ref.watch(homeRepositoryProvider).getMainBooks(
        accessToken: accessToken,
        bookFindType: BookFindType.POPULAR,
      );
});

/// RECENT 도서 목록
final recentBooksProvider = FutureProvider<List<MainBook>>((ref) async {
  final accessToken = ref.watch(authSessionProvider).accessToken;
  if (accessToken == null || accessToken.isEmpty) return [];
  return ref.watch(homeRepositoryProvider).getMainBooks(
        accessToken: accessToken,
        bookFindType: BookFindType.RECENT,
      );
});
