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

  Future<List<dynamic>> calculateCheckSum() async {
    String binaryPath = FirmwareFileTable.filePathMap['2'] ?? '';

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

    return [true, ''];
  }

  Future<dynamic> enterBootloader() async {
    int commandIndex = 1000;

    print('Entering Bootloader');

    List<int> cmd = List<int>.generate(1, (index) => 0x43);

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: cmd,
      );
      return rawData;
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> exitBootloader() async {
    List<int> req00Cmd = [0xB0, 0x03, 0x00, 0x00, 0x00, 0x06, 0, 0]; //0
    CRC16.calculateCRC16(command: req00Cmd, usDataLength: 6);

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: 300,
        value: req00Cmd,
      );
      return rawData;
    } catch (e) {
      return e;
    }
  }
}
