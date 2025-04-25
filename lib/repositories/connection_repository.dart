import 'dart:async';
import 'package:usb_serial/usb_serial.dart';

class ConnectionRepository {
  ConnectionRepository();

  // 檢查是否有連接 usb
  Future<bool> checkUsbConnection() async {
    List<UsbDevice> devices = await UsbSerial.listDevices();
    return devices.isNotEmpty ? true : false;
  }

  // 取得 usb device
  Future<UsbDevice> getUsbDevice() async {
    List<UsbDevice> devices = await UsbSerial.listDevices();

    return devices.first;
  }
}
