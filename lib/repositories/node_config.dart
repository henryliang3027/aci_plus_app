import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'node_config.g.dart';

/// 定義使用者的設定檔資料結構
@JsonSerializable()
@HiveType(typeId: 3)
class NodeConfig {
  const NodeConfig({
    required this.id,
    required this.name,
    required this.forwardMode,
    required this.forwardConfig,
    // required this.splitOption,
  });

  @JsonKey(name: '0')
  @HiveField(0, defaultValue: -1)
  final int id;

  @JsonKey(name: '1')
  @HiveField(1, defaultValue: '')
  final String name;

  @JsonKey(name: '2')
  @HiveField(2, defaultValue: '120')
  final String forwardMode;

  @JsonKey(name: '3')
  @HiveField(3, defaultValue: '1')
  final String forwardConfig;

  // @JsonKey(name: '4')
  // @HiveField(4, defaultValue: '0')
  // final String splitOption;

  factory NodeConfig.fromJson(Map<String, dynamic> json) =>
      _$NodeConfigFromJson(json);

  Map<String, dynamic> toJson() => _$NodeConfigToJson(this);
}
