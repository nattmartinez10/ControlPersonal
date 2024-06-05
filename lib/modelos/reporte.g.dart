// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reporte.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReporteAdapter extends TypeAdapter<Reporte> {
  @override
  final int typeId = 0;

  @override
  Reporte read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reporte(
      id: fields[0] as int,
      idUser: fields[1] as String,
      issue: fields[2] as String,
      rating: fields[3] as String,
      duration: fields[4] as String,
      idClient: fields[5] as String,
      idReport: fields[6] as String,
      startTime: fields[7] as String,
      description: fields[8] as String,
      creationDate: fields[9] as String,
      isSent: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Reporte obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.idUser)
      ..writeByte(2)
      ..write(obj.issue)
      ..writeByte(3)
      ..write(obj.rating)
      ..writeByte(4)
      ..write(obj.duration)
      ..writeByte(5)
      ..write(obj.idClient)
      ..writeByte(6)
      ..write(obj.idReport)
      ..writeByte(7)
      ..write(obj.startTime)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.creationDate)
      ..writeByte(10)
      ..write(obj.isSent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReporteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
