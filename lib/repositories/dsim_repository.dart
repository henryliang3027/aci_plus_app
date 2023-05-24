import 'dart:async';
import 'dart:io';
import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/crc16_calculate.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';

enum DataKey {
  typeNo,
  partNo,
  serialNumber,
  softwareVersion,
  location,
  dsimMode,
  currentPilot,
  logInterval,
  alarmRServerity,
  alarmTServertity,
  alarmPServerity,
  currentAttenuation,
  minAttenuation,
  normalAttenuation,
  maxAttenuation,
  historicalMinAttenuation,
  historicalMaxAttenuation,
  currentTemperature,
  minTemperature,
  maxTemperature,
  currentVoltage,
  minVoltage,
  maxVoltage,
  currentVoltageRipple,
  minVoltageRipple,
  maxVoltageRipple,
}

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
  DsimRepository() : _ble = FlutterReactiveBle() {
    _calculateCRCs();
  }
  final FlutterReactiveBle _ble;
  final scanDuration = 3; // sec
  late StreamController<ScanReport> _scanReportStreamController;
  StreamController<ConnectionReport> _connectionReportStreamController =
      StreamController<ConnectionReport>();
  StreamController<Map<DataKey, String>> _characteristicDataStreamController =
      StreamController<Map<DataKey, String>>();
  StreamSubscription<DiscoveredDevice>? _discoveredDeviceStreamSubscription;
  StreamSubscription<ConnectionStateUpdate>? _connectionStreamSubscription;
  StreamSubscription<List<int>>? _characteristicStreamSubscription;

  final _name1 = 'ACI03170078';
  final _name2 = 'ACI01160006';
  final _aciPrefix = 'ACI';
  final _serviceId = 'ffe0';
  final _characteristicId = 'ffe1';
  final List<List<int>> _commandCollection = [];
  int _commandIndex = 0;

  String _tempLocation = '';
  int _basicModeID = 0;
  String _basicCurrentPilot = '';
  int _basicCurrentPilotMode = 0;
  int _currentSettingMode = 0;
  int _alarmR = 0;
  int _alarmT = 0;
  int _alarmP = 0;
  String _basicInterval = '';

  Stream<ScanReport> get scannedDevices async* {
    // close connection before start scanning new device,
    // it is to solve device is not successfully disconnected after the app is closed
    await closeConnectionStream();

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
      }, onError: (_) {
        _scanReportStreamController.add(
          const ScanReport(
            scanStatus: ScanStatus.disable,
            discoveredDevice: null,
          ),
        );
      });
      yield* _scanReportStreamController.stream.timeout(
          Duration(
            seconds: scanDuration,
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
            connectionTimeout: const Duration(
              seconds: 10,
            ))
        .listen((connectionStateUpdate) async {
      _connectionReportStreamController.add(ConnectionReport(
          connectionState: connectionStateUpdate.connectionState));

      if (connectionStateUpdate.connectionState ==
          DeviceConnectionState.connected) {
        // initialize _characteristicDataStreamController
        _characteristicDataStreamController =
            StreamController<Map<DataKey, String>>();

        final qualifiedCharacteristic = QualifiedCharacteristic(
          serviceId: Uuid.parse(_serviceId),
          characteristicId: Uuid.parse(_characteristicId),
          deviceId: discoveredDevice.id,
        );

        _characteristicStreamSubscription = _ble
            .subscribeToCharacteristic(qualifiedCharacteristic)
            .listen((data) async {
          print('-----data received-----');
          print(data);

          List<int> rawData = data;
          _parseRawData(rawData);
          // _generateCharacteristicData(strData);

          _commandIndex += 1;

          if (_commandIndex < _commandCollection.length) {
            await _ble.writeCharacteristicWithoutResponse(
              qualifiedCharacteristic,
              value: _commandCollection[_commandIndex],
            );
          } else {
            _characteristicDataStreamController.close();
          }
        });

        // start to write first command
        _commandIndex = 0;
        await _ble.writeCharacteristicWithoutResponse(
          qualifiedCharacteristic,
          value: _commandCollection[_commandIndex],
        );
      }
    }, onError: (error) {
      print('Error: $error');
      _connectionReportStreamController.add(ConnectionReport(
        connectionState: DeviceConnectionState.disconnected,
        errorMessage: error,
      ));
    });
  }

  void _parseRawData(List<int> rawData) {
    switch (_commandIndex) {
      case 0:
        String typeNo = '';
        for (int i = 3; i < 15; i++) {
          typeNo += String.fromCharCode(rawData[i]);
        }
        _characteristicDataStreamController.add({DataKey.typeNo: typeNo});
        break;
      case 1:
        String partNo = 'DSIM';
        for (int i = 3; i < 14; i++) {
          partNo += String.fromCharCode(rawData[i]);
        }
        _characteristicDataStreamController.add({DataKey.partNo: partNo});
        break;
      case 2:
        String serialNumber = '';
        for (int i = 3; i < 15; i++) {
          serialNumber += String.fromCharCode(rawData[i]);
        }
        _characteristicDataStreamController
            .add({DataKey.serialNumber: serialNumber});
        break;
      case 3:
        int number = rawData[10]; // hardware status 4 bytes last bute

        // bit 0: RF detect Max, bit 1 : RF detect Min
        _alarmR = (number & 0x01) + (number & 0x02);

        // bit 6: Temperature Max, bit 1 : Temperature Min
        _alarmT = (number & 0x40) + (number & 0x80);

        // bit 4: Voltage 24v Max, bit 5 : Voltage 24v Min
        _alarmP = (number & 0x10) + (number & 0x20);

        _basicInterval = rawData[13].toString(); //time interval
        _basicInterval += " minutes";

        String softwareVersion = '';
        for (int i = 3; i < 6; i++) {
          softwareVersion += String.fromCharCode(rawData[i]);
        }

        _characteristicDataStreamController
            .add({DataKey.logInterval: _basicInterval});

        _characteristicDataStreamController
            .add({DataKey.softwareVersion: softwareVersion});
        break;
      case 4:
        //MGC Value 2Bytes
        int currentAttenuator = rawData[4] * 256 + rawData[5];

        _currentSettingMode = rawData[3];
        _basicCurrentPilot = rawData[7].toString();
        _basicCurrentPilotMode = rawData[8];

        _characteristicDataStreamController
            .add({DataKey.currentAttenuation: currentAttenuator.toString()});
        _characteristicDataStreamController.add({DataKey.minAttenuation: '0'});
        _characteristicDataStreamController
            .add({DataKey.maxAttenuation: '4095'});
        break;

      case 5:
        String dsimMode = '';
        String currentPilot = '';
        Alarm alarmRServerity = Alarm.medium;
        Alarm alarmTServerity = Alarm.medium;
        Alarm alarmPServerity = Alarm.medium;
        double currentTemperatureC;
        double currentTemperatureF;
        double current24V;
        switch (rawData[3]) //working mode
        {
          case 1:
            {
              _basicModeID = 1;
              dsimMode = "Align";
              break;
            }
          case 2:
            {
              _basicModeID = 2;
              dsimMode = "AGC";
              break;
            }
          case 3:
            {
              _basicModeID = 3;
              dsimMode = "TGC";
              break;
            }
          case 4:
            {
              _basicModeID = 4;
              dsimMode = "MGC";
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
          if (rawData[3] == 3) {
            if (_currentSettingMode == 1 || _currentSettingMode == 2) {
              // danger
              alarmRServerity = Alarm.danger;
            }
          }
        }

        if (alarmRServerity == Alarm.danger) {
          currentPilot = 'Loss';
        } else {
          currentPilot = _basicCurrentPilot;
          if (_basicCurrentPilotMode == 1) {
            currentPilot += ' IRC';
          } else {
            currentPilot += ' DIG';
          }
        }

        alarmTServerity = _alarmT > 0 ? Alarm.danger : Alarm.success;
        alarmPServerity = _alarmP > 0 ? Alarm.danger : Alarm.success;

        //Temperature
        currentTemperatureC = (rawData[10] * 256 + rawData[11]) / 10;
        currentTemperatureF = _convertToFahrenheit(currentTemperatureC);
        String currentTemperatureFC =
            '${currentTemperatureF.toStringAsFixed(1)}/$currentTemperatureC';

        //24V
        current24V = (rawData[8] * 256 + rawData[9]) / 10;

        _characteristicDataStreamController.add({DataKey.dsimMode: dsimMode});
        _characteristicDataStreamController
            .add({DataKey.currentPilot: currentPilot});
        _characteristicDataStreamController
            .add({DataKey.alarmRServerity: alarmRServerity.name});
        _characteristicDataStreamController
            .add({DataKey.alarmTServertity: alarmTServerity.name});
        _characteristicDataStreamController
            .add({DataKey.alarmPServerity: alarmPServerity.name});
        _characteristicDataStreamController
            .add({DataKey.currentTemperature: currentTemperatureFC});
        _characteristicDataStreamController
            .add({DataKey.currentVoltage: current24V.toString()});

        break;
      case 6:
        int centerAttenuation = rawData[11] * 256 + rawData[12];
        int currentVoltageRipple = rawData[9] * 256 + rawData[10]; //24VR

        _characteristicDataStreamController
            .add({DataKey.normalAttenuation: centerAttenuation.toString()});
        _characteristicDataStreamController.add(
            {DataKey.currentVoltageRipple: currentVoltageRipple.toString()});

        break;
      case 7:
        break;
      case 8:
        break;
      case 9:
        for (int i = 3; i < 15; i++) {
          _tempLocation += String.fromCharCode(rawData[i]);
        }
        break;
      case 10: // location2
        for (int i = 3; i < 15; i++) {
          _tempLocation += String.fromCharCode(rawData[i]);
        }
        break;
      case 11: // location3
        for (int i = 3; i < 15; i++) {
          _tempLocation += String.fromCharCode(rawData[i]);
        }
        break;
      case 12: // location1
        for (int i = 3; i < 7; i++) {
          if (rawData[i] != 0 && rawData[i] != 32) {
            // 32 is space
            _tempLocation += String.fromCharCode(rawData[i]);
          }
        }
        _characteristicDataStreamController
            .add({DataKey.location: _tempLocation});

        _tempLocation = '';
        break;
      case 13:
        break;
      default:
        break;
    }
  }

  void _calculateCRCs() {
    CRC16.calculateCRC16(command: Command.req00Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.req01Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.req02Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.req03Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.req04Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.req05Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.req06Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.req07Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.req08Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.location1, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.location2, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.location3, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.location4, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.req0DCmd, usDataLength: 6);

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
    ]);

    // print(_commandCollection[0]);
    // print(_commandCollection[1]);
    // print(_commandCollection[2]);
    // print(_commandCollection[3]);
    // print(_commandCollection[4]);
    // print(_commandCollection[5]);
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
}
