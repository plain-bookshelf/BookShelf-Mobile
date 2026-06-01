import 'package:bookshelf_mobile/features/ai/domain/entities/ai_message.dart';
import 'package:bookshelf_mobile/features/book/domain/entities/book.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── 상태 ──────────────────────────────────────────────────────────────────────
enum AiStatus {
  idle,         // 대화 없음 (빈 화면)
  chatting,     // 응답 대기 중 (타이핑 인디케이터)
  recommended,  // 추천 결과 표시
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
  }) =>
      AiState(
        status: status ?? this.status,
        messages: messages ?? this.messages,
        isTyping: isTyping ?? this.isTyping,
        userName: userName ?? this.userName,
        recommendedBooks: recommendedBooks ?? this.recommendedBooks,
      );
}

// ── 더미 추천 도서 ─────────────────────────────────────────────────────────────
const _dummyRecommendations = <Book>[
  Book(
    id: 'r1', title: '화씨 451', author: '레이 브래드버리',
    genre: '소설', publisher: 'SF북스', publishYear: 1953,
    status: BookStatus.available,
  ),
  Book(
    id: 'r2', title: '1984', author: '조지 오웰',
    genre: '소설', publisher: '민음사', publishYear: 1949,
    status: BookStatus.available,
  ),
  Book(
    id: 'r3', title: '멋진 신세계', author: '올더스 헉슬리',
    genre: '소설', publisher: '문학사상', publishYear: 1932,
    status: BookStatus.rented,
  ),
  Book(
    id: 'r4', title: '파친코', author: '이민진',
    genre: '소설', publisher: '문학사상', publishYear: 2022,
    status: BookStatus.available,
  ),
  Book(
    id: 'r5', title: '채식주의자', author: '한강',
    genre: '소설', publisher: '창비', publishYear: 2007,
    status: BookStatus.available,
  ),
  Book(
    id: 'r6', title: '아몬드', author: '손원평',
    genre: '소설', publisher: '창비', publishYear: 2017,
    status: BookStatus.available,
  ),
];

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

    // 2. AI 응답 대기 (TODO: 실제 AI API 연동)
    await Future.delayed(const Duration(milliseconds: 1200));
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
      recommendedBooks: _dummyRecommendations,
    );
  }

  /// 대화 초기화
  void reset() {
    state = const AiState();
  }
}

final aiProvider =
    NotifierProvider<AiNotifier, AiState>(AiNotifier.new);
