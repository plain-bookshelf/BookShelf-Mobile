import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bookshelf_mobile/core/network/api_constants.dart';
import 'package:bookshelf_mobile/features/notification/data/models/notification_model.dart';
import 'package:bookshelf_mobile/features/notification/domain/entities/app_notification.dart';

/// GET /api/notification/subscribe (text/event-stream)
class SseService {
  HttpClient? _client;
  Timer? _reconnectTimer;
  bool _disposed = false;

  // ── 구독 시작 ──────────────────────────────────────────────────────────────
  Stream<AppNotification> subscribe({
    required String accessToken,
    String? lastEventId,
  }) {
    final controller = StreamController<AppNotification>.broadcast();
    _connect(
      controller: controller,
      accessToken: accessToken,
      lastEventId: lastEventId,
    );
    return controller.stream;
  }

  // ── 내부 연결 로직 (재귀 재연결) ───────────────────────────────────────────
  Future<void> _connect({
    required StreamController<AppNotification> controller,
    required String accessToken,
    String? lastEventId,
  }) async {
    if (_disposed || controller.isClosed) return;

    final uri = Uri.parse(
      '${ApiConstants.baseUrl1}/api/notification/subscribe',
    );

    try {
      _client = HttpClient();
      final request = await _client!.getUrl(uri);
      request.headers.set(
        HttpHeaders.authorizationHeader,
        'Bearer $accessToken',
      );
      request.headers.set(HttpHeaders.acceptHeader, 'text/event-stream');
      request.headers.set(HttpHeaders.cacheControlHeader, 'no-cache');
      if (lastEventId != null && lastEventId.isNotEmpty) {
        request.headers.set('Last-Event-ID', lastEventId);
      }

      final response = await request.close();

      // SSE 파싱용 버퍼
      String buffer = '';
      String? currentEvent;
      String? currentData;
      String? currentId;

      await for (final chunk in response.transform(utf8.decoder)) {
        if (_disposed || controller.isClosed) return;

        buffer += chunk;
        final lines = buffer.split('\n');
        buffer = lines.removeLast(); // 미완성 라인은 버퍼 보관

        for (final line in lines) {
          if (line.startsWith('id:')) {
            currentId = line.substring(3).trim();
          } else if (line.startsWith('event:')) {
            currentEvent = line.substring(6).trim();
          } else if (line.startsWith('data:')) {
            // 멀티라인 data 지원
            currentData =
                (currentData == null ? '' : '$currentData\n') +
                line.substring(5).trim();
          } else if (line.isEmpty) {
            // 빈 줄 → 이벤트 하나 완성
            if (currentId != null) lastEventId = currentId;

            if (currentEvent == 'notification' && currentData != null) {
              _emit(controller, currentData);
            }

            currentEvent = null;
            currentData = null;
            currentId = null;
          }
        }
      }
    } catch (_) {
      // 연결 오류 무시 → 재연결
    } finally {
      _client?.close(force: true);
      _client = null;
    }

    // 재연결 (3초 후)
    if (!_disposed && !controller.isClosed) {
      _reconnectTimer = Timer(const Duration(seconds: 3), () {
        _connect(
          controller: controller,
          accessToken: accessToken,
          lastEventId: lastEventId,
        );
      });
    }
  }

  // ── JSON 파싱 → AppNotification emit ──────────────────────────────────────
  void _emit(StreamController<AppNotification> controller, String data) {
    try {
      final json = jsonDecode(data) as Map<String, dynamic>;
      final notifJson = json['notification'] as Map<String, dynamic>;
      final model = NotificationModel.fromJson(notifJson);
      controller.add(model.toEntity());
    } catch (_) {}
  }

  // ── 정리 ──────────────────────────────────────────────────────────────────
  void dispose() {
    _disposed = true;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _client?.close(force: true);
    _client = null;
  }
}
