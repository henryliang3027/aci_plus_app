import 'dart:async';

import 'package:dsim_app/core/custom_style.dart';

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

class DsimParser {
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
  final int _logGettingTimeout = 20; // s
  final int _agcWorkingModeSettingTimeout = 40; // s
  Timer? _timeoutTimer;
  Stopwatch _stopwatch = Stopwatch();

  void parseRawData({
    required int commandIndex,
    required List<int> rawData,
    required Completer completer,
  }) {
    switch (commandIndex) {
      case 0:
        String typeNo = '';
        for (int i = 3; i < 15; i++) {
          typeNo += String.fromCharCode(rawData[i]);
        }
        typeNo = typeNo.trim();

        if (!completer.isCompleted) {
          completer.complete(typeNo);
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

        if (!completer.isCompleted) {
          completer.complete(partNo);
        }
        break;
      case 2:
        String serialNumber = '';
        for (int i = 3; i < 15; i++) {
          serialNumber += String.fromCharCode(rawData[i]);
        }
        serialNumber = serialNumber.trim();

        if (!completer.isCompleted) {
          completer.complete(serialNumber);
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

        if (!completer.isCompleted) {
          completer.complete((_basicInterval, firmwareVersion));
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

        if (!completer.isCompleted) {
          completer.complete((
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

        if (!completer.isCompleted) {
          completer.complete((
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

        if (!completer.isCompleted) {
          completer.complete(
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
        if (!completer.isCompleted) {
          completer.complete(partOfLocation);
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
        if (!completer.isCompleted) {
          completer.complete(partOfLocation);
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
        if (!completer.isCompleted) {
          completer.complete(partOfLocation);
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

        if (!completer.isCompleted) {
          completer.complete(partOfLocation);
        }

        break;
      default:
        break;
    }
  }

  void parseLog({
    required commandIndex,
    required Completer completer,
  }) {
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
      if (!completer.isCompleted) {
        completer.complete(true);
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

        if (!completer.isCompleted) {
          completer.complete((
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
        if (!completer.isCompleted) {
          completer.complete((
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

  double _convertToFahrenheit(double celcius) {
    double fahrenheit = (celcius * 1.8) + 32;
    return fahrenheit;
  }

  DateTime timeStampToDateTime(int timeStamp) {
    int adjustedMillisecond =
        DateTime.now().millisecondsSinceEpoch - timeStamp * 60000;
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(adjustedMillisecond);

    return dateTime;
  }
}
