import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/features/my_page/presentation/providers/my_page_provider.dart';
import 'package:bookshelf_mobile/features/my_page/presentation/widgets/liked_book_card.dart';
import 'package:bookshelf_mobile/features/my_page/presentation/widgets/liked_books_error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LikedBooksPage extends ConsumerWidget {
  const LikedBooksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBooks = ref.watch(likedBooksProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: Color(0xFF7E7E7E),
          ),
        ),
        title: const Text(
          '좋아요한 책',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        centerTitle: true,
      ),
      body: asyncBooks.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => LikedBooksErrorView(
          onRetry: () => ref.invalidate(likedBooksProvider),
        ),
        data: (books) => books.isEmpty
            ? const Center(
                child: Text(
                  '좋아요한 책이 없습니다.',
                  style: TextStyle(fontSize: 14, color: AppColors.grey500),
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 12,
                  childAspectRatio: 110 / 190,
                ),
                itemCount: books.length,
                itemBuilder: (_, index) => LikedBookCard(book: books[index]),
              ),
      ),
    );
  }
}
