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
      splitOption: fields[1] == null ? '0' : fields[1] as String,
      firstChannelLoadingFrequency:
          fields[2] == null ? '258' : fields[2] as String,
      firstChannelLoadingLevel:
          fields[3] == null ? '34.0' : fields[3] as String,
      lastChannelLoadingFrequency:
          fields[4] == null ? '1794' : fields[4] as String,
      lastChannelLoadingLevel: fields[5] == null ? '51.1' : fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Config obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.partId)
      ..writeByte(1)
      ..write(obj.splitOption)
      ..writeByte(2)
      ..write(obj.firstChannelLoadingFrequency)
      ..writeByte(3)
      ..write(obj.firstChannelLoadingLevel)
      ..writeByte(4)
      ..write(obj.lastChannelLoadingFrequency)
      ..writeByte(5)
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

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Config _$ConfigFromJson(Map<String, dynamic> json) => Config(
      partId: json['0'] as String,
      splitOption: json['1'] as String,
      firstChannelLoadingFrequency: json['2'] as String,
      firstChannelLoadingLevel: json['3'] as String,
      lastChannelLoadingFrequency: json['4'] as String,
      lastChannelLoadingLevel: json['5'] as String,
    );

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
      '0': instance.partId,
      '1': instance.splitOption,
      '2': instance.firstChannelLoadingFrequency,
      '3': instance.firstChannelLoadingLevel,
      '4': instance.lastChannelLoadingFrequency,
      '5': instance.lastChannelLoadingLevel,
    };
