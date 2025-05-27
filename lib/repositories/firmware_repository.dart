import 'dart:io';
import 'dart:typed_data';

import 'package:aci_plus_app/core/command18.dart';
import 'package:aci_plus_app/core/crc16_calculate.dart';
import 'package:aci_plus_app/core/firmware_file_id.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/repositories/connection_client.dart';
import 'package:aci_plus_app/repositories/connection_client_factory.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FirmwareRepository {
  FirmwareRepository() : _connectionClient = ConnectionClientFactory.instance;

  ConnectionClient _connectionClient;

  Stream<String> get updateReport async* {
    yield* _connectionClient.updateReport;
  }

  void updateClient() {
    _connectionClient = ConnectionClientFactory.instance;
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

    await _connectionClient.transferFirmwareCommand(
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

    await _connectionClient.transferFirmwareCommand(
      commandIndex: commandIndex,
      command: cmd,
    );
  }

  Future<dynamic> exitBootloader() async {
    List<int> req00Cmd = [0xB0, 0x03, 0x00, 0x00, 0x00, 0x06, 0, 0]; //0
    CRC16.calculateCRC16(command: req00Cmd, usDataLength: 6);

    await _connectionClient.transferFirmwareCommand(
      commandIndex: 300,
      command: req00Cmd,
    );
  }

  Future<void> transferBinaryChunk({
    required List<int> chunk,
    required int indexOfChunk,
  }) async {
    await _connectionClient.transferBinaryChunk(
        commandIndex: 1000, chunk: chunk, indexOfChunk: indexOfChunk);
  }

  List<UpdateLog> _decodeUpdateLogs(List<int> rawData) {
    List<List<int>> separatedGroups = [];
    List<int> currentGroup = [];
    List<UpdateLog> updateLogs = [];

    List rawDataContent = rawData.sublist(3, 1027);

    // 判斷是否只有 0 或 255, 如果是代表 log 為空
    if (rawDataContent.every((element) => element == 0 || element == 255)) {
      return [];
    } else {
      // 因為前三個 byte 為 header, 後兩個 byte 為 crc, 所以迴圈從有內容的部分迭代
      for (int i = 0; i < rawDataContent.length; i++) {
        if (rawDataContent[i] == 0x00) {
          // ASCII code for ','
          // If we hit a comma, save the current group if it's not empty
          separatedGroups.add(currentGroup);
          currentGroup = []; // Clear the current group for the next set
        } else {
          // Add non-comma ASCII codes to the current group
          currentGroup.add(rawDataContent[i]);
        }
      }

      // After the loop, add any remaining currentGroup
      if (currentGroup.isNotEmpty) {
        separatedGroups.add(currentGroup);
      }

      for (List<int> group in separatedGroups) {
        RegExp regex = RegExp(r'^(\d+),(\d+),(\d+),(\d+)$');
        String strGroup = String.fromCharCodes(group);

        Match? match = regex.firstMatch(strGroup);

        if (match != null) {
          String strType = match.group(1)!;
          String strDateTime = match.group(2)!;
          String strFirmwareVersion = match.group(3)!;
          String strTechnicianID = match.group(4)!;

          UpdateType updateType = strType == UpdateType.upgrade.index.toString()
              ? UpdateType.upgrade
              : UpdateType.downgrade;

          // Parse the components of the DateTime string
          int year = int.parse(strDateTime.substring(0, 4));
          int month = int.parse(strDateTime.substring(4, 6));
          int day = int.parse(strDateTime.substring(6, 8));
          int hour = int.parse(strDateTime.substring(8, 10));
          int minute = int.parse(strDateTime.substring(10, 12));
          int second = int.parse(strDateTime.substring(12, 14));

          DateTime dateTime = DateTime(year, month, day, hour, minute, second);

          updateLogs.add(UpdateLog(
            type: updateType,
            dateTime: dateTime,
            firmwareVersion: strFirmwareVersion,
            technicianID: strTechnicianID,
          ));
        }
      }
      return updateLogs;
    }
  }

  Future<dynamic> requestCommand1p8GUpdateLogs({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    int commandIndex = 206;

    try {
      List<int> rawData =
          await _connectionClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.reqFirmwareUpdateLogCmd,
        timeout: timeout,
      );

      List<UpdateLog> updateLogs = _decodeUpdateLogs(rawData);

      return [
        true,
        updateLogs,
      ];
    } catch (e) {
      return [
        false,
      ];
    }
  }

  Future<dynamic> set1p8GFirmwareUpdateLogs(
    List<UpdateLog> updateLogs,
  ) async {
    int commandIndex = 358;
    print('get data from request command 1p8G$commandIndex');

    List<String> strUpdateLogs = [];

    for (UpdateLog updateLog in updateLogs) {
      String strUpdateLog = updateLog.toString();

      strUpdateLogs.add(strUpdateLog);
    }

    // ASCII code 0x00 corresponds to the null character '\u0000'
    String separator = '\u0000';

    // Join the strings with the separator
    String combinedString = '';

    for (String strUpdateLog in strUpdateLogs) {
      combinedString += '$strUpdateLog$separator';
    }

    List<int> combinedBytes = combinedString.codeUnits;

    for (int i = 0; i < combinedBytes.length; i++) {
      Command18.setFirmwareUpdateLogCmd[i + 7] = combinedBytes[i];
    }

    // 填入空白
    for (int i = combinedBytes.length; i < 1024; i++) {
      Command18.setFirmwareUpdateLogCmd[i + 7] = 0x20;
    }

    CRC16.calculateCRC16(
      command: Command18.setFirmwareUpdateLogCmd,
      usDataLength: Command18.setFirmwareUpdateLogCmd.length - 2,
    );

    // 將 binary 切分成每個大小為 chunkSize 的封包
    int chunkSize = await BLEUtils.getChunkSize();

    List<List<int>> chunks = BLEUtils.divideToChunkList(
      binary: Command18.setFirmwareUpdateLogCmd,
      chunkSize: chunkSize,
    );

    try {
      List<int> rawData =
          await _connectionClient.writeLongSetCommandToCharacteristic(
        commandIndex: commandIndex,
        chunks: chunks,
        timeout: const Duration(seconds: 10),
      );
    } catch (e) {
      return false;
    }

    return true;
  }

  Future<dynamic> exportFirmwareUpdateLogs({
    required AppLocalizations appLocalizations,
    required List<UpdateLog> updateLogs,
  }) async {
    Excel excel = Excel.createExcel();

    excel.rename('Sheet1', 'Update Logs');
    Sheet updateLogSheet = excel['Update Logs'];

    // String dateTimeTitle, typeTitle, firmwareVersionTitle, technicianIDTitle;
    // [dateTimeTitle, typeTitle, firmwareVersionTitle, technicianIDTitle] =
    //     formattedUpdateLogs.first;
    updateLogSheet.insertRowIterables(
      [
        TextCellValue(appLocalizations.time),
        TextCellValue(appLocalizations.firmwareChange),
        TextCellValue(appLocalizations.firmwareVersion),
        TextCellValue(appLocalizations.technicianID),
      ],
      0,
    );

    for (int i = 0; i < updateLogs.length; i++) {
      UpdateLog updateLog = updateLogs[i];
      String dateTime = updateLog.formatDateTime();
      String type = updateLog.type == UpdateType.upgrade
          ? appLocalizations.upgrade
          : appLocalizations.downgrade;
      String firmwareVersion = updateLog.firmwareVersion;
      String technicianID = updateLog.technicianID;

      updateLogSheet.insertRowIterables(
        [
          TextCellValue(dateTime),
          TextCellValue(type),
          TextCellValue(firmwareVersion),
          TextCellValue(technicianID),
        ],
        i + 1,
      );
    }

    var fileBytes = excel.save();

    String timeStamp =
        DateFormat('yyyy_MM_dd_HH_mm_ss').format(DateTime.now()).toString();
    String filename = 'firmware_update_$timeStamp';
    String extension = '.xlsx';

    if (Platform.isIOS) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String fullWrittenPath = '$appDocPath/$filename$extension';
      File f = File(fullWrittenPath);
      await f.writeAsBytes(fileBytes!);
      return [
        true,
        filename,
        fullWrittenPath,
      ];
    } else if (Platform.isAndroid) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String fullWrittenPath = '$appDocPath/$filename$extension';
      File f = File(fullWrittenPath);
      await f.writeAsBytes(fileBytes!);

      return [
        true,
        filename,
        fullWrittenPath,
      ];
    } else if (Platform.isWindows) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      Directory appDocDirFolder = Directory('${appDocDir.path}/ACI+/');
      bool isExist = await appDocDirFolder.exists();
      if (!isExist) {
        await appDocDirFolder.create(recursive: true);
      }

      String appDocPath = appDocDirFolder.path;
      String fullWrittenPath = '$appDocPath/$filename$extension';
      File f = File(fullWrittenPath);
      await f.writeAsBytes(fileBytes!);

      return [
        true,
        filename,
        fullWrittenPath,
      ];
    } else {
      return [
        false,
        '',
        'write file failed, export function not implement on ${Platform.operatingSystem} '
      ];
    }
  }
}

enum UpdateType {
  downgrade,
  upgrade,
}

class UpdateLog {
  const UpdateLog({
    required this.type,
    required this.dateTime,
    required this.firmwareVersion,
    required this.technicianID,
  });

  final UpdateType type;
  final DateTime dateTime;
  final String firmwareVersion;
  final String technicianID;

  @override
  String toString() {
    String strDateTime = DateFormat('yyyyMMddHHmmss').format(dateTime);
    return '${type.index},$strDateTime,$firmwareVersion,$technicianID';
  }

  String formatDateTime() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }
}
