import 'package:aci_plus_app/app.dart';
import 'package:aci_plus_app/repositories/aci_device_repository.dart';
import 'package:aci_plus_app/repositories/dsim_repository.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/repositories/gps_repository.dart';
import 'package:aci_plus_app/repositories/unit_repository.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(App(
    aciDeviceRepository: ACIDeviceRepository(),
    dsimRepository: DsimRepository(),
    amp18Repository: Amp18Repository(),
    amp18CCorNodeRepository: Amp18CCorNodeRepository(),
    unitRepository: UnitRepository(),
    gpsRepository: GPSRepository(),
  ));
}
