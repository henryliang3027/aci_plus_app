import 'dart:io';
import 'dart:typed_data';

import 'package:aci_plus_app/core/crc16_calculate.dart';
import 'package:aci_plus_app/core/firmware_file_table.dart';
import 'package:aci_plus_app/repositories/ble_client_base.dart';
import 'package:aci_plus_app/repositories/ble_factory.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';

class FirmwareRepository {
  FirmwareRepository() : _bleClient = BLEClientFactory.instance;

  final BLEClientBase _bleClient;

  Stream<String> get updateReport async* {
    yield* _bleClient.updateReport;
  }

  List<dynamic> checkFileContent(
      {required String partId, required Uint8List binaryData}) {
    List<int> fileID = FirmwareFileTable.fileIDMap[partId]!;

    // 檢查 binary file 裡是否有正確的識別碼, 以迴圈方式每次取出長度為 uint8fileID.length 的 binaryData 內容來比對
    Uint8List uint8fileID = Uint8List.fromList(fileID);
    for (int i = 0; i <= binaryData.length - uint8fileID.length; i++) {
      Uint8List sublist =
          Uint8List.sublistView(binaryData, i, i + uint8fileID.length);
      if (areEqual(sublist, uint8fileID)) {
        return [true];
      }
    }
    return [false, 'The file you selected is invalid'];
  }

  // 比對取出的 binaryData 內容與 uint8fileID 是否相同
  bool areEqual(Uint8List list1, Uint8List list2) {
    if (list1.length != list2.length) return false;

    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
        return false;
      }
    }

    return true;
  }

  Future<List<dynamic>> calculateCheckSum(
      {required Uint8List binaryData}) async {
    int sum = 0;

    for (int number in binaryData.buffer.asUint8List()) {
      sum += number;
    }

    print('$sum ${sum.toRadixString(16)}');
    print(binaryData.lengthInBytes);

    return [
      sum,
      binaryData.buffer.asUint8List().toList(),
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

  Future<int> getChunkSize() async {
    // ios version < 16 mtu 為 182, 其餘為 244
    // android 為 247, 3 個 byte 用在 header, 所以實際可容納的量為 244

    if (Platform.isIOS) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;

      // ipad version ex: 16.6.1
      // ios version ex: 16.5
      double version = double.parse(iosDeviceInfo.systemVersion.split('.')[0]);

      if (version < 16) {
        return 182;
      } else {
        return 244;
      }
    } else {
      // android or windows
      return 244;
    }
  }

  List<List<int>> divideToChunkList({
    required List<int> binary,
    required int chunkSize,
  }) {
    List<List<int>> chunks = [];
    for (int i = 0; i < binary.length; i += chunkSize) {
      int end = (i + chunkSize < binary.length) ? i + chunkSize : binary.length;
      chunks.add(binary.sublist(i, end));
    }
    return chunks;
  }

  Future<void> transferBinaryChunk({
    required List<int> chunk,
    required int indexOfChunk,
  }) async {
    await _bleClient.transferBinaryChunk(
        commandIndex: 1000, chunk: chunk, indexOfChunk: indexOfChunk);
  }
}
