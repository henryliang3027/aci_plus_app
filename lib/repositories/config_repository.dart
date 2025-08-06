import 'dart:io';
import 'dart:typed_data';

import 'package:aci_plus_app/repositories/config.dart';
import 'package:aci_plus_app/repositories/distribution_config.dart';
import 'package:aci_plus_app/repositories/distribution_config_api.dart';
import 'package:aci_plus_app/repositories/mdu_config.dart';
import 'package:aci_plus_app/repositories/mdu_config_api.dart';
import 'package:aci_plus_app/repositories/node_config.dart';
import 'package:aci_plus_app/repositories/node_config_api.dart';
import 'package:aci_plus_app/repositories/trunk_config.dart';
import 'package:aci_plus_app/repositories/trunk_config_api.dart';
import 'package:path_provider/path_provider.dart';

class ConfigRepository {
  ConfigRepository()
      : _trunkConfigApi = TrunkConfigApi(),
        _distributionConfigApi = DistributionConfigApi(),
        _nodeConfigApi = NodeConfigApi();

  final TrunkConfigApi _trunkConfigApi;
  final DistributionConfigApi _distributionConfigApi;
  final NodeConfigApi _nodeConfigApi;
  final MDUConfigApi _mduConfigApi = MDUConfigApi();

  final Map<int, String> _trunkConfigNames = {
    0: '',
    1: '',
    2: '',
  };

  final Map<int, String> _distributionConfigNames = {
    0: '',
    1: '',
    2: '',
  };

  final Map<int, String> _nodeConfigNames = {
    0: '',
    1: '',
    2: '',
  };

  final Map<int, String> _mduConfigNames = {
    0: '',
    1: '',
    2: '',
  };

  int? getEmptyNameId({
    required String groupId,
  }) {
    int? firstEmptyId;
    if (groupId == '0') {
      // 檢查還可以分配的 trunk config id
      for (var entry in _trunkConfigNames.entries) {
        if (entry.value.isEmpty) {
          firstEmptyId = entry.key;
          break;
        }
      }
    } else if (groupId == '1') {
      // 檢查還可以分配的 distribution config id
      for (var entry in _distributionConfigNames.entries) {
        if (entry.value.isEmpty) {
          firstEmptyId = entry.key;
          break;
        }
      }
    } else if (groupId == '2') {
      // 檢查還可以分配的 node config id
      for (var entry in _nodeConfigNames.entries) {
        if (entry.value.isEmpty) {
          firstEmptyId = entry.key;
          break;
        }
      }
    } else if (groupId == '3') {
      // 檢查還可以分配的 mdu config id
      for (var entry in _mduConfigNames.entries) {
        if (entry.value.isEmpty) {
          firstEmptyId = entry.key;
          break;
        }
      }
    } else {}
    return firstEmptyId;
  }

  /// 新增 config 到手機端資料庫, 如果該 part id 已存在, 則 put() 會更新其資料
  Future<void> putConfig({
    required String groupId,
    required String name,
    // required String splitOption,
    required String firstChannelLoadingFrequency,
    required String firstChannelLoadingLevel,
    required String lastChannelLoadingFrequency,
    required String lastChannelLoadingLevel,
    // required String isDefault,
  }) async {
    if (groupId == '0') {
      int? firstEmptyId = getEmptyNameId(groupId: groupId);

      if (firstEmptyId != null) {
        await _trunkConfigApi.putConfig(
          id: firstEmptyId,
          name: name,
          // splitOption: splitOption,
          firstChannelLoadingFrequency: firstChannelLoadingFrequency,
          firstChannelLoadingLevel: firstChannelLoadingLevel,
          lastChannelLoadingFrequency: lastChannelLoadingFrequency,
          lastChannelLoadingLevel: lastChannelLoadingLevel,
          // isDefault: isDefault,
        );
        _trunkConfigNames[firstEmptyId] = name;
      }
    } else if (groupId == '1') {
      int? firstEmptyId = getEmptyNameId(groupId: groupId);

      if (firstEmptyId != null) {
        await _distributionConfigApi.putConfig(
          id: firstEmptyId,
          name: name,
          // splitOption: splitOption,
          firstChannelLoadingFrequency: firstChannelLoadingFrequency,
          firstChannelLoadingLevel: firstChannelLoadingLevel,
          lastChannelLoadingFrequency: lastChannelLoadingFrequency,
          lastChannelLoadingLevel: lastChannelLoadingLevel,
          // isDefault: isDefault,
        );
        _distributionConfigNames[firstEmptyId] = name;
      }
    } else if (groupId == '3') {
      int? firstEmptyId = getEmptyNameId(groupId: groupId);

      if (firstEmptyId != null) {
        await _mduConfigApi.putConfig(
          id: firstEmptyId,
          name: name,
          // splitOption: splitOption,
          firstChannelLoadingFrequency: firstChannelLoadingFrequency,
          firstChannelLoadingLevel: firstChannelLoadingLevel,
          lastChannelLoadingFrequency: lastChannelLoadingFrequency,
          lastChannelLoadingLevel: lastChannelLoadingLevel,
          // isDefault: isDefault,
        );
        _mduConfigNames[firstEmptyId] = name;
      }
    }
  }

  Future<void> putNodeConfig({
    required String groupId,
    required String name,
    required String forwardMode,
    required String forwardConfig,
    // required String splitOption,
  }) async {
    int? firstEmptyId = getEmptyNameId(groupId: groupId);

    if (firstEmptyId != null) {
      await _nodeConfigApi.putConfig(
        id: firstEmptyId,
        name: name,
        forwardMode: forwardMode,
        forwardConfig: forwardConfig,
        // splitOption: splitOption,
      );
      _nodeConfigNames[firstEmptyId] = name;
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
    // required String isDefault,
  }) async {
    if (groupId == '0') {
      await _trunkConfigApi.putConfig(
        id: id,
        name: name,
        // splitOption: splitOption,
        firstChannelLoadingFrequency: firstChannelLoadingFrequency,
        firstChannelLoadingLevel: firstChannelLoadingLevel,
        lastChannelLoadingFrequency: lastChannelLoadingFrequency,
        lastChannelLoadingLevel: lastChannelLoadingLevel,
        // isDefault: isDefault,
      );
      _trunkConfigNames[id] = name;
    } else if (groupId == '1') {
      await _distributionConfigApi.putConfig(
        id: id,
        name: name,
        // splitOption: splitOption,
        firstChannelLoadingFrequency: firstChannelLoadingFrequency,
        firstChannelLoadingLevel: firstChannelLoadingLevel,
        lastChannelLoadingFrequency: lastChannelLoadingFrequency,
        lastChannelLoadingLevel: lastChannelLoadingLevel,
        // isDefault: isDefault,
      );
      _distributionConfigNames[id] = name;
    } else if (groupId == '3') {
      await _mduConfigApi.putConfig(
        id: id,
        name: name,
        // splitOption: splitOption,
        firstChannelLoadingFrequency: firstChannelLoadingFrequency,
        firstChannelLoadingLevel: firstChannelLoadingLevel,
        lastChannelLoadingFrequency: lastChannelLoadingFrequency,
        lastChannelLoadingLevel: lastChannelLoadingLevel,
        // isDefault: isDefault,
      );
      _mduConfigNames[id] = name;
    }
  }

  Future<void> updateNodeConfig({
    required int id,
    required String name,
    required String forwardMode,
    required String forwardConfig,
    required String splitOption,
  }) async {
    await _nodeConfigApi.putConfig(
      id: id,
      name: name,
      forwardMode: forwardMode,
      forwardConfig: forwardConfig,
      // splitOption: splitOption,
    );
    _nodeConfigNames[id] = name;
  }

  Future<void> updateConfigsByQRCode({
    required List<TrunkConfig> trunkConfigs,
    required List<DistributionConfig> distributionConfigs,
    required List<NodeConfig> nodeConfigs,
    required List<MDUConfig> mduConfigs,
  }) async {
    // clear all configs in the hive box
    await deleteAllConfig();

    for (int i = 0; i < 3; i++) {
      _trunkConfigNames[i] = '';
      _distributionConfigNames[i] = '';
      _nodeConfigNames[i] = '';
      _mduConfigNames[i] = '';
    }

    for (TrunkConfig trunkConfig in trunkConfigs) {
      await _trunkConfigApi.putConfig(
        id: trunkConfig.id,
        name: trunkConfig.name,
        // splitOption: trunkConfig.splitOption,
        firstChannelLoadingFrequency: trunkConfig.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: trunkConfig.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: trunkConfig.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: trunkConfig.lastChannelLoadingLevel,
        // isDefault: trunkConfig.isDefault,
      );
      _trunkConfigNames[trunkConfig.id] = trunkConfig.name;
    }

    for (DistributionConfig distributionConfig in distributionConfigs) {
      await _distributionConfigApi.putConfig(
        id: distributionConfig.id,
        name: distributionConfig.name,
        // splitOption: distributionConfig.splitOption,
        firstChannelLoadingFrequency:
            distributionConfig.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: distributionConfig.firstChannelLoadingLevel,
        lastChannelLoadingFrequency:
            distributionConfig.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: distributionConfig.lastChannelLoadingLevel,
        // isDefault: distributionConfig.isDefault,
      );
      _distributionConfigNames[distributionConfig.id] = distributionConfig.name;
    }

    for (NodeConfig nodeConfig in nodeConfigs) {
      await _nodeConfigApi.putConfig(
        id: nodeConfig.id,
        name: nodeConfig.name,
        forwardMode: nodeConfig.forwardMode,
        forwardConfig: nodeConfig.forwardConfig,
        // splitOption: nodeConfig.splitOption,
      );

      _nodeConfigNames[nodeConfig.id] = nodeConfig.name;
    }

    for (MDUConfig mduConfig in mduConfigs) {
      await _mduConfigApi.putConfig(
        id: mduConfig.id,
        name: mduConfig.name,
        firstChannelLoadingFrequency: mduConfig.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: mduConfig.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: mduConfig.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: mduConfig.lastChannelLoadingLevel,
      );
      _mduConfigNames[mduConfig.id] = mduConfig.name;
    }
  }

  List<Config> getConfigsByGroupId(
    String groupId,
  ) {
    if (groupId == '0') {
      return _trunkConfigApi.getAllConfigs();
    } else if (groupId == '1') {
      return _distributionConfigApi.getAllConfigs();
    } else if (groupId == '3') {
      return _mduConfigApi.getAllConfigs();
    } else {
      return [];
    }
  }

  List<NodeConfig> getAllNodeConfig() {
    return _nodeConfigApi.getAllConfigs();
  }

  /// 藉由 groupId 與 config id 取得 config 參數
  // List<dynamic> getConfig({
  //   required int id,
  //   required String groupId,
  // }) {
  //   if (groupId == '0') {
  //     return _trunkConfigApi.getConfigById(id);
  //   } else {
  //     return _distributionConfigApi.getConfigById(id);
  //   }
  // }

  List<TrunkConfig> getAllTrunkConfigs() {
    List<TrunkConfig> trunkConfigs = _trunkConfigApi.getAllConfigs();

    print('db trunkConfig:');
    for (TrunkConfig trunkConfig in trunkConfigs) {
      print('${trunkConfig.id} : ${trunkConfig.name}');
      _trunkConfigNames[trunkConfig.id] = trunkConfig.name;
    }
    print('=============');
    print('repo _trunkConfigNames:');
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
    print('repo _distributionConfigNames:');
    for (MapEntry entry in _distributionConfigNames.entries) {
      print('${entry.key} : ${entry.value}');
    }
    print('=============');

    return distributionConfigs;
  }

  List<NodeConfig> getAllNodeConfigs() {
    List<NodeConfig> nodeConfigs = _nodeConfigApi.getAllConfigs();

    print('db nodeConfig:');
    for (NodeConfig nodeConfig in nodeConfigs) {
      print('${nodeConfig.id} : ${nodeConfig.name}');
      _nodeConfigNames[nodeConfig.id] = nodeConfig.name;
    }
    print('=============');
    print('repo _nodeConfigNames:');
    for (MapEntry entry in _nodeConfigNames.entries) {
      print('${entry.key} : ${entry.value}');
    }
    print('=============');

    return nodeConfigs;
  }

  List<MDUConfig> getAllMDUConfigs() {
    List<MDUConfig> mduConfigs = _mduConfigApi.getAllConfigs();

    print('db mduConfig:');
    for (MDUConfig mduConfig in mduConfigs) {
      print('${mduConfig.id} : ${mduConfig.name}');
      _mduConfigNames[mduConfig.id] = mduConfig.name;
    }
    print('=============');
    print('repo _mduConfigNames:');
    for (MapEntry entry in _mduConfigNames.entries) {
      print('${entry.key} : ${entry.value}');
    }
    print('=============');

    return mduConfigs;
  }

  Future<void> deleteConfig({
    required int id,
    required String groupId,
  }) async {
    if (groupId == '0') {
      _trunkConfigNames[id] = '';
      await _trunkConfigApi.deleteConfigByid(id);
    } else if (groupId == '1') {
      _distributionConfigNames[id] = '';
      await _distributionConfigApi.deleteConfigByid(id);
    } else if (groupId == '2') {
      _nodeConfigNames[id] = '';
      await _nodeConfigApi.deleteConfigByid(id);
    } else if (groupId == '3') {
      _mduConfigNames[id] = '';
      await _mduConfigApi.deleteConfigByid(id);
    } else {}
  }

  Future<void> deleteAllConfig() async {
    await _trunkConfigApi.deleteAllConfig();
    await _distributionConfigApi.deleteAllConfig();
    await _nodeConfigApi.deleteAllConfig();
    await _mduConfigApi.deleteAllConfig();
  }

  Future<dynamic> saveGenretatedQRCode({
    required String description,
    required Uint8List imageBytes,
  }) async {
    const String extension = '.png';
    final String imageName = description;

    if (Platform.isIOS) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String fullWrittenPath = '$appDocPath/$description$extension';
      File f = File(fullWrittenPath);
      await f.writeAsBytes(imageBytes);
      return [
        true,
        imageName,
        fullWrittenPath,
      ];
    } else if (Platform.isAndroid) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String fullWrittenPath = '$appDocPath/$imageName$extension';
      File f = File(fullWrittenPath);
      await f.writeAsBytes(imageBytes);

      return [
        true,
        imageName,
        fullWrittenPath,
      ];
    } else if (Platform.isWindows) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      Directory appDocDirFolder = Directory('${appDocDir.path}/ACI+/');
      bool isExist = await appDocDirFolder.exists();
      if (!isExist) {
        await appDocDirFolder.create(recursive: true);
      }

      String appDocPath = appDocDirFolder.path;
      String fullWrittenPath = '$appDocPath/$imageName$extension';
      File f = File(fullWrittenPath);
      await f.writeAsBytes(imageBytes);

      return [
        true,
        imageName,
        fullWrittenPath,
      ];
    } else {
      return [
        false,
        '',
        'write file failed, export function not implement on ${Platform.operatingSystem} '
      ];
    }
  }
}
