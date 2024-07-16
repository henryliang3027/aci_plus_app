import 'dart:io';

import 'package:aci_plus_app/app.dart';
import 'package:aci_plus_app/repositories/aci_device_repository.dart';
import 'package:aci_plus_app/repositories/distribution_config.dart';
import 'package:aci_plus_app/repositories/node_config.dart';
import 'package:aci_plus_app/repositories/trunk_config.dart';
import 'package:aci_plus_app/repositories/config_repository.dart';
import 'package:aci_plus_app/repositories/dsim_repository.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/repositories/gps_repository.dart';
import 'package:aci_plus_app/repositories/unit_repository.dart';
import 'package:aci_plus_app/repositories/firmware_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void openHiveBox() {}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  await Hive.initFlutter('.db');
  Hive.registerAdapter<TrunkConfig>(TrunkConfigAdapter());
  Hive.registerAdapter<DistributionConfig>(DistributionConfigAdapter());
  Hive.registerAdapter<NodeConfig>(NodeConfigAdapter());

  await Hive.openBox<TrunkConfig>('TrunkConfigData');
  await Hive.openBox<DistributionConfig>('DistributionConfigData');
  await Hive.openBox<NodeConfig>('NodeConfigData');

  runApp(App(
    aciDeviceRepository: ACIDeviceRepository(),
    dsimRepository: DsimRepository(),
    amp18Repository: Amp18Repository(),
    amp18CCorNodeRepository: Amp18CCorNodeRepository(),
    unitRepository: UnitRepository(),
    gpsRepository: GPSRepository(),
    configRepository: ConfigRepository(),
    firmwareRepository: FirmwareRepository(),
  ));
}
