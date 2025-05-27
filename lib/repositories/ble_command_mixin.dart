import 'dart:typed_data';
import 'package:aci_plus_app/core/crc16_calculate.dart';
import 'package:aci_plus_app/repositories/connection_client.dart';

mixin BLECommandsMixin {
  // Define an abstract getter for the BLE client.
  ConnectionClient get bleClient;

  // [factor]: 如果是浮點數則 factor = 10, 乘以十倍再帶入 command, 如果是整數則 factor = 1
  Future<dynamic> set1p8GTwoBytesParameter({
    required String value,
    required List<int> command,
    double factor = 10,
  }) async {
    print('set command 1p8G 300');

    double dVal = double.parse(value);
    int scaledValue = (dVal * factor).toInt();

    // Convert the integer to 2 bytes in little-endian format.
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, scaledValue, Endian.little);
    Uint8List bytes = Uint8List.view(byteData.buffer);

    command[7] = bytes[0];
    command[8] = bytes[1];

    // Calculate CRC16.
    CRC16.calculateCRC16(
      command: command,
      usDataLength: command.length - 2,
    );

    try {
      await bleClient.writeSetCommandToCharacteristic(
        commandIndex: 300,
        value: command,
      );
      return true;
    } catch (e) {
      print('Error in command 300: $e');
      return false;
    }
  }

  Future<bool> set1p8GOneByteParameter({
    required List<int> command,
    required String value,
  }) async {
    print('set command 1p8G 300');

    // Parse the ingress value
    int intValue = int.parse(value);

    // Update the command array at the proper index
    command[7] = intValue;

    // Calculate the CRC16 for the command array.
    // (Assuming the length is always command.length - 2)
    CRC16.calculateCRC16(
      command: command,
      usDataLength: command.length - 2,
    );

    try {
      await bleClient.writeSetCommandToCharacteristic(
        commandIndex: 300,
        value: command,
      );
      return true;
    } catch (e) {
      print('Error while sending command 300: $e');
      return false;
    }
  }

  Future<bool> set1p8GLocationParameter({
    required String location,
    required List<int> command,
  }) async {
    print('set command 1p8GLocation');

    List<int> locationBytes = [];

    print('get data from request command 1p8G Location');

    for (int code in location.codeUnits) {
      // Create a ByteData object with a length of 2 bytes
      ByteData byteData = ByteData(2);

      // Set the Unicode code unit in the byte array
      byteData.setInt16(0, code, Endian.little);

      // Convert the ByteData to a Uint8List
      Uint8List bytes = Uint8List.view(byteData.buffer);

      locationBytes.addAll(bytes);
    }

    for (int i = 0; i < locationBytes.length; i++) {
      command[i + 7] = locationBytes[i];
    }

    // 填入空白
    for (int i = locationBytes.length; i < 96; i += 2) {
      command[i + 7] = 0x20;
      command[i + 8] = 0x00;
    }

    CRC16.calculateCRC16(
      command: command,
      usDataLength: command.length - 2,
    );

    try {
      await bleClient.writeSetCommandToCharacteristic(
        commandIndex: 300,
        value: command,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> set1p8GCoordinatesParameter({
    required String coordinates,
    required List<int> command,
  }) async {
    List<int> coordinatesBytes = [];

    print('get data from request command 1p8G Coordinate');

    coordinatesBytes = coordinates.codeUnits;

    for (int i = 0; i < coordinatesBytes.length; i++) {
      command[i + 7] = coordinatesBytes[i];
    }

    for (int i = coordinatesBytes.length; i < 39; i++) {
      command[i + 7] = 0x20;
    }

    CRC16.calculateCRC16(
      command: command,
      usDataLength: command.length - 2,
    );

    try {
      await bleClient.writeSetCommandToCharacteristic(
        commandIndex: 300,
        value: command,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> set1p8GNowDateTimeParameter({
    required String nowDateTime,
    required List<int> command,
  }) async {
    print('get data from request command 1p8G NowDateTime');

    DateTime dateTime = DateTime.now();

    int year = dateTime.year;

    // Convert the integer to bytes
    ByteData yearByteData = ByteData(2);
    yearByteData.setInt16(0, year, Endian.little); // little endian
    Uint8List yearBytes = Uint8List.view(yearByteData.buffer);

    int month = dateTime.month;
    int day = dateTime.day;
    int hour = dateTime.hour;
    int minute = dateTime.minute;

    command[7] = yearBytes[0];
    command[8] = yearBytes[1];
    command[9] = month;
    command[10] = day;
    command[11] = hour;
    command[12] = minute;

    CRC16.calculateCRC16(
      command: command,
      usDataLength: command.length - 2,
    );

    try {
      await bleClient.writeSetCommandToCharacteristic(
        commandIndex: 300,
        value: command,
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
