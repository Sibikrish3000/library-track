import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:libarary_gen/models/book.dart';
import 'package:libarary_gen/repositories/book_repository.dart';
import 'package:libarary_gen/repositories/settings_repository.dart';
import 'package:libarary_gen/services/book_service.dart';
import 'package:libarary_gen/services/open_library_service.dart';
import 'package:libarary_gen/services/settings_service.dart';

// Data Sources / Services
final bookBoxProvider = Provider<Box<Book>>((ref) {
  throw UnimplementedError('bookBoxProvider must be overridden');
});

final settingsBoxProvider = Provider<Box<dynamic>>((ref) {
  throw UnimplementedError('settingsBoxProvider must be overridden');
});

final bookServiceProvider = Provider<BookService>((ref) {
  final box = ref.watch(bookBoxProvider);
  return BookServiceImpl(box);
});

final openLibraryServiceProvider = Provider<OpenLibraryService>((ref) {
  return OpenLibraryService();
});

final settingsServiceProvider = Provider<SettingsService>((ref) {
  final box = ref.watch(settingsBoxProvider);
  return SettingsServiceImpl(box);
});

// Repositories
final bookRepositoryProvider = Provider<BookRepository>((ref) {
  final service = ref.watch(bookServiceProvider);
  return BookRepository(service);
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final service = ref.watch(settingsServiceProvider);
  return SettingsRepository(service);
});
