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
  });

  const Peripheral.empty()
      : id = '',
        name = '',
        rssi = 0;

  final String id;
  final String name;
  final int rssi;
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
