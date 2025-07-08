import 'dart:async';
import 'dart:io';

import 'package:aci_plus_app/repositories/ble_client.dart';
import 'package:aci_plus_app/repositories/connection_client.dart';
import 'package:aci_plus_app/repositories/ble_windows_client.dart';
import 'package:aci_plus_app/repositories/usb_client.dart';
import 'package:ftdi_serial/ftdi_serial.dart';
import 'package:ftdi_serial/serial_device.dart';

enum ConnectionType {
  none,
  ble,
  usb,
}

class ConnectionClientFactory {
  static late ConnectionClient _instance;
  static bool _initialized = false;

  static StreamSubscription? _usbStatusSubscription;
  static Stream<bool>? _usbStatusDataStream;

  static final StreamController<ConnectionType> _connectionTypeController =
      StreamController<ConnectionType>.broadcast();

  static Stream<ConnectionType> get connectionTypeStream async* {
    yield* _connectionTypeController.stream;
  }

  // private constructor to prevent direct instantiation
  ConnectionClientFactory._();

  static ConnectionClient get instance {
    if (!_initialized) {
      throw StateError(
          'ConnectionClientFactory not initialized. Call initialize() first.');
    }
    return _instance; // 始終返回同一個實例
  }

  static Future<void> initialize() async {
    if (!_initialized) {
      await _startUsbMonitoring();
    }

    _instance = await create();
    _initialized = true;
  }

  /// 開始監控 USB 設備狀態
  static Future<void> _startUsbMonitoring() async {
    if (Platform.isAndroid) {
      _usbStatusDataStream = FtdiSerial.usbStatusStream;

      _usbStatusSubscription = _usbStatusDataStream?.listen(
        (isUsbConnected) {
          print('USB status changed: $isUsbConnected');
          _onUsbStatusChanged(isUsbConnected);
        },
        onError: (error) {
          print('USB monitoring error: $error');
        },
      );
    }
  }

  /// 處理 USB 狀態變化
  static Future<void> _onUsbStatusChanged(bool isUsbConnected) async {
    if (isUsbConnected) {
      // USB 連接時，切換到 USB 客戶端
      _connectionTypeController.add(ConnectionType.usb);
    } else {
      // USB 斷開時，切換到 BLE 客戶端
      _connectionTypeController.add(ConnectionType.ble);
    }
  }

  static Future<ConnectionClient> create() async {
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
