import 'package:bookshelf_mobile/features/admin/domain/entities/rental_request.dart';

/// RentalRequest 도메인 엔티티의 데이터 모델
class RentalRequestModel extends RentalRequest {
  const RentalRequestModel({
    required super.id,
    required super.studentId,
    required super.userName,
    required super.bookTitle,
    super.callNumber,
    required super.requestedAt,
    super.status,
  });

  factory RentalRequestModel.fromJson(Map<String, dynamic> json) =>
      RentalRequestModel(
        id: json['id'] as String,
        studentId: json['studentId'] as String,
        userName: json['userName'] as String,
        bookTitle: json['bookTitle'] as String,
        callNumber: json['callNumber'] as String?,
        requestedAt: DateTime.parse(json['requestedAt'] as String),
        status: RentalRequestStatus.values.byName(
          json['status'] as String? ?? 'pending',
        ),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'studentId': studentId,
        'userName': userName,
        'bookTitle': bookTitle,
        'callNumber': callNumber,
        'requestedAt': requestedAt.toIso8601String(),
        'status': status.name,
      };
}
