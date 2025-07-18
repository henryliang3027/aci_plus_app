import 'dart:async';
import 'dart:io';

import 'package:aci_plus_app/repositories/ble_client.dart';
import 'package:aci_plus_app/repositories/connection_client.dart';
import 'package:aci_plus_app/repositories/ble_windows_client.dart';
import 'package:aci_plus_app/repositories/platform_streategy_factory.dart';
import 'package:aci_plus_app/repositories/usb_client.dart';
import 'package:ftdi_serial/ftdi_serial.dart';
import 'package:ftdi_serial/serial_device.dart';

enum ConnectionType {
  none,
  ble,
  usb,
}

class ConnectionClientFactory {
  static ConnectionClient? _instance;
  static bool _initialized = false;
  static PlatformStrategy? _currentStrategy;

  static final StreamController<ConnectionType> _connectionTypeController =
      StreamController<ConnectionType>.broadcast();

  static Stream<ConnectionType> get connectionTypeStream async* {
    yield* _connectionTypeController.stream;
  }

  /// 獲取當前策略（用於測試或調試）
  static PlatformStrategy? get currentStrategy => _currentStrategy;

  /// 檢查是否已初始化
  static bool get isInitialized => _initialized;

  /// 獲取連接客戶端實例
  static ConnectionClient get instance {
    if (!_initialized || _instance == null) {
      throw StateError(
          'ConnectionClientFactory not initialized. Call initialize() first.');
    }
    return _instance!;
  }

  /// 初始化工廠
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      _currentStrategy = PlatformStrategyFactory.getCurrentStrategy();

      // 如果需要監控 USB，開始監控
      if (_currentStrategy!.shouldMonitorUsb) {
        await _currentStrategy!.startUsbMonitoring(_onUsbStatusChanged);
      }

      // 創建連接客戶端
      _instance = await _currentStrategy!.createClient();
      _initialized = true;

      print(
          'ConnectionClientFactory initialized with ${_currentStrategy.runtimeType}');
    } catch (e) {
      print('Failed to initialize ConnectionClientFactory: $e');
      rethrow;
    }
  }

  /// 處理 USB 狀態變化
  static void _onUsbStatusChanged(bool isUsbConnected) {
    print('USB status changed: $isUsbConnected');

    _currentStrategy?.handleUsbStatusChange(
      isUsbConnected,
      _connectionTypeController.add,
    );
  }

  /// 手動切換連接類型（用於測試或特殊情況）
  static Future<void> switchConnectionType(ConnectionType type) async {
    try {
      // 停止當前的 USB 監控
      await _currentStrategy?.stopUsbMonitoring();

      // 創建新的客戶端
      if (type == ConnectionType.usb) {
        _instance = USBClient();
      } else if (type == ConnectionType.ble) {
        _instance = BLEClient();
      }

      // 發送連接類型變化事件
      _connectionTypeController.add(type);

      print('Switched to connection type: $type');
    } catch (e) {
      print('Failed to switch connection type: $e');
      rethrow;
    }
  }

  /// 重置工廠（主要用於測試）
  static Future<void> reset() async {
    await dispose();
    PlatformStrategyFactory.clearTestStrategy();
  }

  /// 釋放資源
  static Future<void> dispose() async {
    try {
      await _currentStrategy?.stopUsbMonitoring();

      if (!_connectionTypeController.isClosed) {
        await _connectionTypeController.close();
      }

      _instance = null;
      _currentStrategy = null;
      _initialized = false;

      print('ConnectionClientFactory disposed');
    } catch (e) {
      print('Error disposing ConnectionClientFactory: $e');
    }
  }
}
