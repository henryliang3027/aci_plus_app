import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:aci_plus_app/core/command18.dart';
import 'package:aci_plus_app/core/crc16_calculate.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/repositories/amp18_chart_cache.dart';
import 'package:aci_plus_app/repositories/amp18_parser.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/repositories/connection_client.dart';
import 'package:aci_plus_app/repositories/connection_client_factory.dart';
import 'package:aci_plus_app/repositories/mock/amp18_repository_data.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:speed_chart/speed_chart.dart';

class SampleAmp18Repository extends Amp18Repository {
  SampleAmp18Repository()
      : _connectionClient = ConnectionClientFactory.instance,
        _amp18Parser = Amp18Parser(),
        _amp18ChartCache = Amp18ChartCache();

  final ConnectionClient _connectionClient;
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

  @override
  void createCharacteristicDataStream() {
    if (!isCreateCharacteristicDataStreamController) {
      _characteristicDataStreamController =
          StreamController<Map<DataKey, String>>();
      isCreateCharacteristicDataStreamController = true;
    }
  }

  @override
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

  @override
  Future<dynamic> requestCommand1p8G0() async {
    int commandIndex = 80;

    print('get data from request command 1p8G0');

    Map<DataKey, String> characteristicDataCache = {
      DataKey.partName: 'MB',
      DataKey.partNo: 'P1A14X0-0X0G',
      DataKey.partId: '3',
      DataKey.serialNumber: '01110001',
      DataKey.firmwareVersion: '147',
      DataKey.hardwareVersion: '101',
      DataKey.mfgDate: '2023/09/26',
      DataKey.coordinates: '25.0644003000,121.4467530000',
      DataKey.nowDateTime: '2024-10-14 15:05:00',
    };

    _characteristicDataCache.addAll(characteristicDataCache);

    return [
      true,
      characteristicDataCache,
    ];
  }

  @override
  Future<dynamic> requestCommand1p8G1({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    int commandIndex = 81;

    print('get data from request command 1p8G1');

    Map<DataKey, String> characteristicDataCache = {
      DataKey.minTemperatureC: '-40.0',
      DataKey.maxTemperatureC: '85.0',
      DataKey.minTemperatureF: '-40.0',
      DataKey.maxTemperatureF: '185.0',
      DataKey.minVoltage: '23.0',
      DataKey.maxVoltage: '25.0',
      DataKey.minVoltageRipple: '0',
      DataKey.maxVoltageRipple: '500',
      DataKey.minRFOutputPower: '10.0',
      DataKey.maxRFOutputPower: '50.0',
      DataKey.ingressSetting2: '0',
      DataKey.ingressSetting3: '0',
      DataKey.ingressSetting4: '0',
      DataKey.forwardCEQIndex: '0',
      DataKey.rfOutputLogInterval: '30',
      DataKey.tgcCableLength: '27',
      DataKey.splitOption: '1',
      DataKey.pilotFrequencyMode: '1',
      DataKey.agcMode: '0',
      DataKey.alcMode: '0',
      DataKey.firstChannelLoadingFrequency: '262',
      DataKey.lastChannelLoadingFrequency: '1793',
      DataKey.firstChannelLoadingLevel: '25.0',
      DataKey.lastChannelLoadingLevel: '39.0',
      DataKey.pilotFrequency1: '267',
      DataKey.pilotFrequency2: '1209',
      DataKey.rfOutputPilotLowFrequencyAlarmState: '0',
      DataKey.rfOutputPilotHighFrequencyAlarmState: '0',
      DataKey.temperatureAlarmState: '0',
      DataKey.voltageAlarmState: '0',
      DataKey.factoryDefaultNumber: '11',
      DataKey.splitOptionAlarmState: '0',
      DataKey.voltageRippleAlarmState: '0',
      DataKey.rfOutputPowerAlarmState: '0',
      DataKey.location: '23307 66TH Avenue South Kent, WA 98032 U.S.A.',
      DataKey.logInterval: '30',
      DataKey.dsVVA1: '10.0',
      DataKey.dsSlope1: '10.0',
      DataKey.dsVVA2: '0.0',
      DataKey.dsSlope2: '0.0',
      DataKey.usVCA1: '10.0',
      DataKey.eREQ: '10.0',
      DataKey.dsVVA3: '0.0',
      DataKey.dsVVA4: '10.0',
      DataKey.dsVVA5: '10.0',
      DataKey.usVCA2: '10.0',
      DataKey.usVCA3: '10.0',
      DataKey.usVCA4: '10.0',
      DataKey.dsSlope3: '10.0',
      DataKey.dsSlope4: '10.0',
      // DataKey.usTGC: a1p8g1.usTGC,
    };

    _characteristicDataCache.addAll(characteristicDataCache);

    return [
      true,
      characteristicDataCache,
    ];
  }

  @override
  Future<dynamic> requestCommand1p8G2({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    int commandIndex = 82;

    print('get data from request command 1p8G2');

    Map<DataKey, String> characteristicDataCache = {
      DataKey.currentTemperatureC: '29.9',
      DataKey.currentTemperatureF: '85.8',
      DataKey.currentVoltage: '24.3',
      DataKey.currentVoltageRipple: '40',
      DataKey.currentRFInputPower: '0.0',
      DataKey.currentRFOutputPower: '0.0',
      DataKey.currentDSVVA1: '11.3',
      DataKey.currentDSSlope1: '12.0',
      DataKey.currentWorkingMode: '72',
      DataKey.currentDetectedSplitOption: '1',
      DataKey.rfOutputOperatingSlope: '0.0',
      DataKey.currentRFInputPower1p8G: '-1000.0',
      DataKey.manualModePilot1RFOutputPower: '25.2',
      DataKey.manualModePilot2RFOutputPower: '37.9',
      DataKey.rfOutputLowChannelPower: '-1000.0',
      DataKey.rfOutputHighChannelPower: '-1000.0',
      DataKey.pilot1RFChannelFrequency: '267',
      DataKey.pilot2RFChannelFrequency: '1209',
      DataKey.unitStatusAlarmSeverity: 'danger',
      DataKey.rfInputPilotLowFrequencyAlarmSeverity: 'success',
      DataKey.rfInputPilotHighFrequencyAlarmSeverity: 'success',
      DataKey.rfOutputPilotLowFrequencyAlarmSeverity: 'danger',
      DataKey.rfOutputPilotHighFrequencyAlarmSeverity: 'danger',
      DataKey.temperatureAlarmSeverity: 'success',
      DataKey.voltageAlarmSeverity: 'success',
      DataKey.splitOptionAlarmSeverity: 'success',
      DataKey.voltageRippleAlarmSeverity: 'success',
      DataKey.outputPowerAlarmSeverity: 'danger',
      DataKey.currentForwardCEQIndex: '0',
    };

    _characteristicDataCache.addAll(characteristicDataCache);

    return [
      true,
      characteristicDataCache,
    ];
  }

  @override
  Future<dynamic> requestCommand1p8GAlarm() async {
    int commandIndex = 82;

    print('get data from request command 1p8G_Alarm');

    return [
      true,
      'danger',
      'success',
      'danger',
    ];
  }

  @override
  Future<dynamic> requestCommand1p8G3() async {
    int commandIndex = 183;

    print('get data from request command 1p8G3');

    List<RFInOut> rfInOuts = [];

    for (int i = 261; i <= 1791; i += 5) {
      RFInOut rfInOut = RFInOut(
        frequency: i,
        input: -1000,
        output: -1000,
      );

      rfInOuts.add(rfInOut);
    }
    return [
      true,
      rfInOuts,
      <DataKey, String>{
        DataKey.historicalMinRFOutputPower: '-1000',
        DataKey.historicalMaxRFOutputPower: '-1000',
      }
    ];
  }

  // commandIndex range from 184 to 193;
  // commandIndex = 184 時獲取最新的1024筆Log的統計資料跟 log
  @override
  Future<dynamic> requestCommand1p8GForLogChunk(int chunkIndex) async {
    int commandIndex = chunkIndex + 184;

    print('get data from request command 1p8GForLogChunk $commandIndex');

    List<Log1p8G> log1p8Gs = [];
    for (List<String> strLog in sampleLog1p8GData) {
      DateTime dateTime = DateTime.parse(strLog[0]);
      double temperature = double.parse(strLog[1]);
      double voltage = double.parse(strLog[2]);
      double rfOutputLowPilot = double.parse(strLog[3]);
      double rfOutputHighPilot = double.parse(strLog[4]);
      int voltageRipple = int.parse(strLog[5]);
      Log1p8G log1p8g = Log1p8G(
        dateTime: dateTime,
        temperature: temperature,
        voltage: voltage,
        rfOutputLowPilot: rfOutputLowPilot,
        rfOutputHighPilot: rfOutputHighPilot,
        voltageRipple: voltageRipple,
      );

      log1p8Gs.add(log1p8g);
    }

    if (commandIndex == 184) {
      return [
        true,
        true,
        log1p8Gs,
        <DataKey, String>{
          DataKey.historicalMinTemperatureC: '27.0',
          DataKey.historicalMaxTemperatureC: '33.4',
          DataKey.historicalMinTemperatureF: '80.6',
          DataKey.historicalMaxTemperatureF: '92.1',
          DataKey.historicalMinVoltage: '24.3',
          DataKey.historicalMaxVoltage: '24.3',
          DataKey.historicalMinVoltageRipple: '32',
          DataKey.historicalMaxVoltageRipple: '48',
        }
      ];
    } else {
      List<int> rawData =
          await _connectionClient.writeSetCommandToCharacteristic(
        commandIndex: commandIndex,
        value: _amp18Parser.command18Collection[commandIndex - 180],
        // timeout: Duration(minutes: 1),
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
    }
  }

  @override
  Future<dynamic> requestCommand1p8GEvent() async {
    int commandIndex = 194;

    print('get data from request command 1p8G_Event');

    List<Event1p8G> event1p8Gs = [];
    for (List<String> strLog in sampleEvent1p8GData) {
      DateTime dateTime = DateTime.parse(strLog[0]);
      int code = int.parse(strLog[1]);
      int parameter = int.parse(strLog[2]);

      Event1p8G event1p8G = Event1p8G(
        dateTime: dateTime,
        code: code,
        parameter: parameter,
      );

      event1p8Gs.add(event1p8G);
    }

    return [
      true,
      event1p8Gs,
    ];
  }

  @override
  Future<dynamic> requestCommand1p8GRFOutputLogChunk(int chunkIndex) async {
    int commandIndex = chunkIndex + 195;

    print('get data from request command 1p8G_RFOuts');

    List<RFOutputLog> rfOutputLogs = [];

    List<RFOut> rfOuts = [];

    for (int i = 261; i <= 1791; i += 5) {
      RFOut rfOut = RFOut(
        frequency: i,
        output: -1000,
      );

      rfOuts.add(rfOut);
    }

    DateTime dateTime = DateTime.parse('2024-10-14 14:39:00.000');

    RFOutputLog rfOutputLog = RFOutputLog(dateTime: dateTime, rfOuts: rfOuts);

    bool hasNextChunk =
        rfOutputLogs.isNotEmpty && commandIndex != 204 ? true : false;

    return [
      true,
      hasNextChunk,
      rfOutputLogs,
    ];
  }

  @override
  Future<dynamic> requestCommand1p8GUserAttribute({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    int commandIndex = 205;

    print('get data from request command 1p8GUserAttribute');

    Map<DataKey, String> characteristicDataCache = {
      DataKey.inputSignalLevel: '',
      DataKey.cascadePosition: '頭端 幹線放大器 第二級位置',
      DataKey.deviceName: '達運光電放大器',
      DataKey.deviceNote: '11/20 告警有問題\n11/22 硬體過熱 連線很慢',
    };

    _characteristicDataCache.addAll(characteristicDataCache);

    return [
      true,
      characteristicDataCache,
    ];
  }

  @override
  List<List<ValuePair>> get1p8GDateValueCollectionOfLogs(
      List<Log1p8G> log1p8Gs) {
    return _amp18Parser.get1p8GDateValueCollectionOfLogs(log1p8Gs);
  }

  @override
  List<List<ValuePair>> get1p8GValueCollectionOfRFInOut(
      List<RFInOut> rfInOuts) {
    return _amp18Parser.get1p8GValueCollectionOfRFInOut(rfInOuts);
  }

  @override
  void clearEvent1p8Gs() {
    _amp18ChartCache.clearEvent1p8Gs();
  }

  @override
  void clearLoadMoreLog1p8Gs() {
    _amp18ChartCache.clearLoadMoreLog1p8Gs();
  }

  @override
  void clearAllLog1p8Gs() {
    _amp18ChartCache.clearAllLog1p8Gs();
  }

  @override
  void clearRFInOuts() {
    _amp18ChartCache.clearRFInOuts();
  }

  @override
  void clearRFOutputLogs() {
    _amp18ChartCache.clearRFOutputLogs();
  }

  @override
  void writeEvent1p8Gs(List<Event1p8G> event1p8Gs) {
    _amp18ChartCache.writeEvent1p8Gs(event1p8Gs);
  }

  @override
  void writeLoadMoreLog1p8Gs(List<Log1p8G> log1p8Gs) {
    _amp18ChartCache.writeLoadMoreLog1p8Gs(log1p8Gs);
  }

  @override
  void writeAllLog1p8Gs(List<Log1p8G> log1p8Gs) {
    _amp18ChartCache.writeAllLog1p8Gs(log1p8Gs);
  }

  @override
  void writeRFInOuts(List<RFInOut> rfInOuts) {
    _amp18ChartCache.writeRFInOuts(rfInOuts);
  }

  @override
  void writeRFOutputLogs(List<RFOutputLog> rfOutputLogs) {
    _amp18ChartCache.writeRFOutputLogs(rfOutputLogs);
  }

  @override
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

  @override
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

  @override
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

  @override
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

  @override
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

    return true;
  }

  @override
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

    return true;
  }

  @override
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

    return true;
  }

  @override
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

    return true;
  }

  @override
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

    return true;
  }

  @override
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

    return true;
  }

  @override
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

    return true;
  }

  @override
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

    return true;
  }

  @override
  Future<dynamic> set1p8GReturnIngress2(String ingress) async {
    int commandIndex = 308;

    print('get data from request command 1p8G$commandIndex');

    int ingressNumber = int.parse(ingress);

    Command18.setReturnIngress2Cmd[7] = ingressNumber;

    CRC16.calculateCRC16(
      command: Command18.setReturnIngress2Cmd,
      usDataLength: Command18.setReturnIngress2Cmd.length - 2,
    );

    return true;
  }

  @override
  Future<dynamic> set1p8GReturnIngress3(String ingress) async {
    int commandIndex = 309;

    print('get data from request command 1p8G$commandIndex');

    int ingressNumber = int.parse(ingress);

    Command18.setReturnIngress3Cmd[7] = ingressNumber;

    CRC16.calculateCRC16(
      command: Command18.setReturnIngress3Cmd,
      usDataLength: Command18.setReturnIngress3Cmd.length - 2,
    );

    return true;
  }

  @override
  Future<dynamic> set1p8GReturnIngress4(String ingress) async {
    int commandIndex = 310;

    print('get data from request command 1p8G$commandIndex');

    int ingressNumber = int.parse(ingress);

    Command18.setReturnIngress4Cmd[7] = ingressNumber;

    CRC16.calculateCRC16(
      command: Command18.setReturnIngress4Cmd,
      usDataLength: Command18.setReturnIngress4Cmd.length - 2,
    );

    return true;
  }

  @override
  Future<dynamic> set1p8GTGCCableLength(String value) async {
    int commandIndex = 313;

    print('get data from request command 1p8G$commandIndex');

    int intValue = int.parse(value);

    Command18.setTGCCableLengthCmd[7] = intValue;

    CRC16.calculateCRC16(
      command: Command18.setTGCCableLengthCmd,
      usDataLength: Command18.setTGCCableLengthCmd.length - 2,
    );

    return true;
  }

  @override
  Future<dynamic> set1p8GSplitOption(String splitOption) async {
    int commandIndex = 314;

    print('get data from request command 1p8G$commandIndex');

    int splitOptionNumber = int.parse(splitOption);

    Command18.setSplitOptionCmd[7] = splitOptionNumber;

    CRC16.calculateCRC16(
      command: Command18.setSplitOptionCmd,
      usDataLength: Command18.setSplitOptionCmd.length - 2,
    );

    return true;
  }

  @override
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

    return true;
  }

  @override
  Future<dynamic> set1p8GForwardAGCMode(String value) async {
    int commandIndex = 316;

    print('get data from request command 1p8G$commandIndex');

    int intValue = int.parse(value);

    Command18.setFowardAGCModeCmd[7] = intValue;

    CRC16.calculateCRC16(
      command: Command18.setFowardAGCModeCmd,
      usDataLength: Command18.setFowardAGCModeCmd.length - 2,
    );

    return true;
  }

  @override
  Future<dynamic> set1p8GALCMode(String value) async {
    int commandIndex = 317;

    print('get data from request command 1p8G$commandIndex');

    int intValue = int.parse(value);

    Command18.setALCModeCmd[7] = intValue;

    CRC16.calculateCRC16(
      command: Command18.setALCModeCmd,
      usDataLength: Command18.setALCModeCmd.length - 2,
    );

    return true;
  }

  @override
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

    return true;
  }

  @override
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

    return true;
  }

  @override
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

    return true;
  }

  @override
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

    return true;
  }

  @override
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

    return true;
  }

  @override
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

    return true;
  }

  @override
  Future<dynamic> setInputPilotLowFrequencyAlarmState(String isEnable) async {
    int commandIndex = 324;

    print('get data from request command 1p8G$commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18.setInputPilotLowFrequencyAlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18.setInputPilotLowFrequencyAlarmStateCmd,
      usDataLength: Command18.setInputPilotLowFrequencyAlarmStateCmd.length - 2,
    );

    return true;
  }

  @override
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

    return true;
  }

  @override
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

    return true;
  }

  @override
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

    return true;
  }

  @override
  Future<dynamic> set1p8GTemperatureAlarmState(String isEnable) async {
    int commandIndex = 328;

    print('get data from request command 1p8G$commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18.setTemperatureAlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18.setTemperatureAlarmStateCmd,
      usDataLength: Command18.setTemperatureAlarmStateCmd.length - 2,
    );

    return true;
  }

  @override
  Future<dynamic> set1p8GVoltageAlarmState(String isEnable) async {
    int commandIndex = 329;

    print('get data from request command 1p8G$commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18.setVoltageAlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18.setVoltageAlarmStateCmd,
      usDataLength: Command18.setVoltageAlarmStateCmd.length - 2,
    );

    return true;
  }

  @override
  Future<dynamic> set1p8GFactoryDefault(int number) async {
    int commandIndex = 333;

    print('get data from request command 1p8G$commandIndex');

    Command18.setFactoryDefaultCmd[7] = number;

    CRC16.calculateCRC16(
      command: Command18.setFactoryDefaultCmd,
      usDataLength: Command18.setFactoryDefaultCmd.length - 2,
    );

    return true;
  }

  @override
  Future<dynamic> set1p8GSplitOptionAlarmState(String isEnable) async {
    int commandIndex = 334;

    print('get data from request command 1p8G$commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18.setSplitOptionAlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18.setSplitOptionAlarmStateCmd,
      usDataLength: Command18.setSplitOptionAlarmStateCmd.length - 2,
    );

    return true;
  }

  @override
  Future<dynamic> set1p8GVoltageRippleAlarmState(String isEnable) async {
    int commandIndex = 335;

    print('get data from request command 1p8G$commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18.setVoltageRippleAlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18.setVoltageRippleAlarmStateCmd,
      usDataLength: Command18.setVoltageRippleAlarmStateCmd.length - 2,
    );

    return true;
  }

  @override
  Future<dynamic> set1p8GRFOutputPowerAlarmState(String isEnable) async {
    int commandIndex = 336;

    print('get data from request command 1p8G$commandIndex');

    int isEnableNumber = int.parse(isEnable);

    Command18.setRFOutputPowerAlarmStateCmd[7] = isEnableNumber;

    CRC16.calculateCRC16(
      command: Command18.setRFOutputPowerAlarmStateCmd,
      usDataLength: Command18.setRFOutputPowerAlarmStateCmd.length - 2,
    );

    return true;
  }

  @override
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

    return true;
  }

  @override
  Future<dynamic> set1p8GLogInterval(String logInterval) async {
    int commandIndex = 338;

    int interval = int.parse(logInterval);

    print('get data from request command 1p8G$commandIndex');

    Command18.setLogIntervalCmd[7] = interval;

    CRC16.calculateCRC16(
      command: Command18.setLogIntervalCmd,
      usDataLength: Command18.setLogIntervalCmd.length - 2,
    );

    return true;
  }

  @override
  Future<dynamic> set1p8GRFOutputLogInterval(String rfOutputLogInterval) async {
    int commandIndex = 339;

    int interval = int.parse(rfOutputLogInterval);

    print('get data from request command 1p8G$commandIndex');

    Command18.setRFOutputLogIntervalCmd[7] = interval;

    CRC16.calculateCRC16(
      command: Command18.setRFOutputLogIntervalCmd,
      usDataLength: Command18.setRFOutputLogIntervalCmd.length - 2,
    );

    return true;
  }

  @override
  Future<dynamic> set1p8GDSVVA1(String strValue) async {
    int commandIndex = 340;

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

    return true;
  }

  @override
  Future<dynamic> set1p8GDSSlope1(String strValue) async {
    int commandIndex = 341;

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

    return true;
  }

  @override
  Future<dynamic> set1p8GDSVVA2(String strValue) async {
    int commandIndex = 342;

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

    return true;
  }

  @override
  Future<dynamic> set1p8GDSSlope2(String strValue) async {
    int commandIndex = 343;

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

    return true;
  }

  @override
  Future<dynamic> set1p8GUSVCA1(String strValue) async {
    int commandIndex = 344;

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

    return true;
  }

  @override
  Future<dynamic> set1p8GEREQ(String strValue) async {
    int commandIndex = 345;

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

    return true;
  }

  @override
  Future<dynamic> set1p8DSVVA3(String strValue) async {
    int commandIndex = 346;

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

    return true;
  }

  @override
  Future<dynamic> set1p8GDSVVA4(String strValue) async {
    int commandIndex = 347;

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

    return true;
  }

  @override
  Future<dynamic> set1p8GUSVCA2(String strValue) async {
    int commandIndex = 348;

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

    return true;
  }

  @override
  Future<dynamic> set1p8GUSVCA3(String strValue) async {
    int commandIndex = 349;

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

    return true;
  }

  @override
  Future<dynamic> set1p8GUSVCA4(String strValue) async {
    int commandIndex = 350;

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

    return true;
  }

  @override
  Future<dynamic> set1p8GDSVVA5(String strValue) async {
    int commandIndex = 351;

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

    return true;
  }

  @override
  Future<dynamic> set1p8GDSSlope3(String strValue) async {
    int commandIndex = 352;

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

    return true;
  }

  @override
  Future<dynamic> set1p8GDSSlope4(String strValue) async {
    int commandIndex = 353;

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

    return true;
  }

  @override
  Future<dynamic> set1p8GCoordinates(String coordinates) async {
    int commandIndex = 354;

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

    return true;
  }

  // 設定藍牙串口的資料傳輸延遲時間, 單位為 ms
  // 例如 MTU = 244, 則每傳輸244byte 就會休息 ms 時間再傳下一筆
  @override
  Future<dynamic> set1p8GTransmitDelayTime({int? ms}) async {
    int commandIndex = 355;

    print('get data from request command 1p8G$commandIndex');

    int rssi = -60;

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

    return true;
  }

  @override
  Future<dynamic> set1p8GNowDateTime(
    String nowDateTime,
  ) async {
    int commandIndex = 356;

    print('get data from request command 1p8G$commandIndex');

    DateTime dateTime = DateTime.now();
    DateTime deviceDateTime = DateTime.parse(nowDateTime);

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

    return true;

    // 之前版本的 log interval 可以為 1 分鐘, 如果一直同步時間就可能發生log紀錄裡有某前後兩筆的log時間一模一樣
    // 所以才加入判斷
    // device 的 now time 跟 目前時間相差大於等於 30 分鐘, 則寫入目前時間
    // int difference = dateTime.difference(deviceDateTime).inMinutes.abs();

    // // 如果 device 的 now time 跟 目前時間相差大於等於 30 分鐘, 則寫入目前時間
    // if (difference >= 30) {
    //   print('sync time on device id $partId');
    //   try {
    //     List<int> rawData = await _connectionClient.writeSetCommandToCharacteristic(
    //       commandIndex: commandIndex,
    //       value: Command18.setNowDateTimeCmd,
    //     );
    //     return true;
    //   } catch (e) {
    //     return false;
    //   }
    // } else {
    //   return true;
    // }
  }

  @override
  void clearCharacteristics() {
    _characteristicDataCache.clear();
  }

  @override
  Future<void> updateDataWithGivenValuePairs(
      Map<DataKey, String> valuePairs) async {
    _characteristicDataStreamController
        .add(Map<DataKey, String>.from(valuePairs));
  }

  @override
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

    _characteristicDataCache.clear();
    _characteristicDataCache.addAll(characteristicDataCache);
  }
}
