import 'dart:async';
import 'dart:io';

import 'package:aci_plus_app/repositories/connection_client.dart';
import 'package:aci_plus_app/repositories/ble_peripheral.dart';
import 'package:aci_plus_app/core/common_enum.dart';
import 'package:bluetooth_enable/bluetooth_enable.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

class BLEClient extends ConnectionClient {
  BLEClient()
      : _ble = FlutterReactiveBle(),
        super();

  FlutterReactiveBle? _ble;
  final _scanTimeout = 15; // sec
  final _connectionTimeout = 30; //sec
  late StreamController<ScanReport> _scanReportStreamController;
  StreamController<ConnectionReport> _connectionReportStreamController =
      StreamController<ConnectionReport>();

  late StreamController<String> _updateReportStreamController;

  StreamSubscription<DiscoveredDevice>? _discoveredDeviceStreamSubscription;
  StreamSubscription<ConnectionStateUpdate>? _connectionStreamSubscription;
  StreamSubscription<List<int>>? _characteristicStreamSubscription;
  late QualifiedCharacteristic _qualifiedCharacteristic;
  Peripheral? _peripheral;

  final _aciPrefix = 'ACI';
  final _serviceId = 'ffe0';
  final _characteristicId = 'ffe1';

  Completer<dynamic>? _completer;

  int _currentCommandIndex = 0;

  Timer? _characteristicDataTimer;
  Timer? _connectionTimer;
  Timer? _scanTimer;
  ACIDeviceType _aciDeviceType = ACIDeviceType.undefined;

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

  Future<bool> checkBluetoothEnabled() async {
    // 要求定位與藍芽存取權
    bool isPermissionGranted = await _requestPermission();

    if (isPermissionGranted) {
      // 偵測藍芽是否有打開, 如果沒有打開會跳出提示訊息
      String resultStrOfEnableBluetooth = await BluetoothEnable.enableBluetooth;
      bool resultOfEnableBluetooth =
          resultStrOfEnableBluetooth == 'true' ? true : false;

      if (resultOfEnableBluetooth) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  Future<int> getRSSI() {
    return _ble!.readRssi(_qualifiedCharacteristic.deviceId);
  }

  @override
  Stream<ScanReport> get scanReport async* {
    _ble ??= FlutterReactiveBle();
    _scanReportStreamController = StreamController<ScanReport>();

    bool isPermissionGranted = await checkBluetoothEnabled();

    if (isPermissionGranted) {
      startScanTimer();

      _discoveredDeviceStreamSubscription =
          _ble!.scanForDevices(withServices: []).listen((device) {
        if (device.name.startsWith(_aciPrefix)) {
          if (!_scanReportStreamController.isClosed) {
            // scanTimer.cancel();
            print('Device: ${device.name}, ${device.rssi}');

            // _peripheral = Peripheral(
            //   id: device.id,
            //   name: device.name,
            //   rssi: device.rssi,
            // );

            _scanReportStreamController.add(
              ScanReport(
                scanStatus: ScanStatus.scanning,
                peripheral: Peripheral(
                  id: device.id,
                  name: device.name,
                  rssi: device.rssi,
                ),
              ),
            );
          }
        }
      }, onError: (error) {
        print('Scan Error $error');
        _scanReportStreamController.add(
          const ScanReport(
            scanStatus: ScanStatus.failure,
            peripheral: null,
          ),
        );
      });
    } else {
      print('bluetooth disable');
      _scanReportStreamController.add(
        const ScanReport(
          scanStatus: ScanStatus.disable,
          peripheral: null,
        ),
      );
    }

    yield* _scanReportStreamController.stream;
  }

  @override
  Future<void> connectToDevice(Peripheral peripheral) async {
    _peripheral = peripheral;
    startConnectionTimer();

    _connectionReportStreamController = StreamController<ConnectionReport>();
    _connectionStreamSubscription = _ble!
        .connectToDevice(
      id: _peripheral!.id,
    )
        .listen((connectionStateUpdate) async {
      print('current connection state: $connectionStateUpdate');
      switch (connectionStateUpdate.connectionState) {
        case DeviceConnectionState.connecting:
          break;
        case DeviceConnectionState.connected:
          cancelConnectionTimer();

          // _characteristicDataStreamController =
          //     StreamController<Map<DataKey, String>>();

          _qualifiedCharacteristic = QualifiedCharacteristic(
            serviceId: Uuid.parse(_serviceId),
            characteristicId: Uuid.parse(_characteristicId),
            deviceId: _peripheral!.id,
          );

          _characteristicStreamSubscription = _ble!
              .subscribeToCharacteristic(_qualifiedCharacteristic)
              .listen((data) async {
            // print('index: $_currentCommandIndex, length:${data.length}');

            List<dynamic> finalResult = combineRawData(
              commandIndex: _currentCommandIndex,
              rawData: data,
            );

            if (_currentCommandIndex >= 1000) {
              List<int> finalRawData = finalResult[1];
              String message = String.fromCharCodes(finalRawData);
              _updateReportStreamController.add(message);
            } else {
              if (finalResult[0]) {
                cancelCharacteristicDataTimer(
                    name: 'cmd $_currentCommandIndex');
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
          }, onError: (error) {
            _connectionReportStreamController.add(const ConnectionReport(
              connectStatus: ConnectStatus.disconnected,
              errorMessage: 'Device connection failed',
            ));
            print('lisetn to the characteristic failed');
          });

          _connectionReportStreamController.add(const ConnectionReport(
            connectStatus: ConnectStatus.connected,
          ));

          break;
        case DeviceConnectionState.disconnecting:
          // _connectionReportStreamController.add(const ConnectionReport(
          //   connectionState: DeviceConnectionState.disconnected,
          //   errorMessage: 'disconnecting',
          // ));
          // break;
          break;
        case DeviceConnectionState.disconnected:
          // cancelConnectionTimer();
          // cancelCharacteristicDataTimer(name: 'connection closed');
          // cancelCompleterOnDisconnected();

          _connectionReportStreamController.add(const ConnectionReport(
            connectStatus: ConnectStatus.disconnected,
            errorMessage: 'Device connection failed',
          ));

          await closeConnectionStream();

          break;
      }
    }, onError: (error) {
      // cancelConnectionTimer();
      // cancelCharacteristicDataTimer(name: 'connection closed');
      // cancelCompleterOnDisconnected();
      _connectionReportStreamController.add(ConnectionReport(
        connectStatus: ConnectStatus.disconnected,
        errorMessage: error.toString(),
      ));
    });
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
  }

  @override
  Future<void> closeConnectionStream() async {
    print('close _characteristicStreamSubscription');

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
    await Future.delayed(const Duration(milliseconds: 100));

    print('close _connectionStreamSubscription');
    await _connectionStreamSubscription?.cancel();
    await Future.delayed(const Duration(milliseconds: 2000));
    _connectionStreamSubscription = null;
    _ble = null;
    _aciDeviceType = ACIDeviceType.undefined;
    clearCombinedRawData();
    // _combinedRawData.clear();
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
    final negotiatedMtu = await _ble!.requestMtu(deviceId: deviceId, mtu: mtu);
    print('negotiatedMtu: $negotiatedMtu');

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
          _aciDeviceType,
        ];
      } else {
        // 1.8G data length = 181
        int partId = rawData[71];
        partId == 4
            ? _aciDeviceType = ACIDeviceType.ampCCorNode1P8G
            : _aciDeviceType = ACIDeviceType.amp1P8G;

        return [
          true,
          _aciDeviceType,
        ];
      }
    } else {
      return [false];
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

    _completer = Completer<dynamic>();

    startCharacteristicDataTimer(
      timeout: timeout,
      commandIndex: commandIndex,
    );

    Future.microtask(() async {
      try {
        if (_aciDeviceType == ACIDeviceType.undefined ||
            _aciDeviceType == ACIDeviceType.dsim1G1P2G) {
          // DSIM 的 藍牙 dongle 是 ＨＭ-10 藍牙模組, 沒有 ACK 機制
          await _ble!.writeCharacteristicWithoutResponse(
            _qualifiedCharacteristic,
            value: value,
          );
        } else {
          await _ble!.writeCharacteristicWithResponse(
            _qualifiedCharacteristic,
            value: value,
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

    _completer = Completer<dynamic>();

    startCharacteristicDataTimer(
      timeout: timeout,
      commandIndex: commandIndex,
    );

    Future.microtask(() async {
      for (int i = 0; i < chunks.length; i++) {
        try {
          await _ble!.writeCharacteristicWithResponse(
            _qualifiedCharacteristic,
            value: chunks[i],
          );
          print('$i sent');
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
    print('chink index: $indexOfChunk, length: ${chunk.length}');

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      await _ble!.writeCharacteristicWithResponse(
        _qualifiedCharacteristic,
        value: chunk,
      );

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
      if (Platform.isAndroid) {
        await _ble!.writeCharacteristicWithResponse(
          _qualifiedCharacteristic,
          value: command,
        );
      } else if (Platform.isIOS) {
        await _ble!.writeCharacteristicWithoutResponse(
          _qualifiedCharacteristic,
          value: command,
        );
      } else {}
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

  void startConnectionTimer() {
    _connectionTimer = Timer(Duration(seconds: _connectionTimeout), () async {
      _connectionReportStreamController.add(const ConnectionReport(
        connectStatus: ConnectStatus.disconnected,
        errorMessage: 'disconnected',
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
    required int commandIndex,
  }) {
    _characteristicDataTimer = Timer(timeout, () {
      if (!_completer!.isCompleted) {
        _completer!.completeError(CharacteristicError.timeoutOccured);
        print('cmd:$commandIndex Timeout occurred');
      }
    });
  }

  @override
  void cancelCharacteristicDataTimer({required String name}) {
    if (_characteristicDataTimer != null) {
      _characteristicDataTimer!.cancel();
    }

    print('$name CharacteristicDataTimer has been canceled');
  }

  void cancelCompleterOnDisconnected() {
    if (_completer != null) {
      if (!_completer!.isCompleted) {
        _completer!.completeError(false);
      }
    }
  }

  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
        Permission.bluetoothAdvertise,
        Permission.location,
      ].request();

      // 所有權限都允許, 才return true
      if (statuses.values.contains(PermissionStatus.denied)) {
        return false;
      } else {
        return true;
      }
    } else if (Platform.isIOS) {
      return true;
    } else {
      // neither android nor ios
      return false;
    }
  }
}
