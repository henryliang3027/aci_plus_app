import 'dart:async';
import 'dart:io';

import 'package:aci_plus_app/core/command18_c_core_node.dart';
import 'package:aci_plus_app/core/crc16_calculate.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_chart_cache.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_parser.dart';
import 'package:aci_plus_app/repositories/ble_client.dart';
import 'package:aci_plus_app/repositories/connection_client.dart';
import 'package:aci_plus_app/repositories/ble_command_mixin.dart';
import 'package:aci_plus_app/repositories/connection_client_factory.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_speed_chart/speed_chart.dart';

class Amp18CCorNodeRepository with BLECommandsMixin {
  Amp18CCorNodeRepository()
      : _connectionClient = ConnectionClientFactory.instance,
        _amp18CCorNodeParser = Amp18CCorNodeParser(),
        _amp18CCorNodeChartCache = Amp18CCorNodeChartCache();

  ConnectionClient _connectionClient;
  final Amp18CCorNodeChartCache _amp18CCorNodeChartCache;
  final Amp18CCorNodeParser _amp18CCorNodeParser;

  // Implement the abstract getter required by the mixin.
  @override
  ConnectionClient get bleClient => _connectionClient;

  // 給設定頁面用來初始化預設值用
  final Map<DataKey, String> _characteristicDataCache = {};

  late StreamController<Map<DataKey, String>>
      _characteristicDataStreamController;

  bool isCreateCharacteristicDataStreamController = false;

  Map<DataKey, String> get characteristicDataCache => _characteristicDataCache;

  Stream<Map<DataKey, String>> get characteristicData async* {
    yield* _characteristicDataStreamController.stream;
  }

  void updateClient() {
    _connectionClient = ConnectionClientFactory.instance;
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
    int commandIndex = 80;

    print('get data from request command 1p8G0');

    try {
      List<int> rawData =
          await _connectionClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value:
            _amp18CCorNodeParser.command18CCorNodeCollection[commandIndex - 80],
      );

      A1P8GCCorNode80 a1p8gcCorNode80 =
          _amp18CCorNodeParser.decodeA1P8GCCorNode80(rawData);

      Map<DataKey, String> characteristicDataCache = {
        DataKey.partName: a1p8gcCorNode80.partName,
        DataKey.partNo: a1p8gcCorNode80.partNo,
        DataKey.partId: a1p8gcCorNode80.partId,
        DataKey.serialNumber: a1p8gcCorNode80.serialNumber,
        DataKey.firmwareVersion: a1p8gcCorNode80.firmwareVersion,
        DataKey.hardwareVersion: a1p8gcCorNode80.hardwareVersion,
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
    int commandIndex = 81;

    print('get data from request command 1p8G0');

    try {
      List<int> rawData =
          await _connectionClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value:
            _amp18CCorNodeParser.command18CCorNodeCollection[commandIndex - 80],
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
        DataKey.forwardConfig: a1p8gcCorNode91.forwardConfig,
        DataKey.splitOption: a1p8gcCorNode91.splitOption,
        DataKey.forwardMode: a1p8gcCorNode91.forwardMode,
        DataKey.maxRFOutputPower3: a1p8gcCorNode91.maxRFOutputPower3,
        DataKey.minRFOutputPower3: a1p8gcCorNode91.minRFOutputPower3,
        DataKey.dsVVA1: a1p8gcCorNode91.dsVVA1,
        DataKey.dsInSlope1: a1p8gcCorNode91.dsInSlope1,
        DataKey.dsOutSlope1: a1p8gcCorNode91.dsOutSlope1,
        DataKey.usVCA1: a1p8gcCorNode91.usVCA1,
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
        DataKey.dsVVA3: a1p8gcCorNode91.dsVVA3,
        DataKey.dsInSlope3: a1p8gcCorNode91.dsInSlope3,
        DataKey.dsOutSlope3: a1p8gcCorNode91.dsOutSlope3,
        DataKey.usVCA3: a1p8gcCorNode91.usVCA3,
        DataKey.dsVVA4: a1p8gcCorNode91.dsVVA4,
        DataKey.dsInSlope4: a1p8gcCorNode91.dsInSlope4,
        DataKey.dsOutSlope4: a1p8gcCorNode91.dsOutSlope4,
        DataKey.usVCA4: a1p8gcCorNode91.usVCA4,
        DataKey.dsVVA6: a1p8gcCorNode91.dsVVA6,
        DataKey.dsInSlope6: a1p8gcCorNode91.dsInSlope6,
        DataKey.dsOutSlope6: a1p8gcCorNode91.dsOutSlope6,
        DataKey.usVCA6: a1p8gcCorNode91.usVCA6,
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

  Future<dynamic> requestCommand1p8GCCorNode92() async {
    int commandIndex = 82;

    print('get data from request command 1p8G1');

    try {
      List<int> rawData =
          await _connectionClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value:
            _amp18CCorNodeParser.command18CCorNodeCollection[commandIndex - 80],
      );

      A1P8GCCorNode92 a1p8gcCorNode92 =
          _amp18CCorNodeParser.decodeA1P8GCCorNode92(rawData);

      Map<DataKey, String> characteristicDataCache = {
        DataKey.biasCurrent1: a1p8gcCorNode92.biasCurrent1,
        DataKey.biasCurrent3: a1p8gcCorNode92.biasCurrent3,
        DataKey.biasCurrent4: a1p8gcCorNode92.biasCurrent4,
        DataKey.biasCurrent6: a1p8gcCorNode92.biasCurrent6,
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

  Future<dynamic> requestCommand1p8GCCorNodeA1({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    int commandIndex = 83;

    print('get data from request command 1p8GA1');

    try {
      List<int> rawData =
          await _connectionClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value:
            _amp18CCorNodeParser.command18CCorNodeCollection[commandIndex - 80],
        timeout: timeout,
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
        DataKey.currentDSVVA1: a1p8gcCorNodeA1.currentDSVVA1,
        DataKey.currentDSInSlope1: a1p8gcCorNodeA1.currentDSInSlope1,
        DataKey.currentDSOutSlope1: a1p8gcCorNodeA1.currentDSOutSlope1,
        DataKey.currentUSVCA1: a1p8gcCorNodeA1.currentUSVCA1,
        DataKey.currentDSVVA3: a1p8gcCorNodeA1.currentDSVVA3,
        DataKey.currentDSInSlope3: a1p8gcCorNodeA1.currentDSInSlope3,
        DataKey.currentDSOutSlope3: a1p8gcCorNodeA1.currentDSOutSlope3,
        DataKey.currentUSVCA3: a1p8gcCorNodeA1.currentUSVCA3,
        DataKey.currentDSVVA4: a1p8gcCorNodeA1.currentDSVVA4,
        DataKey.currentDSInSlope4: a1p8gcCorNodeA1.currentDSInSlope4,
        DataKey.currentDSOutSlope4: a1p8gcCorNodeA1.currentDSOutSlope4,
        DataKey.currentUSVCA4: a1p8gcCorNodeA1.currentUSVCA4,
        DataKey.currentDSVVA6: a1p8gcCorNodeA1.currentDSVVA6,
        DataKey.currentDSInSlope6: a1p8gcCorNodeA1.currentDSInSlope6,
        DataKey.currentDSOutSlope6: a1p8gcCorNodeA1.currentDSOutSlope6,
        DataKey.currentUSVCA6: a1p8gcCorNodeA1.currentUSVCA6,
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
    int commandIndex = 83;

    print('get data from request command 1p8G_Alarm');

    try {
      List<int> rawData =
          await _connectionClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value:
            _amp18CCorNodeParser.command18CCorNodeCollection[commandIndex - 80],
        timeout: const Duration(seconds: 1),
      );

      A1P8GAlarm a1p8gAlarm = decodeAlarmSeverity(rawData);

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

  // commandIndex range from 184 to 193;
  // commandIndex = 184 時獲取最新的1024筆Log的統計資料跟 log
  Future<dynamic> requestCommand1p8GCCorNodeLogChunk(int chunkIndex) async {
    int commandIndex = chunkIndex + 184;

    print('get data from request command 1p8GForLogChunk $commandIndex');

    if (commandIndex == 184) {
      try {
        List<int> rawData =
            await _connectionClient.writeSetCommandToCharacteristic(
          commandIndex: commandIndex,
          value: _amp18CCorNodeParser
              .command18CCorNodeCollection[commandIndex - 180],
          timeout: const Duration(seconds: 8),
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
          false, // hasNextChunk
          e.toString(),
        ];
      }
    } else {
      try {
        List<int> rawData =
            await _connectionClient.writeSetCommandToCharacteristic(
          commandIndex: commandIndex,
          value: _amp18CCorNodeParser
              .command18CCorNodeCollection[commandIndex - 180],
          timeout: const Duration(seconds: 8),
        );

        List<Log1p8GCCorNode> log1p8Gs =
            _amp18CCorNodeParser.parse1P8GCCorNodeLog(rawData);

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

  Future<dynamic> requestCommand1p8GCCorNodeEvent() async {
    int commandIndex = 194;

    print('get data from request command 1p8G_Event');

    try {
      List<int> rawData =
          await _connectionClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _amp18CCorNodeParser
            .command18CCorNodeCollection[commandIndex - 181],
        timeout: const Duration(seconds: 8),
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
        e.toString(),
      ];
    }
  }

  Future<dynamic> requestCommand1p8GCCorNodeUserAttribute({
    Duration timeout = const Duration(seconds: 3),
  }) async {
    int commandIndex = 205;

    print('get data from request command 1p8GUserAttribute');

    try {
      List<int> rawData =
          await _connectionClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _amp18CCorNodeParser.command18CCorNodeCollection[15],
        timeout: timeout,
      );

      A1P8GCCorNodeUserAttribute a1P8GUserAttribute =
          _amp18CCorNodeParser.decodeA1P8GCCorNodeUserAttribute(rawData);

      Map<DataKey, String> characteristicDataCache = {
        DataKey.technicianID: a1P8GUserAttribute.technicianID,
        // DataKey.inputSignalLevel: a1P8GUserAttribute.inputSignalLevel,
        // DataKey.inputAttenuation: a1P8GUserAttribute.inputAttenuation,
        // DataKey.inputEqualizer: a1P8GUserAttribute.inputEqualizer,
        DataKey.cascadePosition: a1P8GUserAttribute.cascadePosition,
        DataKey.deviceName: a1P8GUserAttribute.deviceName,
        DataKey.deviceNote: a1P8GUserAttribute.deviceNote,
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

  Future<bool> set1p8GCCorNodeUserAttribute({
    required String technicianID,
    // required String inputSignalLevel,
    // required String inputAttenuation,
    // required String inputEqualizer,
    required String cascadePosition,
    required String deviceName,
    required String deviceNote,
  }) async {
    int commandIndex = 357;

    print('get data from request command 1p8G$commandIndex');

    List<int> technicianIDBytes = convertStringToInt16List(technicianID);
    // List<int> inputSignalLevelBytes =
    //     convertStringToInt16List(inputSignalLevel);
    // List<int> inputAttenuationBytes =
    //     convertStringToInt16List(inputAttenuation);
    // List<int> inputEqualizerBytes = convertStringToInt16List(inputEqualizer);
    List<int> cascadePositionBytes = convertStringToInt16List(cascadePosition);
    List<int> deviceNameBytes = convertStringToInt16List(deviceName);
    List<int> deviceNoteBytes = convertStringToInt16List(deviceNote);

    List<int> combinedBytes = [
      ...technicianIDBytes,
      0x00,
      0x00,
      // ...inputSignalLevelBytes,
      // 0x00,
      // 0x00,
      // ...inputAttenuationBytes,
      // 0x00,
      // 0x00,
      // ...inputEqualizerBytes,
      // 0x00,
      // 0x00,
      ...cascadePositionBytes,
      0x00,
      0x00,
      ...deviceNameBytes,
      0x00,
      0x00,
      ...deviceNoteBytes,
    ];

    for (int i = 0; i < combinedBytes.length; i++) {
      Command18CCorNode.setUserAttributeCmd[i + 7] = combinedBytes[i];
    }

    // 填入空白
    for (int i = combinedBytes.length; i < 1024; i += 2) {
      Command18CCorNode.setUserAttributeCmd[i + 7] = 0x20;
      Command18CCorNode.setUserAttributeCmd[i + 8] = 0x00;
    }

    CRC16.calculateCRC16(
      command: Command18CCorNode.setUserAttributeCmd,
      usDataLength: Command18CCorNode.setUserAttributeCmd.length - 2,
    );

    if (_connectionClient is BLEClient) {
      // 將 binary 切分成每個大小為 chunkSize 的封包
      int chunkSize = await BLEUtils.getChunkSize();

      List<List<int>> chunks = BLEUtils.divideToChunkList(
        binary: Command18CCorNode.setUserAttributeCmd,
        chunkSize: chunkSize,
      );

      try {
        List<int> rawData =
            await _connectionClient.writeLongSetCommandToCharacteristic(
          commandIndex: commandIndex,
          chunks: chunks,
          timeout: const Duration(seconds: 10),
        );
      } catch (e) {
        return false;
      }
    } else {
      // USBClient
      try {
        List<int> rawData =
            await _connectionClient.writeSetCommandToCharacteristic(
          commandIndex: commandIndex,
          value: Command18CCorNode.setUserAttributeCmd,
          timeout: const Duration(seconds: 10),
        );
      } catch (e) {
        return false;
      }
    }

    return true;
  }

  Future<dynamic> export1p8GCCorNodeRecords({
    required String code,
    required Map<String, String> attributeData,
    required Map<String, String> regulationData,
    required List<Map<String, String>> controlData,
  }) async {
    List<Log1p8GCCorNode> log1p8Gs =
        _amp18CCorNodeChartCache.readLoadMoreLog1p8Gs();
    List<Event1p8GCCorNode> event1p8Gs =
        _amp18CCorNodeChartCache.readEvent1p8Gs();

    List<dynamic> result = await _amp18CCorNodeParser.export1p8GCCorNodeRecords(
      code: code,
      attributeData: attributeData,
      regulationData: regulationData,
      controlData: controlData,
      log1p8Gs: log1p8Gs,
      event1p8Gs: event1p8Gs,
    );
    return result;
  }

  Future<dynamic> exportAll1p8GCCorNodeRecords({
    required String code,
    required Map<String, String> attributeData,
    required Map<String, String> regulationData,
    required List<Map<String, String>> controlData,
  }) async {
    List<Log1p8GCCorNode> log1p8Gs = _amp18CCorNodeChartCache.readAllLog1p8Gs();
    List<Event1p8GCCorNode> event1p8Gs =
        _amp18CCorNodeChartCache.readEvent1p8Gs();

    List<dynamic> result = await _amp18CCorNodeParser.export1p8GCCorNodeRecords(
      code: code,
      attributeData: attributeData,
      regulationData: regulationData,
      controlData: controlData,
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
    return set1p8GTwoBytesParameter(
      value: temperature,
      command: Command18CCorNode.setMaxTemperatureCmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeMinTemperature(String temperature) async {
    return set1p8GTwoBytesParameter(
      value: temperature,
      command: Command18CCorNode.setMinTemperatureCmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeMaxVoltage(String valtage) async {
    return set1p8GTwoBytesParameter(
      value: valtage,
      command: Command18CCorNode.setMaxVoltageCmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeMinVoltage(String valtage) async {
    return set1p8GTwoBytesParameter(
      value: valtage,
      command: Command18CCorNode.setMinVoltageCmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeMaxRFOutputPower1(String outputPower) async {
    return set1p8GTwoBytesParameter(
      value: outputPower,
      command: Command18CCorNode.setMaxOutputPower1Cmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeMinRFOutputPower1(String outputPower) async {
    return set1p8GTwoBytesParameter(
      value: outputPower,
      command: Command18CCorNode.setMinOutputPower1Cmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeReturnIngress1(String ingress) async {
    return set1p8GOneByteParameter(
      value: ingress,
      command: Command18CCorNode.setReturnIngress1Cmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeReturnIngress3(String ingress) async {
    return set1p8GOneByteParameter(
      value: ingress,
      command: Command18CCorNode.setReturnIngress3Cmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeReturnIngress4(String ingress) async {
    return set1p8GOneByteParameter(
      value: ingress,
      command: Command18CCorNode.setReturnIngress4Cmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeReturnIngress6(String ingress) async {
    return set1p8GOneByteParameter(
      value: ingress,
      command: Command18CCorNode.setReturnIngress6Cmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeForwardConfig(String forwardConfig) async {
    return set1p8GOneByteParameter(
      value: forwardConfig,
      command: Command18CCorNode.setForwardConfigCmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeSplitOption(String splitOption) async {
    return set1p8GOneByteParameter(
      value: splitOption,
      command: Command18CCorNode.setSplitOptionCmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeForwardMode(String forwardMode) async {
    return set1p8GOneByteParameter(
      value: forwardMode,
      command: Command18CCorNode.setForwardModeCmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeMaxRFOutputPower3(String outputPower) async {
    return set1p8GTwoBytesParameter(
      value: outputPower,
      command: Command18CCorNode.setMaxOutputPower3Cmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeMinRFOutputPower3(String outputPower) async {
    return set1p8GTwoBytesParameter(
      value: outputPower,
      command: Command18CCorNode.setMinOutputPower3Cmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeDSVVA1(String strValue) async {
    return set1p8GTwoBytesParameter(
      value: strValue,
      command: Command18CCorNode.setDSVVA1Cmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeDSInSlope1(String strValue) async {
    return set1p8GTwoBytesParameter(
      value: strValue,
      command: Command18CCorNode.setDSInSlope1Cmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeDSOutSlope1(String strValue) async {
    return set1p8GTwoBytesParameter(
      value: strValue,
      command: Command18CCorNode.setDSOutSlope1Cmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeUSVCA1(String strValue) async {
    return set1p8GTwoBytesParameter(
      value: strValue,
      command: Command18CCorNode.setUSVCA1Cmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeRFOutputPower1AlarmState(String enable) async {
    return set1p8GOneByteParameter(
      value: enable,
      command: Command18CCorNode.setRFOutputPower1AlarmStateCmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeRFOutputPower3AlarmState(String enable) async {
    return set1p8GOneByteParameter(
      value: enable,
      command: Command18CCorNode.setRFOutputPower3AlarmStateCmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeRFOutputPower4AlarmState(String enable) async {
    return set1p8GOneByteParameter(
      value: enable,
      command: Command18CCorNode.setRFOutputPower4AlarmStateCmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeRFOutputPower6AlarmState(String enable) async {
    return set1p8GOneByteParameter(
      value: enable,
      command: Command18CCorNode.setRFOutputPower6AlarmStateCmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeTemperatureAlarmState(String enable) async {
    return set1p8GOneByteParameter(
      value: enable,
      command: Command18CCorNode.setTemperatureAlarmStateCmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeVoltageAlarmState(String enable) async {
    return set1p8GOneByteParameter(
      value: enable,
      command: Command18CCorNode.setVoltageAlarmStateCmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeMaxRFOutputPower4(String outputPower) async {
    return set1p8GTwoBytesParameter(
      value: outputPower,
      command: Command18CCorNode.setMaxOutputPower4Cmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeMinRFOutputPower4(String outputPower) async {
    return set1p8GTwoBytesParameter(
      value: outputPower,
      command: Command18CCorNode.setMinOutputPower4Cmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeSplitOptionAlarmState(String enable) async {
    return set1p8GOneByteParameter(
      value: enable,
      command: Command18CCorNode.setSplitOptionAlarmStateCmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeLocation(String location) async {
    return set1p8GLocationParameter(
      location: location,
      command: Command18CCorNode.setLocationCmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeLogInterval(String logInterval) async {
    return set1p8GOneByteParameter(
      value: logInterval,
      command: Command18CCorNode.setLogIntervalCmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeDSVVA3(String strValue) async {
    return set1p8GTwoBytesParameter(
      value: strValue,
      command: Command18CCorNode.setDSVVA3Cmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeDSInSlope3(String strValue) async {
    return set1p8GTwoBytesParameter(
      value: strValue,
      command: Command18CCorNode.setDSInSlope3Cmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeDSOutSlope3(String strValue) async {
    return set1p8GTwoBytesParameter(
      value: strValue,
      command: Command18CCorNode.setDSOutSlope3Cmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeUSVCA3(String strValue) async {
    return set1p8GTwoBytesParameter(
      value: strValue,
      command: Command18CCorNode.setUSVCA3Cmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeDSVVA4(String strValue) async {
    return set1p8GTwoBytesParameter(
      value: strValue,
      command: Command18CCorNode.setDSVVA4Cmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeDSInSlope4(String strValue) async {
    return set1p8GTwoBytesParameter(
      value: strValue,
      command: Command18CCorNode.setDSInSlope4Cmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeDSOutSlope4(String strValue) async {
    return set1p8GTwoBytesParameter(
      value: strValue,
      command: Command18CCorNode.setDSOutSlope4Cmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeUSVCA4(String strValue) async {
    return set1p8GTwoBytesParameter(
      value: strValue,
      command: Command18CCorNode.setUSVCA4Cmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeDSVVA6(String strValue) async {
    return set1p8GTwoBytesParameter(
      value: strValue,
      command: Command18CCorNode.setDSVVA6Cmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeDSInSlope6(String strValue) async {
    return set1p8GTwoBytesParameter(
      value: strValue,
      command: Command18CCorNode.setDSInSlope6Cmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeDSOutSlope6(String strValue) async {
    return set1p8GTwoBytesParameter(
      value: strValue,
      command: Command18CCorNode.setDSOutSlope6Cmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeUSVCA6(String strValue) async {
    return set1p8GTwoBytesParameter(
      value: strValue,
      command: Command18CCorNode.setUSVCA6Cmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeMaxRFOutputPower6(String outputPower) async {
    return set1p8GTwoBytesParameter(
      value: outputPower,
      command: Command18CCorNode.setMaxOutputPower6Cmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeMinRFOutputPower6(String outputPower) async {
    return set1p8GTwoBytesParameter(
      value: outputPower,
      command: Command18CCorNode.setMinOutputPower6Cmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeCoordinates(String coordinates) async {
    return set1p8GCoordinatesParameter(
      coordinates: coordinates,
      command: Command18CCorNode.setCoordinatesCmd,
    );
  }

  Future<dynamic> set1p8GMTU(int mtu) async {
    return set1p8GTwoBytesParameter(
      value: mtu.toString(),
      command: Command18CCorNode.setMTUCmd,
      factor: 1,
    );
  }

  // 設定藍芽串口的資料傳輸延遲時間, 單位為 ms
  // 例如 MTU = 244, 則每傳輸244byte 就會休息 ms 時間再傳下一筆
  Future<dynamic> set1p8GCCorNodeTransmitDelayTime({int? ms}) async {
    int commandIndex = 353;

    print('set data from request command 1p8G CCor Node $commandIndex');

    // 依據藍牙訊號強度來決定延遲時間, RSSI 為一個負的數值
    if (ms == null) {
      int rssi = await _connectionClient.getRSSI();
      ms = await BLEUtils.getDelayByRSSI(rssi);
      print('RSSI: $rssi, Delay: $ms');
    }

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

    return set1p8GTwoBytesParameter(
      value: ms.toString(),
      command: Command18CCorNode.setTransmitDelayTimeCmd,
      factor: 1,
    );
  }

  Future<dynamic> set1p8GCCorNodeNowDateTime(String nowDateTime) async {
    return set1p8GNowDateTimeParameter(
      nowDateTime: nowDateTime,
      command: Command18CCorNode.setNowDateTimeCmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeBiasCurrent1(String biasCurrent) async {
    return set1p8GTwoBytesParameter(
      value: biasCurrent,
      command: Command18CCorNode.setBiasCurrent1Cmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeBiasCurrent3(String biasCurrent) async {
    return set1p8GTwoBytesParameter(
      value: biasCurrent,
      command: Command18CCorNode.setBiasCurrent3Cmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeBiasCurrent4(String biasCurrent) async {
    return set1p8GTwoBytesParameter(
      value: biasCurrent,
      command: Command18CCorNode.setBiasCurrent4Cmd,
    );
  }

  Future<dynamic> set1p8GCCorNodeBiasCurrent6(String biasCurrent) async {
    return set1p8GTwoBytesParameter(
      value: biasCurrent,
      command: Command18CCorNode.setBiasCurrent6Cmd,
    );
  }

  void clearCharacteristics() {
    _characteristicDataCache.clear();
  }

  Future<void> updateDataWithGivenValuePairs(
      Map<DataKey, String> valuePairs) async {
    _characteristicDataStreamController
        .add(Map<DataKey, String>.from(valuePairs));
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

    List<dynamic> resultOf1p8GCCorNode92 = await requestCommand1p8GCCorNode92();

    if (resultOf1p8GCCorNode92[0]) {
      _characteristicDataStreamController
          .add(Map<DataKey, String>.from(resultOf1p8GCCorNode92[1]));

      characteristicDataCache.addAll(resultOf1p8GCCorNode92[1]);
    }

    List<dynamic> resultOf1p8GCCorNodeA1 = await requestCommand1p8GCCorNodeA1();
    if (resultOf1p8GCCorNodeA1[0]) {
      _characteristicDataStreamController
          .add(Map<DataKey, String>.from(resultOf1p8GCCorNodeA1[1]));

      characteristicDataCache.addAll(resultOf1p8GCCorNodeA1[1]);
    }

    int firmwareVersion = convertFirmwareVersionStringToInt(
        characteristicDataCache[DataKey.firmwareVersion] ?? '0');

    if (firmwareVersion >= 148) {
      List<dynamic> resultOf1p8GCCorNodeUserAttribute =
          await requestCommand1p8GCCorNodeUserAttribute();

      if (resultOf1p8GCCorNodeUserAttribute[0]) {
        _characteristicDataStreamController.add(
            Map<DataKey, String>.from(resultOf1p8GCCorNodeUserAttribute[1]));

        characteristicDataCache.addAll(resultOf1p8GCCorNodeUserAttribute[1]);
      }
    }

    _characteristicDataCache.clear();
    _characteristicDataCache.addAll(characteristicDataCache);
  }

  // 定時更新被取消時, 也同時取消 command 的 timer 和 completer
  void cancelPeriodicUpdateCommand() {
    _connectionClient.cancelCharacteristicDataTimer(name: "Periodic Update");
  }
}
