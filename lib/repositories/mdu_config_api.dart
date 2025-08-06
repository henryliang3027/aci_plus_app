import 'package:aci_plus_app/repositories/mdu_config.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MDUConfigApi {
  MDUConfigApi() : _mduConfigBox = Hive.box('MDUConfigData');
  final Box<MDUConfig> _mduConfigBox;

  List<MDUConfig> getAllConfigs() {
    return _mduConfigBox.values.toList();
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
    MDUConfig newConfig = MDUConfig(
      id: id,
      name: name,
      firstChannelLoadingFrequency: firstChannelLoadingFrequency,
      firstChannelLoadingLevel: firstChannelLoadingLevel,
      lastChannelLoadingFrequency: lastChannelLoadingFrequency,
      lastChannelLoadingLevel: lastChannelLoadingLevel,
    );
    await _mduConfigBox.put(id, newConfig);
  }

  /// 藉由 config id 取得 config 參數
  List<dynamic> getConfigById(
    int id,
  ) {
    MDUConfig? config = _mduConfigBox.get(id); //get config if it already exists

    if (config != null) {
      return [true, config];
    } else {
      return [false, 'config does not exist.'];
    }
  }

  Future<void> deleteConfigByid(int id) async {
    await _mduConfigBox.delete(id);
  }

  Future<void> deleteAllConfig() async {
    await _mduConfigBox.deleteAll(_mduConfigBox.keys);
  }
}
