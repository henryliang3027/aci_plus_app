import 'dart:async';
import 'dart:io';

import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';
import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/crc16_calculate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

enum ScanStatus {
  success,
  failure,
  disable,
}

class ScanReport {
  const ScanReport({
    required this.scanStatus,
    this.discoveredDevice,
  });

  final ScanStatus scanStatus;
  final DiscoveredDevice? discoveredDevice;
}

class ConnectionReport {
  const ConnectionReport({
    required this.connectionState,
    this.errorMessage = '',
  });

  final DeviceConnectionState connectionState;
  final String errorMessage;
}

class BLEClient {
  BLEClient._() : _ble = FlutterReactiveBle();

  static final BLEClient _instance = BLEClient._();

  static BLEClient get instance => _instance;

  FlutterReactiveBle? _ble;
  final _scanTimeout = 3; // sec
  final _connectionTimeout = 30; //sec
  late StreamController<ScanReport> _scanReportStreamController;
  StreamController<ConnectionReport> _connectionReportStreamController =
      StreamController<ConnectionReport>();
  // StreamController<Map<DataKey, String>> _characteristicDataStreamController =
  //     StreamController<Map<DataKey, String>>();
  StreamSubscription<DiscoveredDevice>? _discoveredDeviceStreamSubscription;
  StreamSubscription<ConnectionStateUpdate>? _connectionStreamSubscription;
  StreamSubscription<List<int>>? _characteristicStreamSubscription;
  late QualifiedCharacteristic _qualifiedCharacteristic;

  final _aciPrefix = 'ACI';
  final _serviceId = 'ffe0';
  final _characteristicId = 'ffe1';

  Completer<dynamic>? _completer;

  int _currentCommandIndex = 0;

  Timer? _characteristicDataTimer;
  Timer? _connectionTimer;

  final List<int> _combinedRawData = [];
  final int _totalBytesPerCommand = 261;

  // 1p8G variables
  // List<int> _rawRFInOut = [];

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

  Future<int> getRSSI() {
    return _ble!.readRssi(_qualifiedCharacteristic.deviceId);
  }

  Stream<ScanReport> get scanReport async* {
    _ble ??= FlutterReactiveBle();
    _scanReportStreamController = StreamController<ScanReport>();

    bool isPermissionGranted = await checkBluetoothEnabled();

    if (isPermissionGranted) {
      // 設定 scan timeout
      Timer scanTimer = Timer(Duration(seconds: _scanTimeout), () async {
        _scanReportStreamController.add(
          const ScanReport(
            scanStatus: ScanStatus.failure,
            discoveredDevice: null,
          ),
        );

        await closeScanStream();
      });

      _discoveredDeviceStreamSubscription =
          _ble!.scanForDevices(withServices: []).listen((device) {
        if (device.name.startsWith(_aciPrefix)) {
          if (!_scanReportStreamController.isClosed) {
            scanTimer.cancel();
            print('Device: ${device.name}');
            _scanReportStreamController.add(
              ScanReport(
                scanStatus: ScanStatus.success,
                discoveredDevice: device,
              ),
            );
          }
        }
      }, onError: (error) {
        print('Scan Error $error');
        _scanReportStreamController.add(
          const ScanReport(
            scanStatus: ScanStatus.failure,
            discoveredDevice: null,
          ),
        );
      });
    } else {
      print('bluetooth disable');
      _scanReportStreamController.add(
        const ScanReport(
          scanStatus: ScanStatus.disable,
          discoveredDevice: null,
        ),
      );
    }

    yield* _scanReportStreamController.stream;
  }

  Future<void> connectToDevice(DiscoveredDevice discoveredDevice) async {
    startConnectionTimer();

    _connectionReportStreamController = StreamController<ConnectionReport>();
    _connectionStreamSubscription = _ble!
        .connectToDevice(
      id: discoveredDevice.id,
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
            deviceId: discoveredDevice.id,
          );

          _characteristicStreamSubscription = _ble!
              .subscribeToCharacteristic(_qualifiedCharacteristic)
              .listen((data) async {
            List<int> rawData = data;
            print(_currentCommandIndex);
            // print('data length: ${rawData.length}, $rawData');

            if (_currentCommandIndex <= 13) {
              cancelCharacteristicDataTimer(name: 'cmd $_currentCommandIndex');

              bool isValidCRC = checkCRC(rawData);
              if (isValidCRC) {
                if (!_completer!.isCompleted) {
                  _completer!.complete(rawData);
                }
              } else {
                if (!_completer!.isCompleted) {
                  _completer!.completeError(CharacteristicError.invalidData);
                }
              }
            } else if (_currentCommandIndex >= 14 &&
                _currentCommandIndex <= 37) {
              _combinedRawData.addAll(rawData);
              // 一個 log command 總共會接收 261 bytes, 每一次傳回 16 bytes
              if (_combinedRawData.length == _totalBytesPerCommand) {
                bool isValidCRC = checkCRC(_combinedRawData);
                if (isValidCRC) {
                  List<int> combinedRawData = List.from(_combinedRawData);
                  _combinedRawData.clear();
                  cancelCharacteristicDataTimer(
                      name: 'cmd $_currentCommandIndex');
                  if (!_completer!.isCompleted) {
                    _completer!.complete(combinedRawData);
                  }
                } else {
                  if (!_completer!.isCompleted) {
                    _completer!.completeError(CharacteristicError.invalidData);
                  }
                }
              }
            } else if (_currentCommandIndex >= 40 &&
                _currentCommandIndex <= 46) {
              cancelCharacteristicDataTimer(name: 'cmd $_currentCommandIndex');
              if (!_completer!.isCompleted) {
                _completer!.complete(rawData);
              }
            } else if (_currentCommandIndex >= 180 &&
                _currentCommandIndex <= 182) {
              cancelCharacteristicDataTimer(name: 'cmd $_currentCommandIndex');

              bool isValidCRC = checkCRC(rawData);
              if (isValidCRC) {
                if (!_completer!.isCompleted) {
                  _completer!.complete(rawData);
                }
              } else {
                if (!_completer!.isCompleted) {
                  _completer!.completeError(CharacteristicError.invalidData);
                }
              }
            } else if (_currentCommandIndex == 183) {
              // 接收 RF input/output power 資料流
              List<int> header = [0xB0, 0x03, 0x00];
              if (listEquals(rawData.sublist(0, 3), header)) {
                _combinedRawData.clear();
              }

              _combinedRawData.addAll(rawData);
              // print(_combinedRawData.length);

              if (_combinedRawData.length == 1029) {
                // RF input/output power 資料流總長度 1029
                bool isValidCRC = checkCRC(_combinedRawData);
                if (isValidCRC) {
                  List<int> rawRFInOuts = List.from(_combinedRawData);
                  cancelCharacteristicDataTimer(
                      name: 'cmd $_currentCommandIndex');
                  if (!_completer!.isCompleted) {
                    _completer!.complete(rawRFInOuts);
                  }
                } else {
                  if (!_completer!.isCompleted) {
                    _completer!.completeError(CharacteristicError.invalidData);
                  }
                }
              }
            } else if (_currentCommandIndex >= 184 &&
                _currentCommandIndex <= 194) {
              // _currentCommandIndex 184 ~ 193 用來接收 10 組 Log 資料流, 每一組 Log 總長 16389
              // _currentCommandIndex 194 用來接收 1 組 Event 資料流, Event 總長 16389
              List<int> header = [0xB0, 0x03, 0x00];
              if (listEquals(rawData.sublist(0, 3), header)) {
                _combinedRawData.clear();
              }

              _combinedRawData.addAll(rawData);
              print(_combinedRawData.length);

              if (_combinedRawData.length == 16389) {
                bool isValidCRC = checkCRC(_combinedRawData);
                if (isValidCRC) {
                  List<int> rawLogs = List.from(_combinedRawData);
                  cancelCharacteristicDataTimer(
                      name: 'cmd $_currentCommandIndex');
                  if (!_completer!.isCompleted) {
                    _completer!.complete(rawLogs);
                  }
                } else {
                  if (!_completer!.isCompleted) {
                    _completer!.completeError(CharacteristicError.invalidData);
                  }
                }
              }
            } else if (_currentCommandIndex >= 300) {
              cancelCharacteristicDataTimer(name: 'cmd $_currentCommandIndex');
              if (!_completer!.isCompleted) {
                _completer!.complete(rawData);
              }
            }
          }, onError: (error) {
            print('lisetn to Characteristic failed');
          });

          _connectionReportStreamController.add(const ConnectionReport(
            connectionState: DeviceConnectionState.connected,
          ));

          break;
        case DeviceConnectionState.disconnecting:
        // _connectionReportStreamController.add(const ConnectionReport(
        //   connectionState: DeviceConnectionState.disconnected,
        //   errorMessage: 'disconnecting',
        // ));
        // break;
        case DeviceConnectionState.disconnected:
          // cancelConnectionTimer();
          // cancelCharacteristicDataTimer(name: 'connection closed');
          // cancelCompleterOnDisconnected();

          _connectionReportStreamController.add(const ConnectionReport(
            connectionState: DeviceConnectionState.disconnected,
            errorMessage: 'Device connection failed',
          ));

          await closeConnectionStream();
          break;
        default:
          break;
      }
    }, onError: (error) {
      cancelConnectionTimer();
      cancelCharacteristicDataTimer(name: 'connection closed');
      cancelCompleterOnDisconnected();
      _connectionReportStreamController.add(ConnectionReport(
        connectionState: DeviceConnectionState.disconnected,
        errorMessage: error.toString(),
      ));
    });
  }

  Stream<ConnectionReport> get connectionStateReport async* {
    yield* _connectionReportStreamController.stream;
  }

  // Stream<Map<DataKey, String>> get characteristicData async* {
  //   yield* _characteristicDataStreamController.stream;
  // }

  Future<void> closeScanStream() async {
    print('closeScanStream');

    if (!_scanReportStreamController.isClosed) {
      await _scanReportStreamController.close();
    }

    await _discoveredDeviceStreamSubscription?.cancel();
    _discoveredDeviceStreamSubscription = null;
  }

  Future<void> closeConnectionStream() async {
    print('close _characteristicStreamSubscription');

    cancelConnectionTimer();
    cancelCharacteristicDataTimer(name: 'connection closed');
    cancelCompleterOnDisconnected();

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
    _combinedRawData.clear();
  }

  bool checkCRC(
    List<int> rawData,
  ) {
    List<int> crcData = List<int>.from(rawData);
    CRC16.calculateCRC16(command: crcData, usDataLength: crcData.length - 2);
    if (rawData.isNotEmpty) {
      if (crcData[crcData.length - 1] == rawData[rawData.length - 1] &&
          crcData[crcData.length - 2] == rawData[rawData.length - 2]) {
        return true;
      } else {
        return false;
      }
    } else {
      // 如果 rawData 是空的
      return false;
    }
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

  Future<dynamic> getACIDeviceType({
    required int commandIndex,
    required List<int> value,
    required String deviceId,
    int mtu = 247,
  }) async {
    _currentCommandIndex = commandIndex;
    final negotiatedMtu = await _ble!.requestMtu(deviceId: deviceId, mtu: mtu);

    // 設定 mtu = 247
    List<dynamic> result = await _requestBasicInformationRawData(value);

    if (result[0]) {
      List<int> rawData = result[1];
      int length = rawData.length;
      // 1G/1.2G data length = 17
      if (length == 17) {
        return [
          true,
          ACIDeviceType.dsim1G1P2G,
        ];
      } else {
        // 1.8G data length = 181
        int partId = rawData[71];
        if (partId == 4) {
          return [
            true,
            ACIDeviceType.ampCCorNode1P8G,
          ];
        } else {
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
  Future writeSetCommandToCharacteristic({
    required int commandIndex,
    required List<int> value,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    _currentCommandIndex = commandIndex;

    _completer = Completer<dynamic>();

    try {
      if (Platform.isAndroid) {
        await _ble!.writeCharacteristicWithResponse(
          _qualifiedCharacteristic,
          value: value,
        );
      } else if (Platform.isIOS) {
        await _ble!.writeCharacteristicWithoutResponse(
          _qualifiedCharacteristic,
          value: value,
        );
      } else {}

      startCharacteristicDataTimer(
        timeout: timeout,
        commandIndex: commandIndex,
      );
    } catch (e) {
      if (!_completer!.isCompleted) {
        print('writeCharacteristic failed: ${e.toString()}');
        _completer!.completeError(CharacteristicError.writeDataError.name);
      }
    }
    return _completer!.future;
  }

  // Future getCompleter() {
  //   _completer = Completer<dynamic>();
  //   return _completer.future;
  // }

  // void testTimeout() {
  //   print(1111);
  //   _characteristicDataTimer = Timer(Duration(seconds: 1), () {
  //     if (!_completer.isCompleted) {
  //       _completer.completeError('Timeout occurred');
  //     }
  //   });
  //   print(1111);
  // }

  // void setTimeout({required Duration duration, required String name}) {
  //   _characteristicDataTimer = Timer(duration, () {
  //     print('$name: ${_characteristicDataTimer!.tick.toString()}');
  //     if (!_completer.isCompleted) {
  //       _completer.completeError('Timeout occurred');
  //       print('$name Timeout occurred');
  //     }
  //   });
  // }

  void startConnectionTimer() {
    _connectionTimer = Timer(Duration(seconds: _connectionTimeout), () async {
      _connectionReportStreamController.add(const ConnectionReport(
        connectionState: DeviceConnectionState.disconnected,
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
