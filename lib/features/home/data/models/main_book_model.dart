import 'package:bookshelf_mobile/features/home/domain/entities/main_book.dart';

class MainBookModel {
  final int id;
  final String bookImage;
  final String? title;
  final String? author;
  final List<String>? genreList;

  const MainBookModel({
    required this.id,
    required this.bookImage,
    this.title,
    this.author,
    this.genreList,
  });

  factory MainBookModel.fromJson(Map<String, dynamic> json) => MainBookModel(
        id: json['id'] as int,
        bookImage: json['book_image'] as String? ?? '',
        title: json['title'] as String?,
        author: json['author'] as String?,
        genreList: (json['genre_list'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
      );

  MainBook toEntity() => MainBook(
        id: id,
        bookImage: bookImage,
        title: title,
        author: author,
        genreList: genreList,
      );
}

class MainBookListModel {
  final List<MainBookModel> content;
  final bool isLastPage;

  const MainBookListModel({
    required this.content,
    required this.isLastPage,
  });

  factory MainBookListModel.fromJson(Map<String, dynamic> json) =>
      MainBookListModel(
        content: (json['content'] as List<dynamic>)
            .map((e) => MainBookModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        isLastPage: json['is_last_page'] as bool? ?? true,
      );

  List<MainBook> toEntityList() => content.map((e) => e.toEntity()).toList();
}
