import 'dart:io';

import 'package:aci_plus_app/app.dart';
import 'package:aci_plus_app/core/shared_preference_key.dart';
import 'package:aci_plus_app/repositories/aci_device_repository.dart';
import 'package:aci_plus_app/repositories/code_repository.dart';
import 'package:aci_plus_app/repositories/distribution_config.dart';
import 'package:aci_plus_app/repositories/mock/sample_aci_device_repository.dart';
import 'package:aci_plus_app/repositories/mock/sample_amp18_repository.dart';
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
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
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
}

Future<void> initBox() async {
  await Hive.initFlutter('.db');
  Hive.registerAdapter<TrunkConfig>(TrunkConfigAdapter());
  Hive.registerAdapter<DistributionConfig>(DistributionConfigAdapter());
  Hive.registerAdapter<NodeConfig>(NodeConfigAdapter());

  bool trunkConfigBoxExists = await Hive.boxExists('TrunkConfigData');
  bool distributionConfigBoxExists =
      await Hive.boxExists('DistributionConfigData');
  bool nodeConfigBoxExists = await Hive.boxExists('NodeConfigData');

  // print(
  //     '$trunkConfigBoxExists, $distributionConfigBoxExists, $nodeConfigBoxExists');

  // 如果是第一次建立 hive db 則在 SharedPreferences 內寫入 db 支援的最低 app 版本
  if (!trunkConfigBoxExists &&
      !distributionConfigBoxExists &&
      !nodeConfigBoxExists) {
    print('writeboxVersion1');
    await writeBoxVersion();
  } else {
    // 如果已經存在, 則檢查 db 支援的最低 app 版本, 如果版本不符則清除 db, 再建立一個新的
    String? boxVersion = await readBoxVersion();

    print('boxVersion: $boxVersion');

    if (boxVersion == null) {
      print('writeboxVersion2');
      await deleteAllBox();
      await writeBoxVersion();
    } else {
      if (boxVersion.isEmpty) {
        print('writeboxVersion3');
        await deleteAllBox();
        await writeBoxVersion();
      }
    }
  }

  await Hive.openBox<TrunkConfig>('TrunkConfigData');
  await Hive.openBox<DistributionConfig>('DistributionConfigData');
  await Hive.openBox<NodeConfig>('NodeConfigData');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final AdaptiveThemeMode savedAdaptiveThemeMode =
      await AdaptiveTheme.getThemeMode() ?? AdaptiveThemeMode.light;

  if (Platform.isIOS || Platform.isAndroid) {
    await Firebase.initializeApp();
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  await initBox();

  int mock = 0;

  if (mock == 1) {
    runApp(App(
      savedAdaptiveThemeMode: savedAdaptiveThemeMode,
      aciDeviceRepository: SampleACIDeviceRepository(),
      dsimRepository: DsimRepository(),
      amp18Repository: SampleAmp18Repository(),
      amp18CCorNodeRepository: Amp18CCorNodeRepository(),
      unitRepository: UnitRepository(),
      gpsRepository: GPSRepository(),
      configRepository: ConfigRepository(),
      firmwareRepository: FirmwareRepository(),
      codeRepository: CodeRepository(),
    ));
  } else {
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
}
