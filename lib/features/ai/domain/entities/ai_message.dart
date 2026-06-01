import 'package:bookshelf_mobile/features/book/domain/entities/book.dart';

enum AiMessageRole { ai, user }

/// 마루AI 채팅 메시지 도메인 엔티티
///
/// [books] 가 non-null 이면 AI 추천 도서 목록이 인라인으로 첨부된 메시지입니다.
class AiMessage {
  final String id;
  final AiMessageRole role;
  final String content;
  final List<Book>? books;

  const AiMessage({
    required this.id,
    required this.role,
    required this.content,
    this.books,
  });
}
