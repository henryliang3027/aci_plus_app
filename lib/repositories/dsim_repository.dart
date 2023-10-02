import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/command18.dart';
import 'package:dsim_app/core/crc16_calculate.dart';
import 'package:dsim_app/core/shared_preference_key.dart';
import 'package:dsim_app/repositories/ble_client.dart';
import 'package:dsim_app/repositories/dsim18_parser.dart';
import 'package:dsim_app/repositories/dsim_parser.dart';
import 'package:dsim_app/repositories/unit_converter.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_speed_chart/speed_chart.dart';
import 'package:location/location.dart' as GPS;
import 'package:permission_handler/permission_handler.dart';
import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';
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

class RFInOut {
  const RFInOut({
    required this.input,
    required this.output,
  });

  final double input;
  final double output;
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

class DsimRepository {
  DsimRepository()
      : _bleClient = BLEClient(),
        _dsim18parser = Dsim18Parser(),
        _dsimParser = DsimParser(),
        _unitConverter = UnitConverter() {}

  late QualifiedCharacteristic _qualifiedCharacteristic;
  StreamController<Map<DataKey, String>> _characteristicDataStreamController =
      StreamController<Map<DataKey, String>>();

  final _aciPrefix = 'ACI';
  final _serviceId = 'ffe0';
  final _characteristicId = 'ffe1';

  late Completer<dynamic> _completer;

  // 記錄欲設定的 workingModeId
  int _workingModeId = 0;
  final int _agcWorkingModeSettingDuration = 30;

  final int _commandExecutionTimeout = 10; // s
  final int _agcWorkingModeSettingTimeout = 40; // s
  Timer? _timeoutTimer;

  final BLEClient _bleClient;
  final DsimParser _dsimParser;
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
      commandIndex: -1,
      value: _dsimParser.commandCollection[0],
      deviceId: deviceId,
    );
  }

  void clearCache() {
    _dsimParser.clearCache();
  }

  Future<dynamic> requestCommand1p8G0() async {
    int commandIndex = 180;
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
        <DataKey, String>{
          DataKey.partName: partName,
          DataKey.partNo: partNo,
          DataKey.serialNumber: serialNumber,
          DataKey.firmwareVersion: firmwareVersion,
          DataKey.mfgDate: mfgDate,
          DataKey.coordinates: coordinate,
        },
      ];
    } catch (e) {
      return [
        false,
      ];
    }
  }

  Future<dynamic> requestCommand1p8G1() async {
    int commandIndex = 181;
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
        minVoltageRipple,
        maxVoltageRipple,
        minRFOutputPower,
        maxRFOutputPower,
        ingressSetting2,
        ingressSetting3,
        ingressSetting4,
        tgcCableLength,
        splitOption,
        pilotFrequencyMode,
        agcMode,
        alcMode,
        firstChannelLoadingFrequency,
        lastChannelLoadingFrequency,
        firstChannelLoadingLevel,
        lastChannelLoadingLevel,
        pilotFrequency1,
        pilotFrequency2,
        pilotFrequency1AlarmState,
        pilotFrequency2AlarmState,
        rfOutputPilotLowFrequencyAlarmState,
        rfOutputPilotHighFrequencyAlarmState,
        temperatureAlarmState,
        voltageAlarmState,
        splitOptionAlarmState,
        voltageRippleAlarmState,
        rfOutputPowerAlarmState,
        location,
        logInterval,
        inputAttenuation,
        inputEqualizer,
        dsVVA2,
        dsSlope2,
        inputAttenuation2,
        outputEqualizer,
        dsVVA3,
        dsVVA4,
        outputAttenuation,
        inputAttenuation3,
        inputAttenuation4,
        usTGC,
      ) = await _completer.future;
      cancelTimeout(name: '1p8G1');

      return [
        true,
        <DataKey, String>{
          DataKey.minTemperatureC: minTemperatureC,
          DataKey.maxTemperatureC: maxTemperatureC,
          DataKey.minTemperatureF: minTemperatureF,
          DataKey.maxTemperatureF: maxTemperatureF,
          DataKey.minVoltage: minVoltage,
          DataKey.maxVoltage: maxVoltage,
          DataKey.minVoltageRipple: minVoltageRipple,
          DataKey.maxVoltageRipple: maxVoltageRipple,
          DataKey.minRFOutputPower: minRFOutputPower,
          DataKey.maxRFOutputPower: maxRFOutputPower,
          DataKey.ingressSetting2: ingressSetting2,
          DataKey.ingressSetting3: ingressSetting3,
          DataKey.ingressSetting4: ingressSetting4,
          DataKey.tgcCableLength: tgcCableLength,
          DataKey.splitOption: splitOption,
          DataKey.pilotFrequencyMode: pilotFrequencyMode,
          DataKey.agcMode: agcMode,
          DataKey.alcMode: alcMode,
          DataKey.firstChannelLoadingFrequency: firstChannelLoadingFrequency,
          DataKey.lastChannelLoadingFrequency: lastChannelLoadingFrequency,
          DataKey.firstChannelLoadingLevel: firstChannelLoadingLevel,
          DataKey.lastChannelLoadingLevel: lastChannelLoadingLevel,
          DataKey.pilotFrequency1: pilotFrequency1,
          DataKey.pilotFrequency2: pilotFrequency2,
          DataKey.pilotFrequency1AlarmState: pilotFrequency1AlarmState,
          DataKey.pilotFrequency2AlarmState: pilotFrequency2AlarmState,
          DataKey.rfOutputPilotLowFrequencyAlarmState:
              rfOutputPilotLowFrequencyAlarmState,
          DataKey.rfOutputPilotHighFrequencyAlarmState:
              rfOutputPilotHighFrequencyAlarmState,
          DataKey.temperatureAlarmState: temperatureAlarmState,
          DataKey.voltageAlarmState: voltageAlarmState,
          DataKey.splitOptionAlarmState: splitOptionAlarmState,
          DataKey.voltageRippleAlarmState: voltageRippleAlarmState,
          DataKey.rfOutputPowerAlarmState: rfOutputPowerAlarmState,
          DataKey.location: location,
          DataKey.logInterval: logInterval,
          DataKey.inputAttenuation: inputAttenuation,
          DataKey.inputEqualizer: inputEqualizer,
          DataKey.dsVVA2: dsVVA2,
          DataKey.dsSlope2: dsSlope2,
          DataKey.inputAttenuation2: inputAttenuation2,
          DataKey.outputEqualizer: outputEqualizer,
          DataKey.dsVVA3: dsVVA3,
          DataKey.dsVVA4: dsVVA4,
          DataKey.outputAttenuation: outputAttenuation,
          DataKey.inputAttenuation3: inputAttenuation3,
          DataKey.inputAttenuation4: inputAttenuation4,
          DataKey.usTGC: usTGC,
        }
      ];
    } catch (e) {
      return [
        false,
      ];
    }
  }

  Future<dynamic> requestCommand1p8G2() async {
    int commandIndex = 182;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G2');

    _writeSetCommandToCharacteristic(
        _dsim18parser.command18Collection[commandIndex - 180]);
    setTimeout(
        duration: Duration(seconds: _commandExecutionTimeout),
        name: 'cmd1p8G2');

    try {
      var (
        currentTemperatureC,
        currentTemperatureF,
        currentVoltage,
        currentVoltageRipple,
        currentRFInputPower,
        currentRFOutputPower,
        currentWorkingMode,
        currentDetectedSplitOption,
        unitStatusAlarmSeverity,
        rfInputPilotLowFrequencyAlarmSeverity,
        rfInputPilotHighFrequencyAlarmSeverity,
        rfOutputPilotLowFrequencyAlarmSeverity,
        rfOutputPilotHighFrequencyAlarmSeverity,
        temperatureAlarmSeverity,
        voltageAlarmSeverity,
        splitOptionAlarmSeverity,
        voltageRippleAlarmSeverity,
        outputPowerAlarmSeverity,
      ) = await _completer.future;
      cancelTimeout(name: '1p8G2');

      return [
        true,
        <DataKey, String>{
          DataKey.currentTemperatureC: currentTemperatureC,
          DataKey.currentTemperatureF: currentTemperatureF,
          DataKey.currentVoltage: currentVoltage,
          DataKey.currentVoltageRipple: currentVoltageRipple,
          DataKey.currentRFInputPower: currentRFInputPower,
          DataKey.currentRFOutputPower: currentRFOutputPower,
          DataKey.currentWorkingMode: currentWorkingMode,
          DataKey.currentDetectedSplitOption: currentDetectedSplitOption,
          DataKey.unitStatusAlarmSeverity: unitStatusAlarmSeverity,
          DataKey.rfInputPilotLowFrequencyAlarmSeverity:
              rfInputPilotLowFrequencyAlarmSeverity,
          DataKey.rfInputPilotHighFrequencyAlarmSeverity:
              rfInputPilotHighFrequencyAlarmSeverity,
          DataKey.rfOutputPilotLowFrequencyAlarmSeverity:
              rfOutputPilotLowFrequencyAlarmSeverity,
          DataKey.rfOutputPilotHighFrequencyAlarmSeverity:
              rfOutputPilotHighFrequencyAlarmSeverity,
          DataKey.temperatureAlarmSeverity: temperatureAlarmSeverity,
          DataKey.voltageAlarmSeverity: voltageAlarmSeverity,
          DataKey.splitOptionAlarmSeverity: splitOptionAlarmSeverity,
          DataKey.voltageRippleAlarmSeverity: voltageRippleAlarmSeverity,
          DataKey.outputPowerAlarmSeverity: outputPowerAlarmSeverity,
        }
      ];
    } catch (e) {
      return [
        false,
      ];
    }
  }

  Future<dynamic> requestCommand1p8G3() async {
    int commandIndex = 183;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G3');

    _writeSetCommandToCharacteristic(
        _dsim18parser.command18Collection[commandIndex - 180]);
    setTimeout(
        duration: Duration(seconds: _commandExecutionTimeout),
        name: 'cmd1p8G3');

    try {
      var rfInOuts = await _completer.future;
      cancelTimeout(name: '1p8G3');

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

  // commandIndex range from 184 to 193;
  // commandIndex = 184 時獲取最新的1024筆Log的統計資料跟 log
  Future<dynamic> requestCommand1p8GForLogChunk(int chunkIndex) async {
    int commandIndex = chunkIndex + 184;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8GForLogChunk');

    _writeSetCommandToCharacteristic(
        _dsim18parser.command18Collection[commandIndex - 180]);
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
    int commandIndex = 204;
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
    int commandIndex = 300;
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
    int commandIndex = 301;
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
    int commandIndex = 302;
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
    int commandIndex = 303;
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

  Future<dynamic> set1p8GMaxVoltageRipple(String valtageRipple) async {
    int commandIndex = 304;
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

    _writeSetCommandToCharacteristic(Command18.setMaxVoltageRippleCmd);
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
    int commandIndex = 305;
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

    _writeSetCommandToCharacteristic(Command18.setMinVoltageRippleCmd);
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
    int commandIndex = 306;
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

    _writeSetCommandToCharacteristic(Command18.setMaxOutputPowerCmd);
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
    int commandIndex = 307;
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

    _writeSetCommandToCharacteristic(Command18.setMinOutputPowerCmd);
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
    int commandIndex = 308;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    int ingressNumber = int.parse(ingress);

    Command18.setReturnIngress2Cmd[7] = ingressNumber;

    CRC16.calculateCRC16(
      command: Command18.setReturnIngress2Cmd,
      usDataLength: Command18.setReturnIngress2Cmd.length - 2,
    );

    _writeSetCommandToCharacteristic(Command18.setReturnIngress2Cmd);
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
    int commandIndex = 309;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    int ingressNumber = int.parse(ingress);

    Command18.setReturnIngress3Cmd[7] = ingressNumber;

    CRC16.calculateCRC16(
      command: Command18.setReturnIngress3Cmd,
      usDataLength: Command18.setReturnIngress3Cmd.length - 2,
    );

    _writeSetCommandToCharacteristic(Command18.setReturnIngress3Cmd);
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
    int commandIndex = 310;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    int ingressNumber = int.parse(ingress);

    Command18.setReturnIngress4Cmd[7] = ingressNumber;

    CRC16.calculateCRC16(
      command: Command18.setReturnIngress4Cmd,
      usDataLength: Command18.setReturnIngress4Cmd.length - 2,
    );

    _writeSetCommandToCharacteristic(Command18.setReturnIngress4Cmd);
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
    int commandIndex = 313;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    int intValue = int.parse(value);

    Command18.setTGCCableLengthCmd[7] = intValue;

    CRC16.calculateCRC16(
      command: Command18.setTGCCableLengthCmd,
      usDataLength: Command18.setTGCCableLengthCmd.length - 2,
    );

    _writeSetCommandToCharacteristic(Command18.setTGCCableLengthCmd);
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
    int commandIndex = 314;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    int splitOptionNumber = int.parse(splitOption);

    Command18.setSplitOptionCmd[7] = splitOptionNumber;

    CRC16.calculateCRC16(
      command: Command18.setSplitOptionCmd,
      usDataLength: Command18.setSplitOptionCmd.length - 2,
    );

    _writeSetCommandToCharacteristic(Command18.setSplitOptionCmd);
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
    int commandIndex = 315;
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

    _writeSetCommandToCharacteristic(Command18.setPilotFrequencyModeCmd);
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
    int commandIndex = 316;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    int intValue = int.parse(value);

    Command18.setFowardAGCModeCmd[7] = intValue;

    CRC16.calculateCRC16(
      command: Command18.setFowardAGCModeCmd,
      usDataLength: Command18.setFowardAGCModeCmd.length - 2,
    );

    _writeSetCommandToCharacteristic(Command18.setFowardAGCModeCmd);
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
    int commandIndex = 317;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    int intValue = int.parse(value);

    Command18.setALCModeCmd[7] = intValue;

    CRC16.calculateCRC16(
      command: Command18.setALCModeCmd,
      usDataLength: Command18.setALCModeCmd.length - 2,
    );

    _writeSetCommandToCharacteristic(Command18.setALCModeCmd);
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
    int commandIndex = 318;
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

    _writeSetCommandToCharacteristic(
        Command18.setFirstChannelLoadingFrequencyCmd);
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
    int commandIndex = 319;
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

    _writeSetCommandToCharacteristic(
        Command18.setLastChannelLoadingFrequencyCmd);
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
    int commandIndex = 320;
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

    _writeSetCommandToCharacteristic(Command18.setFirstChannelLoadingLevelCmd);
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
    int commandIndex = 321;
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

    _writeSetCommandToCharacteristic(Command18.setLastChannelLoadingLevelCmd);
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
    int commandIndex = 322;
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

    _writeSetCommandToCharacteristic(Command18.setPilotFrequency1Cmd);
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
    int commandIndex = 323;
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

    _writeSetCommandToCharacteristic(Command18.setPilotFrequency2Cmd);
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
    int commandIndex = 324;
    _completer = Completer<dynamic>();

    print('get data from request command 1p8G$commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18.setInputPilotLowFrequencyAlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18.setInputPilotLowFrequencyAlarmStateCmd,
      usDataLength: Command18.setInputPilotLowFrequencyAlarmStateCmd.length - 2,
    );

    _writeSetCommandToCharacteristic(
        Command18.setInputPilotLowFrequencyAlarmStateCmd);
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

    _writeSetCommandToCharacteristic(
        Command18.setInputPilotHighFrequencyAlarmStateCmd);
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

    _writeSetCommandToCharacteristic(
        Command18.setOutputPilotLowFrequencyAlarmStateCmd);
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

    _writeSetCommandToCharacteristic(
        Command18.setOutputPilotHighFrequencyAlarmStateCmd);
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

    _writeSetCommandToCharacteristic(Command18.setTemperatureAlarmStateCmd);
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

    _writeSetCommandToCharacteristic(Command18.setVoltageAlarmStateCmd);
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

    _writeSetCommandToCharacteristic(Command18.setSplitOptionAlarmStateCmd);
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

    _writeSetCommandToCharacteristic(Command18.setVoltageRippleAlarmStateCmd);
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

    _writeSetCommandToCharacteristic(Command18.setRFOutputPowerAlarmStateCmd);
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

    _writeSetCommandToCharacteristic(Command18.setLogIntervalCmd);
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

    _writeSetCommandToCharacteristic(Command18.setForwardInputAttenuationCmd);
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

    _writeSetCommandToCharacteristic(Command18.setForwardInputEqualizerCmd);
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

    _writeSetCommandToCharacteristic(Command18.setDSVVA2Cmd);
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

    _writeSetCommandToCharacteristic(Command18.setDSSlope2Cmd);
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

    _writeSetCommandToCharacteristic(Command18.setReturnInputAttenuation2Cmd);
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

    _writeSetCommandToCharacteristic(Command18.setReturnOutputEqualizerCmd);
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

    _writeSetCommandToCharacteristic(Command18.setDSVVA3Cmd);
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

    _writeSetCommandToCharacteristic(Command18.setDSVVA4Cmd);
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

    _writeSetCommandToCharacteristic(Command18.setReturnOutputAttenuationCmd);
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

    _writeSetCommandToCharacteristic(Command18.setReturnInputAttenuation3Cmd);
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

    _writeSetCommandToCharacteristic(Command18.setReturnInputAttenuation4Cmd);
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

    _writeSetCommandToCharacteristic(Command18.setUSTGCCmd);
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

    _writeSetCommandToCharacteristic(Command18.setTransmitDelayTimeCmd);
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

    _writeSetCommandToCharacteristic(Command18.setNowDateTimeCmd);
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
          .add(Map<DataKey, String>.from(resultOf1p8G0[1]));
    }

    List<dynamic> resultOf1p8G1 = await requestCommand1p8G1();

    if (resultOf1p8G1[0]) {
      _characteristicDataStreamController
          .add(Map<DataKey, String>.from(resultOf1p8G1[1]));
    }

    List<dynamic> resultOf1p8G2 = await requestCommand1p8G2();
    if (resultOf1p8G2[0]) {
      _characteristicDataStreamController
          .add(Map<DataKey, String>.from(resultOf1p8G2[1]));
    }
  }

  Future<dynamic> requestCommand0() async {
    commandIndex = 0;

    print('get data from request command 0');

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _dsimParser.commandCollection[commandIndex],
      );

      String typeNo = _dsimParser.parseCommand0(rawData);

      return [true, typeNo];
    } catch (e) {
      return [
        false,
      ];
    }
  }

  Future<dynamic> requestCommand1() async {
    commandIndex = 1;

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _dsimParser.commandCollection[commandIndex],
      );

      A1G1 a1g1 = _dsimParser.parseCommand1(rawData);

      return [
        true,
        a1g1.partNo,
        a1g1.hasDualPilot,
      ];
    } catch (e) {
      return [
        false,
      ];
    }
  }

  Future<dynamic> requestCommand2() async {
    commandIndex = 2;

    print('get data from request command 2');

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _dsimParser.commandCollection[commandIndex],
      );

      String serialNumber = _dsimParser.parseCommand2(rawData);

      return [
        true,
        serialNumber,
      ];
    } catch (e) {
      return [
        false,
      ];
    }
  }

  Future<dynamic> requestCommand3() async {
    commandIndex = 3;

    print('get data from request command 3');

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _dsimParser.commandCollection[commandIndex],
      );

      A1G3 a1g3 = _dsimParser.parseCommand3(rawData);

      return [
        true,
        a1g3.logInterval,
        a1g3.firmwareVersion,
      ];
    } catch (e) {
      return [
        false,
      ];
    }
  }

  Future<dynamic> requestCommand4() async {
    commandIndex = 4;
    print('get data from request command 4');

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _dsimParser.commandCollection[commandIndex],
      );

      A1G4 a1g4 = _dsimParser.parseCommand4(rawData);

      return [
        true,
        a1g4.currentAttenuation,
        a1g4.minAttenuation,
        a1g4.maxAttenuation,
        a1g4.tgcCableLength,
      ];
    } catch (e) {
      return [
        false,
      ];
    }
  }

  Future<dynamic> requestCommand5() async {
    commandIndex = 5;

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _dsimParser.commandCollection[commandIndex],
      );

      A1G5 a1g5 = _dsimParser.parseCommand5(rawData);

      return [
        true,
        a1g5.workingMode,
        a1g5.currentPilot,
        a1g5.pilotMode,
        a1g5.rfAlarmSeverity,
        a1g5.temperatureAlarmSeverity,
        a1g5.powerAlarmSeverity,
        a1g5.currentTemperatureF,
        a1g5.currentTemperatureC,
        a1g5.currentVoltage,
      ];
    } catch (e) {
      return [
        false,
      ];
    }
  }

  Future<dynamic> requestCommand6() async {
    commandIndex = 6;

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _dsimParser.commandCollection[commandIndex],
      );

      A1G6 a1g6 = _dsimParser.parseCommand6(rawData);

      return [
        true,
        a1g6.centerAttenuation,
        a1g6.currentVoltageRipple,
      ];
    } catch (e) {
      return [
        false,
      ];
    }
  }

  Future<dynamic> requestCommand9() async {
    commandIndex = 6;

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _dsimParser.commandCollection[commandIndex],
      );

      A1G6 a1g6 = _dsimParser.parseCommand6(rawData);

      return [
        true,
        a1g6.centerAttenuation,
        a1g6.currentVoltageRipple,
      ];
    } catch (e) {
      return [
        false,
      ];
    }
  }

  // location
  Future requestCommand9To12() async {
    String location = '';
    for (int i = 9; i <= 12; i++) {
      commandIndex = i;
      try {
        List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
          commandIndex: commandIndex,
          value: _dsimParser.commandCollection[commandIndex],
        );

        String partOfLocation =
            _dsimParser.parseLocationChunk(rawData, commandIndex - 9);

        location += partOfLocation;

        if (commandIndex == 12) {
          return [
            true,
            location,
          ];
        }
      } catch (e) {
        return [
          false,
        ];
      }
    }
  }

  Future requestCommandForLogChunk(int chunkIndex) async {
    commandIndex = chunkIndex;
    print('get data from request command $chunkIndex');

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _dsimParser.commandCollection[commandIndex],
      );

      _dsimParser.parseLog(
        commandIndex: commandIndex,
        rawLog: rawData,
      );

      if (commandIndex == 29) {
        LogStatistic logStatistic = _dsimParser.getLogStatistic();

        return [
          true,
          logStatistic.minTemperatureF,
          logStatistic.maxTemperatureF,
          logStatistic.minTemperatureC,
          logStatistic.maxTemperatureC,
          logStatistic.historicalMinAttenuation,
          logStatistic.historicalMaxAttenuation,
          logStatistic.minVoltage,
          logStatistic.maxVoltage,
          logStatistic.minVoltageRipple,
          logStatistic.maxVoltageRipple,
        ];
      }
    } catch (e) {
      return [false, '', '', '', '', '', '', '', '', '', ''];
    }
  }

  Future requestCommand30To37() async {
    for (int i = 30; i <= 37; i++) {
      commandIndex = i;

      print('get data from request command $i');
      try {
        List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
          commandIndex: commandIndex,
          value: _dsimParser.commandCollection[commandIndex],
        );

        _dsimParser.parseEvent(
          commandIndex: commandIndex,
          rawEvent: rawData,
        );
      } catch (e) {
        return [false];
      }
    }

    return [true];
  }

  // void _parseSetWorkingMode(List<int> rawData) async {
  //   if (commandIndex == 46) {
  //     if ((rawData[0] == 0xB0) &&
  //         (rawData[1] == 0x10) &&
  //         (rawData[2] == 0x00) &&
  //         (rawData[3] == 0x04) &&
  //         (rawData[4] == 0x00) &&
  //         (rawData[5] == 0x06)) {
  //       print('set working mode done');

  //       // 如果 _workingModeId == 1 也就是 AGC, 則等待30秒後再讀回資料
  //       if (_workingModeId == 1) {
  //         await Future.delayed(
  //             Duration(seconds: _agcWorkingModeSettingDuration));
  //       }

  //       if (!_completer.isCompleted) {
  //         _completer.complete(true);
  //       }
  //     }
  //   }
  // }

  // Future<void> _parseSetLogInterval(List<int> rawData) async {
  //   if (commandIndex == 45) {
  //     if ((rawData[0] == 0xB0) &&
  //         (rawData[1] == 0x10) &&
  //         (rawData[2] == 0x00) &&
  //         (rawData[3] == 0x04) &&
  //         (rawData[4] == 0x00) &&
  //         (rawData[5] == 0x06)) {
  //       print('set log interval done');

  //       if (!_completer.isCompleted) {
  //         _completer.complete(true);
  //       }
  //     }
  //   }
  // }

  // Future<void> _parseSetTGCCableLength(List<int> rawData) async {
  //   if (commandIndex == 44) {
  //     if ((rawData[0] == 0xB0) &&
  //         (rawData[1] == 0x10) &&
  //         (rawData[2] == 0x00) &&
  //         (rawData[3] == 0x04) &&
  //         (rawData[4] == 0x00) &&
  //         (rawData[5] == 0x06)) {
  //       print('set TGC cable length done');
  //     }

  //     if (!_completer.isCompleted) {
  //       _completer.complete(true);
  //     }
  //   }
  // }

  // Future<void> _parseSetLocation(List<int> rawData) async {
  //   if (commandIndex == 40) {
  //     if ((rawData[0] == 0xB0) &&
  //         (rawData[1] == 0x10) &&
  //         (rawData[2] == 0x00) &&
  //         (rawData[3] == 0x09) &&
  //         (rawData[4] == 0x00) &&
  //         (rawData[5] == 0x06)) {
  //       print('Location09 Set');
  //       commandIndex = 41;
  //       _writeSetCommandToCharacteristic(
  //         Command.setLocACmd,
  //       );
  //     } else {}
  //   } else if (commandIndex == 41) {
  //     if ((rawData[0] == 0xB0) &&
  //         (rawData[1] == 0x10) &&
  //         (rawData[2] == 0x00) &&
  //         (rawData[3] == 0x0A) &&
  //         (rawData[4] == 0x00) &&
  //         (rawData[5] == 0x06)) {
  //       print('Location0A Set');
  //       commandIndex = 42;
  //       _writeSetCommandToCharacteristic(
  //         Command.setLocBCmd,
  //       );
  //     } else {}
  //   } else if (commandIndex == 42) {
  //     if ((rawData[0] == 0xB0) &&
  //         (rawData[1] == 0x10) &&
  //         (rawData[2] == 0x00) &&
  //         (rawData[3] == 0x0B) &&
  //         (rawData[4] == 0x00) &&
  //         (rawData[5] == 0x06)) {
  //       print('Location0B Set');
  //       commandIndex = 43;
  //       _writeSetCommandToCharacteristic(
  //         Command.setLocCCmd,
  //       );
  //     } else {}
  //   } else if (commandIndex == 43) {
  //     if ((rawData[0] == 0xB0) &&
  //         (rawData[1] == 0x10) &&
  //         (rawData[2] == 0x00) &&
  //         (rawData[3] == 0x0C) &&
  //         (rawData[4] == 0x00) &&
  //         (rawData[5] == 0x06)) {
  //       print('Location0C Set');

  //       if (!_completer.isCompleted) {
  //         _completer.complete(true);
  //       }
  //     } else {}
  //   }
  // }

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

    for (int i = 40; i < 43; i++) {
      commandIndex = i;
      try {
        List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
          commandIndex: commandIndex,
          value: _dsimParser.commandCollection[commandIndex],
        );
      } catch (e) {
        return false;
      }
    }

    // 設定後重新讀取 location 來比對是否設定成功
    List<dynamic> resultOfGetLocation = await requestCommand9To12();

    if (resultOfGetLocation[0]) {
      if (location == resultOfGetLocation[1]) {
        _characteristicDataStreamController
            .add({DataKey.location: resultOfGetLocation[1]});
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> setTGCCableLength({
    required int currentAttenuation,
    required String tgcCableLength,
    required String pilotChannel,
    required String pilotMode,
    required String logIntervalId,
  }) async {
    _completer = Completer<dynamic>();

    Command.set04Cmd[7] = 3; //3 TGC
    Command.set04Cmd[8] = currentAttenuation ~/ 256; //MGC Value 2Bytes
    Command.set04Cmd[9] = currentAttenuation % 256; //MGC Value
    Command.set04Cmd[10] = int.parse(tgcCableLength); //TGC Cable length
    Command.set04Cmd[11] = int.parse(pilotChannel); //AGC Channel 1Byte
    Command.set04Cmd[12] = _getPilotModeId(pilotMode); //AGC channel Mode 1 Byte
    Command.set04Cmd[13] = int.parse(logIntervalId); //Log Minutes 1Byte
    Command.set04Cmd[14] = 0x03; //AGC Channel 2 1Byte
    Command.set04Cmd[15] = 0x02; //AGC Channel 2 Mode 1Byte
    CRC16.calculateCRC16(command: Command.set04Cmd, usDataLength: 19);

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _dsimParser.commandCollection[commandIndex],
      );
    } catch (e) {
      return false;
    }

    // 設定後重新讀取 tgc cable length 來比對是否設定成功

    List<dynamic> resultOfCommand4 = await requestCommand4();
    List<dynamic> resultOfCommand5 = await requestCommand5();

    if (resultOfCommand4[0] && resultOfCommand5[0]) {
      if (tgcCableLength == resultOfCommand4[4]) {
        _characteristicDataStreamController
            .add({DataKey.tgcCableLength: resultOfCommand4[4]});

        _characteristicDataStreamController
            .add({DataKey.workingMode: resultOfCommand5[1]});

        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> setLogInterval({
    required String logIntervalId,
  }) async {
    _completer = Completer<dynamic>();

    int intLogIntervalId = int.parse(logIntervalId);

    Command.set04Cmd[7] = 0x08; // 8
    Command.set04Cmd[13] = intLogIntervalId; // Log Minutes 1Byte
    CRC16.calculateCRC16(command: Command.set04Cmd, usDataLength: 19);

    commandIndex = 45;
    endIndex = 45;
    _writeSetCommandToCharacteristic(Command.set04Cmd);
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
            _characteristicDataStreamController
                .add({DataKey.logInterval: result[1]});
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
    required String logIntervalId,
    required bool hasDualPilot,
  }) async {
    _completer = Completer<dynamic>();
    _workingModeId = _getWorkingModeId(workingMode);

    if (hasDualPilot) {
      Command.set04Cmd[7] = _workingModeId;
      Command.set04Cmd[8] = currentAttenuation ~/ 256; //MGC Value 2Bytes
      Command.set04Cmd[9] = currentAttenuation % 256; //MGC Value
      Command.set04Cmd[10] = int.parse(tgcCableLength); //TGC Cable length
      Command.set04Cmd[11] = int.parse(pilotChannel); //AGC Channel 1Byte
      Command.set04Cmd[12] =
          _getPilotModeId(pilotMode); //AGC channel Mode 1 Byte
      Command.set04Cmd[13] = int.parse(logIntervalId); //Log Minutes 1Byte
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
      Command.set04Cmd[13] = int.parse(logIntervalId); //Log Minutes 1Byte
      Command.set04Cmd[14] = 0x03; //AGC Channel 2 1Byte
      Command.set04Cmd[15] = 0x02; //AGC Channel 2 Mode 1Byte
    }

    CRC16.calculateCRC16(command: Command.set04Cmd, usDataLength: 19);

    commandIndex = 46;
    endIndex = 46;
    _writeSetCommandToCharacteristic(Command.set04Cmd);

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
        List<dynamic> resultOfCommand5 = await requestCommand5();

        if (resultOfCommand5[0]) {
          if (workingMode == resultOfCommand5[1]) {
            _characteristicDataStreamController
                .add({DataKey.workingMode: resultOfCommand5[1]});
            _characteristicDataStreamController
                .add({DataKey.currentPilot: resultOfCommand5[2]});
            _characteristicDataStreamController
                .add({DataKey.currentPilotMode: resultOfCommand5[3]});

            _characteristicDataStreamController.add(
                {DataKey.currentAttenuation: currentAttenuation.toString()});

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

  List<List<ValuePair>> getDateValueCollectionOfLogs() {
    return _dsimParser.getDateValueCollectionOfLogs();
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
}
