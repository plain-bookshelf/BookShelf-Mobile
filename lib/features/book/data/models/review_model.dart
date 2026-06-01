import 'package:bookshelf_mobile/features/book/domain/entities/review.dart';

/// Review 도메인 엔티티의 데이터 모델
class ReviewModel extends Review {
  const ReviewModel({
    required super.id,
    required super.reviewerName,
    required super.content,
    required super.likeCount,
    required super.isLiked,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        id: json['id'] as String,
        reviewerName: json['reviewerName'] as String,
        content: json['content'] as String,
        likeCount: json['likeCount'] as int? ?? 0,
        isLiked: json['isLiked'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'reviewerName': reviewerName,
        'content': content,
        'likeCount': likeCount,
        'isLiked': isLiked,
      };
}
