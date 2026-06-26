import 'dart:async';

import 'package:bookshelf_mobile/core/network/auth_session_provider.dart';
import 'package:bookshelf_mobile/features/notification/data/datasources/sse_service.dart';
import 'package:bookshelf_mobile/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:bookshelf_mobile/features/notification/domain/entities/app_notification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NotificationStatus { loading, loaded, failure }

class NotificationState {
  final NotificationStatus status;
  final List<AppNotification> notifications;
  final bool isLastPage;
  final bool isLoadingMore;

  const NotificationState({
    this.status = NotificationStatus.loading,
    this.notifications = const [],
    this.isLastPage = true,
    this.isLoadingMore = false,
  });

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  NotificationState copyWith({
    NotificationStatus? status,
    List<AppNotification>? notifications,
    bool? isLastPage,
    bool? isLoadingMore,
  }) =>
      NotificationState(
        status: status ?? this.status,
        notifications: notifications ?? this.notifications,
        isLastPage: isLastPage ?? this.isLastPage,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );
}

class NotificationNotifier extends Notifier<NotificationState> {
  bool _mounted = true;
  SseService? _sseService;
  StreamSubscription<AppNotification>? _sseSub;

  @override
  NotificationState build() {
    ref.onDispose(() {
      _mounted = false;
      _sseSub?.cancel();
      _sseService?.dispose();
    });

    Future.microtask(_load);
    Future.microtask(_connectSse);

    return const NotificationState(status: NotificationStatus.loading);
  }

  // ── REST: 알림 목록 초기 로드 ────────────────────────────────────────────
  Future<void> _load() async {
    try {
      final accessToken = ref.read(authSessionProvider).accessToken ?? '';
      final items = await ref
          .read(notificationRepositoryProvider)
          .getNotifications(accessToken: accessToken, page: 0);
      if (!_mounted) return;
      state = state.copyWith(
        status: NotificationStatus.loaded,
        notifications: items,
      );
    } catch (_) {
      if (!_mounted) return;
      state = state.copyWith(status: NotificationStatus.failure);
    }
  }

  // ── SSE: 실시간 새 알림 구독 ──────────────────────────────────────────────
  void _connectSse() {
    final accessToken = ref.read(authSessionProvider).accessToken;
    if (accessToken == null || accessToken.isEmpty) return;

    _sseService = SseService();
    _sseSub = _sseService!
        .subscribe(accessToken: accessToken)
        .listen((notification) {
      if (!_mounted) return;
      // 중복 방지: 같은 id가 이미 있으면 추가하지 않음
      final exists = state.notifications.any((n) => n.id == notification.id);
      if (!exists) {
        state = state.copyWith(
          notifications: [notification, ...state.notifications],
        );
      }
    });
  }

  // ── 새로고침 ──────────────────────────────────────────────────────────────
  Future<void> refresh() async {
    state = state.copyWith(
      status: NotificationStatus.loading,
      notifications: [],
    );
    await _load();
  }

  // ── 읽음 처리 (로컬) ──────────────────────────────────────────────────────
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
