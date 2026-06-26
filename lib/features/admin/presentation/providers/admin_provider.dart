import 'package:bookshelf_mobile/core/network/auth_session_provider.dart';
import 'package:bookshelf_mobile/features/admin/data/datasources/admin_remote_data_source.dart';
import 'package:bookshelf_mobile/features/admin/domain/entities/rental_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── 로딩 상태 ─────────────────────────────────────────────────────────────────
enum AdminStatus { loading, loaded, failure }

// ── AdminState ────────────────────────────────────────────────────────────────
class AdminState {
  final AdminStatus status;
  final List<RentalRequest> rentalRequests;
  final bool hasActiveEvent;

  const AdminState({
    this.status = AdminStatus.loading,
    this.rentalRequests = const [],
    this.hasActiveEvent = true,
  });

  bool get isEmpty => rentalRequests.isEmpty;

  AdminState copyWith({
    AdminStatus? status,
    List<RentalRequest>? rentalRequests,
    bool? hasActiveEvent,
  }) =>
      AdminState(
        status: status ?? this.status,
        rentalRequests: rentalRequests ?? this.rentalRequests,
        hasActiveEvent: hasActiveEvent ?? this.hasActiveEvent,
      );
}

// ── 더미 데이터 ───────────────────────────────────────────────────────────────
final _dummyRequests = [
  RentalRequest(
    id: '1',
    studentId: '1411',
    userName: '이승현',
    bookTitle: '오늘도 소심한 야옹이',
    callNumber: '813.6',
    requestedAt: DateTime(2024, 9, 13),
  ),
  RentalRequest(
    id: '2',
    studentId: '1411',
    userName: '이승현',
    bookTitle: '오늘도 소심한 야옹이',
    requestedAt: DateTime(2024, 9, 13),
  ),
  RentalRequest(
    id: '3',
    studentId: '1411',
    userName: '이승현',
    bookTitle: '오늘도 소심한 야옹이',
    requestedAt: DateTime(2024, 9, 13),
  ),
  RentalRequest(
    id: '4',
    studentId: '1411',
    userName: '이승현',
    bookTitle: '오늘도 소심한 야옹이',
    requestedAt: DateTime(2024, 9, 13),
  ),
  RentalRequest(
    id: '5',
    studentId: '1411',
    userName: '이승현',
    bookTitle: '오늘도 소심한 야옹이',
    requestedAt: DateTime(2024, 9, 13),
  ),
];

// ── AdminNotifier ─────────────────────────────────────────────────────────────
class AdminNotifier extends Notifier<AdminState> {
  bool _mounted = true;

  @override
  AdminState build() {
    ref.onDispose(() => _mounted = false);
    Future.microtask(_loadRequests);
    return const AdminState(status: AdminStatus.loading);
  }

  // ── 대여 요청 목록 로드 ───────────────────────────────────────────────────
  Future<void> _loadRequests() async {
    // TODO: AdminRepository.getPendingRentals() 연동
    await Future.delayed(const Duration(milliseconds: 400));
    if (!_mounted) return;
    state = state.copyWith(
      status: AdminStatus.loaded,
      rentalRequests: List.of(_dummyRequests),
    );
  }

  // ── 대여 승인 ─────────────────────────────────────────────────────────────
  // PATCH /api/manager/approve/{bookDetailId}
  Future<void> approveRental(String id) async {
    final previous = state.rentalRequests;
    // 낙관적 업데이트: 목록에서 즉시 제거
    state = state.copyWith(
      rentalRequests: previous.where((r) => r.id != id).toList(),
    );

    try {
      final accessToken = ref.read(authSessionProvider).accessToken ?? '';
      await ref.read(adminRemoteDataSourceProvider).approveRental(
            bookDetailId: id,
            accessToken: accessToken,
          );
    } catch (_) {
      // 실패 시 이전 목록으로 롤백
      if (!_mounted) return;
      state = state.copyWith(rentalRequests: previous);
    }
  }

  // ── 대여 취소 ─────────────────────────────────────────────────────────────
  Future<void> cancelRental(String id) async {
    // TODO: AdminRepository.cancelRental(id) 연동
    state = state.copyWith(
      rentalRequests: state.rentalRequests
          .where((r) => r.id != id)
          .toList(),
    );
  }
}

final adminProvider =
    NotifierProvider<AdminNotifier, AdminState>(AdminNotifier.new);
