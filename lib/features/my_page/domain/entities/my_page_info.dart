/// 마이페이지 도메인 엔티티
class MyPageInfo {
  final String profileImage;
  final String nickname;
  final String? mostLittleLeftRentalTitle;
  final int? mostLittleLeftRentalDate;
  final int rentedBookCount;
  final int reservedBookCount;
  final int overdueBookCount;

  const MyPageInfo({
    required this.profileImage,
    required this.nickname,
    this.mostLittleLeftRentalTitle,
    this.mostLittleLeftRentalDate,
    required this.rentedBookCount,
    required this.reservedBookCount,
    required this.overdueBookCount,
  });

  MyPageInfo copyWith({String? profileImage, String? nickname}) => MyPageInfo(
    profileImage: profileImage ?? this.profileImage,
    nickname: nickname ?? this.nickname,
    mostLittleLeftRentalTitle: mostLittleLeftRentalTitle,
    mostLittleLeftRentalDate: mostLittleLeftRentalDate,
    rentedBookCount: rentedBookCount,
    reservedBookCount: reservedBookCount,
    overdueBookCount: overdueBookCount,
  );
}
