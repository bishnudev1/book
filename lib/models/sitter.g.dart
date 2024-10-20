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
      email: fields[6] as String?,
      user_type: fields[7] as String?,
      zip_code: fields[8] as String?,
      id: fields[9] as int?,
      profile_pic: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Sitter obj) {
    writer
      ..writeByte(11)
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
      ..write(obj.per_hour_rate)
      ..writeByte(6)
      ..write(obj.email)
      ..writeByte(7)
      ..write(obj.user_type)
      ..writeByte(8)
      ..write(obj.zip_code)
      ..writeByte(9)
      ..write(obj.id)
      ..writeByte(10)
      ..write(obj.profile_pic);
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
