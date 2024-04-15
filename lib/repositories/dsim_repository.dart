import 'dart:async';

import 'package:aci_plus_app/core/command.dart';
import 'package:aci_plus_app/core/crc16_calculate.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/shared_preference_key.dart';
import 'package:aci_plus_app/repositories/ble_windows_client.dart';
import 'package:aci_plus_app/repositories/dsim_parser.dart';
import 'package:flutter_speed_chart/speed_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DsimRepository {
  DsimRepository()
      : _bleClient = BLEWindowsClient.instance,
        _dsimParser = DsimParser();

  final BLEWindowsClient _bleClient;
  final DsimParser _dsimParser;

  late StreamController<Map<DataKey, String>>
      _characteristicDataStreamController;

  bool isCreateCharacteristicDataStreamController = false;

  Stream<Map<DataKey, String>> get characteristicData async* {
    yield* _characteristicDataStreamController.stream;
  }

  void createCharacteristicDataStream() {
    if (!isCreateCharacteristicDataStreamController) {
      _characteristicDataStreamController =
          StreamController<Map<DataKey, String>>();
      isCreateCharacteristicDataStreamController = true;
    }
  }

  void closeCharacteristicDataStream() async {
    if (isCreateCharacteristicDataStreamController) {
      if (_characteristicDataStreamController.hasListener) {
        if (!_characteristicDataStreamController.isClosed) {
          await _characteristicDataStreamController.close();
          isCreateCharacteristicDataStreamController = false;
        }
      }
    }
  }

  void clearCache() {
    _dsimParser.clearCache();
  }

  Future<dynamic> requestCommand0() async {
    int commandIndex = 0;

    print('get data from request command 0');

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _dsimParser.commandCollection[commandIndex],
      );

      String typeNo = _dsimParser.parseCommand0(rawData);

      return [true, typeNo];
    } catch (e) {
      return [
        false,
      ];
    }
  }

  Future<dynamic> requestCommand1() async {
    int commandIndex = 1;

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _dsimParser.commandCollection[commandIndex],
      );

      A1G1 a1g1 = _dsimParser.parseCommand1(rawData);

      return [
        true,
        a1g1.partNo,
        a1g1.hasDualPilot,
      ];
    } catch (e) {
      return [
        false,
      ];
    }
  }

  Future<dynamic> requestCommand2() async {
    int commandIndex = 2;

    print('get data from request command 2');

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _dsimParser.commandCollection[commandIndex],
      );

      String serialNumber = _dsimParser.parseCommand2(rawData);

      return [
        true,
        serialNumber,
      ];
    } catch (e) {
      return [
        false,
      ];
    }
  }

  Future<dynamic> requestCommand3() async {
    int commandIndex = 3;

    print('get data from request command 3');

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _dsimParser.commandCollection[commandIndex],
      );

      A1G3 a1g3 = _dsimParser.parseCommand3(rawData);

      return [
        true,
        a1g3.logInterval,
        a1g3.firmwareVersion,
      ];
    } catch (e) {
      return [
        false,
      ];
    }
  }

  Future<dynamic> requestCommand4() async {
    int commandIndex = 4;
    print('get data from request command 4');

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _dsimParser.commandCollection[commandIndex],
      );

      A1G4 a1g4 = _dsimParser.parseCommand4(rawData);

      return [
        true,
        a1g4.currentAttenuation,
        a1g4.minAttenuation,
        a1g4.maxAttenuation,
        a1g4.tgcCableLength,
      ];
    } catch (e) {
      return [
        false,
      ];
    }
  }

  Future<dynamic> requestCommand5() async {
    int commandIndex = 5;

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _dsimParser.commandCollection[commandIndex],
      );

      A1G5 a1g5 = _dsimParser.parseCommand5(rawData);

      return [
        true,
        a1g5.workingMode,
        a1g5.currentPilot,
        a1g5.pilotMode,
        a1g5.rfAlarmSeverity,
        a1g5.temperatureAlarmSeverity,
        a1g5.powerAlarmSeverity,
        a1g5.currentTemperatureF,
        a1g5.currentTemperatureC,
        a1g5.currentVoltage,
      ];
    } catch (e) {
      return [
        false,
      ];
    }
  }

  Future<dynamic> requestCommand6() async {
    int commandIndex = 6;

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _dsimParser.commandCollection[commandIndex],
      );

      A1G6 a1g6 = _dsimParser.parseCommand6(rawData);

      return [
        true,
        a1g6.centerAttenuation,
        a1g6.currentVoltageRipple,
      ];
    } catch (e) {
      return [
        false,
      ];
    }
  }

  Future<dynamic> requestCommand9() async {
    int commandIndex = 6;

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _dsimParser.commandCollection[commandIndex],
      );

      A1G6 a1g6 = _dsimParser.parseCommand6(rawData);

      return [
        true,
        a1g6.centerAttenuation,
        a1g6.currentVoltageRipple,
      ];
    } catch (e) {
      return [
        false,
      ];
    }
  }

  // location
  Future requestCommand9To12() async {
    String location = '';
    for (int i = 9; i <= 12; i++) {
      int commandIndex = i;
      try {
        List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
          commandIndex: commandIndex,
          value: _dsimParser.commandCollection[commandIndex],
        );

        String partOfLocation =
            _dsimParser.parseLocationChunk(rawData, commandIndex - 9);

        location += partOfLocation;

        if (commandIndex == 12) {
          return [
            true,
            location,
          ];
        }
      } catch (e) {
        return [
          false,
        ];
      }
    }
  }

  Future requestCommandForLogChunk(int chunkIndex) async {
    int commandIndex = chunkIndex;
    print('get data from request command $chunkIndex');

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _dsimParser.commandCollection[commandIndex],
      );

      _dsimParser.parseLog(
        commandIndex: commandIndex,
        rawLog: rawData,
      );

      if (commandIndex == 29) {
        LogStatistic logStatistic = _dsimParser.getLogStatistic();

        return [
          true,
          logStatistic.minTemperatureF,
          logStatistic.maxTemperatureF,
          logStatistic.minTemperatureC,
          logStatistic.maxTemperatureC,
          logStatistic.historicalMinAttenuation,
          logStatistic.historicalMaxAttenuation,
          logStatistic.minVoltage,
          logStatistic.maxVoltage,
          logStatistic.minVoltageRipple,
          logStatistic.maxVoltageRipple,
        ];
      } else {
        return [
          true,
        ];
      }
    } catch (e) {
      return [false, '', '', '', '', '', '', '', '', '', ''];
    }
  }

  Future requestCommand30To37() async {
    for (int i = 30; i <= 37; i++) {
      int commandIndex = i;

      print('get data from request command $i');
      try {
        List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
          commandIndex: commandIndex,
          value: _dsimParser.commandCollection[commandIndex],
        );

        _dsimParser.parseEvent(
          commandIndex: commandIndex,
          rawEvent: rawData,
        );
      } catch (e) {
        return [false];
      }
    }

    return [true];
  }

  Future<bool> setLocation(String location) async {
    int newLength = location.length;
    int imod;
    int index;
    for (var i = 0; i < 12; i++) {
      Command.setLoc9Cmd[7 + i] = 0;
      Command.setLocACmd[7 + i] = 0;
      Command.setLocBCmd[7 + i] = 0;
      Command.setLocCCmd[7 + i] = 0;
    }

    for (int unit in location.codeUnits) {
      //如果超出 ascii 的範圍則回傳 false
      if (unit > 255) {
        return false;
      }
    }

    imod = newLength % 12;
    index = (newLength - imod) ~/ 12;
    if (imod > 0) index += 1;
    if (imod == 0) imod = 12;
    if (index == 4) {
      for (var i = 0; i < 12; i++) {
        Command.setLoc9Cmd[7 + i] = location.codeUnitAt(i);
      }
      for (var i = 12; i < 24; i++) {
        Command.setLocACmd[7 + i - 12] = location.codeUnitAt(i);
      }
      for (var i = 24; i < 36; i++) {
        Command.setLocBCmd[7 + i - 24] = location.codeUnitAt(i);
      }
      if (imod > 4) {
        imod = 4;
      }
      for (var i = 36; i < 36 + imod; i++) {
        Command.setLocCCmd[7 + i - 36] = location.codeUnitAt(i);
      }
    } //4
    if (index == 3) {
      for (var i = 0; i < 12; i++) {
        Command.setLoc9Cmd[7 + i] = location.codeUnitAt(i);
      }

      for (var i = 12; i < 24; i++) {
        Command.setLocACmd[7 + i - 12] = location.codeUnitAt(i);
      }
      for (var i = 24; i < 24 + imod; i++) {
        Command.setLocBCmd[7 + i - 24] = location.codeUnitAt(i);
      }
    } //3
    if (index == 2) {
      for (var i = 0; i < 12; i++) {
        Command.setLoc9Cmd[7 + i] = location.codeUnitAt(i);
      }
      for (var i = 12; i < 12 + imod; i++) {
        Command.setLocACmd[7 + i - 12] = location.codeUnitAt(i);
      }
    } //2
    if (index == 1) {
      for (var i = 0; i < imod; i++) {
        Command.setLoc9Cmd[7 + i] = location.codeUnitAt(i);
      }
    } //1

    // calculateLocationCRCs
    CRC16.calculateCRC16(command: Command.setLoc9Cmd, usDataLength: 19);
    CRC16.calculateCRC16(command: Command.setLocACmd, usDataLength: 19);
    CRC16.calculateCRC16(command: Command.setLocBCmd, usDataLength: 19);
    CRC16.calculateCRC16(command: Command.setLocCCmd, usDataLength: 19);

    List<List<int>> locationCommand = [
      Command.setLoc9Cmd,
      Command.setLocACmd,
      Command.setLocBCmd,
      Command.setLocCCmd
    ];

    for (int i = 0; i <= 3; i++) {
      int commandIndex = i + 40;
      try {
        List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
          commandIndex: commandIndex,
          value: locationCommand[i],
        );
      } catch (e) {
        return false;
      }
    }

    // 設定後重新讀取 location 來比對是否設定成功
    List<dynamic> resultOfGetLocation = await requestCommand9To12();

    if (resultOfGetLocation[0]) {
      if (location == resultOfGetLocation[1]) {
        _characteristicDataStreamController
            .add({DataKey.location: resultOfGetLocation[1]});
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> setTGCCableLength({
    required int currentAttenuation,
    required String tgcCableLength,
    required String pilotChannel,
    required String pilotMode,
    required String logIntervalId,
  }) async {
    Command.set04Cmd[7] = 3; //3 TGC
    Command.set04Cmd[8] = currentAttenuation ~/ 256; //MGC Value 2Bytes
    Command.set04Cmd[9] = currentAttenuation % 256; //MGC Value
    Command.set04Cmd[10] = int.parse(tgcCableLength); //TGC Cable length
    Command.set04Cmd[11] = int.parse(pilotChannel); //AGC Channel 1Byte
    Command.set04Cmd[12] = _getPilotModeId(pilotMode); //AGC channel Mode 1 Byte
    Command.set04Cmd[13] = int.parse(logIntervalId); //Log Minutes 1Byte
    Command.set04Cmd[14] = 0x03; //AGC Channel 2 1Byte
    Command.set04Cmd[15] = 0x02; //AGC Channel 2 Mode 1Byte
    CRC16.calculateCRC16(command: Command.set04Cmd, usDataLength: 19);

    try {
      int commandIndex = 44;
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command.set04Cmd,
      );
    } catch (e) {
      return false;
    }

    // 設定後重新讀取 tgc cable length 來比對是否設定成功

    List<dynamic> resultOfCommand4 = await requestCommand4();
    List<dynamic> resultOfCommand5 = await requestCommand5();

    if (resultOfCommand4[0] && resultOfCommand5[0]) {
      if (tgcCableLength == resultOfCommand4[4]) {
        _characteristicDataStreamController
            .add({DataKey.tgcCableLength: resultOfCommand4[4]});

        _characteristicDataStreamController
            .add({DataKey.workingMode: resultOfCommand5[1]});

        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> setLogInterval({
    required String logIntervalId,
  }) async {
    int intLogIntervalId = int.parse(logIntervalId);

    Command.set04Cmd[7] = 0x08; // 8
    Command.set04Cmd[13] = intLogIntervalId; // Log Minutes 1Byte
    CRC16.calculateCRC16(command: Command.set04Cmd, usDataLength: 19);

    try {
      int commandIndex = 45;
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command.set04Cmd,
      );
    } catch (e) {
      return false;
    }

    // 設定後重新讀取 log interval 來比對是否設定成功
    List<dynamic> result = await requestCommand3();

    if (result[0]) {
      if (logIntervalId.toString() == result[1]) {
        _characteristicDataStreamController
            .add({DataKey.logInterval: result[1]});
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> setWorkingMode({
    required String workingMode,
    required int currentAttenuation,
    required String tgcCableLength,
    required String pilotChannel,
    required String pilotMode,
    String pilot2Channel = '',
    String pilot2Mode = '',
    required String logIntervalId,
    required bool hasDualPilot,
  }) async {
    int workingModeId = _getWorkingModeId(workingMode);

    if (hasDualPilot) {
      Command.set04Cmd[7] = workingModeId;
      Command.set04Cmd[8] = currentAttenuation ~/ 256; //MGC Value 2Bytes
      Command.set04Cmd[9] = currentAttenuation % 256; //MGC Value
      Command.set04Cmd[10] = int.parse(tgcCableLength); //TGC Cable length
      Command.set04Cmd[11] = int.parse(pilotChannel); //AGC Channel 1Byte
      Command.set04Cmd[12] =
          _getPilotModeId(pilotMode); //AGC channel Mode 1 Byte
      Command.set04Cmd[13] = int.parse(logIntervalId); //Log Minutes 1Byte
      Command.set04Cmd[14] = int.parse(pilot2Channel); //AGC Channel 2 1Byte
      Command.set04Cmd[15] =
          _getPilotModeId(pilot2Mode); //AGC Channel 2 Mode 1Byte
    } else {
      Command.set04Cmd[7] = workingModeId;
      Command.set04Cmd[8] = currentAttenuation ~/ 256; //MGC Value 2Bytes
      Command.set04Cmd[9] = currentAttenuation % 256; //MGC Value
      Command.set04Cmd[10] = int.parse(tgcCableLength); //TGC Cable length
      Command.set04Cmd[11] = int.parse(pilotChannel); //AGC Channel 1Byte
      Command.set04Cmd[12] =
          _getPilotModeId(pilot2Mode); //AGC channel Mode 1 Byte
      Command.set04Cmd[13] = int.parse(logIntervalId); //Log Minutes 1Byte
      Command.set04Cmd[14] = 0x03; //AGC Channel 2 1Byte
      Command.set04Cmd[15] = 0x02; //AGC Channel 2 Mode 1Byte
    }

    CRC16.calculateCRC16(command: Command.set04Cmd, usDataLength: 19);

    int commandIndex = 46;

    if (workingModeId == 1) {
      // AGC
      try {
        List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
          commandIndex: commandIndex,
          value: Command.set04Cmd,
        );

        // 等 30 秒再讀取 working mode
        await Future.delayed(const Duration(seconds: 30));
      } catch (e) {
        return false;
      }
    } else {
      try {
        List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
          commandIndex: commandIndex,
          value: Command.set04Cmd,
        );
      } catch (e) {
        return false;
      }
    }

    // 設定後重新讀取 working mode 來比對是否設定成功
    List<dynamic> resultOfCommand5 = await requestCommand5();

    if (resultOfCommand5[0]) {
      // 設定 AGC mode 如果失敗會變為 TGC mode
      _characteristicDataStreamController
          .add({DataKey.workingMode: resultOfCommand5[1]});
      _characteristicDataStreamController
          .add({DataKey.currentPilot: resultOfCommand5[2]});
      _characteristicDataStreamController
          .add({DataKey.currentPilotMode: resultOfCommand5[3]});

      _characteristicDataStreamController
          .add({DataKey.currentAttenuation: currentAttenuation.toString()});

      if (workingMode == resultOfCommand5[1]) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  int _getWorkingModeId(String workingMode) {
    switch (workingMode) {
      case 'AGC':
        return 1;
      case 'TGC':
        return 3;
      case 'MGC':
        return 4;
      default:
        return 1;
    }
  }

  int _getPilotModeId(String pilotMode) {
    if (pilotMode == 'IRC') {
      return 1;
    } else {
      return 2;
    }
  }

  Future<dynamic> exportRecords() async {
    return _dsimParser.exportRecords();
  }

  List<List<ValuePair>> getDateValueCollectionOfLogs() {
    return _dsimParser.getDateValueCollectionOfLogs();
  }

  Future<bool> writePilotCode(String pilotCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result =
        await prefs.setString(SharedPreferenceKey.pilotCode.name, pilotCode);
    return result;
  }

  Future<bool> writePilot2Code(String pilot2Code) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result =
        await prefs.setString(SharedPreferenceKey.pilot2Code.name, pilot2Code);
    return result;
  }

  Future<String> readPilotCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String pilotCode =
        prefs.getString(SharedPreferenceKey.pilotCode.name) ?? 'GG<@';
    return pilotCode;
  }

  Future<String> readPilot2Code() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String pilot2Code =
        prefs.getString(SharedPreferenceKey.pilot2Code.name) ?? 'C<A';
    return pilot2Code;
  }
}
