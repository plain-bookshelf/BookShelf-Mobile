import 'package:bookshelf_mobile/features/ranking/domain/entities/ranking_user.dart';

/// GET /ranking 응답의 단일 랭킹 모델
class RankingUserModel {
  final int memberId;
  final int rank;
  final String nickName;
  final int oneMonthStatistics;
  final String? profileImage;
  final String? affiliationName;

  const RankingUserModel({
    required this.memberId,
    required this.rank,
    required this.nickName,
    required this.oneMonthStatistics,
    this.profileImage,
    this.affiliationName,
  });

  factory RankingUserModel.fromJson(Map<String, dynamic> json) =>
      RankingUserModel(
        memberId: json['member_id'] as int? ?? 0,
        rank: json['rank'] as int? ?? 0,
        nickName: json['nick_name'] as String? ?? '',
        oneMonthStatistics: json['one_month_statistics'] as int? ?? 0,
        profileImage: (json['profile_image'] as String?)?.isNotEmpty == true
            ? json['profile_image'] as String
            : null,
        affiliationName: json['affiliation_name'] as String?,
      );

  RankingUser toEntity() => RankingUser(
        rank: rank,
        userName: nickName,
        bookCount: oneMonthStatistics,
        institution: affiliationName,
        avatarUrl: profileImage,
      );
}
