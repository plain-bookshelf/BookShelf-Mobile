import 'package:bookshelf_mobile/features/my_page/domain/entities/affiliation_change_result.dart';

/// PATCH /api/member/affiliation-change 응답 data 필드 모델
class AffiliationChangeModel {
  final String affiliationName;
  final String accessToken;
  final String? refreshToken;

  const AffiliationChangeModel({
    required this.affiliationName,
    required this.accessToken,
    this.refreshToken,
  });

  factory AffiliationChangeModel.fromJson(
    Map<String, dynamic> json, {
    String? refreshToken,
  }) => AffiliationChangeModel(
    affiliationName: json['affiliation_name'] as String? ?? '',
    accessToken: json['access_token'] as String? ?? '',
    refreshToken: refreshToken,
  );

  AffiliationChangeResult toEntity() => AffiliationChangeResult(
    affiliationName: affiliationName,
    accessToken: accessToken,
    refreshToken: refreshToken,
  );
}
