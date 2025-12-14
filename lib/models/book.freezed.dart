// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Book _$BookFromJson(Map<String, dynamic> json) {
  return _Book.fromJson(json);
}

/// @nodoc
mixin _$Book {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get title => throw _privateConstructorUsedError;
  @HiveField(2)
  String get author => throw _privateConstructorUsedError;
  @HiveField(3)
  String? get isbn => throw _privateConstructorUsedError;
  @HiveField(4)
  String? get description => throw _privateConstructorUsedError;
  @HiveField(5)
  int? get publicationYear => throw _privateConstructorUsedError;
  @HiveField(6)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(7)
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @HiveField(8)
  String? get genre => throw _privateConstructorUsedError;
  @HiveField(9)
  String? get customGenre => throw _privateConstructorUsedError;
  @HiveField(10)
  bool get isFavorite => throw _privateConstructorUsedError;
  @HiveField(11)
  String get readingStatus => throw _privateConstructorUsedError;
  @HiveField(12)
  String? get coverUrl => throw _privateConstructorUsedError;

  /// Serializes this Book to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Book
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookCopyWith<Book> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookCopyWith<$Res> {
  factory $BookCopyWith(Book value, $Res Function(Book) then) =
      _$BookCopyWithImpl<$Res, Book>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String title,
      @HiveField(2) String author,
      @HiveField(3) String? isbn,
      @HiveField(4) String? description,
      @HiveField(5) int? publicationYear,
      @HiveField(6) DateTime createdAt,
      @HiveField(7) DateTime updatedAt,
      @HiveField(8) String? genre,
      @HiveField(9) String? customGenre,
      @HiveField(10) bool isFavorite,
      @HiveField(11) String readingStatus,
      @HiveField(12) String? coverUrl});
}

/// @nodoc
class _$BookCopyWithImpl<$Res, $Val extends Book>
    implements $BookCopyWith<$Res> {
  _$BookCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Book
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? author = null,
    Object? isbn = freezed,
    Object? description = freezed,
    Object? publicationYear = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? genre = freezed,
    Object? customGenre = freezed,
    Object? isFavorite = null,
    Object? readingStatus = null,
    Object? coverUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      isbn: freezed == isbn
          ? _value.isbn
          : isbn // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      publicationYear: freezed == publicationYear
          ? _value.publicationYear
          : publicationYear // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      genre: freezed == genre
          ? _value.genre
          : genre // ignore: cast_nullable_to_non_nullable
              as String?,
      customGenre: freezed == customGenre
          ? _value.customGenre
          : customGenre // ignore: cast_nullable_to_non_nullable
              as String?,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      readingStatus: null == readingStatus
          ? _value.readingStatus
          : readingStatus // ignore: cast_nullable_to_non_nullable
              as String,
      coverUrl: freezed == coverUrl
          ? _value.coverUrl
          : coverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookImplCopyWith<$Res> implements $BookCopyWith<$Res> {
  factory _$$BookImplCopyWith(
          _$BookImpl value, $Res Function(_$BookImpl) then) =
      __$$BookImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String title,
      @HiveField(2) String author,
      @HiveField(3) String? isbn,
      @HiveField(4) String? description,
      @HiveField(5) int? publicationYear,
      @HiveField(6) DateTime createdAt,
      @HiveField(7) DateTime updatedAt,
      @HiveField(8) String? genre,
      @HiveField(9) String? customGenre,
      @HiveField(10) bool isFavorite,
      @HiveField(11) String readingStatus,
      @HiveField(12) String? coverUrl});
}

/// @nodoc
class __$$BookImplCopyWithImpl<$Res>
    extends _$BookCopyWithImpl<$Res, _$BookImpl>
    implements _$$BookImplCopyWith<$Res> {
  __$$BookImplCopyWithImpl(_$BookImpl _value, $Res Function(_$BookImpl) _then)
      : super(_value, _then);

  /// Create a copy of Book
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? author = null,
    Object? isbn = freezed,
    Object? description = freezed,
    Object? publicationYear = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? genre = freezed,
    Object? customGenre = freezed,
    Object? isFavorite = null,
    Object? readingStatus = null,
    Object? coverUrl = freezed,
  }) {
    return _then(_$BookImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      isbn: freezed == isbn
          ? _value.isbn
          : isbn // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      publicationYear: freezed == publicationYear
          ? _value.publicationYear
          : publicationYear // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      genre: freezed == genre
          ? _value.genre
          : genre // ignore: cast_nullable_to_non_nullable
              as String?,
      customGenre: freezed == customGenre
          ? _value.customGenre
          : customGenre // ignore: cast_nullable_to_non_nullable
              as String?,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      readingStatus: null == readingStatus
          ? _value.readingStatus
          : readingStatus // ignore: cast_nullable_to_non_nullable
              as String,
      coverUrl: freezed == coverUrl
          ? _value.coverUrl
          : coverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookImpl extends _Book {
  const _$BookImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.title,
      @HiveField(2) required this.author,
      @HiveField(3) this.isbn,
      @HiveField(4) this.description,
      @HiveField(5) this.publicationYear,
      @HiveField(6) required this.createdAt,
      @HiveField(7) required this.updatedAt,
      @HiveField(8) this.genre,
      @HiveField(9) this.customGenre,
      @HiveField(10) this.isFavorite = false,
      @HiveField(11) this.readingStatus = 'to_read',
      @HiveField(12) this.coverUrl})
      : super._();

  factory _$BookImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String title;
  @override
  @HiveField(2)
  final String author;
  @override
  @HiveField(3)
  final String? isbn;
  @override
  @HiveField(4)
  final String? description;
  @override
  @HiveField(5)
  final int? publicationYear;
  @override
  @HiveField(6)
  final DateTime createdAt;
  @override
  @HiveField(7)
  final DateTime updatedAt;
  @override
  @HiveField(8)
  final String? genre;
  @override
  @HiveField(9)
  final String? customGenre;
  @override
  @JsonKey()
  @HiveField(10)
  final bool isFavorite;
  @override
  @JsonKey()
  @HiveField(11)
  final String readingStatus;
  @override
  @HiveField(12)
  final String? coverUrl;

  @override
  String toString() {
    return 'Book(id: $id, title: $title, author: $author, isbn: $isbn, description: $description, publicationYear: $publicationYear, createdAt: $createdAt, updatedAt: $updatedAt, genre: $genre, customGenre: $customGenre, isFavorite: $isFavorite, readingStatus: $readingStatus, coverUrl: $coverUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.isbn, isbn) || other.isbn == isbn) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.publicationYear, publicationYear) ||
                other.publicationYear == publicationYear) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.genre, genre) || other.genre == genre) &&
            (identical(other.customGenre, customGenre) ||
                other.customGenre == customGenre) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.readingStatus, readingStatus) ||
                other.readingStatus == readingStatus) &&
            (identical(other.coverUrl, coverUrl) ||
                other.coverUrl == coverUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      author,
      isbn,
      description,
      publicationYear,
      createdAt,
      updatedAt,
      genre,
      customGenre,
      isFavorite,
      readingStatus,
      coverUrl);

  /// Create a copy of Book
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookImplCopyWith<_$BookImpl> get copyWith =>
      __$$BookImplCopyWithImpl<_$BookImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookImplToJson(
      this,
    );
  }
}

abstract class _Book extends Book {
  const factory _Book(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String title,
      @HiveField(2) required final String author,
      @HiveField(3) final String? isbn,
      @HiveField(4) final String? description,
      @HiveField(5) final int? publicationYear,
      @HiveField(6) required final DateTime createdAt,
      @HiveField(7) required final DateTime updatedAt,
      @HiveField(8) final String? genre,
      @HiveField(9) final String? customGenre,
      @HiveField(10) final bool isFavorite,
      @HiveField(11) final String readingStatus,
      @HiveField(12) final String? coverUrl}) = _$BookImpl;
  const _Book._() : super._();

  factory _Book.fromJson(Map<String, dynamic> json) = _$BookImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get title;
  @override
  @HiveField(2)
  String get author;
  @override
  @HiveField(3)
  String? get isbn;
  @override
  @HiveField(4)
  String? get description;
  @override
  @HiveField(5)
  int? get publicationYear;
  @override
  @HiveField(6)
  DateTime get createdAt;
  @override
  @HiveField(7)
  DateTime get updatedAt;
  @override
  @HiveField(8)
  String? get genre;
  @override
  @HiveField(9)
  String? get customGenre;
  @override
  @HiveField(10)
  bool get isFavorite;
  @override
  @HiveField(11)
  String get readingStatus;
  @override
  @HiveField(12)
  String? get coverUrl;

  /// Create a copy of Book
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookImplCopyWith<_$BookImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
