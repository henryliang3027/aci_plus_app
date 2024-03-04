// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trunk_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrunkConfigAdapter extends TypeAdapter<TrunkConfig> {
  @override
  final int typeId = 1;

  @override
  TrunkConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrunkConfig(
      id: fields[0] == null ? -1 : fields[0] as int,
      name: fields[1] == null ? '' : fields[1] as String,
      splitOption: fields[2] == null ? '0' : fields[2] as String,
      firstChannelLoadingFrequency:
          fields[3] == null ? '258' : fields[3] as String,
      firstChannelLoadingLevel:
          fields[4] == null ? '34.0' : fields[4] as String,
      lastChannelLoadingFrequency:
          fields[5] == null ? '1794' : fields[5] as String,
      lastChannelLoadingLevel: fields[6] == null ? '51.1' : fields[6] as String,
      isDefault: fields[7] == null ? '0' : fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TrunkConfig obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.splitOption)
      ..writeByte(3)
      ..write(obj.firstChannelLoadingFrequency)
      ..writeByte(4)
      ..write(obj.firstChannelLoadingLevel)
      ..writeByte(5)
      ..write(obj.lastChannelLoadingFrequency)
      ..writeByte(6)
      ..write(obj.lastChannelLoadingLevel)
      ..writeByte(7)
      ..write(obj.isDefault);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrunkConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrunkConfig _$TrunkConfigFromJson(Map<String, dynamic> json) => TrunkConfig(
      id: json['0'] as int,
      name: json['1'] as String,
      splitOption: json['2'] as String,
      firstChannelLoadingFrequency: json['3'] as String,
      firstChannelLoadingLevel: json['4'] as String,
      lastChannelLoadingFrequency: json['5'] as String,
      lastChannelLoadingLevel: json['6'] as String,
      isDefault: json['7'] as String,
    );

Map<String, dynamic> _$TrunkConfigToJson(TrunkConfig instance) =>
    <String, dynamic>{
      '0': instance.id,
      '1': instance.name,
      '2': instance.splitOption,
      '3': instance.firstChannelLoadingFrequency,
      '4': instance.firstChannelLoadingLevel,
      '5': instance.lastChannelLoadingFrequency,
      '6': instance.lastChannelLoadingLevel,
      '7': instance.isDefault,
    };
