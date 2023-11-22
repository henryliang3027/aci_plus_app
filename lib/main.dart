import 'package:aci_plus_app/app.dart';
import 'package:aci_plus_app/repositories/aci_device_repository.dart';
import 'package:aci_plus_app/repositories/dsim12_repository.dart';
import 'package:aci_plus_app/repositories/dsim18_ccor_node_repository.dart';
import 'package:aci_plus_app/repositories/dsim18_repository.dart';
import 'package:aci_plus_app/repositories/dsim_repository.dart';
import 'package:aci_plus_app/repositories/gps_repository.dart';
import 'package:aci_plus_app/repositories/unit_repository.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(App(
    aciDeviceRepository: ACIDeviceRepository(),
    dsim12Repository: Dsim12Repository(),
    dsim18Repository: Dsim18Repository(),
    dsim18CCorNodeRepository: Dsim18CCorNodeRepository(),
    unitRepository: UnitRepository(
      temperatureUnit: TemperatureUnit.fahrenheit, // 預設顯示華氏溫度
    ),
    gpsRepository: GPSRepository(),
  ));
}
