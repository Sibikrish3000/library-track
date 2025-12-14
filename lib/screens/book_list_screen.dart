import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libarary_gen/models/book.dart';
import 'package:libarary_gen/providers/book_provider.dart';
import 'package:libarary_gen/screens/book_details_screen.dart';
import 'package:libarary_gen/screens/book_form_screen.dart';
import 'package:libarary_gen/screens/settings_screen.dart';
import 'package:libarary_gen/widgets/book_card.dart';
import 'package:libarary_gen/widgets/empty_state.dart';

class BookListScreen extends ConsumerStatefulWidget {
  const BookListScreen({super.key});

  @override
  ConsumerState<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends ConsumerState<BookListScreen> {
  final _searchController = TextEditingController();
  Book? _recentlyDeletedBook;
  bool _isGridView = false;
  String _sortBy = 'date_added'; // date_added, title, author
  String _filterStatus = 'all'; // all, to_read, reading, completed

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(bookNotifierProvider.notifier).loadBooks());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    ref.read(bookNotifierProvider.notifier).searchBooksWithQuery(query);
  }

  Future<void> _navigateToAddBook() async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => const BookFormScreen(),
      ),
    );
  }

  Future<void> _navigateToBookDetails(Book book) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailsScreen(book: book),
      ),
    );
  }

  Future<void> _deleteBook(Book book) async {
    setState(() {
      _recentlyDeletedBook = book;
    });

    await ref.read(bookNotifierProvider.notifier).removeBook(book.id);

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.bookDeleted),
          action: SnackBarAction(
            label: l10n.undo,
            onPressed: _undoDelete,
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _recentlyDeletedBook = null;
        });
      }
    });
  }

  Future<void> _undoDelete() async {
    if (_recentlyDeletedBook != null) {
      await ref.read(bookNotifierProvider.notifier).addNewBook(
            title: _recentlyDeletedBook!.title,
            author: _recentlyDeletedBook!.author,
            isbn: _recentlyDeletedBook!.isbn,
            description: _recentlyDeletedBook!.description,
            publicationYear: _recentlyDeletedBook!.publicationYear,
            genre: _recentlyDeletedBook!.genre,
            customGenre: _recentlyDeletedBook!.customGenre,
            isFavorite: _recentlyDeletedBook!.isFavorite,
            readingStatus: _recentlyDeletedBook!.readingStatus,
            coverUrl: _recentlyDeletedBook!.coverUrl,
          );
      setState(() {
        _recentlyDeletedBook = null;
      });
    }
  }

  List<Book> _processBooks(List<Book> books) {
    var processed = List<Book>.from(books);

    // Filter
    if (_filterStatus != 'all') {
      processed =
          processed.where((b) => b.readingStatus == _filterStatus).toList();
    }

    // Sort
    processed.sort((a, b) {
      switch (_sortBy) {
        case 'title':
          return a.title.compareTo(b.title);
        case 'author':
          return a.author.compareTo(b.author);
        case 'date_added':
        default:
          return b.createdAt.compareTo(a.createdAt);
      }
    });

    return processed;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bookState = ref.watch(bookNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                  value: 'date_added', child: Text('Date Added'),),
              const PopupMenuItem(value: 'title', child: Text('Title')),
              const PopupMenuItem(value: 'author', child: Text('Author')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: SearchBar(
                    controller: _searchController,
                    hintText: l10n.searchBooks,
                    leading: const Icon(Icons.search),
                    onChanged: _onSearchChanged,
                    elevation: WidgetStateProperty.all(0),
                    backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.filter_list),
                  onSelected: (value) {
                    setState(() {
                      _filterStatus = value;
                    });
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'all', child: Text('All')),
                    PopupMenuItem(value: 'to_read', child: Text(l10n.toRead)),
                    PopupMenuItem(value: 'reading', child: Text(l10n.reading)),
                    PopupMenuItem(
                        value: 'completed', child: Text(l10n.completed),),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: bookState.when(
        initial: () => const SizedBox.shrink(),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (message) => Center(child: Text(message)),
        loaded: (books) {
          final processedBooks = _processBooks(books);

          if (processedBooks.isEmpty) {
            return EmptyState(
              title: l10n.noBooksFound,
              message: l10n.addBookPrompt,
            );
          }

          if (_isGridView) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: processedBooks.length,
              itemBuilder: (context, index) {
                final book = processedBooks[index];
                return BookCard(
                  book: book,
                  isGridView: true,
                  onTap: () => _navigateToBookDetails(book),
                  onDelete: () => _deleteBook(book),
                  onToggleFavorite: () => ref
                      .read(bookNotifierProvider.notifier)
                      .toggleFavorite(book),
                );
              },
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: processedBooks.length,
            itemBuilder: (context, index) {
              final book = processedBooks[index];
              return BookCard(
                book: book,
                onTap: () => _navigateToBookDetails(book),
                onDelete: () => _deleteBook(book),
                onToggleFavorite: () => ref
                    .read(bookNotifierProvider.notifier)
                    .toggleFavorite(book),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddBook,
        child: const Icon(Icons.add),
      ),
    );
  }
}
