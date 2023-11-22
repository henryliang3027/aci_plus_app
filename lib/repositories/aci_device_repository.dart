import 'package:aci_plus_app/core/command.dart';
import 'package:aci_plus_app/core/crc16_calculate.dart';
import 'package:aci_plus_app/repositories/ble_client.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class ACIDeviceRepository {
  ACIDeviceRepository() : _bleClient = BLEClient.instance;

  final BLEClient _bleClient;

  Stream<ScanReport> get scanReport async* {
    yield* _bleClient.scanReport;
  }

  Stream<ConnectionReport> get connectionStateReport async* {
    yield* _bleClient.connectionStateReport;
  }

  Future<void> connectToDevice(DiscoveredDevice discoveredDevice) {
    return _bleClient.connectToDevice(discoveredDevice);
  }

  Future<void> closeScanStream() async {
    await _bleClient.closeScanStream();
  }

  Future<void> closeConnectionStream() async {
    await _bleClient.closeConnectionStream();
  }

  Future<dynamic> getACIDeviceType({
    required String deviceId,
    int mtu = 247,
  }) async {
    CRC16.calculateCRC16(command: Command.req00Cmd, usDataLength: 6);
    return _bleClient.getACIDeviceType(
      commandIndex: -1,
      value: Command.req00Cmd,
      deviceId: deviceId,
      mtu: mtu,
    );
  }
}
