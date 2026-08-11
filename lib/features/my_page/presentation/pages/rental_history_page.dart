import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/network/api_error.dart';
import 'package:bookshelf_mobile/features/my_page/presentation/providers/my_page_provider.dart';
import 'package:bookshelf_mobile/features/my_page/presentation/widgets/lending_list.dart';
import 'package:bookshelf_mobile/features/my_page/presentation/widgets/lending_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
          child: Text(
            parseApiErrorMessage(e, fallback: '대여 정보를 불러오지 못했습니다.'),
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.errorNormal),
          ),
        ),
        data: (info) => TabBarView(
          controller: _tabController,
          children: [
            LendingList(books: info.rentals, tab: LendingTab.rental),
            LendingList(books: info.reservations, tab: LendingTab.reservation),
            LendingList(books: info.overdues, tab: LendingTab.overdue),
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
        child: const Icon(
          Icons.arrow_back_ios_new,
          size: 18,
          color: Color(0xFF7E7E7E),
        ),
      ),
      bottom: TabBar(
        controller: _tabController,
        labelColor: AppColors.successNormal,
        unselectedLabelColor: AppColors.grey500,
        indicatorColor: AppColors.successNormal,
        indicatorWeight: 2,
        labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        tabs: _tabs.map((t) => Tab(text: t)).toList(),
      ),
    );
  }
}
