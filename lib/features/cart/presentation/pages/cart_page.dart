import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/widgets/app_bottom_nav_bar.dart';
import 'package:bookshelf_mobile/features/cart/domain/entities/cart_item.dart';
import 'package:bookshelf_mobile/features/cart/presentation/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    final notifier = ref.read(cartProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: items.isEmpty
          ? const Center(
              child: Text('장바구니가 비어있습니다.',
                  style: TextStyle(fontSize: 14, color: AppColors.grey500)),
            )
          : Column(
              children: [
                _SelectAllRow(
                  allSelected: notifier.allSelected,
                  onChanged: (v) => notifier.toggleAll(selected: v ?? false),
                ),
                const Divider(height: 1, color: AppColors.borderLight),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: items.length,
                    separatorBuilder: (_, _) =>
                        const Divider(height: 1, color: AppColors.borderLight),
                    itemBuilder: (context, index) => _CartItemTile(
                      item: items[index],
                      onChanged: (_) => notifier.toggleItem(index),
                      onRemove: () => notifier.removeItem(index),
                    ),
                  ),
                ),
                _RentalButton(count: notifier.selectedCount),
              ],
            ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 20,
      title: const Text(
        '장바구니',
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark),
      ),
    );
  }
}

// ─────────────────────────────────────────
// 전체 선택 행
// ─────────────────────────────────────────
class _SelectAllRow extends StatelessWidget {
  final bool allSelected;
  final ValueChanged<bool?> onChanged;

  const _SelectAllRow({required this.allSelected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Checkbox(
            value: allSelected,
            onChanged: onChanged,
            activeColor: AppColors.successNormal,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          const Text('전체 선택',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// 카트 아이템 타일
// ─────────────────────────────────────────
class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onRemove;

  const _CartItemTile({
    required this.item,
    required this.onChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Checkbox(
            value: item.isSelected,
            onChanged: onChanged,
            activeColor: AppColors.successNormal,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(width: 4),
          Container(
            width: 52,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.book.title,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark)),
                const SizedBox(height: 4),
                Text(item.book.author,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.grey600)),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.close, size: 18, color: AppColors.grey500),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// 대여 신청 버튼
// ─────────────────────────────────────────
class _RentalButton extends StatelessWidget {
  final int count;
  const _RentalButton({required this.count});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: count == 0 ? null : () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.successNormal,
              disabledBackgroundColor: AppColors.grey300,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: Text(
              count == 0 ? '대여 신청' : '대여 신청 ($count권)',
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white),
            ),
          ),
        ),
      ),
    );
  }
}
