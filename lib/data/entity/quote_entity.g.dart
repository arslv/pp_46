// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuoteEntityAdapter extends TypeAdapter<QuoteEntity> {
  @override
  final int typeId = 2;

  @override
  QuoteEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuoteEntity(
      quote: fields[0] as String,
      author: fields[1] as String,
      isLiked: fields[2] as bool,
      category: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, QuoteEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.quote)
      ..writeByte(1)
      ..write(obj.author)
      ..writeByte(2)
      ..write(obj.isLiked)
      ..writeByte(3)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuoteEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
