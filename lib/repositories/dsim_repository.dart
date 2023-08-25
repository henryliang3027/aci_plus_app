import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:dsim_app/core/characteristic_data.dart';
import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/command18.dart';
import 'package:dsim_app/core/crc16_calculate.dart';
import 'package:dsim_app/core/custom_style.dart';
import 'package:dsim_app/core/shared_preference_key.dart';
import 'package:dsim_app/repositories/dsim18_parser.dart';
import 'package:dsim_app/repositories/dsim_parser.dart';
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

class DsimRepository {
  DsimRepository() : _ble = FlutterReactiveBle();
  final FlutterReactiveBle _ble;
  final _scanTimeout = 3; // sec
  final _connectionTimeout = 30; //sec
  late StreamController<ScanReport> _scanReportStreamController;
  StreamController<ConnectionReport> _connectionReportStreamController =
      StreamController<ConnectionReport>();
  StreamController<Map<DataKey, String>> _characteristicDataStreamController =
      StreamController<Map<DataKey, String>>();
  StreamSubscription<DiscoveredDevice>? _discoveredDeviceStreamSubscription;
  StreamSubscription<ConnectionStateUpdate>? _connectionStreamSubscription;
  StreamSubscription<List<int>>? _characteristicStreamSubscription;
  late QualifiedCharacteristic _qualifiedCharacteristic;

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
  int _logIntervalId = 0;
  String _maxAttenuation = '';
  String _minAttenuation = '';
  String _centerAttenuation = '';
  String _currentAttenuation = '';

  // 記錄欲設定的 workingModeId
  int _workingModeId = 0;
  final int _agcWorkingModeSettingDuration = 30;

  bool _hasDualPilot = false;

  final int _commandExecutionTimeout = 10; // s
  final int _agcWorkingModeSettingTimeout = 40; // s
  Timer? _timeoutTimer;

  late Dsim18Parser _dsim18parser;
  late DsimParser _dsimParser;

  Future<void> checkBluetoothEnabled() async {
    await GPS.Location().requestService();
    await BluetoothEnable.enableBluetooth;
  }

  Stream<ScanReport> get scanReport async* {
    await checkBluetoothEnabled();

    bool isPermissionGranted = await _requestPermission();
    if (isPermissionGranted) {
      _scanReportStreamController = StreamController<ScanReport>();

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
      _scanReportStreamController.add(const ScanReport(
        scanStatus: ScanStatus.disable,
        discoveredDevice: null,
      ));
    }

    yield* _scanReportStreamController.stream;
  }

  Stream<ConnectionReport> get connectionStateReport async* {
    yield* _connectionReportStreamController.stream;
  }

  Stream<Map<DataKey, String>> get characteristicData async* {
    yield* _dsimParser.characteristicData;
  }

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

    if (_characteristicDataStreamController.hasListener) {
      if (!_characteristicDataStreamController.isClosed) {
        await _characteristicDataStreamController.close();
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
  }

  Future<int> requestMTU({required String deviceId, required int mtu}) async {
    final negotiatedMtu = await _ble.requestMtu(deviceId: deviceId, mtu: mtu);

    return negotiatedMtu;
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

          _characteristicDataStreamController =
              StreamController<Map<DataKey, String>>();

          _qualifiedCharacteristic = QualifiedCharacteristic(
            serviceId: Uuid.parse(_serviceId),
            characteristicId: Uuid.parse(_characteristicId),
            deviceId: discoveredDevice.id,
          );

          _dsim18parser = Dsim18Parser();
          _dsimParser = DsimParser(
              ble: _ble, qualifiedCharacteristic: _qualifiedCharacteristic);

          _characteristicStreamSubscription = _ble
              .subscribeToCharacteristic(_qualifiedCharacteristic)
              .listen((data) async {
            List<int> rawData = data;
            print(commandIndex);
            print('data length: ${rawData.length}');

            if (commandIndex <= 46) {
              _dsimParser.parseRawData(
                  commandIndex: commandIndex, rawData: rawData);
            } else if (commandIndex >= 180) {
              _dsim18parser.parseRawData(
                  commandIndex: commandIndex,
                  rawData: rawData,
                  completer: _completer);
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

  void clearCache() {
    _dsimParser.clearCache();
  }

  Future<dynamic> requestCommand1p8G0() async {
    commandIndex = 180;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G0');

    _writeSetCommandToCharacteristic(
        _dsim18parser.command18Collection[commandIndex - 180]);
    setTimeout(
        duration: Duration(seconds: _commandExecutionTimeout),
        name: 'cmd1p8G0');

    try {
      var (
        partName,
        partNo,
        serialNumber,
        firmwareVersion,
        mfgDate,
        coordinate
      ) = await _completer.future;
      cancelTimeout(name: '1p8G0');

      return [
        true,
        partName,
        partNo,
        serialNumber,
        firmwareVersion,
        mfgDate,
        coordinate,
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
      ];
    }
  }

  Future<dynamic> requestCommand1p8G1() async {
    commandIndex = 181;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G1');

    _writeSetCommandToCharacteristic(
        _dsim18parser.command18Collection[commandIndex - 180]);
    setTimeout(
        duration: Duration(seconds: _commandExecutionTimeout),
        name: 'cmd1p8G1');

    try {
      var (
        minTemperatureC,
        maxTemperatureC,
        minTemperatureF,
        maxTemperatureF,
        minVoltage,
        maxVoltage,
        location,
      ) = await _completer.future;
      cancelTimeout(name: '1p8G1');

      return [
        true,
        minTemperatureC,
        maxTemperatureC,
        minTemperatureF,
        maxTemperatureF,
        minVoltage,
        maxVoltage,
        location,
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
      ];
    }
  }

  Future<dynamic> requestCommand1p8G2() async {
    commandIndex = 182;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G2');

    _writeSetCommandToCharacteristic(
        _dsim18parser.command18Collection[commandIndex - 180]);
    setTimeout(
        duration: Duration(seconds: _commandExecutionTimeout),
        name: 'cmd1p8G2');

    try {
      var (
        alarmUSeverity,
        alarmTServerity,
        alarmPServerity,
        currentTemperatureC,
        currentTemperatureF,
        currentVoltage,
        currentRFInputTotalPower,
        currentRFOutputTotalPower,
        splitOption,
        fwdAgcMode,
        autoLevelControl,
      ) = await _completer.future;
      cancelTimeout(name: '1p8G2');

      return [
        true,
        alarmUSeverity,
        alarmTServerity,
        alarmPServerity,
        currentTemperatureC,
        currentTemperatureF,
        currentVoltage,
        currentRFInputTotalPower,
        currentRFOutputTotalPower,
        splitOption,
        fwdAgcMode,
        autoLevelControl,
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
        '',
        '',
      ];
    }
  }

  // commandIndex range from 183 to 192;
  Future<dynamic> requestCommand1p8GForLogChunk(int chunkIndex) async {
    commandIndex = chunkIndex;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8GForLogChunk');

    _writeSetCommandToCharacteristic(
        _dsim18parser.command18Collection[commandIndex - 180]);
    setTimeout(
        duration: Duration(seconds: _commandExecutionTimeout),
        name: '1p8GForLogChunk');

    try {
      var (
        historicalMinTemperatureC,
        historicalMaxTemperatureC,
        historicalMinTemperatureF,
        historicalMaxTemperatureF,
        historicalMinVoltage,
        historicalMaxVoltage,
      ) = await _completer.future;
      cancelTimeout(name: '1p8GForLogChunk');

      return [
        true,
        historicalMinTemperatureC,
        historicalMaxTemperatureC,
        historicalMinTemperatureF,
        historicalMaxTemperatureF,
        historicalMinVoltage,
        historicalMaxVoltage,
      ];
    } catch (e) {
      return [
        false,
        '',
        '',
        '',
      ];
    }
  }

  Future<dynamic> requestCommand1p8GAlarm() async {
    commandIndex = 204;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G_Alarm');

    _writeSetCommandToCharacteristic(_dsim18parser.command18Collection[2]);
    setTimeout(
        duration: Duration(seconds: _commandExecutionTimeout),
        name: '1p8G_Alarm');

    try {
      var (
        alarmUSeverity,
        alarmTServerity,
        alarmPServerity,
      ) = await _completer.future;
      cancelTimeout(name: '1p8G_Alarm');

      return [
        true,
        alarmUSeverity,
        alarmTServerity,
        alarmPServerity,
      ];
    } catch (e) {
      return [
        false,
        '',
        '',
        '',
      ];
    }
  }

  Future<dynamic> set1p8GMaxTemperature(String temperature) async {
    commandIndex = 300;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    double dMaxTemperature = double.parse(temperature);

    int max = (dMaxTemperature * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, max, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setMaxTemperatureCmd[7] = bytes[0];
    Command18.setMaxTemperatureCmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setMaxTemperatureCmd,
      usDataLength: Command18.setMaxTemperatureCmd.length - 2,
    );

    _writeSetCommandToCharacteristic(Command18.setMaxTemperatureCmd);
    setTimeout(
        duration: Duration(seconds: _commandExecutionTimeout),
        name: '1p8G$commandIndex');

    try {
      bool isDone = await _completer.future;
      cancelTimeout(name: '1p8G$commandIndex');
      return isDone;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GMinTemperature(String temperature) async {
    commandIndex = 301;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    double dMinTemperature = double.parse(temperature);

    int min = (dMinTemperature * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, min, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setMinTemperatureCmd[7] = bytes[0];
    Command18.setMinTemperatureCmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setMinTemperatureCmd,
      usDataLength: Command18.setMinTemperatureCmd.length - 2,
    );

    _writeSetCommandToCharacteristic(Command18.setMinTemperatureCmd);
    setTimeout(
        duration: Duration(seconds: _commandExecutionTimeout),
        name: '1p8G$commandIndex');

    try {
      bool isDone = await _completer.future;
      cancelTimeout(name: '1p8G$commandIndex');
      return isDone;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GMaxVoltage(String valtage) async {
    commandIndex = 302;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    double dMaxVoltage = double.parse(valtage);

    int max = (dMaxVoltage * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, max, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setMaxVoltageCmd[7] = bytes[0];
    Command18.setMaxVoltageCmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setMaxVoltageCmd,
      usDataLength: Command18.setMaxVoltageCmd.length - 2,
    );

    _writeSetCommandToCharacteristic(Command18.setMaxVoltageCmd);
    setTimeout(
        duration: Duration(seconds: _commandExecutionTimeout),
        name: '1p8G$commandIndex');

    try {
      bool isDone = await _completer.future;
      cancelTimeout(name: '1p8G$commandIndex');
      return isDone;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GMinVoltage(String valtage) async {
    commandIndex = 303;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    double dMinVoltage = double.parse(valtage);

    int min = (dMinVoltage * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, min, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setMinVoltageCmd[7] = bytes[0];
    Command18.setMinVoltageCmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setMinVoltageCmd,
      usDataLength: Command18.setMinVoltageCmd.length - 2,
    );

    _writeSetCommandToCharacteristic(Command18.setMinVoltageCmd);
    setTimeout(
        duration: Duration(seconds: _commandExecutionTimeout),
        name: '1p8G$commandIndex');

    try {
      bool isDone = await _completer.future;
      cancelTimeout(name: '1p8G$commandIndex');
      return isDone;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GLocation(String location) async {
    commandIndex = 304;
    _completer = Completer<dynamic>();

    List<int> locationBytes = [];

    print('get data from request command 1p8G$commandIndex');

    for (int code in location.codeUnits) {
      // Create a ByteData object with a length of 2 bytes
      ByteData byteData = ByteData(2);

      // Set the Unicode code unit in the byte array
      byteData.setInt16(0, code, Endian.little);

      // Convert the ByteData to a Uint8List
      Uint8List bytes = Uint8List.view(byteData.buffer);

      locationBytes.addAll(bytes);
    }

    for (int i = 0; i < locationBytes.length; i++) {
      Command18.setLocationCmd[i + 7] = locationBytes[i];
    }

    for (int i = locationBytes.length; i < 96; i += 2) {
      Command18.setLocationCmd[i + 7] = 0x20;
      Command18.setLocationCmd[i + 8] = 0x00;
    }

    // String output = '';
    // print('length: ${Command18.setLocationCmd.length}');
    // for (int i = 0; i < Command18.setLocationCmd.length; i++) {
    //   // print(Command18.setLocationCmd[i].toRadixString(16));
    //   output += Command18.setLocationCmd[i].toRadixString(16) + ' ';
    // }

    // print(output);

    CRC16.calculateCRC16(
      command: Command18.setLocationCmd,
      usDataLength: Command18.setLocationCmd.length - 2,
    );

    _writeSetCommandToCharacteristic(Command18.setLocationCmd);
    setTimeout(
        duration: Duration(seconds: _commandExecutionTimeout),
        name: '1p8G$commandIndex');

    try {
      bool isDone = await _completer.future;
      cancelTimeout(name: '1p8G$commandIndex');
      return isDone;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GCoordinates(String coordinates) async {
    commandIndex = 305;
    _completer = Completer<dynamic>();

    List<int> coordinatesBytes = [];

    print('get data from request command 1p8G$commandIndex');

    coordinatesBytes = coordinates.codeUnits;

    for (int i = 0; i < coordinatesBytes.length; i++) {
      Command18.setCoordinatesCmd[i + 7] = coordinatesBytes[i];
    }

    for (int i = coordinatesBytes.length; i < 39; i++) {
      Command18.setCoordinatesCmd[i + 7] = 0x20;
    }

    CRC16.calculateCRC16(
      command: Command18.setCoordinatesCmd,
      usDataLength: Command18.setCoordinatesCmd.length - 2,
    );

    _writeSetCommandToCharacteristic(Command18.setCoordinatesCmd);
    setTimeout(
        duration: Duration(seconds: _commandExecutionTimeout),
        name: '1p8G$commandIndex');

    try {
      bool isDone = await _completer.future;
      cancelTimeout(name: '1p8G$commandIndex');
      return isDone;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateCharacteristics() async {
    List<dynamic> resultOf1p8G0 = await requestCommand1p8G0();

    if (resultOf1p8G0[0]) {
      _characteristicDataStreamController
          .add({DataKey.coordinates: resultOf1p8G0[6]});
    }

    List<dynamic> resultOf1p8G1 = await requestCommand1p8G1();

    if (resultOf1p8G1[0]) {
      _characteristicDataStreamController
          .add({DataKey.minTemperatureC: resultOf1p8G1[1]});
      _characteristicDataStreamController
          .add({DataKey.maxTemperatureC: resultOf1p8G1[2]});
      _characteristicDataStreamController
          .add({DataKey.minTemperatureF: resultOf1p8G1[3]});
      _characteristicDataStreamController
          .add({DataKey.maxTemperatureF: resultOf1p8G1[4]});
      _characteristicDataStreamController
          .add({DataKey.minVoltage: resultOf1p8G1[5]});
      _characteristicDataStreamController
          .add({DataKey.maxVoltage: resultOf1p8G1[6]});
      _characteristicDataStreamController
          .add({DataKey.location: resultOf1p8G1[7]});
    }

    List<dynamic> resultOf1p8G2 = await requestCommand1p8G2();
    if (resultOf1p8G2[0]) {
      _characteristicDataStreamController
          .add({DataKey.alarmUSeverity: resultOf1p8G2[1]});
      _characteristicDataStreamController
          .add({DataKey.alarmTSeverity: resultOf1p8G2[2]});
      _characteristicDataStreamController
          .add({DataKey.alarmPSeverity: resultOf1p8G2[3]});
      _characteristicDataStreamController
          .add({DataKey.currentTemperatureC: resultOf1p8G2[4]});
      _characteristicDataStreamController
          .add({DataKey.currentTemperatureF: resultOf1p8G2[5]});
      _characteristicDataStreamController
          .add({DataKey.currentVoltage: resultOf1p8G2[6]});
    }
  }

  Future<dynamic> requestCommand0() async {
    return _dsimParser.requestCommand0();
  }

  Future<dynamic> requestCommand1() async {
    return _dsimParser.requestCommand1();
  }

  Future<dynamic> requestCommand2() async {
    return _dsimParser.requestCommand2();
  }

  Future<dynamic> requestCommand3() async {
    return _dsimParser.requestCommand3();
  }

  Future<dynamic> requestCommand4() async {
    return _dsimParser.requestCommand4();
  }

  Future<dynamic> requestCommand5() async {
    return _dsimParser.requestCommand5();
  }

  Future<dynamic> requestCommand6() async {
    return _dsimParser.requestCommand6();
  }

  // location
  Future requestCommand9To12() async {
    return _dsimParser.requestCommand9To12();
  }

  Future requestCommandForLogChunk(int chunkIndex) async {
    return _dsimParser.requestCommandForLogChunk(chunkIndex);
  }

  Future requestCommand14To29() async {
    return _dsimParser.requestCommand14To29();
  }

  Future requestCommand30To37() async {
    return _dsimParser.requestCommand30To37();
  }

  Future<bool> setLocation(String location) async {
    return _dsimParser.setLocation(location: location);
  }

  Future<bool> setTGCCableLength({
    required int currentAttenuation,
    required String tgcCableLength,
    required String pilotChannel,
    required String pilotMode,
    required int logIntervalId,
  }) async {
    return _dsimParser.setTGCCableLength(
      currentAttenuation: currentAttenuation,
      tgcCableLength: tgcCableLength,
      pilotChannel: pilotChannel,
      pilotMode: pilotMode,
      logIntervalId: logIntervalId,
    );
  }

  Future<bool> setLogInterval({
    required int logIntervalId,
  }) async {
    return _dsimParser.setLogInterval(logIntervalId: logIntervalId);
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
    return _dsimParser.setWorkingMode(
      workingMode: workingMode,
      currentAttenuation: currentAttenuation,
      tgcCableLength: tgcCableLength,
      pilotChannel: pilotChannel,
      pilotMode: pilotMode,
      logIntervalId: logIntervalId,
    );
  }

  // iOS 跟 Android 的 set command 方式不一樣
  Future<void> _writeSetCommandToCharacteristic(List<int> value) async {
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
    } catch (e) {
      if (!_completer.isCompleted) {
        _completer.completeError('Write command failed');
        print('Write command failed');
      }
    }
  }

  Future<dynamic> exportRecords() async {
    return _dsimParser.exportRecords();
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

  List<List<String>> formatEvent() {
    List<int> counts = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    List<List<String>> csvContent = List<List<String>>.generate(
      128,
      (index) => List<String>.generate(
        13,
        (index) => '',
        growable: false,
      ),
      growable: false,
    );

    for (Event event in _events) {
      String formattedDateTime =
          DateFormat('yyyy-MM-dd HH:mm').format(event.dateTime);

      switch (event.code) {
        case 0x0000:
          {
            //EventCPEstart 0
            int index = 0;
            if (event.parameter > 0) {
              csvContent[counts[index]][index] =
                  '$formattedDateTime@${event.parameter}';
            } else {
              csvContent[counts[index]][index] = formattedDateTime;
            }
            counts[index]++;
            break;
          }
        case 0x0001:
          {
            //EventCPEstop 1
            int index = 1;
            if (event.parameter > 0) {
              csvContent[counts[index]][index] =
                  '$formattedDateTime@${event.parameter}';
            } else {
              csvContent[counts[index]][index] = formattedDateTime;
            }
            counts[index]++;
            break;
          }
        case 0x0002:
          {
            //Event24VOver 2
            int index = 2;
            if (event.parameter > 0) {
              csvContent[counts[index]][index] =
                  '$formattedDateTime@${event.parameter / 10}';
            } else {
              csvContent[counts[index]][index] = formattedDateTime;
            }
            counts[index]++;
            break;
          }
        case 0x0004:
          {
            //Event24VLess 3
            int index = 3;
            if (event.parameter > 0) {
              csvContent[counts[index]][index] =
                  '$formattedDateTime@${event.parameter / 10}';
            } else {
              csvContent[counts[index]][index] = formattedDateTime;
            }
            counts[index]++;
            break;
          }
        case 0x0008:
          {
            //EventTemOver 4
            int index = 4;
            if (event.parameter > 0) {
              csvContent[counts[index]][index] =
                  '$formattedDateTime@${event.parameter / 10}';
            } else {
              csvContent[counts[index]][index] = formattedDateTime;
            }
            counts[index]++;
            break;
          }
        case 0x0010:
          {
            //EventTemLess 5
            int index = 5;
            if (event.parameter > 0) {
              csvContent[counts[index]][index] =
                  '$formattedDateTime@${event.parameter / 10}';
            } else {
              csvContent[counts[index]][index] = formattedDateTime;
            }
            counts[index]++;
            break;
          }
        case 0x0020:
          {
            //EventSSIOver 6
            int index = 6;
            if (event.parameter > 0) {
              csvContent[counts[index]][index] =
                  '$formattedDateTime@${event.parameter}';
            } else {
              csvContent[counts[index]][index] = formattedDateTime;
            }
            counts[index]++;
            break;
          }
        case 0x0040:
          {
            //EventSSILess 7
            int index = 7;
            if (event.parameter > 0) {
              csvContent[counts[index]][index] =
                  '$formattedDateTime@${event.parameter}';
            } else {
              csvContent[counts[index]][index] = formattedDateTime;
            }
            counts[index]++;
            break;
          }
        case 0x0080:
          {
            //Event24VriOv 8
            int index = 8;
            if (event.parameter > 0) {
              csvContent[counts[index]][index] =
                  '$formattedDateTime@${event.parameter}';
            } else {
              csvContent[counts[index]][index] = formattedDateTime;
            }
            counts[index]++;
            break;
          }
        case 0x0100:
          {
            //EventAlPiLos 9
            int index = 9;
            if (event.parameter > 0) {
              csvContent[counts[index]][index] =
                  '$formattedDateTime@${event.parameter}';
            } else {
              csvContent[counts[index]][index] = formattedDateTime;
            }
            counts[index]++;
            break;
          }
        case 0x0200:
          {
            //EventAGPiLos 10
            int index = 10;
            if (event.parameter > 0) {
              csvContent[counts[index]][index] =
                  '$formattedDateTime@${event.parameter}';
            } else {
              csvContent[counts[index]][index] = formattedDateTime;
            }
            counts[index]++;
            break;
          }
        case 0x1000:
          {
            //EventCTRPlin 11 used
            int index = 11;
            if (event.parameter > 0) {
              csvContent[counts[index]][index] =
                  '$formattedDateTime@${event.parameter}';
            } else {
              csvContent[counts[index]][index] = formattedDateTime;
            }
            counts[index]++;
            break;
          }
        case 0x2000:
          {
            //EventCTRPlout 12 used
            int index = 12;
            if (event.parameter > 0) {
              csvContent[counts[index]][index] =
                  '$formattedDateTime@${event.parameter}';
            } else {
              csvContent[counts[index]][index] = formattedDateTime;
            }
            counts[index]++;
            break;
          }
      } //switch
    }

    return csvContent;
  }

  List<List<DateValuePair>> getDateValueCollectionOfLogs() {
    return _dsimParser.getDateValueCollectionOfLogs();
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

    print('$name completed (timeout canceled)');
  }

  Future<bool> writePilotCode(String pilotCode) async {
    return _dsimParser.writePilotCode(pilotCode);
  }

  Future<bool> writePilot2Code(String pilot2Code) async {
    return _dsimParser.writePilot2Code(pilot2Code);
  }

  Future<String> readPilotCode() async {
    return _dsimParser.readPilotCode();
  }

  Future<String> readPilot2Code() async {
    return _dsimParser.readPilot2Code();
  }

  Future<SettingData> getSettingData() async {
    return _dsimParser.getSettingData();
  }
}
