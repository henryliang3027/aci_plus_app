import 'package:aci_plus_app/core/command.dart';
import 'package:aci_plus_app/core/crc16_calculate.dart';
import 'package:aci_plus_app/repositories/connection_client.dart';
import 'package:aci_plus_app/repositories/connection_client_factory.dart';
import 'package:aci_plus_app/repositories/ble_peripheral.dart';
import 'package:aci_plus_app/repositories/usb_client.dart';
import 'package:ftdi_serial/serial_device.dart';

class ACIDeviceRepository {
  ACIDeviceRepository() : _connectionClient = ConnectionClientFactory.instance;

  ConnectionClient _connectionClient;

  void updateClient() {
    _connectionClient = ConnectionClientFactory.instance;
  }

  // 檢查是否有連接 usb
  ConnectionType checkConnectionType() {
    final client = ConnectionClientFactory.instance;

    return client is USBClient ? ConnectionType.usb : ConnectionType.ble;
  }

  // 取得 usb device
  Future<SerialDevice> getUsbDevice() async {
    SerialDevice serialDevice = await USBClient.getAttachedDevice();

    return serialDevice;
  }

  Stream<ScanReport> get scanReport async* {
    yield* _connectionClient.scanReport;
  }

  Stream<ConnectionReport> get connectionStateReport async* {
    yield* _connectionClient.connectionStateReport;
  }

  Future<void> connectToDevice(Peripheral peripheral) {
    return _connectionClient.connectToDevice(peripheral);
  }

  Future<void> closeScanStream() async {
    await _connectionClient.closeScanStream();
  }

  Future<void> closeConnectionStream() async {
    await _connectionClient.closeConnectionStream();
  }

  Future<dynamic> getACIDeviceType({
    required String deviceId,
  }) async {
    CRC16.calculateCRC16(command: Command.req00Cmd, usDataLength: 6);

    return _connectionClient.getACIDeviceType(
      commandIndex: 80,
      value: Command.req00Cmd,
      deviceId: deviceId,
    );
  }
}
