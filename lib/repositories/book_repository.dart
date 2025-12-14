import 'package:dartz/dartz.dart';
import 'package:libarary_gen/utils/exceptions.dart';
import 'package:libarary_gen/utils/failures.dart';
import 'package:libarary_gen/services/book_service.dart';
import 'package:libarary_gen/models/book.dart';

class BookRepository {
  BookRepository(this.service);

  final BookService service;

  Future<Either<Failure, List<Book>>> getAllBooks() async {
    try {
      final books = await service.getAllBooks();
      return Right(books);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  Future<Either<Failure, Book>> getBookById(String id) async {
    try {
      final book = await service.getBookById(id);
      if (book == null) {
        return const Left(CacheFailure('Book not found'));
      }
      return Right(book);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  Future<Either<Failure, Unit>> addBook(Book book) async {
    try {
      await service.addBook(book);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  Future<Either<Failure, Unit>> updateBook(Book book) async {
    try {
      await service.updateBook(book);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  Future<Either<Failure, Unit>> deleteBook(String id) async {
    try {
      await service.deleteBook(id);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  Future<Either<Failure, List<Book>>> searchBooks(String query) async {
    try {
      final books = await service.searchBooks(query);
      return Right(books);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
