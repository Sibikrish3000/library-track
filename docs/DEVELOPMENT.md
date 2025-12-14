# Development Guide

## Quick Start Commands

```bash
# Get dependencies
flutter pub get

# Generate code (Freezed, Hive)
flutter pub run build_runner build --delete-conflicting-outputs

# Run app
flutter run

# Run on specific device
flutter run -d chrome        # Web
flutter run -d windows       # Windows
flutter run -d <device-id>   # Mobile/emulator
```

## Code Generation

### When to run build_runner:
- After modifying Freezed models
- After changing Hive TypeAdapters
- After adding JSON serialization

```bash
# Generate once
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes (auto-generate)
flutter pub run build_runner watch --delete-conflicting-outputs
```

## Project Commands

### Testing
```bash
flutter test                           # Run all tests
flutter test --coverage                # With coverage report
flutter test test/path/to/file.dart    # Specific file
flutter test --name "test name"        # Specific test
```

### Code Quality
```bash
flutter analyze                        # Static analysis
dart format .                          # Format all files
dart format --set-exit-if-changed .    # Check formatting
```

### Cleaning
```bash
flutter clean                 # Clean build cache
flutter pub get               # Reinstall dependencies
rm -rf build/                 # Remove build folder
```

## Common Development Tasks

### Adding a New Book Field

1. **Update Domain Entity** (`lib/features/library/domain/entities/book.dart`):
```dart
@freezed
class Book with _$Book {
  const factory Book({
    // ... existing fields
    String? newField,  // Add new field
  }) = _Book;
}
```

2. **Update Data Model** (`lib/features/library/data/models/book_model.dart`):
```dart
@HiveType(typeId: 0)
class BookModel with _$BookModel {
  const factory BookModel({
    // ... existing fields
    @HiveField(8) String? newField,  // Match entity
  }) = _BookModel;
}
```

3. **Run Code Generation**:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Update UI** (`lib/features/library/presentation/screens/book_form_screen.dart`):
- Add TextFormField for new field
- Update save logic to include new field

5. **Write Tests**

### Adding a New Screen

1. Create screen file in `lib/features/*/presentation/screens/`
2. Add navigation in existing screen
3. Create tests in `test/features/*/presentation/screens/`

### Adding Localization String

1. Edit `lib/l10n/app_en.arb`:
```json
{
  "newKey": "New Value",
  "@newKey": {
    "description": "Description of the new key"
  }
}
```

2. Use in code:
```dart
final l10n = AppLocalizations.of(context)!;
Text(l10n.newKey)
```

## Debugging

### Common Issues

**Issue**: "type 'Null' is not a subtype of type 'String'"
**Solution**: Check for null values, use null-aware operators (`?.`, `??`)

**Issue**: Provider not found
**Solution**: Ensure ProviderScope wraps MaterialApp, check provider overrides

**Issue**: Hive box not registered
**Solution**: Check adapter registration in main.dart before openBox

**Issue**: Build runner errors
**Solution**: 
```bash
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Logging

```dart
import 'dart:developer' as developer;

developer.log('Message', name: 'MyFeature');
developer.log('Error: $error', name: 'MyFeature', error: error);
```

### Flutter DevTools

```bash
flutter run --observatory-port=9100
# Then open Flutter DevTools in Chrome
```

## Performance Profiling

```bash
# Profile mode build
flutter run --profile

# Release mode build  
flutter build apk --release
flutter build ios --release
flutter build web --release
```

### Performance Best Practices
- Use `const` constructors wherever possible
- Avoid rebuilding entire widget trees
- Use `ListView.builder` for large lists
- Profile before optimizing
- Keep frame render time under 16ms (60fps)

## Database Management

### Viewing Hive Data

```dart
// Print all books
final box = Hive.box<BookModel>('books');
print('Total books: ${box.length}');
for (var book in box.values) {
  print('${book.title} by ${book.author}');
}
```

### Clearing Data (for testing)
```dart
await Hive.box<BookModel>('books').clear();
await Hive.box('settings').clear();
```

### Hive File Location
- Android: `/data/data/com.example.app/app_flutter/`
- iOS: `<app_directory>/Documents/`
- Web: IndexedDB
- Desktop: Application documents directory

## Git Workflow

```bash
# Start new feature
git checkout -b feat/feature-name

# Stage changes
git add .

# Commit with conventional commit
git commit -m "feat(library): add book categories"

# Push to origin
git push origin feat/feature-name

# Update from main
git fetch upstream
git rebase upstream/main
```

## CI/CD

GitHub Actions runs automatically on:
- Every push to main/develop
- Every pull request

### Local CI Simulation
```bash
# Run same checks as CI
flutter analyze && \\
dart format --set-exit-if-changed . && \\
flutter test --coverage && \\
flutter build apk --debug
```

## Environment Setup

### VS Code Extensions
- Flutter
- Dart
- Error Lens
- Better Comments
- GitLens

### Recommended VS Code Settings
```json
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true
  },
  "[dart]": {
    "editor.defaultFormatter": "Dart-Code.dart-code",
    "editor.rulers": [80]
  }
}
```

## Useful Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Riverpod Documentation](https://riverpod.dev)
- [Clean Architecture (Uncle Bob)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Material 3 Design](https://m3.material.io)

## Troubleshooting

### Flutter Doctor
```bash
flutter doctor -v  # Detailed system info
```

### Gradle Issues (Android)
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### CocoaPods Issues (iOS)
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
```

### Clear Everything
```bash
flutter clean
rm -rf .dart_tool/
rm -rf build/
rm -rf ios/Pods/
rm -rf ios/.symlinks/
rm -rf android/.gradle/
flutter pub get
cd ios && pod install && cd ..
flutter pub run build_runner build --delete-conflicting-outputs
```

## Release Checklist

- [ ] All tests pass
- [ ] Code coverage > 80%
- [ ] No analyzer warnings
- [ ] Code formatted
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] Version bumped in pubspec.yaml
- [ ] Screenshots updated
- [ ] Release notes written

---

Happy coding! 🚀
