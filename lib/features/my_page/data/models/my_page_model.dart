import 'package:bookshelf_mobile/features/my_page/domain/entities/my_page_info.dart';

/// GET /mypage 응답 모델
class MyPageModel {
  final String profileImage;
  final String nickname;
  final String? mostLittleLeftRentalTitle;
  final int? mostLittleLeftRentalDate;
  final int rentedBookCount;
  final int reservedBookCount;
  final int overdueBookCount;

  const MyPageModel({
    required this.profileImage,
    required this.nickname,
    this.mostLittleLeftRentalTitle,
    this.mostLittleLeftRentalDate,
    required this.rentedBookCount,
    required this.reservedBookCount,
    required this.overdueBookCount,
  });

  factory MyPageModel.fromJson(Map<String, dynamic> json) => MyPageModel(
        profileImage: json['profile_image'] as String? ?? '',
        nickname: json['nickname'] as String? ?? '',
        mostLittleLeftRentalTitle:
            json['most_little_left_rental_title'] as String?,
        mostLittleLeftRentalDate:
            json['most_little_left_rental_date'] as int?,
        rentedBookCount: json['rented_book_count'] as int? ?? 0,
        reservedBookCount: json['reserved_book_count'] as int? ?? 0,
        overdueBookCount: json['overdue_book_count'] as int? ?? 0,
      );

  MyPageInfo toEntity() => MyPageInfo(
        profileImage: profileImage,
        nickname: nickname,
        mostLittleLeftRentalTitle: mostLittleLeftRentalTitle,
        mostLittleLeftRentalDate: mostLittleLeftRentalDate,
        rentedBookCount: rentedBookCount,
        reservedBookCount: reservedBookCount,
        overdueBookCount: overdueBookCount,
      );
}
