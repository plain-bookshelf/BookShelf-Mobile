import 'package:bookshelf_mobile/features/home/domain/entities/main_book.dart';

abstract interface class HomeRepository {
  Future<List<MainBook>> getMainBooks({
    required String accessToken,
    required BookFindType bookFindType,
  });
}
