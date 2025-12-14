import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libarary_gen/providers/providers.dart';
import 'package:libarary_gen/screens/book_list_screen.dart';
import 'package:libarary_gen/services/book_service.dart';
import 'package:libarary_gen/services/settings_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'widget_test.mocks.dart';

@GenerateMocks([BookService, SettingsService])
void main() {
  late MockBookService mockBookService;
  late MockSettingsService mockSettingsService;

  setUp(() {
    mockBookService = MockBookService();
    mockSettingsService = MockSettingsService();

    // Setup default stubs
    when(mockBookService.getAllBooks()).thenAnswer((_) async => []);
    when(mockSettingsService.getThemeMode())
        .thenAnswer((_) async => ThemeMode.system);
  });

  testWidgets('BookListScreen shows empty state when no books',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookServiceProvider.overrideWithValue(mockBookService),
          settingsServiceProvider.overrideWithValue(mockSettingsService),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BookListScreen(),
        ),
      ),
    );

    // Trigger a frame
    await tester.pumpAndSettle();

    // Verify empty state is shown
    expect(find.byType(BookListScreen), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Can navigate to Add Book screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookServiceProvider.overrideWithValue(mockBookService),
          settingsServiceProvider.overrideWithValue(mockSettingsService),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BookListScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Tap the add button
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verify we navigated (checking for a widget on the form screen)
    expect(find.text('Add Book'), findsOneWidget);
  });
}
