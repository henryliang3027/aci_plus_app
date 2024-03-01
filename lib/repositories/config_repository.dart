import 'package:aci_plus_app/repositories/config.dart';
import 'package:aci_plus_app/repositories/config_api.dart';

class ConfigRepository {
  ConfigRepository() : _configApi = ConfigApi();

  final ConfigApi _configApi;
  final Map<int, ConfigName> _nameCandidates = {
    0: const ConfigName(name: 'Config0'),
    1: const ConfigName(name: 'Config1'),
    2: const ConfigName(name: 'Config2'),
    3: const ConfigName(name: 'Config3'),
    4: const ConfigName(name: 'Config4'),
    5: const ConfigName(name: 'Config5'),
    6: const ConfigName(name: 'Config6'),
    7: const ConfigName(name: 'Config7'),
    8: const ConfigName(name: 'Config8'),
    9: const ConfigName(name: 'Config9'),
  };

  String getUnusedConfigName() {
    for (int i = 0; i < _nameCandidates.length; i++) {
      if (_nameCandidates[i]!.isUsed == false) {
        ConfigName configName = _nameCandidates[i]!;
        return configName.name;
      }
    }

    return '';
  }

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
    List<Config> configs = getAllConfigs();
    int length = configs.length;

    _nameCandidates[length] = ConfigName(
      name: name,
      isUsed: true,
    );

    await _configApi.addConfig(
      groupId: groupId,
      name: name,
      splitOption: splitOption,
      firstChannelLoadingFrequency: firstChannelLoadingFrequency,
      firstChannelLoadingLevel: firstChannelLoadingLevel,
      lastChannelLoadingFrequency: lastChannelLoadingFrequency,
      lastChannelLoadingLevel: lastChannelLoadingLevel,
      isDefault: isDefault,
    );
  }

  Future<void> updateConfig({
    required Config config,
  }) async {
    _nameCandidates[config.id] = ConfigName(
      name: config.name,
      isUsed: true,
    );

    _configApi.updateConfig(config: config);
  }

  Future<void> setDefaultConfigById({
    required String groupId,
    required int id,
  }) async {
    _configApi.setDefaultConfigById(
      groupId: groupId,
      id: id,
    );
  }

  List<dynamic> getDefaultConfigByGroupId(
    String groupId,
  ) {
    return _configApi.getDefaultConfigByGroupId(groupId);
  }

  /// 藉由 config id 取得 config 參數
  List<dynamic> getConfigById(
    int id,
  ) {
    return _configApi.getConfigById(id);
  }

  List<Config> getAllConfigs() {
    List<Config> configs = _configApi.getAllConfigs();

    for (int i = 0; i < configs.length; i++) {
      Config config = configs[i];
      _nameCandidates[i] = ConfigName(
        name: config.name,
        isUsed: true,
      );
    }

    for (MapEntry entry in _nameCandidates.entries) {
      ConfigName configName = entry.value;
      print('${entry.key}: ${configName.name}, ${configName.isUsed}');
    }

    return configs;
  }

  void deleteConfigByid(int id) {
    _nameCandidates[id] = ConfigName(
      name: 'Config$id',
      isUsed: false,
    );

    _configApi.deleteConfigByid(id);
  }

  // Future<void> writeConfigAutoIncrementId() async {
  //   _configApi.writeConfigAutoIncrementId();
  // }

  // Future<int> getConfigAutoIncrementId() async {
  //   return _configApi.getConfigAutoIncrementId();
  // }
}

class ConfigName {
  const ConfigName({
    required this.name,
    this.isUsed = false,
  });

  final String name;
  final bool isUsed;
}

class UnusedConfigName {
  const UnusedConfigName({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;
}
