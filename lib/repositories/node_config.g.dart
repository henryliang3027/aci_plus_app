// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NodeConfigAdapter extends TypeAdapter<NodeConfig> {
  @override
  final int typeId = 3;

  @override
  NodeConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NodeConfig(
      id: fields[0] == null ? -1 : fields[0] as int,
      name: fields[1] == null ? '' : fields[1] as String,
      forwardMode: fields[2] == null ? '120' : fields[2] as String,
      forwardConfig: fields[3] == null ? '1' : fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NodeConfig obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.forwardMode)
      ..writeByte(3)
      ..write(obj.forwardConfig);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NodeConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NodeConfig _$NodeConfigFromJson(Map<String, dynamic> json) => NodeConfig(
      id: json['0'] as int,
      name: json['1'] as String,
      forwardMode: json['2'] as String,
      forwardConfig: json['3'] as String,
    );

Map<String, dynamic> _$NodeConfigToJson(NodeConfig instance) =>
    <String, dynamic>{
      '0': instance.id,
      '1': instance.name,
      '2': instance.forwardMode,
      '3': instance.forwardConfig,
    };
