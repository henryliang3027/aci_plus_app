import 'package:aci_plus_app/core/command18.dart';
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

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.bootloaderCmd,
      );
      return rawData;
    } catch (e) {
      return e;
    }
  }
}
