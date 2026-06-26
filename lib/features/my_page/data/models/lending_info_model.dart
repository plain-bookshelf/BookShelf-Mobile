import 'package:bookshelf_mobile/features/my_page/domain/entities/lending_info.dart';

/// GET /myPage/lendinginfo 응답 모델
class LendingInfoModel {
  final List<LendingBookModel> rentalBookInfo;
  final List<LendingBookModel> reservationBookInfo;
  final List<LendingBookModel> overDueBookInfo;

  const LendingInfoModel({
    required this.rentalBookInfo,
    required this.reservationBookInfo,
    required this.overDueBookInfo,
  });

  static List<LendingBookModel> _parseList(dynamic raw) =>
      (raw as List<dynamic>? ?? [])
          .map((e) => LendingBookModel.fromJson(e as Map<String, dynamic>))
          .toList();

  factory LendingInfoModel.fromJson(Map<String, dynamic> json) =>
      LendingInfoModel(
        rentalBookInfo: _parseList(json['rental_book_info']),
        reservationBookInfo: _parseList(json['reservation_book_info']),
        overDueBookInfo: _parseList(json['over_due_book_info']),
      );

  LendingInfo toEntity() => LendingInfo(
        rentals: rentalBookInfo.map((e) => e.toEntity()).toList(),
        reservations: reservationBookInfo.map((e) => e.toEntity()).toList(),
        overdues: overDueBookInfo.map((e) => e.toEntity()).toList(),
      );
}

class LendingBookModel {
  final int bookAffiliationId;
  final String bookImage;
  final String title;
  final int? leftRentalDate;
  final int? rank;
  final int? overdueDate;

  const LendingBookModel({
    required this.bookAffiliationId,
    required this.bookImage,
    required this.title,
    this.leftRentalDate,
    this.rank,
    this.overdueDate,
  });

  factory LendingBookModel.fromJson(Map<String, dynamic> json) =>
      LendingBookModel(
        bookAffiliationId: json['book_affiliation_id'] as int? ?? 0,
        bookImage: json['book_image'] as String? ?? '',
        title: json['title'] as String? ?? '',
        leftRentalDate: json['left_rental_date'] as int?,
        rank: json['rank'] as int?,
        overdueDate: json['overdue_date'] as int?,
      );

  LendingBook toEntity() => LendingBook(
        bookAffiliationId: bookAffiliationId,
        bookImage: bookImage,
        title: title,
        leftRentalDate: leftRentalDate,
        rank: rank,
        overdueDate: overdueDate,
      );
}
