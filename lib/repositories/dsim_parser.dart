import 'dart:async';
import 'dart:io';

import 'package:aci_plus_app/core/command.dart';
import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/crc16_calculate.dart';
import 'package:aci_plus_app/repositories/unit_converter.dart';
import 'package:excel/excel.dart';
import 'package:flutter_speed_chart/speed_chart.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

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

class A1G1 {
  const A1G1({
    required this.partNo,
    required this.hasDualPilot,
  });

  final String partNo;
  final String hasDualPilot;
}

class A1G3 {
  const A1G3({
    required this.logInterval,
    required this.firmwareVersion,
  });

  final String logInterval;
  final String firmwareVersion;
}

class A1G4 {
  const A1G4({
    required this.currentAttenuation,
    required this.minAttenuation,
    required this.maxAttenuation,
    required this.tgcCableLength,
  });

  final String currentAttenuation;
  final String minAttenuation;
  final String maxAttenuation;
  final String tgcCableLength;
}

class A1G5 {
  const A1G5({
    required this.workingMode,
    required this.currentPilot,
    required this.pilotMode,
    required this.rfAlarmSeverity,
    required this.temperatureAlarmSeverity,
    required this.powerAlarmSeverity,
    required this.currentTemperatureF,
    required this.currentTemperatureC,
    required this.currentVoltage,
  });

  final String workingMode;
  final String currentPilot;
  final String pilotMode;
  final String rfAlarmSeverity;
  final String temperatureAlarmSeverity;
  final String powerAlarmSeverity;
  final String currentTemperatureF;
  final String currentTemperatureC;
  final String currentVoltage;
}

class A1G6 {
  const A1G6({
    required this.centerAttenuation,
    required this.currentVoltageRipple,
  });

  final String centerAttenuation;
  final String currentVoltageRipple;
}

class LogStatistic {
  const LogStatistic({
    required this.minTemperatureF,
    required this.maxTemperatureF,
    required this.minTemperatureC,
    required this.maxTemperatureC,
    required this.historicalMinAttenuation,
    required this.historicalMaxAttenuation,
    required this.minVoltage,
    required this.maxVoltage,
    required this.minVoltageRipple,
    required this.maxVoltageRipple,
  });

  final String minTemperatureF;
  final String maxTemperatureF;
  final String minTemperatureC;
  final String maxTemperatureC;
  final String historicalMinAttenuation;
  final String historicalMaxAttenuation;
  final String minVoltage;
  final String maxVoltage;
  final String minVoltageRipple;
  final String maxVoltageRipple;
}

class DsimParser {
  DsimParser() : _unitConverter = UnitConverter() {
    _calculateCRCs();
  }

  final UnitConverter _unitConverter;
  final List<List<int>> _commandCollection = [];
  List<List<int>> get commandCollection => _commandCollection;
  String _basicCurrentPilot = '';
  int _basicCurrentPilotMode = 0;
  int _currentSettingMode = 0;
  int _nowTimeCount = 0;
  int _alarmR = 0;
  int _alarmT = 0;
  int _alarmP = 0;
  final List<int> _rawLog = [];
  final List<Log> _logs = [];
  final List<int> _rawEvent = [];
  final List<Event> _events = [];
  final int _totalBytesPerCommand = 261;

  void clearCache() {
    _logs.clear();
    _rawLog.clear();
    _events.clear();
    _rawEvent.clear();
  }

  String parseCommand0(List<int> rawData) {
    String typeNo = '';
    for (int i = 3; i < 15; i++) {
      typeNo += String.fromCharCode(rawData[i]);
    }
    typeNo = typeNo.trim();

    return typeNo;
  }

  A1G1 parseCommand1(List<int> rawData) {
    String partNo = 'DSIM';
    String hasDualPilot = '0';
    for (int i = 3; i < 15; i++) {
      partNo += String.fromCharCode(rawData[i]);
    }

    partNo = partNo.trim();

    // 如果是 dual, 會有兩的 pilot channel
    if (partNo.startsWith('DSIM-CG')) {
      hasDualPilot = '1';
    }

    A1G1 a1g1 = A1G1(
      partNo: partNo,
      hasDualPilot: hasDualPilot,
    );

    return a1g1;
  }

  String parseCommand2(List<int> rawData) {
    String serialNumber = '';
    for (int i = 3; i < 15; i++) {
      serialNumber += String.fromCharCode(rawData[i]);
    }
    serialNumber = serialNumber.trim();
    return serialNumber;
  }

  A1G3 parseCommand3(List<int> rawData) {
    int number = rawData[10]; // hardware status 4 bytes last byte

    // bit 0: RF detect Max, bit 1 : RF detect Min
    _alarmR = (number & 0x01) + (number & 0x02);

    // bit 6: Temperature Max, bit 7 : Temperature Min
    _alarmT = (number & 0x40) + (number & 0x80);

    // bit 4: Voltage 24v Max, bit 5 : Voltage 24v Min
    _alarmP = (number & 0x10) + (number & 0x20);

    String logInterval = rawData[13].toString(); //time interval

    _nowTimeCount = rawData[11] * 256 + rawData[12];

    String firmwareVersion = '';
    for (int i = 3; i < 6; i++) {
      firmwareVersion += String.fromCharCode(rawData[i]);
    }

    A1G3 a1g3 = A1G3(
      logInterval: logInterval,
      firmwareVersion: firmwareVersion,
    );

    return a1g3;
  }

  A1G4 parseCommand4(List<int> rawData) {
    String currentAttenuation = (rawData[4] * 256 + rawData[5]).toString();

    _currentSettingMode = rawData[3];

    _basicCurrentPilot = rawData[7].toString();
    _basicCurrentPilotMode = rawData[8];

    String tgcCableLength = rawData[6].toString();

    A1G4 a1g4 = A1G4(
      currentAttenuation: currentAttenuation,
      minAttenuation: '0',
      maxAttenuation: '3000',
      tgcCableLength: tgcCableLength,
    );

    return a1g4;
  }

  A1G5 parseCommand5(List<int> rawData) {
    String workingMode = '';
    String currentPilot = '';
    Alarm rfAlarmSeverity = Alarm.medium;
    Alarm temperatureAlarmSeverity = Alarm.medium;
    Alarm powerAlarmSeverity = Alarm.medium;
    double currentTemperatureC;
    double currentTemperatureF;
    String currentVoltage;
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
      rfAlarmSeverity = Alarm.medium;
    } else {
      if (_alarmR > 0) {
        // danger
        rfAlarmSeverity = Alarm.danger;
      } else {
        // success
        rfAlarmSeverity = Alarm.success;
      }
    }
    if (rawData[3] == 3) {
      if (_currentSettingMode == 1 || _currentSettingMode == 2) {
        // danger
        rfAlarmSeverity = Alarm.danger;
      }
    }

    if (rfAlarmSeverity == Alarm.danger) {
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

    temperatureAlarmSeverity = _alarmT > 0 ? Alarm.danger : Alarm.success;
    powerAlarmSeverity = _alarmP > 0 ? Alarm.danger : Alarm.success;

    //Temperature
    currentTemperatureC = (rawData[10] * 256 + rawData[11]) / 10;
    currentTemperatureF =
        _unitConverter.converCelciusToFahrenheit(currentTemperatureC);
    String strCurrentTemperatureF = currentTemperatureF.toStringAsFixed(1);
    String strCurrentTemperatureC = currentTemperatureC.toString();

    //24V
    currentVoltage = ((rawData[8] * 256 + rawData[9]) / 10).toStringAsFixed(1);

    A1G5 a1g5 = A1G5(
      workingMode: workingMode,
      currentPilot: currentPilot,
      pilotMode: pilotMode,
      rfAlarmSeverity: rfAlarmSeverity.name,
      temperatureAlarmSeverity: temperatureAlarmSeverity.name,
      powerAlarmSeverity: powerAlarmSeverity.name,
      currentTemperatureF: strCurrentTemperatureF,
      currentTemperatureC: strCurrentTemperatureC,
      currentVoltage: currentVoltage,
    );

    return a1g5;
  }

  A1G6 parseCommand6(List<int> rawData) {
    String centerAttenuation = (rawData[11] * 256 + rawData[12]).toString();
    String currentVoltageRipple = (rawData[9] * 256 + rawData[10]).toString();

    A1G6 a1g6 = A1G6(
      centerAttenuation: centerAttenuation,
      currentVoltageRipple: currentVoltageRipple,
    );

    return a1g6;
  }

  String parseLocationChunk(List<int> rawData, int index) {
    String partOfLocation = '';
    if (index == 3) {
      for (int i = 3; i < 7; i++) {
        if (rawData[i] == 0) {
          break;
        }
        partOfLocation += String.fromCharCode(rawData[i]);
      }
    } else {
      for (int i = 3; i < 15; i++) {
        if (rawData[i] == 0) {
          break;
        }
        partOfLocation += String.fromCharCode(rawData[i]);
      }
    }
    return partOfLocation;
  }

  DateTime timeStampToDateTime(int timeStamp) {
    int adjustedMillisecond =
        DateTime.now().millisecondsSinceEpoch - timeStamp * 60000;
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(adjustedMillisecond);

    return dateTime;
  }

  LogStatistic getLogStatistic() {
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
          .toStringAsFixed(1);

      String maxTemperatureF = _unitConverter
          .converCelciusToFahrenheit(maxTemperature)
          .toStringAsFixed(1);

      String minTemperatureC = minTemperature.toString();

      String maxTemperatureC = maxTemperature.toString();

      LogStatistic logStatistic = LogStatistic(
        minTemperatureF: minTemperatureF,
        maxTemperatureF: maxTemperatureF,
        minTemperatureC: minTemperatureC,
        maxTemperatureC: maxTemperatureC,
        historicalMinAttenuation: historicalMinAttenuation.toString(),
        historicalMaxAttenuation: historicalMaxAttenuation.toString(),
        minVoltage: minVoltage.toString(),
        maxVoltage: maxVoltage.toString(),
        minVoltageRipple: minVoltageRipple.toString(),
        maxVoltageRipple: maxVoltageRipple.toString(),
      );

      return logStatistic;
    } else {
      LogStatistic logStatistic = const LogStatistic(
        minTemperatureF: '',
        maxTemperatureF: '',
        minTemperatureC: '',
        maxTemperatureC: '',
        historicalMinAttenuation: '',
        historicalMaxAttenuation: '',
        minVoltage: '',
        maxVoltage: '',
        minVoltageRipple: '',
        maxVoltageRipple: '',
      );

      return logStatistic;
    }
  }

  void parseLog({
    required int commandIndex,
    required List<int> rawLog,
  }) {
    rawLog.removeRange(rawLog.length - 2, rawLog.length);
    rawLog.removeRange(0, 3);

    for (var i = 0; i < 16; i++) {
      int timeStamp = rawLog[i * 16] * 256 + rawLog[i * 16 + 1];
      double temperature = (rawLog[i * 16 + 2] * 256 + rawLog[i * 16 + 3]) / 10;
      int attenuation = rawLog[i * 16 + 4] * 256 + rawLog[i * 16 + 5];
      double pilot = (rawLog[i * 16 + 6] * 256 + rawLog[i * 16 + 7]) / 10;
      double voltage = (rawLog[i * 16 + 8] * 256 + rawLog[i * 16 + 9]) / 10;
      int voltageRipple = rawLog[i * 16 + 10] * 256 + rawLog[i * 16 + 11];

      if (timeStamp < 0xFFF0) {
        //# 20210128 做2補數
        if (temperature > 32767) {
          temperature = -(65535 - temperature + 1).abs();
        }
        // print('$_nowTimeCount: $timeStamp');

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

        if (_logs.isNotEmpty) {
          _logs.sort((a, b) => a.dateTime.compareTo(b.dateTime));
        }
      }
    }
  }

  void parseEvent({
    required int commandIndex,
    required List<int> rawEvent,
  }) {
    rawEvent.removeRange(rawEvent.length - 2, rawEvent.length);
    rawEvent.removeRange(0, 3);

    for (int i = 0; i < 16; i++) {
      int timeStamp = rawEvent[i * 16] * 256 + rawEvent[i * 16 + 1];
      int code = rawEvent[i * 16 + 2] * 256 + rawEvent[i * 16 + 3];
      int parameter = rawEvent[i * 16 + 4] * 256 + rawEvent[i * 16 + 5];

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

    excel.rename('Sheet1', 'Log');
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
