import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'book.freezed.dart';
part 'book.g.dart';

@freezed
@HiveType(typeId: 0)
class Book with _$Book {
  const factory Book({
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    @HiveField(2) required String author,
    @HiveField(3) String? isbn,
    @HiveField(4) String? description,
    @HiveField(5) int? publicationYear,
    @HiveField(6) required DateTime createdAt,
    @HiveField(7) required DateTime updatedAt,
    @HiveField(8) String? genre,
    @HiveField(9) String? customGenre,
    @HiveField(10) @Default(false) bool isFavorite,
    @HiveField(11) @Default('to_read') String readingStatus,
    @HiveField(12) String? coverUrl,
  }) = _Book;

  const Book._();

  factory Book.fromJson(Map<String, dynamic> json) =>
      _$BookFromJson(json);
}
