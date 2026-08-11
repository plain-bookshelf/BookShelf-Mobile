import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/features/search/domain/entities/search_book.dart';
import 'package:bookshelf_mobile/features/search/presentation/widgets/cover_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookCard extends StatelessWidget {
  final SearchBook book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.bookDetailOf(book.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: book.imageUrl.isNotEmpty
                  ? Image.network(
                      book.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const CoverPlaceholder(),
                    )
                  : const CoverPlaceholder(),
            ),
          ),
        ],
      ),
    );
  }
}
