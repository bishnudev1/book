// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sitter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SitterAdapter extends TypeAdapter<Sitter> {
  @override
  final int typeId = 1;

  @override
  Sitter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sitter(
      first_name: fields[0] as String?,
      last_name: fields[1] as String?,
      rating: fields[2] as String?,
      description: fields[3] as String?,
      services: (fields[4] as List?)?.cast<Services>(),
      per_hour_rate: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Sitter obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.first_name)
      ..writeByte(1)
      ..write(obj.last_name)
      ..writeByte(2)
      ..write(obj.rating)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.services)
      ..writeByte(5)
      ..write(obj.per_hour_rate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SitterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
