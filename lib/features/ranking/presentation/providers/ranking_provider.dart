import 'package:bookshelf_mobile/core/network/auth_session_provider.dart';
import 'package:bookshelf_mobile/features/ranking/data/repositories/ranking_repository_impl.dart';
import 'package:bookshelf_mobile/features/ranking/domain/entities/ranking_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── 로딩 상태 ─────────────────────────────────────────────────────────────────
enum RankingStatus { loading, loaded, failure }

// ── RankingState ──────────────────────────────────────────────────────────────
class RankingState {
  final RankingStatus status;
  final List<RankingUser> rankings;

  const RankingState({
    this.status = RankingStatus.loading,
    this.rankings = const [],
  });

  /// 상위 3위 (포디움 표시용)
  List<RankingUser> get topThree =>
      rankings.where((u) => u.isTopThree).toList();

  /// 4위 이하 (리스트 표시용)
  List<RankingUser> get rest =>
      rankings.where((u) => !u.isTopThree).toList();

  RankingState copyWith({
    RankingStatus? status,
    List<RankingUser>? rankings,
  }) =>
      RankingState(
        status: status ?? this.status,
        rankings: rankings ?? this.rankings,
      );
}

// ── RankingNotifier ───────────────────────────────────────────────────────────
class RankingNotifier extends Notifier<RankingState> {
  bool _mounted = true;

  @override
  RankingState build() {
    ref.onDispose(() => _mounted = false);
    Future.microtask(_load);
    return const RankingState(status: RankingStatus.loading);
  }

  Future<void> _load() async {
    try {
      final accessToken = ref.read(authSessionProvider).accessToken ?? '';
      final rankings = await ref
          .read(rankingRepositoryProvider)
          .getRankings(accessToken: accessToken);
      if (!_mounted) return;
      state = state.copyWith(
        status: RankingStatus.loaded,
        rankings: rankings,
      );
    } catch (_) {
      if (!_mounted) return;
      state = state.copyWith(status: RankingStatus.failure);
    }
  }
}

final rankingProvider =
    NotifierProvider<RankingNotifier, RankingState>(RankingNotifier.new);
