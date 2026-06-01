import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/features/home/domain/entities/main_book.dart';
import 'package:bookshelf_mobile/features/home/presentation/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 도서 추천 화면 본문 (초록 배너 + 인기/신규 가로 리스트)
///
/// 기존 홈페이지에 있던 내용으로, 현재는 마루AI 페이지의 "도서 추천" 탭에서 사용합니다.
class BookRecommendView extends ConsumerWidget {
  const BookRecommendView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popularAsync = ref.watch(popularBooksProvider);
    final recentAsync = ref.watch(recentBooksProvider);

    return ColoredBox(
      color: Colors.white,
      child: ListView(
        children: [
          const _BannerSection(),
          const SizedBox(height: 28),
          _SectionHeader(
            title: '인기 도서',
            onMore: () => context.push(AppRoutes.bookListOf('POPULAR')),
          ),
          const SizedBox(height: 12),
          _HorizontalBookList(asyncBooks: popularAsync),
          const SizedBox(height: 28),
          _SectionHeader(
            title: '신규 도서',
            onMore: () => context.push(AppRoutes.bookListOf('RECENT')),
          ),
          const SizedBox(height: 12),
          _HorizontalBookList(asyncBooks: recentAsync),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
class _BannerSection extends StatelessWidget {
  const _BannerSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.successLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text(
          '이번 주 신규 도서를 만나보세요!',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.successDark),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onMore;
  const _SectionHeader({required this.title, this.onMore});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark)),
          GestureDetector(
            onTap: onMore,
            child: const Text('더보기',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey600)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
class _HorizontalBookList extends StatelessWidget {
  final AsyncValue<List<MainBook>> asyncBooks;
  const _HorizontalBookList({required this.asyncBooks});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: asyncBooks.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) {
          debugPrint('홈 책 목록 오류: $e\n$st');
          return Center(
            child: Text('불러오기 실패: $e',
                style: const TextStyle(color: AppColors.errorNormal)),
          );
        },
        data: (books) => books.isEmpty
            ? const Center(child: Text('도서가 없습니다.'))
            : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: books.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) => _BookCard(book: books[index]),
              ),
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  final MainBook book;
  const _BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.bookDetailOf(book.id.toString())),
      child: SizedBox(
        width: 110,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: book.bookImage.isNotEmpty
                  ? Image.network(
                      book.bookImage,
                      width: 110,
                      height: 140,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _BookImagePlaceholder(),
                    )
                  : _BookImagePlaceholder(),
            ),
            const SizedBox(height: 6),
            Text(
              book.title ?? '제목 없음',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark),
            ),
            if (book.author != null)
              Text(
                book.author!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey600),
              ),
          ],
        ),
      ),
    );
  }
}

class _BookImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 140,
      decoration: BoxDecoration(
        color: AppColors.grey300,
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Icon(Icons.book, color: AppColors.grey600, size: 36),
    );
  }
}
