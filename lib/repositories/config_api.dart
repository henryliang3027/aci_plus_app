import 'package:aci_plus_app/core/shared_preference_key.dart';
import 'package:aci_plus_app/repositories/config.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigApi {
  ConfigApi() : _configBox = Hive.box('ConfigData');
  final Box<Config> _configBox;

  /// 新增 config 到手機端資料庫, 如果該 part id 已存在, 則 put() 會更新其資料
  Future<void> addConfig({
    required String groupId,
    required String name,
    required String splitOption,
    required String firstChannelLoadingFrequency,
    required String firstChannelLoadingLevel,
    required String lastChannelLoadingFrequency,
    required String lastChannelLoadingLevel,
    required String isDefault,
  }) async {
    int id = await getConfigAutoIncrementId();

    Config newConfig = Config(
      id: id,
      groupId: groupId,
      name: name,
      splitOption: splitOption,
      firstChannelLoadingFrequency: firstChannelLoadingFrequency,
      firstChannelLoadingLevel: firstChannelLoadingLevel,
      lastChannelLoadingFrequency: lastChannelLoadingFrequency,
      lastChannelLoadingLevel: lastChannelLoadingLevel,
      isDefault: isDefault,
    );
    await _configBox.put(id, newConfig);
    await writeConfigAutoIncrementId();
  }

  Future<void> updateConfig({
    required Config config,
  }) async {
    await _configBox.put(config.id, config);
  }

  Future<void> setDefaultConfigById({
    required String groupId,
    required int id,
  }) async {
    List<Config> configs = getAllConfigs();

    Config? defaultConfig;

    List<Config> filteredConfig =
        configs.where((config) => config.groupId == groupId).toList();

    for (Config config in filteredConfig) {
      if (config.isDefault == '1') {
        defaultConfig = config;
      }
    }

    // 如果在該 group 裡已經有預設的 config, 則先將該 config 改為非預設
    if (defaultConfig != null) {
      Config canceledDefaultConfig = Config(
        id: defaultConfig.id,
        groupId: defaultConfig.groupId,
        name: defaultConfig.name,
        splitOption: defaultConfig.splitOption,
        firstChannelLoadingFrequency:
            defaultConfig.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: defaultConfig.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: defaultConfig.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: defaultConfig.lastChannelLoadingLevel,
        isDefault: '0',
      );

      updateConfig(config: canceledDefaultConfig);
    }

    List<dynamic> result = getConfigById(id);

    if (result[0]) {
      Config targetConfig = result[1];

      Config newDefaultConfig = Config(
        id: targetConfig.id,
        groupId: targetConfig.groupId,
        name: targetConfig.name,
        splitOption: targetConfig.splitOption,
        firstChannelLoadingFrequency: targetConfig.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: targetConfig.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: targetConfig.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: targetConfig.lastChannelLoadingLevel,
        isDefault: '1',
      );

      updateConfig(config: newDefaultConfig);
    }
  }

  List<dynamic> getDefaultConfigByGroupId(
    String groupId,
  ) {
    List<Config> configs = getAllConfigs();

    List<Config> filteredConfigs =
        configs.where((config) => config.groupId == groupId).toList();

    for (Config config in filteredConfigs) {
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
    Config? config = _configBox.get(id); //get config if it already exists

    if (config != null) {
      return [true, config];
    } else {
      return [false, 'config does not exist.'];
    }
  }

  List<Config> getAllConfigs() {
    return _configBox.values.toList();
  }

  void deleteConfigByid(int id) {
    _configBox.delete(id);
  }

  Future<void> writeConfigAutoIncrementId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int id = prefs.getInt(SharedPreferenceKey.configAutoIncrementId.name) ?? 0;

    id = id + 1;

    await prefs.setInt(SharedPreferenceKey.configAutoIncrementId.name, id);
  }

  Future<int> getConfigAutoIncrementId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int id = prefs.getInt(SharedPreferenceKey.configAutoIncrementId.name) ?? 0;
    return id;
  }
}
