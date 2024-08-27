import 'package:aci_plus_app/repositories/distribution_config.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DistributionConfigApi {
  DistributionConfigApi()
      : _distributionConfigBox = Hive.box('DistributionConfigData');
  final Box<DistributionConfig> _distributionConfigBox;

  List<DistributionConfig> getAllConfigs() {
    return _distributionConfigBox.values.toList();
  }

  /// 新增 config 到手機端資料庫, 如果該 part id 已存在, 則 put() 會更新其資料
  Future<void> putConfig({
    required int id,
    required String name,
    // required String splitOption,
    required String firstChannelLoadingFrequency,
    required String firstChannelLoadingLevel,
    required String lastChannelLoadingFrequency,
    required String lastChannelLoadingLevel,
    // required String isDefault,
  }) async {
    DistributionConfig newConfig = DistributionConfig(
      id: id,
      name: name,
      // splitOption: splitOption,
      firstChannelLoadingFrequency: firstChannelLoadingFrequency,
      firstChannelLoadingLevel: firstChannelLoadingLevel,
      lastChannelLoadingFrequency: lastChannelLoadingFrequency,
      lastChannelLoadingLevel: lastChannelLoadingLevel,
      // isDefault: isDefault,
    );
    await _distributionConfigBox.put(id, newConfig);
  }

  // Future<void> setDefaultConfigById({
  //   required int id,
  // }) async {
  //   List<DistributionConfig> configs = getAllConfigs();

  //   DistributionConfig? defaultConfig;

  //   for (DistributionConfig config in configs) {
  //     if (config.isDefault == '1') {
  //       defaultConfig = config;
  //     }
  //   }

  //   // 如果在該 group 裡已經有預設的 config, 則先將該 config 改為非預設
  //   if (defaultConfig != null) {
  //     DistributionConfig canceledDefaultConfig = DistributionConfig(
  //       id: defaultConfig.id,
  //       name: defaultConfig.name,
  //       splitOption: defaultConfig.splitOption,
  //       firstChannelLoadingFrequency:
  //           defaultConfig.firstChannelLoadingFrequency,
  //       firstChannelLoadingLevel: defaultConfig.firstChannelLoadingLevel,
  //       lastChannelLoadingFrequency: defaultConfig.lastChannelLoadingFrequency,
  //       lastChannelLoadingLevel: defaultConfig.lastChannelLoadingLevel,
  //       isDefault: '0',
  //     );

  //     await _distributionConfigBox.put(defaultConfig.id, canceledDefaultConfig);
  //   }

  //   List<dynamic> result = getConfigById(id);

  //   if (result[0]) {
  //     DistributionConfig targetConfig = result[1];

  //     DistributionConfig newDefaultConfig = DistributionConfig(
  //       id: targetConfig.id,
  //       name: targetConfig.name,
  //       splitOption: targetConfig.splitOption,
  //       firstChannelLoadingFrequency: targetConfig.firstChannelLoadingFrequency,
  //       firstChannelLoadingLevel: targetConfig.firstChannelLoadingLevel,
  //       lastChannelLoadingFrequency: targetConfig.lastChannelLoadingFrequency,
  //       lastChannelLoadingLevel: targetConfig.lastChannelLoadingLevel,
  //       isDefault: '1',
  //     );

  //     await _distributionConfigBox.put(targetConfig.id, newDefaultConfig);
  //   }
  // }

  // List<dynamic> getDefaultConfig() {
  //   List<DistributionConfig> configs = getAllConfigs();

  //   for (DistributionConfig config in configs) {
  //     if (config.isDefault == '1') {
  //       return [true, config];
  //     }
  //   }

  //   return [false, 'default config does not exist'];
  // }

  /// 藉由 config id 取得 config 參數
  List<dynamic> getConfigById(
    int id,
  ) {
    DistributionConfig? config =
        _distributionConfigBox.get(id); //get config if it already exists

    if (config != null) {
      return [true, config];
    } else {
      return [false, 'config does not exist.'];
    }
  }

  Future<void> deleteConfigByid(int id) async {
    await _distributionConfigBox.delete(id);
  }

  Future<void> deleteAllConfig() async {
    await _distributionConfigBox.deleteAll(_distributionConfigBox.keys);
  }
}
