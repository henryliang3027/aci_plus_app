import 'package:aci_plus_app/core/command.dart';
import 'package:aci_plus_app/core/command18.dart';
import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/crc16_calculate.dart';
import 'package:aci_plus_app/repositories/ble_client_base.dart';
import 'package:aci_plus_app/repositories/ble_command_mixin.dart';
import 'package:aci_plus_app/repositories/ble_factory.dart';
import 'package:aci_plus_app/repositories/ble_peripheral.dart';

class ACIDeviceRepository with BLECommandsMixin {
  ACIDeviceRepository() : _bleClient = BLEClientFactory.instance;

  final BLEClientBase _bleClient;

  // Implement the abstract getter required by the mixin.
  @override
  BLEClientBase get bleClient => _bleClient;

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

  Future<dynamic> setMTU(int mtu) async {
    return set1p8GTwoBytesParameter(
      value: mtu.toString(),
      command: Command18.setMTUCmd,
      factor: 1,
    );
  }

  Future<dynamic> set1p8GTransmitDelayTime(int ms) async {
    int commandIndex = 355;

    print('get data from request command 1p8G$commandIndex');

    return set1p8GTwoBytesParameter(
      value: ms.toString(),
      command: Command18.setTransmitDelayTimeCmd,
      factor: 1,
    );
  }

  Future<dynamic> getACIDeviceType({
    required String deviceId,
  }) async {
    CRC16.calculateCRC16(command: Command.req00Cmd, usDataLength: 6);

    return _bleClient.getACIDeviceType(
      commandIndex: 80,
      value: Command.req00Cmd,
      deviceId: deviceId,
    );
  }
}
