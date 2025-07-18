import 'dart:async';
import 'dart:io';

import 'package:aci_plus_app/repositories/ble_client.dart';
import 'package:aci_plus_app/repositories/ble_windows_client.dart';
import 'package:aci_plus_app/repositories/connection_client.dart';
import 'package:aci_plus_app/repositories/connection_client_factory.dart';
import 'package:aci_plus_app/repositories/usb_client.dart';
import 'package:ftdi_serial/ftdi_serial.dart';

/// 抽象平台策略接口
abstract class PlatformStrategy {
  /// 是否需要監控 USB 狀態
  bool get shouldMonitorUsb;

  /// 創建連接客戶端
  Future<ConnectionClient> createClient();

  /// 開始 USB 監控 (可選)
  Future<void> startUsbMonitoring(Function(bool) onStatusChanged);

  /// 停止 USB 監控
  Future<void> stopUsbMonitoring();

  /// 處理 USB 狀態變化
  void handleUsbStatusChange(
    bool isConnected,
    Function(ConnectionType) onConnectionTypeChanged,
  );
}

/// Android 平台策略
class AndroidStrategy implements PlatformStrategy {
  StreamSubscription? _usbSubscription;

  @override
  bool get shouldMonitorUsb => true;

  @override
  Future<ConnectionClient> createClient() async {
    try {
      final serialDevice = await USBClient.getAttachedDevice();
      if (serialDevice.vendorId != -1) {
        return USBClient();
      }
    } catch (e) {
      print('Error checking USB device: $e');
    }
    return BLEClient();
  }

  @override
  Future<void> startUsbMonitoring(Function(bool) onStatusChanged) async {
    try {
      final usbStatusStream = FtdiSerial.usbStatusStream;
      _usbSubscription = usbStatusStream.listen(
        onStatusChanged,
        onError: (error) {
          print('USB monitoring error: $error');
        },
      );
    } catch (e) {
      print('Failed to start USB monitoring: $e');
    }
  }

  @override
  Future<void> stopUsbMonitoring() async {
    await _usbSubscription?.cancel();
    _usbSubscription = null;
  }

  @override
  void handleUsbStatusChange(
      bool isConnected, Function(ConnectionType) onConnectionTypeChanged) {
    final connectionType =
        isConnected ? ConnectionType.usb : ConnectionType.ble;
    onConnectionTypeChanged(connectionType);
  }
}

/// iOS 平台策略
class IOSStrategy implements PlatformStrategy {
  @override
  bool get shouldMonitorUsb => false;

  @override
  Future<ConnectionClient> createClient() async => BLEClient();

  @override
  Future<void> startUsbMonitoring(Function(bool) onStatusChanged) async {
    // iOS 不需要 USB 監控
  }

  @override
  Future<void> stopUsbMonitoring() async {
    // iOS 不需要 USB 監控
  }

  @override
  void handleUsbStatusChange(
      bool isConnected, Function(ConnectionType) onConnectionTypeChanged) {
    // iOS 不處理 USB 狀態變化
  }
}

/// Windows 平台策略
class WindowsStrategy implements PlatformStrategy {
  @override
  bool get shouldMonitorUsb => false;

  @override
  Future<ConnectionClient> createClient() async => BLEWindowsClient();

  @override
  Future<void> startUsbMonitoring(Function(bool) onStatusChanged) async {
    // Windows 不需要 USB 監控
  }

  @override
  Future<void> stopUsbMonitoring() async {
    // Windows 不需要 USB 監控
  }

  @override
  void handleUsbStatusChange(
      bool isConnected, Function(ConnectionType) onConnectionTypeChanged) {
    // Windows 不處理 USB 狀態變化
  }
}

/// 測試平台策略
class TestStrategy implements PlatformStrategy {
  final bool _shouldMonitorUsb;
  final ConnectionClient _mockClient;
  final bool _shouldSimulateUsbEvents;

  TestStrategy({
    bool shouldMonitorUsb = false,
    ConnectionClient? mockClient,
    bool shouldSimulateUsbEvents = false,
  })  : _shouldMonitorUsb = shouldMonitorUsb,
        _mockClient = mockClient ?? BLEClient(),
        _shouldSimulateUsbEvents = shouldSimulateUsbEvents;

  @override
  bool get shouldMonitorUsb => _shouldMonitorUsb;

  @override
  Future<ConnectionClient> createClient() async => _mockClient;

  @override
  Future<void> startUsbMonitoring(Function(bool) onStatusChanged) async {
    if (_shouldSimulateUsbEvents) {
      // 模擬 USB 事件用於測試
      Future.delayed(
          const Duration(milliseconds: 100), () => onStatusChanged(true));
      Future.delayed(
          const Duration(milliseconds: 200), () => onStatusChanged(false));
    }
  }

  @override
  Future<void> stopUsbMonitoring() async {
    // 測試策略不需要實際停止監控
  }

  @override
  void handleUsbStatusChange(
      bool isConnected, Function(ConnectionType) onConnectionTypeChanged) {
    final connectionType =
        isConnected ? ConnectionType.usb : ConnectionType.ble;
    onConnectionTypeChanged(connectionType);
  }
}

/// 平台策略工廠
class PlatformStrategyFactory {
  /// 測試策略（可選）
  static PlatformStrategy? _testStrategy;

  /// 設置測試策略
  static void setTestStrategy(PlatformStrategy strategy) {
    _testStrategy = strategy;
  }

  /// 清除測試策略
  static void clearTestStrategy() {
    _testStrategy = null;
  }

  /// 獲取當前平台的策略
  static PlatformStrategy getCurrentStrategy() {
    // 測試模式優先
    if (_testStrategy != null) {
      return _testStrategy!;
    }

    // 根據平台返回相應策略
    if (Platform.isAndroid) {
      return AndroidStrategy();
    } else if (Platform.isIOS) {
      return IOSStrategy();
    } else if (Platform.isWindows) {
      return WindowsStrategy();
    } else {
      throw UnsupportedError(
          'Platform ${Platform.operatingSystem} not supported');
    }
  }
}
