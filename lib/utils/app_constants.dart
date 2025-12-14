class AppConstants {
  const AppConstants._();

  // Hive box names
  static const String booksBoxName = 'books';
  static const String settingsBoxName = 'settings';

  // Settings keys
  static const String themeModeKey = 'theme_mode';

  // ISBN validation
  static const String isbnPattern = r'^\d{10}$|^\d{13}$';
}
