import 'dart:async';
import 'dart:io';
import 'package:aci_plus_app/core/command18.dart';
import 'package:aci_plus_app/core/crc16_calculate.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/repositories/amp18_chart_cache.dart';
import 'package:aci_plus_app/repositories/amp18_parser.dart';
import 'package:aci_plus_app/repositories/ble_client_base.dart';
import 'package:aci_plus_app/repositories/ble_command_mixin.dart';
import 'package:aci_plus_app/repositories/ble_factory.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:speed_chart/speed_chart.dart';

class Amp18Repository with BLECommandsMixin {
  Amp18Repository()
      : _bleClient = BLEClientFactory.instance,
        _amp18Parser = Amp18Parser(),
        _amp18ChartCache = Amp18ChartCache();

  final BLEClientBase _bleClient;
  final Amp18Parser _amp18Parser;
  final Amp18ChartCache _amp18ChartCache;

  // Implement the abstract getter required by the mixin.
  @override
  BLEClientBase get bleClient => _bleClient;

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
    int commandIndex = 80;

    print('get data from request command 1p8G0');

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _amp18Parser.command18Collection[commandIndex - 80],
      );

      A1P8G0 a1p8g0 = _amp18Parser.decodeA1P8G0(rawData);

      print('Device time: ${a1p8g0.nowDateTime}');

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
        DataKey.bluetoothDelayTime: a1p8g0.bluetoothDelayTime,
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

  Future<dynamic> requestCommand1p8G1({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    int commandIndex = 81;

    print('get data from request command 1p8G1');

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _amp18Parser.command18Collection[commandIndex - 80],
        timeout: timeout,
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
        DataKey.forwardCEQIndex: a1p8g1.forwardCEQIndex,
        DataKey.rfOutputLogInterval: a1p8g1.rfOutputLogInterval,
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
    int commandIndex = 82;

    print('get data from request command 1p8G2');

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _amp18Parser.command18Collection[commandIndex - 80],
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
        DataKey.currentForwardCEQIndex: a1p8g2.currentForwardCEQIndex,
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

  Future<dynamic> requestCommand1p8GAlarm() async {
    int commandIndex = 82;

    print('get data from request command 1p8G_Alarm');

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _amp18Parser.command18Collection[commandIndex - 80],
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

    print('get data from request command 1p8GForLogChunk $commandIndex');

    if (commandIndex == 184) {
      try {
        List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
          commandIndex: commandIndex,
          value: _amp18Parser.command18Collection[commandIndex - 180],
          timeout: const Duration(seconds: 8),
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
          timeout: const Duration(seconds: 8),
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
          false, // no next chunk
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
        timeout: const Duration(seconds: 8),
      );

      List<Event1p8G> event1p8Gs = _amp18Parser.parse1p8GEvent(rawData);
      return [
        true,
        event1p8Gs,
      ];
    } catch (e) {
      return [
        false,
        false, // no next chunk
        e.toString(),
      ];
    }
  }

  Future<dynamic> requestCommand1p8GRFOutputLogChunk(int chunkIndex) async {
    int commandIndex = chunkIndex + 195;

    print('get data from request command 1p8G_RFOuts');

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _amp18Parser.command18Collection[commandIndex - 180],
      );

      List<RFOutputLog> rfOutputLogs =
          _amp18Parser.parse1P8GRFOutputLogs(rawData);
      bool hasNextChunk =
          rfOutputLogs.isNotEmpty && commandIndex != 204 ? true : false;

      return [
        true,
        hasNextChunk,
        rfOutputLogs,
      ];
    } catch (e) {
      return [
        false,
        false, // no next chunk
        e.toString(),
      ];
    }
  }

  Future<dynamic> requestCommand1p8GUserAttribute({
    Duration timeout = const Duration(seconds: 3),
  }) async {
    int commandIndex = 205;

    print('get data from request command 1p8GUserAttribute');

    try {
      List<int> rawData = await _bleClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _amp18Parser.command18Collection[commandIndex - 180],
        timeout: timeout,
      );

      A1P8GUserAttribute a1P8GUserAttribute =
          _amp18Parser.decodeA1P8GUserAttribute(rawData);

      Map<DataKey, String> characteristicDataCache = {
        DataKey.technicianID: a1P8GUserAttribute.technicianID,
        DataKey.inputSignalLevel: a1P8GUserAttribute.inputSignalLevel,
        DataKey.inputAttenuation: a1P8GUserAttribute.inputAttenuation,
        DataKey.inputEqualizer: a1P8GUserAttribute.inputEqualizer,
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

  Future<dynamic> set1p8GUserAttribute({
    required String technicianID,
    required String inputSignalLevel,
    required String inputAttenuation,
    required String inputEqualizer,
    required String cascadePosition,
    required String deviceName,
    required String deviceNote,
  }) async {
    int commandIndex = 357;

    print('get data from request command 1p8G$commandIndex');

    List<int> technicianIDBytes = convertStringToInt16List(technicianID);
    List<int> inputSignalLevelBytes =
        convertStringToInt16List(inputSignalLevel);
    List<int> inputAttenuationBytes =
        convertStringToInt16List(inputAttenuation);
    List<int> inputEqualizerBytes = convertStringToInt16List(inputEqualizer);
    List<int> cascadePositionBytes = convertStringToInt16List(cascadePosition);
    List<int> deviceNameBytes = convertStringToInt16List(deviceName);
    List<int> deviceNoteBytes = convertStringToInt16List(deviceNote);

    List<int> combinedBytes = [
      ...technicianIDBytes,
      0x00,
      0x00,
      ...inputSignalLevelBytes,
      0x00,
      0x00,
      ...inputAttenuationBytes,
      0x00,
      0x00,
      ...inputEqualizerBytes,
      0x00,
      0x00,
      ...cascadePositionBytes,
      0x00,
      0x00,
      ...deviceNameBytes,
      0x00,
      0x00,
      ...deviceNoteBytes,
    ];

    for (int i = 0; i < combinedBytes.length; i++) {
      Command18.setUserAttributeCmd[i + 7] = combinedBytes[i];
    }

    // 填入空白
    for (int i = combinedBytes.length; i < 1024; i += 2) {
      Command18.setUserAttributeCmd[i + 7] = 0x20;
      Command18.setUserAttributeCmd[i + 8] = 0x00;
    }

    CRC16.calculateCRC16(
      command: Command18.setUserAttributeCmd,
      usDataLength: Command18.setUserAttributeCmd.length - 2,
    );

    // 將 binary 切分成每個大小為 chunkSize 的封包
    int chunkSize = await BLEUtils.getChunkSize();

    List<List<int>> chunks = BLEUtils.divideToChunkList(
      binary: Command18.setUserAttributeCmd,
      chunkSize: chunkSize,
    );

    try {
      List<int> rawData = await _bleClient.writeLongSetCommandToCharacteristic(
        commandIndex: commandIndex,
        chunks: chunks,
        timeout: const Duration(seconds: 10),
      );
    } catch (e) {
      return false;
    }

    return true;
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

  void clearRFOutputLogs() {
    _amp18ChartCache.clearRFOutputLogs();
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

  void writeRFOutputLogs(List<RFOutputLog> rfOutputLogs) {
    _amp18ChartCache.writeRFOutputLogs(rfOutputLogs);
  }

  Future<dynamic> export1p8GRecords({
    required String code,
    required Map<String, String> attributeData,
    required Map<String, String> regulationData,
    required List<Map<String, String>> controlData,
  }) async {
    List<Log1p8G> log1p8Gs = _amp18ChartCache.readLoadMoreLog1p8Gs();
    List<Event1p8G> event1p8Gs = _amp18ChartCache.readEvent1p8Gs();

    List<dynamic> result = await _amp18Parser.export1p8GRecords(
      code: code,
      attributeData: attributeData,
      regulationData: regulationData,
      controlData: controlData,
      log1p8Gs: log1p8Gs,
      event1p8Gs: event1p8Gs,
    );
    return result;
  }

  Future<dynamic> exportAll1p8GRecords({
    required String code,
    required Map<String, String> attributeData,
    required Map<String, String> regulationData,
    required List<Map<String, String>> controlData,
  }) async {
    List<Log1p8G> log1p8Gs = _amp18ChartCache.readAllLog1p8Gs();
    List<Event1p8G> event1p8Gs = _amp18ChartCache.readEvent1p8Gs();

    List<dynamic> result = await _amp18Parser.export1p8GRecords(
      code: code,
      attributeData: attributeData,
      regulationData: regulationData,
      controlData: controlData,
      log1p8Gs: log1p8Gs,
      event1p8Gs: event1p8Gs,
    );
    return result;
  }

  Future<dynamic> export1p8GRFInOuts({
    required String code,
    required Map<String, String> attributeData,
    required Map<String, String> regulationData,
    required List<Map<String, String>> controlData,
  }) async {
    List<RFInOut> rfInOuts = _amp18ChartCache.readRFInOuts();

    List<dynamic> result = await _amp18Parser.export1p8GRFInOuts(
      rfInOuts: rfInOuts,
      code: code,
      attributeData: attributeData,
      regulationData: regulationData,
      controlData: controlData,
    );
    return result;
  }

  Future<dynamic> export1p8GAllRFOutputLogs({
    required String code,
    required Map<String, String> attributeData,
    required Map<String, String> regulationData,
    required List<Map<String, String>> controlData,
  }) async {
    List<RFInOut> rfInOuts = _amp18ChartCache.readRFInOuts();
    List<RFOutputLog> rfOutputLogs = _amp18ChartCache.readRFOutputLogs();

    List<dynamic> result = await _amp18Parser.export1p8GAllRFOutputLogs(
      rfInOuts: rfInOuts,
      rfOutputLogs: rfOutputLogs,
      code: code,
      attributeData: attributeData,
      regulationData: regulationData,
      controlData: controlData,
    );
    return result;
  }

  Future<dynamic> set1p8GMaxTemperature(String temperature) async {
    return set1p8GTwoBytesParameter(
      value: temperature,
      command: Command18.setMaxTemperatureCmd,
    );
  }

  Future<dynamic> set1p8GMinTemperature(String temperature) async {
    return set1p8GTwoBytesParameter(
      value: temperature,
      command: Command18.setMinTemperatureCmd,
    );
  }

  Future<dynamic> set1p8GMaxVoltage(String valtage) async {
    return set1p8GTwoBytesParameter(
      value: valtage,
      command: Command18.setMaxVoltageCmd,
    );
  }

  Future<dynamic> set1p8GMinVoltage(String valtage) async {
    return set1p8GTwoBytesParameter(
      value: valtage,
      command: Command18.setMinVoltageCmd,
    );
  }

  Future<dynamic> set1p8GMaxVoltageRipple(String valtageRipple) async {
    return set1p8GTwoBytesParameter(
        value: valtageRipple,
        command: Command18.setMaxVoltageRippleCmd,
        factor: 1);
  }

  Future<dynamic> set1p8GMinVoltageRipple(String valtageRipple) async {
    return set1p8GTwoBytesParameter(
        value: valtageRipple,
        command: Command18.setMinVoltageRippleCmd,
        factor: 1);
  }

  Future<dynamic> set1p8GMaxRFOutputPower(String outputPower) async {
    return set1p8GTwoBytesParameter(
      value: outputPower,
      command: Command18.setMaxOutputPowerCmd,
    );
  }

  Future<dynamic> set1p8GMinRFOutputPower(String outputPower) async {
    return set1p8GTwoBytesParameter(
      value: outputPower,
      command: Command18.setMinOutputPowerCmd,
    );
  }

  Future<dynamic> set1p8GReturnIngress2(String ingress) async {
    return set1p8GOneByteParameter(
      value: ingress,
      command: Command18.setReturnIngress2Cmd,
    );
  }

  Future<dynamic> set1p8GReturnIngress3(String ingress) async {
    return set1p8GOneByteParameter(
      value: ingress,
      command: Command18.setReturnIngress3Cmd,
    );
  }

  Future<dynamic> set1p8GReturnIngress4(String ingress) async {
    return set1p8GOneByteParameter(
      value: ingress,
      command: Command18.setReturnIngress4Cmd,
    );
  }

  Future<dynamic> set1p8GTGCCableLength(String value) async {
    return set1p8GOneByteParameter(
      value: value,
      command: Command18.setTGCCableLengthCmd,
    );
  }

  Future<dynamic> set1p8GSplitOption(String splitOption) async {
    return set1p8GOneByteParameter(
      value: splitOption,
      command: Command18.setSplitOptionCmd,
    );
  }

  Future<dynamic> set1p8GPilotFrequencyMode(String value) async {
    bool isSuccess = await set1p8GOneByteParameter(
      value: value,
      command: Command18.setPilotFrequencyModeCmd,
    );

    // 在 bench mode 切換到其他 mode 時, 需要等待 device 完成更新後再進行其他設定,
    // 否則會導致 device 無法設定成功, 所以增加了額外的 delay, 只要有切換 mode 一律 delay
    await Future.delayed(const Duration(milliseconds: 1000));

    return isSuccess;
  }

  Future<dynamic> set1p8GForwardAGCMode(String value) async {
    return set1p8GOneByteParameter(
      value: value,
      command: Command18.setFowardAGCModeCmd,
    );
  }

  Future<dynamic> set1p8GALCMode(String value) async {
    return set1p8GOneByteParameter(
      value: value,
      command: Command18.setALCModeCmd,
    );
  }

  Future<dynamic> set1p8GFirstChannelLoadingFrequency(String value) async {
    return set1p8GTwoBytesParameter(
      value: value,
      command: Command18.setFirstChannelLoadingFrequencyCmd,
      factor: 1,
    );
  }

  Future<dynamic> set1p8GLastChannelLoadingFrequency(String value) async {
    return set1p8GTwoBytesParameter(
      value: value,
      command: Command18.setLastChannelLoadingFrequencyCmd,
      factor: 1,
    );
  }

  Future<dynamic> set1p8GFirstChannelLoadingLevel(String value) async {
    return set1p8GTwoBytesParameter(
      value: value,
      command: Command18.setFirstChannelLoadingLevelCmd,
    );
  }

  Future<dynamic> set1p8GLastChannelLoadingLevel(String value) async {
    return set1p8GTwoBytesParameter(
      value: value,
      command: Command18.setLastChannelLoadingLevelCmd,
    );
  }

  Future<dynamic> set1p8GPilotFrequency1(String value) async {
    return set1p8GTwoBytesParameter(
      value: value,
      command: Command18.setPilotFrequency1Cmd,
      factor: 1,
    );
  }

  Future<dynamic> set1p8GPilotFrequency2(String value) async {
    return set1p8GTwoBytesParameter(
      value: value,
      command: Command18.setPilotFrequency2Cmd,
      factor: 1,
    );
  }

  Future<dynamic> setInputPilotLowFrequencyAlarmState(String enable) async {
    return set1p8GOneByteParameter(
      value: enable,
      command: Command18.setInputPilotLowFrequencyAlarmStateCmd,
    );
  }

  Future<dynamic> setInputPilotHighFrequencyAlarmState(String enable) async {
    return set1p8GOneByteParameter(
      value: enable,
      command: Command18.setInputPilotHighFrequencyAlarmStateCmd,
    );
  }

  Future<dynamic> setOutputPilotLowFrequencyAlarmState(String enable) async {
    return set1p8GOneByteParameter(
      value: enable,
      command: Command18.setOutputPilotLowFrequencyAlarmStateCmd,
    );
  }

  Future<dynamic> setOutputPilotHighFrequencyAlarmState(String enable) async {
    return set1p8GOneByteParameter(
      value: enable,
      command: Command18.setOutputPilotHighFrequencyAlarmStateCmd,
    );
  }

  Future<dynamic> set1p8GTemperatureAlarmState(String enable) async {
    return set1p8GOneByteParameter(
      value: enable,
      command: Command18.setTemperatureAlarmStateCmd,
    );
  }

  Future<dynamic> set1p8GVoltageAlarmState(String enable) async {
    return set1p8GOneByteParameter(
      value: enable,
      command: Command18.setVoltageAlarmStateCmd,
    );
  }

  Future<dynamic> set1p8GFactoryDefault(int number) async {
    return set1p8GOneByteParameter(
      value: number.toString(),
      command: Command18.setFactoryDefaultCmd,
    );
  }

  Future<dynamic> set1p8GSplitOptionAlarmState(String enable) async {
    return set1p8GOneByteParameter(
      value: enable,
      command: Command18.setSplitOptionAlarmStateCmd,
    );
  }

  Future<dynamic> set1p8GVoltageRippleAlarmState(String enable) async {
    return set1p8GOneByteParameter(
      value: enable,
      command: Command18.setVoltageRippleAlarmStateCmd,
    );
  }

  Future<dynamic> set1p8GRFOutputPowerAlarmState(String enable) async {
    return set1p8GOneByteParameter(
      value: enable,
      command: Command18.setRFOutputPowerAlarmStateCmd,
    );
  }

  Future<dynamic> set1p8GLocation(String location) async {
    return set1p8GLocationParameter(
      location: location,
      command: Command18.setLocationCmd,
    );
  }

  Future<dynamic> set1p8GLogInterval(String logInterval) async {
    return set1p8GOneByteParameter(
      value: logInterval,
      command: Command18.setLogIntervalCmd,
    );
  }

  Future<dynamic> set1p8GRFOutputLogInterval(String rfOutputLogInterval) async {
    return set1p8GOneByteParameter(
      value: rfOutputLogInterval,
      command: Command18.setRFOutputLogIntervalCmd,
    );
  }

  Future<dynamic> set1p8GDSVVA1(String strValue) async {
    return set1p8GTwoBytesParameter(
      value: strValue,
      command: Command18.setDSVVA1Cmd,
    );
  }

  Future<dynamic> set1p8GDSSlope1(String strValue) async {
    return set1p8GTwoBytesParameter(
      value: strValue,
      command: Command18.setDSSlope1Cmd,
    );
  }

  Future<dynamic> set1p8GDSVVA2(String strValue) async {
    return set1p8GTwoBytesParameter(
      value: strValue,
      command: Command18.setDSVVA2Cmd,
    );
  }

  Future<dynamic> set1p8GDSSlope2(String strValue) async {
    return set1p8GTwoBytesParameter(
      value: strValue,
      command: Command18.setDSSlope2Cmd,
    );
  }

  Future<dynamic> set1p8GUSVCA1(String strValue) async {
    return set1p8GTwoBytesParameter(
      value: strValue,
      command: Command18.setUSVCA1Cmd,
    );
  }

  Future<dynamic> set1p8GEREQ(String strValue) async {
    return set1p8GTwoBytesParameter(
      value: strValue,
      command: Command18.setEREQCmd,
    );
  }

  Future<dynamic> set1p8DSVVA3(String strValue) async {
    return set1p8GTwoBytesParameter(
      value: strValue,
      command: Command18.setDSVVA3Cmd,
    );
  }

  Future<dynamic> set1p8GDSVVA4(String strValue) async {
    return set1p8GTwoBytesParameter(
      value: strValue,
      command: Command18.setDSVVA4Cmd,
    );
  }

  Future<dynamic> set1p8GUSVCA2(String strValue) async {
    return set1p8GTwoBytesParameter(
      value: strValue,
      command: Command18.setUSVCA2Cmd,
    );
  }

  Future<dynamic> set1p8GUSVCA3(String strValue) async {
    return set1p8GTwoBytesParameter(
      value: strValue,
      command: Command18.setUSVCA3Cmd,
    );
  }

  Future<dynamic> set1p8GUSVCA4(String strValue) async {
    return set1p8GTwoBytesParameter(
      value: strValue,
      command: Command18.setUSVCA4Cmd,
    );
  }

  Future<dynamic> set1p8GDSVVA5(String strValue) async {
    return set1p8GTwoBytesParameter(
      value: strValue,
      command: Command18.setDSVVA5Cmd,
    );
  }

  Future<dynamic> set1p8GDSSlope3(String strValue) async {
    return set1p8GTwoBytesParameter(
      value: strValue,
      command: Command18.setDSSlope3Cmd,
    );
  }

  Future<dynamic> set1p8GDSSlope4(String strValue) async {
    return set1p8GTwoBytesParameter(
      value: strValue,
      command: Command18.setDSSlope4Cmd,
    );
  }

  Future<dynamic> set1p8GCoordinates(String coordinates) async {
    return set1p8GCoordinatesParameter(
      coordinates: coordinates,
      command: Command18.setCoordinatesCmd,
    );
  }

  Future<dynamic> set1p8GMTU(int mtu) async {
    return set1p8GTwoBytesParameter(
      value: mtu.toString(),
      command: Command18.setMTUCmd,
    );
  }

  // 設定藍牙串口的資料傳輸延遲時間, 單位為 ms
  // 例如 MTU = 244, 則每傳輸244byte 就會休息 ms 時間再傳下一筆
  Future<dynamic> set1p8GTransmitDelayTime({int? ms}) async {
    int commandIndex = 355;

    print('get data from request command 1p8G$commandIndex');

    int rssi = await _bleClient.getRSSI();

    // 依據藍牙訊號強度來決定延遲時間, RSSI 為一個負的數值
    ms ??= getDelayByRSSI(rssi);

    // int ms = 200;

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

    return set1p8GTwoBytesParameter(
      value: ms.toString(),
      command: Command18.setTransmitDelayTimeCmd,
      factor: 1,
    );
  }

  Future<dynamic> set1p8GNowDateTime(
    String nowDateTime,
  ) async {
    return set1p8GNowDateTimeParameter(
      nowDateTime: nowDateTime,
      command: Command18.setNowDateTimeCmd,
    );
  }

  void clearCharacteristics() {
    _characteristicDataCache.clear();
  }

  Future<void> updateDataWithGivenValuePairs(
      Map<DataKey, String> valuePairs) async {
    _characteristicDataStreamController
        .add(Map<DataKey, String>.from(valuePairs));

    _characteristicDataCache.addAll(valuePairs);
  }

  Future<void> updateSettingCharacteristics() async {
    List<dynamic> resultOf1p8G1 = await requestCommand1p8G1();

    if (resultOf1p8G1[0]) {
      // 使用 addAll 直接覆蓋對應的值
      _characteristicDataCache.addAll(resultOf1p8G1[1]);
      print('updateSettingCharacteristics');
    }
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
      print('fcl: ${resultOf1p8G1[1][DataKey.firstChannelLoadingLevel]}');
      print('lcl: ${resultOf1p8G1[1][DataKey.lastChannelLoadingLevel]}');
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

    int firmwareVersion = convertFirmwareVersionStringToInt(
        characteristicDataCache[DataKey.firmwareVersion] ?? '0');

    if (firmwareVersion >= 148) {
      List<dynamic> resultOf1p8GUserAttribute =
          await requestCommand1p8GUserAttribute();

      if (resultOf1p8GUserAttribute[0]) {
        _characteristicDataStreamController
            .add(Map<DataKey, String>.from(resultOf1p8GUserAttribute[1]));

        characteristicDataCache.addAll(resultOf1p8GUserAttribute[1]);
      }
    }

    _characteristicDataCache.clear();
    _characteristicDataCache.addAll(characteristicDataCache);
  }

  // 定時更新被取消時, 也同時取消 command 的 timer 和 completer
  void cancelPeriodicUpdateCommand() {
    _bleClient.cancelCharacteristicDataTimer(name: "Periodic Update");
  }
}
