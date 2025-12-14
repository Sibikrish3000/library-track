import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libarary_gen/providers/providers.dart';
import 'package:libarary_gen/models/book.dart';
import 'package:libarary_gen/repositories/book_repository.dart';
import 'package:libarary_gen/providers/book_state.dart';
import 'package:uuid/uuid.dart';

class BookNotifier extends StateNotifier<BookState> {
  BookNotifier(this._repository) : super(const BookState.initial());

  final BookRepository _repository;
  final _uuid = const Uuid();
  String _searchQuery = '';

  Future<void> loadBooks() async {
    state = const BookState.loading();

    final result = await _repository.getAllBooks();

    result.fold(
      (failure) =>
          state = BookState.error(failure.message ?? 'Failed to load books'),
      (books) {
        final sortedBooks = List<Book>.from(books)
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        state = BookState.loaded(sortedBooks);
      },
    );
  }

  Future<void> addNewBook({
    required String title,
    required String author,
    String? isbn,
    String? description,
    int? publicationYear,
    String? genre,
    String? customGenre,
    bool isFavorite = false,
    String readingStatus = 'to_read',
    String? coverUrl,
  }) async {
    final now = DateTime.now();
    final book = Book(
      id: _uuid.v4(),
      title: title,
      author: author,
      isbn: isbn,
      description: description,
      publicationYear: publicationYear,
      genre: genre,
      customGenre: customGenre,
      isFavorite: isFavorite,
      readingStatus: readingStatus,
      coverUrl: coverUrl,
      createdAt: now,
      updatedAt: now,
    );

    final result = await _repository.addBook(book);

    result.fold(
      (failure) =>
          state = BookState.error(failure.message ?? 'Failed to add book'),
      (_) => loadBooks(),
    );
  }

  Future<void> editBook({
    required String id,
    required String title,
    required String author,
    String? isbn,
    String? description,
    int? publicationYear,
    String? genre,
    String? customGenre,
    bool isFavorite = false,
    String readingStatus = 'to_read',
    required DateTime createdAt,
    String? coverUrl,
  }) async {
    final book = Book(
      id: id,
      title: title,
      author: author,
      isbn: isbn,
      description: description,
      publicationYear: publicationYear,
      genre: genre,
      customGenre: customGenre,
      isFavorite: isFavorite,
      readingStatus: readingStatus,
      coverUrl: coverUrl,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );

    final result = await _repository.updateBook(book);

    result.fold(
      (failure) =>
          state = BookState.error(failure.message ?? 'Failed to update book'),
      (_) => loadBooks(),
    );
  }

  Future<void> updateReadingStatus(Book book, String status) async {
    final updatedBook = book.copyWith(
      readingStatus: status,
      updatedAt: DateTime.now(),
    );

    final result = await _repository.updateBook(updatedBook);

    result.fold(
      (failure) =>
          state = BookState.error(failure.message ?? 'Failed to update book'),
      (_) => loadBooks(),
    );
  }

  Future<void> toggleFavorite(Book book) async {
    final updatedBook = book.copyWith(
      isFavorite: !book.isFavorite,
      updatedAt: DateTime.now(),
    );

    final result = await _repository.updateBook(updatedBook);

    result.fold(
      (failure) =>
          state = BookState.error(failure.message ?? 'Failed to update book'),
      (_) => loadBooks(),
    );
  }

  Future<void> removeBook(String id) async {
    final result = await _repository.deleteBook(id);

    result.fold(
      (failure) =>
          state = BookState.error(failure.message ?? 'Failed to delete book'),
      (_) => loadBooks(),
    );
  }

  Future<void> searchBooksWithQuery(String query) async {
    _searchQuery = query;

    if (query.isEmpty) {
      await loadBooks();
      return;
    }

    state = const BookState.loading();

    final result = await _repository.searchBooks(query);

    result.fold(
      (failure) =>
          state = BookState.error(failure.message ?? 'Failed to search books'),
      (books) {
        final sortedBooks = List<Book>.from(books)
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        state = BookState.loaded(sortedBooks);
      },
    );
  }

  String get currentSearchQuery => _searchQuery;
}

final bookNotifierProvider =
    StateNotifierProvider<BookNotifier, BookState>((ref) {
  return BookNotifier(ref.watch(bookRepositoryProvider));
});
