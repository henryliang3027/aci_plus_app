import 'package:aci_plus_app/repositories/config.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mdu_config.g.dart';

/// 定義使用者的設定檔資料結構
@JsonSerializable()
@HiveType(typeId: 4)
class MDUConfig extends Config {
  const MDUConfig({
    required super.id,
    required super.name,
    // required super.splitOption,
    required super.firstChannelLoadingFrequency,
    required super.firstChannelLoadingLevel,
    required super.lastChannelLoadingFrequency,
    required super.lastChannelLoadingLevel,
    // required super.isDefault,
  });

  factory MDUConfig.fromJson(Map<String, dynamic> json) =>
      _$MDUConfigFromJson(json);

  Map<String, dynamic> toJson() => _$MDUConfigToJson(this);
}
