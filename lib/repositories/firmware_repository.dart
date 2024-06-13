import 'package:aci_plus_app/core/command.dart';
import 'package:aci_plus_app/core/command18.dart';
import 'package:aci_plus_app/core/crc16_calculate.dart';
import 'package:aci_plus_app/core/firmware_file_table.dart';
import 'package:aci_plus_app/repositories/ble_client_base.dart';
import 'package:aci_plus_app/repositories/ble_factory.dart';
import 'package:flutter/services.dart';

class FirmwareRepository {
  FirmwareRepository() : _bleClient = BLEClientFactory.instance;

  final BLEClientBase _bleClient;

  Stream<String> get updateReport async* {
    yield* _bleClient.updateReport;
  }

  Future<List<dynamic>> calculateCheckSum({required String binaryPath}) async {
    if (binaryPath.isEmpty) {
      return [false, ''];
    }

    ByteData byteData = await rootBundle.load(binaryPath);

    int sum = 0;

    for (int number in byteData.buffer.asUint8List()) {
      sum += number;
    }

    print('$sum ${sum.toRadixString(16)}');
    print(byteData.lengthInBytes);

    return [
      true,
      sum,
      byteData.buffer.asUint8List().toList(),
    ];
  }

  Future<dynamic> enterBootloader() async {
    int commandIndex = 1000;

    print('Entering Bootloader');

    List<int> cmd = List<int>.generate(10, (index) => 0xf0);

    await _bleClient.transferFirmwareCommand(
      commandIndex: commandIndex,
      command: cmd,
    );
  }

  Future<dynamic> writeCommand(List<int> cmd) async {
    int commandIndex = 1000;

    print('Write ${String.fromCharCodes(cmd)}');
    // 0x43 67 C
    // 0x4E 78 N
    // 0x59 89 Y

    await _bleClient.transferFirmwareCommand(
      commandIndex: commandIndex,
      command: cmd,
    );
  }

  Future<dynamic> exitBootloader() async {
    List<int> req00Cmd = [0xB0, 0x03, 0x00, 0x00, 0x00, 0x06, 0, 0]; //0
    CRC16.calculateCRC16(command: req00Cmd, usDataLength: 6);

    await _bleClient.transferFirmwareCommand(
      commandIndex: 300,
      command: req00Cmd,
    );
  }

  Future<dynamic> updateFirmware({
    required List<int> binary,
  }) async {
    // List<int> binaryWithLeadingC = [0x43, ...binary];
    try {
      List<int> rawData = await _bleClient.transferFirmwareBinary(
        commandIndex: 1000,
        binary: binary,
      );
      return String.fromCharCodes(rawData);
    } catch (e) {
      return e;
    }
  }
}
