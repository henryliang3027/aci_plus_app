import 'package:aci_plus_app/app.dart';
import 'package:aci_plus_app/core/shared_preference_key.dart';
import 'package:aci_plus_app/env_config.dart';
import 'package:aci_plus_app/repositories/aci_device_repository.dart';
import 'package:aci_plus_app/repositories/connection_client_factory.dart';
import 'package:aci_plus_app/repositories/code_repository.dart';
import 'package:aci_plus_app/repositories/distribution_config.dart';
import 'package:aci_plus_app/repositories/mdu_config.dart';
import 'package:aci_plus_app/repositories/node_config.dart';
import 'package:aci_plus_app/repositories/trunk_config.dart';
import 'package:aci_plus_app/repositories/config_repository.dart';
import 'package:aci_plus_app/repositories/dsim_repository.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/repositories/gps_repository.dart';
import 'package:aci_plus_app/repositories/unit_repository.dart';
import 'package:aci_plus_app/repositories/firmware_repository.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> writeBoxVersion() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(SharedPreferenceKey.boxVersion.name, '2.2.6');
}

Future<String?> readBoxVersion() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? boxVersion = prefs.getString(SharedPreferenceKey.boxVersion.name);
  return boxVersion;
}

Future<void> deleteAllBox() async {
  await Hive.deleteBoxFromDisk('TrunkConfigData');
  await Hive.deleteBoxFromDisk('DistributionConfigData');
  await Hive.deleteBoxFromDisk('NodeConfigData');
  await Hive.deleteBoxFromDisk('MDUConfigData');
}

Future<void> initBox() async {
  await Hive.initFlutter('.db');
  Hive.registerAdapter<TrunkConfig>(TrunkConfigAdapter());
  Hive.registerAdapter<DistributionConfig>(DistributionConfigAdapter());
  Hive.registerAdapter<NodeConfig>(NodeConfigAdapter());
  Hive.registerAdapter<MDUConfig>(MDUConfigAdapter());

  String? boxVersion = await readBoxVersion();

  if (boxVersion != '2.2.6') {
    await deleteAllBox();
    await writeBoxVersion();
  }

  await Hive.openBox<TrunkConfig>('TrunkConfigData');
  await Hive.openBox<DistributionConfig>('DistributionConfigData');
  await Hive.openBox<NodeConfig>('NodeConfigData');
  await Hive.openBox<MDUConfig>('MDUConfigData');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final AdaptiveThemeMode savedAdaptiveThemeMode =
      await AdaptiveTheme.getThemeMode() ?? AdaptiveThemeMode.light;

  await initBox();

  // Initialize env config
  await EnvConfig.initialize();

  // initialize client to determine if it is a USB or BLE connection
  await ConnectionClientFactory.initialize();

  runApp(App(
    savedAdaptiveThemeMode: savedAdaptiveThemeMode,
    aciDeviceRepository: ACIDeviceRepository(),
    dsimRepository: DsimRepository(),
    amp18Repository: Amp18Repository(),
    amp18CCorNodeRepository: Amp18CCorNodeRepository(),
    unitRepository: UnitRepository(),
    gpsRepository: GPSRepository(),
    configRepository: ConfigRepository(),
    firmwareRepository: FirmwareRepository(),
    codeRepository: CodeRepository(),
  ));
}
