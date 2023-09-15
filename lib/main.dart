import 'package:dsim_app/app.dart';
import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:dsim_app/repositories/unit_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(App(
    dsimRepository: DsimRepository(),
    unitRepository: UnitRepository(
      temperatureUnit: TemperatureUnit.fahrenheit, // 預設顯示華氏溫度
    ),
  ));
}
