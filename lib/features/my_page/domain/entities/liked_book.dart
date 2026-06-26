/// 마이페이지 좋아요(찜)한 책 엔티티
class LikedBook {
  final int bookAffiliationId;
  final String title;
  final String bookImage;

  const LikedBook({
    required this.bookAffiliationId,
    required this.title,
    required this.bookImage,
  });
}
