// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookAdapter extends TypeAdapter<Book> {
  @override
  final int typeId = 0;

  @override
  Book read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Book(
      id: fields[0] as String,
      title: fields[1] as String,
      author: fields[2] as String,
      isbn: fields[3] as String?,
      description: fields[4] as String?,
      publicationYear: fields[5] as int?,
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime,
      genre: fields[8] as String?,
      customGenre: fields[9] as String?,
      isFavorite: fields[10] as bool,
      readingStatus: fields[11] as String,
      coverUrl: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Book obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.author)
      ..writeByte(3)
      ..write(obj.isbn)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.publicationYear)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.genre)
      ..writeByte(9)
      ..write(obj.customGenre)
      ..writeByte(10)
      ..write(obj.isFavorite)
      ..writeByte(11)
      ..write(obj.readingStatus)
      ..writeByte(12)
      ..write(obj.coverUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookImpl _$$BookImplFromJson(Map<String, dynamic> json) => _$BookImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      isbn: json['isbn'] as String?,
      description: json['description'] as String?,
      publicationYear: (json['publicationYear'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      genre: json['genre'] as String?,
      customGenre: json['customGenre'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      readingStatus: json['readingStatus'] as String? ?? 'to_read',
      coverUrl: json['coverUrl'] as String?,
    );

Map<String, dynamic> _$$BookImplToJson(_$BookImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'author': instance.author,
      'isbn': instance.isbn,
      'description': instance.description,
      'publicationYear': instance.publicationYear,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'genre': instance.genre,
      'customGenre': instance.customGenre,
      'isFavorite': instance.isFavorite,
      'readingStatus': instance.readingStatus,
      'coverUrl': instance.coverUrl,
    };
