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
      id: fields[0] == null ? -1 : fields[0] as int,
      groupId: fields[1] == null ? '' : fields[1] as String,
      name: fields[2] == null ? '' : fields[2] as String,
      splitOption: fields[3] == null ? '0' : fields[3] as String,
      firstChannelLoadingFrequency:
          fields[4] == null ? '258' : fields[4] as String,
      firstChannelLoadingLevel:
          fields[5] == null ? '34.0' : fields[5] as String,
      lastChannelLoadingFrequency:
          fields[6] == null ? '1794' : fields[6] as String,
      lastChannelLoadingLevel: fields[7] == null ? '51.1' : fields[7] as String,
      isDefault: fields[8] == null ? '0' : fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Config obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.groupId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.splitOption)
      ..writeByte(4)
      ..write(obj.firstChannelLoadingFrequency)
      ..writeByte(5)
      ..write(obj.firstChannelLoadingLevel)
      ..writeByte(6)
      ..write(obj.lastChannelLoadingFrequency)
      ..writeByte(7)
      ..write(obj.lastChannelLoadingLevel)
      ..writeByte(8)
      ..write(obj.isDefault);
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
      id: json['0'] as int,
      groupId: json['1'] as String,
      name: json['2'] as String,
      splitOption: json['3'] as String,
      firstChannelLoadingFrequency: json['4'] as String,
      firstChannelLoadingLevel: json['5'] as String,
      lastChannelLoadingFrequency: json['6'] as String,
      lastChannelLoadingLevel: json['7'] as String,
      isDefault: json['8'] as String,
    );

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
      '0': instance.id,
      '1': instance.groupId,
      '2': instance.name,
      '3': instance.splitOption,
      '4': instance.firstChannelLoadingFrequency,
      '5': instance.firstChannelLoadingLevel,
      '6': instance.lastChannelLoadingFrequency,
      '7': instance.lastChannelLoadingLevel,
      '8': instance.isDefault,
    };
