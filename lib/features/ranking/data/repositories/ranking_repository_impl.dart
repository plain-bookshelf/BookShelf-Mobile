import 'package:bookshelf_mobile/features/ranking/domain/entities/ranking_user.dart';
import 'package:bookshelf_mobile/features/ranking/domain/repositories/ranking_repository.dart';

/// RankingRepository 구현체 (Data Layer)
/// TODO: 실제 API 연동 시 RemoteDataSource 주입
class RankingRepositoryImpl implements RankingRepository {
  const RankingRepositoryImpl();

  @override
  Future<List<RankingUser>> getRankings() {
    throw UnimplementedError();
  }
}
