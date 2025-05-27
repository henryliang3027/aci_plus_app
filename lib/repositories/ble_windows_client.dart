import 'dart:async';
import 'package:aci_plus_app/repositories/connection_client.dart';
import 'package:aci_plus_app/repositories/ble_peripheral.dart';
import 'package:aci_plus_app/core/common_enum.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_ble/universal_ble.dart';

class BLEWindowsClient extends ConnectionClient {
  BLEWindowsClient() : super();

  // static final BLEWindowsClient _instance = BLEWindowsClient._();

  // static BLEWindowsClient get instance => _instance;

  final _scanTimeout = 15; // sec
  final _connectionTimeout = 30; //sec
  late StreamController<ScanReport> _scanReportStreamController;
  StreamController<ConnectionReport> _connectionReportStreamController =
      StreamController<ConnectionReport>();

  late StreamController<String> _updateReportStreamController;

  StreamSubscription<BleDevice>? _discoveredDeviceStreamSubscription;
  StreamSubscription<bool>? _connectionStreamSubscription;
  StreamSubscription<dynamic>? _characteristicStreamSubscription;
  Peripheral? _peripheral;

  final _aciPrefix = 'ACI';
  final _serviceId = '0000ffe0-0000-1000-8000-00805f9b34fb';
  final _characteristicId = '0000ffe1-0000-1000-8000-00805f9b34fb';

  Completer<dynamic>? _completer;

  int _currentCommandIndex = 0;

  Timer? _characteristicDataTimer;
  Timer? _connectionTimer;
  Timer? _scanTimer;
  ACIDeviceType _aciDeviceType = ACIDeviceType.undefined;
  bool _connectionState = false;
  int _numberOfReconnect = 1;
  final int _maxReconnectTimes = 3;

  // final List<int> _combinedRawData = [];
  // final int _totalBytesPerCommand = 261;

  // 1p8G variables
  // List<int> _rawRFInOut = [];

  @override
  Stream<String> get updateReport async* {
    _updateReportStreamController = StreamController<String>();
    Stream<String> streamWithTimeout =
        _updateReportStreamController.stream.timeout(
      const Duration(seconds: 20),
      onTimeout: (sink) {
        sink.addError('Timeout occurred');
      },
    );

    yield* streamWithTimeout;
  }

  // Future<void> initialize() async {
  //   await WinBle.initialize(
  //     serverPath: await WinServer.path(),
  //     enableLog: true,
  //   );
  //   print("WinBle Initialized: ${await WinBle.version()}");
  // }

  void _handleBluetoothAvailability(AvailabilityState availabilityState) async {
    if (availabilityState == AvailabilityState.poweredOff) {
      _connectionReportStreamController.add(const ConnectionReport(
        connectStatus: ConnectStatus.disconnected,
        errorMessage: 'Device connection failed',
      ));

      await closeConnectionStream();
    }
  }

  Future<void> enableBluetooth() async {
    AvailabilityState availabilityState =
        await UniversalBle.getBluetoothAvailabilityState();

    if (availabilityState == AvailabilityState.poweredOff) {
      // 啟用藍芽
      UniversalBle.enableBluetooth();
    }

    UniversalBle.onAvailabilityChange = _handleBluetoothAvailability;
  }

  @override
  Future<int> getRSSI() async {
    return _peripheral!.rssi;
  }

  void _handleScanResult(BleDevice device) {
    String deviceName = device.name ?? '';

    if (deviceName.startsWith(_aciPrefix)) {
      if (!_scanReportStreamController.isClosed) {
        // scanTimer.cancel();
        // WinBle.stopScanning();
        print('Device: ${device.name} ${device.rssi}');

        // _peripheral = Peripheral(
        //   id: device.address,
        //   name: device.name,
        // );

        _scanReportStreamController.add(
          ScanReport(
            scanStatus: ScanStatus.scanning,
            peripheral: Peripheral(
              id: device.deviceId,
              name: deviceName,
              rssi: device.rssi ?? 0,
            ),
          ),
        );
      }
    }
  }

  @override
  Stream<ScanReport> get scanReport async* {
    _scanReportStreamController = StreamController<ScanReport>();
    await enableBluetooth();
    startScanTimer();
    UniversalBle.startScan();
    UniversalBle.onScanResult = _handleScanResult;

    yield* _scanReportStreamController.stream;
  }

  void _handleValueChange(
      String deviceId, String characteristicId, Uint8List data) {
    List<int> rawData = data;
    print('cmd $_currentCommandIndex, received_data: $data');

    List<dynamic> finalResult = combineRawData(
      commandIndex: _currentCommandIndex,
      rawData: rawData,
    );

    if (_currentCommandIndex >= 1000) {
      List<int> finalRawData = finalResult[1];
      String message = String.fromCharCodes(finalRawData);
      _updateReportStreamController.add(message);
    } else {
      if (finalResult[0]) {
        cancelCharacteristicDataTimer(name: 'cmd $_currentCommandIndex');
        List<int> finalRawData = finalResult[1];

        bool isValidCRC = checkCRC(finalRawData);
        if (isValidCRC) {
          if (!_completer!.isCompleted) {
            _completer!.complete(finalRawData);
          }
        } else {
          if (!_completer!.isCompleted) {
            _completer!.completeError(CharacteristicError.invalidData);
          }
        }
      }
    }
  }

  Future<void> _handleConnectionChange(
      String deviceId, bool isConnected) async {
    print('_handleConnectionChange $deviceId, $isConnected');

    switch (isConnected) {
      case true:
        _connectionState = true;
        cancelConnectionTimer();
        UniversalBle.setNotifiable(
          deviceId,
          _serviceId,
          _characteristicId,
          BleInputProperty.notification,
        );

        UniversalBle.onValueChange = _handleValueChange;

        _connectionReportStreamController.add(const ConnectionReport(
          connectStatus: ConnectStatus.connected,
        ));

        break;
      case false:
        if (_connectionState) {
          _connectionReportStreamController.add(const ConnectionReport(
            connectStatus: ConnectStatus.disconnected,
            errorMessage: 'Device connection failed',
          ));

          await closeConnectionStream();
        } else {
          if (_peripheral != null) {
            if (_numberOfReconnect <= _maxReconnectTimes) {
              UniversalBle.connect(_peripheral!.id);
              _numberOfReconnect += 1;
            } else {
              _connectionReportStreamController.add(const ConnectionReport(
                connectStatus: ConnectStatus.disconnected,
                errorMessage: 'Device connection failed',
              ));

              await closeConnectionStream();
            }
          }
        }

        break;
    }
  }

  @override
  Future<void> connectToDevice(Peripheral peripheral) async {
    _peripheral = peripheral;
    startConnectionTimer(_peripheral!.id);
    _connectionReportStreamController = StreamController<ConnectionReport>();
    UniversalBle.onConnectionChange = _handleConnectionChange;
    UniversalBle.connect(_peripheral!.id);
  }

  @override
  Stream<ConnectionReport> get connectionStateReport async* {
    yield* _connectionReportStreamController.stream;
  }

  @override
  Future<void> closeScanStream() async {
    print('closeScanStream');

    cancelScanTimer();

    if (!_scanReportStreamController.isClosed) {
      await _scanReportStreamController.close();
    }

    await _discoveredDeviceStreamSubscription?.cancel();
    _discoveredDeviceStreamSubscription = null;

    UniversalBle.stopScan();
  }

  @override
  Future<void> closeConnectionStream() async {
    print('close _characteristicStreamSubscription');
    _connectionState = false;
    _numberOfReconnect = 1;

    if (_peripheral != null) {
      UniversalBle.disconnect(_peripheral!.id);
      _peripheral = null;
    }

    cancelCompleterOnDisconnected();
    cancelConnectionTimer();
    cancelCharacteristicDataTimer(name: 'connection closed');

    if (_connectionReportStreamController.hasListener) {
      if (!_connectionReportStreamController.isClosed) {
        await _connectionReportStreamController.close();
      }
    }

    await _characteristicStreamSubscription?.cancel();
    _characteristicStreamSubscription = null;

    // add delay to solve the following exception on ios
    // Error unsubscribing from notifications:
    // PlatformException(reactive_ble_mobile.PluginError:7, The operation couldn’t be completed.
    // (reactive_ble_mobile.PluginError error 7.), {}, null)
    await Future.delayed(const Duration(milliseconds: 500));

    print('close _connectionStreamSubscription');
    await _connectionStreamSubscription?.cancel();
    await Future.delayed(const Duration(milliseconds: 2000));
    _connectionStreamSubscription = null;
    _aciDeviceType = ACIDeviceType.undefined;
    clearCombinedRawData();
  }

  // 透過 1G/1.2G/1.8G 同樣的基本指令, 來取得回傳資料的長度
  Future<dynamic> _requestBasicInformationRawData(List<int> value) async {
    _currentCommandIndex = -1;

    print('get data from request command 0');

    try {
      List<int> rawData = await writeSetCommandToCharacteristic(
        commandIndex: 0,
        value: value,
        timeout: const Duration(seconds: 10),
      );
      return [true, rawData];
    } catch (e) {
      return [
        false,
      ];
    }
  }

  @override
  Future<dynamic> getACIDeviceType({
    required int commandIndex,
    required List<int> value,
    required String deviceId,
    int mtu = 244,
  }) async {
    _currentCommandIndex = commandIndex;
    final maxMtu = await UniversalBle.requestMtu(deviceId, mtu);
    print('Max MTU: $maxMtu');

    // 設定 mtu = 247
    List<dynamic> result = await _requestBasicInformationRawData(value);

    if (result[0]) {
      List<int> rawData = result[1];
      int length = rawData.length;
      if (length == 17) {
        // 1G/1.2G data length = 17
        _aciDeviceType = ACIDeviceType.dsim1G1P2G;
        return [
          true,
          ACIDeviceType.dsim1G1P2G,
        ];
      } else {
        // 1.8G data length = 181
        int partId = rawData[71];
        if (partId == 4) {
          _aciDeviceType = ACIDeviceType.ampCCorNode1P8G;
          return [
            true,
            ACIDeviceType.ampCCorNode1P8G,
          ];
        } else {
          _aciDeviceType = ACIDeviceType.amp1P8G;
          return [
            true,
            ACIDeviceType.amp1P8G,
          ];
        }
      }
    } else {
      return [
        false,
      ];
    }
  }

  // iOS 跟 Android 的 set command 方式不一樣
  @override
  Future writeSetCommandToCharacteristic({
    required int commandIndex,
    required List<int> value,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    _currentCommandIndex = commandIndex;
    print('write cmd $commandIndex, $_currentCommandIndex');

    _completer = Completer<dynamic>();

    startCharacteristicDataTimer(
      timeout: timeout,
    );

    Future.microtask(() async {
      try {
        if (_aciDeviceType == ACIDeviceType.undefined ||
            _aciDeviceType == ACIDeviceType.dsim1G1P2G) {
          await UniversalBle.writeValue(
            _peripheral!.id,
            _serviceId,
            _characteristicId,
            Uint8List.fromList(value),
            BleOutputProperty.withoutResponse,
          );
        } else {
          await UniversalBle.writeValue(
            _peripheral!.id,
            _serviceId,
            _characteristicId,
            Uint8List.fromList(value),
            BleOutputProperty.withResponse,
          );
        }
      } catch (e) {
        cancelCharacteristicDataTimer(
            name:
                'cmd $commandIndex, ${CharacteristicError.writeDataError.name}');

        if (!_completer!.isCompleted) {
          print('writeCharacteristic failed: ${e.toString()}');
          _completer!.completeError(CharacteristicError.writeDataError.name);
        }
      }
    });

    return _completer!.future;
  }

  // iOS 跟 Android 的 set command 方式不一樣
  @override
  Future writeLongSetCommandToCharacteristic({
    required int commandIndex,
    required List<List<int>> chunks,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    _currentCommandIndex = commandIndex;
    print('write cmd $commandIndex, $_currentCommandIndex');

    _completer = Completer<dynamic>();

    startCharacteristicDataTimer(
      timeout: timeout,
    );

    Future.microtask(() async {
      for (int i = 0; i < chunks.length; i++) {
        try {
          await UniversalBle.writeValue(
            _peripheral!.id,
            _serviceId,
            _characteristicId,
            Uint8List.fromList(chunks[i]),
            BleOutputProperty.withResponse,
          );
        } catch (e) {
          cancelCharacteristicDataTimer(
              name:
                  'cmd $commandIndex, ${CharacteristicError.writeDataError.name}');

          if (!_completer!.isCompleted) {
            print('writeCharacteristic failed: ${e.toString()}');
            _completer!.completeError(CharacteristicError.writeDataError.name);
          }
        }
      }
    });

    return _completer!.future;
  }

  @override
  Future<void> transferBinaryChunk({
    required int commandIndex,
    required List<int> chunk,
    required int indexOfChunk,
  }) async {
    _currentCommandIndex = commandIndex;

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      await UniversalBle.writeValue(
        _peripheral!.id,
        _serviceId,
        _characteristicId,
        Uint8List.fromList(chunk),
        BleOutputProperty.withResponse,
      );

      // withResponse 下傳送binary chunk, device 作為接收端還是會漏收, 所以多 delay 一些時間確保有收到
      await Future.delayed(Duration(milliseconds: 50));

      _updateReportStreamController.add('Sent $indexOfChunk');
      print(
          'transferBinaryChunk executed in ${stopwatch.elapsed.inMilliseconds}');
    } catch (e) {
      _updateReportStreamController.addError('Sending the chunk error');
    }
  }

  @override
  Future<void> transferFirmwareCommand({
    required int commandIndex,
    required List<int> command,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    _currentCommandIndex = commandIndex;

    try {
      await UniversalBle.writeValue(
        _peripheral!.id,
        _serviceId,
        _characteristicId,
        Uint8List.fromList(command),
        BleOutputProperty.withResponse,
      );
    } catch (e) {
      _updateReportStreamController.addError('write data error');
    }
  }

  void startScanTimer() {
    // 設定 scan timeout
    _scanTimer = Timer(Duration(seconds: _scanTimeout), () async {
      _scanReportStreamController.add(
        ScanReport(
          scanStatus: ScanStatus.complete,
          peripheral: _peripheral,
        ),
      );

      await closeScanStream();
    });
  }

  void cancelScanTimer() {
    if (_scanTimer != null) {
      _scanTimer!.cancel();
    }
  }

  void startConnectionTimer(String deviceAddress) {
    _connectionTimer = Timer(Duration(seconds: _connectionTimeout), () async {
      _connectionReportStreamController.add(const ConnectionReport(
        connectStatus: ConnectStatus.disconnected,
        errorMessage: 'Device connection failed',
      ));

      await closeScanStream();
      await closeConnectionStream();
    });
  }

  void cancelConnectionTimer() {
    if (_connectionTimer != null) {
      _connectionTimer!.cancel();
    }
  }

  void startCharacteristicDataTimer({
    required Duration timeout,
  }) {
    print("timeout: ${timeout.inSeconds}");

    _characteristicDataTimer = Timer(timeout, () {
      if (!_completer!.isCompleted) {
        _completer!.completeError(CharacteristicError.timeoutOccured);
        print('cmd:$_currentCommandIndex Timeout occurred');
      }
    });
  }

  @override
  void cancelCharacteristicDataTimer({required String name}) {
    if (_characteristicDataTimer != null) {
      _characteristicDataTimer!.cancel();
      print('$name CharacteristicDataTimer has been canceled');
    }
  }

  void cancelCompleterOnDisconnected() {
    if (_completer != null) {
      if (!_completer!.isCompleted) {
        _completer!.completeError(false);
      }
    }
  }
}
