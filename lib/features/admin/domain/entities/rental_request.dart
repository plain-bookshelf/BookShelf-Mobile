/// 대여 요청 처리 상태
enum RentalRequestStatus { pending, approved, cancelled }

/// 관리자 화면의 대여 요청 도메인 엔티티
class RentalRequest {
  final String id;
  final String studentId;   // 학번 (예: "1411")
  final String userName;    // 학생 이름 (예: "이승현")
  final String bookTitle;   // 도서명
  final String? callNumber; // 청구기호 (예: "813.6")
  final DateTime requestedAt;
  final RentalRequestStatus status;

  const RentalRequest({
    required this.id,
    required this.studentId,
    required this.userName,
    required this.bookTitle,
    this.callNumber,
    required this.requestedAt,
    this.status = RentalRequestStatus.pending,
  });

  /// 화면에 표시할 "학번 이름" 형식 문자열
  String get userLabel => '$studentId $userName';

  /// 화면에 표시할 "도서명 청구기호" 형식 문자열
  String get bookLabel =>
      callNumber != null ? '$bookTitle $callNumber' : bookTitle;

  RentalRequest copyWith({
    String? id,
    String? studentId,
    String? userName,
    String? bookTitle,
    String? callNumber,
    DateTime? requestedAt,
    RentalRequestStatus? status,
  }) =>
      RentalRequest(
        id: id ?? this.id,
        studentId: studentId ?? this.studentId,
        userName: userName ?? this.userName,
        bookTitle: bookTitle ?? this.bookTitle,
        callNumber: callNumber ?? this.callNumber,
        requestedAt: requestedAt ?? this.requestedAt,
        status: status ?? this.status,
      );
}
