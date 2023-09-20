import 'package:dsim_app/app.dart';
import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:dsim_app/repositories/unit_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  double screenWidth =
      WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width;

  if (screenWidth <= 1290) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  } else {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }
  print('width: $screenWidth');

  runApp(App(
    dsimRepository: DsimRepository(),
    unitRepository: UnitRepository(
      temperatureUnit: TemperatureUnit.fahrenheit, // 預設顯示華氏溫度
    ),
  ));
}
