import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:aci_plus_app/repositories/config.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ConfigApi {
  ConfigApi() : _configBox = Hive.box('UserData');
  final Box<Config> _configBox;

  /// 新增 config 到手機端資料庫, 如果該 part id 已存在, 則 put() 會更新其資料
  Future<void> addConfigByPartId({
    required String partId,
    required String firstChannelLoadingFrequency,
    required String lastChannelLoadingFrequency,
    required String firstChannelLoadingLevel,
    required String lastChannelLoadingLevel,
  }) async {
    Config newConfig = Config(
      partId: partId,
      firstChannelLoadingFrequency: firstChannelLoadingFrequency,
      lastChannelLoadingFrequency: lastChannelLoadingFrequency,
      firstChannelLoadingLevel: firstChannelLoadingLevel,
      lastChannelLoadingLevel: lastChannelLoadingLevel,
    );
    await _configBox.put(partId, newConfig);
  }

  /// 藉由 part id 取得 config 參數
  List<dynamic> getConfigByPartId(
    String partId,
  ) {
    Config? config = _configBox.get(partId); //get user if it already exists

    if (config != null) {
      return [true, config];
    } else {
      return [false, '${partIdMap[partId]} config does not exist.'];
    }
  }
}
