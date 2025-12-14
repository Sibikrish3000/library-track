# Contributing to Personal Library Manager

Thank you for your interest in contributing! This document provides guidelines and instructions for contributing to this project.

## 🤝 Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on what is best for the community
- Show empathy towards other community members

## 🔧 Development Setup

1. **Fork the repository** on GitHub
2. **Clone your fork**:
   ```bash
   git clone https://github.com/YOUR-USERNAME/libarary_gen.git
   cd libarary_gen
   ```
3. **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/ORIGINAL-OWNER/libarary_gen.git
   ```
4. **Install dependencies**:
   ```bash
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

## 📝 Commit Convention

This project follows [Conventional Commits](https://www.conventionalcommits.org/):

### Format
```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, missing semicolons, etc.)
- `refactor`: Code refactoring without functionality changes
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `perf`: Performance improvements
- `ci`: CI/CD changes

### Examples
```bash
feat(library): add book sorting by publication year
fix(search): resolve case-sensitive search issue
docs(readme): update installation instructions
test(repository): add tests for delete operation
```

## 🔀 Pull Request Process

1. **Create a feature branch**:
   ```bash
   git checkout -b feat/your-feature-name
   ```

2. **Make your changes** following the code style guidelines

3. **Run tests**:
   ```bash
   flutter test
   flutter analyze
   dart format --set-exit-if-changed .
   ```

4. **Commit your changes**:
   ```bash
   git add .
   git commit -m "feat(scope): your commit message"
   ```

5. **Keep your fork updated**:
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

6. **Push to your fork**:
   ```bash
   git push origin feat/your-feature-name
   ```

7. **Create a Pull Request** on GitHub with:
   - Clear title and description
   - Reference any related issues
   - Screenshots/GIFs for UI changes
   - Test coverage for new code

## ✅ Code Quality Standards

### Flutter/Dart Guidelines
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Use `very_good_analysis` linting rules
- Write self-documenting code with clear variable names
- Keep functions small and focused
- Avoid deeply nested code

### Architecture Principles
- Maintain Clean Architecture separation
- Domain layer must not depend on UI or external frameworks
- Use dependency injection (Riverpod providers)
- Follow SOLID principles
- Each class should have a single responsibility

### Testing Requirements
- **Minimum 80% code coverage** for new features
- Write unit tests for:
  - All use cases
  - All repository implementations
  - Complex business logic
- Write widget tests for:
  - Critical user flows
  - Complex UI components
- Use mocks for external dependencies

### UI/UX Guidelines
- Follow Material 3 design guidelines
- Ensure responsive layouts (mobile, tablet, desktop)
- Support both light and dark themes
- Add loading states for async operations
- Provide meaningful error messages
- Use proper accessibility labels

## 🧪 Testing

### Running Tests
```bash
# All tests
flutter test

# Specific test file
flutter test test/path/to/test_file.dart

# With coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### Writing Tests

**Unit Test Example**:
```dart
test('should return books when data source succeeds', () async {
  // Arrange
  final books = [mockBook];
  when(() => mockDataSource.getAllBooks())
      .thenAnswer((_) async => books);
  
  // Act
  final result = await repository.getAllBooks();
  
  // Assert
  expect(result.isRight(), true);
  verify(() => mockDataSource.getAllBooks()).called(1);
});
```

**Widget Test Example**:
```dart
testWidgets('displays book list correctly', (tester) async {
  await tester.pumpWidget(MyApp());
  await tester.pumpAndSettle();
  
  expect(find.text('Book Title'), findsOneWidget);
  expect(find.byType(BookCard), findsWidgets);
});
```

## 📂 Project Structure

When adding new features, follow this structure:

```
lib/features/your_feature/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── data/
│   ├── models/
│   ├── datasources/
│   └── repositories/
└── presentation/
    ├── providers/
    ├── screens/
    └── widgets/
```

## 🐛 Reporting Bugs

Use the GitHub issue tracker with:
- Clear, descriptive title
- Steps to reproduce
- Expected vs actual behavior
- Flutter version, OS, device info
- Screenshots/logs if applicable

## 💡 Suggesting Features

- Check existing issues first
- Provide clear use case
- Explain why it benefits users
- Consider implementation complexity
- Be open to discussion

## 📚 Documentation

- Update README.md for user-facing changes
- Update ARCHITECTURE.md for structural changes
- Add inline comments for complex logic
- Update .arb files for new UI strings

## 🔍 Code Review Guidelines

### For Contributors
- Respond to feedback promptly
- Be open to suggestions
- Explain your reasoning
- Keep discussions professional

### For Reviewers
- Review within 48 hours when possible
- Focus on code quality and architecture
- Suggest, don't demand
- Acknowledge good work
- Check for:
  - Clean Architecture adherence
  - Test coverage
  - Performance implications
  - Breaking changes

## 🎉 Recognition

Contributors will be acknowledged in:
- README.md contributors section
- Release notes
- Git history

Thank you for making this project better! 🚀
