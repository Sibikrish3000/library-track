import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:libarary_gen/models/book.dart';
import 'package:uuid/uuid.dart';

class OpenLibraryService {
  static const String _baseUrl = 'https://openlibrary.org';
  static const String _coversUrl = 'https://covers.openlibrary.org/b/id';

  Future<List<Book>> searchBooks(String query) async {
    if (query.isEmpty) return [];

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/search.json?q=${Uri.encodeComponent(query)}&fields=key,title,author_name,editions,editions.key,editions.title,editions.language,editions.description,editions.isbn,first_publish_year,isbn,cover_i,subject,description&limit=40'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final docs = data['docs'] as List<dynamic>;

        return docs.map((doc) => _mapToBook(doc)).toList();
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      throw Exception('Failed to search books: $e');
    }
  }

  Future<Book> getBookDetails(Book book) async {
    String? description = book.description;
    String? isbn = book.isbn;

    try {
      // 1. Fetch Work Details
      if (book.id.startsWith('/works/')) {
        final workUrl = '$_baseUrl${book.id}.json';
        final workResponse = await http.get(Uri.parse(workUrl));

        if (workResponse.statusCode == 200) {
          final workData = json.decode(workResponse.body);
          
          // Parse Description
          final descData = workData['description'];
          if (descData is String) {
            description = descData;
          } else if (descData is Map) {
            description = descData['value'] as String?;
          }

          // 2. Check for cover_edition to get ISBN if missing
          if (isbn == null) {
            final coverEditionKey = workData['cover_edition']?['key'] as String?;
            if (coverEditionKey != null) {
              final editionUrl = '$_baseUrl$coverEditionKey.json';
              final editionResponse = await http.get(Uri.parse(editionUrl));

              if (editionResponse.statusCode == 200) {
                final editionData = json.decode(editionResponse.body);
                final isbn10 = (editionData['isbn_10'] as List<dynamic>?)?.firstOrNull as String?;
                final isbn13 = (editionData['isbn_13'] as List<dynamic>?)?.firstOrNull as String?;
                isbn = isbn13 ?? isbn10;
              }
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching book details: $e');
    }

    return book.copyWith(
      description: description,
      isbn: isbn,
    );
  }

  Book _mapToBook(Map<String, dynamic> doc) {
    final key = doc['key'] as String? ?? const Uuid().v4();
    final title = doc['title'] as String? ?? 'Unknown Title';
    final authorName = (doc['author_name'] as List<dynamic>?)?.firstOrNull as String? ?? 'Unknown Author';
    
    // Try to get ISBN from editions first, then fallback to top-level isbn list
    String? isbn;
    String? description = doc['description'] is String ? doc['description'] : (doc['description'] is Map ? doc['description']['value'] : null);
    
    // Check editions if available (requires 'editions' field in search query)
    if (doc.containsKey('editions') && doc['editions'] is Map) {
      final editionsDocs = doc['editions']['docs'] as List<dynamic>?;
      if (editionsDocs != null && editionsDocs.isNotEmpty) {
        final firstEdition = editionsDocs.first as Map<String, dynamic>;
        
        // Try to get description from edition if missing
        if (description == null) {
           final edDesc = firstEdition['description'];
           if (edDesc is String) description = edDesc;
           else if (edDesc is Map) description = edDesc['value'];
        }

        final editionIsbns = firstEdition['isbn'] as List<dynamic>?;
        if (editionIsbns != null && editionIsbns.isNotEmpty) {
           // Prefer ISBN-13 (usually starts with 978 or 979)
           isbn = editionIsbns.firstWhere(
             (i) => i.toString().length == 13, 
             orElse: () => editionIsbns.first
           ).toString();
        }
      }
    }

    // Fallback to top-level isbn list if still null
    if (isbn == null) {
       final isbnList = (doc['isbn'] as List<dynamic>?);
       if (isbnList != null && isbnList.isNotEmpty) {
          // Prefer ISBN-13
           isbn = isbnList.firstWhere(
             (i) => i.toString().length == 13, 
             orElse: () => isbnList.first
           ).toString();
       }
    }

    final firstPublishYear = doc['first_publish_year'] as int?;
    final coverI = doc['cover_i'] as int?;
    
    // Try to determine genre from subjects
    String? genre;
    final subjects = (doc['subject'] as List<dynamic>?)?.map((e) => e.toString()).toList();
    if (subjects != null && subjects.isNotEmpty) {
      // Simple mapping logic - can be expanded
      if (subjects.any((s) => s.toLowerCase().contains('fiction'))) genre = 'Fiction';
      else if (subjects.any((s) => s.toLowerCase().contains('history'))) genre = 'History';
      else if (subjects.any((s) => s.toLowerCase().contains('biography'))) genre = 'Biography';
      else if (subjects.any((s) => s.toLowerCase().contains('science'))) genre = 'Science';
      else genre = 'Custom';
    }

    return Book(
      id: key, // Use OpenLibrary key as temporary ID
      title: title,
      author: authorName,
      isbn: isbn,
      description: description,
      publicationYear: firstPublishYear,
      genre: genre,
      customGenre: genre == 'Custom' ? subjects?.firstOrNull : null,
      coverUrl: coverI != null ? '$_coversUrl/$coverI-L.jpg' : null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
