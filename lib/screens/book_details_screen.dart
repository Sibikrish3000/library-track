import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libarary_gen/models/book.dart';
import 'package:libarary_gen/providers/book_provider.dart';
import 'package:libarary_gen/screens/book_form_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookDetailsScreen extends ConsumerWidget {
  const BookDetailsScreen({
    required this.book,
    this.isPreview = false,
    this.onAdd,
    super.key,
  });

  final Book book;
  final bool isPreview;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // Watch for updates to this specific book
    final currentBook = isPreview 
        ? book 
        : ref.watch(bookNotifierProvider).maybeWhen(
            loaded: (books) => books.firstWhere(
              (b) => b.id == book.id,
              orElse: () => book,
            ),
            orElse: () => book,
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(currentBook.title),
        actions: [
          if (!isPreview)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookFormScreen(book: currentBook),
                  ),
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 250,
                width: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: currentBook.coverUrl != null
                      ? Image.network(
                          currentBook.coverUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.book, size: 50, color: Colors.grey),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.book, size: 50, color: Colors.grey),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              currentBook.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              currentBook.author,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.secondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (currentBook.publicationYear != null)
                  Chip(
                    label: Text(currentBook.publicationYear.toString()),
                    avatar: const Icon(Icons.calendar_today, size: 16),
                  ),
                const SizedBox(width: 8),
                if (currentBook.genre != null)
                  Chip(
                    label: Text(currentBook.genre!),
                    avatar: const Icon(Icons.category, size: 16),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            if (!isPreview) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () => _showStatusPicker(context, ref, currentBook, l10n),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Icon(Icons.bookmark),
                              const SizedBox(height: 4),
                              Text(
                                _getReadingStatusText(currentBook.readingStatus, l10n),
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => ref.read(bookNotifierProvider.notifier).toggleFavorite(currentBook),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(
                                currentBook.isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: currentBook.isFavorite ? Colors.red : null,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.favorite,
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
            Text(
              l10n.description,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              currentBook.description ?? 'No description available.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            if (currentBook.isbn != null) ...[
              Text(
                l10n.isbn,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                currentBook.isbn!,
                style: theme.textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: isPreview
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FilledButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                  label: const Text('Add to Library'),
                ),
              ),
            )
          : null,
    );
  }

  void _showStatusPicker(BuildContext context, WidgetRef ref, Book book, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.bookmark_border),
            title: Text(l10n.toRead),
            selected: book.readingStatus == 'to_read',
            onTap: () {
              ref.read(bookNotifierProvider.notifier).updateReadingStatus(book, 'to_read');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: Text(l10n.reading),
            selected: book.readingStatus == 'reading',
            onTap: () {
              ref.read(bookNotifierProvider.notifier).updateReadingStatus(book, 'reading');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: Text(l10n.completed),
            selected: book.readingStatus == 'completed',
            onTap: () {
              ref.read(bookNotifierProvider.notifier).updateReadingStatus(book, 'completed');
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  String _getReadingStatusText(String status, AppLocalizations l10n) {
    switch (status) {
      case 'reading':
        return l10n.reading;
      case 'completed':
        return l10n.completed;
      case 'to_read':
      default:
        return l10n.toRead;
    }
  }
}
