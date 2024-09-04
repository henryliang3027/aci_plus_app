import 'dart:io';

import 'package:aci_plus_app/repositories/ble_client.dart';
import 'package:aci_plus_app/repositories/ble_client_base.dart';
import 'package:aci_plus_app/repositories/ble_windows_client.dart';

class BLEClientFactory {
  // The single instance of the class
  static BLEClientBase _instance = create();

  static BLEClientBase get instance => _instance;

  // create instances based on the platform
  static BLEClientBase create() {
    if (Platform.isWindows) {
      // _instance = BLEWindowsClient()..initialize();
      _instance = BLEWindowsClient();
      return _instance;
    } else if (Platform.isIOS || Platform.isAndroid) {
      _instance = BLEClient();
      return _instance;
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }
}
