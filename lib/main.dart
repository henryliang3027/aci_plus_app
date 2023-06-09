import 'package:dsim_app/app.dart';
import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(App(
    dsimRepository: DsimRepository(),
  ));
}
