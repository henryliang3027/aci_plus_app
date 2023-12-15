// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConfigAdapter extends TypeAdapter<Config> {
  @override
  final int typeId = 1;

  @override
  Config read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Config(
      partId: fields[0] == null ? '' : fields[0] as String,
      firstChannelLoadingFrequency:
          fields[1] == null ? '' : fields[1] as String,
      lastChannelLoadingFrequency: fields[2] == null ? '' : fields[2] as String,
      firstChannelLoadingLevel: fields[3] == null ? '' : fields[3] as String,
      lastChannelLoadingLevel: fields[4] == null ? '' : fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Config obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.partId)
      ..writeByte(1)
      ..write(obj.firstChannelLoadingFrequency)
      ..writeByte(2)
      ..write(obj.lastChannelLoadingFrequency)
      ..writeByte(3)
      ..write(obj.firstChannelLoadingLevel)
      ..writeByte(4)
      ..write(obj.lastChannelLoadingLevel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
