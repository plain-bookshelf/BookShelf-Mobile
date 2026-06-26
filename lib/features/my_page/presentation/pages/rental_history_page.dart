import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/features/my_page/domain/entities/lending_info.dart';
import 'package:bookshelf_mobile/features/my_page/presentation/providers/my_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ── 탭 종류 ───────────────────────────────────────────────────────────────────
enum _LendingTab { rental, reservation, overdue }

// ── RentalHistoryPage ─────────────────────────────────────────────────────────
class RentalHistoryPage extends ConsumerStatefulWidget {
  const RentalHistoryPage({super.key});

  @override
  ConsumerState<RentalHistoryPage> createState() => _RentalHistoryPageState();
}

class _RentalHistoryPageState extends ConsumerState<RentalHistoryPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _tabs = ['대여', '예약', '연체'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncInfo = ref.watch(lendingInfoProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: asyncInfo.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('불러오기 실패: $e',
              style: const TextStyle(color: AppColors.errorNormal)),
        ),
        data: (info) => TabBarView(
          controller: _tabController,
          children: [
            _LendingList(books: info.rentals, tab: _LendingTab.rental),
            _LendingList(books: info.reservations, tab: _LendingTab.reservation),
            _LendingList(books: info.overdues, tab: _LendingTab.overdue),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => context.pop(),
        child: const Icon(Icons.arrow_back_ios_new,
            size: 18, color: Color(0xFF7E7E7E)),
      ),
      bottom: TabBar(
        controller: _tabController,
        labelColor: AppColors.successNormal,
        unselectedLabelColor: AppColors.grey500,
        indicatorColor: AppColors.successNormal,
        indicatorWeight: 2,
        labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
        tabs: _tabs.map((t) => Tab(text: t)).toList(),
      ),
    );
  }
}

// ── 리스트 ────────────────────────────────────────────────────────────────────
class _LendingList extends StatelessWidget {
  final List<LendingBook> books;
  final _LendingTab tab;

  const _LendingList({required this.books, required this.tab});

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return const Center(
        child: Text('내역이 없습니다.',
            style: TextStyle(fontSize: 14, color: AppColors.grey500)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: books.length,
      separatorBuilder: (_, _) =>
          const Divider(height: 24, color: AppColors.borderLight),
      itemBuilder: (_, index) => _LendingItem(book: books[index], tab: tab),
    );
  }
}

// ── 아이템 ────────────────────────────────────────────────────────────────────
class _LendingItem extends StatelessWidget {
  final LendingBook book;
  final _LendingTab tab;

  const _LendingItem({required this.book, required this.tab});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 표지 썸네일
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: book.bookImage.isNotEmpty
              ? Image.network(
                  book.bookImage,
                  width: 56,
                  height: 76,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const _CoverPlaceholder(),
                )
              : const _CoverPlaceholder(),
        ),
        const SizedBox(width: 16),
        // 제목
        Expanded(
          child: Text(
            book.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ),
        const SizedBox(width: 12),
        // 우측 배지
        _LendingBadge(book: book, tab: tab),
      ],
    );
  }
}

class _CoverPlaceholder extends StatelessWidget {
  const _CoverPlaceholder();

  @override
  Widget build(BuildContext context) => Container(
        width: 56,
        height: 76,
        decoration: BoxDecoration(
          color: AppColors.grey300,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(Icons.book, color: AppColors.grey600, size: 24),
      );
}

// ── 배지 ──────────────────────────────────────────────────────────────────────
class _LendingBadge extends StatelessWidget {
  final LendingBook book;
  final _LendingTab tab;

  // 경고(임박) 색상 — AppColors에 warning 없어서 인라인 정의
  static const _warnBg = Color(0xFFFFF3E0);
  static const _warnFg = Color(0xFFD97706);

  const _LendingBadge({required this.book, required this.tab});

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    final String label;

    switch (tab) {
      case _LendingTab.rental:
        final d = book.leftRentalDate ?? 0;
        if (d <= 0) {
          bg = _warnBg;
          fg = _warnFg;
          label = '오늘 반납';
        } else if (d <= 3) {
          bg = _warnBg;
          fg = _warnFg;
          label = 'D-$d';
        } else {
          bg = AppColors.successLight;
          fg = AppColors.successDark;
          label = 'D-$d';
        }
      case _LendingTab.reservation:
        bg = AppColors.successLight;
        fg = AppColors.successDark;
        label = '${book.rank ?? '-'}번째 대기';
      case _LendingTab.overdue:
        bg = AppColors.errorLight;
        fg = AppColors.errorNormal;
        label = '연체 ${book.overdueDate ?? 0}일';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}
