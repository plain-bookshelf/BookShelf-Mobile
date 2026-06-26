/// 도서 리뷰(댓글) 도메인 엔티티
class Review {
  final String id;
  final String reviewerName;
  final String content;
  final int likeCount;
  final bool isLiked;
  final String? profileImage;

  const Review({
    required this.id,
    required this.reviewerName,
    required this.content,
    required this.likeCount,
    required this.isLiked,
    this.profileImage,
  });

  Review copyWith({
    String? id,
    String? reviewerName,
    String? content,
    int? likeCount,
    bool? isLiked,
    String? profileImage,
  }) =>
      Review(
        id: id ?? this.id,
        reviewerName: reviewerName ?? this.reviewerName,
        content: content ?? this.content,
        likeCount: likeCount ?? this.likeCount,
        isLiked: isLiked ?? this.isLiked,
        profileImage: profileImage ?? this.profileImage,
      );
}
