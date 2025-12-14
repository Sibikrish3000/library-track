import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:libarary_gen/utils/app_constants.dart';
import 'package:libarary_gen/providers/providers.dart';
import 'package:libarary_gen/utils/app_theme.dart';
import 'package:libarary_gen/models/book.dart';
import 'package:libarary_gen/screens/book_list_screen.dart';
import 'package:libarary_gen/providers/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(BookAdapter());

  // Delete old box to handle schema changes
  await Hive.deleteBoxFromDisk(AppConstants.booksBoxName);

  // Open boxes
  final booksBox = await Hive.openBox<Book>(AppConstants.booksBoxName);
  final settingsBox = await Hive.openBox<dynamic>(AppConstants.settingsBoxName);

  runApp(
    ProviderScope(
      overrides: [
        bookBoxProvider.overrideWithValue(booksBox),
        settingsBoxProvider.overrideWithValue(settingsBox),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Personal Library',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const BookListScreen(),
    );
  }
}
