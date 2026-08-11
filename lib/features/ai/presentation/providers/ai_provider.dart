import 'package:bookshelf_mobile/core/network/auth_session_provider.dart';
import 'package:bookshelf_mobile/features/ai/data/datasources/recommend_remote_data_source.dart';
import 'package:bookshelf_mobile/features/ai/domain/entities/ai_message.dart';
import 'package:bookshelf_mobile/features/book/domain/entities/book.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── 상태 ──────────────────────────────────────────────────────────────────────
enum AiStatus {
  idle, // 대화 없음 (빈 화면)
  chatting, // 응답 대기 중 (타이핑 인디케이터)
  recommended, // 추천 결과 표시
}

class AiState {
  final AiStatus status;
  final List<AiMessage> messages;
  final bool isTyping;
  final String userName;
  final List<Book> recommendedBooks;

  const AiState({
    this.status = AiStatus.idle,
    this.messages = const [],
    this.isTyping = false,
    this.userName = '사용자',
    this.recommendedBooks = const [],
  });

  /// 추천 결과가 있는지 여부
  bool get hasBooks => recommendedBooks.isNotEmpty;

  AiState copyWith({
    AiStatus? status,
    List<AiMessage>? messages,
    bool? isTyping,
    String? userName,
    List<Book>? recommendedBooks,
  }) => AiState(
    status: status ?? this.status,
    messages: messages ?? this.messages,
    isTyping: isTyping ?? this.isTyping,
    userName: userName ?? this.userName,
    recommendedBooks: recommendedBooks ?? this.recommendedBooks,
  );
}

// ── AiNotifier ────────────────────────────────────────────────────────────────
class AiNotifier extends Notifier<AiState> {
  bool _mounted = true;
  int _idCounter = 0;

  @override
  AiState build() {
    ref.onDispose(() => _mounted = false);
    return const AiState();
  }

  String _nextId() => '${++_idCounter}';

  /// 사용자 메시지 전송 → AI 응답 시뮬레이션 후 추천 결과 표시
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // 1. 사용자 메시지 + 타이핑 인디케이터
    state = state.copyWith(
      status: AiStatus.chatting,
      messages: [
        ...state.messages,
        AiMessage(
          id: _nextId(),
          role: AiMessageRole.user,
          content: text.trim(),
        ),
      ],
      isTyping: true,
    );

    // 2. 추천 API 호출 (GET /recommend_books)
    final memberId = ref.read(authSessionProvider).username ?? '';
    List<Book> recommended = const [];
    try {
      final books = await ref
          .read(recommendRemoteDataSourceProvider)
          .getRecommendedBooks(memberId: memberId);
      recommended = books.map((b) => b.toEntity()).toList();
    } catch (_) {
      // 추천 서버 실패 시 빈 목록으로 대화는 계속 이어감
    }
    if (!_mounted) return;

    // 3. 추천 결과로 전환
    state = state.copyWith(
      status: AiStatus.recommended,
      messages: [
        ...state.messages,
        AiMessage(
          id: _nextId(),
          role: AiMessageRole.ai,
          content: '${state.userName}님의 취향을 분석해 책을 준비했어요!',
        ),
      ],
      isTyping: false,
      recommendedBooks: recommended,
    );
  }

  /// 대화 초기화
  void reset() {
    state = const AiState();
  }
}

final aiProvider = NotifierProvider<AiNotifier, AiState>(AiNotifier.new);
