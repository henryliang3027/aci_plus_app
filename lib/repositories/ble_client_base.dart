import 'dart:async';

import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/repositories/ble_peripheral.dart';
import 'package:flutter/foundation.dart';

abstract class BLEClientBase {
  final int scanTimeout = 3; // seconds
  final int connectionTimeout = 30; // seconds
  late StreamController<ScanReport> scanReportStreamController;
  StreamController<ConnectionReport> connectionReportStreamController =
      StreamController<ConnectionReport>();

  Completer<dynamic>? _completer;

  int _currentCommandIndex = 0;

  Timer? _characteristicDataTimer;
  Timer? _connectionTimer;

  final List<int> _combinedRawData = [];
  final int _totalBytesPerCommand = 261;

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

  void handleDataReceived(List<int> rawData) {
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
    } else if (_currentCommandIndex >= 14 && _currentCommandIndex <= 37) {
      _combinedRawData.addAll(rawData);
      // 一個 log command 總共會接收 261 bytes, 每一次傳回 16 bytes
      if (_combinedRawData.length == _totalBytesPerCommand) {
        bool isValidCRC = checkCRC(_combinedRawData);
        if (isValidCRC) {
          List<int> combinedRawData = List.from(_combinedRawData);
          _combinedRawData.clear();
          cancelCharacteristicDataTimer(name: 'cmd $_currentCommandIndex');
          if (!_completer!.isCompleted) {
            _completer!.complete(combinedRawData);
          }
        } else {
          if (!_completer!.isCompleted) {
            _completer!.completeError(CharacteristicError.invalidData);
          }
        }
      }
    } else if (_currentCommandIndex >= 40 && _currentCommandIndex <= 46) {
      cancelCharacteristicDataTimer(name: 'cmd $_currentCommandIndex');
      if (!_completer!.isCompleted) {
        _completer!.complete(rawData);
      }
    } else if (_currentCommandIndex >= 80 && _currentCommandIndex <= 83) {
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
          cancelCharacteristicDataTimer(name: 'cmd $_currentCommandIndex');
          if (!_completer!.isCompleted) {
            _completer!.complete(rawRFInOuts);
          }
        } else {
          if (!_completer!.isCompleted) {
            _completer!.completeError(CharacteristicError.invalidData);
          }
        }
      }
    } else if (_currentCommandIndex >= 184 && _currentCommandIndex <= 194) {
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
          cancelCharacteristicDataTimer(name: 'cmd $_currentCommandIndex');
          if (!_completer!.isCompleted) {
            _completer!.complete(rawLogs);
          }
        } else {
          if (!_completer!.isCompleted) {
            _completer!.completeError(CharacteristicError.invalidData);
          }
        }
      }
    } else if (_currentCommandIndex >= 195 && _currentCommandIndex <= 204) {
      // _currentCommandIndex 195 ~ 204 用來接收 10 組 RFOut 資料流, 每一組 Log 總長 16389
      List<int> header = [0xB0, 0x03, 0x00];
      if (listEquals(rawData.sublist(0, 3), header)) {
        _combinedRawData.clear();
      }

      _combinedRawData.addAll(rawData);
      print(_combinedRawData.length);

      if (_combinedRawData.length == 16389) {
        bool isValidCRC = checkCRC(_combinedRawData);
        if (isValidCRC) {
          List<int> rawRFOuts = List.from(_combinedRawData);
          cancelCharacteristicDataTimer(name: 'cmd $_currentCommandIndex');
          if (!_completer!.isCompleted) {
            _completer!.complete(rawRFOuts);
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
  }
}
