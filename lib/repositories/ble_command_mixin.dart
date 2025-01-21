import 'dart:typed_data';
import 'package:aci_plus_app/core/crc16_calculate.dart';
import 'package:aci_plus_app/repositories/ble_client_base.dart';

mixin BLECommandsMixin {
  // Define an abstract getter for the BLE client.
  BLEClientBase get bleClient;

  // [factor]: 如果是浮點數則 factor = 10, 乘以十倍再帶入 command, 如果是整數則 factor = 1
  Future<dynamic> set1p8GTwoBytesParameter({
    required int commandIndex,
    required String value,
    required List<int> command,
    double factor = 10,
  }) async {
    print('get data from request command 1p8G$commandIndex');

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
        commandIndex: commandIndex,
        value: command,
      );
      return true;
    } catch (e) {
      print('Error in command $commandIndex: $e');
      return false;
    }
  }

  Future<bool> set1p8GOneByteParameter({
    required int commandIndex,
    required List<int> command,
    required String value,
  }) async {
    print('get data from request command 1p8G$commandIndex');

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
        commandIndex: commandIndex,
        value: command,
      );
      return true;
    } catch (e) {
      print('Error while sending command $commandIndex: $e');
      return false;
    }
  }
}
