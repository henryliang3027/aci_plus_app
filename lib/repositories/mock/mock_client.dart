import 'dart:async';

import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/repositories/ble_peripheral.dart';
import 'package:aci_plus_app/repositories/connection_client.dart';

class MockClient extends ConnectionClient {
  final StreamController<ConnectionReport> _connectionReportStreamController =
      StreamController<ConnectionReport>();

  final StreamController<ScanReport> _scanReportStreamController =
      StreamController<ScanReport>();

  final StreamController<String> _updateReportStreamController =
      StreamController<String>();

  @override
  void cancelCharacteristicDataTimer({required String name}) {}

  @override
  Future<void> closeConnectionStream() async {}

  @override
  Future<void> closeScanStream() async {}

  @override
  Future<void> connectToDevice(Peripheral peripheral) async {}

  @override
  Stream<ConnectionReport> get connectionStateReport =>
      _connectionReportStreamController.stream;

  @override
  Future getACIDeviceType(
      {required int commandIndex,
      required List<int> value,
      required String deviceId,
      int mtu = 244}) async {
    // 模擬返回一個 ACIDeviceType
    await Future.delayed(const Duration(milliseconds: 100));
    return [
      true,
      ACIDeviceType.amp1P8G,
    ];
  }

  @override
  Future<int> getRSSI() {
    // 模擬返回一個 RSSI 值
    return Future.value(-60);
  }

  @override
  Stream<ScanReport> get scanReport => _scanReportStreamController.stream;

  @override
  Future<void> transferBinaryChunk(
      {required int commandIndex,
      required List<int> chunk,
      required int indexOfChunk}) {
    // 模擬傳輸二進制塊
    return Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Future<void> transferFirmwareCommand(
      {required int commandIndex,
      required List<int> command,
      Duration timeout = const Duration(seconds: 10)}) {
    // 模擬傳輸韌體命令
    return Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Stream<String> get updateReport => _updateReportStreamController.stream;

  @override
  Future writeLongSetCommandToCharacteristic(
      {required int commandIndex,
      required List<List<int>> chunks,
      Duration timeout = const Duration(seconds: 10)}) {
    // 模擬寫入長設置命令到特徵
    return Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Future writeSetCommandToCharacteristic(
      {required int commandIndex,
      required List<int> value,
      Duration timeout = const Duration(seconds: 10)}) {
    // 模擬寫入設置命令到特徵
    return Future.delayed(const Duration(milliseconds: 100));
  }
}
