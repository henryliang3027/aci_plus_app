import 'dart:async';
import 'dart:io';

import 'package:aci_plus_app/repositories/ble_client_base.dart';
import 'package:aci_plus_app/repositories/ble_peripheral.dart';
import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';
import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/crc16_calculate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

class BLEClient extends BLEClientBase {
  BLEClient()
      : _ble = FlutterReactiveBle(),
        super();
  // BLEClient._() : _ble = FlutterReactiveBle();

  // static final BLEClient _instance = BLEClient._();

  // static BLEClient get instance => _instance;

  FlutterReactiveBle? _ble;
  final _scanTimeout = 3; // sec
  final _connectionTimeout = 30; //sec
  late StreamController<ScanReport> _scanReportStreamController;
  StreamController<ConnectionReport> _connectionReportStreamController =
      StreamController<ConnectionReport>();

  late StreamController<String> _updateReportStreamController;

  StreamSubscription<DiscoveredDevice>? _discoveredDeviceStreamSubscription;
  StreamSubscription<ConnectionStateUpdate>? _connectionStreamSubscription;
  StreamSubscription<List<int>>? _characteristicStreamSubscription;
  late QualifiedCharacteristic _qualifiedCharacteristic;
  late Perigheral _perigheral;

  final _aciPrefix = 'ACI';
  final _serviceId = 'ffe0';
  final _characteristicId = 'ffe1';

  Completer<dynamic>? _completer;

  int _currentCommandIndex = 0;

  Timer? _characteristicDataTimer;
  Timer? _connectionTimer;

  // final List<int> _combinedRawData = [];
  // final int _totalBytesPerCommand = 261;

  // 1p8G variables
  // List<int> _rawRFInOut = [];

  @override
  Stream<String> get updateReport async* {
    _updateReportStreamController = StreamController<String>();
    Stream<String> streamWithTimeout =
        _updateReportStreamController.stream.timeout(
      Duration(seconds: 10),
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
      // 設定 scan timeout
      Timer scanTimer = Timer(Duration(seconds: _scanTimeout), () async {
        _scanReportStreamController.add(
          const ScanReport(
            scanStatus: ScanStatus.failure,
            perigheral: null,
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

            _perigheral = Perigheral(
              id: device.id,
              name: device.name,
            );

            _scanReportStreamController.add(
              ScanReport(
                scanStatus: ScanStatus.success,
                perigheral: _perigheral,
              ),
            );
          }
        }
      }, onError: (error) {
        print('Scan Error $error');
        _scanReportStreamController.add(
          const ScanReport(
            scanStatus: ScanStatus.failure,
            perigheral: null,
          ),
        );
      });
    } else {
      print('bluetooth disable');
      _scanReportStreamController.add(
        const ScanReport(
          scanStatus: ScanStatus.disable,
          perigheral: null,
        ),
      );
    }

    yield* _scanReportStreamController.stream;
  }

  @override
  Future<void> connectToDevice() async {
    startConnectionTimer();

    _connectionReportStreamController = StreamController<ConnectionReport>();
    _connectionStreamSubscription = _ble!
        .connectToDevice(
      id: _perigheral.id,
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
            deviceId: _perigheral.id,
          );

          _characteristicStreamSubscription = _ble!
              .subscribeToCharacteristic(_qualifiedCharacteristic)
              .listen((data) async {
            List<int> rawData = data;
            print(_currentCommandIndex);
            print('data length: ${rawData.length}, $rawData');

            List<dynamic> finalResult = combineRawData(
              commandIndex: _currentCommandIndex,
              rawData: rawData,
            );

            if (_currentCommandIndex >= 1000) {
              List<int> finalRawData = finalResult[1];
              String message = String.fromCharCodes(finalRawData);
              _updateReportStreamController.add(message);
              // cancelCharacteristicDataTimer(name: 'cmd $_currentCommandIndex');
              // List<int> finalRawData = finalResult[1];

              // if (!_completer!.isCompleted) {
              //   _completer!.complete(finalRawData);
              // }
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
            print('lisetn to Characteristic failed');
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
        default:
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

  // Stream<Map<DataKey, String>> get characteristicData async* {
  //   yield* _characteristicDataStreamController.stream;
  // }

  @override
  Future<void> closeScanStream() async {
    print('closeScanStream');

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
    clearCombinedRawData();
    // _combinedRawData.clear();
  }

  // bool checkCRC(
  //   List<int> rawData,
  // ) {
  //   List<int> crcData = List<int>.from(rawData);
  //   CRC16.calculateCRC16(command: crcData, usDataLength: crcData.length - 2);
  //   if (rawData.isNotEmpty) {
  //     if (crcData[crcData.length - 1] == rawData[rawData.length - 1] &&
  //         crcData[crcData.length - 2] == rawData[rawData.length - 2]) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } else {
  //     // 如果 rawData 是空的
  //     return false;
  //   }
  // }

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
    int mtu = 247,
  }) async {
    _currentCommandIndex = commandIndex;
    final negotiatedMtu = await _ble!.requestMtu(deviceId: deviceId, mtu: mtu);
    print('negotiatedMtu: ${negotiatedMtu}');

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
  @override
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
      } else {
        // iOS
        await _ble!.writeCharacteristicWithoutResponse(
          _qualifiedCharacteristic,
          value: value,
        );
      }

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

  @override
  Future<dynamic> transferFirmwareBinary({
    required int commandIndex,
    required List<int> binary,
    Duration timeout = const Duration(seconds: 600),
  }) async {
    int chunkSize = 244;
    _currentCommandIndex = commandIndex;

    // negotiatedMtu = 247
    // 送 chunck0 的時候會出現 status 13 (GATT_INVALID_ATTR_LEN) 的錯誤
    // final negotiatedMtu =
    //     await _ble!.requestMtu(deviceId: _perigheral.id, mtu: 244);

    List<List<int>> chunks = divideToChunkList(
      binary: binary,
      chunkSize: chunkSize,
    );

    print('binary.length: ${binary.length}, chunks.length: ${chunks.length}');
    for (int i = 0; i < chunks.length; i++) {
      List<int> chunk = chunks[i];
      print('chink index: $i, length: ${chunks[i].length}');

      try {
        Stopwatch stopwatch = Stopwatch()..start();
        if (Platform.isAndroid) {
          await _ble!.writeCharacteristicWithResponse(
            _qualifiedCharacteristic,
            value: chunk,
          );
        } else {
          // iOS
          await _ble!.writeCharacteristicWithoutResponse(
            _qualifiedCharacteristic,
            value: chunk,
          );
        }
        // if (i == 10) {
        //   await Future.delayed(Duration(milliseconds: 500));
        // }

        _updateReportStreamController
            .add('Sending ${i * chunkSize} ${binary.length}');
        print('doSomething() executed in ${stopwatch.elapsed.inMilliseconds}');
        int elapsedMs = stopwatch.elapsed.inMilliseconds;
        if (elapsedMs >= 400) {
          // _updateReportStreamController
          //     .addError('Sending the chunk $i takes too long, $elapsedMs');

          break;
        }
      } catch (e) {
        _updateReportStreamController.addError('Sending the chunk $i error');
      }
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
