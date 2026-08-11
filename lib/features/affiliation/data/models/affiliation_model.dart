import 'package:bookshelf_mobile/features/affiliation/domain/entities/affiliation.dart';

/// GET /affiliation/view 응답의 개별 소속 모델
class AffiliationModel {
  final int id;
  final String affiliationName;

  const AffiliationModel({required this.id, required this.affiliationName});

  factory AffiliationModel.fromJson(Map<String, dynamic> json) =>
      AffiliationModel(
        id: json['id'] as int? ?? 0,
        affiliationName: json['affiliation_name'] as String? ?? '',
      );

  Affiliation toEntity() => Affiliation(id: id, name: affiliationName);
}
