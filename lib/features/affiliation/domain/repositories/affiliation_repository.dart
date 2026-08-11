import 'package:bookshelf_mobile/features/affiliation/domain/entities/affiliation.dart';

abstract interface class AffiliationRepository {
  /// 전체 소속(도서관) 목록 조회
  Future<List<Affiliation>> getAffiliations();
}
