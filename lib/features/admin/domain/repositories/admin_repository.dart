import 'package:bookshelf_mobile/features/admin/domain/entities/rental_request.dart';

/// 관리자 Repository 인터페이스 (Domain Layer)
abstract interface class AdminRepository {
  /// 대기 중인 대여 요청 목록 조회
  Future<List<RentalRequest>> getPendingRentals();

  /// 대여 승인
  Future<void> approveRental(String requestId);

  /// 대여 요청 취소
  Future<void> cancelRental(String requestId);
}
