import 'package:aci_plus_app/repositories/distribution_config.dart';
import 'package:aci_plus_app/repositories/distribution_config_api.dart';
import 'package:aci_plus_app/repositories/trunk_config.dart';
import 'package:aci_plus_app/repositories/trunk_config_api.dart';

class ConfigRepository {
  ConfigRepository()
      : _trunkConfigApi = TrunkConfigApi(),
        _distributionConfigApi = DistributionConfigApi();

  final TrunkConfigApi _trunkConfigApi;
  final DistributionConfigApi _distributionConfigApi;

  final Map<int, String> _trunkConfigNames = {
    0: '',
    1: '',
    2: '',
    3: '',
    4: '',
  };

  final Map<int, String> _distributionConfigNames = {
    0: '',
    1: '',
    2: '',
    3: '',
    4: '',
  };

  int? getEmptyNameId({
    required String groupId,
  }) {
    int? firstEmptyId;
    if (groupId == '0') {
      for (var entry in _trunkConfigNames.entries) {
        if (entry.value.isEmpty) {
          firstEmptyId = entry.key;
          break;
        }
      }
    } else {
      for (var entry in _distributionConfigNames.entries) {
        if (entry.value.isEmpty) {
          firstEmptyId = entry.key;
          break;
        }
      }
    }
    return firstEmptyId;
  }

  /// 新增 config 到手機端資料庫, 如果該 part id 已存在, 則 put() 會更新其資料
  Future<void> putConfig({
    required String groupId,
    required String name,
    required String splitOption,
    required String firstChannelLoadingFrequency,
    required String firstChannelLoadingLevel,
    required String lastChannelLoadingFrequency,
    required String lastChannelLoadingLevel,
    required String isDefault,
  }) async {
    if (groupId == '0') {
      int? firstEmptyId = getEmptyNameId(groupId: groupId);

      if (firstEmptyId != null) {
        await _trunkConfigApi.putConfig(
          id: firstEmptyId,
          name: name,
          splitOption: splitOption,
          firstChannelLoadingFrequency: firstChannelLoadingFrequency,
          firstChannelLoadingLevel: firstChannelLoadingLevel,
          lastChannelLoadingFrequency: lastChannelLoadingFrequency,
          lastChannelLoadingLevel: lastChannelLoadingLevel,
          isDefault: isDefault,
        );
        _trunkConfigNames[firstEmptyId] = name;
      }
    } else {
      int? firstEmptyId = getEmptyNameId(groupId: groupId);

      if (firstEmptyId != null) {
        await _distributionConfigApi.putConfig(
          id: firstEmptyId,
          name: name,
          splitOption: splitOption,
          firstChannelLoadingFrequency: firstChannelLoadingFrequency,
          firstChannelLoadingLevel: firstChannelLoadingLevel,
          lastChannelLoadingFrequency: lastChannelLoadingFrequency,
          lastChannelLoadingLevel: lastChannelLoadingLevel,
          isDefault: isDefault,
        );
        _distributionConfigNames[firstEmptyId] = name;
      }
    }
  }

  Future<void> updateConfig({
    required int id,
    required String groupId,
    required String name,
    required String splitOption,
    required String firstChannelLoadingFrequency,
    required String firstChannelLoadingLevel,
    required String lastChannelLoadingFrequency,
    required String lastChannelLoadingLevel,
    required String isDefault,
  }) async {
    if (groupId == '0') {
      await _trunkConfigApi.putConfig(
        id: id,
        name: name,
        splitOption: splitOption,
        firstChannelLoadingFrequency: firstChannelLoadingFrequency,
        firstChannelLoadingLevel: firstChannelLoadingLevel,
        lastChannelLoadingFrequency: lastChannelLoadingFrequency,
        lastChannelLoadingLevel: lastChannelLoadingLevel,
        isDefault: isDefault,
      );
      _trunkConfigNames[id] = name;
    } else {
      await _distributionConfigApi.putConfig(
        id: id,
        name: name,
        splitOption: splitOption,
        firstChannelLoadingFrequency: firstChannelLoadingFrequency,
        firstChannelLoadingLevel: firstChannelLoadingLevel,
        lastChannelLoadingFrequency: lastChannelLoadingFrequency,
        lastChannelLoadingLevel: lastChannelLoadingLevel,
        isDefault: isDefault,
      );
      _distributionConfigNames[id] = name;
    }
  }

  Future<void> setDefaultConfigById({
    required String groupId,
    required int id,
  }) async {
    if (groupId == '0') {
      await _trunkConfigApi.setDefaultConfigById(id: id);
    } else {
      await _distributionConfigApi.setDefaultConfigById(id: id);
    }
  }

  List<dynamic> getDefaultConfigByGroupId(
    String groupId,
  ) {
    if (groupId == '0') {
      return _trunkConfigApi.getDefaultConfig();
    } else {
      return _distributionConfigApi.getDefaultConfig();
    }
  }

  /// 藉由 groupId 與 config id 取得 config 參數
  List<dynamic> getConfig({
    required int id,
    required String groupId,
  }) {
    if (groupId == '0') {
      return _trunkConfigApi.getConfigById(id);
    } else {
      return _distributionConfigApi.getConfigById(id);
    }
  }

  List<TrunkConfig> getAllTrunkConfigs() {
    List<TrunkConfig> trunkConfigs = _trunkConfigApi.getAllConfigs();

    print('db trunkConfig:');
    for (TrunkConfig trunkConfig in trunkConfigs) {
      print('${trunkConfig.id} : ${trunkConfig.name}');
      _trunkConfigNames[trunkConfig.id] = trunkConfig.name;
    }
    print('=============');
    print(' _trunkConfigNames:');
    for (MapEntry entry in _trunkConfigNames.entries) {
      print('${entry.key} : ${entry.value}');
    }
    print('=============');

    return trunkConfigs;
  }

  List<DistributionConfig> getAllDistributionConfigs() {
    List<DistributionConfig> distributionConfigs =
        _distributionConfigApi.getAllConfigs();

    print('db distributionConfig:');
    for (DistributionConfig distributionConfig in distributionConfigs) {
      print('${distributionConfig.id} : ${distributionConfig.name}');
      _distributionConfigNames[distributionConfig.id] = distributionConfig.name;
    }
    print('=============');
    print(' _distributionConfigNames:');
    for (MapEntry entry in _distributionConfigNames.entries) {
      print('${entry.key} : ${entry.value}');
    }
    print('=============');

    return distributionConfigs;
  }

  Future<void> deleteConfig({
    required int id,
    required String groupId,
  }) async {
    if (groupId == '0') {
      _trunkConfigNames[id] = '';
      await _trunkConfigApi.deleteConfigByid(id);
    } else {
      _distributionConfigNames[id] = '';
      await _distributionConfigApi.deleteConfigByid(id);
    }
  }
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
