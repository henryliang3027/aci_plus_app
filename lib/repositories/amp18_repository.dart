import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:aci_plus_app/core/command18.dart';
import 'package:aci_plus_app/core/crc16_calculate.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/repositories/amp18_chart_cache.dart';
import 'package:aci_plus_app/repositories/amp18_parser.dart';
import 'package:aci_plus_app/repositories/ble_windows_client.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_speed_chart/speed_chart.dart';

class Amp18Repository {
  Amp18Repository()
      : _bleClient = BLEWindowsClient.instance,
        _amp18Parser = Amp18Parser(),
        _amp18ChartCache = Amp18ChartCache();

  final BLEWindowsClient _bleClient;
  final Amp18Parser _amp18Parser;
  final Amp18ChartCache _amp18ChartCache;

  // 給設定頁面用來初始化預設值用
  final Map<DataKey, String> _characteristicDataCache = {};

  late StreamController<Map<DataKey, String>>
      _characteristicDataStreamController;

  bool isCreateCharacteristicDataStreamController = false;

  Map<DataKey, String> get characteristicDataCache => _characteristicDataCache;

  Stream<Map<DataKey, String>> get characteristicData async* {
    yield* _characteristicDataStreamController.stream;
  }

  void createCharacteristicDataStream() {
    if (!isCreateCharacteristicDataStreamController) {
      _characteristicDataStreamController =
          StreamController<Map<DataKey, String>>();
      isCreateCharacteristicDataStreamController = true;
    }
  }

  void closeCharacteristicDataStream() async {
    if (isCreateCharacteristicDataStreamController) {
      if (_characteristicDataStreamController.hasListener) {
        if (!_characteristicDataStreamController.isClosed) {
          await _characteristicDataStreamController.close();
          isCreateCharacteristicDataStreamController = false;
        }
      }
    }
  }

  Future<dynamic> requestCommand1p8G0() async {
    int commandIndex = 180;

    print('get data from request command 1p8G0');

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _amp18Parser.command18Collection[commandIndex - 180],
      );

      A1P8G0 a1p8g0 = _amp18Parser.decodeA1P8G0(rawData);

      Map<DataKey, String> characteristicDataCache = {
        DataKey.partName: a1p8g0.partName,
        DataKey.partNo: a1p8g0.partNo,
        DataKey.partId: a1p8g0.partId,
        DataKey.serialNumber: a1p8g0.serialNumber,
        DataKey.firmwareVersion: a1p8g0.firmwareVersion,
        DataKey.hardwareVersion: a1p8g0.hardwareVersion,
        DataKey.mfgDate: a1p8g0.mfgDate,
        DataKey.coordinates: a1p8g0.coordinate,
        DataKey.nowDateTime: a1p8g0.nowDateTime,
      };

      _characteristicDataCache.addAll(characteristicDataCache);

      return [
        true,
        characteristicDataCache,
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
        value: _amp18Parser.command18Collection[commandIndex - 180],
      );

      A1P8G1 a1p8g1 = _amp18Parser.decodeA1P8G1(rawData);

      Map<DataKey, String> characteristicDataCache = {
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
        DataKey.lastChannelLoadingFrequency: a1p8g1.lastChannelLoadingFrequency,
        DataKey.firstChannelLoadingLevel: a1p8g1.firstChannelLoadingLevel,
        DataKey.lastChannelLoadingLevel: a1p8g1.lastChannelLoadingLevel,
        DataKey.pilotFrequency1: a1p8g1.pilotFrequency1,
        DataKey.pilotFrequency2: a1p8g1.pilotFrequency2,
        // DataKey.pilotFrequency1AlarmState: a1p8g1.pilotFrequency1AlarmState,
        // DataKey.pilotFrequency2AlarmState: a1p8g1.pilotFrequency2AlarmState,
        DataKey.rfOutputPilotLowFrequencyAlarmState:
            a1p8g1.rfOutputPilotLowFrequencyAlarmState,
        DataKey.rfOutputPilotHighFrequencyAlarmState:
            a1p8g1.rfOutputPilotHighFrequencyAlarmState,
        DataKey.temperatureAlarmState: a1p8g1.temperatureAlarmState,
        DataKey.voltageAlarmState: a1p8g1.voltageAlarmState,
        DataKey.factoryDefaultNumber: a1p8g1.factoryDefaultNumber,
        DataKey.splitOptionAlarmState: a1p8g1.splitOptionAlarmState,
        DataKey.voltageRippleAlarmState: a1p8g1.voltageRippleAlarmState,
        DataKey.rfOutputPowerAlarmState: a1p8g1.outputPowerAlarmState,
        DataKey.location: a1p8g1.location,
        DataKey.logInterval: a1p8g1.logInterval,
        DataKey.dsVVA1: a1p8g1.dsVVA1,
        DataKey.dsSlope1: a1p8g1.dsSlope1,
        DataKey.dsVVA2: a1p8g1.dsVVA2,
        DataKey.dsSlope2: a1p8g1.dsSlope2,
        DataKey.usVCA1: a1p8g1.usVCA1,
        DataKey.eREQ: a1p8g1.eREQ,
        DataKey.dsVVA3: a1p8g1.dsVVA3,
        DataKey.dsVVA4: a1p8g1.dsVVA4,
        DataKey.dsVVA5: a1p8g1.dsVVA5,
        DataKey.usVCA2: a1p8g1.usVCA2,
        DataKey.usVCA3: a1p8g1.usVCA3,
        DataKey.usVCA4: a1p8g1.usVCA4,
        DataKey.dsSlope3: a1p8g1.dsSlope3,
        DataKey.dsSlope4: a1p8g1.dsSlope4,
        // DataKey.usTGC: a1p8g1.usTGC,
      };

      _characteristicDataCache.addAll(characteristicDataCache);

      return [
        true,
        characteristicDataCache,
      ];
    } catch (e) {
      return [
        false,
      ];
    }
  }

  Future<dynamic> requestCommand1p8G2({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    int commandIndex = 182;

    print('get data from request command 1p8G2');

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _amp18Parser.command18Collection[commandIndex - 180],
        timeout: timeout,
      );

      A1P8G2 a1p8g2 = _amp18Parser.decodeA1P8G2(rawData);

      Map<DataKey, String> characteristicDataCache = {
        DataKey.currentTemperatureC: a1p8g2.currentTemperatureC,
        DataKey.currentTemperatureF: a1p8g2.currentTemperatureF,
        DataKey.currentVoltage: a1p8g2.currentVoltage,
        DataKey.currentVoltageRipple: a1p8g2.currentVoltageRipple,
        DataKey.currentRFInputPower: a1p8g2.currentRFInputPower,
        DataKey.currentRFOutputPower: a1p8g2.currentRFOutputPower,
        DataKey.currentDSVVA1: a1p8g2.currentDSVVA1,
        DataKey.currentDSSlope1: a1p8g2.currentDSSlope1,
        DataKey.currentWorkingMode: a1p8g2.currentWorkingMode,
        DataKey.currentDetectedSplitOption: a1p8g2.currentDetectedSplitOption,
        DataKey.rfOutputOperatingSlope: a1p8g2.rfOutputOperatingSlope,
        DataKey.currentRFInputPower1p8G: a1p8g2.currentRFInputPower1p8G,
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
      };

      _characteristicDataCache.addAll(characteristicDataCache);

      return [
        true,
        characteristicDataCache,
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
        value: _amp18Parser.command18Collection[commandIndex - 180],
      );

      List<RFInOut> rfInOuts = _amp18Parser.parse1P8GRFInOut(rawData);
      A1P8GRFOutputPowerStatistic a1p8grfOutputPowerStatistic =
          _amp18Parser.getA1p8GRFOutputPowerStatistic(rfInOuts);

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
        e.toString(),
      ];
    }
  }

  // commandIndex range from 184 to 193;
  // commandIndex = 184 時獲取最新的1024筆Log的統計資料跟 log
  Future<dynamic> requestCommand1p8GForLogChunk(int chunkIndex) async {
    int commandIndex = chunkIndex + 184;

    print('get data from request command 1p8GForLogChunk $chunkIndex');

    if (commandIndex == 184) {
      try {
        List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
          commandIndex: commandIndex,
          value: _amp18Parser.command18Collection[commandIndex - 180],
        );

        List<Log1p8G> log1p8Gs = _amp18Parser.parse1P8GLog(rawData);
        A1P8GLogStatistic a1p8gLogStatistic =
            _amp18Parser.getA1p8GLogStatistics(log1p8Gs);
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
          false, // hasNextChunk
          e.toString(),
        ];
      }
    } else {
      try {
        List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
          commandIndex: commandIndex,
          value: _amp18Parser.command18Collection[commandIndex - 180],
        );

        List<Log1p8G> log1p8Gs = _amp18Parser.parse1P8GLog(rawData);

        // 如果 log1p8Gs 不為空, 而且不是最後一個 command (index = 193), 就視為還有更多的 log
        bool hasNextChunk =
            log1p8Gs.isNotEmpty && commandIndex != 193 ? true : false;

        return [
          true,
          hasNextChunk,
          log1p8Gs,
        ];
      } catch (e) {
        return [
          false,
          false, // hasNextChunk
          e.toString(),
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
        value: _amp18Parser.command18Collection[commandIndex - 180],
      );

      List<Event1p8G> event1p8Gs = _amp18Parser.parse1p8GEvent(rawData);
      return [
        true,
        event1p8Gs,
      ];
    } catch (e) {
      return [
        false,
        e.toString(),
      ];
    }
  }

  Future<dynamic> requestCommand1p8GAlarm() async {
    int commandIndex = 182;

    print('get data from request command 1p8G_Alarm');

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _amp18Parser.command18Collection[commandIndex - 180],
        timeout: const Duration(seconds: 1),
      );

      A1P8GAlarm a1p8gAlarm = _amp18Parser.decodeAlarmSeverity(rawData);

      return [
        true,
        a1p8gAlarm.unitStatusAlarmSeverity,
        a1p8gAlarm.temperatureAlarmSeverity,
        a1p8gAlarm.powerAlarmSeverity,
      ];
    } catch (e) {
      return [
        false,
      ];
    }
  }

  List<List<ValuePair>> get1p8GDateValueCollectionOfLogs(
      List<Log1p8G> log1p8Gs) {
    return _amp18Parser.get1p8GDateValueCollectionOfLogs(log1p8Gs);
  }

  List<List<ValuePair>> get1p8GValueCollectionOfRFInOut(
      List<RFInOut> rfInOuts) {
    return _amp18Parser.get1p8GValueCollectionOfRFInOut(rfInOuts);
  }

  void clearEvent1p8Gs() {
    _amp18ChartCache.clearEvent1p8Gs();
  }

  void clearLoadMoreLog1p8Gs() {
    _amp18ChartCache.clearLoadMoreLog1p8Gs();
  }

  void clearAllLog1p8Gs() {
    _amp18ChartCache.clearAllLog1p8Gs();
  }

  void clearRFInOuts() {
    _amp18ChartCache.clearRFInOuts();
  }

  void writeEvent1p8Gs(List<Event1p8G> event1p8Gs) {
    _amp18ChartCache.writeEvent1p8Gs(event1p8Gs);
  }

  void writeLoadMoreLog1p8Gs(List<Log1p8G> log1p8Gs) {
    _amp18ChartCache.writeLoadMoreLog1p8Gs(log1p8Gs);
  }

  void writeAllLog1p8Gs(List<Log1p8G> log1p8Gs) {
    _amp18ChartCache.writeAllLog1p8Gs(log1p8Gs);
  }

  void writeRFInOuts(List<RFInOut> rfInOuts) {
    _amp18ChartCache.writeRFInOuts(rfInOuts);
  }

  Future<dynamic> export1p8GRecords({
    required String code,
    required Map<String, String> configurationData,
    required List<Map<String, String>> controlData,
  }) async {
    List<Log1p8G> log1p8Gs = _amp18ChartCache.readLoadMoreLog1p8Gs();
    List<Event1p8G> event1p8Gs = _amp18ChartCache.readEvent1p8Gs();

    // List<DateTime> datetimes = [];

    // for (Log1p8G log1p8G in log1p8Gs) {
    //   datetimes.add(log1p8G.dateTime);

    // }

    // Set<DateTime> uniqueDatetimes = Set<DateTime>();
    // List<DateTime> duplicates = [];

    // for (DateTime datetime in datetimes) {
    //   if (!uniqueDatetimes.add(datetime)) {
    //     duplicates.add(datetime);
    //   }
    // }

    // print("Duplicate elements: $duplicates");

    // String coordinate = _characteristicDataCache[DataKey.coordinates] ?? '';
    // String location = _characteristicDataCache[DataKey.location] ?? '';

    List<dynamic> result = await _amp18Parser.export1p8GRecords(
      code: code,
      configurationData: configurationData,
      controlData: controlData,
      // coordinate: coordinate,
      // location: location,
      log1p8Gs: log1p8Gs,
      event1p8Gs: event1p8Gs,
    );
    return result;
  }

  Future<dynamic> exportAll1p8GRecords({
    required String code,
    required Map<String, String> configurationData,
    required List<Map<String, String>> controlData,
  }) async {
    List<Log1p8G> log1p8Gs = _amp18ChartCache.readAllLog1p8Gs();
    List<Event1p8G> event1p8Gs = _amp18ChartCache.readEvent1p8Gs();

    // String coordinate = _characteristicDataCache[DataKey.coordinates] ?? '';
    // String location = _characteristicDataCache[DataKey.location] ?? '';

    List<dynamic> result = await _amp18Parser.export1p8GRecords(
      code: code,
      configurationData: configurationData,
      controlData: controlData,
      // coordinate: coordinate,
      // location: location,
      log1p8Gs: log1p8Gs,
      event1p8Gs: event1p8Gs,
    );
    return result;
  }

  Future<dynamic> export1p8GRFInOuts({
    required String code,
    required Map<String, String> configurationData,
    required List<Map<String, String>> controlData,
  }) async {
    List<RFInOut> rfInOuts = _amp18ChartCache.readRFInOuts();

    // String coordinate = _characteristicDataCache[DataKey.coordinates] ?? '';
    // String location = _characteristicDataCache[DataKey.location] ?? '';

    List<dynamic> result = await _amp18Parser.export1p8GRFInOuts(
      rfInOuts: rfInOuts,
      code: code,
      configurationData: configurationData,
      controlData: controlData,
      // coordinate: coordinate,
      // location: location,
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

  Future<dynamic> set1p8GFactoryDefault(int number) async {
    int commandIndex = 333;

    print('get data from request command 1p8G$commandIndex');

    Command18.setFactoryDefaultCmd[7] = number;

    CRC16.calculateCRC16(
      command: Command18.setFactoryDefaultCmd,
      usDataLength: Command18.setFactoryDefaultCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setFactoryDefaultCmd,
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

    // 填入空白
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

  Future<dynamic> set1p8GDSVVA1(String strValue) async {
    int commandIndex = 339;

    print('get data from request command 1p8G$commandIndex');

    double doubleValue = double.parse(strValue);

    int intValue = (doubleValue * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, intValue, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setDSVVA1Cmd[7] = bytes[0];
    Command18.setDSVVA1Cmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setDSVVA1Cmd,
      usDataLength: Command18.setDSVVA1Cmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setDSVVA1Cmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GDSSlope1(String strValue) async {
    int commandIndex = 340;

    print('get data from request command 1p8G$commandIndex');

    double doubleValue = double.parse(strValue);

    int intValue = (doubleValue * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, intValue, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setDSSlope1Cmd[7] = bytes[0];
    Command18.setDSSlope1Cmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setDSSlope1Cmd,
      usDataLength: Command18.setDSSlope1Cmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setDSSlope1Cmd,
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

  Future<dynamic> set1p8GUSVCA1(String strValue) async {
    int commandIndex = 343;

    print('get data from request command 1p8G$commandIndex');

    double doubleValue = double.parse(strValue);

    int intValue = (doubleValue * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, intValue, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setUSVCA1Cmd[7] = bytes[0];
    Command18.setUSVCA1Cmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setUSVCA1Cmd,
      usDataLength: Command18.setUSVCA1Cmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setUSVCA1Cmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GEREQ(String strValue) async {
    int commandIndex = 344;

    print('get data from request command 1p8G$commandIndex');

    double doubleValue = double.parse(strValue);

    int intValue = (doubleValue * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, intValue, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setEREQCmd[7] = bytes[0];
    Command18.setEREQCmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setEREQCmd,
      usDataLength: Command18.setEREQCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setEREQCmd,
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

  Future<dynamic> set1p8GDSVVA4(String strValue) async {
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

  Future<dynamic> set1p8GUSVCA2(String strValue) async {
    int commandIndex = 347;

    print('get data from request command 1p8G$commandIndex');

    double doubleValue = double.parse(strValue);

    int intValue = (doubleValue * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, intValue, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setUSVCA2Cmd[7] = bytes[0];
    Command18.setUSVCA2Cmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setUSVCA2Cmd,
      usDataLength: Command18.setUSVCA2Cmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setUSVCA2Cmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GUSVCA3(String strValue) async {
    int commandIndex = 348;

    print('get data from request command 1p8G$commandIndex');

    double doubleValue = double.parse(strValue);

    int intValue = (doubleValue * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, intValue, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setUSVCA3Cmd[7] = bytes[0];
    Command18.setUSVCA3Cmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setUSVCA3Cmd,
      usDataLength: Command18.setUSVCA3Cmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setUSVCA3Cmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GUSVCA4(String strValue) async {
    int commandIndex = 349;

    print('get data from request command 1p8G$commandIndex');

    double doubleValue = double.parse(strValue);

    int intValue = (doubleValue * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, intValue, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setUSVCA4Cmd[7] = bytes[0];
    Command18.setUSVCA4Cmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setUSVCA4Cmd,
      usDataLength: Command18.setUSVCA4Cmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setUSVCA4Cmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GDSVVA5(String strValue) async {
    int commandIndex = 350;

    print('get data from request command 1p8G$commandIndex');

    double doubleValue = double.parse(strValue);

    int intValue = (doubleValue * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, intValue, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setDSVVA5Cmd[7] = bytes[0];
    Command18.setDSVVA5Cmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setDSVVA5Cmd,
      usDataLength: Command18.setDSVVA5Cmd.length - 2,
    );
    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setDSVVA5Cmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8DSSlope3(String strValue) async {
    int commandIndex = 351;

    print('get data from request command 1p8G$commandIndex');

    double doubleValue = double.parse(strValue);

    int intValue = (doubleValue * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, intValue, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setDSSlope3Cmd[7] = bytes[0];
    Command18.setDSSlope3Cmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setDSSlope3Cmd,
      usDataLength: Command18.setDSSlope3Cmd.length - 2,
    );
    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setDSSlope3Cmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8DSSlope4(String strValue) async {
    int commandIndex = 352;

    print('get data from request command 1p8G$commandIndex');

    double doubleValue = double.parse(strValue);

    int intValue = (doubleValue * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, intValue, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18.setDSSlope4Cmd[7] = bytes[0];
    Command18.setDSSlope4Cmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18.setDSSlope4Cmd,
      usDataLength: Command18.setDSSlope4Cmd.length - 2,
    );
    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18.setDSSlope4Cmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GCoordinates(String coordinates) async {
    int commandIndex = 353;

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

  // 設定藍牙串口的資料傳輸延遲時間, 單位為 ms
  // 例如 MTU = 244, 則每傳輸244byte 就會休息 ms 時間再傳下一筆
  Future<dynamic> set1p8GTransmitDelayTime() async {
    int commandIndex = 354;

    print('get data from request command 1p8G$commandIndex');

    int rssi = -65;

    // 依據藍牙訊號強度來決定延遲時間, RSSI 為一個負的數值
    int ms = rssi >= -65 ? 26 : 27;

    if (Platform.isIOS) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;

      // ipad version ex: 16.6.1
      // ios version ex: 16.5
      double version = double.parse(iosDeviceInfo.systemVersion.split('.')[0]);

      if (version < 16) {
        ms = 59;
      }
    }

    print('RSSI: $rssi, Delay: $ms');

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

  Future<dynamic> set1p8GNowDateTime({
    required String partId,
    required String deviceNowDateTime,
  }) async {
    int commandIndex = 355;

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

    // 如果 device 的 now time 跟 目前時間相差大於1440分鐘(24 小時), 則寫入目前時間
    if (difference > 1440) {
      print('sync time on device id $partId');
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

  Future<void> updateDataWithGivenValuePairs(
      Map<DataKey, String> valuePairs) async {
    _characteristicDataStreamController
        .add(Map<DataKey, String>.from(valuePairs));
  }

  Future<void> updateCharacteristics() async {
    Map<DataKey, String> characteristicDataCache = {};

    List<dynamic> resultOf1p8G0 = await requestCommand1p8G0();

    if (resultOf1p8G0[0]) {
      _characteristicDataStreamController
          .add(Map<DataKey, String>.from(resultOf1p8G0[1]));

      characteristicDataCache.addAll(resultOf1p8G0[1]);
    }

    List<dynamic> resultOf1p8G1 = await requestCommand1p8G1();

    if (resultOf1p8G1[0]) {
      _characteristicDataStreamController
          .add(Map<DataKey, String>.from(resultOf1p8G1[1]));

      characteristicDataCache.addAll(resultOf1p8G1[1]);
    }

    List<dynamic> resultOf1p8G2 = await requestCommand1p8G2();
    if (resultOf1p8G2[0]) {
      _characteristicDataStreamController
          .add(Map<DataKey, String>.from(resultOf1p8G2[1]));

      characteristicDataCache.addAll(resultOf1p8G2[1]);
    }

    _characteristicDataCache.clear();
    _characteristicDataCache.addAll(characteristicDataCache);
  }
}
