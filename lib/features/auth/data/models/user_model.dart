import 'package:bookshelf_mobile/features/auth/domain/entities/user.dart';

/// User 도메인 엔티티의 데이터 모델
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.isAdmin,
    super.rentalDaysLeft,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        email: json['email'] as String,
        name: json['name'] as String,
        isAdmin: json['isAdmin'] as bool,
        rentalDaysLeft: json['rentalDaysLeft'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'isAdmin': isAdmin,
        'rentalDaysLeft': rentalDaysLeft,
      };
}
