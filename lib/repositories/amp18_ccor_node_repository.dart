import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:aci_plus_app/core/command.dart';
import 'package:aci_plus_app/core/command18_c_core_node.dart';
import 'package:aci_plus_app/core/crc16_calculate.dart';
import 'package:aci_plus_app/repositories/ble_client.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_chart_cache.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_parser.dart';
import 'package:aci_plus_app/repositories/amp18_parser.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_speed_chart/speed_chart.dart';

class Amp18CCorNodeRepository {
  Amp18CCorNodeRepository()
      : _bleClient = BLEClient.instance,
        _amp18CCorNodeParser = Amp18CCorNodeParser(),
        _amp18CCorNodeChartCache = Amp18CCorNodeChartCache();

  final BLEClient _bleClient;
  final Amp18CCorNodeChartCache _amp18CCorNodeChartCache;
  final Amp18CCorNodeParser _amp18CCorNodeParser;

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

  Future<dynamic> requestCommand1p8GCCorNode80() async {
    int commandIndex = 180;

    print('get data from request command 1p8G0');

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _amp18CCorNodeParser
            .command18CCorNodeCollection[commandIndex - 180],
      );

      A1P8GCCorNode80 a1p8gcCorNode80 =
          _amp18CCorNodeParser.decodeA1P8GCCorNode80(rawData);

      Map<DataKey, String> characteristicDataCache = {
        DataKey.partName: a1p8gcCorNode80.partName,
        DataKey.partNo: a1p8gcCorNode80.partNo,
        DataKey.partId: a1p8gcCorNode80.partId,
        DataKey.serialNumber: a1p8gcCorNode80.serialNumber,
        DataKey.firmwareVersion: a1p8gcCorNode80.firmwareVersion,
        DataKey.mfgDate: a1p8gcCorNode80.mfgDate,
        DataKey.coordinates: a1p8gcCorNode80.coordinate,
        DataKey.nowDateTime: a1p8gcCorNode80.nowDateTime,
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

  Future<dynamic> requestCommand1p8GCCorNode91() async {
    int commandIndex = 181;

    print('get data from request command 1p8G0');

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _amp18CCorNodeParser
            .command18CCorNodeCollection[commandIndex - 180],
      );

      A1P8GCCorNode91 a1p8gcCorNode91 =
          _amp18CCorNodeParser.decodeA1P8GCCorNode91(rawData);

      Map<DataKey, String> characteristicDataCache = {
        DataKey.maxTemperatureC: a1p8gcCorNode91.maxTemperatureC,
        DataKey.minTemperatureC: a1p8gcCorNode91.minTemperatureC,
        DataKey.maxTemperatureF: a1p8gcCorNode91.maxTemperatureF,
        DataKey.minTemperatureF: a1p8gcCorNode91.minTemperatureF,
        DataKey.maxVoltage: a1p8gcCorNode91.maxVoltage,
        DataKey.minVoltage: a1p8gcCorNode91.minVoltage,
        DataKey.maxRFOutputPower1: a1p8gcCorNode91.maxRFOutputPower1,
        DataKey.minRFOutputPower1: a1p8gcCorNode91.minRFOutputPower1,
        DataKey.ingressSetting1: a1p8gcCorNode91.ingressSetting1,
        DataKey.ingressSetting3: a1p8gcCorNode91.ingressSetting3,
        DataKey.ingressSetting4: a1p8gcCorNode91.ingressSetting4,
        DataKey.ingressSetting6: a1p8gcCorNode91.ingressSetting6,
        DataKey.splitOption: a1p8gcCorNode91.splitOption,
        DataKey.maxRFOutputPower3: a1p8gcCorNode91.maxRFOutputPower3,
        DataKey.minRFOutputPower3: a1p8gcCorNode91.minRFOutputPower3,
        DataKey.forwardVVA1: a1p8gcCorNode91.forwardVVA1,
        DataKey.forwardInSlope1: a1p8gcCorNode91.forwardInSlope1,
        DataKey.forwardOutSlope1: a1p8gcCorNode91.forwardOutSlope1,
        DataKey.returnVCA1: a1p8gcCorNode91.returnVCA1,
        DataKey.rfOutputPower1AlarmState:
            a1p8gcCorNode91.rfOutputPower1AlarmState,
        DataKey.rfOutputPower3AlarmState:
            a1p8gcCorNode91.rfOutputPower3AlarmState,
        DataKey.rfOutputPower4AlarmState:
            a1p8gcCorNode91.rfOutputPower4AlarmState,
        DataKey.rfOutputPower6AlarmState:
            a1p8gcCorNode91.rfOutputPower6AlarmState,
        DataKey.temperatureAlarmState: a1p8gcCorNode91.temperatureAlarmState,
        DataKey.voltageAlarmState: a1p8gcCorNode91.voltageAlarmState,
        DataKey.maxRFOutputPower4: a1p8gcCorNode91.maxRFOutputPower4,
        DataKey.minRFOutputPower4: a1p8gcCorNode91.minRFOutputPower4,
        DataKey.splitOptionAlarmState: a1p8gcCorNode91.splitOptionAlarmState,
        DataKey.location: a1p8gcCorNode91.location,
        DataKey.logInterval: a1p8gcCorNode91.logInterval,
        DataKey.forwardVVA3: a1p8gcCorNode91.forwardVVA3,
        DataKey.forwardInSlope3: a1p8gcCorNode91.forwardInSlope3,
        DataKey.forwardOutSlope3: a1p8gcCorNode91.forwardOutSlope3,
        DataKey.returnVCA3: a1p8gcCorNode91.returnVCA3,
        DataKey.forwardVVA4: a1p8gcCorNode91.forwardVVA4,
        DataKey.forwardInSlope4: a1p8gcCorNode91.forwardInSlope4,
        DataKey.forwardOutSlope4: a1p8gcCorNode91.forwardOutSlope4,
        DataKey.returnVCA4: a1p8gcCorNode91.returnVCA4,
        DataKey.forwardVVA6: a1p8gcCorNode91.forwardVVA6,
        DataKey.forwardInSlope6: a1p8gcCorNode91.forwardInSlope6,
        DataKey.forwardOutSlope6: a1p8gcCorNode91.forwardOutSlope6,
        DataKey.returnVCA6: a1p8gcCorNode91.returnVCA6,
        DataKey.maxRFOutputPower6: a1p8gcCorNode91.maxRFOutputPower6,
        DataKey.minRFOutputPower6: a1p8gcCorNode91.minRFOutputPower6,
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

  Future<dynamic> requestCommand1p8GCCorNodeA1() async {
    int commandIndex = 182;

    print('get data from request command 1p8G0');

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _amp18CCorNodeParser
            .command18CCorNodeCollection[commandIndex - 180],
      );

      A1P8GCCorNodeA1 a1p8gcCorNodeA1 =
          _amp18CCorNodeParser.decodeA1P8GCCorNodeA1(rawData);

      Map<DataKey, String> characteristicDataCache = {
        DataKey.currentTemperatureC: a1p8gcCorNodeA1.currentTemperatureC,
        DataKey.currentTemperatureF: a1p8gcCorNodeA1.currentTemperatureF,
        DataKey.currentVoltage: a1p8gcCorNodeA1.currentVoltage,
        DataKey.currentVoltageRipple: a1p8gcCorNodeA1.currentVoltageRipple,
        DataKey.currentRFOutputPower1: a1p8gcCorNodeA1.currentRFOutputPower1,
        DataKey.currentRFOutputPower3: a1p8gcCorNodeA1.currentRFOutputPower3,
        DataKey.currentRFOutputPower4: a1p8gcCorNodeA1.currentRFOutputPower4,
        DataKey.currentRFOutputPower6: a1p8gcCorNodeA1.currentRFOutputPower6,
        DataKey.currentForwardVVA1: a1p8gcCorNodeA1.currentForwardVVA1,
        DataKey.currentForwardInSlope1: a1p8gcCorNodeA1.currentForwardInSlope1,
        DataKey.currentForwardOutSlope1:
            a1p8gcCorNodeA1.currentForwardOutSlope1,
        DataKey.currentReturnVCA1: a1p8gcCorNodeA1.currentReturnVCA1,
        DataKey.currentForwardVVA3: a1p8gcCorNodeA1.currentForwardVVA3,
        DataKey.currentForwardInSlope3: a1p8gcCorNodeA1.currentForwardInSlope3,
        DataKey.currentForwardOutSlope3:
            a1p8gcCorNodeA1.currentForwardOutSlope3,
        DataKey.currentReturnVCA3: a1p8gcCorNodeA1.currentReturnVCA3,
        DataKey.currentForwardVVA4: a1p8gcCorNodeA1.currentForwardVVA4,
        DataKey.currentForwardInSlope4: a1p8gcCorNodeA1.currentForwardInSlope4,
        DataKey.currentForwardOutSlope4:
            a1p8gcCorNodeA1.currentForwardOutSlope4,
        DataKey.currentReturnVCA4: a1p8gcCorNodeA1.currentReturnVCA4,
        DataKey.currentForwardVVA6: a1p8gcCorNodeA1.currentForwardVVA6,
        DataKey.currentForwardInSlope6: a1p8gcCorNodeA1.currentForwardInSlope6,
        DataKey.currentForwardOutSlope6:
            a1p8gcCorNodeA1.currentForwardOutSlope6,
        DataKey.currentReturnVCA6: a1p8gcCorNodeA1.currentReturnVCA6,
        DataKey.currentWorkingMode: a1p8gcCorNodeA1.currentWorkingMode,
        DataKey.currentDetectedSplitOption:
            a1p8gcCorNodeA1.currentDetectedSplitOption,
        DataKey.unitStatusAlarmSeverity:
            a1p8gcCorNodeA1.unitStatusAlarmSeverity,
        DataKey.temperatureAlarmSeverity:
            a1p8gcCorNodeA1.temperatureAlarmSeverity,
        DataKey.voltageAlarmSeverity: a1p8gcCorNodeA1.voltageAlarmSeverity,
        DataKey.splitOptionAlarmSeverity:
            a1p8gcCorNodeA1.splitOptionAlarmSeverity,
        DataKey.voltageRippleAlarmSeverity:
            a1p8gcCorNodeA1.voltageRippleAlarmSeverity,
        DataKey.rfOutputPower1AlarmSeverity:
            a1p8gcCorNodeA1.rfOutputPower1AlarmSeverity,
        DataKey.rfOutputPower3AlarmSeverity:
            a1p8gcCorNodeA1.rfOutputPower3AlarmSeverity,
        DataKey.rfOutputPower4AlarmSeverity:
            a1p8gcCorNodeA1.rfOutputPower4AlarmSeverity,
        DataKey.rfOutputPower6AlarmSeverity:
            a1p8gcCorNodeA1.rfOutputPower6AlarmSeverity,
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

  Future<dynamic> requestCommand1p8GCCorNodeAlarm() async {
    int commandIndex = 182;

    print('get data from request command 1p8G_Alarm');

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _amp18CCorNodeParser
            .command18CCorNodeCollection[commandIndex - 180],
      );

      A1P8GAlarm a1p8gAlarm = _amp18CCorNodeParser.decodeAlarmSeverity(rawData);

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

  // commandIndex range from 184 to 193;
  // commandIndex = 184 時獲取最新的1024筆Log的統計資料跟 log
  Future<dynamic> requestCommand1p8GCCorNodeLogChunk(int chunkIndex) async {
    int commandIndex = chunkIndex + 184;

    print('get data from request command 1p8GForLogChunk');

    if (commandIndex == 184) {
      try {
        List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
          commandIndex: commandIndex,
          value: _amp18CCorNodeParser
              .command18CCorNodeCollection[commandIndex - 181],
        );

        List<Log1p8GCCorNode> log1p8Gs =
            _amp18CCorNodeParser.parse1P8GCCorNodeLog(rawData);
        A1P8GCCorNodeLogStatistic a1p8gcCorNodeLogStatistic =
            _amp18CCorNodeParser.getA1p8GCCorNodeLogStatistics(log1p8Gs);
        bool hasNextChunk = log1p8Gs.isNotEmpty ? true : false;

        return [
          true,
          hasNextChunk,
          log1p8Gs,
          <DataKey, String>{
            DataKey.historicalMinTemperatureC:
                a1p8gcCorNodeLogStatistic.historicalMinTemperatureC,
            DataKey.historicalMaxTemperatureC:
                a1p8gcCorNodeLogStatistic.historicalMaxTemperatureC,
            DataKey.historicalMinTemperatureF:
                a1p8gcCorNodeLogStatistic.historicalMinTemperatureF,
            DataKey.historicalMaxTemperatureF:
                a1p8gcCorNodeLogStatistic.historicalMaxTemperatureF,
            DataKey.historicalMinRFOutputPower1:
                a1p8gcCorNodeLogStatistic.historicalMinRFOutputPower1,
            DataKey.historicalMaxRFOutputPower1:
                a1p8gcCorNodeLogStatistic.historicalMaxRFOutputPower1,
            DataKey.historicalMinRFOutputPower3:
                a1p8gcCorNodeLogStatistic.historicalMinRFOutputPower3,
            DataKey.historicalMaxRFOutputPower3:
                a1p8gcCorNodeLogStatistic.historicalMaxRFOutputPower3,
            DataKey.historicalMinRFOutputPower4:
                a1p8gcCorNodeLogStatistic.historicalMinRFOutputPower4,
            DataKey.historicalMaxRFOutputPower4:
                a1p8gcCorNodeLogStatistic.historicalMaxRFOutputPower4,
            DataKey.historicalMinRFOutputPower6:
                a1p8gcCorNodeLogStatistic.historicalMinRFOutputPower6,
            DataKey.historicalMaxRFOutputPower6:
                a1p8gcCorNodeLogStatistic.historicalMaxRFOutputPower6,
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
          value: _amp18CCorNodeParser
              .command18CCorNodeCollection[commandIndex - 181],
        );

        List<Log1p8GCCorNode> log1p8Gs =
            _amp18CCorNodeParser.parse1P8GCCorNodeLog(rawData);
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

  Future<dynamic> requestCommand1p8GCCorNodeEvent() async {
    int commandIndex = 194;

    print('get data from request command 1p8G_Event');

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _amp18CCorNodeParser
            .command18CCorNodeCollection[commandIndex - 181],
      );

      List<Event1p8GCCorNode> event1p8Gs =
          _amp18CCorNodeParser.parse1p8GCCorNodeEvent(rawData);
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

  Future<dynamic> export1p8GCCorNodeRecords({
    required String code,
  }) async {
    List<Log1p8GCCorNode> log1p8Gs =
        _amp18CCorNodeChartCache.readLoadMoreLog1p8Gs();
    List<Event1p8GCCorNode> event1p8Gs =
        _amp18CCorNodeChartCache.readEvent1p8Gs();

    String coordinate = _characteristicDataCache[DataKey.coordinates] ?? '';
    String location = _characteristicDataCache[DataKey.location] ?? '';

    List<dynamic> result = await _amp18CCorNodeParser.export1p8GCCorNodeRecords(
      code: code,
      coordinate: coordinate,
      location: location,
      log1p8Gs: log1p8Gs,
      event1p8Gs: event1p8Gs,
    );
    return result;
  }

  Future<dynamic> exportAll1p8GCCorNodeRecords({
    required String code,
  }) async {
    List<Log1p8GCCorNode> log1p8Gs = _amp18CCorNodeChartCache.readAllLog1p8Gs();
    List<Event1p8GCCorNode> event1p8Gs =
        _amp18CCorNodeChartCache.readEvent1p8Gs();

    String coordinate = _characteristicDataCache[DataKey.coordinates] ?? '';
    String location = _characteristicDataCache[DataKey.location] ?? '';
    List<dynamic> result = await _amp18CCorNodeParser.export1p8GCCorNodeRecords(
      code: code,
      coordinate: coordinate,
      location: location,
      log1p8Gs: log1p8Gs,
      event1p8Gs: event1p8Gs,
    );
    return result;
  }

  List<List<ValuePair>> get1p8GCCorNodeDateValueCollectionOfLogs(
      List<Log1p8GCCorNode> log1p8Gs) {
    return _amp18CCorNodeParser.get1p8GDateValueCollectionOfLogs(log1p8Gs);
  }

  void clearEvent1p8GCCorNodes() {
    _amp18CCorNodeChartCache.clearEvent1p8Gs();
  }

  void clearLoadMoreLog1p8GCCorNodes() {
    _amp18CCorNodeChartCache.clearLoadMoreLog1p8Gs();
  }

  void clearAllLog1p8GCCorNodes() {
    _amp18CCorNodeChartCache.clearAllLog1p8Gs();
  }

  void writeEvent1p8GCCorNodes(List<Event1p8GCCorNode> event1p8Gs) {
    _amp18CCorNodeChartCache.writeEvent1p8Gs(event1p8Gs);
  }

  void writeLoadMoreLog1p8GCCorNodes(List<Log1p8GCCorNode> log1p8Gs) {
    _amp18CCorNodeChartCache.writeLoadMoreLog1p8Gs(log1p8Gs);
  }

  void writeAllLog1p8GCCorNodes(List<Log1p8GCCorNode> log1p8Gs) {
    _amp18CCorNodeChartCache.writeAllLog1p8Gs(log1p8Gs);
  }

  Future<dynamic> set1p8GCCorNodeMaxTemperature(String temperature) async {
    int commandIndex = 300;

    print('set data from request command 1p8G CCor Node $commandIndex');

    double dMaxTemperature = double.parse(temperature);

    int max = (dMaxTemperature * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, max, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18CCorNode.setMaxTemperatureCmd[7] = bytes[0];
    Command18CCorNode.setMaxTemperatureCmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18CCorNode.setMaxTemperatureCmd,
      usDataLength: Command18CCorNode.setMaxTemperatureCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18CCorNode.setMaxTemperatureCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GCCorNodeMinTemperature(String temperature) async {
    int commandIndex = 301;

    print('set data from request command 1p8G CCor Node $commandIndex');

    double dMinTemperature = double.parse(temperature);

    int min = (dMinTemperature * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, min, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18CCorNode.setMinTemperatureCmd[7] = bytes[0];
    Command18CCorNode.setMinTemperatureCmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18CCorNode.setMinTemperatureCmd,
      usDataLength: Command18CCorNode.setMinTemperatureCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18CCorNode.setMinTemperatureCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GCCorNodeMaxVoltage(String valtage) async {
    int commandIndex = 302;

    print('set data from request command 1p8G CCor Node $commandIndex');

    double dMaxVoltage = double.parse(valtage);

    int max = (dMaxVoltage * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, max, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18CCorNode.setMaxVoltageCmd[7] = bytes[0];
    Command18CCorNode.setMaxVoltageCmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18CCorNode.setMaxVoltageCmd,
      usDataLength: Command18CCorNode.setMaxVoltageCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18CCorNode.setMaxVoltageCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GCCorNodeMinVoltage(String valtage) async {
    int commandIndex = 303;

    print('set data from request command 1p8G CCor Node $commandIndex');

    double dMinVoltage = double.parse(valtage);

    int min = (dMinVoltage * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, min, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18CCorNode.setMinVoltageCmd[7] = bytes[0];
    Command18CCorNode.setMinVoltageCmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18CCorNode.setMinVoltageCmd,
      usDataLength: Command18CCorNode.setMinVoltageCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18CCorNode.setMinVoltageCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GCCorNodeMaxRFOutputPower1(String outputPower) async {
    int commandIndex = 306;

    print('set data from request command 1p8G CCor Node $commandIndex');

    double dMaxOutputPower = double.parse(outputPower);

    int min = (dMaxOutputPower * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, min, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18CCorNode.setMaxOutputPower1Cmd[7] = bytes[0];
    Command18CCorNode.setMaxOutputPower1Cmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18CCorNode.setMaxOutputPower1Cmd,
      usDataLength: Command18CCorNode.setMaxOutputPower1Cmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18CCorNode.setMaxOutputPower1Cmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GCCorNodeMinRFOutputPower1(String outputPower) async {
    int commandIndex = 307;

    print('set data from request command 1p8G CCor Node $commandIndex');

    double dMinOutputPower = double.parse(outputPower);

    int min = (dMinOutputPower * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, min, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18CCorNode.setMinOutputPower1Cmd[7] = bytes[0];
    Command18CCorNode.setMinOutputPower1Cmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18CCorNode.setMinOutputPower1Cmd,
      usDataLength: Command18CCorNode.setMinOutputPower1Cmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18CCorNode.setMinOutputPower1Cmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GCCorNodeSplitOption(String splitOption) async {
    int commandIndex = 314;

    print('set data from request command 1p8G CCor Node $commandIndex');

    int splitOptionNumber = int.parse(splitOption);

    Command18CCorNode.setSplitOptionCmd[7] = splitOptionNumber;

    CRC16.calculateCRC16(
      command: Command18CCorNode.setSplitOptionCmd,
      usDataLength: Command18CCorNode.setSplitOptionCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18CCorNode.setSplitOptionCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GCCorNodeMaxRFOutputPower3(String outputPower) async {
    int commandIndex = 318;

    print('set data from request command 1p8G CCor Node $commandIndex');

    double dMaxOutputPower = double.parse(outputPower);

    int min = (dMaxOutputPower * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, min, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18CCorNode.setMaxOutputPower3Cmd[7] = bytes[0];
    Command18CCorNode.setMaxOutputPower3Cmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18CCorNode.setMaxOutputPower3Cmd,
      usDataLength: Command18CCorNode.setMaxOutputPower3Cmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18CCorNode.setMaxOutputPower3Cmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GCCorNodeMinRFOutputPower3(String outputPower) async {
    int commandIndex = 319;

    print('set data from request command 1p8G CCor Node $commandIndex');

    double dMinOutputPower = double.parse(outputPower);

    int min = (dMinOutputPower * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, min, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18CCorNode.setMinOutputPower3Cmd[7] = bytes[0];
    Command18CCorNode.setMinOutputPower3Cmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18CCorNode.setMinOutputPower3Cmd,
      usDataLength: Command18CCorNode.setMinOutputPower3Cmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18CCorNode.setMinOutputPower3Cmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GCCorNodeRFOutputPower1AlarmState(
      String isEnable) async {
    int commandIndex = 324;

    print('set data from request command 1p8G CCor Node $commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18CCorNode.setRFOutputPower1AlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18CCorNode.setRFOutputPower1AlarmStateCmd,
      usDataLength: Command18CCorNode.setRFOutputPower1AlarmStateCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18CCorNode.setRFOutputPower1AlarmStateCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GCCorNodeRFOutputPower3AlarmState(
      String isEnable) async {
    int commandIndex = 325;

    print('set data from request command 1p8G CCor Node $commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18CCorNode.setRFOutputPower3AlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18CCorNode.setRFOutputPower3AlarmStateCmd,
      usDataLength: Command18CCorNode.setRFOutputPower3AlarmStateCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18CCorNode.setRFOutputPower3AlarmStateCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GCCorNodeRFOutputPower4AlarmState(
      String isEnable) async {
    int commandIndex = 326;

    print('set data from request command 1p8G CCor Node $commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18CCorNode.setRFOutputPower4AlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18CCorNode.setRFOutputPower4AlarmStateCmd,
      usDataLength: Command18CCorNode.setRFOutputPower4AlarmStateCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18CCorNode.setRFOutputPower4AlarmStateCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GCCorNodeRFOutputPower6AlarmState(
      String isEnable) async {
    int commandIndex = 327;

    print('set data from request command 1p8G CCor Node $commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18CCorNode.setRFOutputPower6AlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18CCorNode.setRFOutputPower6AlarmStateCmd,
      usDataLength: Command18CCorNode.setRFOutputPower6AlarmStateCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18CCorNode.setRFOutputPower6AlarmStateCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GCCorNodeTemperatureAlarmState(String isEnable) async {
    int commandIndex = 328;

    print('set data from request command 1p8G CCor Node $commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18CCorNode.setTemperatureAlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18CCorNode.setTemperatureAlarmStateCmd,
      usDataLength: Command18CCorNode.setTemperatureAlarmStateCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18CCorNode.setTemperatureAlarmStateCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GCCorNodeVoltageAlarmState(String isEnable) async {
    int commandIndex = 329;

    print('set data from request command 1p8G CCor Node $commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18CCorNode.setVoltageAlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18CCorNode.setVoltageAlarmStateCmd,
      usDataLength: Command18CCorNode.setVoltageAlarmStateCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18CCorNode.setVoltageAlarmStateCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GCCorNodeMaxRFOutputPower4(String outputPower) async {
    int commandIndex = 330;

    print('set data from request command 1p8G CCor Node $commandIndex');

    double dMaxOutputPower = double.parse(outputPower);

    int min = (dMaxOutputPower * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, min, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18CCorNode.setMaxOutputPower4Cmd[7] = bytes[0];
    Command18CCorNode.setMaxOutputPower4Cmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18CCorNode.setMaxOutputPower4Cmd,
      usDataLength: Command18CCorNode.setMaxOutputPower4Cmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18CCorNode.setMaxOutputPower4Cmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GCCorNodeMinRFOutputPower4(String outputPower) async {
    int commandIndex = 331;

    print('set data from request command 1p8G CCor Node $commandIndex');

    double dMinOutputPower = double.parse(outputPower);

    int min = (dMinOutputPower * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, min, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18CCorNode.setMinOutputPower4Cmd[7] = bytes[0];
    Command18CCorNode.setMinOutputPower4Cmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18CCorNode.setMinOutputPower4Cmd,
      usDataLength: Command18CCorNode.setMinOutputPower4Cmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18CCorNode.setMinOutputPower4Cmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GCCorNodeSplitOptionAlarmState(String isEnable) async {
    int commandIndex = 334;

    print('set data from request command 1p8G CCor Node $commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18CCorNode.setSplitOptionAlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18CCorNode.setSplitOptionAlarmStateCmd,
      usDataLength: Command18CCorNode.setSplitOptionAlarmStateCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18CCorNode.setSplitOptionAlarmStateCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GCCorNodeLocation(String location) async {
    int commandIndex = 337;

    List<int> locationBytes = [];

    print('set data from request command 1p8G CCor Node $commandIndex');

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
      Command18CCorNode.setLocationCmd[i + 7] = locationBytes[i];
    }

    for (int i = locationBytes.length; i < 96; i += 2) {
      Command18CCorNode.setLocationCmd[i + 7] = 0x20;
      Command18CCorNode.setLocationCmd[i + 8] = 0x00;
    }

    CRC16.calculateCRC16(
      command: Command18CCorNode.setLocationCmd,
      usDataLength: Command18CCorNode.setLocationCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18CCorNode.setLocationCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GCCorNodeLogInterval(String logInterval) async {
    int commandIndex = 338;

    int interval = int.parse(logInterval);

    print('set data from request command 1p8G CCor Node $commandIndex');

    Command18CCorNode.setLogIntervalCmd[7] = interval;

    CRC16.calculateCRC16(
      command: Command18CCorNode.setLogIntervalCmd,
      usDataLength: Command18CCorNode.setLogIntervalCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18CCorNode.setLogIntervalCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GCCorNodeMaxRFOutputPower6(String outputPower) async {
    int commandIndex = 349;

    print('set data from request command 1p8G CCor Node $commandIndex');

    double dMaxOutputPower = double.parse(outputPower);

    int min = (dMaxOutputPower * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, min, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18CCorNode.setMaxOutputPower6Cmd[7] = bytes[0];
    Command18CCorNode.setMaxOutputPower6Cmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18CCorNode.setMaxOutputPower6Cmd,
      usDataLength: Command18CCorNode.setMaxOutputPower6Cmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18CCorNode.setMaxOutputPower6Cmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GCCorNodeMinRFOutputPower6(String outputPower) async {
    int commandIndex = 350;

    print('set data from request command 1p8G CCor Node $commandIndex');

    double dMinOutputPower = double.parse(outputPower);

    int min = (dMinOutputPower * 10).toInt();

    // Convert the integer to bytes
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, min, Endian.little); // little endian
    Uint8List bytes = Uint8List.view(byteData.buffer);

    Command18CCorNode.setMinOutputPower6Cmd[7] = bytes[0];
    Command18CCorNode.setMinOutputPower6Cmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18CCorNode.setMinOutputPower6Cmd,
      usDataLength: Command18CCorNode.setMinOutputPower6Cmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18CCorNode.setMinOutputPower6Cmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GCCorNodeCoordinates(String coordinates) async {
    int commandIndex = 352;

    List<int> coordinatesBytes = [];

    print('set data from request command 1p8G CCor Node $commandIndex');

    coordinatesBytes = coordinates.codeUnits;

    for (int i = 0; i < coordinatesBytes.length; i++) {
      Command18CCorNode.setCoordinatesCmd[i + 7] = coordinatesBytes[i];
    }

    for (int i = coordinatesBytes.length; i < 39; i++) {
      Command18CCorNode.setCoordinatesCmd[i + 7] = 0x20;
    }

    CRC16.calculateCRC16(
      command: Command18CCorNode.setCoordinatesCmd,
      usDataLength: Command18CCorNode.setCoordinatesCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18CCorNode.setCoordinatesCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // 設定藍芽串口的資料傳輸延遲時間, 單位為 ms
  // 例如 MTU = 244, 則每傳輸244byte 就會休息 ms 時間再傳下一筆
  Future<dynamic> set1p8GCCorNodeTransmitDelayTime() async {
    int commandIndex = 353;

    print('set data from request command 1p8G CCor Node $commandIndex');

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

    Command18CCorNode.setTransmitDelayTimeCmd[7] = bytes[0];
    Command18CCorNode.setTransmitDelayTimeCmd[8] = bytes[1];

    CRC16.calculateCRC16(
      command: Command18CCorNode.setTransmitDelayTimeCmd,
      usDataLength: Command18CCorNode.setTransmitDelayTimeCmd.length - 2,
    );

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: Command18CCorNode.setTransmitDelayTimeCmd,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> set1p8GCCorNodeNowDateTime(String deviceNowDateTime) async {
    int commandIndex = 354;

    print('set data from request command 1p8G CCor Node $commandIndex');

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

    Command18CCorNode.setNowDateTimeCmd[7] = yearBytes[0];
    Command18CCorNode.setNowDateTimeCmd[8] = yearBytes[1];
    Command18CCorNode.setNowDateTimeCmd[9] = month;
    Command18CCorNode.setNowDateTimeCmd[10] = day;
    Command18CCorNode.setNowDateTimeCmd[11] = hour;
    Command18CCorNode.setNowDateTimeCmd[12] = minute;

    CRC16.calculateCRC16(
      command: Command18CCorNode.setNowDateTimeCmd,
      usDataLength: Command18CCorNode.setNowDateTimeCmd.length - 2,
    );

    int difference = dateTime.difference(deviceDateTime).inMinutes.abs();

    // 如果 device 的now time 跟 目前時間相差大於5分鐘, 則寫入目前時間
    if (difference > 5) {
      try {
        List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
          commandIndex: commandIndex,
          value: Command18CCorNode.setNowDateTimeCmd,
        );
        return true;
      } catch (e) {
        return false;
      }
    } else {
      return true;
    }
  }

  Future<void> update1p8GCCorNodeCharacteristics() async {
    Map<DataKey, String> characteristicDataCache = {};

    List<dynamic> resultOf1p8GCCorNode80 = await requestCommand1p8GCCorNode80();

    if (resultOf1p8GCCorNode80[0]) {
      _characteristicDataStreamController
          .add(Map<DataKey, String>.from(resultOf1p8GCCorNode80[1]));

      characteristicDataCache.addAll(resultOf1p8GCCorNode80[1]);
    }

    List<dynamic> resultOf1p8GCCorNode91 = await requestCommand1p8GCCorNode91();

    if (resultOf1p8GCCorNode91[0]) {
      _characteristicDataStreamController
          .add(Map<DataKey, String>.from(resultOf1p8GCCorNode91[1]));

      characteristicDataCache.addAll(resultOf1p8GCCorNode91[1]);
    }

    List<dynamic> resultOf1p8GCCorNodeA1 = await requestCommand1p8GCCorNodeA1();
    if (resultOf1p8GCCorNodeA1[0]) {
      _characteristicDataStreamController
          .add(Map<DataKey, String>.from(resultOf1p8GCCorNodeA1[1]));

      characteristicDataCache.addAll(resultOf1p8GCCorNodeA1[1]);
    }

    _characteristicDataCache.clear();
    _characteristicDataCache.addAll(characteristicDataCache);
  }
}
