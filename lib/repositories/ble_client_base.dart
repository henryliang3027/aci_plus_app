import 'dart:async';

import 'package:aci_plus_app/repositories/ble_peripheral.dart';

abstract class BLEClientBase {
  final int scanTimeout = 3; // seconds
  final int connectionTimeout = 30; // seconds
  late StreamController<ScanReport> scanReportStreamController;
  StreamController<ConnectionReport> connectionReportStreamController =
      StreamController<ConnectionReport>();

  Completer<dynamic>? completer;

  int currentCommandIndex = 0;

  Timer? characteristicDataTimer;
  Timer? connectionTimer;

  final List<int> combinedRawData = [];
  final int totalBytesPerCommand = 261;

  BLEClientBase() {
    initialize();
  }

  void initialize();

  Future<bool> checkBluetoothEnabled();

  Stream<ScanReport> get scanReport;

  Future<void> connectToDevice();

  Stream<ConnectionReport> get connectionStateReport async* {
    yield* connectionReportStreamController.stream;
  }

  Future<void> closeScanStream();

  Future<void> closeConnectionStream();

  bool checkCRC(List<int> rawData);

  Future<dynamic> _requestBasicInformationRawData(List<int> value);

  Future<dynamic> getACIDeviceType({
    required int commandIndex,
    required List<int> value,
    required String deviceId,
    int mtu = 247,
  });

  Future writeSetCommandToCharacteristic({
    required int commandIndex,
    required List<int> value,
    Duration timeout = const Duration(seconds: 10),
  });

  void startConnectionTimer(String deviceAddress);

  void cancelConnectionTimer();

  void startCharacteristicDataTimer({
    required Duration timeout,
    required int commandIndex,
  });

  void cancelCharacteristicDataTimer({required String name});

  void cancelCompleterOnDisconnected();

  Future<bool> _requestPermission();
}
