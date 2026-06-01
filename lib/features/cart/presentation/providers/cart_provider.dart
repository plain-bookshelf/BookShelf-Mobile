import 'package:bookshelf_mobile/features/book/domain/entities/book.dart';
import 'package:bookshelf_mobile/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── 더미 데이터 ──────────────────────────────
const _dummyBooks = [
  Book(
    id: '1',
    title: '오늘도 소심한 고양이',
    author: '김소심',
    genre: '소설',
    publisher: '책마루출판사',
    publishYear: 2024,
    status: BookStatus.available,
  ),
  Book(
    id: '2',
    title: '파친코',
    author: '이민진',
    genre: '소설',
    publisher: '문학사상',
    publishYear: 2022,
    status: BookStatus.available,
  ),
  Book(
    id: '3',
    title: '채식주의자',
    author: '한강',
    genre: '소설',
    publisher: '창비',
    publishYear: 2007,
    status: BookStatus.rented,
  ),
];

/// 장바구니 Notifier
class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() => _dummyBooks
      .map((book) => CartItem(book: book, isSelected: book.isAvailable))
      .toList();

  bool get allSelected => state.every((item) => item.isSelected);
  int get selectedCount => state.where((item) => item.isSelected).length;

  void toggleItem(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          state[i].copyWith(isSelected: !state[i].isSelected)
        else
          state[i],
    ];
  }

  void toggleAll({required bool selected}) {
    state = state.map((item) => item.copyWith(isSelected: selected)).toList();
  }

  void removeItem(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i],
    ];
  }
}

final cartProvider =
    NotifierProvider<CartNotifier, List<CartItem>>(CartNotifier.new);
