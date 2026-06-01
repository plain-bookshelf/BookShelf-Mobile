import 'package:bookshelf_mobile/features/book/domain/entities/book.dart';

/// 장바구니 아이템 도메인 엔티티
class CartItem {
  final Book book;
  final bool isSelected;

  const CartItem({required this.book, this.isSelected = true});

  CartItem copyWith({Book? book, bool? isSelected}) => CartItem(
        book: book ?? this.book,
        isSelected: isSelected ?? this.isSelected,
      );
}
