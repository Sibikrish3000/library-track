import 'package:flutter_test/flutter_test.dart';
import 'package:libarary_gen/utils/validators.dart';

void main() {
  group('Validators', () {
    group('validateRequired', () {
      test('should return error message when value is null', () {
        final result = Validators.validateRequired(null, fieldName: 'Title');
        expect(result, 'Title is required');
      });

      test('should return error message when value is empty', () {
        final result = Validators.validateRequired('', fieldName: 'Author');
        expect(result, 'Author is required');
      });

      test('should return error message when value is whitespace', () {
        final result = Validators.validateRequired('   ', fieldName: 'Field');
        expect(result, 'Field is required');
      });

      test('should return null when value is valid', () {
        final result = Validators.validateRequired('Valid Value');
        expect(result, null);
      });
    });

    group('validateIsbn', () {
      test('should return null when value is null', () {
        final result = Validators.validateIsbn(null);
        expect(result, null);
      });

      test('should return null when value is empty', () {
        final result = Validators.validateIsbn('');
        expect(result, null);
      });

      test('should return null for valid 10-digit ISBN', () {
        final result = Validators.validateIsbn('1234567890');
        expect(result, null);
      });

      test('should return null for valid 13-digit ISBN', () {
        final result = Validators.validateIsbn('1234567890123');
        expect(result, null);
      });

      test('should return null for ISBN with hyphens', () {
        final result = Validators.validateIsbn('123-456-7890');
        expect(result, null);
      });

      test('should return error for invalid ISBN length', () {
        final result = Validators.validateIsbn('123');
        expect(result, 'Invalid ISBN format (must be 10 or 13 digits)');
      });

      test('should return error for ISBN with letters', () {
        final result = Validators.validateIsbn('12345ABC90');
        expect(result, 'Invalid ISBN format (must be 10 or 13 digits)');
      });
    });

    group('validateYear', () {
      test('should return null when value is null', () {
        final result = Validators.validateYear(null);
        expect(result, null);
      });

      test('should return null when value is empty', () {
        final result = Validators.validateYear('');
        expect(result, null);
      });

      test('should return null for valid year', () {
        final result = Validators.validateYear('2024');
        expect(result, null);
      });

      test('should return error for non-numeric value', () {
        final result = Validators.validateYear('abc');
        expect(result, 'Invalid year');
      });

      test('should return error for year too old', () {
        final result = Validators.validateYear('999');
        expect(result, contains('Year must be between 1000 and'));
      });

      test('should return error for future year', () {
        final futureYear = (DateTime.now().year + 1).toString();
        final result = Validators.validateYear(futureYear);
        expect(result, contains('Year must be between 1000 and'));
      });
    });
  });
}
