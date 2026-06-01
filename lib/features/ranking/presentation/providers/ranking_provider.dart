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

// ── 더미 데이터 ───────────────────────────────────────────────────────────────
final _dummyRankings = [
  const RankingUser(rank: 1, userName: '복어',  bookCount: 120),
  const RankingUser(rank: 2, userName: '개복치', bookCount: 100),
  const RankingUser(rank: 3, userName: '기린',  bookCount: 60),
  const RankingUser(
    rank: 4,
    userName: '공룡',
    institution: '대덕소프트웨어마이스터고',
    bookCount: 79,
  ),
  const RankingUser(
    rank: 5,
    userName: '공룡',
    institution: '대덕소프트웨어마이스터고',
    bookCount: 78,
  ),
  const RankingUser(
    rank: 6,
    userName: '공룡',
    institution: '대덕소프트웨어마이스터고',
    bookCount: 77,
  ),
];

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
    // TODO: RankingRepository.getRankings() 연동
    await Future.delayed(const Duration(milliseconds: 400));
    if (!_mounted) return;
    state = state.copyWith(
      status: RankingStatus.loaded,
      rankings: _dummyRankings,
    );
  }
}

final rankingProvider =
    NotifierProvider<RankingNotifier, RankingState>(RankingNotifier.new);
