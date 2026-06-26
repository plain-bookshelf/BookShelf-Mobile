class SearchBookModel {
  final int bookAffiliationId;
  final String bookImage;

  const SearchBookModel({
    required this.bookAffiliationId,
    required this.bookImage,
  });

  factory SearchBookModel.fromJson(Map<String, dynamic> json) =>
      SearchBookModel(
        bookAffiliationId: json['book_affiliation_id'] as int,
        bookImage: json['book_image'] as String? ?? '',
      );
}

class SearchPageModel {
  final List<SearchBookModel> content;
  final bool isLastPage;

  const SearchPageModel({
    required this.content,
    required this.isLastPage,
  });

  factory SearchPageModel.fromJson(Map<String, dynamic> json) =>
      SearchPageModel(
        content: (json['content'] as List<dynamic>? ?? [])
            .map((e) => SearchBookModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        isLastPage: json['is_last_page'] as bool? ?? true,
      );
}
