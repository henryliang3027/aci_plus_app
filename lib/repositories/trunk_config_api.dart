import 'package:aci_plus_app/repositories/trunk_config.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TrunkConfigApi {
  TrunkConfigApi() : _trunkConfigBox = Hive.box('TrunkConfigData');
  final Box<TrunkConfig> _trunkConfigBox;

  List<TrunkConfig> getAllConfigs() {
    return _trunkConfigBox.values.toList();
  }

  /// 新增 config 到手機端資料庫, 如果該 part id 已存在, 則 put() 會更新其資料
  Future<void> putConfig({
    required int id,
    required String name,
    required String splitOption,
    required String firstChannelLoadingFrequency,
    required String firstChannelLoadingLevel,
    required String lastChannelLoadingFrequency,
    required String lastChannelLoadingLevel,
    required String isDefault,
  }) async {
    TrunkConfig newConfig = TrunkConfig(
      id: id,
      name: name,
      splitOption: splitOption,
      firstChannelLoadingFrequency: firstChannelLoadingFrequency,
      firstChannelLoadingLevel: firstChannelLoadingLevel,
      lastChannelLoadingFrequency: lastChannelLoadingFrequency,
      lastChannelLoadingLevel: lastChannelLoadingLevel,
      isDefault: isDefault,
    );
    await _trunkConfigBox.put(id, newConfig);
  }

  Future<void> setDefaultConfigById({
    required int id,
  }) async {
    List<TrunkConfig> configs = getAllConfigs();

    TrunkConfig? defaultConfig;

    for (TrunkConfig config in configs) {
      if (config.isDefault == '1') {
        defaultConfig = config;
      }
    }

    // 如果已經有預設的 config, 則先將該 config 改為非預設
    if (defaultConfig != null) {
      TrunkConfig canceledDefaultConfig = TrunkConfig(
        id: defaultConfig.id,
        name: defaultConfig.name,
        splitOption: defaultConfig.splitOption,
        firstChannelLoadingFrequency:
            defaultConfig.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: defaultConfig.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: defaultConfig.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: defaultConfig.lastChannelLoadingLevel,
        isDefault: '0',
      );

      await _trunkConfigBox.put(defaultConfig.id, canceledDefaultConfig);
    }

    List<dynamic> result = getConfigById(id);

    if (result[0]) {
      TrunkConfig targetConfig = result[1];

      TrunkConfig newDefaultConfig = TrunkConfig(
        id: targetConfig.id,
        name: targetConfig.name,
        splitOption: targetConfig.splitOption,
        firstChannelLoadingFrequency: targetConfig.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: targetConfig.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: targetConfig.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: targetConfig.lastChannelLoadingLevel,
        isDefault: '1',
      );

      await _trunkConfigBox.put(targetConfig.id, newDefaultConfig);
    }
  }

  List<dynamic> getDefaultConfig() {
    List<TrunkConfig> configs = getAllConfigs();

    for (TrunkConfig config in configs) {
      if (config.isDefault == '1') {
        return [true, config];
      }
    }

    return [false, 'default config does not exist'];
  }

  /// 藉由 config id 取得 config 參數
  List<dynamic> getConfigById(
    int id,
  ) {
    TrunkConfig? config =
        _trunkConfigBox.get(id); //get config if it already exists

    if (config != null) {
      return [true, config];
    } else {
      return [false, 'config does not exist.'];
    }
  }

  Future<void> deleteConfigByid(int id) async {
    await _trunkConfigBox.delete(id);
  }

  Future<void> deleteAllConfig() async {
    await _trunkConfigBox.deleteAll(_trunkConfigBox.keys);
  }
}
