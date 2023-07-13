import 'dart:async';
import 'dart:io';
import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/crc16_calculate.dart';
import 'package:dsim_app/core/custom_style.dart';
import 'package:excel/excel.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_speed_chart/speed_chart.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as GPS;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ScanStatus {
  success,
  failure,
  disable,
}

enum Alarm {
  success,
  danger,
  medium,
}

class Log {
  const Log({
    required this.dateTime,
    required this.temperature,
    required this.attenuation,
    required this.pilot,
    required this.voltage,
    required this.voltageRipple,
  });

  final DateTime dateTime;
  final double temperature;
  final int attenuation;
  final double pilot;
  final double voltage;
  final int voltageRipple;
}

class Event {
  const Event({
    required this.dateTime,
    required this.code,
    required this.parameter,
  });

  final DateTime dateTime;
  final int code;
  final int parameter;
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

class SettingData {
  const SettingData({
    required this.location,
    required this.tgcCableLength,
    required this.workingMode,
    required this.logIntervalId,
    required this.pilotCode,
    required this.pilot2Code,
    required this.maxAttenuation,
    required this.minAttenuation,
    required this.currentAttenuation,
    required this.centerAttenuation,
    required this.hasDualPilot,
  });
  final String location;
  final String tgcCableLength;
  final String workingMode;
  final int logIntervalId;
  final String pilotCode;
  final String pilot2Code;
  final String maxAttenuation;
  final String minAttenuation;
  final String currentAttenuation;
  final String centerAttenuation;
  final bool hasDualPilot;
}

class DsimRepository {
  DsimRepository() : _ble = FlutterReactiveBle() {
    _calculateCRCs();
  }
  final FlutterReactiveBle _ble;
  final _scanDuration = 3; // sec
  final _connectionTimeout = 10; //sec
  late StreamController<ScanReport> _scanReportStreamController;
  StreamController<ConnectionReport> _connectionReportStreamController =
      StreamController<ConnectionReport>();
  StreamController<Map<DataKey, String>> _characteristicDataStreamController =
      StreamController<Map<DataKey, String>>();
  StreamController<DataKey> _loadingResultStreamController =
      StreamController<DataKey>();

  StreamSubscription<DiscoveredDevice>? _discoveredDeviceStreamSubscription;
  StreamSubscription<ConnectionStateUpdate>? _connectionStreamSubscription;
  StreamSubscription<List<int>>? _characteristicStreamSubscription;
  late QualifiedCharacteristic _qualifiedCharacteristic;

  List<int> _dataList1 = [];
  List<int> _dataList2 = [];

  final _name1 = 'ACI03170078';
  final _name2 = 'ACI01160006';
  final _aciPrefix = 'ACI';
  final _serviceId = 'ffe0';
  final _characteristicId = 'ffe1';

  final List<List<int>> _commandCollection = [];
  int commandIndex = 0;
  int endIndex = 37;

  late Completer<dynamic> _completer;

  String _basicCurrentPilot = '';
  int _basicCurrentPilotMode = 0;
  int _currentSettingMode = 0;
  int _nowTimeCount = 0;
  int _alarmR = 0;
  int _alarmT = 0;
  int _alarmP = 0;
  String _basicInterval = '';
  final List<int> _rawLog = [];
  final List<Log> _logs = [];
  final List<int> _rawEvent = [];
  final List<Event> _events = [];
  final int _totalBytesPerCommand = 261;

  // 給 setting page 用
  String _location = '';
  String _tgcCableLength = '';
  String _workingMode = '';
  int _logIntervalId = -1;

  String _maxAttenuation = '';
  String _minAttenuation = '';
  String _currentAttenuation = '';
  String _centerAttenuation = '';

  // 記錄欲設定的 workingModeId
  int _workingModeId = 0;
  final int _agcWorkingModeSettingDuration = 30;

  bool _hasDualPilot = false;

  final int _commandExecutionTimeout = 10; // s
  final int _logGettingTimeout = 20; // s
  final int _agcWorkingModeSettingTimeout = 40; // s
  Timer? _timeoutTimer;

  Stream<ScanReport> get scannedDevices async* {
    // close connection before start scanning new device,
    // it is to solve device is not successfully disconnected after the app is closed
    await closeConnectionStream();

    GPS.Location location = GPS.Location();
    bool ison = await location.serviceEnabled();
    if (!ison) {
      //if defvice is off
      bool isTurnedOn = await location.requestService();
      if (isTurnedOn) {
        print("GPS device is turned ON");
      } else {
        print("GPS Device is still OFF");
      }
    }

    bool isPermissionGranted = await _requestPermission();
    if (isPermissionGranted) {
      await BluetoothEnable.enableBluetooth;
      _scanReportStreamController = StreamController<ScanReport>();
      _discoveredDeviceStreamSubscription =
          _ble.scanForDevices(withServices: []).listen((device) {
        if (device.name.startsWith(_aciPrefix)) {
          if (!_scanReportStreamController.isClosed) {
            _scanReportStreamController.add(
              ScanReport(
                scanStatus: ScanStatus.success,
                discoveredDevice: device,
              ),
            );
            _connectDevice(device);
          }
        }
      }, onError: (error) {
        print('Scan Error $error');
        _scanReportStreamController.add(
          const ScanReport(
            scanStatus: ScanStatus.disable,
            discoveredDevice: null,
          ),
        );
      });
      yield* _scanReportStreamController.stream.timeout(
          Duration(
            seconds: _scanDuration,
          ), onTimeout: (sink) {
        print('Stop Scanning');
        _scanReportStreamController.add(
          const ScanReport(
            scanStatus: ScanStatus.failure,
            discoveredDevice: null,
          ),
        );
      });
    } else {
      print('bluetooth disable');
      yield const ScanReport(
        scanStatus: ScanStatus.failure,
        discoveredDevice: null,
      );
    }
  }

  Stream<ConnectionReport> get connectionStateReport async* {
    yield* _connectionReportStreamController.stream;
  }

  Stream<Map<DataKey, String>> get characteristicData async* {
    yield* _characteristicDataStreamController.stream;
  }

  Stream<DataKey> get loadingResult async* {
    yield* _loadingResultStreamController.stream;
  }

  void clearCache() {
    _completer = Completer<dynamic>();
    cancelTimeout(name: 'set timeout from clearCache');
    _logs.clear();
    _rawLog.clear();
    _events.clear();
    _rawEvent.clear();
    _hasDualPilot = false;
    commandIndex = 0;
    endIndex = 37;
  }

  Future<void> closeScanStream() async {
    print('closeScanStream');
    _scanReportStreamController.close();
    await _discoveredDeviceStreamSubscription?.cancel();
    _discoveredDeviceStreamSubscription = null;
  }

  Future<void> closeConnectionStream() async {
    print('close _characteristicStreamSubscription');

    await _characteristicStreamSubscription?.cancel();
    _characteristicStreamSubscription = null;

    // add delay to solve the following exception on ios
    // Error unsubscribing from notifications:
    // PlatformException(reactive_ble_mobile.PluginError:7, The operation couldn’t be completed.
    // (reactive_ble_mobile.PluginError error 7.), {}, null)
    await Future.delayed(const Duration(milliseconds: 1));

    print('close _connectionStreamSubscription');
    await _connectionStreamSubscription?.cancel();
    _connectionStreamSubscription = null;
  }

  void _connectDevice(DiscoveredDevice discoveredDevice) {
    print('connect to ${discoveredDevice.name}, ${discoveredDevice.id}');
    _connectionReportStreamController = StreamController<ConnectionReport>();
    _connectionStreamSubscription = _ble
        .connectToDevice(
            id: discoveredDevice.id,
            connectionTimeout: Duration(
              seconds: _connectionTimeout,
            ))
        .listen((connectionStateUpdate) async {
      _connectionReportStreamController.add(ConnectionReport(
          connectionState: connectionStateUpdate.connectionState));

      if (connectionStateUpdate.connectionState ==
          DeviceConnectionState.connected) {
        // initialize _characteristicDataStreamController
        _characteristicDataStreamController =
            StreamController<Map<DataKey, String>>();

        _qualifiedCharacteristic = QualifiedCharacteristic(
          serviceId: Uuid.parse(_serviceId),
          characteristicId: Uuid.parse(_characteristicId),
          deviceId: discoveredDevice.id,
        );

        _characteristicStreamSubscription = _ble
            .subscribeToCharacteristic(_qualifiedCharacteristic)
            .listen((data) async {
          List<int> rawData = data;
          print(commandIndex);
          // _dataList2.addAll(rawData);
          // print('${_dataList2.length}, ${_dataList2[_dataList2.length - 1]}');

          if (commandIndex == -1) {
            _dataList1.addAll(rawData);
            print('${_dataList1.length}, ${_dataList1[_dataList1.length - 1]}');
          } else if (commandIndex == -2) {
            _dataList2.addAll(rawData);
            print('${_dataList2.length}, ${_dataList2[_dataList2.length - 1]}');
          } else if (commandIndex <= 13) {
            _parseRawData(rawData);
            // if (commandIndex <= endIndex) {
            //   writeNextCommand = true;
            // }
          } else if (commandIndex >= 14 && commandIndex <= 29) {
            _rawLog.addAll(rawData);
            // 一個 log command 總共會接收 261 bytes, 每一次傳回 16 bytes
            if (_rawLog.length == _totalBytesPerCommand) {
              _rawLog.removeRange(_rawLog.length - 2, _rawLog.length);
              _rawLog.removeRange(0, 3);
              _parseLog();
              _rawLog.clear();
              // writeNextCommand = true;
            }
          } else if (commandIndex >= 30 && commandIndex <= 37) {
            _rawEvent.addAll(rawData);
            // 一個 event command 總共會接收 261 bytes, 每一次傳回 16 bytes
            if (_rawEvent.length == _totalBytesPerCommand) {
              _rawEvent.removeRange(_rawEvent.length - 2, _rawEvent.length);
              _rawEvent.removeRange(0, 3);
              _parseEvent();
              _rawEvent.clear();
              // writeNextCommand = true;
            }
          } else if (commandIndex >= 40 && commandIndex <= 43) {
            _parseSetLocation(rawData);
          } else if (commandIndex == 44) {
            _parseSetTGCCableLength(rawData);
          } else if (commandIndex == 45) {
            _parseSetLogInterval(rawData);
          } else if (commandIndex == 46) {
            _parseSetWorkingMode(rawData);
          }
        });
      }
    }, onError: (error) {
      print('Error: $error');
      _connectionReportStreamController.add(ConnectionReport(
        connectionState: DeviceConnectionState.disconnected,
        errorMessage: error,
      ));
    });
  }

  void _parseEvent() {
    for (int i = 0; i < 16; i++) {
      int timeStamp = _rawEvent[i * 16] * 256 + _rawEvent[i * 16 + 1];
      int code = _rawEvent[i * 16 + 2] * 256 + _rawEvent[i * 16 + 3];
      int parameter = _rawEvent[i * 16 + 4] * 256 + _rawEvent[i * 16 + 5];

      int timeDiff = _nowTimeCount - timeStamp;
      if (timeDiff < 0) {
        timeDiff = timeDiff + 65520;
      }
      timeStamp = timeDiff;
      final DateTime dateTime = timeStampToDateTime(timeStamp);

      _events.add(Event(
        dateTime: dateTime,
        code: code,
        parameter: parameter,
      ));
    }

    if (commandIndex == 37) {
      _events.sort((a, b) => a.dateTime.compareTo(b.dateTime));

      // _loadingResultStreamController.add(DataKey.eventRecordsLoadingComplete);
      // _loadingResultStreamController
      //     .add(DataKey.settingParametersLoadingComplete);
    }

    if (!_completer.isCompleted) {
      _completer.complete(true);
    }
  }

  void _parseLog() {
    if (commandIndex < 29) {
      for (var i = 0; i < 16; i++) {
        int timeStamp = _rawLog[i * 16] * 256 + _rawLog[i * 16 + 1];
        double temperature =
            (_rawLog[i * 16 + 2] * 256 + _rawLog[i * 16 + 3]) / 10;
        int attenuation = _rawLog[i * 16 + 4] * 256 + _rawLog[i * 16 + 5];
        double pilot = (_rawLog[i * 16 + 6] * 256 + _rawLog[i * 16 + 7]) / 10;
        double voltage = (_rawLog[i * 16 + 8] * 256 + _rawLog[i * 16 + 9]) / 10;
        int voltageRipple = _rawLog[i * 16 + 10] * 256 + _rawLog[i * 16 + 11];

        if (timeStamp < 0xFFF0) {
          //# 20210128 做2補數
          if (temperature > 32767) {
            temperature = -(65535 - temperature + 1).abs();
          }

          int timeDiff = _nowTimeCount - timeStamp;
          if (timeDiff < 0) {
            timeDiff = timeDiff + 65520;
          }
          timeStamp = timeDiff;

          final DateTime dateTime = timeStampToDateTime(timeStamp);

          _logs.add(Log(
              dateTime: dateTime,
              temperature: temperature,
              attenuation: attenuation,
              pilot: pilot,
              voltage: voltage,
              voltageRipple: voltageRipple));
        }
      }
      if (!_completer.isCompleted) {
        _completer.complete(true);
      }
    } else {
      _logs.sort((a, b) => a.dateTime.compareTo(b.dateTime));

      // get min temperature
      double minTemperature = _logs
          .map((log) => log.temperature)
          .reduce((min, current) => min < current ? min : current);

      // get max temperature
      double maxTemperature = _logs
          .map((log) => log.temperature)
          .reduce((max, current) => max > current ? max : current);

      // get min attenuation
      int historicalMinAttenuation = _logs
          .map((log) => log.attenuation)
          .reduce((min, current) => min < current ? min : current);

      // get max attenuation
      int historicalMaxAttenuation = _logs
          .map((log) => log.attenuation)
          .reduce((max, current) => max > current ? max : current);

      // get min voltage
      double minVoltage = _logs
          .map((log) => log.voltage)
          .reduce((min, current) => min < current ? min : current);

      // get max voltage
      double maxVoltage = _logs
          .map((log) => log.voltage)
          .reduce((max, current) => max > current ? max : current);

      // get min voltage ripple
      int minVoltageRipple = _logs
          .map((log) => log.voltageRipple)
          .reduce((min, current) => min < current ? min : current);

      // get max voltage ripple
      int maxVoltageRipple = _logs
          .map((log) => log.voltageRipple)
          .reduce((max, current) => max > current ? max : current);

      String minTemperatureF =
          _convertToFahrenheit(minTemperature).toStringAsFixed(1) +
              CustomStyle.fahrenheitUnit;

      String maxTemperatureF =
          _convertToFahrenheit(maxTemperature).toStringAsFixed(1) +
              CustomStyle.fahrenheitUnit;

      String minTemperatureC =
          minTemperature.toString() + CustomStyle.celciusUnit;

      String maxTemperatureC =
          maxTemperature.toString() + CustomStyle.celciusUnit;

      if (!_completer.isCompleted) {
        _completer.complete((
          minTemperatureF,
          maxTemperatureF,
          minTemperatureC,
          maxTemperatureC,
          historicalMinAttenuation.toString(),
          historicalMaxAttenuation.toString(),
          minVoltage.toString(),
          maxVoltage.toString(),
          minVoltageRipple.toString(),
          maxVoltageRipple.toString(),
        ));
      }
    }
  }

  void _parseRawData(List<int> rawData) {
    switch (commandIndex) {
      case 0:
        String typeNo = '';
        for (int i = 3; i < 15; i++) {
          typeNo += String.fromCharCode(rawData[i]);
        }
        typeNo = typeNo.trim();

        if (!_completer.isCompleted) {
          _completer.complete(typeNo);
        }

        break;
      case 1:
        String partNo = 'DSIM';
        for (int i = 3; i < 15; i++) {
          partNo += String.fromCharCode(rawData[i]);
        }

        partNo = partNo.trim();

        // 如果是 dual, 會有兩的 pilot channel
        if (partNo.startsWith('DSIM-CG')) {
          _hasDualPilot = true;
        }

        if (!_completer.isCompleted) {
          _completer.complete(partNo);
        }
        break;
      case 2:
        String serialNumber = '';
        for (int i = 3; i < 15; i++) {
          serialNumber += String.fromCharCode(rawData[i]);
        }
        serialNumber = serialNumber.trim();

        if (!_completer.isCompleted) {
          _completer.complete(serialNumber);
        }

        break;
      case 3:
        int number = rawData[10]; // hardware status 4 bytes last bute

        // bit 0: RF detect Max, bit 1 : RF detect Min
        _alarmR = (number & 0x01) + (number & 0x02);

        // bit 6: Temperature Max, bit 7 : Temperature Min
        _alarmT = (number & 0x40) + (number & 0x80);

        // bit 4: Voltage 24v Max, bit 5 : Voltage 24v Min
        _alarmP = (number & 0x10) + (number & 0x20);

        _basicInterval = rawData[13].toString(); //time interval

        _nowTimeCount = rawData[11] * 256 + rawData[12];

        String firmwareVersion = '';
        for (int i = 3; i < 6; i++) {
          firmwareVersion += String.fromCharCode(rawData[i]);
        }

        _logIntervalId = int.parse(_basicInterval);

        if (!_completer.isCompleted) {
          _completer.complete((_basicInterval, firmwareVersion));
        }

        break;
      case 4:
        //MGC Value 2Bytes
        int currentAttenuator = rawData[4] * 256 + rawData[5];

        _currentSettingMode = rawData[3];

        _basicCurrentPilot = rawData[7].toString();
        _basicCurrentPilotMode = rawData[8];

        String tgcCableLength = rawData[6].toString();

        // setting data _currentAttenuation
        _currentAttenuation = currentAttenuator.toString();

        // setting data _minAttenuation
        _minAttenuation = '0';

        // setting data _maxAttenuation
        _maxAttenuation = '3000';

        // setting data _tgcCableLength
        _tgcCableLength = tgcCableLength;

        if (!_completer.isCompleted) {
          _completer.complete((
            currentAttenuator.toString(),
            '0',
            '3000',
            tgcCableLength,
          ));
        }
        break;

      case 5:
        String workingMode = '';
        String currentPilot = '';
        Alarm alarmRServerity = Alarm.medium;
        Alarm alarmTServerity = Alarm.medium;
        Alarm alarmPServerity = Alarm.medium;
        double currentTemperatureC;
        double currentTemperatureF;
        double current24V;
        String pilotMode = '';
        switch (rawData[3]) //working mode
        {
          case 1:
            {
              // _basicModeID = 1;
              workingMode = "Align";
              break;
            }
          case 2:
            {
              // _basicModeID = 2;
              workingMode = "AGC";
              break;
            }
          case 3:
            {
              // _basicModeID = 3;
              workingMode = "TGC";
              break;
            }
          case 4:
            {
              // _basicModeID = 4;
              workingMode = "MGC";
              break;
            }
        }

        if (rawData[3] > 2) {
          // medium
          alarmRServerity = Alarm.medium;
        } else {
          if (_alarmR > 0) {
            // danger
            alarmRServerity = Alarm.danger;
          } else {
            // success
            alarmRServerity = Alarm.success;
          }
        }
        if (rawData[3] == 3) {
          if (_currentSettingMode == 1 || _currentSettingMode == 2) {
            // danger
            alarmRServerity = Alarm.danger;
          }
        }

        if (alarmRServerity == Alarm.danger) {
          currentPilot = 'Loss';
        } else {
          currentPilot = _basicCurrentPilot;
          if (_basicCurrentPilotMode == 1) {
            // currentPilot += ' IRC';
            pilotMode = 'IRC';
          } else {
            // currentPilot += ' DIG';
            pilotMode = 'DIG';
          }
        }

        alarmTServerity = _alarmT > 0 ? Alarm.danger : Alarm.success;
        alarmPServerity = _alarmP > 0 ? Alarm.danger : Alarm.success;

        //Temperature
        currentTemperatureC = (rawData[10] * 256 + rawData[11]) / 10;
        currentTemperatureF = _convertToFahrenheit(currentTemperatureC);
        String strCurrentTemperatureF =
            currentTemperatureF.toStringAsFixed(1) + CustomStyle.fahrenheitUnit;
        String strCurrentTemperatureC =
            currentTemperatureC.toString() + CustomStyle.celciusUnit;

        //24V
        current24V = (rawData[8] * 256 + rawData[9]) / 10;

        if (!_completer.isCompleted) {
          _completer.complete((
            workingMode,
            currentPilot,
            pilotMode,
            alarmRServerity.name,
            alarmTServerity.name,
            alarmPServerity.name,
            strCurrentTemperatureF,
            strCurrentTemperatureC,
            current24V.toString(),
          ));
        }

        // setting data _workingMode
        _workingMode = workingMode;

        break;
      case 6:
        int centerAttenuation = rawData[11] * 256 + rawData[12];
        int currentVoltageRipple = rawData[9] * 256 + rawData[10]; //24VR

        // setting data _centerAttenuation
        _centerAttenuation = centerAttenuation.toString();

        if (!_completer.isCompleted) {
          _completer.complete(
              (centerAttenuation.toString(), currentVoltageRipple.toString()));
        }

        break;
      case 7:
        // no logic
        break;
      case 8:
        // no logic
        break;
      case 9:
        String partOfLocation = '';
        for (int i = 3; i < 15; i++) {
          if (rawData[i] == 0) {
            break;
          }
          partOfLocation += String.fromCharCode(rawData[i]);
        }
        if (!_completer.isCompleted) {
          _completer.complete(partOfLocation);
        }
        break;
      case 10:
        String partOfLocation = '';
        for (int i = 3; i < 15; i++) {
          if (rawData[i] == 0) {
            break;
          }
          partOfLocation += String.fromCharCode(rawData[i]);
        }
        if (!_completer.isCompleted) {
          _completer.complete(partOfLocation);
        }
        break;
      case 11:
        String partOfLocation = '';
        for (int i = 3; i < 15; i++) {
          if (rawData[i] == 0) {
            break;
          }
          partOfLocation += String.fromCharCode(rawData[i]);
        }
        if (!_completer.isCompleted) {
          _completer.complete(partOfLocation);
        }
        break;
      case 12:
        String partOfLocation = '';
        for (int i = 3; i < 7; i++) {
          if (rawData[i] == 0) {
            break;
          }
          partOfLocation += String.fromCharCode(rawData[i]);
        }

        if (!_completer.isCompleted) {
          _completer.complete(partOfLocation);
        }

        break;
      default:
        break;
    }
  }

  Future<dynamic> requestCommandTest1() async {
    _dataList1.clear();
    commandIndex = -1;
    _completer = Completer<dynamic>();
    List<int> cmd1 = [0xB0, 0x03, 0xAA, 0x00, 0x00, 0x80, 0x7E, 0x53];
    List<int> cmd2 = [0xB0, 0x03, 0xAB, 0x00, 0x00, 0x80, 0x7F, 0xAF];

    print('get data from request command -1');
    await _writeSetCommandToCharacteristic(cmd1);

    // setTimeout(Duration(seconds: 0));

    try {
      String test = await _completer.future;

      return [true, test];
    } catch (e) {
      return [false, ''];
    }
  }

  Future<dynamic> requestCommandTest2() async {
    _dataList2.clear();
    commandIndex = -2;
    _completer = Completer<dynamic>();
    List<int> cmd1 = [0xB0, 0x03, 0xAA, 0x00, 0x00, 0x80, 0x7E, 0x53];
    List<int> cmd2 = [0xB0, 0x03, 0xAB, 0x00, 0x00, 0x80, 0x7F, 0xAF];

    print('get data from request command -2');
    await _writeSetCommandToCharacteristic(cmd2);

    // setTimeout(Duration(seconds: 0));

    try {
      String test = await _completer.future;

      return [true, test];
    } catch (e) {
      return [false, ''];
    }
  }

  Future<dynamic> requestCommand0() async {
    commandIndex = 0;
    _completer = Completer<dynamic>();

    print('get data from request command 0');
    await _writeSetCommandToCharacteristic(_commandCollection[commandIndex]);
    setTimeout(
        duration: Duration(seconds: _commandExecutionTimeout), name: 'cmd0');

    try {
      String typeNo = await _completer.future;
      cancelTimeout(name: 'cmd0');

      return [true, typeNo];
    } catch (e) {
      return [false, ''];
    }
  }

  Future<dynamic> requestCommand1() async {
    commandIndex = 1;
    _completer = Completer<dynamic>();

    print('get data from request command 1');
    await _writeSetCommandToCharacteristic(_commandCollection[commandIndex]);
    setTimeout(
        duration: Duration(seconds: _commandExecutionTimeout), name: 'cmd1');

    try {
      String partNo = await _completer.future;
      cancelTimeout(name: 'cmd1');

      return [true, partNo];
    } catch (e) {
      return [false, ''];
    }
  }

  Future<dynamic> requestCommand2() async {
    commandIndex = 2;
    _completer = Completer<dynamic>();

    print('get data from request command 2');
    await _writeSetCommandToCharacteristic(_commandCollection[commandIndex]);
    setTimeout(
        duration: Duration(seconds: _commandExecutionTimeout), name: 'cmd2');

    try {
      String serialNumber = await _completer.future;
      cancelTimeout(name: 'cmd2');

      return [true, serialNumber];
    } catch (e) {
      return [false, ''];
    }
  }

  Future<dynamic> requestCommand3() async {
    commandIndex = 3;
    _completer = Completer<dynamic>();

    print('get data from request command 3');
    await _writeSetCommandToCharacteristic(_commandCollection[commandIndex]);
    setTimeout(
        duration: Duration(seconds: _commandExecutionTimeout), name: 'cmd3');

    try {
      var (String basicInterval, String firmwareVersion) =
          await _completer.future;

      cancelTimeout(name: 'cmd3');

      return [true, basicInterval, firmwareVersion];
    } catch (e) {
      return [false, '', ''];
    }
  }

  Future<dynamic> requestCommand4() async {
    commandIndex = 4;
    _completer = Completer<dynamic>();

    print('get data from request command 4');
    await _writeSetCommandToCharacteristic(_commandCollection[commandIndex]);
    setTimeout(
        duration: Duration(seconds: _commandExecutionTimeout), name: 'cmd4');

    try {
      var (
        String currentAttenuation,
        String minAttenuation,
        String maxAttenuation,
        String tgcCableLength
      ) = await _completer.future;

      cancelTimeout(name: 'cmd4');

      return [
        true,
        currentAttenuation,
        minAttenuation,
        maxAttenuation,
        tgcCableLength,
      ];
    } catch (e) {
      return [
        false,
        '',
        '',
        '',
        '',
      ];
    }
  }

  Future<dynamic> requestCommand5() async {
    commandIndex = 5;
    _completer = Completer<dynamic>();

    print('get data from request command 5');
    await _writeSetCommandToCharacteristic(_commandCollection[commandIndex]);
    setTimeout(
        duration: Duration(seconds: _commandExecutionTimeout), name: 'cmd5');

    try {
      var (
        String workingMode,
        String currentPilot,
        String pilotMode,
        String alarmRServerity,
        String alarmTServerity,
        String alarmPServerity,
        String strCurrentTemperatureF,
        String strCurrentTemperatureC,
        String current24V,
      ) = await _completer.future;

      cancelTimeout(name: 'cmd5');

      return [
        true,
        workingMode,
        currentPilot,
        pilotMode,
        alarmRServerity,
        alarmTServerity,
        alarmPServerity,
        strCurrentTemperatureF,
        strCurrentTemperatureC,
        current24V,
      ];
    } catch (e) {
      return [
        false,
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
      ];
    }
  }

  Future<dynamic> requestCommand6() async {
    commandIndex = 6;
    _completer = Completer<dynamic>();

    print('get data from request command 6');
    await _writeSetCommandToCharacteristic(_commandCollection[commandIndex]);
    setTimeout(
        duration: Duration(seconds: _commandExecutionTimeout), name: 'cmd6');

    try {
      var (
        String centerAttenuation,
        String currentVoltageRipple,
      ) = await _completer.future;

      cancelTimeout(name: 'cmd6');

      return [
        true,
        centerAttenuation,
        currentVoltageRipple,
      ];
    } catch (e) {
      return [
        false,
        '',
        '',
      ];
    }
  }

  // location
  Future requestCommand9To12() async {
    String loc = '';
    for (int i = 9; i <= 12; i++) {
      commandIndex = i;
      _completer = Completer<dynamic>();

      print('get data from request command $i');
      await _writeSetCommandToCharacteristic(_commandCollection[commandIndex]);
      setTimeout(
          duration: Duration(seconds: _commandExecutionTimeout),
          name: 'cmd9 to 12');

      // 設定後重新讀取 location 來比對是否設定成功
      try {
        String partOfLocation = await _completer.future;

        cancelTimeout(name: 'cmd$i');

        loc += partOfLocation;

        print('$i $loc, $partOfLocation');

        if (commandIndex == 12) {
          _location = loc;
          return [true, loc];
        }
      } catch (e) {
        return [false, ''];
      }
    }
  }

  Future requestCommand14To29() async {
    for (int i = 14; i <= 29; i++) {
      commandIndex = i;
      _completer = Completer<dynamic>();

      print('get data from request command $i');
      await _writeSetCommandToCharacteristic(_commandCollection[commandIndex]);
      setTimeout(
          duration: Duration(seconds: _commandExecutionTimeout),
          name: 'cmd14 to 29');

      if (commandIndex == 29) {
        try {
          var (
            minTemperatureF,
            maxTemperatureF,
            minTemperatureC,
            maxTemperatureC,
            historicalMinAttenuation,
            historicalMaxAttenuation,
            minVoltage,
            maxVoltage,
            minVoltageRipple,
            maxVoltageRipple,
          ) = await _completer.future;

          cancelTimeout(name: 'cmd$i');

          return [
            true,
            minTemperatureF,
            maxTemperatureF,
            minTemperatureC,
            maxTemperatureC,
            historicalMinAttenuation,
            historicalMaxAttenuation,
            minVoltage,
            maxVoltage,
            minVoltageRipple,
            maxVoltageRipple,
          ];
        } catch (e) {
          return [false, '', '', '', '', '', '', '', '', '', ''];
        }
      } else {
        try {
          bool isDone = await _completer.future;
          cancelTimeout(name: 'cmd$i');
          if (!isDone) {
            return [false, '', '', '', '', '', '', '', '', '', ''];
          }
        } catch (e) {
          return [false, '', '', '', '', '', '', '', '', '', ''];
        }
      }
    }
  }

  Future requestCommand30To37() async {
    for (int i = 30; i <= 37; i++) {
      commandIndex = i;
      _completer = Completer<dynamic>();

      print('get data from request command $i');
      await _writeSetCommandToCharacteristic(_commandCollection[commandIndex]);
      setTimeout(
          duration: Duration(seconds: _commandExecutionTimeout),
          name: 'cmd30 to 37');

      try {
        bool isGettingChunkDone = await _completer.future;
        cancelTimeout(name: 'cmd$i');
        if (!isGettingChunkDone) {
          return [false];
        }
      } catch (e) {
        return [false];
      }
    }

    return [true];
  }

  void _calculateCRCs() {
    // 機型(typeNo)
    CRC16.calculateCRC16(command: Command.req00Cmd, usDataLength: 6);

    // 型號(partNo)
    CRC16.calculateCRC16(command: Command.req01Cmd, usDataLength: 6);

    // serialNumber
    CRC16.calculateCRC16(command: Command.req02Cmd, usDataLength: 6);

    // firmware, logInterval
    CRC16.calculateCRC16(command: Command.req03Cmd, usDataLength: 6);

    // currentAttenuation, minAttenuation, maxAttenuation, tgcCableLength
    CRC16.calculateCRC16(command: Command.req04Cmd, usDataLength: 6);

    // workingMode, currentPilot, currentPilotMode, alarmRServerity, alarmTServerity,
    // alarmPServerity, currentTemperatureF, currentTemperatureC, currentVoltage
    CRC16.calculateCRC16(command: Command.req05Cmd, usDataLength: 6);

    // centerAttenuation, currentVoltageRipple
    CRC16.calculateCRC16(command: Command.req06Cmd, usDataLength: 6);

    // none
    CRC16.calculateCRC16(command: Command.req07Cmd, usDataLength: 6);

    // none
    CRC16.calculateCRC16(command: Command.req08Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.location1, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.location2, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.location3, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.location4, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.req0DCmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.ddataE8, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.ddataE9, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.ddataEA, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.ddataEB, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.ddataEC, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.ddataED, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.ddataEE, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.ddataEF, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.ddataF0, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.ddataF1, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.ddataF2, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.ddataF3, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.ddataF4, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.ddataF5, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.ddataF6, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.ddataF7, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.ddataF8, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.ddataF9, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.ddataFA, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.ddataFB, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.ddataFC, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.ddataFD, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.ddataFE, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.ddataFF, usDataLength: 6);

    _commandCollection.addAll([
      Command.req00Cmd,
      Command.req01Cmd,
      Command.req02Cmd,
      Command.req03Cmd,
      Command.req04Cmd,
      Command.req05Cmd,
      Command.req06Cmd,
      Command.req07Cmd,
      Command.req08Cmd,
      Command.location1,
      Command.location2,
      Command.location3,
      Command.location4,
      Command.req0DCmd,
      Command.ddataE8, // #14 log
      Command.ddataE9,
      Command.ddataEA,
      Command.ddataEB,
      Command.ddataEC,
      Command.ddataED,
      Command.ddataEE,
      Command.ddataEF,
      Command.ddataF0,
      Command.ddataF1,
      Command.ddataF2,
      Command.ddataF3,
      Command.ddataF4,
      Command.ddataF5,
      Command.ddataF6,
      Command.ddataF7, // #29 log
      Command.ddataF8, // #30 event
      Command.ddataF9,
      Command.ddataFA,
      Command.ddataFB,
      Command.ddataFC,
      Command.ddataFD,
      Command.ddataFE,
      Command.ddataFF, // #37 event
    ]);
  }

  void _parseSetWorkingMode(List<int> rawData) async {
    if (commandIndex == 46) {
      if ((rawData[0] == 0xB0) &&
          (rawData[1] == 0x10) &&
          (rawData[2] == 0x00) &&
          (rawData[3] == 0x04) &&
          (rawData[4] == 0x00) &&
          (rawData[5] == 0x06)) {
        print('set working mode done');

        // 如果 _workingModeId == 1 也就是 AGC, 則等待30秒後再讀回資料
        if (_workingModeId == 1) {
          await Future.delayed(
              Duration(seconds: _agcWorkingModeSettingDuration));
        }

        if (!_completer.isCompleted) {
          _completer.complete(true);
        }
      }
    }
  }

  Future<void> _parseSetLogInterval(List<int> rawData) async {
    if (commandIndex == 45) {
      if ((rawData[0] == 0xB0) &&
          (rawData[1] == 0x10) &&
          (rawData[2] == 0x00) &&
          (rawData[3] == 0x04) &&
          (rawData[4] == 0x00) &&
          (rawData[5] == 0x06)) {
        print('set log interval done');

        if (!_completer.isCompleted) {
          _completer.complete(true);
        }
      }
    }
  }

  Future<void> _parseSetTGCCableLength(List<int> rawData) async {
    if (commandIndex == 44) {
      if ((rawData[0] == 0xB0) &&
          (rawData[1] == 0x10) &&
          (rawData[2] == 0x00) &&
          (rawData[3] == 0x04) &&
          (rawData[4] == 0x00) &&
          (rawData[5] == 0x06)) {
        print('set TGC cable length done');
      }

      if (!_completer.isCompleted) {
        _completer.complete(true);
      }
    }
  }

  Future<void> _parseSetLocation(List<int> rawData) async {
    if (commandIndex == 40) {
      if ((rawData[0] == 0xB0) &&
          (rawData[1] == 0x10) &&
          (rawData[2] == 0x00) &&
          (rawData[3] == 0x09) &&
          (rawData[4] == 0x00) &&
          (rawData[5] == 0x06)) {
        print('Location09 Set');
        commandIndex = 41;
        await _writeSetCommandToCharacteristic(
          Command.setLocACmd,
        );
      } else {}
    } else if (commandIndex == 41) {
      if ((rawData[0] == 0xB0) &&
          (rawData[1] == 0x10) &&
          (rawData[2] == 0x00) &&
          (rawData[3] == 0x0A) &&
          (rawData[4] == 0x00) &&
          (rawData[5] == 0x06)) {
        print('Location0A Set');
        commandIndex = 42;
        await _writeSetCommandToCharacteristic(
          Command.setLocBCmd,
        );
      } else {}
    } else if (commandIndex == 42) {
      if ((rawData[0] == 0xB0) &&
          (rawData[1] == 0x10) &&
          (rawData[2] == 0x00) &&
          (rawData[3] == 0x0B) &&
          (rawData[4] == 0x00) &&
          (rawData[5] == 0x06)) {
        print('Location0B Set');
        commandIndex = 43;
        await _writeSetCommandToCharacteristic(
          Command.setLocCCmd,
        );
      } else {}
    } else if (commandIndex == 43) {
      if ((rawData[0] == 0xB0) &&
          (rawData[1] == 0x10) &&
          (rawData[2] == 0x00) &&
          (rawData[3] == 0x0C) &&
          (rawData[4] == 0x00) &&
          (rawData[5] == 0x06)) {
        print('Location0C Set');

        if (!_completer.isCompleted) {
          _completer.complete(true);
        }
      } else {}
    }
  }

  Future<bool> setLocation(String location) async {
    _completer = Completer<dynamic>();
    int newLength = location.length;
    int imod;
    int index;
    for (var i = 0; i < 12; i++) {
      Command.setLoc9Cmd[7 + i] = 0;
      Command.setLocACmd[7 + i] = 0;
      Command.setLocBCmd[7 + i] = 0;
      Command.setLocCCmd[7 + i] = 0;
    }

    if (newLength >= 40) newLength = 40;

    imod = newLength % 12;
    index = (newLength - imod) ~/ 12;
    if (imod > 0) index += 1;
    if (imod == 0) imod = 12;
    if (index == 4) {
      for (var i = 0; i < 12; i++) {
        Command.setLoc9Cmd[7 + i] = location.codeUnitAt(i);
      }
      for (var i = 12; i < 24; i++) {
        Command.setLocACmd[7 + i - 12] = location.codeUnitAt(i);
      }
      for (var i = 24; i < 36; i++) {
        Command.setLocBCmd[7 + i - 24] = location.codeUnitAt(i);
      }
      if (imod > 4) {
        imod = 4;
      }
      for (var i = 36; i < 36 + imod; i++) {
        Command.setLocCCmd[7 + i - 36] = location.codeUnitAt(i);
      }
    } //4
    if (index == 3) {
      for (var i = 0; i < 12; i++) {
        Command.setLoc9Cmd[7 + i] = location.codeUnitAt(i);
      }

      for (var i = 12; i < 24; i++) {
        Command.setLocACmd[7 + i - 12] = location.codeUnitAt(i);
      }
      for (var i = 24; i < 24 + imod; i++) {
        Command.setLocBCmd[7 + i - 24] = location.codeUnitAt(i);
      }
    } //3
    if (index == 2) {
      for (var i = 0; i < 12; i++) {
        Command.setLoc9Cmd[7 + i] = location.codeUnitAt(i);
      }
      for (var i = 12; i < 12 + imod; i++) {
        Command.setLocACmd[7 + i - 12] = location.codeUnitAt(i);
      }
    } //2
    if (index == 1) {
      for (var i = 0; i < imod; i++) {
        Command.setLoc9Cmd[7 + i] = location.codeUnitAt(i);
      }
    } //1

    // calculateLocationCRCs
    CRC16.calculateCRC16(command: Command.setLoc9Cmd, usDataLength: 19);
    CRC16.calculateCRC16(command: Command.setLocACmd, usDataLength: 19);
    CRC16.calculateCRC16(command: Command.setLocBCmd, usDataLength: 19);
    CRC16.calculateCRC16(command: Command.setLocCCmd, usDataLength: 19);

    commandIndex = 40;
    endIndex = 43;

    print('set location');
    await _writeSetCommandToCharacteristic(
      Command.setLoc9Cmd,
    );

    // 設定後重新讀取 location 來比對是否設定成功
    try {
      bool isDone = await _completer.future;
      setTimeout(
          duration: Duration(seconds: _commandExecutionTimeout),
          name: 'cmd set location');

      if (isDone) {
        List<dynamic> resultOfGetLocation = await requestCommand9To12();

        if (resultOfGetLocation[0]) {
          if (location == resultOfGetLocation[1]) {
            _characteristicDataStreamController
                .add({DataKey.location: resultOfGetLocation[1]});
            _location = resultOfGetLocation[1];
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> setTGCCableLength({
    required int currentAttenuation,
    required String tgcCableLength,
    required String pilotChannel,
    required String pilotMode,
    required int logIntervalId,
  }) async {
    _completer = Completer<dynamic>();

    Command.set04Cmd[7] = 3; //3 TGC
    Command.set04Cmd[8] = currentAttenuation ~/ 256; //MGC Value 2Bytes
    Command.set04Cmd[9] = currentAttenuation % 256; //MGC Value
    Command.set04Cmd[10] = int.parse(tgcCableLength); //TGC Cable length
    Command.set04Cmd[11] = int.parse(pilotChannel); //AGC Channel 1Byte
    Command.set04Cmd[12] = _getPilotModeId(pilotMode); //AGC channel Mode 1 Byte
    Command.set04Cmd[13] = logIntervalId; //Log Minutes 1Byte
    Command.set04Cmd[14] = 0x03; //AGC Channel 2 1Byte
    Command.set04Cmd[15] = 0x02; //AGC Channel 2 Mode 1Byte
    CRC16.calculateCRC16(command: Command.set04Cmd, usDataLength: 19);

    commandIndex = 44;
    endIndex = 44;
    _writeSetCommandToCharacteristic(Command.set04Cmd);
    setTimeout(
        duration: Duration(seconds: _commandExecutionTimeout),
        name: 'cmd set tgc cable length');

    // 設定後重新讀取 tgc cable length 來比對是否設定成功
    try {
      bool isDone = await _completer.future;
      cancelTimeout(name: 'cmd set tgc cable length');

      if (isDone) {
        List<dynamic> result = await requestCommand4();

        if (result[0]) {
          if (tgcCableLength == result[4]) {
            // _characteristicDataStreamController
            //     .add({DataKey.tgcCableLength: resultOfGetTGCCableLength[1]});
            _tgcCableLength = result[4];
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> setLogInterval({
    required int logIntervalId,
  }) async {
    _completer = Completer<dynamic>();
    Command.set04Cmd[7] = 0x08; // 8
    Command.set04Cmd[13] = logIntervalId; // Log Minutes 1Byte
    CRC16.calculateCRC16(command: Command.set04Cmd, usDataLength: 19);

    commandIndex = 45;
    endIndex = 45;
    _writeSetCommandToCharacteristic(Command.set04Cmd);
    setTimeout(
        duration: Duration(seconds: _commandExecutionTimeout),
        name: 'set log interval');

    // 設定後重新讀取 log interval 來比對是否設定成功
    try {
      bool isDone = await _completer.future;
      cancelTimeout(name: 'set log interval');

      if (isDone) {
        List<dynamic> result = await requestCommand3();

        if (result[0]) {
          if (logIntervalId.toString() == result[1]) {
            _characteristicDataStreamController
                .add({DataKey.logInterval: result[1]});
            _logIntervalId = int.parse(result[1]);
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> setWorkingMode({
    required String workingMode,
    required int currentAttenuation,
    required String tgcCableLength,
    required String pilotChannel,
    required String pilotMode,
    String pilot2Channel = '',
    String pilot2Mode = '',
    required int logIntervalId,
  }) async {
    _completer = Completer<dynamic>();
    _workingModeId = _getWorkingModeId(workingMode);

    if (_hasDualPilot) {
      Command.set04Cmd[7] = _workingModeId;
      Command.set04Cmd[8] = currentAttenuation ~/ 256; //MGC Value 2Bytes
      Command.set04Cmd[9] = currentAttenuation % 256; //MGC Value
      Command.set04Cmd[10] = int.parse(tgcCableLength); //TGC Cable length
      Command.set04Cmd[11] = int.parse(pilotChannel); //AGC Channel 1Byte
      Command.set04Cmd[12] =
          _getPilotModeId(pilotMode); //AGC channel Mode 1 Byte
      Command.set04Cmd[13] = logIntervalId; //Log Minutes 1Byte
      Command.set04Cmd[14] = int.parse(pilot2Channel); //AGC Channel 2 1Byte
      Command.set04Cmd[15] =
          _getPilotModeId(pilot2Mode); //AGC Channel 2 Mode 1Byte
    } else {
      Command.set04Cmd[7] = _workingModeId;
      Command.set04Cmd[8] = currentAttenuation ~/ 256; //MGC Value 2Bytes
      Command.set04Cmd[9] = currentAttenuation % 256; //MGC Value
      Command.set04Cmd[10] = int.parse(tgcCableLength); //TGC Cable length
      Command.set04Cmd[11] = int.parse(pilotChannel); //AGC Channel 1Byte
      Command.set04Cmd[12] =
          _getPilotModeId(pilot2Mode); //AGC channel Mode 1 Byte
      Command.set04Cmd[13] = logIntervalId; //Log Minutes 1Byte
      Command.set04Cmd[14] = 0x03; //AGC Channel 2 1Byte
      Command.set04Cmd[15] = 0x02; //AGC Channel 2 Mode 1Byte
    }

    CRC16.calculateCRC16(command: Command.set04Cmd, usDataLength: 19);

    commandIndex = 46;
    endIndex = 46;
    _writeSetCommandToCharacteristic(Command.set04Cmd);
    setTimeout(
        duration: Duration(seconds: _commandExecutionTimeout),
        name: 'set working mode');

    // 設定後重新讀取 working mode 來比對是否設定成功
    try {
      bool isDone = await _completer.future;
      cancelTimeout(name: 'set working mode');

      if (isDone) {
        List<dynamic> result = await requestCommand5();

        if (result[0]) {
          if (workingMode == result[1]) {
            _characteristicDataStreamController
                .add({DataKey.workingMode: result[1]});
            _characteristicDataStreamController
                .add({DataKey.currentPilot: result[2]});
            _characteristicDataStreamController
                .add({DataKey.currentPilotMode: result[3]});
            _workingMode = result[1];
            // _basicCurrentPilot = result[2];
            // _basicCurrentPilotMode = result[3];
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  int _getWorkingModeId(String workingMode) {
    switch (workingMode) {
      case 'AGC':
        return 1;
      case 'TGC':
        return 3;
      case 'MGC':
        return 4;
      default:
        return 1;
    }
  }

  int _getPilotModeId(String pilotMode) {
    if (pilotMode == 'IRC') {
      return 1;
    } else {
      return 2;
    }
  }

  // iOS 跟 Android 的 set command 方式不一樣
  Future<void> _writeSetCommandToCharacteristic(List<int> value) async {
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
  }

  Future<dynamic> exportRecords() async {
    Excel excel = Excel.createExcel();
    List<String> logHeader = [
      'Time',
      'Temperature(C)',
      'Attenuator',
      'Pilot (dBuV)',
      '24V(V)',
      '24V Ripple(mV)',
    ];
    List<String> eventHeader = [
      'Power On',
      'Power Off',
      '24V High(V)',
      '24V Low(V)',
      'Temperature High(C)',
      'Temperature Low(C)',
      'Input RF Power High(dBuV)',
      'Input RF Power Low(dBuV)',
      '24V Ripple High(mV)',
      'Align Loss Pilot',
      'AGC Loss Pilot',
      'Controll Plug in',
      'Controll Plug out',
    ];

    Sheet logSheet = excel['Log'];
    Sheet eventSheet = excel['Event'];

    eventSheet.insertRowIterables(eventHeader, 0);
    for (int i = 0; i < _events.length; i++) {
      Event event = _events[i];
      List<String> row = formatEvent(event);
      eventSheet.insertRowIterables(row, i + 1);
    }

    logSheet.insertRowIterables(logHeader, 0);
    for (int i = 0; i < _logs.length; i++) {
      Log log = _logs[i];
      List<String> row = formatLog(log);
      logSheet.insertRowIterables(row, i + 1);
    }

    excel.unLink('Sheet1'); // Excel 預設會自動產生 Sheet1, 所以先unlink
    excel.delete('Sheet1'); // 再刪除 Sheet1
    excel.link('Log', logSheet);
    var fileBytes = excel.save();

    String timeStamp =
        DateFormat('yyyy_MM_dd_HH_mm_ss').format(DateTime.now()).toString();
    String filename = 'data_$timeStamp.xlsx';

    if (Platform.isIOS) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String fullWrittenPath = '$appDocPath/$filename';
      File f = File(fullWrittenPath);
      await f.writeAsBytes(fileBytes!);
      return [
        true,
        fullWrittenPath,
      ];
    } else if (Platform.isAndroid) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String fullWrittenPath = '$appDocPath/$filename';
      File f = File(fullWrittenPath);
      await f.writeAsBytes(fileBytes!);

      return [
        true,
        fullWrittenPath,
      ];
    } else {
      return [
        false,
        'write file failed, export function not implement on ${Platform.operatingSystem} '
      ];
    }
  }

  double _convertToFahrenheit(double celcius) {
    double fahrenheit = (celcius * 1.8) + 32;
    return fahrenheit;
  }

  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
        Permission.bluetoothAdvertise,
        Permission.location,
      ].request();

      if (statuses.values.contains(PermissionStatus.granted)) {
        return true;
      } else {
        return false;
      }
    } else if (Platform.isIOS) {
      return true;
    } else {
      // neither android nor ios
      return false;
    }
  }

  List<String> formatLog(Log log) {
    String formattedDateTime =
        DateFormat('yyyy-MM-dd HH:mm').format(log.dateTime);
    String temperatureC = log.temperature.toString();
    String attenuation = log.attenuation.toString();
    String pilot = log.pilot.toString();
    String voltage = log.voltage.toString();
    String voltageRipple = log.voltageRipple.toString();
    List<String> row = [
      formattedDateTime,
      temperatureC,
      attenuation,
      pilot,
      voltage,
      voltageRipple
    ];

    return row;
  }

  List<String> formatEvent(Event event) {
    String formattedDateTime =
        DateFormat('yyyy-MM-dd HH:mm').format(event.dateTime);
    List<String> row = ['', '', '', '', '', '', '', '', '', '', '', '', ''];

    switch (event.code) {
      case 0x0000:
        {
          //EventCPEstart 0
          row[0] = formattedDateTime;
          if (event.parameter > 0) {
            row[0] = '$formattedDateTime@${event.parameter}';
          }
          break;
        }
      case 0x0001:
        {
          //EventCPEstop 1
          row[1] = formattedDateTime;
          if (event.parameter > 0) {
            row[1] = '$formattedDateTime@${event.parameter}';
          }

          break;
        }
      case 0x0002:
        {
          //Event24VOver 2
          row[2] = formattedDateTime;
          if (event.parameter > 0) {
            row[2] = '$formattedDateTime@${event.parameter / 10}';
          }
          break;
        }
      case 0x0004:
        {
          //Event24VLess 3
          row[3] = formattedDateTime;
          if (event.parameter > 0) {
            row[3] = '$formattedDateTime@${event.parameter / 10}';
          }
          break;
        }
      case 0x0008:
        {
          //EventTemOver 4
          row[4] = formattedDateTime;
          if (event.parameter > 0) {
            row[4] = '$formattedDateTime@${event.parameter / 10}';
          }
          break;
        }
      case 0x0010:
        {
          //EventTemLess 5
          row[5] = formattedDateTime;
          if (event.parameter > 0) {
            row[5] = '$formattedDateTime@${event.parameter / 10}';
          }
          break;
        }
      case 0x0020:
        {
          //EventSSIOver 6
          row[6] = formattedDateTime;
          if (event.parameter > 0) {
            row[6] = '$formattedDateTime@${event.parameter}';
          }
          break;
        }
      case 0x0040:
        {
          //EventSSILess 7
          row[7] = formattedDateTime;
          if (event.parameter > 0) {
            row[7] = '$formattedDateTime@${event.parameter}';
          }
          break;
        }
      case 0x0080:
        {
          //Event24VriOv 8
          row[8] = formattedDateTime;
          if (event.parameter > 0) {
            row[8] = '$formattedDateTime@${event.parameter}';
          }
          break;
        }
      case 0x0100:
        {
          //EventAlPiLos 9
          row[9] = formattedDateTime;
          if (event.parameter > 0) {
            row[9] = '$formattedDateTime@${event.parameter}';
          }
          break;
        }
      case 0x0200:
        {
          //EventAGPiLos 10
          row[10] = formattedDateTime;
          if (event.parameter > 0) {
            row[10] = '$formattedDateTime@${event.parameter}';
          }
          break;
        }
      case 0x1000:
        {
          //EventCTRPlin 11 used
          row[11] = formattedDateTime;
          if (event.parameter > 0) {
            row[11] = '$formattedDateTime@${event.parameter}';
          }
          break;
        }
      case 0x2000:
        {
          //EventCTRPlout 12 used
          row[12] = formattedDateTime;
          if (event.parameter > 0) {
            row[12] = '$formattedDateTime@${event.parameter}';
          }
          break;
        }
    } //switch

    return row;
  }

  DateTime timeStampToDateTime(int timeStamp) {
    int adjustedMillisecond =
        DateTime.now().millisecondsSinceEpoch - timeStamp * 60000;
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(adjustedMillisecond);

    return dateTime;
  }

  List<List<DateValuePair>> getDateValueCollectionOfLogs() {
    List<DateValuePair> attenuationDataList = [];
    List<DateValuePair> temperatureDataList = [];
    List<DateValuePair> pilotDataList = [];
    List<DateValuePair> voltageDataList = [];
    List<DateValuePair> voltageRippleDataList = [];
    for (Log log in _logs) {
      attenuationDataList.add(DateValuePair(
        dateTime: log.dateTime,
        value: log.attenuation.toDouble(),
      ));
      temperatureDataList.add(DateValuePair(
        dateTime: log.dateTime,
        value: log.temperature.toDouble(),
      ));
      pilotDataList.add(DateValuePair(
        dateTime: log.dateTime,
        value: log.pilot.toDouble(),
      ));
      voltageDataList.add(DateValuePair(
        dateTime: log.dateTime,
        value: log.voltage,
      ));
      voltageRippleDataList.add(DateValuePair(
        dateTime: log.dateTime,
        value: log.voltageRipple.toDouble(),
      ));
    }

    // print('---att--');
    // for (DateValuePair dateValuePair in attenuationDataList) {
    //   print(
    //       '{"time": "${DateFormat('yyyy-MM-dd HH:mm:ss').format(dateValuePair.dateTime).toString()}", "value": "${dateValuePair.value}"},');
    // }
    // print('---att--');
    // print('---temp--');
    // for (DateValuePair dateValuePair in temperatureDataList) {
    //   print(
    //       '{"time": "${DateFormat('yyyy-MM-dd HH:mm:ss').format(dateValuePair.dateTime).toString()}", "value": "${dateValuePair.value}"},');
    // }
    // print('---temp--');
    // print('---pilot--');
    // for (DateValuePair dateValuePair in pilotDataList) {
    //   print(
    //       '{"time": "${DateFormat('yyyy-MM-dd HH:mm:ss').format(dateValuePair.dateTime).toString()}", "value": "${dateValuePair.value}"},');
    // }
    // print('---pilot--');
    // print('---voltage--');
    // for (DateValuePair dateValuePair in voltageDataList) {
    //   print(
    //       '{"time": "${DateFormat('yyyy-MM-dd HH:mm:ss').format(dateValuePair.dateTime).toString()}", "value": "${dateValuePair.value}"},');
    // }
    // print('---voltage--');
    // print('---voltageRipple--');
    // for (DateValuePair dateValuePair in voltageRippleDataList) {
    //   print(
    //       '{"time": "${DateFormat('yyyy-MM-dd HH:mm:ss').format(dateValuePair.dateTime).toString()}", "value": "${dateValuePair.value}"},');
    // }
    // print('---voltageRipple--');

    return [
      attenuationDataList,
      temperatureDataList,
      pilotDataList,
      voltageDataList,
      voltageRippleDataList,
    ];
  }

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

    print('$name completed');
  }

  Future<void> writePilotCode(String pilotCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pilotCode', pilotCode);
  }

  Future<void> writePilot2Code(String pilot2Code) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pilot2Code', pilot2Code);
  }

  Future<String> readPilotCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String pilotCode = prefs.getString('pilotCode') ?? 'GG<@';
    return pilotCode;
  }

  Future<String> readPilot2Code() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String pilot2Code = prefs.getString('pilot2Code') ?? 'C<A';
    return pilot2Code;
  }

  Future<SettingData> getSettingData() async {
    String pilotCode = await readPilotCode();
    String pilot2Code = await readPilot2Code();

    return SettingData(
      location: _location,
      tgcCableLength: _tgcCableLength,
      workingMode: _workingMode,
      logIntervalId: _logIntervalId,
      pilotCode: pilotCode,
      pilot2Code: pilot2Code,
      maxAttenuation: _maxAttenuation,
      minAttenuation: _minAttenuation,
      currentAttenuation: _currentAttenuation,
      centerAttenuation: _centerAttenuation,
      hasDualPilot: _hasDualPilot,
    );
  }
}
