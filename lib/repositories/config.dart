import 'package:hive/hive.dart';
part 'config.g.dart';

/// 定義使用者的設定檔資料結構
class Config {
  const Config({
    required this.partId,
    required this.firstChannelLoadingFrequency,
    required this.lastChannelLoadingFrequency,
    required this.firstChannelLoadingLevel,
    required this.lastChannelLoadingLevel,
  });

  @HiveField(0, defaultValue: '')
  final String partId;

  @HiveField(1, defaultValue: '')
  final String firstChannelLoadingFrequency;

  @HiveField(2, defaultValue: '')
  final String lastChannelLoadingFrequency;

  @HiveField(3, defaultValue: '')
  final String firstChannelLoadingLevel;

  @HiveField(4, defaultValue: '')
  final String lastChannelLoadingLevel;
}
