import 'package:bookshelf_mobile/features/ranking/domain/entities/ranking_user.dart';

/// 랭킹 Repository 인터페이스 (Domain Layer)
abstract interface class RankingRepository {
  /// 전체 랭킹 목록 조회
  Future<List<RankingUser>> getRankings();
}
