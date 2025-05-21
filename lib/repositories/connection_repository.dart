import 'dart:async';
import 'package:aci_plus_app/repositories/ble_factory.dart';
import 'package:aci_plus_app/repositories/usb_client.dart';
import 'package:ftdi_serial/serial_device.dart';

enum ConnectionType {
  ble,
  usb,
}

class ConnectionRepository {
  ConnectionRepository();

  // 檢查是否有連接 usb
  Future<ConnectionType> checkConnectionType() async {
    final client = BLEClientFactory.instance;

    return client is USBClient ? ConnectionType.usb : ConnectionType.ble;
  }

  // 取得 usb device
  Future<SerialDevice> getUsbDevice() async {
    SerialDevice serialDevice = await USBClient.getAttachedDevice();

    return serialDevice;
  }
}
