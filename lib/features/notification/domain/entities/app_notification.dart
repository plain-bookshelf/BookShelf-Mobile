/// 앱 알림 도메인 엔티티
///
/// Flutter 기본 [Notification] 클래스와 이름 충돌을 피하기 위해 App 접두사 사용
class AppNotification {
  final String id;
  final String title;
  final String body;
  final String? coverUrl; // 도서 표지 이미지 URL (있을 경우 상세에서 표시)
  final DateTime createdAt;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    this.coverUrl,
    required this.createdAt,
    this.isRead = false,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? body,
    String? coverUrl,
    DateTime? createdAt,
    bool? isRead,
  }) =>
      AppNotification(
        id: id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
        coverUrl: coverUrl ?? this.coverUrl,
        createdAt: createdAt ?? this.createdAt,
        isRead: isRead ?? this.isRead,
      );
}
