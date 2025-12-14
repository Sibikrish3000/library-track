import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libarary_gen/models/book.dart';
import 'package:libarary_gen/providers/book_provider.dart';
import 'package:libarary_gen/providers/providers.dart';
import 'package:libarary_gen/screens/book_details_screen.dart';
import 'package:libarary_gen/utils/validators.dart';

class BookFormScreen extends ConsumerStatefulWidget {
  const BookFormScreen({this.book, super.key});

  final Book? book;

  @override
  ConsumerState<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends ConsumerState<BookFormScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Form Controllers
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _isbnController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _yearController = TextEditingController();
  final _customGenreController = TextEditingController();
  final _coverUrlController = TextEditingController();

  // Search Controllers
  final _searchController = TextEditingController();
  List<Book> _searchResults = [];
  bool _isSearching = false;
  String? _searchError;

  String? _selectedGenre;
  bool _isFavorite = false;
  String _readingStatus = 'to_read';
  bool _isLoading = false;

  final List<String> _genres = [
    'Fiction',
    'Non-Fiction',
    'Science Fiction',
    'Fantasy',
    'Mystery',
    'Thriller',
    'Romance',
    'Biography',
    'History',
    'Self-Help',
    'Custom',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    if (widget.book != null) {
      _populateForm(widget.book!);
      // If editing, default to manual entry tab (index 1)
      _tabController.index = 1;
    }
  }

  void _populateForm(Book book) {
    _titleController.text = book.title;
    _authorController.text = book.author;
    _isbnController.text = book.isbn ?? '';
    _descriptionController.text = book.description ?? '';
    _yearController.text = book.publicationYear?.toString() ?? '';
    _selectedGenre = book.genre;
    _customGenreController.text = book.customGenre ?? '';
    _coverUrlController.text = book.coverUrl ?? '';
    _isFavorite = book.isFavorite;
    _readingStatus = book.readingStatus;

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _authorController.dispose();
    _isbnController.dispose();
    _descriptionController.dispose();
    _yearController.dispose();
    _customGenreController.dispose();
    _coverUrlController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchBooks() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
      _searchError = null;
      _searchResults = [];
    });

    try {
      final service = ref.read(openLibraryServiceProvider);
      final results = await service.searchBooks(query);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      setState(() {
        _searchError = e.toString();
      });
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  Future<void> _selectBook(Book book) async {
    // Show loading snackbar
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fetching book details...'),
        duration: Duration(seconds: 1),
      ),
    );

    var fullBook = book;
    try {
      // book.id holds the OpenLibrary key (e.g. /works/OL...)
      if (book.id.startsWith('/works/')) {
        fullBook =
            await ref.read(openLibraryServiceProvider).getBookDetails(book);
      }
    } catch (e) {
      // Ignore error, just proceed without extra details
      debugPrint('Error fetching details: $e');
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Show Overview Page (Preview)
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (context) => BookDetailsScreen(
          book: fullBook,
          isPreview: true,
          onAdd: () {
            Navigator.pop(context); // Close details
            _populateForm(fullBook);
            _tabController.animateTo(1); // Switch to Manual Entry tab
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Book details loaded. Please review and save.'),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _saveBook() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final notifier = ref.read(bookNotifierProvider.notifier);

      if (widget.book != null) {
        // Edit existing book
        await notifier.editBook(
          id: widget.book!.id,
          title: _titleController.text.trim(),
          author: _authorController.text.trim(),
          isbn: _isbnController.text.trim().isEmpty
              ? null
              : _isbnController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          publicationYear: _yearController.text.isEmpty
              ? null
              : int.tryParse(_yearController.text),
          genre: _selectedGenre,
          customGenre: _selectedGenre == 'Custom'
              ? _customGenreController.text.trim()
              : null,
          isFavorite: _isFavorite,
          readingStatus: _readingStatus,
          createdAt: widget.book!.createdAt,
          coverUrl: _coverUrlController.text.trim().isEmpty
              ? null
              : _coverUrlController.text.trim(),
        );
      } else {
        // Add new book
        await notifier.addNewBook(
          title: _titleController.text.trim(),
          author: _authorController.text.trim(),
          isbn: _isbnController.text.trim().isEmpty
              ? null
              : _isbnController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          publicationYear: _yearController.text.isEmpty
              ? null
              : int.tryParse(_yearController.text),
          genre: _selectedGenre,
          customGenre: _selectedGenre == 'Custom'
              ? _customGenreController.text.trim()
              : null,
          isFavorite: _isFavorite,
          readingStatus: _readingStatus,
          coverUrl: _coverUrlController.text.trim().isEmpty
              ? null
              : _coverUrlController.text.trim(),
        );
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.book != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? l10n.editBook : l10n.addBook),
        bottom: isEditing
            ? null
            : TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Online Search', icon: Icon(Icons.search)),
                  Tab(text: 'Manual Entry', icon: Icon(Icons.edit)),
                ],
              ),
      ),
      body: isEditing
          ? _buildManualEntryForm(l10n)
          : TabBarView(
              controller: _tabController,
              children: [
                _buildSearchTab(l10n),
                _buildManualEntryForm(l10n),
              ],
            ),
    );
  }

  Widget _buildSearchTab(AppLocalizations l10n) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search by title, author, or ISBN',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _searchBooks,
                    ),
                  ),
                  onSubmitted: (_) => _searchBooks(),
                ),
              ),
            ],
          ),
        ),
        if (_isSearching)
          const Expanded(child: Center(child: CircularProgressIndicator()))
        else if (_searchError != null)
          Expanded(child: Center(child: Text('Error: $_searchError')))
        else if (_searchResults.isEmpty && _searchController.text.isNotEmpty)
          const Expanded(child: Center(child: Text('No results found')))
        else
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final book = _searchResults[index];
                return ListTile(
                  leading: book.coverUrl != null
                      ? Image.network(book.coverUrl!,
                          width: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => const Icon(Icons.book),)
                      : const Icon(Icons.book),
                  title: Text(book.title),
                  subtitle: Text(book.author),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _selectBook(book),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildManualEntryForm(AppLocalizations l10n) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Cover Image Preview
          if (_coverUrlController.text.isNotEmpty)
            Container(
              height: 200,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  _coverUrlController.text,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                        child: Icon(Icons.broken_image, size: 50),);
                  },
                ),
              ),
            ),

          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: l10n.title,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.book),
            ),
            validator: (value) =>
                Validators.requiredField(value, l10n.titleRequired),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _authorController,
            decoration: InputDecoration(
              labelText: l10n.author,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.person),
            ),
            validator: (value) =>
                Validators.requiredField(value, l10n.authorRequired),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _isbnController,
                  decoration: InputDecoration(
                    labelText: l10n.isbn,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.qr_code),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _yearController,
                  decoration: InputDecoration(
                    labelText: l10n.publicationYear,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.calendar_today),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedGenre,
            decoration: InputDecoration(
              labelText: l10n.genre,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.category),
            ),
            items: _genres.map((genre) {
              return DropdownMenuItem(
                value: genre,
                child: Text(genre),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedGenre = value;
              });
            },
          ),
          if (_selectedGenre == 'Custom') ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: _customGenreController,
              decoration: InputDecoration(
                labelText: l10n.customGenre,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.edit),
              ),
              validator: (value) {
                if (_selectedGenre == 'Custom') {
                  return Validators.requiredField(
                      value, l10n.customGenreRequired,);
                }
                return null;
              },
            ),
          ],
          const SizedBox(height: 16),
          TextFormField(
            controller: _coverUrlController,
            decoration: InputDecoration(
              labelText: 'Cover Image URL',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.image),
              suffixIcon: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => setState(() {}), // Refresh preview
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: l10n.description,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.description),
              alignLabelWithHint: true,
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text(l10n.favorite),
                    secondary: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : null,
                    ),
                    value: _isFavorite,
                    onChanged: (value) {
                      setState(() {
                        _isFavorite = value;
                      });
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.bookmark),
                    title: Text(l10n.readingStatus),
                    trailing: DropdownButton<String>(
                      value: _readingStatus,
                      underline: const SizedBox(),
                      items: [
                        DropdownMenuItem(
                          value: 'to_read',
                          child: Text(l10n.toRead),
                        ),
                        DropdownMenuItem(
                          value: 'reading',
                          child: Text(l10n.reading),
                        ),
                        DropdownMenuItem(
                          value: 'completed',
                          child: Text(l10n.completed),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _readingStatus = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 50,
            child: FilledButton.icon(
              onPressed: _isLoading ? null : _saveBook,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save),
              label: Text(_isLoading ? l10n.saving : l10n.save),
            ),
          ),
        ],
      ),
    );
  }
}
