// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'idea_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IdeaAdapter extends TypeAdapter<Idea> {
  @override
  final int typeId = 1;

  @override
  Idea read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Idea(
      name: fields[0] as String,
      text: fields[1] as String,
      dateTime: fields[2] as DateTime,
      base64Image: fields[3] as String,
      isLiked: fields[4] as bool,
      category: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Idea obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.dateTime)
      ..writeByte(3)
      ..write(obj.base64Image)
      ..writeByte(4)
      ..write(obj.isLiked)
      ..writeByte(5)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdeaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
