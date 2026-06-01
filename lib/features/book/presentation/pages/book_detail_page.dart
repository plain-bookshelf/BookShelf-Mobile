import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/constants/app_text_styles.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/features/book/data/models/book_detail_model.dart';
import 'package:bookshelf_mobile/features/book/domain/entities/book.dart';
import 'package:bookshelf_mobile/features/book/domain/entities/review.dart';
import 'package:bookshelf_mobile/features/book/presentation/providers/book_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ── 상수 ─────────────────────────────────────────────────────────────────────
const _coverHeight = 280.0;
const _descriptionMaxLines = 4;
const _reviewPreviewCount = 4;

// ── BookDetailPage ────────────────────────────────────────────────────────────
class BookDetailPage extends ConsumerStatefulWidget {
  final String bookId;

  const BookDetailPage({super.key, required this.bookId});

  @override
  ConsumerState<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends ConsumerState<BookDetailPage> {
  // 토스트 메시지 변화 감지 후 SnackBar 표시
  void _onStateChanged(BookDetailState? prev, BookDetailState next) {
    final message = next.toastMessage;
    if (message == null) return;
    if (prev?.toastMessage == message) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppTextStyles.caption1.copyWith(color: AppColors.white)),
        backgroundColor: AppColors.textDark,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: '클리어하여 닫기',
          textColor: AppColors.grey400,
          onPressed: () {
            ref.read(bookDetailProvider(widget.bookId).notifier).clearToast();
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
    // 표시 후 상태에서 토스트 초기화
    ref.read(bookDetailProvider(widget.bookId).notifier).clearToast();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<BookDetailState>(
      bookDetailProvider(widget.bookId),
      _onStateChanged,
    );

    final state = ref.watch(bookDetailProvider(widget.bookId));
    final notifier = ref.read(bookDetailProvider(widget.bookId).notifier);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _DetailAppBar(
        title: state.book?.title ?? '',
        isWishlisted: state.isWishlisted,
        onBack: () => context.pop(),
        onToggleWishlist: notifier.toggleWishlist,
      ),
      body: switch (state.status) {
        BookDetailStatus.loading => const _LoadingBody(),
        BookDetailStatus.failure => const _FailureBody(),
        BookDetailStatus.loaded => _LoadedBody(
            state: state,
            bookId: widget.bookId,
            onToggleDescription: notifier.toggleDescription,
            onToggleReviewLike: notifier.toggleReviewLike,
          ),
      },
      bottomNavigationBar: state.book != null
          ? _ActionBar(
              book: state.book!,
              onRental: notifier.requestRental,
              onReservation: notifier.requestReservation,
            )
          : null,
    );
  }
}

// ── AppBar ────────────────────────────────────────────────────────────────────
class _DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isWishlisted;
  final VoidCallback onBack;
  final VoidCallback onToggleWishlist;

  const _DetailAppBar({
    required this.title,
    required this.isWishlisted,
    required this.onBack,
    required this.onToggleWishlist,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: GestureDetector(
        onTap: onBack,
        child: const Icon(
          Icons.arrow_back_ios_new,
          size: 18,
          color: AppColors.grey600,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.body2SemiBold,
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        IconButton(
          onPressed: onToggleWishlist,
          icon: Icon(
            isWishlisted ? Icons.favorite : Icons.favorite_border,
            color: isWishlisted ? AppColors.errorNormal : AppColors.grey600,
            size: 22,
          ),
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppColors.borderLight),
      ),
    );
  }
}

// ── Loading / Failure ─────────────────────────────────────────────────────────
class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) => const Center(
        child: CircularProgressIndicator(color: AppColors.successNormal),
      );
}

class _FailureBody extends StatelessWidget {
  const _FailureBody();

  @override
  Widget build(BuildContext context) => const Center(
        child: Text('도서 정보를 불러올 수 없습니다.', style: AppTextStyles.caption1),
      );
}

// ── Loaded Body ───────────────────────────────────────────────────────────────
class _LoadedBody extends StatelessWidget {
  final BookDetailState state;
  final String bookId;
  final VoidCallback onToggleDescription;
  final ValueChanged<String> onToggleReviewLike;

  const _LoadedBody({
    required this.state,
    required this.bookId,
    required this.onToggleDescription,
    required this.onToggleReviewLike,
  });

  @override
  Widget build(BuildContext context) {
    final book = state.book!;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 도서 표지
          _CoverSection(coverUrl: book.coverUrl),
          // 도서 기본 정보
          _MetaSection(book: book, detail: state.detail),
          const Divider(height: 1, color: AppColors.borderLight),
          // 줄거리
          _DescriptionSection(
            description: book.description ?? '줄거리 정보가 없습니다.',
            isExpanded: state.isDescriptionExpanded,
            onToggle: onToggleDescription,
          ),
          const Divider(height: 1, color: AppColors.borderLight),
          // 리뷰
          _ReviewSection(
            reviews: state.reviews,
            onLike: onToggleReviewLike,
            onViewAll: () =>
                context.push(AppRoutes.bookReviewsOf(bookId)),
          ),
          const Divider(height: 1, color: AppColors.borderLight),
          // 추천 도서
          _RecommendationSection(books: state.recommendations),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── 도서 표지 ─────────────────────────────────────────────────────────────────
class _CoverSection extends StatelessWidget {
  final String? coverUrl;

  const _CoverSection({this.coverUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: _coverHeight,
      color: AppColors.grey100,
      child: coverUrl != null
          ? Image.network(
              coverUrl!,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const _CoverPlaceholder(),
            )
          : const _CoverPlaceholder(),
    );
  }
}

class _CoverPlaceholder extends StatelessWidget {
  const _CoverPlaceholder();

  @override
  Widget build(BuildContext context) => const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.book_outlined, size: 56, color: AppColors.grey400),
        ],
      );
}

// ── 도서 기본 정보 ─────────────────────────────────────────────────────────────
class _MetaSection extends StatelessWidget {
  final Book book;
  final BookDetailModel? detail;

  const _MetaSection({required this.book, this.detail});

  @override
  Widget build(BuildContext context) {
    final genres = detail?.genres ?? [];
    final publicationDate = detail?.bookInfo.publicationDate ?? '';
    final affiliationName = detail?.affiliationName ?? '';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목
          Text(book.title, style: AppTextStyles.heading3),
          const SizedBox(height: 6),
          // 저자
          Text(book.author, style: AppTextStyles.caption1),
          const SizedBox(height: 4),
          // 출판사 • 출판일
          Text(
            [
              if (book.publisher.isNotEmpty) book.publisher,
              if (publicationDate.isNotEmpty) publicationDate,
            ].join(' • '),
            style: AppTextStyles.caption2,
          ),
          if (affiliationName.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(affiliationName, style: AppTextStyles.caption2),
          ],
          // 장르 chip
          if (genres.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: genres
                  .map((g) => _GenreChip(label: g.genreName))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _GenreChip extends StatelessWidget {
  final String label;
  const _GenreChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.grey700,
        ),
      ),
    );
  }
}

// ── 줄거리 ────────────────────────────────────────────────────────────────────
class _DescriptionSection extends StatelessWidget {
  final String description;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _DescriptionSection({
    required this.description,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('줄거리', style: AppTextStyles.body1SemiBold),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.grey700,
              height: 1.7,
            ),
            maxLines: isExpanded ? null : _descriptionMaxLines,
            overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onToggle,
            child: Text(
              isExpanded ? '접기' : '전체보기',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.grey500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 리뷰 ──────────────────────────────────────────────────────────────────────
class _ReviewSection extends StatelessWidget {
  final List<Review> reviews;
  final ValueChanged<String> onLike;
  final VoidCallback onViewAll;

  const _ReviewSection({
    required this.reviews,
    required this.onLike,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final preview = reviews.take(_reviewPreviewCount).toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('리뷰', style: AppTextStyles.body1SemiBold),
          const SizedBox(height: 4),
          ...preview.map(
            (r) => _ReviewItem(review: r, onLike: () => onLike(r.id)),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: onViewAll,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  '전체보기',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final Review review;
  final VoidCallback onLike;

  const _ReviewItem({required this.review, required this.onLike});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  review.reviewerName,
                  style: AppTextStyles.body2SemiBold,
                ),
              ),
              // 좋아요 수 + 하트
              GestureDetector(
                onTap: onLike,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (review.likeCount > 0) ...[
                      Text(
                        '${review.likeCount}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: review.isLiked
                              ? AppColors.successNormal
                              : AppColors.grey500,
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                    Icon(
                      review.isLiked
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 18,
                      color: review.isLiked
                          ? AppColors.successNormal
                          : AppColors.grey400,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(review.content, style: AppTextStyles.caption1),
        ],
      ),
    );
  }
}

// ── 추천 도서 ─────────────────────────────────────────────────────────────────
class _RecommendationSection extends StatelessWidget {
  final List<Book> books;

  const _RecommendationSection({required this.books});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 20),
            child: Text('추천', style: AppTextStyles.body1SemiBold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 20),
              itemCount: books.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) =>
                  _RecommendCard(book: books[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendCard extends StatelessWidget {
  final Book book;

  const _RecommendCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.bookDetailOf(book.id)),
      child: SizedBox(
        width: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 표지
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.grey200,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: book.coverUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          book.coverUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              const Icon(Icons.book_outlined,
                                  color: AppColors.grey400, size: 28),
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.book_outlined,
                            color: AppColors.grey400, size: 28),
                      ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              book.title,
              style: AppTextStyles.caption2,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ── 하단 액션 바 ───────────────────────────────────────────────────────────────
class _ActionBar extends StatelessWidget {
  final Book book;
  final Future<void> Function() onRental;
  final Future<void> Function() onReservation;

  const _ActionBar({
    required this.book,
    required this.onRental,
    required this.onReservation,
  });

  @override
  Widget build(BuildContext context) {
    final isAvailable = book.status == BookStatus.available;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.borderLight)),
        ),
        child: SizedBox(
          height: 52,
          width: double.infinity,
          child: isAvailable
              ? ElevatedButton(
                  onPressed: onRental,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.successNormal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('대여 요청', style: AppTextStyles.button),
                )
              : OutlinedButton(
                  onPressed: onReservation,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.successNormal),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    '예약',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.successNormal,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
