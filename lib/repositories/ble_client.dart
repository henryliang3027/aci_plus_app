import 'dart:async';
import 'dart:io';

import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';
import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/crc16_calculate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as GPS;

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
  BLEClient() : _ble = FlutterReactiveBle();

  final FlutterReactiveBle _ble;
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

  late Completer<dynamic> _completer;

  int _currentCommandIndex = 0;

  Timer? _timeoutTimer;

  // 1G/1.2G variables
  List<int> _rawLog = [];
  List<int> _rawEvent = [];
  int _totalBytesPerCommand = 261;

  // 1p8G variables
  List<int> _rawRFInOut = [];

  Future<bool> checkBluetoothEnabled() async {
    // 要求定位與藍芽存取權
    bool isPermissionGranted = await _requestPermission();

    if (isPermissionGranted) {
      // 偵測定位是否有打開, 如果沒有打開會跳出提示訊息
      bool resultOfEnableGPS = await GPS.Location().requestService();

      // 偵測藍芽是否有打開, 如果沒有打開會跳出提示訊息
      String resultStrOfEnableBluetooth = await BluetoothEnable.enableBluetooth;
      bool resultOfEnableBluetooth =
          resultStrOfEnableBluetooth == 'true' ? true : false;

      if (resultOfEnableGPS && resultOfEnableBluetooth) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Stream<ScanReport> get scanReport async* {
    bool isGranted = await checkBluetoothEnabled();
    _scanReportStreamController = StreamController<ScanReport>();
    if (isGranted) {
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
          _ble.scanForDevices(withServices: []).listen((device) {
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
    Timer connectionTimer =
        Timer(Duration(seconds: _connectionTimeout), () async {
      _connectionReportStreamController.add(const ConnectionReport(
        connectionState: DeviceConnectionState.disconnected,
        errorMessage: 'disconnected',
      ));

      await closeScanStream();
      await closeConnectionStream();
    });

    _connectionReportStreamController = StreamController<ConnectionReport>();
    _connectionStreamSubscription = _ble
        .connectToDevice(
      id: discoveredDevice.id,
    )
        .listen((connectionStateUpdate) async {
      print('connectionStateUpdateXXXXXX: $connectionStateUpdate');
      switch (connectionStateUpdate.connectionState) {
        case DeviceConnectionState.connecting:
          break;
        case DeviceConnectionState.connected:
          connectionTimer.cancel();

          // _characteristicDataStreamController =
          //     StreamController<Map<DataKey, String>>();

          _qualifiedCharacteristic = QualifiedCharacteristic(
            serviceId: Uuid.parse(_serviceId),
            characteristicId: Uuid.parse(_characteristicId),
            deviceId: discoveredDevice.id,
          );

          _characteristicStreamSubscription = _ble
              .subscribeToCharacteristic(_qualifiedCharacteristic)
              .listen((data) async {
            List<int> rawData = data;
            print(_currentCommandIndex);
            print('data length: ${rawData.length}');

            if (_currentCommandIndex <= 13) {
              cancelTimeout(name: 'cmd $_currentCommandIndex');
              if (!_completer.isCompleted) {
                _completer.complete(rawData);
              }
            } else if (_currentCommandIndex >= 14 &&
                _currentCommandIndex <= 29) {
              _rawLog.addAll(rawData);
              // 一個 log command 總共會接收 261 bytes, 每一次傳回 16 bytes
              if (_rawLog.length == _totalBytesPerCommand) {
                List<int> rawLogs = List.from(_rawLog);
                _rawLog.clear();
                cancelTimeout(name: 'cmd $_currentCommandIndex');
                if (!_completer.isCompleted) {
                  _completer.complete(rawLogs);
                }
              }
            } else if (_currentCommandIndex >= 30 &&
                _currentCommandIndex <= 37) {
              _rawEvent.addAll(rawData);
              // 一個 event command 總共會接收 261 bytes, 每一次傳回 16 bytes
              if (_rawEvent.length == _totalBytesPerCommand) {
                List<int> rawEvents = List.from(_rawEvent);
                _rawEvent.clear();
                cancelTimeout(name: 'cmd $_currentCommandIndex');
                if (!_completer.isCompleted) {
                  _completer.complete(rawEvents);
                }
              }
            } else if (_currentCommandIndex >= 40 &&
                _currentCommandIndex <= 46) {
              cancelTimeout(name: 'cmd $_currentCommandIndex');
              if (!_completer.isCompleted) {
                _completer.complete(rawData);
              }
            } else if (_currentCommandIndex >= 180 &&
                _currentCommandIndex <= 182) {
              cancelTimeout(name: 'cmd $_currentCommandIndex');

              if (rawData.length == 181) {
                bool isValidCRC = checkCRC(rawData);
                if (isValidCRC) {
                  if (!_completer.isCompleted) {
                    _completer.complete(rawData);
                  }
                } else {
                  if (!_completer.isCompleted) {
                    _completer.completeError('Invalid data');
                  }
                }
              }
            } else if (_currentCommandIndex == 183) {
              List<int> header = [0xB0, 0x03, 0x00];
              if (listEquals(rawData.sublist(0, 3), header)) {
                _rawRFInOut.clear();
              }

              _rawRFInOut.addAll(rawData);
              print(_rawRFInOut.length);

              if (_rawRFInOut.length == 1029) {
                bool isValidCRC = checkCRC(_rawRFInOut);
                if (isValidCRC) {
                  List<int> rawRFInOuts = List.from(_rawRFInOut);
                  cancelTimeout(name: 'cmd $_currentCommandIndex');
                  if (!_completer.isCompleted) {
                    _completer.complete(rawRFInOuts);
                  }
                } else {
                  if (!_completer.isCompleted) {
                    _completer.completeError('Invalid data');
                  }
                }
              }
            } else if (_currentCommandIndex >= 184 &&
                _currentCommandIndex <= 193) {
              List<int> header = [0xB0, 0x03, 0x00];
              if (listEquals(rawData.sublist(0, 3), header)) {
                _rawLog.clear();
              }

              _rawLog.addAll(rawData);
              print(_rawLog.length);

              if (_rawLog.length == 16389) {
                bool isValidCRC = checkCRC(_rawLog);
                if (isValidCRC) {
                  List<int> rawLogs = List.from(_rawLog);
                  cancelTimeout(name: 'cmd $_currentCommandIndex');
                  if (!_completer.isCompleted) {
                    _completer.complete(rawLogs);
                  }
                } else {
                  if (!_completer.isCompleted) {
                    _completer.completeError('Invalid data');
                  }
                }
              }
            } else if (_currentCommandIndex >= 300) {
              cancelTimeout(name: 'cmd $_currentCommandIndex');
              if (!_completer.isCompleted) {
                _completer.complete(rawData);
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
          _connectionReportStreamController.add(const ConnectionReport(
            connectionState: DeviceConnectionState.disconnected,
            errorMessage: 'disconnected',
          ));
          break;
        default:
          break;
      }
    }, onError: (error) {
      print('Error: $error');
      _connectionReportStreamController.add(const ConnectionReport(
        connectionState: DeviceConnectionState.disconnected,
        errorMessage: 'disconnected',
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

    if (_scanReportStreamController.isClosed) {
      await _scanReportStreamController.close();
    }

    await _discoveredDeviceStreamSubscription?.cancel();
    _discoveredDeviceStreamSubscription = null;
  }

  Future<void> closeConnectionStream() async {
    print('close _characteristicStreamSubscription');

    if (_connectionReportStreamController.hasListener) {
      if (!_connectionReportStreamController.isClosed) {
        await _connectionReportStreamController.close();
      }
    }

    // if (_characteristicDataStreamController.hasListener) {
    //   if (!_characteristicDataStreamController.isClosed) {
    //     await _characteristicDataStreamController.close();
    //   }
    // }

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
  }

  bool checkCRC(
    List<int> rawData,
  ) {
    List<int> crcData = List<int>.from(rawData);
    CRC16.calculateCRC16(command: crcData, usDataLength: crcData.length - 2);
    if (crcData[crcData.length - 1] == rawData[rawData.length - 1] &&
        crcData[crcData.length - 2] == rawData[rawData.length - 2]) {
      return true;
    } else {
      return false;
    }
  }

  // 透過 1G/1.2G/1.8G 同樣的基本指令, 來取得回傳資料的長度
  Future<dynamic> _requestDataLength(List<int> value) async {
    _currentCommandIndex = -1;

    print('get data from request command 0');

    try {
      List<int> rawData = await writeSetCommandToCharacteristic(
        commandIndex: 0,
        value: value,
        timeout: const Duration(seconds: 10),
      );
      return [true, rawData.length];
    } catch (e) {
      return [
        false,
      ];
    }
  }

  Future<dynamic> requestMTU({
    required int commandIndex,
    required List<int> value,
    required String deviceId,
    int mtu = 247,
  }) async {
    _currentCommandIndex = commandIndex;
    final negotiatedMtu = await _ble.requestMtu(deviceId: deviceId, mtu: mtu);

    // 設定 mtu = 247
    List<dynamic> result = await _requestDataLength(value);

    if (result[0]) {
      int length = result[1];
      // 1G/1.2G data length = 17
      if (length == 17) {
        return [
          true,
          23,
        ];
      } else {
        // 1.8G data length = 181
        return [
          true,
          244,
        ];
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
        await _ble.writeCharacteristicWithResponse(
          _qualifiedCharacteristic,
          value: value,
        );
      } else if (Platform.isIOS) {
        await _ble.writeCharacteristicWithoutResponse(
          _qualifiedCharacteristic,
          value: value,
        );
      } else {}

      _timeoutTimer = Timer(timeout, () {
        if (!_completer.isCompleted) {
          _completer.completeError('Timeout occurred');
          print('cmd:$commandIndex Timeout occurred');
        }
      });

      return _completer.future;
    } catch (e) {
      if (!_completer.isCompleted) {
        _completer.completeError(e.toString());
      }
      return _completer.future;
    }
  }

  // Future getCompleter() {
  //   _completer = Completer<dynamic>();
  //   return _completer.future;
  // }

  // void testTimeout() {
  //   print(1111);
  //   _timeoutTimer = Timer(Duration(seconds: 1), () {
  //     if (!_completer.isCompleted) {
  //       _completer.completeError('Timeout occurred');
  //     }
  //   });
  //   print(1111);
  // }

  void setTimeout({required Duration duration, required String name}) {
    _timeoutTimer = Timer(duration, () {
      print('$name: ${_timeoutTimer!.tick.toString()}');
      if (!_completer.isCompleted) {
        _completer.completeError('Timeout occurred');
        print('$name Timeout occurred');
      }
    });
  }

  void cancelTimeout({required String name}) {
    if (_timeoutTimer != null) {
      _timeoutTimer!.cancel();
    }

    print('$name completed (timeout canceled)');
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
