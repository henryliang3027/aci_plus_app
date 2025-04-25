import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:usb_serial/usb_serial.dart';

enum ScanStatus {
  scanning,
  complete,
  disable,
  failure,
}

enum ConnectStatus {
  connecting,
  connected,
  disconnecting,
  disconnected,
}

class Peripheral {
  const Peripheral({
    required this.id,
    required this.name,
    this.rssi = 0,
    this.usbDevice,
  });

  const Peripheral.empty()
      : id = '',
        name = '',
        rssi = 0,
        usbDevice = null;

  final String id;
  final String name;
  final int rssi;
  final UsbDevice? usbDevice;
}

class ScanReport {
  const ScanReport({
    required this.scanStatus,
    this.peripheral,
  });

  final ScanStatus scanStatus;
  final Peripheral? peripheral;
}

class ConnectionReport {
  const ConnectionReport({
    required this.connectStatus,
    this.errorMessage = '',
  });

  final ConnectStatus connectStatus;
  final String errorMessage;
}
