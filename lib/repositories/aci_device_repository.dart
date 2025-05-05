import 'package:aci_plus_app/core/command.dart';
import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/crc16_calculate.dart';
import 'package:aci_plus_app/repositories/ble_client_base.dart';
import 'package:aci_plus_app/repositories/ble_factory.dart';
import 'package:aci_plus_app/repositories/ble_peripheral.dart';

class ACIDeviceRepository {
  ACIDeviceRepository() : _bleClient = BLEClientFactory.instance;

  final BLEClientBase _bleClient;

  Stream<ScanReport> get scanReport async* {
    yield* _bleClient.scanReport;
  }

  Stream<ConnectionReport> get connectionStateReport async* {
    yield* _bleClient.connectionStateReport;
  }

  Future<void> connectToDevice(Peripheral peripheral) {
    return _bleClient.connectToDevice(peripheral);
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
      commandIndex: 80,
      value: Command.req00Cmd,
      deviceId: deviceId,
      mtu: mtu,
    );
  }
}
