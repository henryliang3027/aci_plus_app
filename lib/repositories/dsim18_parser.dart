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
        for (int i = 3; i <= 22; i++) {
          partName += String.fromCharCode(rawData[i]);
        }
        partName = partName.trim();

        for (int i = 23; i <= 42; i++) {
          partNo += String.fromCharCode(rawData[i]);
        }
        partNo = partNo.trim();

        for (int i = 43; i <= 62; i++) {
          serialNumber += String.fromCharCode(rawData[i]);
        }
        serialNumber = serialNumber.trim();

        for (int i = 63; i <= 66; i++) {
          firmwareVersion += String.fromCharCode(rawData[i]);
        }
        firmwareVersion = firmwareVersion.trim();

        // Stopwatch stopwatch = Stopwatch();
        // stopwatch.start();
        List<int> rawYear = rawData.sublist(67, 69);
        ByteData byteData = ByteData.sublistView(Uint8List.fromList(rawYear));
        String year = byteData.getInt16(0, Endian.little).toString();
        String month = rawData[69].toString().padLeft(2, '0');
        String day = rawData[70].toString().padLeft(2, '0');

        mfgDate = '$year/$month/$day';

        // stopwatch.stop();
        // print('Time elapsed1: ${stopwatch.elapsedMicroseconds}');

        // stopwatch.start();

        // int year1 = rawData[67] + rawData[68] * 256;

        // stopwatch.stop();
        // print('Time elapsed2: ${stopwatch.elapsedMicroseconds}');

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
      default:
        break;
    }
  }

  void calculate18CRCs() {
    CRC16.calculateCRC16(command: Command18.req00Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.req01Cmd, usDataLength: 6);

    _command18Collection.add(Command18.req00Cmd);
    _command18Collection.add(Command18.req01Cmd);
  }
}
