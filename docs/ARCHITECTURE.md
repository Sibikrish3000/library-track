# Architecture Overview

## Clean Architecture Layers

This application implements Clean Architecture with three distinct layers:

### 1. Domain Layer (Business Logic)
**Location**: `lib/features/*/domain/`

**Purpose**: Contains the core business logic and rules, independent of any external dependencies.

**Components**:
- **Entities**: Pure Dart objects representing business concepts (e.g., `Book`)
- **Repository Interfaces**: Abstract contracts for data operations
- **Use Cases**: Single-responsibility business operations
  - `GetAllBooks`: Retrieve all books
  - `AddBook`: Create a new book
  - `UpdateBook`: Modify existing book
  - `DeleteBook`: Remove a book
  - `SearchBooks`: Filter books by query

**Key Principle**: No dependencies on UI or external frameworks.

### 2. Data Layer (Data Management)
**Location**: `lib/features/*/data/`

**Purpose**: Handles data persistence and retrieval, implementing domain layer interfaces.

**Components**:
- **Models**: Data transfer objects with serialization logic
  - Extends entities with Freezed and Hive annotations
  - Conversion methods: `toEntity()`, `fromEntity()`
- **Data Sources**: Concrete implementations for data access
  - `BookLocalDataSource`: Hive database operations
- **Repository Implementations**: Bridges domain and data layers
  - Converts between models and entities
  - Handles error mapping (exceptions → failures)

**Key Principle**: Depends on domain layer, implements its contracts.

### 3. Presentation Layer (UI)
**Location**: `lib/features/*/presentation/`

**Purpose**: User interface and state management.

**Components**:
- **Providers**: Riverpod state management
  - `BookNotifier`: Manages book list state
  - `ThemeModeNotifier`: Manages theme preference
- **Screens**: Full-page UI components
  - `BookListScreen`: Main list view with search
  - `BookFormScreen`: Add/edit book form
- **Widgets**: Reusable UI components
  - `BookCard`: Book item display
  - `EmptyState`: No data placeholder

**Key Principle**: Depends only on domain layer use cases.

## Dependency Injection

**Riverpod Providers** (`lib/core/providers/providers.dart`):

```
                    ┌─────────────────┐
                    │   Hive Boxes    │
                    └────────┬────────┘
                             │
                    ┌────────▼─────────┐
                    │  Data Sources    │
                    └────────┬─────────┘
                             │
                    ┌────────▼─────────┐
                    │  Repositories    │
                    └────────┬─────────┘
                             │
                    ┌────────▼─────────┐
                    │   Use Cases      │
                    └────────┬─────────┘
                             │
                    ┌────────▼─────────┐
                    │   Notifiers      │
                    └────────┬─────────┘
                             │
                    ┌────────▼─────────┐
                    │      UI          │
                    └──────────────────┘
```

## Data Flow

### Read Operation (Loading Books)
1. UI calls `BookNotifier.loadBooks()`
2. Notifier invokes `GetAllBooks` use case
3. Use case calls `BookRepository.getAllBooks()`
4. Repository requests data from `BookLocalDataSource`
5. Data source reads from Hive
6. Models are converted to entities
7. Entities are returned through layers
8. UI updates with new state

### Write Operation (Adding Book)
1. UI submits form data
2. Notifier invokes `AddBook` use case with entity
3. Use case calls `BookRepository.addBook()`
4. Repository converts entity to model
5. Data source writes to Hive
6. Success/failure propagates back
7. UI refreshes or shows error

## Error Handling

**Two-tier approach**:

1. **Exceptions** (Data Layer)
   - `CacheException`: Hive errors
   - `ValidationException`: Data validation
   
2. **Failures** (Domain Layer)
   - `CacheFailure`: Converted from exceptions
   - `ValidationFailure`: Business rule violations

**Either Type** from `dartz` package:
```dart
Either<Failure, SuccessType>
```
- `Left`: Contains failure
- `Right`: Contains success value

## State Management Pattern

**Riverpod StateNotifier**:

```dart
class BookNotifier extends StateNotifier<BookState> {
  BookState can be:
  - initial()   : App started
  - loading()   : Fetching data
  - loaded(books) : Data available
  - error(message) : Operation failed
}
```

**Benefits**:
- Immutable state
- Type-safe
- Easy to test
- Clear state transitions

## Testing Strategy

### Unit Tests
- **Repository**: Mock data sources
- **Use Cases**: Mock repositories
- **Validators**: Pure function testing

### Widget Tests
- **Screens**: Mock notifiers
- **Widgets**: Verify rendering and interactions

### Integration Tests
- End-to-end user flows
- Real database operations

## Key Design Patterns

1. **Repository Pattern**: Abstracts data access
2. **Dependency Inversion**: High-level modules don't depend on low-level
3. **Single Responsibility**: Each class has one reason to change
4. **Factory Pattern**: Model conversions
5. **Observer Pattern**: Riverpod state notifications
6. **Strategy Pattern**: Different data sources (local/remote)

## Scalability Considerations

### Adding Remote Data Source
1. Create `BookRemoteDataSource` interface
2. Implement API client
3. Update repository to use both sources
4. Add sync logic
5. No changes to domain or presentation layers

### Adding New Feature
1. Create feature folder structure
2. Define domain entities and use cases
3. Implement data layer
4. Build UI with providers
5. Write tests for all layers

## Performance Optimizations

- **Const constructors**: Reduces rebuilds
- **Provider scoping**: Minimize state updates
- **Lazy loading**: Hive boxes open on-demand
- **Efficient queries**: Filter at database level
- **Debouncing**: Search input throttling
