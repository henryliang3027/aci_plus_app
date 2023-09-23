import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/command18.dart';
import 'package:dsim_app/core/crc16_calculate.dart';
import 'package:dsim_app/core/custom_style.dart';
import 'package:dsim_app/core/shared_preference_key.dart';
import 'package:dsim_app/repositories/ble_client.dart';
import 'package:dsim_app/repositories/dsim18_parser.dart';
import 'package:dsim_app/repositories/unit_converter.dart';
import 'package:excel/excel.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_speed_chart/speed_chart.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';

enum Alarm {
  success,
  danger,
  medium,
}

class Log1p8G {
  const Log1p8G({
    required this.dateTime,
    required this.temperature,
    required this.voltage,
    required this.rfOutputLowPilot,
    required this.rfOutputHighPilot,
    required this.voltageRipple,
  });

  final DateTime dateTime;
  final double temperature;
  final double voltage;
  final double rfOutputLowPilot;
  final double rfOutputHighPilot;
  final int voltageRipple;
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
  DsimRepository()
      : _bleClient = BLEClient(),
        _dsim18parser = Dsim18Parser(),
        _unitConverter = UnitConverter() {
    _calculateCRCs();
  }
  final BLEClient _bleClient;
  final _scanTimeout = 3; // sec
  final _connectionTimeout = 30; //sec
  // late StreamController<ScanReport> _scanReportStreamController;
  // StreamController<ConnectionReport> _connectionReportStreamController =
  //     StreamController<ConnectionReport>();
  // StreamController<Map<DataKey, String>> _characteristicDataStreamController =
  //     StreamController<Map<DataKey, String>>();
  // StreamSubscription<DiscoveredDevice>? _discoveredDeviceStreamSubscription;
  // StreamSubscription<ConnectionStateUpdate>? _connectionStreamSubscription;
  // StreamSubscription<List<int>>? _characteristicStreamSubscription;
  // late QualifiedCharacteristic _qualifiedCharacteristic;

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
  // final List<Log1p8G> _log1p8Gs = [];
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

  final Dsim18Parser _dsim18parser;
  final UnitConverter _unitConverter;

  Stream<ScanReport> get scanReport async* {
    yield* _bleClient.scanReport;
  }

  Stream<ConnectionReport> get connectionStateReport async* {
    yield* _bleClient.connectionStateReport;
  }

  Stream<Map<DataKey, String>> get characteristicData async* {
    yield* _bleClient.characteristicData;
  }

  Future<void> connectToDevice(DiscoveredDevice discoveredDevice) {
    return _bleClient.connectToDevice(discoveredDevice);
  }

  void clearCache() {
    _completer = Completer<dynamic>();
    cancelTimeout(name: 'set timeout from clearCache');
    _logs.clear();
    _rawLog.clear();
    _events.clear();
    _rawEvent.clear();
    _hasDualPilot = false;

    // clear setting form data
    _location = '';
    _tgcCableLength = '';
    _workingMode = '';
    _logIntervalId = 0;
    _maxAttenuation = '';
    _minAttenuation = '';
    _centerAttenuation = '';
    _currentAttenuation = '';

    commandIndex = 0;
    endIndex = 37;
  }

  Future<void> closeScanStream() async {
    await _bleClient.closeScanStream();
  }

  Future<void> closeConnectionStream() async {
    await _bleClient.closeConnectionStream();
  }

  Future<int> requestMTU({
    required String deviceId,
    int mtu = 247,
  }) async {
    return _bleClient.requestMTU(
        commandIndex: -1, value: _commandCollection[0], deviceId: deviceId);
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
    }

    if (!_completer.isCompleted) {
      _completer.complete(true);
    }
  }

  void _parseLog() {
    // Stopwatch swatch = Stopwatch();
    // swatch.start();

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
        print('$_nowTimeCount: $timeStamp');

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

    if (commandIndex < 29) {
      if (!_completer.isCompleted) {
        _completer.complete(true);
      }
    } else {
      if (_logs.isNotEmpty) {
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

        String minTemperatureF = _unitConverter
                .converCelciusToFahrenheit(minTemperature)
                .toStringAsFixed(1) +
            CustomStyle.fahrenheitUnit;

        String maxTemperatureF = _unitConverter
                .converCelciusToFahrenheit(maxTemperature)
                .toStringAsFixed(1) +
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
      } else {
        if (!_completer.isCompleted) {
          _completer.complete((
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
          ));
        }
      }
    }
    // print('parse log executed in ${swatch.elapsed.inMilliseconds}');
  }

  void _parseRawData(List<int> rawData) {
    switch (commandIndex) {
      case -1:
        if (!_completer.isCompleted) {
          _completer.complete(rawData.length);
        }
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
        int number = rawData[10]; // hardware status 4 bytes last byte

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
        Alarm alarmRSeverity = Alarm.medium;
        Alarm alarmTSeverity = Alarm.medium;
        Alarm alarmPSeverity = Alarm.medium;
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
          alarmRSeverity = Alarm.medium;
        } else {
          if (_alarmR > 0) {
            // danger
            alarmRSeverity = Alarm.danger;
          } else {
            // success
            alarmRSeverity = Alarm.success;
          }
        }
        if (rawData[3] == 3) {
          if (_currentSettingMode == 1 || _currentSettingMode == 2) {
            // danger
            alarmRSeverity = Alarm.danger;
          }
        }

        if (alarmRSeverity == Alarm.danger) {
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

        alarmTSeverity = _alarmT > 0 ? Alarm.danger : Alarm.success;
        alarmPSeverity = _alarmP > 0 ? Alarm.danger : Alarm.success;

        //Temperature
        currentTemperatureC = (rawData[10] * 256 + rawData[11]) / 10;
        currentTemperatureF =
            _unitConverter.converCelciusToFahrenheit(currentTemperatureC);
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
            alarmRSeverity.name,
            alarmTSeverity.name,
            alarmPSeverity.name,
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

  Future<dynamic> requestCommand1p8G0() async {
    commandIndex = 180;

    print('get data from request command 1p8G0');

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _dsim18parser.command18Collection[commandIndex - 180],
      );

      A1P8G0 a1p8g0 = _dsim18parser.parseA1P8G0(rawData);

      return [
        true,
        <DataKey, String>{
          DataKey.partName: a1p8g0.partName,
          DataKey.partNo: a1p8g0.partNo,
          DataKey.serialNumber: a1p8g0.serialNumber,
          DataKey.firmwareVersion: a1p8g0.firmwareVersion,
          DataKey.mfgDate: a1p8g0.mfgDate,
          DataKey.coordinates: a1p8g0.coordinate,
        },
      ];
    } catch (e) {
      return [
        false,
      ];
    }
  }

  Future<dynamic> requestCommand1p8G1() async {
    commandIndex = 181;
    _completer = Completer<dynamic>();

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _dsim18parser.command18Collection[commandIndex - 180],
      );

      A1P8G1 a1p8g1 = _dsim18parser.parseA1P8G1(rawData);

      return [
        true,
        <DataKey, String>{
          DataKey.minTemperatureC: a1p8g1.minTemperatureC,
          DataKey.maxTemperatureC: a1p8g1.maxTemperatureC,
          DataKey.minTemperatureF: a1p8g1.minTemperatureF,
          DataKey.maxTemperatureF: a1p8g1.maxTemperatureF,
          DataKey.minVoltage: a1p8g1.minVoltage,
          DataKey.maxVoltage: a1p8g1.maxVoltage,
          DataKey.minVoltageRipple: a1p8g1.minVoltageRipple,
          DataKey.maxVoltageRipple: a1p8g1.maxVoltageRipple,
          DataKey.minRFOutputPower: a1p8g1.minRFOutputPower,
          DataKey.maxRFOutputPower: a1p8g1.maxRFOutputPower,
          DataKey.ingressSetting2: a1p8g1.ingressSetting2,
          DataKey.ingressSetting3: a1p8g1.ingressSetting3,
          DataKey.ingressSetting4: a1p8g1.ingressSetting4,
          DataKey.tgcCableLength: a1p8g1.tgcCableLength,
          DataKey.splitOption: a1p8g1.splitOption,
          DataKey.pilotFrequencyMode: a1p8g1.pilotFrequencyMode,
          DataKey.agcMode: a1p8g1.agcMode,
          DataKey.alcMode: a1p8g1.alcMode,
          DataKey.firstChannelLoadingFrequency:
              a1p8g1.firstChannelLoadingFrequency,
          DataKey.lastChannelLoadingFrequency:
              a1p8g1.lastChannelLoadingFrequency,
          DataKey.firstChannelLoadingLevel: a1p8g1.firstChannelLoadingLevel,
          DataKey.lastChannelLoadingLevel: a1p8g1.lastChannelLoadingLevel,
          DataKey.pilotFrequency1: a1p8g1.pilotFrequency1,
          DataKey.pilotFrequency2: a1p8g1.pilotFrequency2,
          DataKey.pilotFrequency1AlarmState: a1p8g1.pilotFrequency1AlarmState,
          DataKey.pilotFrequency2AlarmState: a1p8g1.pilotFrequency2AlarmState,
          DataKey.rfOutputPilotLowFrequencyAlarmState:
              a1p8g1.rfOutputPilotLowFrequencyAlarmState,
          DataKey.rfOutputPilotHighFrequencyAlarmState:
              a1p8g1.rfOutputPilotHighFrequencyAlarmState,
          DataKey.temperatureAlarmState: a1p8g1.temperatureAlarmState,
          DataKey.voltageAlarmState: a1p8g1.voltageAlarmState,
          DataKey.splitOptionAlarmState: a1p8g1.splitOptionAlarmState,
          DataKey.voltageRippleAlarmState: a1p8g1.voltageRippleAlarmState,
          DataKey.rfOutputPowerAlarmState: a1p8g1.outputPowerAlarmState,
          DataKey.location: a1p8g1.location,
          DataKey.logInterval: a1p8g1.logInterval,
          DataKey.inputAttenuation: a1p8g1.inputAttenuation,
          DataKey.inputEqualizer: a1p8g1.inputEqualizer,
          DataKey.dsVVA2: a1p8g1.dsVVA2,
          DataKey.dsSlope2: a1p8g1.dsSlope2,
          DataKey.inputAttenuation2: a1p8g1.inputAttenuation2,
          DataKey.outputEqualizer: a1p8g1.outputEqualizer,
          DataKey.dsVVA3: a1p8g1.dsVVA3,
          DataKey.dsVVA4: a1p8g1.dsVVA4,
          DataKey.outputAttenuation: a1p8g1.outputAttenuation,
          DataKey.inputAttenuation3: a1p8g1.inputAttenuation3,
          DataKey.inputAttenuation4: a1p8g1.inputAttenuation4,
          DataKey.usTGC: a1p8g1.usTGC,
        }
      ];
    } catch (e) {
      return [
        false,
      ];
    }
  }

  Future<dynamic> requestCommand1p8G2() async {
    commandIndex = 182;
    _completer = Completer<dynamic>();

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _dsim18parser.command18Collection[commandIndex - 180],
      );

      A1P8G2 a1p8g2 = _dsim18parser.parseA1P8G2(rawData);

      return [
        true,
        <DataKey, String>{
          DataKey.currentTemperatureC: a1p8g2.currentTemperatureC,
          DataKey.currentTemperatureF: a1p8g2.currentTemperatureF,
          DataKey.currentVoltage: a1p8g2.currentVoltage,
          DataKey.currentVoltageRipple: a1p8g2.currentVoltageRipple,
          DataKey.currentRFInputPower: a1p8g2.currentRFInputPower,
          DataKey.currentRFOutputPower: a1p8g2.currentRFOutputPower,
          DataKey.currentWorkingMode: a1p8g2.currentWorkingMode,
          DataKey.currentDetectedSplitOption: a1p8g2.currentDetectedSplitOption,
          DataKey.unitStatusAlarmSeverity: a1p8g2.unitStatusAlarmSeverity,
          DataKey.rfInputPilotLowFrequencyAlarmSeverity:
              a1p8g2.rfInputPilotLowFrequencyAlarmSeverity,
          DataKey.rfInputPilotHighFrequencyAlarmSeverity:
              a1p8g2.rfInputPilotHighFrequencyAlarmSeverity,
          DataKey.rfOutputPilotLowFrequencyAlarmSeverity:
              a1p8g2.rfOutputPilotLowFrequencyAlarmSeverity,
          DataKey.rfOutputPilotHighFrequencyAlarmSeverity:
              a1p8g2.rfOutputPilotHighFrequencyAlarmSeverity,
          DataKey.temperatureAlarmSeverity: a1p8g2.temperatureAlarmSeverity,
          DataKey.voltageAlarmSeverity: a1p8g2.voltageAlarmSeverity,
          DataKey.splitOptionAlarmSeverity: a1p8g2.splitOptionAlarmSeverity,
          DataKey.voltageRippleAlarmSeverity: a1p8g2.voltageRippleAlarmSeverity,
          DataKey.outputPowerAlarmSeverity: a1p8g2.outputPowerAlarmSeverity,
        }
      ];
    } catch (e) {
      return [
        false,
      ];
    }
  }

  Future<dynamic> requestCommand1p8G3() async {
    commandIndex = 183;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G3');

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _dsim18parser.command18Collection[commandIndex - 180],
      );

      List<RFInOut> rfInOuts = _dsim18parser.parseRFInOut(rawData);

      return [
        true,
        rfInOuts,
      ];
    } catch (e) {
      return [
        false,
      ];
    }
  }

  Future<dynamic> testForLogChunk(int chunkIndex) async {
    await Future.delayed(Duration(seconds: 1));

    return [true, true];
  }

  // commandIndex range from 184 to 193;
  // commandIndex = 184 時獲取最新的1024筆Log的統計資料跟 log
  Future<dynamic> requestCommand1p8GForLogChunk(int chunkIndex) async {
    commandIndex = chunkIndex + 184;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8GForLogChunk');

    // _bleClient.writeSetCommandToCharacteristic(
    //     _dsim18parser.command18Collection[commandIndex - 180]);
    setTimeout(
        duration: Duration(seconds: _commandExecutionTimeout),
        name: '1p8GForLogChunk');

    if (commandIndex == 184) {
      // _log1p8Gs.clear();
      try {
        var (
          historicalMinTemperatureC,
          historicalMaxTemperatureC,
          historicalMinTemperatureF,
          historicalMaxTemperatureF,
          historicalMinVoltage,
          historicalMaxVoltage,
          historicalMinVoltageRipple,
          historicalMaxVoltageRipple,
          log1p8Gs,
        ) = await _completer.future;
        // 將第一組 log 加入 _log1p8Gs
        // _log1p8Gs.addAll(log1p8Gs);
        cancelTimeout(name: '1p8GForLogChunk');

        bool hasNextChunk = log1p8Gs.isNotEmpty ? true : false;

        return [
          true,
          hasNextChunk,
          log1p8Gs,
          <DataKey, String>{
            DataKey.historicalMinTemperatureC: historicalMinTemperatureC,
            DataKey.historicalMaxTemperatureC: historicalMaxTemperatureC,
            DataKey.historicalMinTemperatureF: historicalMinTemperatureF,
            DataKey.historicalMaxTemperatureF: historicalMaxTemperatureF,
            DataKey.historicalMinVoltage: historicalMinVoltage,
            DataKey.historicalMaxVoltage: historicalMaxVoltage,
            DataKey.historicalMinVoltageRipple: historicalMinVoltageRipple,
            DataKey.historicalMaxVoltageRipple: historicalMaxVoltageRipple,
          }
        ];
      } catch (e) {
        return [
          false,
          false,
        ];
      }
    } else {
      try {
        // 將其他組 log 加入 _log1p8Gs
        List<Log1p8G> log1p8Gs = await _completer.future;
        // _log1p8Gs.addAll(log1p8Gs);
        cancelTimeout(name: '1p8GForLogChunk');

        bool hasNextChunk = log1p8Gs.isNotEmpty ? true : false;

        return [
          true,
          hasNextChunk,
          log1p8Gs,
        ];
      } catch (e) {
        return [
          false,
          false,
        ];
      }
    }
  }

  Future<dynamic> requestCommand1p8GAlarm() async {
    commandIndex = 204;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G_Alarm');

    // _bleClient
    //     .writeSetCommandToCharacteristic(_dsim18parser.command18Collection[2]);
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

  List<List<ValuePair>> get1p8GDateValueCollectionOfLogs(
      List<Log1p8G> log1p8Gs) {
    List<ValuePair> temperatureDataList = [];
    List<ValuePair> rfOutputLowPilotDataList = [];
    List<ValuePair> rfOutputHighPilotDataList = [];
    List<ValuePair> voltageDataList = [];
    List<ValuePair> voltageRippleDataList = [];

    for (Log1p8G log1p8G in log1p8Gs.reversed) {
      temperatureDataList.add(ValuePair(
        x: log1p8G.dateTime,
        y: log1p8G.temperature,
      ));
      rfOutputLowPilotDataList.add(ValuePair(
        x: log1p8G.dateTime,
        y: log1p8G.rfOutputLowPilot,
      ));
      rfOutputHighPilotDataList.add(ValuePair(
        x: log1p8G.dateTime,
        y: log1p8G.rfOutputHighPilot,
      ));
      voltageDataList.add(ValuePair(
        x: log1p8G.dateTime,
        y: log1p8G.voltage,
      ));
      voltageRippleDataList.add(ValuePair(
        x: log1p8G.dateTime,
        y: log1p8G.voltageRipple.toDouble(),
      ));
    }

    return [
      temperatureDataList,
      rfOutputLowPilotDataList,
      rfOutputHighPilotDataList,
      voltageDataList,
      voltageRippleDataList,
    ];
  }

  List<List<ValuePair>> get1p8GValueCollectionOfRFInOut(
      List<RFInOut> rfInOuts) {
    List<ValuePair> rfInputs = [];
    List<ValuePair> rfOutputs = [];

    for (int i = 0; i < rfInOuts.length; i++) {
      int frequency = 261 + 6 * i;

      RFInOut rfInOut = rfInOuts[i];

      rfOutputs.add(ValuePair(
        x: frequency,
        y: rfInOut.output,
      ));

      rfInputs.add(ValuePair(
        x: frequency,
        y: rfInOut.input,
      ));
    }

    return [
      rfOutputs,
      rfInputs,
    ];
  }

  Future<dynamic> export1p8GRecords(List<Log1p8G> log1p8Gs) async {
    List<dynamic> result = await _dsim18parser.export1p8GRecords(log1p8Gs);
    return result;
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

    // _bleClient.writeSetCommandToCharacteristic(Command18.setMaxTemperatureCmd);
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

    // _bleClient.writeSetCommandToCharacteristic(Command18.setMinTemperatureCmd);
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

    // _bleClient.writeSetCommandToCharacteristic(Command18.setMaxVoltageCmd);
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

    // _bleClient.writeSetCommandToCharacteristic(Command18.setMinVoltageCmd);
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

  Future<dynamic> set1p8GMaxVoltageRipple(String valtageRipple) async {
    commandIndex = 304;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    double dMaxVoltageRipple = double.parse(valtageRipple);

    int max = dMaxVoltageRipple.toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, max, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setMaxVoltageRippleCmd[7] = bytes[0];
    Command18.setMaxVoltageRippleCmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setMaxVoltageRippleCmd,
      usDataLength: Command18.setMaxVoltageRippleCmd.length - 2,
    );

    // _bleClient
    //     .writeSetCommandToCharacteristic(Command18.setMaxVoltageRippleCmd);
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

  Future<dynamic> set1p8GMinVoltageRipple(String valtageRipple) async {
    commandIndex = 305;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    double dMinVoltageRipple = double.parse(valtageRipple);

    int min = dMinVoltageRipple.toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, min, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setMinVoltageRippleCmd[7] = bytes[0];
    Command18.setMinVoltageRippleCmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setMinVoltageRippleCmd,
      usDataLength: Command18.setMinVoltageRippleCmd.length - 2,
    );

    // _bleClient
    //     .writeSetCommandToCharacteristic(Command18.setMinVoltageRippleCmd);
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

  Future<dynamic> set1p8GMaxRFOutputPower(String outputPower) async {
    commandIndex = 306;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    double dMaxOutputPower = double.parse(outputPower);

    int min = (dMaxOutputPower * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, min, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setMaxOutputPowerCmd[7] = bytes[0];
    Command18.setMaxOutputPowerCmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setMaxOutputPowerCmd,
      usDataLength: Command18.setMaxOutputPowerCmd.length - 2,
    );

    // _bleClient.writeSetCommandToCharacteristic(Command18.setMaxOutputPowerCmd);
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

  Future<dynamic> set1p8GMinRFOutputPower(String outputPower) async {
    commandIndex = 307;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    double dMinOutputPower = double.parse(outputPower);

    int min = (dMinOutputPower * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, min, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setMinOutputPowerCmd[7] = bytes[0];
    Command18.setMinOutputPowerCmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setMinOutputPowerCmd,
      usDataLength: Command18.setMinOutputPowerCmd.length - 2,
    );

    // _bleClient.writeSetCommandToCharacteristic(Command18.setMinOutputPowerCmd);
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

  Future<dynamic> set1p8GReturnIngress2(String ingress) async {
    commandIndex = 308;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    int ingressNumber = int.parse(ingress);

    Command18.setReturnIngress2Cmd[7] = ingressNumber;

    CRC16.calculateCRC16(
      command: Command18.setReturnIngress2Cmd,
      usDataLength: Command18.setReturnIngress2Cmd.length - 2,
    );

    // _bleClient.writeSetCommandToCharacteristic(Command18.setReturnIngress2Cmd);
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

  Future<dynamic> set1p8GReturnIngress3(String ingress) async {
    commandIndex = 309;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    int ingressNumber = int.parse(ingress);

    Command18.setReturnIngress3Cmd[7] = ingressNumber;

    CRC16.calculateCRC16(
      command: Command18.setReturnIngress3Cmd,
      usDataLength: Command18.setReturnIngress3Cmd.length - 2,
    );

    // _bleClient.writeSetCommandToCharacteristic(Command18.setReturnIngress3Cmd);
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

  Future<dynamic> set1p8GReturnIngress4(String ingress) async {
    commandIndex = 310;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    int ingressNumber = int.parse(ingress);

    Command18.setReturnIngress4Cmd[7] = ingressNumber;

    CRC16.calculateCRC16(
      command: Command18.setReturnIngress4Cmd,
      usDataLength: Command18.setReturnIngress4Cmd.length - 2,
    );

    // _bleClient.writeSetCommandToCharacteristic(Command18.setReturnIngress4Cmd);
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

  Future<dynamic> set1p8GTGCCableLength(String value) async {
    commandIndex = 313;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    int intValue = int.parse(value);

    Command18.setTGCCableLengthCmd[7] = intValue;

    CRC16.calculateCRC16(
      command: Command18.setTGCCableLengthCmd,
      usDataLength: Command18.setTGCCableLengthCmd.length - 2,
    );

    // _bleClient.writeSetCommandToCharacteristic(Command18.setTGCCableLengthCmd);
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

  Future<dynamic> set1p8GSplitOption(String splitOption) async {
    commandIndex = 314;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    int splitOptionNumber = int.parse(splitOption);

    Command18.setSplitOptionCmd[7] = splitOptionNumber;

    CRC16.calculateCRC16(
      command: Command18.setSplitOptionCmd,
      usDataLength: Command18.setSplitOptionCmd.length - 2,
    );

    // _bleClient.writeSetCommandToCharacteristic(Command18.setSplitOptionCmd);
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

  Future<dynamic> set1p8GPilotFrequencyMode(String value) async {
    commandIndex = 315;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    int intValue = int.parse(value);

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, intValue, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setPilotFrequencyModeCmd[7] = bytes[0];

    CRC16.calculateCRC16(
      command: Command18.setPilotFrequencyModeCmd,
      usDataLength: Command18.setPilotFrequencyModeCmd.length - 2,
    );

    // _bleClient
    //     .writeSetCommandToCharacteristic(Command18.setPilotFrequencyModeCmd);
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

  Future<dynamic> set1p8GForwardAGCMode(String value) async {
    commandIndex = 316;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    int intValue = int.parse(value);

    Command18.setFowardAGCModeCmd[7] = intValue;

    CRC16.calculateCRC16(
      command: Command18.setFowardAGCModeCmd,
      usDataLength: Command18.setFowardAGCModeCmd.length - 2,
    );

    // _bleClient.writeSetCommandToCharacteristic(Command18.setFowardAGCModeCmd);
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

  Future<dynamic> set1p8GALCMode(String value) async {
    commandIndex = 317;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    int intValue = int.parse(value);

    Command18.setALCModeCmd[7] = intValue;

    CRC16.calculateCRC16(
      command: Command18.setALCModeCmd,
      usDataLength: Command18.setALCModeCmd.length - 2,
    );

    // _bleClient.writeSetCommandToCharacteristic(Command18.setALCModeCmd);
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

  Future<dynamic> set1p8GFirstChannelLoadingFrequency(String value) async {
    commandIndex = 318;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    int intValue = int.parse(value);

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, intValue, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setFirstChannelLoadingFrequencyCmd[7] = bytes[0];
    Command18.setFirstChannelLoadingFrequencyCmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setFirstChannelLoadingFrequencyCmd,
      usDataLength: Command18.setFirstChannelLoadingFrequencyCmd.length - 2,
    );

    //  _bleClient.writeSetCommandToCharacteristic(
    //     Command18.setFirstChannelLoadingFrequencyCmd);
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

  Future<dynamic> set1p8GLastChannelLoadingFrequency(String value) async {
    commandIndex = 319;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    int intValue = int.parse(value);

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, intValue, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setLastChannelLoadingFrequencyCmd[7] = bytes[0];
    Command18.setLastChannelLoadingFrequencyCmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setLastChannelLoadingFrequencyCmd,
      usDataLength: Command18.setLastChannelLoadingFrequencyCmd.length - 2,
    );

    //  _bleClient.writeSetCommandToCharacteristic(
    //     Command18.setLastChannelLoadingFrequencyCmd);
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

  Future<dynamic> set1p8GFirstChannelLoadingLevel(String value) async {
    commandIndex = 320;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    double doubleValue = double.parse(value);

    int intValue = (doubleValue * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, intValue, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setFirstChannelLoadingLevelCmd[7] = bytes[0];
    Command18.setFirstChannelLoadingLevelCmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setFirstChannelLoadingLevelCmd,
      usDataLength: Command18.setFirstChannelLoadingLevelCmd.length - 2,
    );

    //  _bleClient.writeSetCommandToCharacteristic(
    //     Command18.setFirstChannelLoadingLevelCmd);
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

  Future<dynamic> set1p8GLastChannelLoadingLevel(String value) async {
    commandIndex = 321;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    double doubleValue = double.parse(value);

    int intValue = (doubleValue * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, intValue, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setLastChannelLoadingLevelCmd[7] = bytes[0];
    Command18.setLastChannelLoadingLevelCmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setLastChannelLoadingLevelCmd,
      usDataLength: Command18.setLastChannelLoadingLevelCmd.length - 2,
    );

    //  _bleClient.writeSetCommandToCharacteristic(
    //     Command18.setLastChannelLoadingLevelCmd);
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

  Future<dynamic> set1p8GPilotFrequency1(String value) async {
    commandIndex = 322;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    int intValue = int.parse(value);

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, intValue, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setPilotFrequency1Cmd[7] = bytes[0];
    Command18.setPilotFrequency1Cmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setPilotFrequency1Cmd,
      usDataLength: Command18.setPilotFrequency1Cmd.length - 2,
    );

    // _bleClient.writeSetCommandToCharacteristic(Command18.setPilotFrequency1Cmd);
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

  Future<dynamic> set1p8GPilotFrequency2(String value) async {
    commandIndex = 323;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    int intValue = int.parse(value);

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, intValue, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setPilotFrequency2Cmd[7] = bytes[0];
    Command18.setPilotFrequency2Cmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setPilotFrequency2Cmd,
      usDataLength: Command18.setPilotFrequency2Cmd.length - 2,
    );

    // _bleClient.writeSetCommandToCharacteristic(Command18.setPilotFrequency2Cmd);
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

  Future<dynamic> setInputPilotLowFrequencyAlarmState(String isEnable) async {
    commandIndex = 324;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18.setInputPilotLowFrequencyAlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18.setInputPilotLowFrequencyAlarmStateCmd,
      usDataLength: Command18.setInputPilotLowFrequencyAlarmStateCmd.length - 2,
    );

    // _bleClient.writeSetCommandToCharacteristic(
    //     Command18.setInputPilotLowFrequencyAlarmStateCmd);
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

  Future<dynamic> setInputPilotHighFrequencyAlarmState(String isEnable) async {
    commandIndex = 325;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18.setInputPilotHighFrequencyAlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18.setInputPilotHighFrequencyAlarmStateCmd,
      usDataLength:
          Command18.setInputPilotHighFrequencyAlarmStateCmd.length - 2,
    );

    // _bleClient.writeSetCommandToCharacteristic(
    //     Command18.setInputPilotHighFrequencyAlarmStateCmd);
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

  Future<dynamic> setOutputPilotLowFrequencyAlarmState(String isEnable) async {
    commandIndex = 326;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18.setOutputPilotLowFrequencyAlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18.setOutputPilotLowFrequencyAlarmStateCmd,
      usDataLength:
          Command18.setOutputPilotLowFrequencyAlarmStateCmd.length - 2,
    );

    //  _bleClient.writeSetCommandToCharacteristic(
    //     Command18.setOutputPilotLowFrequencyAlarmStateCmd);
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

  Future<dynamic> setOutputPilotHighFrequencyAlarmState(String isEnable) async {
    commandIndex = 327;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18.setOutputPilotHighFrequencyAlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18.setOutputPilotHighFrequencyAlarmStateCmd,
      usDataLength:
          Command18.setOutputPilotHighFrequencyAlarmStateCmd.length - 2,
    );

    // _bleClient.writeSetCommandToCharacteristic(
    //     Command18.setOutputPilotHighFrequencyAlarmStateCmd);
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

  Future<dynamic> set1p8GTemperatureAlarmState(String isEnable) async {
    commandIndex = 328;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18.setTemperatureAlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18.setTemperatureAlarmStateCmd,
      usDataLength: Command18.setTemperatureAlarmStateCmd.length - 2,
    );

    // _bleClient
    //     .writeSetCommandToCharacteristic(Command18.setTemperatureAlarmStateCmd);
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

  Future<dynamic> set1p8GVoltageAlarmState(String isEnable) async {
    commandIndex = 329;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18.setVoltageAlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18.setVoltageAlarmStateCmd,
      usDataLength: Command18.setVoltageAlarmStateCmd.length - 2,
    );

    // _bleClient
    //     .writeSetCommandToCharacteristic(Command18.setVoltageAlarmStateCmd);
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

  Future<dynamic> set1p8GSplitOptionAlarmState(String isEnable) async {
    commandIndex = 334;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18.setSplitOptionAlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18.setSplitOptionAlarmStateCmd,
      usDataLength: Command18.setSplitOptionAlarmStateCmd.length - 2,
    );

    // _bleClient
    //     .writeSetCommandToCharacteristic(Command18.setSplitOptionAlarmStateCmd);
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

  Future<dynamic> set1p8GVoltageRippleAlarmState(String isEnable) async {
    commandIndex = 335;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18.setVoltageRippleAlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18.setVoltageRippleAlarmStateCmd,
      usDataLength: Command18.setVoltageRippleAlarmStateCmd.length - 2,
    );

    //  _bleClient.writeSetCommandToCharacteristic(
    //     Command18.setVoltageRippleAlarmStateCmd);
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

  Future<dynamic> set1p8GRFOutputPowerAlarmState(String isEnable) async {
    commandIndex = 336;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18.setRFOutputPowerAlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18.setRFOutputPowerAlarmStateCmd,
      usDataLength: Command18.setRFOutputPowerAlarmStateCmd.length - 2,
    );

    //  _bleClient.writeSetCommandToCharacteristic(
    //     Command18.setRFOutputPowerAlarmStateCmd);
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
    commandIndex = 337;
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

    // _bleClient.writeSetCommandToCharacteristic(Command18.setLocationCmd);
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

  Future<dynamic> set1p8GLogInterval(String logInterval) async {
    commandIndex = 338;
    _completer = Completer<dynamic>();

    int interval = int.parse(logInterval);

    print('get data from request command 1p8G$commandIndex');

    Command18.setLogIntervalCmd[7] = interval;

    CRC16.calculateCRC16(
      command: Command18.setLogIntervalCmd,
      usDataLength: Command18.setLogIntervalCmd.length - 2,
    );

    // _bleClient.writeSetCommandToCharacteristic(Command18.setLogIntervalCmd);
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

  Future<dynamic> set1p8GForwardInputAttenuation(String strValue) async {
    commandIndex = 339;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    double doubleValue = double.parse(strValue);

    int intValue = (doubleValue * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, intValue, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setForwardInputAttenuationCmd[7] = bytes[0];
    Command18.setForwardInputAttenuationCmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setForwardInputAttenuationCmd,
      usDataLength: Command18.setForwardInputAttenuationCmd.length - 2,
    );

    //  _bleClient.writeSetCommandToCharacteristic(
    //     Command18.setForwardInputAttenuationCmd);
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

  Future<dynamic> set1p8GForwardInputEqualizer(String strValue) async {
    commandIndex = 340;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    double doubleValue = double.parse(strValue);

    int intValue = (doubleValue * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, intValue, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setForwardInputEqualizerCmd[7] = bytes[0];
    Command18.setForwardInputEqualizerCmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setForwardInputEqualizerCmd,
      usDataLength: Command18.setForwardInputEqualizerCmd.length - 2,
    );

    // _bleClient
    //     .writeSetCommandToCharacteristic(Command18.setForwardInputEqualizerCmd);
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

  Future<dynamic> set1p8GDSVVA2(String strValue) async {
    commandIndex = 341;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    double doubleValue = double.parse(strValue);

    int intValue = (doubleValue * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, intValue, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setDSVVA2Cmd[7] = bytes[0];
    Command18.setDSVVA2Cmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setDSVVA2Cmd,
      usDataLength: Command18.setDSVVA2Cmd.length - 2,
    );

    // _bleClient.writeSetCommandToCharacteristic(Command18.setDSVVA2Cmd);
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

  Future<dynamic> set1p8GDSSlope2(String strValue) async {
    commandIndex = 342;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    double doubleValue = double.parse(strValue);

    int intValue = (doubleValue * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, intValue, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setDSSlope2Cmd[7] = bytes[0];
    Command18.setDSSlope2Cmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setDSSlope2Cmd,
      usDataLength: Command18.setDSSlope2Cmd.length - 2,
    );

    // _bleClient.writeSetCommandToCharacteristic(Command18.setDSSlope2Cmd);
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

  Future<dynamic> set1p8GReturnInputAttenuation2(String strValue) async {
    commandIndex = 343;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    double doubleValue = double.parse(strValue);

    int intValue = (doubleValue * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, intValue, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setReturnInputAttenuation2Cmd[7] = bytes[0];
    Command18.setReturnInputAttenuation2Cmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setReturnInputAttenuation2Cmd,
      usDataLength: Command18.setReturnInputAttenuation2Cmd.length - 2,
    );

    //  _bleClient.writeSetCommandToCharacteristic(
    //     Command18.setReturnInputAttenuation2Cmd);
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

  Future<dynamic> set1p8GReturnOutputEqualizer(String strValue) async {
    commandIndex = 344;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    double doubleValue = double.parse(strValue);

    int intValue = (doubleValue * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, intValue, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setReturnOutputEqualizerCmd[7] = bytes[0];
    Command18.setReturnOutputEqualizerCmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setReturnOutputEqualizerCmd,
      usDataLength: Command18.setReturnOutputEqualizerCmd.length - 2,
    );

    // _bleClient
    //     .writeSetCommandToCharacteristic(Command18.setReturnOutputEqualizerCmd);
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

  Future<dynamic> set1p8DSVVA3(String strValue) async {
    commandIndex = 345;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    double doubleValue = double.parse(strValue);

    int intValue = (doubleValue * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, intValue, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setDSVVA3Cmd[7] = bytes[0];
    Command18.setDSVVA3Cmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setDSVVA3Cmd,
      usDataLength: Command18.setDSVVA3Cmd.length - 2,
    );

    // _bleClient.writeSetCommandToCharacteristic(Command18.setDSVVA3Cmd);
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

  Future<dynamic> set1p8DSVVA4(String strValue) async {
    commandIndex = 346;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    double doubleValue = double.parse(strValue);

    int intValue = (doubleValue * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, intValue, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setDSVVA4Cmd[7] = bytes[0];
    Command18.setDSVVA4Cmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setDSVVA4Cmd,
      usDataLength: Command18.setDSVVA4Cmd.length - 2,
    );

    // _bleClient.writeSetCommandToCharacteristic(Command18.setDSVVA4Cmd);
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

  Future<dynamic> set1p8GReturnOutputAttenuation(String strValue) async {
    commandIndex = 347;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    double doubleValue = double.parse(strValue);

    int intValue = (doubleValue * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, intValue, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setReturnOutputAttenuationCmd[7] = bytes[0];
    Command18.setReturnOutputAttenuationCmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setReturnOutputAttenuationCmd,
      usDataLength: Command18.setReturnOutputAttenuationCmd.length - 2,
    );

    //  _bleClient.writeSetCommandToCharacteristic(
    //     Command18.setReturnOutputAttenuationCmd);
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

  Future<dynamic> set1p8GReturnInputAttenuation3(String strValue) async {
    commandIndex = 348;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    double doubleValue = double.parse(strValue);

    int intValue = (doubleValue * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, intValue, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setReturnInputAttenuation3Cmd[7] = bytes[0];
    Command18.setReturnInputAttenuation3Cmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setReturnInputAttenuation3Cmd,
      usDataLength: Command18.setReturnInputAttenuation3Cmd.length - 2,
    );

    //  _bleClient.writeSetCommandToCharacteristic(
    //     Command18.setReturnInputAttenuation3Cmd);
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

  Future<dynamic> set1p8GReturnInputAttenuation4(String strValue) async {
    commandIndex = 349;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    double doubleValue = double.parse(strValue);

    int intValue = (doubleValue * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, intValue, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setReturnInputAttenuation4Cmd[7] = bytes[0];
    Command18.setReturnInputAttenuation4Cmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setReturnInputAttenuation4Cmd,
      usDataLength: Command18.setReturnInputAttenuation4Cmd.length - 2,
    );

    //  _bleClient.writeSetCommandToCharacteristic(
    //     Command18.setReturnInputAttenuation4Cmd);
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

  Future<dynamic> set1p8USTGC(String strValue) async {
    commandIndex = 350;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    double doubleValue = double.parse(strValue);

    int intValue = (doubleValue * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, intValue, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setUSTGCCmd[7] = bytes[0];
    Command18.setUSTGCCmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setUSTGCCmd,
      usDataLength: Command18.setUSTGCCmd.length - 2,
    );

    // _bleClient.writeSetCommandToCharacteristic(Command18.setUSTGCCmd);
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
    commandIndex = 352;
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

    // _bleClient.writeSetCommandToCharacteristic(Command18.setCoordinatesCmd);
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

  // 設定藍芽串口的資料傳輸延遲時間, 單位為 ms
  // 例如 MTU = 244, 則每傳輸244byte 就會休息 ms 時間再傳下一筆
  Future<dynamic> set1p8GTransmitDelayTime() async {
    commandIndex = 353;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    int ms = 26;

    if (Platform.isIOS) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;

      // ipad version ex: 16.6.1
      // ios version ex: 16.5
      double version = double.parse(iosDeviceInfo.systemVersion.split('.')[0]);

      if (version >= 16) {
        ms = 26;
      } else {
        ms = 59;
      }
    } else {
      // Android
      ms = 26;
    }

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, ms, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setTransmitDelayTimeCmd[7] = bytes[0];
    Command18.setTransmitDelayTimeCmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setTransmitDelayTimeCmd,
      usDataLength: Command18.setTransmitDelayTimeCmd.length - 2,
    );

    // _bleClient
    //     .writeSetCommandToCharacteristic(Command18.setTransmitDelayTimeCmd);
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

  Future<dynamic> set1p8GNowDateTime() async {
    commandIndex = 354;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    DateTime dateTime = DateTime.now();

    int year = dateTime.year;

    // Convert the integer to bytes
    ByteData yearByteData = ByteData(2);
    yearByteData.setInt16(0, year, Endian.little); // little endian
    Uint8List yearBytes = Uint8List.view(yearByteData.buffer);

    int month = dateTime.month;
    int day = dateTime.day;
    int hour = dateTime.hour;
    int minute = dateTime.minute;

    Command18.setNowDateTimeCmd[7] = yearBytes[0];
    Command18.setNowDateTimeCmd[8] = yearBytes[1];
    Command18.setNowDateTimeCmd[9] = month;
    Command18.setNowDateTimeCmd[10] = day;
    Command18.setNowDateTimeCmd[11] = hour;
    Command18.setNowDateTimeCmd[12] = minute;

    CRC16.calculateCRC16(
      command: Command18.setNowDateTimeCmd,
      usDataLength: Command18.setNowDateTimeCmd.length - 2,
    );

    // _bleClient.writeSetCommandToCharacteristic(Command18.setNowDateTimeCmd);
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
      // _characteristicDataStreamController
      //     .add(Map<DataKey, String>.from(resultOf1p8G0[1]));
    }

    List<dynamic> resultOf1p8G1 = await requestCommand1p8G1();

    if (resultOf1p8G1[0]) {
      // _characteristicDataStreamController
      // .add(Map<DataKey, String>.from(resultOf1p8G1[1]));
    }

    List<dynamic> resultOf1p8G2 = await requestCommand1p8G2();
    if (resultOf1p8G2[0]) {
      // _characteristicDataStreamController
      //     .add(Map<DataKey, String>.from(resultOf1p8G2[1]));
    }
  }

  Future<dynamic> requestCommand0() async {
    commandIndex = 0;
    _completer = Completer<dynamic>();

    print('get data from request command 0');

    //_bleClient.writeSetCommandToCharacteristic(_commandCollection[commandIndex]);
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
    //_bleClient.writeSetCommandToCharacteristic(_commandCollection[commandIndex]);
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
    //_bleClient.writeSetCommandToCharacteristic(_commandCollection[commandIndex]);
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
    //_bleClient.writeSetCommandToCharacteristic(_commandCollection[commandIndex]);
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
    //_bleClient.writeSetCommandToCharacteristic(_commandCollection[commandIndex]);
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
    //_bleClient.writeSetCommandToCharacteristic(_commandCollection[commandIndex]);
    setTimeout(
        duration: Duration(seconds: _commandExecutionTimeout), name: 'cmd5');

    try {
      var (
        String workingMode,
        String currentPilot,
        String pilotMode,
        String alarmRSeverity,
        String alarmTSeverity,
        String alarmPSeverity,
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
        alarmRSeverity,
        alarmTSeverity,
        alarmPSeverity,
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
    //_bleClient.writeSetCommandToCharacteristic(_commandCollection[commandIndex]);
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
      // _bleClient
      //     .writeSetCommandToCharacteristic(_commandCollection[commandIndex]);
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

  Future requestCommandForLogChunk(int chunkIndex) async {
    commandIndex = chunkIndex;
    _completer = Completer<dynamic>();

    print('get data from request command $chunkIndex');
    // _stopwatch.reset();
    // _stopwatch.start();
    //_bleClient.writeSetCommandToCharacteristic(_commandCollection[commandIndex]);
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

        cancelTimeout(name: 'cmd$chunkIndex');

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
        print('cmd$chunkIndex done');
        cancelTimeout(name: 'cmd$chunkIndex');
        if (!isDone) {
          return [false, '', '', '', '', '', '', '', '', '', ''];
        } else {
          return [true, '', '', '', '', '', '', '', '', '', ''];
        }
      } catch (e) {
        return [false, '', '', '', '', '', '', '', '', '', ''];
      }
    }
  }

  Future requestCommand14To29() async {
    for (int i = 14; i <= 29; i++) {
      commandIndex = i;
      _completer = Completer<dynamic>();

      print('get data from request command $i');
      // _stopwatch.reset();
      // _stopwatch.start();
      // _bleClient
      //     .writeSetCommandToCharacteristic(_commandCollection[commandIndex]);
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
          print('cmd$i done');
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
      // _bleClient
      //     .writeSetCommandToCharacteristic(_commandCollection[commandIndex]);
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
        // _bleClient.writeSetCommandToCharacteristic(
        //   Command.setLocACmd,
        // );
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
        // _bleClient.writeSetCommandToCharacteristic(
        //   Command.setLocBCmd,
        // );
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
        // _bleClient.writeSetCommandToCharacteristic(
        //   Command.setLocCCmd,
        // );
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

    for (int unit in location.codeUnits) {
      //如果超出 ascii 的範圍則回傳 false
      if (unit > 255) {
        return false;
      }
    }

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
    // _bleClient.writeSetCommandToCharacteristic(
    //   Command.setLoc9Cmd,
    // );
    setTimeout(
        duration: Duration(seconds: _commandExecutionTimeout),
        name: 'cmd set location');

    // 設定後重新讀取 location 來比對是否設定成功
    try {
      bool isDone = await _completer.future;
      cancelTimeout(name: 'cmd set location');

      if (isDone) {
        List<dynamic> resultOfGetLocation = await requestCommand9To12();

        if (resultOfGetLocation[0]) {
          if (location == resultOfGetLocation[1]) {
            // _characteristicDataStreamController
            //     .add({DataKey.location: resultOfGetLocation[1]});
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
    // _bleClient.writeSetCommandToCharacteristic(Command.set04Cmd);
    setTimeout(
        duration: Duration(seconds: _commandExecutionTimeout),
        name: 'cmd set tgc cable length');

    // 設定後重新讀取 tgc cable length 來比對是否設定成功
    try {
      bool isDone = await _completer.future;
      cancelTimeout(name: 'cmd set tgc cable length');

      if (isDone) {
        List<dynamic> resultOfCommand4 = await requestCommand4();
        List<dynamic> resultOfCommand5 = await requestCommand5();

        if (resultOfCommand4[0] && resultOfCommand5[0]) {
          if (tgcCableLength == resultOfCommand4[4]) {
            // _characteristicDataStreamController
            //     .add({DataKey.tgcCableLength: resultOfCommand4[4]});

            // _characteristicDataStreamController
            //     .add({DataKey.workingMode: resultOfCommand5[1]});

            _tgcCableLength = resultOfCommand4[4];
            _workingMode = resultOfCommand5[1];
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
    // _bleClient.writeSetCommandToCharacteristic(Command.set04Cmd);
    setTimeout(
        duration: Duration(seconds: _commandExecutionTimeout),
        name: 'cmd set log interval');

    // 設定後重新讀取 log interval 來比對是否設定成功
    try {
      bool isDone = await _completer.future;
      cancelTimeout(name: 'cmd set log interval');

      if (isDone) {
        List<dynamic> result = await requestCommand3();

        if (result[0]) {
          if (logIntervalId.toString() == result[1]) {
            // _characteristicDataStreamController
            //     .add({DataKey.logInterval: result[1]});
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
    // _bleClient.writeSetCommandToCharacteristic(Command.set04Cmd);

    if (_workingModeId == 1) {
      // AGC
      setTimeout(
          duration: Duration(seconds: _agcWorkingModeSettingTimeout),
          name: 'cmd set working mode');
    } else {
      setTimeout(
          duration: Duration(seconds: _commandExecutionTimeout),
          name: 'cmd set working mode');
    }

    // 設定後重新讀取 working mode 來比對是否設定成功
    try {
      bool isDone = await _completer.future;
      cancelTimeout(name: 'cmd set working mode');

      if (isDone) {
        List<dynamic> result = await requestCommand5();

        if (result[0]) {
          if (workingMode == result[1]) {
            // _characteristicDataStreamController
            //     .add({DataKey.workingMode: result[1]});
            // _characteristicDataStreamController
            //     .add({DataKey.currentPilot: result[2]});
            // _characteristicDataStreamController
            //     .add({DataKey.currentPilotMode: result[3]});

            _workingMode = result[1];
            _currentAttenuation = currentAttenuation.toString();

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

  // // iOS 跟 Android 的 set command 方式不一樣
  // Future<void> writeSetCommandToCharacteristic(List<int> value) async {
  //   await _bleClient.writeSetCommandToCharacteristic(value);
  // }

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
    List<List<String>> eventContent = formatEvent();
    for (int i = 0; i < eventContent.length; i++) {
      List<String> row = eventContent[i];
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
    String filename = 'log_and_event_$timeStamp';
    String extension = '.xlsx';

    if (Platform.isIOS) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String fullWrittenPath = '$appDocPath/$filename$extension';
      File f = File(fullWrittenPath);
      await f.writeAsBytes(fileBytes!);
      return [
        true,
        filename,
        fullWrittenPath,
      ];
    } else if (Platform.isAndroid) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String fullWrittenPath = '$appDocPath/$filename$extension';
      File f = File(fullWrittenPath);
      await f.writeAsBytes(fileBytes!);

      return [
        true,
        filename,
        fullWrittenPath,
      ];
    } else {
      return [
        false,
        '',
        'write file failed, export function not implement on ${Platform.operatingSystem} '
      ];
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

  DateTime timeStampToDateTime(int timeStamp) {
    int adjustedMillisecond =
        DateTime.now().millisecondsSinceEpoch - timeStamp * 60000;
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(adjustedMillisecond);

    return dateTime;
  }

  List<List<ValuePair>> getDateValueCollectionOfLogs() {
    List<ValuePair> attenuationDataList = [];
    List<ValuePair> temperatureDataList = [];
    List<ValuePair> pilotDataList = [];
    List<ValuePair> voltageDataList = [];
    List<ValuePair> voltageRippleDataList = [];
    for (Log log in _logs) {
      attenuationDataList.add(ValuePair(
        x: log.dateTime,
        y: log.attenuation.toDouble(),
      ));
      temperatureDataList.add(ValuePair(
        x: log.dateTime,
        y: log.temperature.toDouble(),
      ));
      pilotDataList.add(ValuePair(
        x: log.dateTime,
        y: log.pilot.toDouble(),
      ));
      voltageDataList.add(ValuePair(
        x: log.dateTime,
        y: log.voltage,
      ));
      voltageRippleDataList.add(ValuePair(
        x: log.dateTime,
        y: log.voltageRipple.toDouble(),
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

    print('$name completed (timeout canceled)');
  }

  Future<bool> writePilotCode(String pilotCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result =
        await prefs.setString(SharedPreferenceKey.pilotCode.name, pilotCode);
    return result;
  }

  Future<bool> writePilot2Code(String pilot2Code) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result =
        await prefs.setString(SharedPreferenceKey.pilot2Code.name, pilot2Code);
    return result;
  }

  Future<String> readPilotCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String pilotCode =
        prefs.getString(SharedPreferenceKey.pilotCode.name) ?? 'GG<@';
    return pilotCode;
  }

  Future<String> readPilot2Code() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String pilot2Code =
        prefs.getString(SharedPreferenceKey.pilot2Code.name) ?? 'C<A';
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

    // for (List<int> command in _commandCollection) {
    //   List<String> hex = [
    //     for (int num in command) ...[num.toRadixString(16)]
    //   ];
    //   print('${_commandCollection.indexOf(command)}: $hex}');
    // }
  }
}
