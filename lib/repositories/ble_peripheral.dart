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

class Perigheral {
  const Perigheral({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;
}

class ScanReport {
  const ScanReport({
    required this.scanStatus,
    this.perigheral,
  });

  final ScanStatus scanStatus;
  final Perigheral? perigheral;
}

class ConnectionReport {
  const ConnectionReport({
    required this.connectStatus,
    this.errorMessage = '',
  });

  final ConnectStatus connectStatus;
  final String errorMessage;
}
