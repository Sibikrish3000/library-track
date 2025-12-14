import 'package:flutter/material.dart';
import 'package:libarary_gen/models/book.dart';

class BookCard extends StatelessWidget {
  const BookCard({
    required this.book,
    required this.onTap,
    this.onDelete,
    this.onToggleFavorite,
    this.isGridView = false,
    super.key,
  });

  final Book book;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleFavorite;
  final bool isGridView;

  String _getStatusText(String status) {
    switch (status) {
      case 'reading':
        return 'Reading';
      case 'completed':
        return 'Completed';
      case 'to_read':
      default:
        return 'To Read';
    }
  }

  Color _getStatusColor(BuildContext context, String status) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case 'reading':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'to_read':
      default:
        return colorScheme.onSurface.withOpacity(0.6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayGenre = book.genre == 'custom' && book.customGenre != null
        ? book.customGenre!
        : book.genre ?? '';

    if (isGridView) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: book.coverUrl != null
                          ? Image.network(
                              book.coverUrl!,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => Container(
                                color: theme.colorScheme.surfaceContainerHighest,
                                child: const Center(child: Icon(Icons.book, size: 40)),
                              ),
                            )
                          : Container(
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: const Center(child: Icon(Icons.book, size: 40)),
                            ),
                    ),
                    if (onToggleFavorite != null)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              book.isFavorite ? Icons.favorite : Icons.favorite_border,
                              size: 20,
                              color: book.isFavorite ? Colors.red : Colors.white,
                            ),
                            onPressed: onToggleFavorite,
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(8),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: theme.textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.author,
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover Image
              Container(
                width: 60,
                height: 90,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: book.coverUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          book.coverUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => const Icon(Icons.book),
                        ),
                      )
                    : const Icon(Icons.book),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            book.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (onToggleFavorite != null)
                          IconButton(
                            icon: Center(
                              child: Icon(
                                book.isFavorite ? Icons.favorite : Icons.favorite_border,
                                size: 20,
                                color: book.isFavorite ? theme.colorScheme.error : theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            onPressed: onToggleFavorite,
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                          )
                        else if (book.isFavorite)
                          Icon(
                            Icons.favorite,
                            size: 16,
                            color: theme.colorScheme.error,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.author,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (displayGenre.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              displayGenre,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _getStatusColor(context, book.readingStatus),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getStatusText(book.readingStatus),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: _getStatusColor(context, book.readingStatus),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: onDelete,
                  color: theme.colorScheme.error,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
