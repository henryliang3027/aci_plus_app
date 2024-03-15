import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

class Config {
  const Config({
    required this.id,
    required this.name,
    required this.splitOption,
    required this.firstChannelLoadingFrequency,
    required this.firstChannelLoadingLevel,
    required this.lastChannelLoadingFrequency,
    required this.lastChannelLoadingLevel,
    // required this.isDefault,
  });

  @JsonKey(name: '0')
  @HiveField(0, defaultValue: -1)
  final int id;

  @JsonKey(name: '1')
  @HiveField(1, defaultValue: '')
  final String name;

  @JsonKey(name: '2')
  @HiveField(2, defaultValue: '0')
  final String splitOption;

  @JsonKey(name: '3')
  @HiveField(3, defaultValue: '258')
  final String firstChannelLoadingFrequency;

  @JsonKey(name: '4')
  @HiveField(4, defaultValue: '34.0')
  final String firstChannelLoadingLevel;

  @JsonKey(name: '5')
  @HiveField(5, defaultValue: '1794')
  final String lastChannelLoadingFrequency;

  @JsonKey(name: '6')
  @HiveField(6, defaultValue: '51.1')
  final String lastChannelLoadingLevel;

  // @JsonKey(name: '7')
  // @HiveField(7, defaultValue: '0')
  // final String isDefault;
}
