# Architecture Diagram

## System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    PERSONAL LIBRARY MANAGER                      │
│                     (Flutter Application)                        │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                           │
├─────────────────────────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │ BookListScreen│  │BookFormScreen│  │   Widgets    │          │
│  │              │  │              │  │ - BookCard   │          │
│  │ - Search     │  │ - Validation │  │ - EmptyState │          │
│  │ - Grid View  │  │ - Add/Edit   │  │              │          │
│  │ - Swipe Delete│ │              │  │              │          │
│  └──────┬───────┘  └──────┬───────┘  └──────────────┘          │
│         │                  │                                     │
│         └──────────┬───────┘                                     │
│                    │                                             │
│         ┌──────────▼─────────┐      ┌──────────────────┐       │
│         │   BookNotifier     │      │ ThemeModeNotifier│       │
│         │   (StateNotifier)  │      │                  │       │
│         │                    │      │ - Light/Dark     │       │
│         │ States:            │      │ - Persistence    │       │
│         │ - Initial          │      │                  │       │
│         │ - Loading          │      └──────────────────┘       │
│         │ - Loaded(books)    │                                  │
│         │ - Error(message)   │                                  │
│         └──────────┬─────────┘                                  │
└────────────────────┼────────────────────────────────────────────┘
                     │
                     │ Uses
                     │
┌────────────────────▼────────────────────────────────────────────┐
│                      DOMAIN LAYER                                │
│                   (Business Logic)                               │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────┐        │
│  │                    Use Cases                        │        │
│  ├─────────────────────────────────────────────────────┤        │
│  │ GetAllBooks    │ AddBook    │ UpdateBook           │        │
│  │ DeleteBook     │ SearchBooks                       │        │
│  └──────────────────────┬──────────────────────────────┘        │
│                         │                                        │
│                         │ Uses                                   │
│                         │                                        │
│  ┌──────────────────────▼────────────────────────┐              │
│  │         BookRepository (Interface)            │              │
│  │                                               │              │
│  │  + getAllBooks(): Either<Failure, List<Book>>│              │
│  │  + addBook(Book): Either<Failure, Unit>      │              │
│  │  + updateBook(Book): Either<Failure, Unit>   │              │
│  │  + deleteBook(id): Either<Failure, Unit>     │              │
│  │  + searchBooks(query): Either<Failure, ...>  │              │
│  └───────────────────────────────────────────────┘              │
│                                                                  │
│  ┌──────────────────────────────────────────────┐               │
│  │            Book Entity                       │               │
│  │                                              │               │
│  │  - id: String                                │               │
│  │  - title: String                             │               │
│  │  - author: String                            │               │
│  │  - isbn: String?                             │               │
│  │  - description: String?                      │               │
│  │  - publicationYear: int?                     │               │
│  │  - createdAt: DateTime                       │               │
│  │  - updatedAt: DateTime                       │               │
│  └──────────────────────────────────────────────┘               │
└─────────────────────────────────────────────────────────────────┘
                         │
                         │ Implements
                         │
┌────────────────────────▼────────────────────────────────────────┐
│                      DATA LAYER                                  │
│                 (Data Management)                                │
├─────────────────────────────────────────────────────────────────┤
│  ┌──────────────────────────────────────────────┐               │
│  │    BookRepositoryImpl (Implementation)       │               │
│  │                                              │               │
│  │  - Converts BookModel ↔ Book Entity         │               │
│  │  - Handles Exceptions → Failures            │               │
│  └──────────────────┬───────────────────────────┘               │
│                     │                                            │
│                     │ Uses                                       │
│                     │                                            │
│  ┌──────────────────▼────────────────────────┐                  │
│  │    BookLocalDataSource (Interface)       │                  │
│  └──────────────────┬───────────────────────┘                  │
│                     │                                            │
│                     │ Implementation                             │
│                     │                                            │
│  ┌──────────────────▼────────────────────────┐                  │
│  │   BookLocalDataSourceImpl                │                  │
│  │                                           │                  │
│  │  - CRUD operations on Hive               │                  │
│  │  - Search functionality                  │                  │
│  └──────────────────┬────────────────────────┘                  │
│                     │                                            │
│  ┌──────────────────▼────────────────────────┐                  │
│  │         BookModel                         │                  │
│  │                                           │                  │
│  │  @freezed + @HiveType                    │                  │
│  │  - All fields from Book Entity           │                  │
│  │  - toEntity() / fromEntity()             │                  │
│  │  - JSON serialization                    │                  │
│  │  - Hive TypeAdapter                      │                  │
│  └──────────────────┬────────────────────────┘                  │
└────────────────────┼───────────────────────────────────────────┘
                     │
                     │ Stores in
                     │
┌────────────────────▼────────────────────────────────────────────┐
│                    STORAGE LAYER                                 │
├─────────────────────────────────────────────────────────────────┤
│  ┌──────────────────────────────┐  ┌─────────────────────────┐ │
│  │     Hive Box: "books"        │  │  Hive Box: "settings"   │ │
│  │                              │  │                         │ │
│  │  Key: String (book.id)       │  │  Key: "theme_mode"      │ │
│  │  Value: BookModel            │  │  Value: int (index)     │ │
│  │                              │  │                         │ │
│  │  - Fast NoSQL storage        │  │  - Persistent prefs     │ │
│  │  - Type-safe access          │  │                         │ │
│  └──────────────────────────────┘  └─────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## Dependency Injection Flow (Riverpod)

```
┌─────────────────────────────────────────────────────────────┐
│                     ProviderScope                            │
│                   (Root of the app)                          │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       │ Overrides
                       │
        ┌──────────────▼──────────────┐
        │  Box Providers              │
        │  - bookBoxProvider          │
        │  - settingsBoxProvider      │
        └──────────────┬──────────────┘
                       │
        ┌──────────────▼──────────────┐
        │  DataSource Providers       │
        │  - bookLocalDataSource      │
        │  - settingsLocalDataSource  │
        └──────────────┬──────────────┘
                       │
        ┌──────────────▼──────────────┐
        │  Repository Providers       │
        │  - bookRepository           │
        │  - settingsRepository       │
        └──────────────┬──────────────┘
                       │
        ┌──────────────▼──────────────┐
        │  UseCase Providers          │
        │  - getAllBooks              │
        │  - addBook                  │
        │  - updateBook               │
        │  - deleteBook               │
        │  - searchBooks              │
        └──────────────┬──────────────┘
                       │
        ┌──────────────▼──────────────┐
        │  Notifier Providers         │
        │  - bookNotifierProvider     │
        │  - themeModeProvider        │
        └──────────────┬──────────────┘
                       │
        ┌──────────────▼──────────────┐
        │      UI Widgets              │
        │  ConsumerWidget / Consumer  │
        │  ref.watch() / ref.read()   │
        └──────────────────────────────┘
```

## Data Flow: Adding a Book

```
User Action                    System Response
─────────────────────────────────────────────────────

1. User fills form           
   ├─ Enter title            ─────> Validate title (required)
   ├─ Enter author           ─────> Validate author (required)  
   ├─ Enter ISBN             ─────> Validate ISBN (format)
   └─ Click "Save"
                              
2. BookFormScreen            
   └─ Calls notifier         ─────> BookNotifier.addNewBook()

3. BookNotifier              
   ├─ Creates Book entity    ─────> Generate UUID
   ├─ Sets timestamps        ─────> DateTime.now()
   └─ Calls use case         ─────> AddBook.call(book)

4. AddBook UseCase           
   └─ Calls repository       ─────> BookRepository.addBook()

5. BookRepositoryImpl        
   ├─ Converts to model      ─────> BookModel.fromEntity()
   ├─ Calls data source      ─────> LocalDataSource.addBook()
   └─ Handles errors         ─────> Exception → Failure

6. BookLocalDataSource       
   └─ Writes to Hive         ─────> box.put(id, model)

7. Success flows back        
   ├─ Repository: Right(unit)
   ├─ UseCase: Right(unit)  
   ├─ Notifier: loadBooks()  
   └─ UI: Navigator.pop()    ─────> Return to list

8. BookListScreen updates    
   └─ Shows new book         ─────> Rebuilt from state
```

## State Management Flow

```
BookState (Union Type with Freezed)
│
├─ initial()           : App just started
│                        Show nothing or placeholder
│
├─ loading()           : Fetching data
│                        Show CircularProgressIndicator
│
├─ loaded(List<Book>)  : Data available
│   │                    Show grid/list of books
│   │
│   ├─ books.isEmpty   : No books yet
│   │                    Show EmptyState widget
│   │
│   └─ books.isNotEmpty: Books available
│                        Show BookCard widgets
│
└─ error(String)       : Operation failed
                         Show error message + retry button
```

## Testing Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      Test Pyramid                            │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│                       ╱╲                                     │
│                      ╱  ╲    Integration Tests              │
│                     ╱    ╲   (Future: E2E flows)            │
│                    ╱──────╲                                  │
│                   ╱        ╲                                 │
│                  ╱  Widget  ╲  Widget Tests                  │
│                 ╱   Tests    ╲ (UI components)               │
│                ╱──────────────╲                              │
│               ╱                ╲                             │
│              ╱   Unit Tests     ╲ Unit Tests                 │
│             ╱  (Largest volume)  ╲ (Business logic)          │
│            ╱──────────────────────╲                          │
│           ────────────────────────── Base                    │
│                                                              │
│  Unit Tests:                                                │
│  ✓ Validators (pure functions)                              │
│  ✓ Repository implementations (mocked data sources)         │
│  ✓ Use cases (mocked repositories)                          │
│  ✓ Models (entity conversion)                               │
│                                                              │
│  Widget Tests:                                               │
│  ✓ BookListScreen (empty, loading, error states)           │
│  ✓ BookFormScreen (validation, submission)                 │
│  ✓ BookCard (rendering)                                     │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## CI/CD Pipeline Flow

```
┌─────────────┐
│  Git Push   │
│  / PR       │
└──────┬──────┘
       │
       ▼
┌─────────────────────────────────────┐
│   GitHub Actions Workflow            │
│   (.github/workflows/main.yml)       │
└──────┬──────────────────────────────┘
       │
       ├──────────────────────────────┐
       │                              │
       ▼                              ▼
┌──────────────┐           ┌──────────────────┐
│ Analyze & Test│           │  Build (if main) │
└──────┬───────┘           └──────┬───────────┘
       │                          │
       ├─► Get dependencies       ├─► Android APK
       ├─► Generate code          ├─► iOS build
       ├─► flutter analyze        └─► Web build
       ├─► dart format check
       ├─► flutter test
       └─► Upload coverage
                │
                ▼
       ┌────────────────┐
       │   Codecov      │
       └────────────────┘
```

---

## Key Architectural Decisions

### 1. Clean Architecture
**Why**: Separation of concerns, testability, maintainability
**Benefit**: Easy to swap data sources or UI frameworks

### 2. Riverpod for DI & State
**Why**: Compile-time safety, no BuildContext needed
**Benefit**: Safer refactoring, better testing

### 3. Hive for Local Storage
**Why**: Fast, lightweight, type-safe
**Benefit**: No SQL boilerplate, easy to use

### 4. Freezed for Models
**Why**: Immutability, union types, code generation
**Benefit**: Less boilerplate, fewer bugs

### 5. Either for Error Handling
**Why**: Functional approach, explicit error handling
**Benefit**: No exceptions thrown, all errors handled

---

**This architecture ensures the app is:**
- ✅ Scalable: Easy to add features
- ✅ Testable: All layers can be tested in isolation
- ✅ Maintainable: Clear separation of concerns
- ✅ Performant: Optimized state updates
- ✅ Robust: Proper error handling
