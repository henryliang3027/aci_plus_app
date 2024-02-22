import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'config.g.dart';

/// 定義使用者的設定檔資料結構
@JsonSerializable()
@HiveType(typeId: 1)
class Config {
  const Config({
    required this.partId,
    required this.splitOption,
    required this.firstChannelLoadingFrequency,
    required this.firstChannelLoadingLevel,
    required this.lastChannelLoadingFrequency,
    required this.lastChannelLoadingLevel,
  });

  @JsonKey(name: '0')
  @HiveField(0, defaultValue: '')
  final String partId;

  @JsonKey(name: '1')
  @HiveField(1, defaultValue: '0')
  final String splitOption;

  @JsonKey(name: '2')
  @HiveField(2, defaultValue: '258')
  final String firstChannelLoadingFrequency;

  @JsonKey(name: '3')
  @HiveField(3, defaultValue: '34.0')
  final String firstChannelLoadingLevel;

  @JsonKey(name: '4')
  @HiveField(4, defaultValue: '1794')
  final String lastChannelLoadingFrequency;

  @JsonKey(name: '5')
  @HiveField(5, defaultValue: '51.1')
  final String lastChannelLoadingLevel;

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigToJson(this);
}
