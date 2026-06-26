import 'package:bookshelf_mobile/features/book/domain/entities/review.dart';

/// GET /book/{bookAffiliationId}/comment 응답의 단일 댓글 모델
class CommentModel {
  final String? profileImage;
  final int commentId;
  final String nickname;
  final String comment;
  final int likeCount;
  final bool isLiked;

  const CommentModel({
    required this.profileImage,
    required this.commentId,
    required this.nickname,
    required this.comment,
    required this.likeCount,
    required this.isLiked,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        profileImage: (json['profile_image'] as String?)?.isNotEmpty == true
            ? json['profile_image'] as String
            : null,
        commentId: json['comment_id'] as int? ?? 0,
        nickname: json['nickname'] as String? ?? '',
        comment: json['comment'] as String? ?? '',
        likeCount: json['like_count'] as int? ?? 0,
        isLiked: json['is_liked'] as bool? ?? false,
      );

  /// 도메인 엔티티로 변환
  Review toReview() => Review(
        id: commentId.toString(),
        reviewerName: nickname,
        content: comment,
        likeCount: likeCount,
        isLiked: isLiked,
        profileImage: profileImage,
      );
}

/// 댓글 목록 + 페이지네이션 메타
class CommentPageModel {
  final List<CommentModel> content;
  final bool isLastPage;

  const CommentPageModel({
    required this.content,
    required this.isLastPage,
  });

  factory CommentPageModel.fromJson(Map<String, dynamic> json) =>
      CommentPageModel(
        content: (json['content'] as List<dynamic>? ?? [])
            .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        isLastPage: json['is_last_page'] as bool? ?? true,
      );
}
