enum ScanStatus {
  success,
  failure,
  disable,
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
  });

  final String id;
  final String name;
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
