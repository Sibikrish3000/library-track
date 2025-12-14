import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libarary_gen/models/book.dart';
import 'package:libarary_gen/repositories/book_repository.dart';
import 'package:libarary_gen/services/book_service.dart';
import 'package:libarary_gen/utils/exceptions.dart';
import 'package:libarary_gen/utils/failures.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'book_repository_test.mocks.dart';

@GenerateMocks([BookService])
void main() {
  late BookRepository repository;
  late MockBookService mockService;

  setUp(() {
    mockService = MockBookService();
    repository = BookRepository(mockService);
  });

  final tBook = Book(
    id: '1',
    title: 'Test Book',
    author: 'Test Author',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  group('getAllBooks', () {
    test('should return list of books when service call is successful',
        () async {
      // Arrange
      when(mockService.getAllBooks()).thenAnswer((_) async => [tBook]);

      // Act
      final result = await repository.getAllBooks();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return failure'),
        (r) => expect(r, [tBook]),
      );
      verify(mockService.getAllBooks());
      verifyNoMoreInteractions(mockService);
    });

    test('should return CacheFailure when service throws CacheException',
        () async {
      // Arrange
      when(mockService.getAllBooks()).thenThrow(CacheException('Error'));

      // Act
      final result = await repository.getAllBooks();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l, isA<CacheFailure>()),
        (r) => fail('Should not return success'),
      );
      verify(mockService.getAllBooks());
      verifyNoMoreInteractions(mockService);
    });
  });

  group('addBook', () {
    test('should return Unit when service call is successful', () async {
      // Arrange
      when(mockService.addBook(tBook)).thenAnswer((_) async {});

      // Act
      final result = await repository.addBook(tBook);

      // Assert
      expect(result, const Right<Failure, Unit>(unit));
      verify(mockService.addBook(tBook));
      verifyNoMoreInteractions(mockService);
    });

    test('should return CacheFailure when service throws CacheException',
        () async {
      // Arrange
      when(mockService.addBook(tBook)).thenThrow(CacheException('Error'));

      // Act
      final result = await repository.addBook(tBook);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l, isA<CacheFailure>()),
        (r) => fail('Should not return success'),
      );
      verify(mockService.addBook(tBook));
      verifyNoMoreInteractions(mockService);
    });
  });
}
