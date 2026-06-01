/// 도서 리뷰 도메인 엔티티
class Review {
  final String id;
  final String reviewerName;
  final String content;
  final int likeCount;
  final bool isLiked;

  const Review({
    required this.id,
    required this.reviewerName,
    required this.content,
    required this.likeCount,
    required this.isLiked,
  });

  Review copyWith({
    String? id,
    String? reviewerName,
    String? content,
    int? likeCount,
    bool? isLiked,
  }) =>
      Review(
        id: id ?? this.id,
        reviewerName: reviewerName ?? this.reviewerName,
        content: content ?? this.content,
        likeCount: likeCount ?? this.likeCount,
        isLiked: isLiked ?? this.isLiked,
      );
}
