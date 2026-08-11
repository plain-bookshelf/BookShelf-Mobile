import 'package:bookshelf_mobile/features/affiliation/data/repositories/affiliation_repository_impl.dart';
import 'package:bookshelf_mobile/features/affiliation/domain/entities/affiliation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 전체 소속(도서관) 목록 (GET /affiliation/view)
/// 정적 참조 데이터이므로 autoDispose 없이 앱 세션 동안 캐시해 재요청을 피함
final affiliationsProvider = FutureProvider<List<Affiliation>>(
  (ref) => ref.read(affiliationRepositoryProvider).getAffiliations(),
);
