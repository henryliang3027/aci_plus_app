import 'dart:typed_data';
import 'package:aci_plus_app/repositories/config_repository.dart';
import 'package:aci_plus_app/repositories/config.dart';
import 'package:aci_plus_app/repositories/distribution_config.dart';
import 'package:aci_plus_app/repositories/mock/mock_distribution_config_api.dart';
import 'package:aci_plus_app/repositories/mock/mock_node_config_api.dart';
import 'package:aci_plus_app/repositories/mock/mock_trunk_config_api.dart';
import 'package:aci_plus_app/repositories/node_config.dart';
import 'package:aci_plus_app/repositories/trunk_config.dart';

class MockConfigRepository extends ConfigRepository {
  // 使用假資料存儲，不依賴 Hive
  final Map<int, TrunkConfig> _mockTrunkConfigs = {};
  final Map<int, DistributionConfig> _mockDistributionConfigs = {};
  final Map<int, NodeConfig> _mockNodeConfigs = {};

  // Override 建構函式，不呼叫父類別建構函式
  MockConfigRepository()
      : super(
          trunkConfigApi: MockTrunkConfigApi(),
          distributionConfigApi: MockDistributionConfigApi(),
          nodeConfigApi: MockNodeConfigApi(),
        );

  @override
  int? getEmptyNameId({required String groupId}) {
    if (groupId == '0') {
      for (int i = 0; i < 3; i++) {
        if (!_mockTrunkConfigs.containsKey(i)) return i;
      }
    } else if (groupId == '1') {
      for (int i = 0; i < 3; i++) {
        if (!_mockDistributionConfigs.containsKey(i)) return i;
      }
    } else {
      for (int i = 0; i < 3; i++) {
        if (!_mockNodeConfigs.containsKey(i)) return i;
      }
    }
    return null;
  }

  @override
  Future<void> putConfig({
    required String groupId,
    required String name,
    required String firstChannelLoadingFrequency,
    required String firstChannelLoadingLevel,
    required String lastChannelLoadingFrequency,
    required String lastChannelLoadingLevel,
  }) async {
    final id = getEmptyNameId(groupId: groupId);
    if (id == null) return;

    if (groupId == '0') {
      _mockTrunkConfigs[id] = TrunkConfig(
        id: id,
        name: name,
        firstChannelLoadingFrequency: firstChannelLoadingFrequency,
        firstChannelLoadingLevel: firstChannelLoadingLevel,
        lastChannelLoadingFrequency: lastChannelLoadingFrequency,
        lastChannelLoadingLevel: lastChannelLoadingLevel,
      );
    } else {
      _mockDistributionConfigs[id] = DistributionConfig(
        id: id,
        name: name,
        firstChannelLoadingFrequency: firstChannelLoadingFrequency,
        firstChannelLoadingLevel: firstChannelLoadingLevel,
        lastChannelLoadingFrequency: lastChannelLoadingFrequency,
        lastChannelLoadingLevel: lastChannelLoadingLevel,
      );
    }
  }

  @override
  Future<void> putNodeConfig({
    required String groupId,
    required String name,
    required String forwardMode,
    required String forwardConfig,
  }) async {
    final id = getEmptyNameId(groupId: groupId);
    if (id == null) return;

    _mockNodeConfigs[id] = NodeConfig(
      id: id,
      name: name,
      forwardMode: forwardMode,
      forwardConfig: forwardConfig,
    );
  }

  @override
  List<Config> getConfigsByGroupId(String groupId) {
    if (groupId == '0') {
      return _mockTrunkConfigs.values.toList();
    } else {
      return _mockDistributionConfigs.values.toList();
    }
  }

  @override
  List<TrunkConfig> getAllTrunkConfigs() {
    return _mockTrunkConfigs.values.toList();
  }

  @override
  List<DistributionConfig> getAllDistributionConfigs() {
    return _mockDistributionConfigs.values.toList();
  }

  @override
  List<NodeConfig> getAllNodeConfigs() {
    return _mockNodeConfigs.values.toList();
  }

  @override
  Future<void> deleteConfig({
    required int id,
    required String groupId,
  }) async {
    if (groupId == '0') {
      _mockTrunkConfigs.remove(id);
    } else if (groupId == '1') {
      _mockDistributionConfigs.remove(id);
    } else {
      _mockNodeConfigs.remove(id);
    }
  }

  @override
  Future<void> deleteAllConfig() async {
    _mockTrunkConfigs.clear();
    _mockDistributionConfigs.clear();
    _mockNodeConfigs.clear();
  }

  @override
  Future<dynamic> saveGenretatedQRCode({
    required String description,
    required Uint8List imageBytes,
  }) async {
    // Mock implementation - 不實際保存文件
    return [true, description, '/mock/path/$description.png'];
  }

  @override
  Future<void> updateConfig({
    required int id,
    required String groupId,
    required String name,
    required String splitOption,
    required String firstChannelLoadingFrequency,
    required String firstChannelLoadingLevel,
    required String lastChannelLoadingFrequency,
    required String lastChannelLoadingLevel,
  }) async {
    // Mock implementation
  }

  @override
  Future<void> updateNodeConfig({
    required int id,
    required String name,
    required String forwardMode,
    required String forwardConfig,
    required String splitOption,
  }) async {
    // Mock implementation
  }

  @override
  Future<void> updateConfigsByQRCode({
    required List<TrunkConfig> trunkConfigs,
    required List<DistributionConfig> distributionConfigs,
    required List<NodeConfig> nodeConfigs,
  }) async {
    // Mock implementation
  }
}
