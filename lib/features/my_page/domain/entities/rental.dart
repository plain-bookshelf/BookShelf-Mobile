import 'package:bookshelf_mobile/features/book/domain/entities/book.dart';

/// 대여 상태
enum RentalStatus { renting, reserved, returned }

/// 대여 내역 도메인 엔티티
class Rental {
  final String id;
  final Book book;
  final RentalStatus status;
  final DateTime? dueDate;

  const Rental({
    required this.id,
    required this.book,
    required this.status,
    this.dueDate,
  });

  /// 반납까지 남은 일수 (음수 = 연체, null = dueDate 없음)
  int? get daysLeft {
    if (dueDate == null) return null;
    final due = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return due.difference(today).inDays;
  }

  bool get isOverdue => daysLeft != null && daysLeft! < 0;
}
