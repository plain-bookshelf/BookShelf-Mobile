import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/features/my_page/domain/entities/rental.dart';
import 'package:bookshelf_mobile/features/book/domain/entities/book.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ── 더미 데이터 ──────────────────────────────────────────────────────────────
// DateTime은 const 불가 → final 리스트
final _dummyRentals = [
  Rental(
    id: '1',
    book: const Book(
      id: '1', title: '오늘도 소심한 고양이', author: '김소심',
      genre: '소설', publisher: '책마루출판사', publishYear: 2024,
      status: BookStatus.available,
    ),
    status: RentalStatus.renting,
    dueDate: DateTime(2026, 5, 30), // 3일 남음
  ),
  Rental(
    id: '2',
    book: const Book(
      id: '2', title: '파친코', author: '이민진',
      genre: '소설', publisher: '문학사상', publishYear: 2022,
      status: BookStatus.available,
    ),
    status: RentalStatus.renting,
    dueDate: DateTime(2026, 5, 24), // 연체 3일
  ),
  Rental(
    id: '3',
    book: const Book(
      id: '3', title: '채식주의자', author: '한강',
      genre: '소설', publisher: '창비', publishYear: 2007,
      status: BookStatus.rented,
    ),
    status: RentalStatus.reserved,
    dueDate: DateTime(2026, 6, 3), // 픽업 기한 7일 남음
  ),
  Rental(
    id: '4',
    book: const Book(
      id: '4', title: '아몬드', author: '손원평',
      genre: '소설', publisher: '창비', publishYear: 2017,
      status: BookStatus.available,
    ),
    status: RentalStatus.returned,
  ),
  Rental(
    id: '5',
    book: const Book(
      id: '5', title: '82년생 김지영', author: '조남주',
      genre: '소설', publisher: '민음사', publishYear: 2016,
      status: BookStatus.available,
    ),
    status: RentalStatus.returned,
  ),
];

// ── RentalHistoryPage ─────────────────────────────────────────────────────────
class RentalHistoryPage extends StatefulWidget {
  const RentalHistoryPage({super.key});

  @override
  State<RentalHistoryPage> createState() => _RentalHistoryPageState();
}

class _RentalHistoryPageState extends State<RentalHistoryPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _tabs = ['대여', '예약', '반납'];

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

  List<Rental> _rentals(RentalStatus status) =>
      _dummyRentals.where((r) => r.status == status).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: TabBarView(
        controller: _tabController,
        children: [
          _RentalList(rentals: _rentals(RentalStatus.renting)),
          _RentalList(rentals: _rentals(RentalStatus.reserved)),
          _RentalList(rentals: _rentals(RentalStatus.returned)),
        ],
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
        labelStyle:
            const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
        tabs: _tabs.map((t) => Tab(text: t)).toList(),
      ),
    );
  }
}

// ── 리스트 ────────────────────────────────────────────────────────────────────
class _RentalList extends StatelessWidget {
  final List<Rental> rentals;
  const _RentalList({required this.rentals});

  @override
  Widget build(BuildContext context) {
    if (rentals.isEmpty) {
      return const Center(
        child: Text('내역이 없습니다.',
            style: TextStyle(fontSize: 14, color: AppColors.grey500)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: rentals.length,
      separatorBuilder: (_, _) =>
          const Divider(height: 24, color: AppColors.borderLight),
      itemBuilder: (_, index) => _RentalItem(rental: rentals[index]),
    );
  }
}

// ── 대여 아이템 ───────────────────────────────────────────────────────────────
class _RentalItem extends StatelessWidget {
  final Rental rental;
  const _RentalItem({required this.rental});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 표지 썸네일
        Container(
          width: 56,
          height: 76,
          decoration: BoxDecoration(
            color: AppColors.grey300,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 16),
        // 제목 · 저자 · 반납일
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rental.book.title,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark),
              ),
              const SizedBox(height: 4),
              Text(
                rental.book.author,
                style: const TextStyle(fontSize: 13, color: AppColors.grey600),
              ),
              if (rental.dueDate != null) ...[
                const SizedBox(height: 6),
                Text(
                  '반납일 ${_formatDate(rental.dueDate!)}',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.grey500),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        // 우측: 남은 일수 배지 or 찜 아이콘
        if (rental.daysLeft != null)
          _DueDateBadge(daysLeft: rental.daysLeft!)
        else if (rental.status == RentalStatus.returned)
          const Icon(Icons.favorite_border,
              color: AppColors.successNormal, size: 22),
      ],
    );
  }

  String _formatDate(DateTime date) => '${date.month}월 ${date.day}일';
}

// ── 남은 일수 배지 ─────────────────────────────────────────────────────────────
class _DueDateBadge extends StatelessWidget {
  final int daysLeft;

  // 경고(3일 이하) 색상 — AppColors에 warning 없어서 인라인 정의
  static const _warnBg = Color(0xFFFFF3E0);
  static const _warnFg = Color(0xFFD97706);

  const _DueDateBadge({required this.daysLeft});

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    final String label;

    if (daysLeft < 0) {
      // 연체
      bg = AppColors.errorLight;
      fg = AppColors.errorNormal;
      label = '연체 ${-daysLeft}일';
    } else if (daysLeft == 0) {
      // 오늘 반납
      bg = _warnBg;
      fg = _warnFg;
      label = '오늘 반납';
    } else if (daysLeft <= 3) {
      // 3일 이하 임박
      bg = _warnBg;
      fg = _warnFg;
      label = 'D-$daysLeft';
    } else {
      // 여유 있음
      bg = AppColors.successLight;
      fg = AppColors.successDark;
      label = 'D-$daysLeft';
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
