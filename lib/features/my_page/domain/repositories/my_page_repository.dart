import 'package:bookshelf_mobile/features/my_page/domain/entities/my_page_info.dart';

abstract interface class MyPageRepository {
  Future<MyPageInfo> getMyPage({required String accessToken});
}
