import 'dart:io';

import 'package:aci_plus_app/repositories/ble_client.dart';
import 'package:aci_plus_app/repositories/ble_client_base.dart';
import 'package:aci_plus_app/repositories/ble_windows_client.dart';
import 'package:aci_plus_app/repositories/usb_client.dart';
import 'package:ftdi_serial/serial_device.dart';

class BLEClientFactory {
  static late BLEClientBase _instance;
  static bool _initialized = false;

  // private constructor to prevent direct instantiation
  BLEClientFactory._();

  static BLEClientBase get instance {
    if (!_initialized) {
      throw StateError(
          'BLEClientFactory not initialized. Call initialize() first.');
    }
    return _instance; // 始終返回同一個實例
  }

  static Future<void> initialize() async {
    _instance = await create(); // 只在第一次初始化時創建實例
    _initialized = true;
  }

  static Future<BLEClientBase> create() async {
    if (Platform.isWindows) {
      return BLEWindowsClient();
    } else if (Platform.isIOS) {
      return BLEClient();
    } else if (Platform.isAndroid) {
      BLEClient bleClient = BLEClient();
      USBClient usbClient = USBClient();
      SerialDevice serialDevice = await USBClient.getAttachedDevice();
      return serialDevice.vendorId != -1 ? usbClient : bleClient;
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }
}
