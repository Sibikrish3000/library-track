import 'package:hive_flutter/hive_flutter.dart';
import 'package:libarary_gen/models/book.dart';
import 'package:libarary_gen/utils/exceptions.dart';

abstract class BookService {
  Future<List<Book>> getAllBooks();
  Future<Book?> getBookById(String id);
  Future<void> addBook(Book book);
  Future<void> updateBook(Book book);
  Future<void> deleteBook(String id);
  Future<List<Book>> searchBooks(String query);
}

class BookServiceImpl implements BookService {
  BookServiceImpl(this._box);

  final Box<Book> _box;

  @override
  Future<List<Book>> getAllBooks() async {
    try {
      return _box.values.toList();
    } catch (e) {
      throw CacheException('Failed to load books: $e');
    }
  }

  @override
  Future<Book?> getBookById(String id) async {
    try {
      return _box.get(id);
    } catch (e) {
      throw CacheException('Failed to load book: $e');
    }
  }

  @override
  Future<void> addBook(Book book) async {
    try {
      await _box.put(book.id, book);
    } catch (e) {
      throw CacheException('Failed to add book: $e');
    }
  }

  @override
  Future<void> updateBook(Book book) async {
    try {
      await _box.put(book.id, book);
    } catch (e) {
      throw CacheException('Failed to update book: $e');
    }
  }

  @override
  Future<void> deleteBook(String id) async {
    try {
      await _box.delete(id);
    } catch (e) {
      throw CacheException('Failed to delete book: $e');
    }
  }

  @override
  Future<List<Book>> searchBooks(String query) async {
    try {
      final books = _box.values.toList();
      if (query.isEmpty) return books;

      final lowercaseQuery = query.toLowerCase();
      return books.where((book) {
        return book.title.toLowerCase().contains(lowercaseQuery) ||
            book.author.toLowerCase().contains(lowercaseQuery) ||
            (book.isbn?.toLowerCase().contains(lowercaseQuery) ?? false);
      }).toList();
    } catch (e) {
      throw CacheException('Failed to search books: $e');
    }
  }
}
