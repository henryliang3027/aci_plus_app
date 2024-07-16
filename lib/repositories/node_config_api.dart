import 'package:aci_plus_app/repositories/node_config.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NodeConfigApi {
  NodeConfigApi() : _nodeConfigBox = Hive.box('NodeConfigData');
  final Box<NodeConfig> _nodeConfigBox;

  List<NodeConfig> getAllConfigs() {
    return _nodeConfigBox.values.toList();
  }

  /// 新增 config 到手機端資料庫, 如果該 part id 已存在, 則 put() 會更新其資料
  Future<void> putConfig({
    required int id,
    required String name,
    required String forwardMode,
    required String forwardConfig,
    required String splitOption,
  }) async {
    NodeConfig newConfig = NodeConfig(
      id: id,
      name: name,
      forwardMode: forwardMode,
      forwardConfig: forwardConfig,
      splitOption: splitOption,

      // isDefault: isDefault,
    );
    await _nodeConfigBox.put(id, newConfig);
  }

  // Future<void> setDefaultConfigById({
  //   required int id,
  // }) async {
  //   List<TrunkConfig> configs = getAllConfigs();

  //   TrunkConfig? defaultConfig;

  //   for (TrunkConfig config in configs) {
  //     if (config.isDefault == '1') {
  //       defaultConfig = config;
  //     }
  //   }

  //   // 如果已經有預設的 config, 則先將該 config 改為非預設
  //   if (defaultConfig != null) {
  //     TrunkConfig canceledDefaultConfig = TrunkConfig(
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

  //     await _trunkConfigBox.put(defaultConfig.id, canceledDefaultConfig);
  //   }

  //   List<dynamic> result = getConfigById(id);

  //   if (result[0]) {
  //     TrunkConfig targetConfig = result[1];

  //     TrunkConfig newDefaultConfig = TrunkConfig(
  //       id: targetConfig.id,
  //       name: targetConfig.name,
  //       splitOption: targetConfig.splitOption,
  //       firstChannelLoadingFrequency: targetConfig.firstChannelLoadingFrequency,
  //       firstChannelLoadingLevel: targetConfig.firstChannelLoadingLevel,
  //       lastChannelLoadingFrequency: targetConfig.lastChannelLoadingFrequency,
  //       lastChannelLoadingLevel: targetConfig.lastChannelLoadingLevel,
  //       isDefault: '1',
  //     );

  //     await _trunkConfigBox.put(targetConfig.id, newDefaultConfig);
  //   }
  // }

  // List<dynamic> getDefaultConfig() {
  //   List<TrunkConfig> configs = getAllConfigs();

  //   for (TrunkConfig config in configs) {
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
    NodeConfig? config =
        _nodeConfigBox.get(id); //get config if it already exists

    if (config != null) {
      return [true, config];
    } else {
      return [false, 'config does not exist.'];
    }
  }

  Future<void> deleteConfigByid(int id) async {
    await _nodeConfigBox.delete(id);
  }

  Future<void> deleteAllConfig() async {
    await _nodeConfigBox.deleteAll(_nodeConfigBox.keys);
  }
}
