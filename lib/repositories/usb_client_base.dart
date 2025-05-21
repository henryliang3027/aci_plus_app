abstract class UsbClientBase {
  Future<bool> connectToDevice();

  Future<dynamic> writeSetCommandToCharacteristic({
    required int commandIndex,
    required List<int> value,
    Duration timeout = const Duration(seconds: 10),
  });
}
