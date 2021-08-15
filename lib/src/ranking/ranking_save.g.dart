// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranking_save.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RankingSaveAdapter extends TypeAdapter<RankingSave> {
  @override
  final int typeId = 1;

  @override
  RankingSave read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RankingSave()
      ..additionL1 = (fields[0] as List).cast<double>()
      ..subtractionL1 = (fields[1] as List).cast<double>()
      ..additionL2 = (fields[2] as List).cast<double>()
      ..subtractionL2 = (fields[3] as List).cast<double>()
      ..name = fields[4] as String
      ..isNameSet = fields[5] as bool;
  }

  @override
  void write(BinaryWriter writer, RankingSave obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.additionL1)
      ..writeByte(1)
      ..write(obj.subtractionL1)
      ..writeByte(2)
      ..write(obj.additionL2)
      ..writeByte(3)
      ..write(obj.subtractionL2)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.isNameSet);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RankingSaveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
