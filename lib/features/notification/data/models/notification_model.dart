import 'package:bookshelf_mobile/features/notification/domain/entities/app_notification.dart';

class NotificationPayloadModel {
  final String type;
  final int? bookId;
  final String? title;
  final String? returnDate;

  const NotificationPayloadModel({
    required this.type,
    this.bookId,
    this.title,
    this.returnDate,
  });

  factory NotificationPayloadModel.fromJson(Map<String, dynamic> json) =>
      NotificationPayloadModel(
        type: json['type'] as String? ?? '',
        bookId: json['book_id'] as int?,
        title: json['title'] as String?,
        returnDate: json['return_date'] as String?,
      );
}

class NotificationInfoModel {
  final String name;
  final NotificationPayloadModel payload;
  final String type;
  final String url;

  const NotificationInfoModel({
    required this.name,
    required this.payload,
    required this.type,
    required this.url,
  });

  factory NotificationInfoModel.fromJson(Map<String, dynamic> json) =>
      NotificationInfoModel(
        name: json['name'] as String? ?? '',
        payload: NotificationPayloadModel.fromJson(
          json['payload'] as Map<String, dynamic>? ?? {},
        ),
        type: json['type'] as String? ?? '',
        url: json['url'] as String? ?? '',
      );
}

class NotificationModel {
  final int id;
  final NotificationInfoModel notificationInfo;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.notificationInfo,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['id'] as int,
        notificationInfo: NotificationInfoModel.fromJson(
          json['notification_info'] as Map<String, dynamic>? ?? {},
        ),
        isRead: json['is_read'] as bool? ?? false,
      );

  AppNotification toEntity() {
    final payload = notificationInfo.payload;

    // body: 책 제목과 반납일이 있으면 조합, 없으면 name 그대로 사용
    final bodyParts = <String>[];
    if (payload.title != null && payload.title!.isNotEmpty) {
      bodyParts.add('"${payload.title}"');
    }
    if (payload.returnDate != null && payload.returnDate!.isNotEmpty) {
      bodyParts.add('반납일: ${payload.returnDate}');
    }
    final body = bodyParts.isNotEmpty
        ? bodyParts.join(' · ')
        : notificationInfo.name;

    return AppNotification(
      id: id.toString(),
      title: notificationInfo.name,
      body: body,
      isRead: isRead,
      bookId: payload.bookId?.toString(),
    );
  }
}

class NotificationPageModel {
  final List<NotificationModel> content;
  final bool isLastPage;

  const NotificationPageModel({
    required this.content,
    required this.isLastPage,
  });

  factory NotificationPageModel.fromJson(Map<String, dynamic> json) =>
      NotificationPageModel(
        content: (json['content'] as List<dynamic>? ?? [])
            .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        isLastPage: json['is_last_page'] as bool? ?? true,
      );
}
