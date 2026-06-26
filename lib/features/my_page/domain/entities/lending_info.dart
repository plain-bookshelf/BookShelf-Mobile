/// 마이페이지 대여/예약/연체 책 단위 엔티티
class LendingBook {
  final int bookAffiliationId;
  final String bookImage;
  final String title;

  /// 대여: 반납까지 남은 일수
  final int? leftRentalDate;

  /// 예약: 대기 순번
  final int? rank;

  /// 연체: 연체된 일수
  final int? overdueDate;

  const LendingBook({
    required this.bookAffiliationId,
    required this.bookImage,
    required this.title,
    this.leftRentalDate,
    this.rank,
    this.overdueDate,
  });
}

/// GET /myPage/lendinginfo 도메인 엔티티
class LendingInfo {
  final List<LendingBook> rentals;
  final List<LendingBook> reservations;
  final List<LendingBook> overdues;

  const LendingInfo({
    this.rentals = const [],
    this.reservations = const [],
    this.overdues = const [],
  });
}
