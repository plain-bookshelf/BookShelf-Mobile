import 'package:bookshelf_mobile/features/notification/domain/entities/app_notification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── 로딩 상태 ─────────────────────────────────────────────────────────────────
enum NotificationStatus { loading, loaded, failure }

// ── NotificationState ─────────────────────────────────────────────────────────
class NotificationState {
  final NotificationStatus status;
  final List<AppNotification> notifications;

  const NotificationState({
    this.status = NotificationStatus.loading,
    this.notifications = const [],
  });

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  NotificationState copyWith({
    NotificationStatus? status,
    List<AppNotification>? notifications,
  }) =>
      NotificationState(
        status: status ?? this.status,
        notifications: notifications ?? this.notifications,
      );
}

// ── 더미 데이터 ───────────────────────────────────────────────────────────────
final _dummyNotifications = [
  AppNotification(
    id: '1',
    title: '책 대여 안내',
    body: '대여하신 책 "오늘도 소심한 고양이"이/가 반납 3일 남으셨습니다',
    createdAt: DateTime(2024, 9, 10),
    isRead: false,
  ),
  AppNotification(
    id: '2',
    title: '책 대여 안내',
    body: '대여하신 책 "오늘도 소심한 고양이"이/가 반납 3일 남으셨습니다',
    createdAt: DateTime(2024, 9, 9),
    isRead: false,
  ),
  AppNotification(
    id: '3',
    title: '책 대여 안내',
    body: '대여하신 책 "오늘도 소심한 고양이"이/가 반납 3일 남으셨습니다',
    createdAt: DateTime(2024, 9, 8),
    isRead: true,
  ),
  AppNotification(
    id: '4',
    title: '책 대여 안내',
    body: '대여하신 책 "오늘도 소심한 고양이"이/가 반납 3일 남으셨습니다',
    createdAt: DateTime(2024, 9, 7),
    isRead: true,
  ),
];

// ── NotificationNotifier ──────────────────────────────────────────────────────
class NotificationNotifier extends Notifier<NotificationState> {
  bool _mounted = true;

  @override
  NotificationState build() {
    ref.onDispose(() => _mounted = false);
    Future.microtask(_load);
    return const NotificationState(status: NotificationStatus.loading);
  }

  Future<void> _load() async {
    // TODO: NotificationRepository.getNotifications() 연동
    await Future.delayed(const Duration(milliseconds: 300));
    if (!_mounted) return;
    state = state.copyWith(
      status: NotificationStatus.loaded,
      notifications: List.of(_dummyNotifications),
    );
  }

  // ── 읽음 처리 ──────────────────────────────────────────────────────────────
  void markAsRead(String id) {
    state = state.copyWith(
      notifications: state.notifications
          .map((n) => n.id == id ? n.copyWith(isRead: true) : n)
          .toList(),
    );
  }
}

final notificationProvider =
    NotifierProvider<NotificationNotifier, NotificationState>(
  NotificationNotifier.new,
);
