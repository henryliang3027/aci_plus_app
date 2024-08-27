// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'distribution_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DistributionConfigAdapter extends TypeAdapter<DistributionConfig> {
  @override
  final int typeId = 2;

  @override
  DistributionConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DistributionConfig(
      id: fields[0] == null ? -1 : fields[0] as int,
      name: fields[1] == null ? '' : fields[1] as String,
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
  void write(BinaryWriter writer, DistributionConfig obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
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
      other is DistributionConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DistributionConfig _$DistributionConfigFromJson(Map<String, dynamic> json) =>
    DistributionConfig(
      id: json['0'] as int,
      name: json['1'] as String,
      firstChannelLoadingFrequency: json['2'] as String,
      firstChannelLoadingLevel: json['3'] as String,
      lastChannelLoadingFrequency: json['4'] as String,
      lastChannelLoadingLevel: json['5'] as String,
    );

Map<String, dynamic> _$DistributionConfigToJson(DistributionConfig instance) =>
    <String, dynamic>{
      '0': instance.id,
      '1': instance.name,
      '2': instance.firstChannelLoadingFrequency,
      '3': instance.firstChannelLoadingLevel,
      '4': instance.lastChannelLoadingFrequency,
      '5': instance.lastChannelLoadingLevel,
    };
