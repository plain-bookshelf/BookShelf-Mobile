import 'package:bookshelf_mobile/features/ranking/domain/entities/ranking_user.dart';
import 'package:bookshelf_mobile/features/ranking/presentation/widgets/podium_item.dart';
import 'package:flutter/material.dart';

// ── 배지 색상 상수 ────────────────────────────────────────────────────────────
const _goldColor = Color(0xFFFFB800);
const _silverColor = Color(0xFFB0B8C1);
const _bronzeColor = Color(0xFFCD7F32);

// ── 포디움 (1~3위) ────────────────────────────────────────────────────────────
class Podium extends StatelessWidget {
  final List<RankingUser> topThree;

  const Podium({super.key, required this.topThree});

  // 순서: 2위(왼쪽) - 1위(가운데) - 3위(오른쪽)
  RankingUser? _userAt(int rank) =>
      topThree.where((u) => u.rank == rank).firstOrNull;

  @override
  Widget build(BuildContext context) {
    final first = _userAt(1);
    final second = _userAt(2);
    final third = _userAt(3);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2위
          Expanded(
            child: PodiumItem(
              user: second,
              rank: 2,
              avatarRadius: 40,
              topPadding: 28,
              badgeColor: _silverColor,
            ),
          ),
          // 1위 (가장 높고 큼)
          Expanded(
            child: PodiumItem(
              user: first,
              rank: 1,
              avatarRadius: 48,
              topPadding: 0,
              badgeColor: _goldColor,
              showCrown: true,
            ),
          ),
          // 3위
          Expanded(
            child: PodiumItem(
              user: third,
              rank: 3,
              avatarRadius: 34,
              topPadding: 44,
              badgeColor: _bronzeColor,
            ),
          ),
        ],
      ),
    );
  }
}
