import 'dart:async';
import 'dart:typed_data';

import 'package:dsim_app/core/command18.dart';
import 'package:dsim_app/core/crc16_calculate.dart';
import 'package:dsim_app/repositories/dsim_repository.dart';

class Dsim18Parser {
  Dsim18Parser() {
    calculate18CRCs();
  }

  final List<List<int>> _command18Collection = [];

  List<List<int>> get command18Collection => _command18Collection;

  void parseRawData({
    required int commandIndex,
    required List<int> rawData,
    required Completer completer,
  }) {
    switch (commandIndex) {
      case 180:
        String partName = '';
        String partNo = '';
        String serialNumber = '';
        String firmwareVersion = '';
        String mfgDate = '';
        String coordinate = '';

        // 解析 partName
        for (int i = 3; i <= 22; i++) {
          partName += String.fromCharCode(rawData[i]);
        }
        partName = partName.trim();

        // 解析 partNo
        for (int i = 23; i <= 42; i++) {
          partNo += String.fromCharCode(rawData[i]);
        }
        partNo = partNo.trim();

        // 解析 serialNumber
        for (int i = 43; i <= 62; i++) {
          serialNumber += String.fromCharCode(rawData[i]);
        }
        serialNumber = serialNumber.trim();

        // 解析 firmwareVersion
        for (int i = 63; i <= 66; i++) {
          firmwareVersion += String.fromCharCode(rawData[i]);
        }
        firmwareVersion = firmwareVersion.trim();

        // 解析 mfgDate
        List<int> rawYear = rawData.sublist(67, 69);
        ByteData byteData = ByteData.sublistView(Uint8List.fromList(rawYear));
        String year = byteData.getInt16(0, Endian.little).toString();
        String month = rawData[69].toString().padLeft(2, '0');
        String day = rawData[70].toString().padLeft(2, '0');
        mfgDate = '$year/$month/$day';

        for (int i = 72; i <= 110; i++) {
          coordinate += String.fromCharCode(rawData[i]);
        }
        coordinate = coordinate.trim();

        if (!completer.isCompleted) {
          completer.complete((
            partName,
            partNo,
            serialNumber,
            firmwareVersion,
            mfgDate,
            coordinate,
          ));
        }

        break;
      case 181:
        String maxTemperatureC = '';
        String minTemperatureC = '';
        String maxTemperatureF = '';
        String minTemperatureF = '';
        String maxVoltage = '';
        String minVoltage = '';
        String location = '';

        // 解析 maxTemperatureC, maxTemperatureF
        List<int> rawMaxTemperatureC = rawData.sublist(3, 5);
        ByteData rawMaxTemperatureCByteData =
            ByteData.sublistView(Uint8List.fromList(rawMaxTemperatureC));

        double maxTemperature =
            rawMaxTemperatureCByteData.getInt16(0, Endian.little) / 10;
        maxTemperatureC = maxTemperature.toStringAsFixed(1);
        maxTemperatureF =
            _convertToFahrenheit(maxTemperature).toStringAsFixed(1);

        // 解析 minTemperatureC, minTemperatureF
        List<int> rawMinTemperatureC = rawData.sublist(5, 7);
        ByteData rawMinTemperatureCByteData =
            ByteData.sublistView(Uint8List.fromList(rawMinTemperatureC));

        double minTemperature =
            rawMinTemperatureCByteData.getInt16(0, Endian.little) / 10;
        minTemperatureC = minTemperature.toStringAsFixed(1);
        minTemperatureF =
            _convertToFahrenheit(minTemperature).toStringAsFixed(1);

        // 解析 maxVoltage, minVoltage
        List<int> rawMaxVoltage = rawData.sublist(7, 9);
        ByteData rawMaxVoltageByteData =
            ByteData.sublistView(Uint8List.fromList(rawMaxVoltage));
        maxVoltage = (rawMaxVoltageByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

        List<int> rawMinVoltage = rawData.sublist(9, 11);
        ByteData rawMinVoltageByteData =
            ByteData.sublistView(Uint8List.fromList(rawMinVoltage));
        minVoltage = (rawMinVoltageByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

        // 解析 location
        for (int i = 54; i <= 149; i++) {
          location += String.fromCharCode(rawData[i]);
        }
        location = location.trim();

        if (!completer.isCompleted) {
          completer.complete((
            minTemperatureC,
            maxTemperatureC,
            minTemperatureF,
            maxTemperatureF,
            minVoltage,
            maxVoltage,
            location,
          ));
        }
        break;
      case 182:
        Alarm alarmUSeverity = Alarm.medium;
        Alarm alarmTServerity = Alarm.medium;
        Alarm alarmPServerity = Alarm.medium;
        String currentTemperatureC = '';
        String currentTemperatureF = '';
        String currentVoltage = '';
        String currentRFInputTotalPower = '';
        String currentRFOutputTotalPower = '';

        int unitStatus = rawData[3];
        alarmUSeverity = unitStatus == 1 ? Alarm.success : Alarm.danger;

        int temperatureStatus = rawData[128];
        alarmTServerity = temperatureStatus == 1 ? Alarm.danger : Alarm.success;

        int powerStatus = rawData[129];
        alarmPServerity = powerStatus == 1 ? Alarm.danger : Alarm.success;

        // 解析 currentTemperatureC, currentTemperatureC
        List<int> rawCurrentTemperatureC = rawData.sublist(4, 6);
        ByteData rawCurrentTemperatureCByteData =
            ByteData.sublistView(Uint8List.fromList(rawCurrentTemperatureC));

        double currentTemperature =
            rawCurrentTemperatureCByteData.getInt16(0, Endian.little) / 10;

        currentTemperatureC = currentTemperature.toStringAsFixed(1);
        currentTemperatureF =
            _convertToFahrenheit(currentTemperature).toStringAsFixed(1);

        // 解析 currentVoltage
        List<int> rawCurrentVoltage = rawData.sublist(6, 8);
        ByteData rawCurrentVoltageByteData =
            ByteData.sublistView(Uint8List.fromList(rawCurrentVoltage));

        currentVoltage =
            (rawCurrentVoltageByteData.getInt16(0, Endian.little) / 10)
                .toStringAsFixed(1);

        // 解析 currentRFInputTotalPower
        List<int> rawCurrentRFInputTotalPower = rawData.sublist(18, 20);
        ByteData rawCurrentRFInputTotalPowerByteData = ByteData.sublistView(
            Uint8List.fromList(rawCurrentRFInputTotalPower));

        currentRFInputTotalPower =
            (rawCurrentRFInputTotalPowerByteData.getInt16(0, Endian.little) /
                    10)
                .toStringAsFixed(1);

        // 解析 currentRFOutputTotalPower
        List<int> rawCurrentRFOutputTotalPower = rawData.sublist(20, 22);
        ByteData rawCurrentRFOutputTotalPowerByteData = ByteData.sublistView(
            Uint8List.fromList(rawCurrentRFOutputTotalPower));

        currentRFOutputTotalPower =
            (rawCurrentRFOutputTotalPowerByteData.getInt16(0, Endian.little) /
                    10)
                .toStringAsFixed(1);

        if (!completer.isCompleted) {
          completer.complete((
            alarmUSeverity.name,
            alarmTServerity.name,
            alarmPServerity.name,
            currentTemperatureC,
            currentTemperatureF,
            currentVoltage,
            currentRFInputTotalPower,
            currentRFOutputTotalPower,
          ));
        }
        break;
      case 183:
      case 184:
      case 185:
      case 186:
      case 187:
      case 188:
      case 189:
      case 190:
      case 191:
      case 192:
        print('${rawData.length}');
        print('${rawData}');
        break;
      case 193:
      case 194:
      case 195:
      case 196:
      case 197:
      case 198:
      case 199:
      case 200:
      case 201:
      case 202:
      case 203:
        break;
      case 204:
        // 給 定期更新 information page 的 alarm 用
        Alarm alarmUSeverity = Alarm.medium;
        Alarm alarmTServerity = Alarm.medium;
        Alarm alarmPServerity = Alarm.medium;

        int unitStatus = rawData[3];
        alarmUSeverity = unitStatus == 1 ? Alarm.success : Alarm.danger;

        int temperatureStatus = rawData[128];
        alarmTServerity = temperatureStatus == 1 ? Alarm.danger : Alarm.success;

        int powerStatus = rawData[129];
        alarmPServerity = powerStatus == 1 ? Alarm.danger : Alarm.success;

        if (!completer.isCompleted) {
          completer.complete((
            alarmUSeverity.name,
            alarmTServerity.name,
            alarmPServerity.name,
          ));
        }

        break;
      case 300:
        if (!completer.isCompleted) {
          bool result = _parseSettingResult(rawData);
          completer.complete(result);
        }
        break;
      case 301:
        if (!completer.isCompleted) {
          bool result = _parseSettingResult(rawData);
          completer.complete(result);
        }
        break;
      case 302:
        if (!completer.isCompleted) {
          bool result = _parseSettingResult(rawData);
          completer.complete(result);
        }
        break;
      case 303:
        if (!completer.isCompleted) {
          bool result = _parseSettingResult(rawData);
          completer.complete(result);
        }
        break;
      default:
        break;
    }
  }

  bool _parseSettingResult(List<int> rawData) {
    if (rawData ==
        [
          0xB0,
          0x10,
          0x00,
          0x00,
          0x00,
          0x01,
          0x1A,
          0x28,
        ]) {
      return false;
    } else if (rawData ==
        [
          0xB0,
          0x10,
          0x00,
          0x00,
          0x00,
          0x02,
          0x5A,
          0x29,
        ]) {
      return false;
    } else if (rawData ==
        [
          0xB0,
          0x10,
          0x00,
          0x90,
          0x00,
          0x03,
          0x9B,
          0xE9,
        ]) {
      return false;
    } else {
      return true;
    }
  }

  double _convertToFahrenheit(double celcius) {
    double fahrenheit = (celcius * 1.8) + 32;
    return fahrenheit;
  }

  void calculate18CRCs() {
    CRC16.calculateCRC16(command: Command18.req00Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.req01Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.req02Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqLog00Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqLog01Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqLog02Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqLog03Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqLog04Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqLog05Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqLog06Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqLog07Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqLog08Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqLog09Cmd, usDataLength: 6);

    _command18Collection.add(Command18.req00Cmd);
    _command18Collection.add(Command18.req01Cmd);
    _command18Collection.add(Command18.req02Cmd);
    _command18Collection.add(Command18.reqLog00Cmd);
    _command18Collection.add(Command18.reqLog01Cmd);
    _command18Collection.add(Command18.reqLog02Cmd);
    _command18Collection.add(Command18.reqLog03Cmd);
    _command18Collection.add(Command18.reqLog04Cmd);
    _command18Collection.add(Command18.reqLog05Cmd);
    _command18Collection.add(Command18.reqLog06Cmd);
    _command18Collection.add(Command18.reqLog07Cmd);
    _command18Collection.add(Command18.reqLog08Cmd);
    _command18Collection.add(Command18.reqLog09Cmd);
  }
}
