# Personal Library Manager

[![CI/CD Pipeline](https://github.com/sibikrish3000/library_track/actions/workflows/main.yml/badge.svg)](https://github.com/sibikrish3000/library_track/actions)

A production-ready Flutter application for managing your personal book library, demonstrating mastery of **Clean Architecture**, **advanced state management**, and **robust testing practices**.


## Demo
![](demo/android.webp)

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

This project uses a pragmatic, layered structure aligned with the current repo:

```
lib/
├── models/                # Hive/JSON models (Freezed)
├── providers/             # Riverpod providers & notifiers
├── repositories/          # Repositories wrapping services
├── screens/               # UI screens (Flutter widgets)
├── services/              # Local + remote services (Hive, OpenLibrary)
├── utils/                 # Constants, themes, validators, failures
├── widgets/               # Reusable UI components
└── l10n/                  # Localization ARB files
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
- Android Studio or VS Code with Flutter plugins
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/sibikrish3000/library_track.git
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

Books are stored locally using **Hive** with `BookAdapter` registered at app start. Boxes:
- `books`: persists all book entries and metadata
- `settings`: persists app settings (e.g., theme mode)

Note: The app no longer deletes boxes on startup; data persists across restarts.

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

Sibi Krish - [@sibikrish3000](https://github.com/sibikrish3000)

**Built with ❤️ using Flutter**
