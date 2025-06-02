import 'dart:async';
import 'dart:typed_data';

import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/crc16_calculate.dart';
import 'package:aci_plus_app/repositories/connection_client.dart';
import 'package:aci_plus_app/repositories/ble_peripheral.dart';
import 'package:ftdi_serial/device_list_result.dart';
import 'package:ftdi_serial/device_status.dart';
import 'package:ftdi_serial/ftdi_serial.dart';
import 'package:ftdi_serial/serial_device.dart';

class USBClient extends ConnectionClient {
  USBClient() : _ftdiSerial = FtdiSerial();

  // 使用非 broadcast 模式的 StreamController

  StreamSubscription? _dataStreamSubscription;
  StreamSubscription? _deviceStatusStreamSubscription;
  bool _isConnected = false;

  final FtdiSerial _ftdiSerial;
  int _currentCommandIndex = 0;

  Completer<dynamic>? _completer;
  Timer? _streamDataTimer;

  late StreamController<ScanReport> _scanReportStreamController;
  StreamController<ConnectionReport> _connectionReportStreamController =
      StreamController<ConnectionReport>();

  late StreamController<String> _updateReportStreamController;

  // 連接狀態報告
  @override
  Stream<ConnectionReport> get connectionStateReport async* {
    yield* _connectionReportStreamController.stream;
  }

  // 獲取當前連接狀態
  bool get isConnected => _isConnected;

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

  static Future<SerialDevice> getAttachedDevice() async {
    SerialDevice serialDevice = await FtdiSerial.getAttachedDevice();
    return serialDevice;
  }

  Future<bool> requestUsbPermission() async {
    bool isPermissionGranted = await _ftdiSerial.requestUsbPermission();
    return isPermissionGranted;
  }

  // 資源清理
  void dispose() {
    _dataStreamSubscription?.cancel();
    _dataStreamSubscription = null;
    _deviceStatusStreamSubscription?.cancel();
    _deviceStatusStreamSubscription = null;
    _connectionReportStreamController.close();
  }

  @override
  Stream<ScanReport> get scanReport async* {
    throw UnimplementedError('USBClient does not support scanReport stream');
  }

  @override
  Future<void> connectToDevice(Peripheral peripheral) async {
    // 必須要在一開始就 initialize stream controller 才能夠正常使用
    _connectionReportStreamController = StreamController<ConnectionReport>();

    bool isPermissionGranted = await requestUsbPermission();

    if (isPermissionGranted) {
      await _ftdiSerial.createDeviceList();
      bool isConnected = await _ftdiSerial.connectToDevice();

      if (isConnected) {
        _deviceStatusStreamSubscription =
            _ftdiSerial.deviceStatusStream.listen((bool isConnected) async {
          if (!isConnected) {
            _connectionReportStreamController.add(const ConnectionReport(
              connectStatus: ConnectStatus.disconnected,
              errorMessage: 'Device connection failed',
            ));

            closeScanStream();
            closeConnectionStream();
          }
        });

        _dataStreamSubscription = _ftdiSerial.dataStream.listen((dynamic data) {
          List<int> rawData = data.toList();

          print(
              'usb data index: $_currentCommandIndex, length:${rawData.length}');

          List<dynamic> finalResult = combineUsbRawData(
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
        }, onError: (error) {
          print('USB data stream error: $error');
          if (!_completer!.isCompleted) {
            _completer!.completeError(CharacteristicError.writeDataError);
          }
        });

        _connectionReportStreamController.add(const ConnectionReport(
          connectStatus: ConnectStatus.connected,
        ));
      } else {
        _connectionReportStreamController.add(const ConnectionReport(
          connectStatus: ConnectStatus.disconnected,
          errorMessage: 'Device connection failed',
        ));
      }
    } else {
      _connectionReportStreamController.add(const ConnectionReport(
        connectStatus: ConnectStatus.disconnected,
        errorMessage: 'Device connection failed',
      ));
    }
  }

  @override
  Future writeSetCommandToCharacteristic({
    required int commandIndex,
    required List<int> value,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    _currentCommandIndex = commandIndex;

    _completer = Completer<dynamic>();

    clearCombinedRawData();

    startCharacteristicDataTimer(
      timeout: timeout,
      commandIndex: commandIndex,
    );

    Future.microtask(() async {
      try {
        // 寫入資料到 USB

        bool isSuccess = await _ftdiSerial.write(Uint8List.fromList(value));
        if (!isSuccess) {
          cancelCharacteristicDataTimer(
              name:
                  'cmd $commandIndex, ${CharacteristicError.writeDataError.name}');
          if (!_completer!.isCompleted) {
            print('writeCharacteristic failed: ftdev does not open');
            _completer!.completeError(CharacteristicError.writeDataError.name);
          }
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

  @override
  Future writeLongSetCommandToCharacteristic(
      {required int commandIndex,
      required List<List<int>> chunks,
      Duration timeout = const Duration(seconds: 10)}) {
    throw UnimplementedError(
        'USBClient does not support writeLongSetCommandToCharacteristic');
  }

  void startCharacteristicDataTimer({
    required Duration timeout,
    required int commandIndex,
  }) {
    _streamDataTimer = Timer(timeout, () {
      if (!_completer!.isCompleted) {
        _completer!.completeError(CharacteristicError.timeoutOccured);
        print('cmd:$commandIndex Timeout occurred');
      }
    });
  }

  @override
  void cancelCharacteristicDataTimer({required String name}) {
    if (_streamDataTimer != null) {
      _streamDataTimer!.cancel();
    }

    print('$name CharacteristicDataTimer has been canceled');
  }

  @override
  Future<void> closeConnectionStream() async {
    _isConnected = false;
    cancelCompleterOnDisconnected();
    // cancelConnectionTimer();
    cancelCharacteristicDataTimer(name: 'connection closed');

    if (_connectionReportStreamController.hasListener) {
      if (!_connectionReportStreamController.isClosed) {
        await _connectionReportStreamController.close();
      }
    }
    clearCombinedRawData();

    _deviceStatusStreamSubscription?.cancel();
    _deviceStatusStreamSubscription = null;
    _dataStreamSubscription?.cancel();
    _dataStreamSubscription = null;
  }

  void cancelCompleterOnDisconnected() {
    if (_completer != null) {
      if (!_completer!.isCompleted) {
        _completer!.completeError(false);
      }
    }
  }

  @override
  Future<void> closeScanStream() async {
    _deviceStatusStreamSubscription?.cancel();
    _deviceStatusStreamSubscription = null;
  }

  // 透過 1G/1.2G/1.8G 同樣的基本指令, 來取得回傳資料的長度
  Future<dynamic> _requestBasicInformationRawData(List<int> value) async {
    print('get data from request command 0');

    try {
      List<int> rawData = await writeSetCommandToCharacteristic(
        commandIndex: _currentCommandIndex,
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
  Future getACIDeviceType({
    required int commandIndex,
    required List<int> value,
    required String deviceId,
    int mtu = 244,
  }) async {
    _currentCommandIndex = commandIndex;

    List<dynamic> result = await _requestBasicInformationRawData(value);

    if (result[0]) {
      List<int> rawData = result[1];
      int length = rawData.length;

      if (length == 17) {
        // 1G/1.2G data length = 17
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

  @override
  Future<int> getRSSI() {
    throw UnimplementedError('RSSI does not support for USB connection');
  }

  @override
  Future<void> transferBinaryChunk(
      {required int commandIndex,
      required List<int> chunk,
      required int indexOfChunk}) async {
    _currentCommandIndex = commandIndex;
    print('chink index: $indexOfChunk, length: ${chunk.length}');

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      await _ftdiSerial.write(Uint8List.fromList(chunk));
      await Future.delayed(const Duration(milliseconds: 50));

      _updateReportStreamController.add('Sent $indexOfChunk');
      print(
          'transferBinaryChunk executed in ${stopwatch.elapsed.inMilliseconds}');
    } catch (e) {
      _updateReportStreamController.addError('Sending the chunk error');
    }
  }

  @override
  Future<void> transferFirmwareCommand(
      {required int commandIndex,
      required List<int> command,
      Duration timeout = const Duration(seconds: 10)}) async {
    _currentCommandIndex = commandIndex;

    try {
      await _ftdiSerial.write(Uint8List.fromList(command));
    } catch (e) {
      _updateReportStreamController.addError('write data error');
    }
  }
}
