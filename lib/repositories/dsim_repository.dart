import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/command18.dart';
import 'package:dsim_app/core/crc16_calculate.dart';
import 'package:dsim_app/core/shared_preference_key.dart';
import 'package:dsim_app/repositories/ble_client.dart';
import 'package:dsim_app/repositories/dsim18_chart_cache.dart';
import 'package:dsim_app/repositories/dsim18_parser.dart';
import 'package:dsim_app/repositories/dsim_parser.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_speed_chart/speed_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DsimRepository {
  DsimRepository()
      : _bleClient = BLEClient(),
        _dsimParser = DsimParser(),
        _dsim18Parser = Dsim18Parser(),
        _dsim18ChartCache = Dsim18ChartCache();

  StreamController<Map<DataKey, String>> _characteristicDataStreamController =
      StreamController<Map<DataKey, String>>();

  final BLEClient _bleClient;
  final DsimParser _dsimParser;
  final Dsim18Parser _dsim18Parser;
  final Dsim18ChartCache _dsim18ChartCache;

  Stream<ScanReport> get scanReport async* {
    yield* _bleClient.scanReport;
  }

  Stream<ConnectionReport> get connectionStateReport async* {
    yield* _bleClient.connectionStateReport;
  }

  Stream<Map<DataKey, String>> get characteristicData async* {
    yield* _characteristicDataStreamController.stream;
  }

  Future<void> connectToDevice(DiscoveredDevice discoveredDevice) {
    _characteristicDataStreamController =
        StreamController<Map<DataKey, String>>();

    return _bleClient.connectToDevice(discoveredDevice);
  }

  Future<void> closeScanStream() async {
    await _bleClient.closeScanStream();
  }

  Future<void> closeConnectionStream() async {
    if (_characteristicDataStreamController.hasListener) {
      if (!_characteristicDataStreamController.isClosed) {
        await _characteristicDataStreamController.close();
      }
    }

    await _bleClient.closeConnectionStream();
  }

  Future<dynamic> getACIDeviceType({
    required String deviceId,
    int mtu = 247,
  }) async {
    return _bleClient.getACIDeviceType(
      commandIndex: -1,
      value: _dsimParser.commandCollection[0],
      deviceId: deviceId,
      mtu: mtu,
    );
  }

  void clearCache() {
    _dsim18ChartCache.clearCache();
  }

  Future<dynamic> requestCommand1p8G0() async {
    int commandIndex = 180;

    print('get data from request command 1p8G0');

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _dsim18Parser.command18Collection[commandIndex - 180],
      );

      A1P8G0 a1p8g0 = _dsim18Parser.decodeA1P8G0(rawData);

      return [
        true,
        <DataKey, String>{
          DataKey.partName: a1p8g0.partName,
          DataKey.partNo: a1p8g0.partNo,
          DataKey.partId: a1p8g0.partId,
          DataKey.serialNumber: a1p8g0.serialNumber,
          DataKey.firmwareVersion: a1p8g0.firmwareVersion,
          DataKey.mfgDate: a1p8g0.mfgDate,
          DataKey.coordinates: a1p8g0.coordinate,
          DataKey.nowDateTime: a1p8g0.nowDateTime,
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

    print('get data from request command 1p8G1');

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _dsim18Parser.command18Collection[commandIndex - 180],
      );

      A1P8G1 a1p8g1 = _dsim18Parser.decodeA1P8G1(rawData);

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
    int commandIndex = 182;

    print('get data from request command 1p8G2');

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _dsim18Parser.command18Collection[commandIndex - 180],
      );

      A1P8G2 a1p8g2 = _dsim18Parser.decodeA1P8G2(rawData);

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
          DataKey.rfOutputOperatingSlope: a1p8g2.rfOutputOperatingSlope,
          DataKey.manualModePilot1RFOutputPower:
              a1p8g2.manualModePilot1RFOutputPower,
          DataKey.manualModePilot2RFOutputPower:
              a1p8g2.manualModePilot2RFOutputPower,
          DataKey.rfOutputLowChannelPower: a1p8g2.rfOutputLowChannelPower,
          DataKey.rfOutputHighChannelPower: a1p8g2.rfOutputHighChannelPower,
          DataKey.pilot1RFChannelFrequency: a1p8g2.pilot1RFChannelFrequency,
          DataKey.pilot2RFChannelFrequency: a1p8g2.pilot2RFChannelFrequency,
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
    int commandIndex = 183;

    print('get data from request command 1p8G3');

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _dsim18Parser.command18Collection[commandIndex - 180],
      );

      List<RFInOut> rfInOuts = _dsim18Parser.parse1P8GRFInOut(rawData);
      A1P8GRFOutputPowerStatistic a1p8grfOutputPowerStatistic =
          _dsim18Parser.getA1p8GRFOutputPowerStatistic(rfInOuts);

      return [
        true,
        rfInOuts,
        <DataKey, String>{
          DataKey.historicalMinRFOutputPower:
              a1p8grfOutputPowerStatistic.historicalMinRFOutputPower,
          DataKey.historicalMaxRFOutputPower:
              a1p8grfOutputPowerStatistic.historicalMaxRFOutputPower,
        }
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

    print('get data from request command 1p8GForLogChunk');

    if (commandIndex == 184) {
      try {
        List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
          commandIndex: commandIndex,
          value: _dsim18Parser.command18Collection[commandIndex - 180],
        );

        List<Log1p8G> log1p8Gs = _dsim18Parser.parse1P8GLog(rawData);
        A1P8GLogStatistic a1p8gLogStatistic =
            _dsim18Parser.getA1p8GLogStatistics(log1p8Gs);
        bool hasNextChunk = log1p8Gs.isNotEmpty ? true : false;

        return [
          true,
          hasNextChunk,
          log1p8Gs,
          <DataKey, String>{
            DataKey.historicalMinTemperatureC:
                a1p8gLogStatistic.historicalMinTemperatureC,
            DataKey.historicalMaxTemperatureC:
                a1p8gLogStatistic.historicalMaxTemperatureC,
            DataKey.historicalMinTemperatureF:
                a1p8gLogStatistic.historicalMinTemperatureF,
            DataKey.historicalMaxTemperatureF:
                a1p8gLogStatistic.historicalMaxTemperatureF,
            DataKey.historicalMinVoltage:
                a1p8gLogStatistic.historicalMinVoltage,
            DataKey.historicalMaxVoltage:
                a1p8gLogStatistic.historicalMaxVoltage,
            DataKey.historicalMinVoltageRipple:
                a1p8gLogStatistic.historicalMinVoltageRipple,
            DataKey.historicalMaxVoltageRipple:
                a1p8gLogStatistic.historicalMaxVoltageRipple,
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
        List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
          commandIndex: commandIndex,
          value: _dsim18Parser.command18Collection[commandIndex - 180],
        );

        List<Log1p8G> log1p8Gs = _dsim18Parser.parse1P8GLog(rawData);
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

  Future<dynamic> requestCommand1p8GEvent() async {
    int commandIndex = 194;

    print('get data from request command 1p8G_Event');

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _dsim18Parser.command18Collection[commandIndex - 180],
      );

      List<Event1p8G> event1p8Gs = _dsim18Parser.parse1p8GEvent(rawData);
      return [
        true,
        event1p8Gs,
      ];
    } catch (e) {
      return [
        false,
      ];
    }
  }

  Future<dynamic> requestCommand1p8GAlarm() async {
    int commandIndex = 182;

    print('get data from request command 1p8G_Alarm');

    List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
      commandIndex: commandIndex,
      value: _dsim18Parser.command18Collection[commandIndex - 180],
    );

    try {
      A1P8GAlarm a1p8gAlarm = _dsim18Parser.decodeAlarmSeverity(rawData);
      return [
        true,
        a1p8gAlarm.unitStatusAlarmSeverity,
        a1p8gAlarm.temperatureAlarmSeverity,
        a1p8gAlarm.powerAlarmSeverity,
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
    return _dsim18Parser.get1p8GDateValueCollectionOfLogs(log1p8Gs);
  }

  List<List<ValuePair>> get1p8GValueCollectionOfRFInOut(
      List<RFInOut> rfInOuts) {
    return _dsim18Parser.get1p8GValueCollectionOfRFInOut(rfInOuts);
  }

  void clearDsim18ChartCache() {
    _dsim18ChartCache.clearCache();
  }

  void writeEvent1p8Gs(List<Event1p8G> event1p8Gs) {
    _dsim18ChartCache.writeEvent1p8Gs(event1p8Gs);
  }

  void writeLoadMoreLog1p8Gs(List<Log1p8G> log1p8Gs) {
    _dsim18ChartCache.writeLoadMoreLog1p8Gs(log1p8Gs);
  }

  void writeAllLog1p8Gs(List<Log1p8G> log1p8Gs) {
    _dsim18ChartCache.writeAllLog1p8Gs(log1p8Gs);
  }

  Future<dynamic> export1p8GRecords() async {
    List<Log1p8G> log1p8Gs = _dsim18ChartCache.readLoadMoreLog1p8Gs();
    List<Event1p8G> event1p8Gs = _dsim18ChartCache.readEvent1p8Gs();

    List<dynamic> result = await _dsim18Parser.export1p8GRecords(
      log1p8Gs: log1p8Gs,
      event1p8Gs: event1p8Gs,
    );
    return result;
  }

  Future<dynamic> exportAll1p8GRecords() async {
    List<Log1p8G> log1p8Gs = _dsim18ChartCache.readAllLog1p8Gs();
    List<Event1p8G> event1p8Gs = _dsim18ChartCache.readEvent1p8Gs();

    List<dynamic> result = await _dsim18Parser.export1p8GRecords(
      log1p8Gs: log1p8Gs,
      event1p8Gs: event1p8Gs,
    );
    return result;
  }

  Future<dynamic> export1p8GRFLevels() async {
    List<Log1p8G> log1p8Gs = _dsim18ChartCache.readLoadMoreLog1p8Gs();
    List<Event1p8G> event1p8Gs = _dsim18ChartCache.readEvent1p8Gs();

    List<dynamic> result = await _dsim18Parser.export1p8GRecords(
      log1p8Gs: log1p8Gs,
      event1p8Gs: event1p8Gs,
    );
    return result;
  }

  Future<dynamic> set1p8GMaxTemperature(String temperature) async {
    int commandIndex = 300;

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

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setMaxTemperatureCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GMinTemperature(String temperature) async {
    int commandIndex = 301;

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

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setMinTemperatureCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GMaxVoltage(String valtage) async {
    int commandIndex = 302;

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

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setMaxVoltageCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GMinVoltage(String valtage) async {
    int commandIndex = 303;

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

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setMinVoltageCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GMaxVoltageRipple(String valtageRipple) async {
    int commandIndex = 304;

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

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setMaxVoltageRippleCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GMinVoltageRipple(String valtageRipple) async {
    int commandIndex = 305;

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

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setMinVoltageRippleCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GMaxRFOutputPower(String outputPower) async {
    int commandIndex = 306;

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

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setMaxOutputPowerCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GMinRFOutputPower(String outputPower) async {
    int commandIndex = 307;

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

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setMinOutputPowerCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GReturnIngress2(String ingress) async {
    int commandIndex = 308;

    print('get data from request command 1p8G$commandIndex');

    int ingressNumber = int.parse(ingress);

    Command18.setReturnIngress2Cmd[7] = ingressNumber;

    CRC16.calculateCRC16(
      command: Command18.setReturnIngress2Cmd,
      usDataLength: Command18.setReturnIngress2Cmd.length - 2,
    );
    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setReturnIngress2Cmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GReturnIngress3(String ingress) async {
    int commandIndex = 309;

    print('get data from request command 1p8G$commandIndex');

    int ingressNumber = int.parse(ingress);

    Command18.setReturnIngress3Cmd[7] = ingressNumber;

    CRC16.calculateCRC16(
      command: Command18.setReturnIngress3Cmd,
      usDataLength: Command18.setReturnIngress3Cmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setReturnIngress3Cmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GReturnIngress4(String ingress) async {
    int commandIndex = 310;

    print('get data from request command 1p8G$commandIndex');

    int ingressNumber = int.parse(ingress);

    Command18.setReturnIngress4Cmd[7] = ingressNumber;

    CRC16.calculateCRC16(
      command: Command18.setReturnIngress4Cmd,
      usDataLength: Command18.setReturnIngress4Cmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setReturnIngress4Cmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GTGCCableLength(String value) async {
    int commandIndex = 313;

    print('get data from request command 1p8G$commandIndex');

    int intValue = int.parse(value);

    Command18.setTGCCableLengthCmd[7] = intValue;

    CRC16.calculateCRC16(
      command: Command18.setTGCCableLengthCmd,
      usDataLength: Command18.setTGCCableLengthCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setTGCCableLengthCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GSplitOption(String splitOption) async {
    int commandIndex = 314;

    print('get data from request command 1p8G$commandIndex');

    int splitOptionNumber = int.parse(splitOption);

    Command18.setSplitOptionCmd[7] = splitOptionNumber;

    CRC16.calculateCRC16(
      command: Command18.setSplitOptionCmd,
      usDataLength: Command18.setSplitOptionCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setSplitOptionCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GPilotFrequencyMode(String value) async {
    int commandIndex = 315;

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

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setPilotFrequencyModeCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GForwardAGCMode(String value) async {
    int commandIndex = 316;

    print('get data from request command 1p8G$commandIndex');

    int intValue = int.parse(value);

    Command18.setFowardAGCModeCmd[7] = intValue;

    CRC16.calculateCRC16(
      command: Command18.setFowardAGCModeCmd,
      usDataLength: Command18.setFowardAGCModeCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setFowardAGCModeCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GALCMode(String value) async {
    int commandIndex = 317;

    print('get data from request command 1p8G$commandIndex');

    int intValue = int.parse(value);

    Command18.setALCModeCmd[7] = intValue;

    CRC16.calculateCRC16(
      command: Command18.setALCModeCmd,
      usDataLength: Command18.setALCModeCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setALCModeCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GFirstChannelLoadingFrequency(String value) async {
    int commandIndex = 318;

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

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setFirstChannelLoadingFrequencyCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GLastChannelLoadingFrequency(String value) async {
    int commandIndex = 319;

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

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setLastChannelLoadingFrequencyCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GFirstChannelLoadingLevel(String value) async {
    int commandIndex = 320;

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

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setFirstChannelLoadingLevelCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GLastChannelLoadingLevel(String value) async {
    int commandIndex = 321;

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

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setLastChannelLoadingLevelCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GPilotFrequency1(String value) async {
    int commandIndex = 322;

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

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setPilotFrequency1Cmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GPilotFrequency2(String value) async {
    int commandIndex = 323;

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

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setPilotFrequency2Cmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> setInputPilotLowFrequencyAlarmState(String isEnable) async {
    int commandIndex = 324;

    print('get data from request command 1p8G$commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18.setInputPilotLowFrequencyAlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18.setInputPilotLowFrequencyAlarmStateCmd,
      usDataLength: Command18.setInputPilotLowFrequencyAlarmStateCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setInputPilotLowFrequencyAlarmStateCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> setInputPilotHighFrequencyAlarmState(String isEnable) async {
    int commandIndex = 325;

    print('get data from request command 1p8G$commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18.setInputPilotHighFrequencyAlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18.setInputPilotHighFrequencyAlarmStateCmd,
      usDataLength:
          Command18.setInputPilotHighFrequencyAlarmStateCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setInputPilotHighFrequencyAlarmStateCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> setOutputPilotLowFrequencyAlarmState(String isEnable) async {
    int commandIndex = 326;

    print('get data from request command 1p8G$commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18.setOutputPilotLowFrequencyAlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18.setOutputPilotLowFrequencyAlarmStateCmd,
      usDataLength:
          Command18.setOutputPilotLowFrequencyAlarmStateCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setOutputPilotLowFrequencyAlarmStateCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> setOutputPilotHighFrequencyAlarmState(String isEnable) async {
    int commandIndex = 327;

    print('get data from request command 1p8G$commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18.setOutputPilotHighFrequencyAlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18.setOutputPilotHighFrequencyAlarmStateCmd,
      usDataLength:
          Command18.setOutputPilotHighFrequencyAlarmStateCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setOutputPilotHighFrequencyAlarmStateCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GTemperatureAlarmState(String isEnable) async {
    int commandIndex = 328;

    print('get data from request command 1p8G$commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18.setTemperatureAlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18.setTemperatureAlarmStateCmd,
      usDataLength: Command18.setTemperatureAlarmStateCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setTemperatureAlarmStateCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GVoltageAlarmState(String isEnable) async {
    int commandIndex = 329;

    print('get data from request command 1p8G$commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18.setVoltageAlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18.setVoltageAlarmStateCmd,
      usDataLength: Command18.setVoltageAlarmStateCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setVoltageAlarmStateCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GSplitOptionAlarmState(String isEnable) async {
    int commandIndex = 334;

    print('get data from request command 1p8G$commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18.setSplitOptionAlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18.setSplitOptionAlarmStateCmd,
      usDataLength: Command18.setSplitOptionAlarmStateCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setSplitOptionAlarmStateCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GVoltageRippleAlarmState(String isEnable) async {
    int commandIndex = 335;

    print('get data from request command 1p8G$commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18.setVoltageRippleAlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18.setVoltageRippleAlarmStateCmd,
      usDataLength: Command18.setVoltageRippleAlarmStateCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setVoltageRippleAlarmStateCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GRFOutputPowerAlarmState(String isEnable) async {
    int commandIndex = 336;

    print('get data from request command 1p8G$commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18.setRFOutputPowerAlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18.setRFOutputPowerAlarmStateCmd,
      usDataLength: Command18.setRFOutputPowerAlarmStateCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setRFOutputPowerAlarmStateCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GLocation(String location) async {
    int commandIndex = 337;

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

    CRC16.calculateCRC16(
      command: Command18.setLocationCmd,
      usDataLength: Command18.setLocationCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setLocationCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GLogInterval(String logInterval) async {
    int commandIndex = 338;

    int interval = int.parse(logInterval);

    print('get data from request command 1p8G$commandIndex');

    Command18.setLogIntervalCmd[7] = interval;

    CRC16.calculateCRC16(
      command: Command18.setLogIntervalCmd,
      usDataLength: Command18.setLogIntervalCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setLogIntervalCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GForwardInputAttenuation(String strValue) async {
    int commandIndex = 339;

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

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setForwardInputAttenuationCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GForwardInputEqualizer(String strValue) async {
    int commandIndex = 340;

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

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setForwardInputEqualizerCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GDSVVA2(String strValue) async {
    int commandIndex = 341;

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

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setDSVVA2Cmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GDSSlope2(String strValue) async {
    int commandIndex = 342;

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

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setDSSlope2Cmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GReturnInputAttenuation2(String strValue) async {
    int commandIndex = 343;

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

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setReturnInputAttenuation2Cmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GReturnOutputEqualizer(String strValue) async {
    int commandIndex = 344;

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

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setReturnOutputEqualizerCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8DSVVA3(String strValue) async {
    int commandIndex = 345;

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

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setDSVVA3Cmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8DSVVA4(String strValue) async {
    int commandIndex = 346;

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

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setDSVVA4Cmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GReturnOutputAttenuation(String strValue) async {
    int commandIndex = 347;

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

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setReturnOutputAttenuationCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GReturnInputAttenuation3(String strValue) async {
    int commandIndex = 348;

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

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setReturnInputAttenuation3Cmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GReturnInputAttenuation4(String strValue) async {
    int commandIndex = 349;

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

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setReturnInputAttenuation4Cmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8USTGC(String strValue) async {
    int commandIndex = 350;

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
    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setUSTGCCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GCoordinates(String coordinates) async {
    int commandIndex = 352;

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

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setCoordinatesCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // 設定藍芽串口的資料傳輸延遲時間, 單位為 ms
  // 例如 MTU = 244, 則每傳輸244byte 就會休息 ms 時間再傳下一筆
  Future<dynamic> set1p8GTransmitDelayTime() async {
    int commandIndex = 353;

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

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setTransmitDelayTimeCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GNowDateTime(String deviceNowDateTime) async {
    int commandIndex = 354;

    print('get data from request command 1p8G$commandIndex');

    DateTime dateTime = DateTime.now();
    DateTime deviceDateTime = DateTime.parse(deviceNowDateTime);

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

    int difference = dateTime.difference(deviceDateTime).inMinutes.abs();

    // 如果 device 的now time 跟 目前時間相差大於5分鐘, 則寫入目前時間
    if (difference > 5) {
      try {
        List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
          commandIndex: commandIndex,
          value: Command18.setNowDateTimeCmd,
        );
        return true;
      } catch (e) {
        return false;
      }
    } else {
      return true;
    }
  }

  Future<String> getGPSCoordinates() async {
    return await _dsim18Parser.getGPSCoordinates();
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

  // Future getCompleter() {
  //   return _bleClient.getCompleter();
  // }

  // void testTimeout() {
  //   _bleClient.testTimeout();
  // }

  Future<dynamic> requestCommand0() async {
    int commandIndex = 0;

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
    int commandIndex = 1;

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
    int commandIndex = 2;

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
    int commandIndex = 3;

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
    int commandIndex = 4;
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
    int commandIndex = 5;

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
    int commandIndex = 6;

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
    int commandIndex = 6;

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
      int commandIndex = i;
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
    int commandIndex = chunkIndex;
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
      } else {
        return [
          true,
        ];
      }
    } catch (e) {
      return [false, '', '', '', '', '', '', '', '', '', ''];
    }
  }

  Future requestCommand30To37() async {
    for (int i = 30; i <= 37; i++) {
      int commandIndex = i;

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

  Future<bool> setLocation(String location) async {
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

    List<List<int>> locationCommand = [
      Command.setLoc9Cmd,
      Command.setLocACmd,
      Command.setLocBCmd,
      Command.setLocCCmd
    ];

    for (int i = 0; i <= 3; i++) {
      int commandIndex = i + 40;
      try {
        List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
          commandIndex: commandIndex,
          value: locationCommand[i],
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
      int commandIndex = 44;
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command.set04Cmd,
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
    int intLogIntervalId = int.parse(logIntervalId);

    Command.set04Cmd[7] = 0x08; // 8
    Command.set04Cmd[13] = intLogIntervalId; // Log Minutes 1Byte
    CRC16.calculateCRC16(command: Command.set04Cmd, usDataLength: 19);

    try {
      int commandIndex = 45;
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command.set04Cmd,
      );
    } catch (e) {
      return false;
    }

    // 設定後重新讀取 log interval 來比對是否設定成功
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
    int workingModeId = _getWorkingModeId(workingMode);

    if (hasDualPilot) {
      Command.set04Cmd[7] = workingModeId;
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
      Command.set04Cmd[7] = workingModeId;
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

    int commandIndex = 46;

    if (workingModeId == 1) {
      // AGC
      try {
        List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
          commandIndex: commandIndex,
          value: Command.set04Cmd,
        );

        // 等 30 秒再讀取 working mode
        await Future.delayed(const Duration(seconds: 30));
      } catch (e) {
        return false;
      }
    } else {
      try {
        List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
          commandIndex: commandIndex,
          value: Command.set04Cmd,
        );
      } catch (e) {
        return false;
      }
    }

    // 設定後重新讀取 working mode 來比對是否設定成功
    List<dynamic> resultOfCommand5 = await requestCommand5();

    if (resultOfCommand5[0]) {
      // 設定 AGC mode 如果失敗會變為 TGC mode
      _characteristicDataStreamController
          .add({DataKey.workingMode: resultOfCommand5[1]});
      _characteristicDataStreamController
          .add({DataKey.currentPilot: resultOfCommand5[2]});
      _characteristicDataStreamController
          .add({DataKey.currentPilotMode: resultOfCommand5[3]});

      _characteristicDataStreamController
          .add({DataKey.currentAttenuation: currentAttenuation.toString()});

      if (workingMode == resultOfCommand5[1]) {
        return true;
      } else {
        return false;
      }
    } else {
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

  Future<dynamic> exportRecords() async {
    return _dsimParser.exportRecords();
  }

  List<List<ValuePair>> getDateValueCollectionOfLogs() {
    return _dsimParser.getDateValueCollectionOfLogs();
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
