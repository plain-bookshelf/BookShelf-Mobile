import 'package:bookshelf_mobile/features/ranking/data/datasources/ranking_remote_data_source.dart';
import 'package:bookshelf_mobile/features/ranking/domain/entities/ranking_user.dart';
import 'package:bookshelf_mobile/features/ranking/domain/repositories/ranking_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// RankingRepository 구현체 (Data Layer)
class RankingRepositoryImpl implements RankingRepository {
  final RankingRemoteDataSource _remote;

  const RankingRepositoryImpl(this._remote);

  @override
  Future<List<RankingUser>> getRankings({required String accessToken}) async {
    final models = await _remote.getRankings(accessToken: accessToken);
    return models.map((m) => m.toEntity()).toList();
  }
}

final rankingRepositoryProvider = Provider<RankingRepository>(
  (ref) => RankingRepositoryImpl(ref.watch(rankingRemoteDataSourceProvider)),
);
