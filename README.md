# Personal Library Manager

[![CI/CD Pipeline](https://github.com/yourusername/libarary_gen/workflows/CI%2FCD%20Pipeline/badge.svg)](https://github.com/yourusername/libarary_gen/actions)
[![codecov](https://codecov.io/gh/yourusername/libarary_gen/branch/main/graph/badge.svg)](https://codecov.io/gh/yourusername/libarary_gen)

A production-ready Flutter application for managing your personal book library, demonstrating mastery of **Clean Architecture**, **advanced state management**, and **robust testing practices**.

## 📱 Features

### Core Functionality
- ✅ **Full CRUD Operations** for books (Create, Read, Update, Delete)
- 🔍 **Real-time Search & Filter** by title, author, or ISBN
- 🎨 **Light & Dark Mode** with persistent user preference
- 📱 **Responsive Design** optimized for mobile, tablet, and desktop
- ↩️ **Undo Delete** with swipe-to-dismiss gesture
- ✔️ **Form Validation** (title, author required; ISBN format check)
- 🌐 **Internationalization** ready (currently English)

### Technical Highlights
- 🏛️ **Clean Architecture** with strict separation of concerns
- 📦 **Riverpod** for state management and dependency injection
- 💾 **Hive** for local data persistence
- ❄️ **Freezed** for immutable data models
- 🧪 **Comprehensive Testing** (unit, widget tests)
- 📊 **CI/CD Pipeline** with GitHub Actions
- 🎯 **Material 3** design system

## 🏗️ Architecture

This application follows **Clean Architecture** principles with three distinct layers:

```
lib/
├── core/                          # Shared utilities and base classes
│   ├── constants/                 # App-wide constants
│   ├── errors/                    # Error handling (Failures, Exceptions)
│   ├── theme/                     # Material 3 theme configuration
│   ├── utils/                     # Validators and utilities
│   └── providers/                 # Dependency injection providers
│
├── features/                      # Feature-based modules
│   ├── library/                   # Book management feature
│   │   ├── domain/               # Business logic layer
│   │   │   ├── entities/         # Book entity (pure Dart)
│   │   │   ├── repositories/     # Repository interfaces
│   │   │   └── usecases/         # Business use cases
│   │   ├── data/                 # Data layer
│   │   │   ├── models/           # Data models (Hive/JSON)
│   │   │   ├── datasources/      # Local data source
│   │   │   └── repositories/     # Repository implementation
│   │   └── presentation/         # UI layer
│   │       ├── providers/        # Riverpod state notifiers
│   │       ├── screens/          # Screen widgets
│   │       └── widgets/          # Reusable widgets
│   │
│   └── settings/                  # Settings feature
│       ├── domain/
│       ├── data/
│       └── presentation/
│
└── l10n/                          # Localization files
```

### Dependency Flow
```
Presentation → Domain ← Data
     ↓           ↓        ↓
  Widgets    Use Cases  Models
     ↓           ↓        ↓
 Providers  Entities  Data Sources
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ≥ 3.5.3
- Dart SDK ≥ 3.5.3
- Android Studio / VS Code with Flutter plugins
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/libarary_gen.git
   cd libarary_gen
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code** (Freezed, Hive adapters)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# View coverage report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Code Analysis

```bash
# Analyze code quality
flutter analyze

# Check formatting
dart format --set-exit-if-changed .

# Fix formatting
dart format .
```

## 🧪 Testing Strategy

### Test Coverage
- **Unit Tests**: Repository implementations, use cases, validators
- **Widget Tests**: Critical UI flows (adding books, search, delete with undo)
- **Integration Tests**: End-to-end user scenarios (not yet implemented)

### Test Structure
```
test/
├── core/
│   └── utils/
│       └── validators_test.dart
├── features/
│   └── library/
│       ├── data/
│       │   └── repositories/
│       │       └── book_repository_impl_test.dart
│       ├── domain/
│       │   └── usecases/
│       │       └── get_all_books_test.dart
│       └── presentation/
│           └── screens/
│               └── book_list_screen_test.dart
```

## 📦 Key Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_riverpod` | State management & DI |
| `hive` & `hive_flutter` | Local database |
| `freezed` & `json_serializable` | Code generation for models |
| `dartz` | Functional programming (Either type) |
| `uuid` | Unique ID generation |
| `very_good_analysis` | Strict linting rules |
| `mocktail` | Mocking for tests |

## 🎨 Design System

- **Material 3** design guidelines
- **Responsive layouts** using `LayoutBuilder`
- **Adaptive UI** for different screen sizes:
  - Mobile: Single column grid
  - Tablet: 2-column grid
  - Desktop: 3-column grid

## 🔒 Data Persistence

Books are stored locally using **Hive**, a fast and lightweight NoSQL database:
- Automatic serialization with Hive TypeAdapters
- Type-safe data access
- Efficient query performance

Settings (theme mode) are persisted in a separate Hive box.

## 🌍 Internationalization

The app uses Flutter's built-in localization:
- `AppLocalizations` generated from `.arb` files
- Currently supports English (en)
- Easy to add new languages by creating `app_<locale>.arb` files

## 🚢 CI/CD Pipeline

GitHub Actions workflow (`.github/workflows/main.yml`) includes:

1. **Analyze & Test**
   - Code analysis with `flutter analyze`
   - Format checking
   - Run all tests with coverage
   - Upload coverage to Codecov

2. **Build** (on main branch push)
   - Android APK
   - iOS build (no code signing)
   - Web build

## 📈 Scalability & Extensibility

### Adding a New Feature (e.g., Book Categories)

1. **Domain Layer**: Create `Category` entity and repository interface
2. **Data Layer**: Implement `CategoryModel` and data source
3. **Presentation Layer**: Add UI screens and providers
4. **Tests**: Write comprehensive tests for each layer

The architecture ensures:
- ✅ Business logic is independent of UI
- ✅ Easy to swap data sources (e.g., add remote API)
- ✅ Testable components in isolation
- ✅ Clear separation of concerns

## 🛠️ Performance Optimizations

- ✅ `const` constructors throughout the widget tree
- ✅ Efficient list rendering with `GridView.builder`
- ✅ Optimized state management (only necessary rebuilds)
- ✅ Lazy loading with Hive boxes
- ✅ Debounced search to prevent excessive queries

## 📝 Code Style

This project follows:
- **very_good_analysis** linting rules
- **Clean Code** principles
- **SOLID** design principles
- **DRY** (Don't Repeat Yourself)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feat/amazing-feature`)
3. Commit your changes using [Conventional Commits](https://www.conventionalcommits.org/)
   - `feat:` new feature
   - `fix:` bug fix
   - `docs:` documentation
   - `test:` tests
   - `refactor:` code refactoring
4. Push to the branch (`git push origin feat/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👤 Author

Your Name - [@yourusername](https://github.com/yourusername)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Clean Architecture principles by Robert C. Martin (Uncle Bob)
- Riverpod by Remi Rousselet
- All open-source contributors

---

**Built with ❤️ using Flutter**
