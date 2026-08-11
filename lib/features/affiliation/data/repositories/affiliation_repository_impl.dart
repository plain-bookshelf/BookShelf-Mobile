import 'package:bookshelf_mobile/features/affiliation/data/datasources/affiliation_remote_data_source.dart';
import 'package:bookshelf_mobile/features/affiliation/domain/entities/affiliation.dart';
import 'package:bookshelf_mobile/features/affiliation/domain/repositories/affiliation_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AffiliationRepositoryImpl implements AffiliationRepository {
  final AffiliationRemoteDataSource _remote;

  const AffiliationRepositoryImpl(this._remote);

  @override
  Future<List<Affiliation>> getAffiliations() async {
    final models = await _remote.getAffiliations();
    return models.map((m) => m.toEntity()).toList();
  }
}

final affiliationRepositoryProvider = Provider<AffiliationRepository>(
  (ref) =>
      AffiliationRepositoryImpl(ref.watch(affiliationRemoteDataSourceProvider)),
);
