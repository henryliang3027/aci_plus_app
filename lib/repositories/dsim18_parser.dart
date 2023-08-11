import 'dart:async';
import 'dart:typed_data';

import 'package:dsim_app/core/command18.dart';
import 'package:dsim_app/core/crc16_calculate.dart';

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
        maxTemperatureC = maxTemperature.toString();
        maxTemperatureF = _convertToFahrenheit(maxTemperature).toString();

        // 解析 minTemperatureC, minTemperatureF
        List<int> rawMinTemperatureC = rawData.sublist(5, 7);
        ByteData rawMinTemperatureCByteData =
            ByteData.sublistView(Uint8List.fromList(rawMinTemperatureC));

        double minTemperature =
            rawMinTemperatureCByteData.getInt16(0, Endian.little) / 10;
        minTemperatureC = minTemperature.toString();
        minTemperatureF = _convertToFahrenheit(minTemperature).toString();

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

      default:
        break;
    }
  }

  double _convertToFahrenheit(double celcius) {
    double fahrenheit = (celcius * 1.8) + 32;
    return fahrenheit;
  }

  void calculate18CRCs() {
    CRC16.calculateCRC16(command: Command18.req00Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.req01Cmd, usDataLength: 6);

    _command18Collection.add(Command18.req00Cmd);
    _command18Collection.add(Command18.req01Cmd);
  }
}
