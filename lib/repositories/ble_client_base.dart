import 'dart:io';

import 'package:aci_plus_app/core/crc16_calculate.dart';
import 'package:aci_plus_app/repositories/ble_client.dart';
import 'package:aci_plus_app/repositories/ble_peripheral.dart';
import 'package:aci_plus_app/repositories/ble_windows_client.dart';
import 'package:flutter/foundation.dart';

abstract class BLEClientBase {
  final List<int> _combinedRawData = [];

  Stream<ScanReport> get scanReport;

  Stream<ConnectionReport> get connectionStateReport;

  Stream<String> get updateReport;

  Future<void> connectToDevice();

  Future<void> closeScanStream();

  Future<void> closeConnectionStream();

  Future<dynamic> getACIDeviceType({
    required int commandIndex,
    required List<int> value,
    required String deviceId,
    int mtu = 247,
  });

  Future<int> getRSSI();

  Future<dynamic> writeSetCommandToCharacteristic({
    required int commandIndex,
    required List<int> value,
    Duration timeout = const Duration(seconds: 10),
  });

  Future<void> transferFirmwareBinary({
    required int commandIndex,
    required List<int> binary,
    Duration timeout = const Duration(seconds: 10),
  });

  Future<void> transferFirmwareCommand({
    required int commandIndex,
    required List<int> command,
    Duration timeout = const Duration(seconds: 10),
  });

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

  bool checkCRC(
    List<int> rawData,
  ) {
    List<int> crcData = List<int>.from(rawData);
    CRC16.calculateCRC16(command: crcData, usDataLength: crcData.length - 2);
    if (rawData.isNotEmpty) {
      if (crcData[crcData.length - 1] == rawData[rawData.length - 1] &&
          crcData[crcData.length - 2] == rawData[rawData.length - 2]) {
        return true;
      } else {
        return false;
      }
    } else {
      // 如果 rawData 是空的
      return false;
    }
  }

  List<dynamic> _combine1p8GRawData({
    required List<int> rawData,
    required int length,
  }) {
    // 如過接收到一半失敗, 則重傳時遇到 header 就清除 _combinedRawData
    List<int> header = [0xB0, 0x03, 0x00];
    if (listEquals(rawData.sublist(0, 3), header)) {
      _combinedRawData.clear();
      _combinedRawData.addAll(rawData);
      print(_combinedRawData.length);
      return [false];
    } else {
      _combinedRawData.addAll(rawData);
      print(_combinedRawData.length);
      if (_combinedRawData.length == length) {
        List<int> finalRawData = List.from(_combinedRawData);

        //清除 _combinedRawData, 給下一個任一需要 combine 的 command 使用
        _combinedRawData.clear();

        return [true, finalRawData];
      } else {
        return [false];
      }
    }
  }

  List<dynamic> combineRawData({
    required commandIndex,
    required List<int> rawData,
  }) {
    if (commandIndex <= 13) {
      return [true, rawData];
    } else if (commandIndex >= 14 && commandIndex <= 37) {
      _combinedRawData.addAll(rawData);
      // 一個 log command 總共會接收 261 bytes, 每一次傳回 16 bytes
      if (_combinedRawData.length == 261) {
        List<int> combinedRawData = List.from(_combinedRawData);
        _combinedRawData.clear();
        return [true, combinedRawData];
      } else {
        return [false];
      }
    } else if (commandIndex >= 40 && commandIndex <= 46) {
      return [true, rawData];
    } else if (commandIndex >= 80 && commandIndex <= 83) {
      // rawData 長度小於 mtu size, 不需要 combine data
      return [true, rawData];
    } else if (commandIndex == 183) {
      // 接收 RF input/output power 資料流
      // RF input/output power 資料流總長度 1029
      return _combine1p8GRawData(rawData: rawData, length: 1029);
    } else if (commandIndex >= 184 && commandIndex <= 194) {
      // _currentCommandIndex 184 ~ 193 用來接收 10 組 Log 資料流, 每一組 Log 總長 16389
      // _currentCommandIndex 194 用來接收 1 組 Event 資料流, Event 總長 16389
      return _combine1p8GRawData(rawData: rawData, length: 16389);
    } else if (commandIndex >= 195 && commandIndex <= 204) {
      // _currentCommandIndex 195 ~ 204 用來接收 10 組 RFOut 資料流, 每一組 RFOut 總長 16389
      return _combine1p8GRawData(rawData: rawData, length: 16389);
    } else if (commandIndex >= 300 && commandIndex <= 999) {
      return [true, rawData];
    } else if (commandIndex >= 1000 && commandIndex <= 1100) {
      return [true, rawData];
    } else {
      return [false];
    }
  }

  void clearCombinedRawData() {
    _combinedRawData.clear();
  }
}
