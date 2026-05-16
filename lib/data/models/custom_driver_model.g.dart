// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_driver_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomDriverAdapter extends TypeAdapter<CustomDriver> {
  @override
  final int typeId = 0;

  @override
  CustomDriver read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomDriver(
      id: fields[0] as String,
      name: fields[1] as String,
      team: fields[2] as String,
      nationality: fields[3] as String,
      number: fields[4] as int,
      bio: fields[5] as String?,
      wins: fields[6] as int,
      podiums: fields[7] as int,
      poles: fields[8] as int,
      points: fields[9] as double,
    );
  }

  @override
  void write(BinaryWriter writer, CustomDriver obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.team)
      ..writeByte(3)
      ..write(obj.nationality)
      ..writeByte(4)
      ..write(obj.number)
      ..writeByte(5)
      ..write(obj.bio)
      ..writeByte(6)
      ..write(obj.wins)
      ..writeByte(7)
      ..write(obj.podiums)
      ..writeByte(8)
      ..write(obj.poles)
      ..writeByte(9)
      ..write(obj.points);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomDriverAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
