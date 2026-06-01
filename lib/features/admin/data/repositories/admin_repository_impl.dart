import 'package:bookshelf_mobile/features/admin/domain/entities/rental_request.dart';
import 'package:bookshelf_mobile/features/admin/domain/repositories/admin_repository.dart';

/// AdminRepository 구현체 (Data Layer)
/// TODO: 실제 API 연동 시 RemoteDataSource 주입
class AdminRepositoryImpl implements AdminRepository {
  const AdminRepositoryImpl();

  @override
  Future<List<RentalRequest>> getPendingRentals() {
    throw UnimplementedError();
  }

  @override
  Future<void> approveRental(String requestId) {
    throw UnimplementedError();
  }

  @override
  Future<void> cancelRental(String requestId) {
    throw UnimplementedError();
  }
}
