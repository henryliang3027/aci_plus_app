import 'dart:async';
import 'dart:io';
import 'package:aci_plus_app/core/command18_c_core_node.dart';
import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/crc16_calculate.dart';
import 'package:aci_plus_app/repositories/amp18_parser.dart';
import 'package:aci_plus_app/repositories/unit_converter.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_speed_chart/speed_chart.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class Amp18CCorNodeParser {
  Amp18CCorNodeParser() {
    calculate18CRCs();
  }

  final List<List<int>> _command18CCorNodeCollection = [];

  List<List<int>> get command18CCorNodeCollection =>
      _command18CCorNodeCollection;

  // 刪除所有 Null character (0x00), 頭尾空白 character
  String _trimString(String s) {
    s = s.replaceAll('\x00', '');
    s = s.trim();
    return s;
  }

  A1P8GCCorNode80 decodeA1P8GCCorNode80(List<int> rawData) {
    String partName = '';
    String partNo = '';
    String partId = '';
    String serialNumber = '';
    String firmwareVersion = '';
    String hardwareVersion = '';
    String mfgDate = '';
    String coordinate = '';
    String nowDateTime = '';

    // 解析 partName
    for (int i = 3; i <= 22; i++) {
      partName += String.fromCharCode(rawData[i]);
    }
    partName = _trimString(partName);

    // 解析 partNo
    for (int i = 23; i <= 42; i++) {
      partNo += String.fromCharCode(rawData[i]);
    }
    partNo = _trimString(partNo);

    // 解析 serialNumber
    for (int i = 43; i <= 58; i++) {
      serialNumber += String.fromCharCode(rawData[i]);
    }
    serialNumber = _trimString(serialNumber);

    // 解析 hardwareVersion
    for (int i = 59; i <= 62; i++) {
      hardwareVersion += String.fromCharCode(rawData[i]);
    }
    hardwareVersion = _trimString(hardwareVersion);

    // 解析 firmwareVersion
    for (int i = 63; i <= 66; i++) {
      firmwareVersion += String.fromCharCode(rawData[i]);
    }
    firmwareVersion = _trimString(firmwareVersion);

    // 舊版本為空自串, 所以加一個N/A表示無 hardware version
    hardwareVersion = hardwareVersion.isEmpty ? 'N/A' : hardwareVersion;

    // 解析 mfgDate
    List<int> rawYear = rawData.sublist(67, 69);
    ByteData byteData = ByteData.sublistView(Uint8List.fromList(rawYear));
    String year = byteData.getInt16(0, Endian.little).toString();
    String month = rawData[69].toString().padLeft(2, '0');
    String day = rawData[70].toString().padLeft(2, '0');
    mfgDate = '$year/$month/$day';

    // 0: MFTJ (預留, app不適用)
    // 1: SDLE
    // 2: MOTO BLE
    // 3: MOTO MB
    // 4: C-Cor Node
    // 5: C-Cor TR
    // 6: C-Cor BR
    // 7: C-Cor LE
    partId = rawData[71].toString();

    // 解析 coordinates
    for (int i = 72; i <= 110; i++) {
      coordinate += String.fromCharCode(rawData[i]);
    }
    coordinate = _trimString(coordinate);

    // 解析 now time
    List<int> rawNowYear = rawData.sublist(171, 173);
    ByteData rawNowYearByteData =
        ByteData.sublistView(Uint8List.fromList(rawNowYear));
    String nowYear = rawNowYearByteData.getInt16(0, Endian.little).toString();
    String nowMonth = rawData[173].toString().padLeft(2, '0');
    String nowDay = rawData[174].toString().padLeft(2, '0');
    String nowHour = rawData[175].toString().padLeft(2, '0');
    String nowMinute = rawData[176].toString().padLeft(2, '0');
    nowDateTime = '$nowYear-$nowMonth-$nowDay $nowHour:$nowMinute:00';

    return A1P8GCCorNode80(
      partName: partName,
      partNo: partNo,
      partId: partId,
      serialNumber: serialNumber,
      firmwareVersion: firmwareVersion,
      hardwareVersion: hardwareVersion,
      mfgDate: mfgDate,
      coordinate: coordinate,
      nowDateTime: nowDateTime,
    );
  }

  A1P8GCCorNode91 decodeA1P8GCCorNode91(List<int> rawData) {
    String maxTemperatureC = '';
    String minTemperatureC = '';
    String maxTemperatureF = '';
    String minTemperatureF = '';
    String maxVoltage = '';
    String minVoltage = '';
    String maxRFOutputPower1 = '';
    String minRFOutputPower1 = '';
    String ingressSetting1 = '';
    String ingressSetting3 = '';
    String ingressSetting4 = '';
    String ingressSetting6 = '';
    String forwardMode = '';
    String forwardConfig = '';
    String splitOption = '';
    String maxRFOutputPower3 = '';
    String minRFOutputPower3 = '';
    String dsVVA1 = '';
    String dsInSlope1 = '';
    String dsOutSlope1 = '';
    String usVCA1 = '';
    String rfOutputPower1AlarmState = '';
    String rfOutputPower3AlarmState = '';
    String rfOutputPower4AlarmState = '';
    String rfOutputPower6AlarmState = '';
    String temperatureAlarmState = '';
    String voltageAlarmState = '';
    String maxRFOutputPower4 = '';
    String minRFOutputPower4 = '';
    String splitOptionAlarmState = '';
    String location = '';
    String logInterval = '';
    String dsVVA3 = '';
    String dsInSlope3 = '';
    String dsOutSlope3 = '';
    String usVCA3 = '';
    String dsVVA4 = '';
    String dsInSlope4 = '';
    String dsOutSlope4 = '';
    String usVCA4 = '';
    String dsVVA6 = '';
    String dsInSlope6 = '';
    String dsOutSlope6 = '';
    String usVCA6 = '';
    String maxRFOutputPower6 = '';
    String minRFOutputPower6 = '';

    // 解析 maxTemperatureC, maxTemperatureF
    List<int> rawMaxTemperatureC = rawData.sublist(3, 5);
    ByteData rawMaxTemperatureCByteData =
        ByteData.sublistView(Uint8List.fromList(rawMaxTemperatureC));

    double maxTemperature =
        rawMaxTemperatureCByteData.getInt16(0, Endian.little) / 10;
    maxTemperatureC = maxTemperature.toStringAsFixed(1);
    maxTemperatureF = _convertToFahrenheit(maxTemperature).toStringAsFixed(1);

    // 解析 minTemperatureC, minTemperatureF
    List<int> rawMinTemperatureC = rawData.sublist(5, 7);
    ByteData rawMinTemperatureCByteData =
        ByteData.sublistView(Uint8List.fromList(rawMinTemperatureC));

    double minTemperature =
        rawMinTemperatureCByteData.getInt16(0, Endian.little) / 10;
    minTemperatureC = minTemperature.toStringAsFixed(1);
    minTemperatureF = _convertToFahrenheit(minTemperature).toStringAsFixed(1);

    // 解析 maxVoltage
    List<int> rawMaxVoltage = rawData.sublist(7, 9);
    ByteData rawMaxVoltageByteData =
        ByteData.sublistView(Uint8List.fromList(rawMaxVoltage));
    maxVoltage = (rawMaxVoltageByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

    // 解析 minVoltage
    List<int> rawMinVoltage = rawData.sublist(9, 11);
    ByteData rawMinVoltageByteData =
        ByteData.sublistView(Uint8List.fromList(rawMinVoltage));
    minVoltage = (rawMinVoltageByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

    // 解析 maxRFOutputPower1
    List<int> rawMaxRFOutputPower1 = rawData.sublist(15, 17);
    ByteData rawMaxRFOutputPower1ByteData =
        ByteData.sublistView(Uint8List.fromList(rawMaxRFOutputPower1));
    maxRFOutputPower1 =
        (rawMaxRFOutputPower1ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 minRFOutputPower1
    List<int> rawMinRFOutputPower1 = rawData.sublist(17, 19);
    ByteData rawMinRFOutputPower1ByteData =
        ByteData.sublistView(Uint8List.fromList(rawMinRFOutputPower1));
    minRFOutputPower1 =
        (rawMinRFOutputPower1ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 ingress setting 1
    ingressSetting1 = rawData[19].toString();

    // 解析 ingress setting 3
    ingressSetting3 = rawData[20].toString();

    // 解析 ingress setting 4
    ingressSetting4 = rawData[21].toString();

    // 解析 ingress setting 6
    ingressSetting6 = rawData[22].toString();

    // 解析 forward config
    forwardConfig = rawData[23].toString();

    // 解析 splitOption
    splitOption = rawData[25].toString();

    // 解析 forward mode
    forwardMode = rawData[27].toString();

    // 解析 maxRFOutputPower3
    List<int> rawMaxRFOutputPower3 = rawData.sublist(29, 31);
    ByteData rawMaxRFOutputPower3ByteData =
        ByteData.sublistView(Uint8List.fromList(rawMaxRFOutputPower3));
    maxRFOutputPower3 =
        (rawMaxRFOutputPower3ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 minRFOutputPower3
    List<int> rawMinRFOutputPower3 = rawData.sublist(31, 33);
    ByteData rawMinRFOutputPower3ByteData =
        ByteData.sublistView(Uint8List.fromList(rawMinRFOutputPower3));
    minRFOutputPower3 =
        (rawMinRFOutputPower3ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 forwardVVA1
    List<int> rawDSVVA1 = rawData.sublist(33, 35);
    ByteData rawDSVVA1ByteData =
        ByteData.sublistView(Uint8List.fromList(rawDSVVA1));
    dsVVA1 =
        (rawDSVVA1ByteData.getInt16(0, Endian.little) / 10).toStringAsFixed(1);

    // 解析 forwardInSlope1
    List<int> rawDSInSlope1 = rawData.sublist(35, 37);
    ByteData rawDSInSlope1ByteData =
        ByteData.sublistView(Uint8List.fromList(rawDSInSlope1));
    dsInSlope1 = (rawDSInSlope1ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

    // 解析 dsOutSlope1
    List<int> rawDSOutSlope1 = rawData.sublist(37, 39);
    ByteData rawDSOutSlope1ByteData =
        ByteData.sublistView(Uint8List.fromList(rawDSOutSlope1));
    dsOutSlope1 = (rawDSOutSlope1ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

    // 解析 usVCA1
    List<int> rawUSVCA1 = rawData.sublist(39, 41);
    ByteData rawUSVCA1ByteData =
        ByteData.sublistView(Uint8List.fromList(rawUSVCA1));
    usVCA1 =
        (rawUSVCA1ByteData.getInt16(0, Endian.little) / 10).toStringAsFixed(1);

    // 解析 rfOutputPower1AlarmState
    rfOutputPower1AlarmState = rawData[41].toString();

    // 解析 rfOutputPower3AlarmState
    rfOutputPower3AlarmState = rawData[42].toString();

    // 解析 rfOutputPower4AlarmState
    rfOutputPower4AlarmState = rawData[43].toString();

    // 解析 rfOutputPower6AlarmState
    rfOutputPower6AlarmState = rawData[44].toString();

    // 解析 temperatureAlarmState
    temperatureAlarmState = rawData[45].toString();

    // 解析 voltageAlarmState
    voltageAlarmState = rawData[46].toString();

    // 解析 maxRFOutputPower4
    List<int> rawMaxRFOutputPower4 = rawData.sublist(47, 49);
    ByteData rawMaxRFOutputPower4ByteData =
        ByteData.sublistView(Uint8List.fromList(rawMaxRFOutputPower4));
    maxRFOutputPower4 =
        (rawMaxRFOutputPower4ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 minRFOutputPower4
    List<int> rawMinRFOutputPower4 = rawData.sublist(49, 51);
    ByteData rawMinRFOutputPower4ByteData =
        ByteData.sublistView(Uint8List.fromList(rawMinRFOutputPower4));
    minRFOutputPower4 =
        (rawMinRFOutputPower4ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 splitOptionAlarmState
    splitOptionAlarmState = rawData[51].toString();

    // 使用 unicode 解析 location
    for (int i = 54; i < 150; i += 2) {
      Uint8List bytes = Uint8List.fromList([rawData[i], rawData[i + 1]]);

      // Extract the bytes and create the Unicode code point
      int lowerByte = bytes[0];
      int upperByte = bytes[1];
      int unicodeCodePoint = (upperByte << 8) | lowerByte;

      // Convert the Unicode code point to a string
      String chineseCharacter = String.fromCharCode(unicodeCodePoint);
      location += chineseCharacter;
    }

    location = _trimString(location);

    // 解析 logInterval
    logInterval = rawData[150].toString();
    print('LOG interval: $logInterval');

    // 解析 dsVVA3
    List<int> rawDSVVA3 = rawData.sublist(151, 153);
    ByteData rawDSVVA3ByteData =
        ByteData.sublistView(Uint8List.fromList(rawDSVVA3));
    dsVVA3 =
        (rawDSVVA3ByteData.getInt16(0, Endian.little) / 10).toStringAsFixed(1);

    // 解析 dsInSlope3
    List<int> rawDSInSlope3 = rawData.sublist(153, 155);
    ByteData rawDSInSlope3ByteData =
        ByteData.sublistView(Uint8List.fromList(rawDSInSlope3));
    dsInSlope3 = (rawDSInSlope3ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

    // 解析 dsOutSlope3
    List<int> rawDSOutSlope3 = rawData.sublist(155, 157);
    ByteData rawDSOutSlope3ByteData =
        ByteData.sublistView(Uint8List.fromList(rawDSOutSlope3));
    dsOutSlope3 = (rawDSOutSlope3ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

    // 解析 usVCA3
    List<int> rawUSVCA3 = rawData.sublist(157, 159);
    ByteData rawUSVCA3ByteData =
        ByteData.sublistView(Uint8List.fromList(rawUSVCA3));
    usVCA3 =
        (rawUSVCA3ByteData.getInt16(0, Endian.little) / 10).toStringAsFixed(1);

    // 解析 dsVVA4
    List<int> rawDSVVA4 = rawData.sublist(159, 161);
    ByteData rawDSVVA4ByteData =
        ByteData.sublistView(Uint8List.fromList(rawDSVVA4));
    dsVVA4 =
        (rawDSVVA4ByteData.getInt16(0, Endian.little) / 10).toStringAsFixed(1);

    // 解析 dsInSlope4
    List<int> rawDSInSlope4 = rawData.sublist(161, 163);
    ByteData rawDSInSlope4ByteData =
        ByteData.sublistView(Uint8List.fromList(rawDSInSlope4));
    dsInSlope4 = (rawDSInSlope4ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

    // 解析 dsOutSlope4
    List<int> rawDSOutSlope4 = rawData.sublist(163, 165);
    ByteData rawDSOutSlope4ByteData =
        ByteData.sublistView(Uint8List.fromList(rawDSOutSlope4));
    dsOutSlope4 = (rawDSOutSlope4ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

    // 解析 usVCA4 (0xA2 DS VVA4 Set dB)
    List<int> rawUSVCA4 = rawData.sublist(165, 167);
    ByteData rawUSVCA4ByteData =
        ByteData.sublistView(Uint8List.fromList(rawUSVCA4));
    usVCA4 =
        (rawUSVCA4ByteData.getInt16(0, Endian.little) / 10).toStringAsFixed(1);

    // 解析 dsVVA6
    List<int> rawDSVVA6 = rawData.sublist(167, 169);
    ByteData rawDSVVA6ByteData =
        ByteData.sublistView(Uint8List.fromList(rawDSVVA6));
    dsVVA6 =
        (rawDSVVA6ByteData.getInt16(0, Endian.little) / 10).toStringAsFixed(1);

    // 解析 dsInSlope6
    List<int> rawDSInSlope6 = rawData.sublist(169, 171);
    ByteData rawDSInSlope6ByteData =
        ByteData.sublistView(Uint8List.fromList(rawDSInSlope6));
    dsInSlope6 = (rawDSInSlope6ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

    // 解析 dsOutSlope6
    List<int> rawDSOutSlope6 = rawData.sublist(171, 173);
    ByteData rawDSOutSlope6ByteData =
        ByteData.sublistView(Uint8List.fromList(rawDSOutSlope6));
    dsOutSlope6 = (rawDSOutSlope6ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

    // 解析 usVCA6
    List<int> rawUSVCA6 = rawData.sublist(173, 175);
    ByteData rawUSVCA6ByteData =
        ByteData.sublistView(Uint8List.fromList(rawUSVCA6));
    usVCA6 =
        (rawUSVCA6ByteData.getInt16(0, Endian.little) / 10).toStringAsFixed(1);

    // 解析 maxRFOutputPower6
    List<int> rawMaxRFOutputPower6 = rawData.sublist(175, 177);
    ByteData rawMaxRFOutputPower6ByteData =
        ByteData.sublistView(Uint8List.fromList(rawMaxRFOutputPower6));
    maxRFOutputPower6 =
        (rawMaxRFOutputPower6ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 minRFOutputPower6
    List<int> rawMinRFOutputPower6 = rawData.sublist(177, 179);
    ByteData rawMinRFOutputPower6ByteData =
        ByteData.sublistView(Uint8List.fromList(rawMinRFOutputPower6));
    minRFOutputPower6 =
        (rawMinRFOutputPower6ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    return A1P8GCCorNode91(
      maxTemperatureC: maxTemperatureC,
      minTemperatureC: minTemperatureC,
      maxTemperatureF: maxTemperatureF,
      minTemperatureF: minTemperatureF,
      maxVoltage: maxVoltage,
      minVoltage: minVoltage,
      maxRFOutputPower1: maxRFOutputPower1,
      minRFOutputPower1: minRFOutputPower1,
      ingressSetting1: ingressSetting1,
      ingressSetting3: ingressSetting3,
      ingressSetting4: ingressSetting4,
      ingressSetting6: ingressSetting6,
      forwardConfig: forwardConfig,
      splitOption: splitOption,
      forwardMode: forwardMode,
      maxRFOutputPower3: maxRFOutputPower3,
      minRFOutputPower3: minRFOutputPower3,
      dsVVA1: dsVVA1,
      dsInSlope1: dsInSlope1,
      dsOutSlope1: dsOutSlope1,
      usVCA1: usVCA1,
      rfOutputPower1AlarmState: rfOutputPower1AlarmState,
      rfOutputPower3AlarmState: rfOutputPower3AlarmState,
      rfOutputPower4AlarmState: rfOutputPower4AlarmState,
      rfOutputPower6AlarmState: rfOutputPower6AlarmState,
      temperatureAlarmState: temperatureAlarmState,
      voltageAlarmState: voltageAlarmState,
      maxRFOutputPower4: maxRFOutputPower4,
      minRFOutputPower4: minRFOutputPower4,
      splitOptionAlarmState: splitOptionAlarmState,
      location: location,
      logInterval: logInterval,
      dsVVA3: dsVVA3,
      dsInSlope3: dsInSlope3,
      dsOutSlope3: dsOutSlope3,
      usVCA3: usVCA3,
      dsVVA4: dsVVA4,
      dsInSlope4: dsInSlope4,
      dsOutSlope4: dsOutSlope4,
      usVCA4: usVCA4,
      dsVVA6: dsVVA6,
      dsInSlope6: dsInSlope6,
      dsOutSlope6: dsOutSlope6,
      usVCA6: usVCA6,
      maxRFOutputPower6: maxRFOutputPower6,
      minRFOutputPower6: minRFOutputPower6,
    );
  }

  A1P8GCCorNode92 decodeA1P8GCCorNode92(List<int> rawData) {
    String biasCurrent1 = '';
    String biasCurrent3 = '';
    String biasCurrent4 = '';
    String biasCurrent6 = '';

    // 解析 biasCurrent1
    List<int> rawBiasCurrent1 = rawData.sublist(3, 5);
    ByteData rawBiasCurrent1ByteData =
        ByteData.sublistView(Uint8List.fromList(rawBiasCurrent1));
    biasCurrent1 = (rawBiasCurrent1ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(0);

    // 解析 biasCurrent3
    List<int> rawBiasCurrent3 = rawData.sublist(5, 7);
    ByteData rawBiasCurrent3ByteData =
        ByteData.sublistView(Uint8List.fromList(rawBiasCurrent3));
    biasCurrent3 = (rawBiasCurrent3ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(0);

    // 解析 biasCurrent4
    List<int> rawBiasCurrent4 = rawData.sublist(7, 9);
    ByteData rawBiasCurrent4ByteData =
        ByteData.sublistView(Uint8List.fromList(rawBiasCurrent4));
    biasCurrent4 = (rawBiasCurrent4ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(0);

    // 解析 biasCurrent6
    List<int> rawBiasCurrent6 = rawData.sublist(9, 11);
    ByteData rawBiasCurrent6ByteData =
        ByteData.sublistView(Uint8List.fromList(rawBiasCurrent6));
    biasCurrent6 = (rawBiasCurrent6ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(0);

    return A1P8GCCorNode92(
      biasCurrent1: biasCurrent1,
      biasCurrent3: biasCurrent3,
      biasCurrent4: biasCurrent4,
      biasCurrent6: biasCurrent6,
    );
  }

  A1P8GCCorNodeA1 decodeA1P8GCCorNodeA1(List<int> rawData) {
    String currentTemperatureC;
    String currentTemperatureF;
    String currentVoltage;
    String currentVoltageRipple;
    String currentRFOutputPower1;
    String currentRFOutputPower3;
    String currentRFOutputPower4;
    String currentRFOutputPower6;
    String currentDSVVA1;
    String currentDSInSlope1;
    String currentDSOutSlope1;
    String currentUSVCA1;
    String currentDSVVA3;
    String currentDSInSlope3;
    String currentDSOutSlope3;
    String currentUSVCA3;
    String currentDSVVA4;
    String currentDSInSlope4;
    String currentDSOutSlope4;
    String currentUSVCA4;
    String currentDSVVA6;
    String currentDSInSlope6;
    String currentDSOutSlope6;
    String currentUSVCA6;
    String currentWorkingMode;
    String currentDetectedSplitOption;
    Alarm unitStatusAlarmSeverity = Alarm.medium;
    Alarm temperatureAlarmSeverity = Alarm.medium;
    Alarm voltageAlarmSeverity = Alarm.medium;
    Alarm splitOptionAlarmSeverity = Alarm.medium;
    Alarm voltageRippleAlarmSeverity = Alarm.medium;
    Alarm rfOutputPower1AlarmSeverity = Alarm.medium;
    Alarm rfOutputPower3AlarmSeverity = Alarm.medium;
    Alarm rfOutputPower4AlarmSeverity = Alarm.medium;
    Alarm rfOutputPower6AlarmSeverity = Alarm.medium;

    int unitStatus = rawData[3];
    unitStatusAlarmSeverity = unitStatus == 1 ? Alarm.success : Alarm.danger;

    // 解析 currentTemperatureC, currentTemperatureC
    List<int> rawCurrentTemperatureC = rawData.sublist(4, 6);
    ByteData rawCurrentTemperatureCByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentTemperatureC));

    double currentTemperature =
        rawCurrentTemperatureCByteData.getInt16(0, Endian.little) / 10;

    currentTemperatureC = currentTemperature.toStringAsFixed(1);
    currentTemperatureF =
        _convertToFahrenheit(currentTemperature).toStringAsFixed(1);

    // 解析 currentVoltage
    List<int> rawCurrentVoltage = rawData.sublist(6, 8);
    ByteData rawCurrentVoltageByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentVoltage));

    currentVoltage = (rawCurrentVoltageByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

    // 解析 currentVoltageRipple
    List<int> rawCurrentVoltageRipple = rawData.sublist(8, 10);
    ByteData rawCurrentVoltageRippleByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentVoltageRipple));

    currentVoltageRipple =
        rawCurrentVoltageRippleByteData.getInt16(0, Endian.little).toString();

    // 解析 currentRFOutputPower1
    List<int> rawCurrentRFOutputPower1 = rawData.sublist(18, 20);
    ByteData rawCurrentRFOutputPower1ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentRFOutputPower1));

    currentRFOutputPower1 =
        (rawCurrentRFOutputPower1ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 currentRFOutputPower3
    List<int> rawCurrentRFOutputPower3 = rawData.sublist(22, 24);
    ByteData rawCurrentRFOutputPower3ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentRFOutputPower3));

    currentRFOutputPower3 =
        (rawCurrentRFOutputPower3ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 currentRFOutputPower4
    List<int> rawCurrentRFOutputPower4 = rawData.sublist(24, 26);
    ByteData rawCurrentRFOutputPower4ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentRFOutputPower4));

    currentRFOutputPower4 =
        (rawCurrentRFOutputPower4ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 currentRFOutputPower6
    List<int> rawCurrentRFOutputPower6 = rawData.sublist(28, 30);
    ByteData rawCurrentRFOutputPower6ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentRFOutputPower6));

    currentRFOutputPower6 =
        (rawCurrentRFOutputPower6ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 currentDSVVA1
    List<int> rawCurrentDSVVA1 = rawData.sublist(34, 36);
    ByteData rawCurrentDSVVA1ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentDSVVA1));

    currentDSVVA1 = (rawCurrentDSVVA1ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

    // 解析 currentDSInSlope1
    List<int> rawCurrentDSInSlope1 = rawData.sublist(36, 38);
    ByteData rawCurrentDSInSlope1ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentDSInSlope1));

    currentDSInSlope1 =
        (rawCurrentDSInSlope1ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 currentDSOutSlope1
    List<int> rawCurrentDSOutSlope1 = rawData.sublist(38, 40);
    ByteData rawCurrentDSOutSlope1ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentDSOutSlope1));

    currentDSOutSlope1 =
        (rawCurrentDSOutSlope1ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 currentUSVCA1
    List<int> rawCurrentUSVCA1 = rawData.sublist(40, 42);
    ByteData rawCurrentUSVCA1ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentUSVCA1));

    currentUSVCA1 = (rawCurrentUSVCA1ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

    // 解析 currentDSVVA3
    List<int> rawCurrentDSVVA3 = rawData.sublist(42, 44);
    ByteData rawCurrentDSVVA3ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentDSVVA3));

    currentDSVVA3 = (rawCurrentDSVVA3ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

    // 解析 currentDSInSlope3
    List<int> rawCurrentDSInSlope3 = rawData.sublist(44, 46);
    ByteData rawCurrentDSInSlope3ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentDSInSlope3));

    currentDSInSlope3 =
        (rawCurrentDSInSlope3ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 currentDSOutSlope3
    List<int> rawCurrentDSOutSlope3 = rawData.sublist(46, 48);
    ByteData rawCurrentDSOutSlope3ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentDSOutSlope3));

    currentDSOutSlope3 =
        (rawCurrentDSOutSlope3ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 currentUSVCA3
    List<int> rawCurrentUSVCA3 = rawData.sublist(48, 50);
    ByteData rawCurrentUSVCA3ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentUSVCA3));

    currentUSVCA3 = (rawCurrentUSVCA3ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

    // 解析 currentDSVVA4
    List<int> rawCurrentDSVVA4 = rawData.sublist(50, 52);
    ByteData rawCurrentDSVVA4ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentDSVVA4));

    currentDSVVA4 = (rawCurrentDSVVA4ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

    // 解析 currentDSInSlope4
    List<int> rawCurrentDSInSlope4 = rawData.sublist(52, 54);
    ByteData rawCurrentDSInSlope4ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentDSInSlope4));

    currentDSInSlope4 =
        (rawCurrentDSInSlope4ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 currentDSOutSlope4
    List<int> rawCurrentDSOutSlope4 = rawData.sublist(54, 56);
    ByteData rawCurrentDSOutSlope4ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentDSOutSlope4));

    currentDSOutSlope4 =
        (rawCurrentDSOutSlope4ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 currentUSVCA4
    List<int> rawCurrentUSVCA4 = rawData.sublist(56, 58);
    ByteData rawCurrentUSVCA4ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentUSVCA4));

    currentUSVCA4 = (rawCurrentUSVCA4ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

    // 解析 currentDSVVA6
    List<int> rawCurrentDSVVA6 = rawData.sublist(58, 60);
    ByteData rawCurrentDSVVA6ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentDSVVA6));

    currentDSVVA6 = (rawCurrentDSVVA6ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

    // 解析 currentDSInSlope6
    List<int> rawCurrentDSInSlope6 = rawData.sublist(60, 62);
    ByteData rawCurrentDSInSlope6ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentDSInSlope6));

    currentDSInSlope6 =
        (rawCurrentDSInSlope6ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 currentDSOutSlope6
    List<int> rawCurrentDSOutSlope6 = rawData.sublist(62, 64);
    ByteData rawCurrentDSOutSlope6ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentDSOutSlope6));

    currentDSOutSlope6 =
        (rawCurrentDSOutSlope6ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 currentUSVCA6
    List<int> rawCurrentUSVCA6 = rawData.sublist(64, 66);
    ByteData rawCurrentUSVCA6ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentUSVCA6));

    currentUSVCA6 = (rawCurrentUSVCA6ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

    // 解析 currentWorkingMode
    currentWorkingMode = rawData[70].toString();

    // 解析 currentDetectedSplitOption
    currentDetectedSplitOption = rawData[71].toString();

    // 解析 temperatureAlarmSeverity
    int temperatureStatus = rawData[128];
    temperatureAlarmSeverity =
        temperatureStatus == 1 ? Alarm.danger : Alarm.success;

    // 解析 voltageAlarmSeverity
    int voltageStatus = rawData[129];
    voltageAlarmSeverity = voltageStatus == 1 ? Alarm.danger : Alarm.success;

    // 解析 splitOptionAlarmSeverity
    int splitOptionStatus = rawData[134];
    splitOptionAlarmSeverity =
        splitOptionStatus == 1 ? Alarm.danger : Alarm.success;

    // 解析 voltageRippleAlarmSeverity
    int voltageRippleStatus = rawData[135];
    voltageRippleAlarmSeverity =
        voltageRippleStatus == 1 ? Alarm.danger : Alarm.success;

    // 解析 rfOutputPower1AlarmSeverity
    int outputPower1Status = rawData[136];
    rfOutputPower1AlarmSeverity =
        outputPower1Status == 1 ? Alarm.danger : Alarm.success;

    // 解析 rfOutputPower3AlarmSeverity
    int outputPower3Status = rawData[138];
    rfOutputPower3AlarmSeverity =
        outputPower3Status == 1 ? Alarm.danger : Alarm.success;

    // 解析 rfOutputPower4AlarmSeverity
    int outputPower4Status = rawData[139];
    rfOutputPower4AlarmSeverity =
        outputPower4Status == 1 ? Alarm.danger : Alarm.success;

    // 解析 rfOutputPower6AlarmSeverity
    int outputPower6Status = rawData[141];
    rfOutputPower6AlarmSeverity =
        outputPower6Status == 1 ? Alarm.danger : Alarm.success;

    return A1P8GCCorNodeA1(
      currentTemperatureC: currentTemperatureC,
      currentTemperatureF: currentTemperatureF,
      currentVoltage: currentVoltage,
      currentVoltageRipple: currentVoltageRipple,
      currentRFOutputPower1: currentRFOutputPower1,
      currentRFOutputPower3: currentRFOutputPower3,
      currentRFOutputPower4: currentRFOutputPower4,
      currentRFOutputPower6: currentRFOutputPower6,
      currentDSVVA1: currentDSVVA1,
      currentDSInSlope1: currentDSInSlope1,
      currentDSOutSlope1: currentDSOutSlope1,
      currentUSVCA1: currentUSVCA1,
      currentDSVVA3: currentDSVVA3,
      currentDSInSlope3: currentDSInSlope3,
      currentDSOutSlope3: currentDSOutSlope3,
      currentUSVCA3: currentUSVCA3,
      currentDSVVA4: currentDSVVA4,
      currentDSInSlope4: currentDSInSlope4,
      currentDSOutSlope4: currentDSOutSlope4,
      currentUSVCA4: currentUSVCA4,
      currentDSVVA6: currentDSVVA6,
      currentDSInSlope6: currentDSInSlope6,
      currentDSOutSlope6: currentDSOutSlope6,
      currentUSVCA6: currentUSVCA6,
      currentWorkingMode: currentWorkingMode,
      currentDetectedSplitOption: currentDetectedSplitOption,
      unitStatusAlarmSeverity: unitStatusAlarmSeverity.name,
      temperatureAlarmSeverity: temperatureAlarmSeverity.name,
      voltageAlarmSeverity: voltageAlarmSeverity.name,
      splitOptionAlarmSeverity: splitOptionAlarmSeverity.name,
      voltageRippleAlarmSeverity: voltageRippleAlarmSeverity.name,
      rfOutputPower1AlarmSeverity: rfOutputPower1AlarmSeverity.name,
      rfOutputPower3AlarmSeverity: rfOutputPower3AlarmSeverity.name,
      rfOutputPower4AlarmSeverity: rfOutputPower4AlarmSeverity.name,
      rfOutputPower6AlarmSeverity: rfOutputPower6AlarmSeverity.name,
    );
  }

  A1P8GAlarm decodeAlarmSeverity(List<int> rawData) {
    // 給 定期更新 information page 的 alarm 用
    Alarm unitStatusAlarmSeverity = Alarm.medium;
    Alarm temperatureAlarmSeverity = Alarm.medium;
    Alarm powerAlarmSeverity = Alarm.medium;

    int unitStatus = rawData[3];
    unitStatusAlarmSeverity = unitStatus == 1 ? Alarm.success : Alarm.danger;

    int temperatureStatus = rawData[128];
    temperatureAlarmSeverity =
        temperatureStatus == 1 ? Alarm.danger : Alarm.success;

    int powerStatus = rawData[129];
    powerAlarmSeverity = powerStatus == 1 ? Alarm.danger : Alarm.success;

    A1P8GAlarm a1p8gAlarm = A1P8GAlarm(
      unitStatusAlarmSeverity: unitStatusAlarmSeverity.name,
      temperatureAlarmSeverity: temperatureAlarmSeverity.name,
      powerAlarmSeverity: powerAlarmSeverity.name,
    );

    return a1p8gAlarm;
  }

  A1P8GCCorNodeLogStatistic getA1p8GCCorNodeLogStatistics(
      List<Log1p8GCCorNode> log1p8Gs) {
    UnitConverter unitConverter = UnitConverter();
    if (log1p8Gs.isNotEmpty) {
      // get min temperature
      double historicalMinTemperature = log1p8Gs
          .map((log1p8G) => log1p8G.temperature)
          .reduce((min, current) => min < current ? min : current);

      // get max temperature
      double historicalMaxTemperature = log1p8Gs
          .map((log1p8G) => log1p8G.temperature)
          .reduce((max, current) => max > current ? max : current);

      // get min rfOutputPower1
      double historicalMinRFOutputPower1 = log1p8Gs
          .map((log1p8G) => log1p8G.rfOutputPower1)
          .reduce((min, current) => min < current ? min : current);

      // get max rfOutputPower1
      double historicalMaxRFOutputPower1 = log1p8Gs
          .map((log1p8G) => log1p8G.rfOutputPower1)
          .reduce((max, current) => max > current ? max : current);

      // get min rfOutputPower3
      double historicalMinRFOutputPower3 = log1p8Gs
          .map((log1p8G) => log1p8G.rfOutputPower3)
          .reduce((min, current) => min < current ? min : current);

      // get max rfOutputPower3
      double historicalMaxRFOutputPower3 = log1p8Gs
          .map((log1p8G) => log1p8G.rfOutputPower3)
          .reduce((max, current) => max > current ? max : current);

      // get min rfOutputPower4
      double historicalMinRFOutputPower4 = log1p8Gs
          .map((log1p8G) => log1p8G.rfOutputPower4)
          .reduce((min, current) => min < current ? min : current);

      // get max rfOutputPower4
      double historicalMaxRFOutputPower4 = log1p8Gs
          .map((log1p8G) => log1p8G.rfOutputPower4)
          .reduce((max, current) => max > current ? max : current);

      // get min rfOutputPower6
      double historicalMinRFOutputPower6 = log1p8Gs
          .map((log1p8G) => log1p8G.rfOutputPower6)
          .reduce((min, current) => min < current ? min : current);

      // get max rfOutputPower6
      double historicalMaxRFOutputPower6 = log1p8Gs
          .map((log1p8G) => log1p8G.rfOutputPower6)
          .reduce((max, current) => max > current ? max : current);

      String historicalMinTemperatureC = historicalMinTemperature.toString();

      String historicalMaxTemperatureC = historicalMaxTemperature.toString();

      String historicalMinTemperatureF = unitConverter
          .converCelciusToFahrenheit(historicalMinTemperature)
          .toStringAsFixed(1);

      String historicalMaxTemperatureF = unitConverter
          .converCelciusToFahrenheit(historicalMaxTemperature)
          .toStringAsFixed(1);

      A1P8GCCorNodeLogStatistic a1p8gLogStatistic = A1P8GCCorNodeLogStatistic(
        historicalMinTemperatureC: historicalMinTemperatureC,
        historicalMaxTemperatureC: historicalMaxTemperatureC,
        historicalMinTemperatureF: historicalMinTemperatureF,
        historicalMaxTemperatureF: historicalMaxTemperatureF,
        historicalMinRFOutputPower1: historicalMinRFOutputPower1.toString(),
        historicalMaxRFOutputPower1: historicalMaxRFOutputPower1.toString(),
        historicalMinRFOutputPower3: historicalMinRFOutputPower3.toString(),
        historicalMaxRFOutputPower3: historicalMaxRFOutputPower3.toString(),
        historicalMinRFOutputPower4: historicalMinRFOutputPower4.toString(),
        historicalMaxRFOutputPower4: historicalMaxRFOutputPower4.toString(),
        historicalMinRFOutputPower6: historicalMinRFOutputPower6.toString(),
        historicalMaxRFOutputPower6: historicalMaxRFOutputPower6.toString(),
      );

      return a1p8gLogStatistic;
    } else {
      A1P8GCCorNodeLogStatistic a1p8gLogStatistic =
          const A1P8GCCorNodeLogStatistic(
        historicalMinTemperatureC: '',
        historicalMaxTemperatureC: '',
        historicalMinTemperatureF: '',
        historicalMaxTemperatureF: '',
        historicalMinRFOutputPower1: '',
        historicalMaxRFOutputPower1: '',
        historicalMinRFOutputPower3: '',
        historicalMaxRFOutputPower3: '',
        historicalMinRFOutputPower4: '',
        historicalMaxRFOutputPower4: '',
        historicalMinRFOutputPower6: '',
        historicalMaxRFOutputPower6: '',
      );
      return a1p8gLogStatistic;
    }
  }

  List<Log1p8GCCorNode> parse1P8GCCorNodeLog(List<int> rawData) {
    List<Log1p8GCCorNode> logChunks = [];
    rawData.removeRange(rawData.length - 2, rawData.length);
    rawData.removeRange(0, 3);
    for (var i = 0; i < 1024; i++) {
      // 如果檢查到有一筆log 的內容全部是 255, 則視為沒有更多log資料了
      bool isEmptyLog = rawData
          .sublist(i * 16, i * 16 + 16)
          .every((element) => element == 255);
      if (isEmptyLog) {
        break;
      }
      // 解析 strDateTime
      List<int> rawYear = rawData.sublist(i * 16, i * 16 + 2);
      ByteData rawYearByteData =
          ByteData.sublistView(Uint8List.fromList(rawYear));
      String strYear = rawYearByteData.getInt16(0, Endian.little).toString();

      String strMonth = rawData[i * 16 + 2].toString().padLeft(2, '0');
      String strDay = rawData[i * 16 + 3].toString().padLeft(2, '0');
      String strHour = rawData[i * 16 + 4].toString().padLeft(2, '0');
      String strMinute = rawData[i * 16 + 5].toString().padLeft(2, '0');

      List<int> rawTemperature = rawData.sublist(i * 16 + 6, i * 16 + 8);
      ByteData rawTemperatureByteData =
          ByteData.sublistView(Uint8List.fromList(rawTemperature));
      double temperature =
          rawTemperatureByteData.getInt16(0, Endian.little) / 10;

      List<int> rawRFOutputPower1 = rawData.sublist(i * 16 + 8, i * 16 + 10);
      ByteData rawRFOutputPower1ByteData =
          ByteData.sublistView(Uint8List.fromList(rawRFOutputPower1));
      double rfOutputPower1 =
          rawRFOutputPower1ByteData.getInt16(0, Endian.little) / 10;

      List<int> rawRFOutputPower3 = rawData.sublist(i * 16 + 10, i * 16 + 12);
      ByteData rawRFOutputPower3ByteData =
          ByteData.sublistView(Uint8List.fromList(rawRFOutputPower3));
      double rfOutputPower3 =
          rawRFOutputPower3ByteData.getInt16(0, Endian.little) / 10;

      List<int> rawRFOutputPower4 = rawData.sublist(i * 16 + 12, i * 16 + 14);
      ByteData rawRFOutputPower4ByteData =
          ByteData.sublistView(Uint8List.fromList(rawRFOutputPower4));
      double rfOutputPower4 =
          rawRFOutputPower4ByteData.getInt16(0, Endian.little) / 10;

      List<int> rawRFOutputPower6 = rawData.sublist(i * 16 + 14, i * 16 + 16);
      ByteData rawRFOutputPower6ByteData =
          ByteData.sublistView(Uint8List.fromList(rawRFOutputPower6));
      double rfOutputPower6 =
          rawRFOutputPower6ByteData.getInt16(0, Endian.little) / 10;

      final DateTime dateTime =
          DateTime.parse('$strYear-$strMonth-$strDay $strHour:$strMinute:00');

      logChunks.add(Log1p8GCCorNode(
        dateTime: dateTime,
        temperature: temperature,
        rfOutputPower1: rfOutputPower1,
        rfOutputPower3: rfOutputPower3,
        rfOutputPower4: rfOutputPower4,
        rfOutputPower6: rfOutputPower6,
      ));
    }

    return logChunks;
  }

  List<Event1p8GCCorNode> parse1p8GCCorNodeEvent(List<int> rawData) {
    List<Event1p8GCCorNode> event1p8Gs = [];

    rawData.removeRange(rawData.length - 2, rawData.length);
    rawData.removeRange(0, 3);

    for (var i = 0; i < 1024; i++) {
      // 如果檢查到有一筆 event 的內容全部是 255, 則視為沒有更多 event 資料了
      bool isEmptyLog = rawData
          .sublist(i * 16, i * 16 + 16)
          .every((element) => element == 255);
      if (isEmptyLog) {
        break;
      }

      // 解析 strDateTime
      List<int> rawYear = rawData.sublist(i * 16, i * 16 + 2);
      ByteData rawYearByteData =
          ByteData.sublistView(Uint8List.fromList(rawYear));
      String strYear = rawYearByteData.getInt16(0, Endian.little).toString();

      String strMonth = rawData[i * 16 + 2].toString().padLeft(2, '0');
      String strDay = rawData[i * 16 + 3].toString().padLeft(2, '0');
      String strHour = rawData[i * 16 + 4].toString().padLeft(2, '0');
      String strMinute = rawData[i * 16 + 5].toString().padLeft(2, '0');

      final DateTime dateTime =
          DateTime.parse('$strYear-$strMonth-$strDay $strHour:$strMinute:00');

      List<int> rawCode = rawData.sublist(i * 16 + 6, i * 16 + 8);
      ByteData rawCodeByteData =
          ByteData.sublistView(Uint8List.fromList(rawCode));
      int code = rawCodeByteData.getInt16(0, Endian.little);

      List<int> rawParameter = rawData.sublist(i * 16 + 8, i * 16 + 10);
      ByteData rawParameterByteData =
          ByteData.sublistView(Uint8List.fromList(rawParameter));
      int parameter = rawParameterByteData.getInt16(0, Endian.little);

      event1p8Gs.add(Event1p8GCCorNode(
        dateTime: dateTime,
        code: code,
        parameter: parameter,
      ));
    }

    return event1p8Gs;
  }

  Future<dynamic> export1p8GCCorNodeRecords({
    required String code,
    required Map<String, String> configurationData,
    required List<Map<String, String>> controlData,
    // required String coordinate,
    // required String location,
    required List<Log1p8GCCorNode> log1p8Gs,
    required List<Event1p8GCCorNode> event1p8Gs,
  }) async {
    Excel excel = Excel.createExcel();

    List<String> log1p8GHeader = [
      'Time',
      'Temperature(C)',
      'Port 1 RF Output Power',
      'Port 3 RF Output Power',
      'Port 4 RF Output Power',
      'Port 6 RF Output Power',
    ];
    List<String> eventHeader = [
      '24V High Alarm(V)',
      '24V Low Alarm(V)',
      'Temperature High Alarm(C)',
      'Temperature Low Alarm(C)',
      'Port 1 RF Output Power High Alarm',
      'Port 1 RF Output Power Low Alarm',
      'Port 3 RF Output Power High Alarm',
      'Port 3 RF Output Power Low Alarm',
      'Port 4 RF Output Power High Alarm',
      'Port 4 RF Output Power Low Alarm',
      'Port 6 RF Output Power High Alarm',
      'Port 6 RF Output Power Low Alarm',
      '24V Ripple High Alarm',
      '24V Ripple Low Alarm',
      'Amplifier Power On',
    ];

    excel.rename('Sheet1', 'User Information');
    Sheet userInformationSheet = excel['User Information'];
    Sheet log1p8GSheet = excel['Log'];
    Sheet eventSheet = excel['Event'];

    userInformationSheet.insertRowIterables(['Code Number', code], 0);

    // 空兩行後再開始寫入 configuration data
    List<String> configurationDataKeys = configurationData.keys.toList();
    for (int i = 0; i < configurationDataKeys.length; i++) {
      String key = configurationDataKeys[i];
      String value = configurationData[key] ?? '';

      userInformationSheet.insertRowIterables([key, value], i + 3);
    }

    // 空兩行後再開始寫入 control data
    for (int i = 0; i < controlData.length; i++) {
      MapEntry entry = controlData[i].entries.first;
      userInformationSheet.insertRowIterables(
          [entry.key, entry.value], i + configurationDataKeys.length + 5);
    }

    eventSheet.insertRowIterables(eventHeader, 0);
    List<List<String>> eventContent = formatEvent1p8G(event1p8Gs);
    for (int i = 0; i < eventContent.length; i++) {
      List<String> row = eventContent[i];
      eventSheet.insertRowIterables(row, i + 1);
    }

    log1p8GSheet.insertRowIterables(log1p8GHeader, 0);
    for (int i = 0; i < log1p8Gs.length; i++) {
      Log1p8GCCorNode log1p8G = log1p8Gs[i];
      List<String> row = formatLog1p8G(log1p8G);
      log1p8GSheet.insertRowIterables(row, i + 1);
    }

    var fileBytes = excel.save();

    String timeStamp =
        DateFormat('yyyy_MM_dd_HH_mm_ss').format(DateTime.now()).toString();
    String filename = 'log_$timeStamp';
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

  List<List<ValuePair>> get1p8GDateValueCollectionOfLogs(
      List<Log1p8GCCorNode> log1p8Gs) {
    List<ValuePair> temperatureDataList = [];
    List<ValuePair> rfOutputPower1DataList = [];
    List<ValuePair> rfOutputPower3DataList = [];
    List<ValuePair> rfOutputPower4DataList = [];
    List<ValuePair> rfOutputPower6DataList = [];

    for (Log1p8GCCorNode log1p8G in log1p8Gs.reversed) {
      temperatureDataList.add(ValuePair(
        x: log1p8G.dateTime,
        y: log1p8G.temperature,
      ));
      rfOutputPower1DataList.add(ValuePair(
        x: log1p8G.dateTime,
        y: log1p8G.rfOutputPower1,
      ));
      rfOutputPower3DataList.add(ValuePair(
        x: log1p8G.dateTime,
        y: log1p8G.rfOutputPower3,
      ));
      rfOutputPower4DataList.add(ValuePair(
        x: log1p8G.dateTime,
        y: log1p8G.rfOutputPower4,
      ));
      rfOutputPower6DataList
          .add(ValuePair(x: log1p8G.dateTime, y: log1p8G.rfOutputPower6));
    }

    return [
      temperatureDataList,
      rfOutputPower1DataList,
      rfOutputPower3DataList,
      rfOutputPower4DataList,
      rfOutputPower6DataList,
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

  List<String> formatLog1p8G(Log1p8GCCorNode log1p8G) {
    String formattedDateTime =
        DateFormat('yyyy-MM-dd HH:mm').format(log1p8G.dateTime);
    String temperatureC = log1p8G.temperature.toString();
    String rfOutputPower1 = log1p8G.rfOutputPower1.toString();
    String rfOutputPower3 = log1p8G.rfOutputPower3.toString();
    String rfOutputPower4 = log1p8G.rfOutputPower4.toString();
    String rfOutputPower6 = log1p8G.rfOutputPower6.toString();
    List<String> row = [
      formattedDateTime,
      temperatureC,
      rfOutputPower1,
      rfOutputPower3,
      rfOutputPower4,
      rfOutputPower6
    ];

    return row;
  }

  List<List<String>> formatEvent1p8G(List<Event1p8GCCorNode> event1p8Gs) {
    List<int> counts = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    List<List<String>> csvContent = List<List<String>>.generate(
      1024,
      (index) => List<String>.generate(
        15,
        (index) => '',
        growable: false,
      ),
      growable: false,
    );

    for (Event1p8GCCorNode event1p8G in event1p8Gs) {
      String formattedDateTime =
          DateFormat('yyyy-MM-dd HH:mm').format(event1p8G.dateTime);

      switch (event1p8G.code) {
        case 1:
          {
            int index = 0;
            if (event1p8G.parameter > 0) {
              csvContent[counts[index]][index] =
                  '$formattedDateTime@${event1p8G.parameter / 10}';
            } else {
              csvContent[counts[index]][index] = formattedDateTime;
            }
            counts[index]++;
            break;
          }
        case 2:
          {
            int index = 1;
            if (event1p8G.parameter > 0) {
              csvContent[counts[index]][index] =
                  '$formattedDateTime@${event1p8G.parameter / 10}';
            } else {
              csvContent[counts[index]][index] = formattedDateTime;
            }
            counts[index]++;
            break;
          }
        case 3:
          {
            int index = 2;
            if (event1p8G.parameter > 0) {
              csvContent[counts[index]][index] =
                  '$formattedDateTime@${event1p8G.parameter / 10}';
            } else {
              csvContent[counts[index]][index] = formattedDateTime;
            }
            counts[index]++;
            break;
          }
        case 4:
          {
            int index = 3;
            if (event1p8G.parameter > 0) {
              csvContent[counts[index]][index] =
                  '$formattedDateTime@${event1p8G.parameter / 10}';
            } else {
              csvContent[counts[index]][index] = formattedDateTime;
            }
            counts[index]++;
            break;
          }
        case 5:
          {
            int index = 4;
            if (event1p8G.parameter > 0) {
              csvContent[counts[index]][index] =
                  '$formattedDateTime@${event1p8G.parameter / 10}';
            } else {
              csvContent[counts[index]][index] = formattedDateTime;
            }
            counts[index]++;
            break;
          }
        case 6:
          {
            int index = 5;
            if (event1p8G.parameter > 0) {
              csvContent[counts[index]][index] =
                  '$formattedDateTime@${event1p8G.parameter / 10}';
            } else {
              csvContent[counts[index]][index] = formattedDateTime;
            }
            counts[index]++;
            break;
          }
        case 7:
          {
            int index = 6;
            if (event1p8G.parameter > 0) {
              csvContent[counts[index]][index] =
                  '$formattedDateTime@${event1p8G.parameter / 10}';
            } else {
              csvContent[counts[index]][index] = formattedDateTime;
            }
            counts[index]++;
            break;
          }
        case 8:
          {
            int index = 7;
            if (event1p8G.parameter > 0) {
              csvContent[counts[index]][index] =
                  '$formattedDateTime@${event1p8G.parameter / 10}';
            } else {
              csvContent[counts[index]][index] = formattedDateTime;
            }
            counts[index]++;
            break;
          }
        case 9:
          {
            int index = 8;
            if (event1p8G.parameter > 0) {
              csvContent[counts[index]][index] =
                  '$formattedDateTime@${event1p8G.parameter / 10}';
            } else {
              csvContent[counts[index]][index] = formattedDateTime;
            }
            counts[index]++;
            break;
          }
        case 10:
          {
            int index = 9;
            if (event1p8G.parameter > 0) {
              csvContent[counts[index]][index] =
                  '$formattedDateTime@${event1p8G.parameter / 10}';
            } else {
              csvContent[counts[index]][index] = formattedDateTime;
            }
            counts[index]++;
            break;
          }
        case 11:
          {
            int index = 10;
            if (event1p8G.parameter > 0) {
              csvContent[counts[index]][index] =
                  '$formattedDateTime@${event1p8G.parameter / 10}';
            } else {
              csvContent[counts[index]][index] = formattedDateTime;
            }
            counts[index]++;
            break;
          }
        case 12:
          {
            int index = 11;
            if (event1p8G.parameter > 0) {
              csvContent[counts[index]][index] =
                  '$formattedDateTime@${event1p8G.parameter / 10}';
            } else {
              csvContent[counts[index]][index] = formattedDateTime;
            }
            counts[index]++;
            break;
          }
        case 13:
          {
            int index = 12;
            if (event1p8G.parameter > 0) {
              csvContent[counts[index]][index] =
                  '$formattedDateTime@${event1p8G.parameter / 10}';
            } else {
              csvContent[counts[index]][index] = formattedDateTime;
            }
            counts[index]++;
            break;
          }
        case 14:
          {
            int index = 13;
            if (event1p8G.parameter > 0) {
              csvContent[counts[index]][index] =
                  '$formattedDateTime@${event1p8G.parameter / 10}';
            } else {
              csvContent[counts[index]][index] = formattedDateTime;
            }
            counts[index]++;
            break;
          }
        case 15:
          {
            int index = 14;
            if (event1p8G.parameter > 0) {
              csvContent[counts[index]][index] =
                  '$formattedDateTime@${event1p8G.parameter}';
            } else {
              csvContent[counts[index]][index] = formattedDateTime;
            }
            counts[index]++;
            break;
          }
      }
    }

    return csvContent;
  }

  double _convertToFahrenheit(double celcius) {
    double fahrenheit = (celcius * 1.8) + 32;
    return fahrenheit;
  }

  void calculate18CRCs() {
    CRC16.calculateCRC16(command: Command18CCorNode.req00Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18CCorNode.req91Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18CCorNode.req92Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18CCorNode.reqA1Cmd, usDataLength: 6);

    CRC16.calculateCRC16(
        command: Command18CCorNode.reqLog00Cmd, usDataLength: 6);
    CRC16.calculateCRC16(
        command: Command18CCorNode.reqLog01Cmd, usDataLength: 6);
    CRC16.calculateCRC16(
        command: Command18CCorNode.reqLog02Cmd, usDataLength: 6);
    CRC16.calculateCRC16(
        command: Command18CCorNode.reqLog03Cmd, usDataLength: 6);
    CRC16.calculateCRC16(
        command: Command18CCorNode.reqLog04Cmd, usDataLength: 6);
    CRC16.calculateCRC16(
        command: Command18CCorNode.reqLog05Cmd, usDataLength: 6);
    CRC16.calculateCRC16(
        command: Command18CCorNode.reqLog06Cmd, usDataLength: 6);
    CRC16.calculateCRC16(
        command: Command18CCorNode.reqLog07Cmd, usDataLength: 6);
    CRC16.calculateCRC16(
        command: Command18CCorNode.reqLog08Cmd, usDataLength: 6);
    CRC16.calculateCRC16(
        command: Command18CCorNode.reqLog09Cmd, usDataLength: 6);
    CRC16.calculateCRC16(
        command: Command18CCorNode.reqEvent00Cmd, usDataLength: 6);

    _command18CCorNodeCollection.add(Command18CCorNode.req00Cmd);
    _command18CCorNodeCollection.add(Command18CCorNode.req91Cmd);
    _command18CCorNodeCollection.add(Command18CCorNode.req92Cmd);
    _command18CCorNodeCollection.add(Command18CCorNode.reqA1Cmd);
    _command18CCorNodeCollection.add(Command18CCorNode.reqLog00Cmd);
    _command18CCorNodeCollection.add(Command18CCorNode.reqLog01Cmd);
    _command18CCorNodeCollection.add(Command18CCorNode.reqLog02Cmd);
    _command18CCorNodeCollection.add(Command18CCorNode.reqLog03Cmd);
    _command18CCorNodeCollection.add(Command18CCorNode.reqLog04Cmd);
    _command18CCorNodeCollection.add(Command18CCorNode.reqLog05Cmd);
    _command18CCorNodeCollection.add(Command18CCorNode.reqLog06Cmd);
    _command18CCorNodeCollection.add(Command18CCorNode.reqLog07Cmd);
    _command18CCorNodeCollection.add(Command18CCorNode.reqLog08Cmd);
    _command18CCorNodeCollection.add(Command18CCorNode.reqLog09Cmd);
    _command18CCorNodeCollection.add(Command18CCorNode.reqEvent00Cmd);
  }
}

class Log1p8GCCorNode {
  const Log1p8GCCorNode({
    required this.dateTime,
    required this.temperature,
    required this.rfOutputPower1,
    required this.rfOutputPower3,
    required this.rfOutputPower4,
    required this.rfOutputPower6,
  });

  final DateTime dateTime;
  final double temperature;
  final double rfOutputPower1;
  final double rfOutputPower3;
  final double rfOutputPower4;
  final double rfOutputPower6;
}

class Event1p8GCCorNode {
  const Event1p8GCCorNode({
    required this.dateTime,
    required this.code,
    required this.parameter,
  });

  final DateTime dateTime;
  final int code;
  final int parameter;
}

class A1P8GCCorNode80 {
  const A1P8GCCorNode80({
    required this.partName,
    required this.partNo,
    required this.partId,
    required this.serialNumber,
    required this.firmwareVersion,
    required this.hardwareVersion,
    required this.mfgDate,
    required this.coordinate,
    required this.nowDateTime,
  });

  final String partName;
  final String partNo;
  final String partId;
  final String serialNumber;
  final String firmwareVersion;
  final String hardwareVersion;
  final String mfgDate;
  final String coordinate;
  final String nowDateTime;
}

class A1P8GCCorNode91 {
  const A1P8GCCorNode91({
    required this.maxTemperatureC,
    required this.minTemperatureC,
    required this.maxTemperatureF,
    required this.minTemperatureF,
    required this.maxVoltage,
    required this.minVoltage,
    required this.maxRFOutputPower1,
    required this.minRFOutputPower1,
    required this.ingressSetting1,
    required this.ingressSetting3,
    required this.ingressSetting4,
    required this.ingressSetting6,
    required this.forwardConfig,
    required this.splitOption,
    required this.forwardMode,
    required this.maxRFOutputPower3,
    required this.minRFOutputPower3,
    required this.dsVVA1,
    required this.dsInSlope1,
    required this.dsOutSlope1,
    required this.usVCA1,
    required this.rfOutputPower1AlarmState,
    required this.rfOutputPower3AlarmState,
    required this.rfOutputPower4AlarmState,
    required this.rfOutputPower6AlarmState,
    required this.temperatureAlarmState,
    required this.voltageAlarmState,
    required this.maxRFOutputPower4,
    required this.minRFOutputPower4,
    required this.splitOptionAlarmState,
    required this.location,
    required this.logInterval,
    required this.dsVVA3,
    required this.dsInSlope3,
    required this.dsOutSlope3,
    required this.usVCA3,
    required this.dsVVA4,
    required this.dsInSlope4,
    required this.dsOutSlope4,
    required this.usVCA4,
    required this.dsVVA6,
    required this.dsInSlope6,
    required this.dsOutSlope6,
    required this.usVCA6,
    required this.maxRFOutputPower6,
    required this.minRFOutputPower6,
  });

  final String maxTemperatureC;
  final String minTemperatureC;
  final String maxTemperatureF;
  final String minTemperatureF;
  final String maxVoltage;
  final String minVoltage;
  final String maxRFOutputPower1;
  final String minRFOutputPower1;
  final String ingressSetting1;
  final String ingressSetting3;
  final String ingressSetting4;
  final String ingressSetting6;
  final String forwardMode;
  final String forwardConfig;
  final String splitOption;
  final String maxRFOutputPower3;
  final String minRFOutputPower3;
  final String dsVVA1;
  final String dsInSlope1;
  final String dsOutSlope1;
  final String usVCA1;
  final String rfOutputPower1AlarmState;
  final String rfOutputPower3AlarmState;
  final String rfOutputPower4AlarmState;
  final String rfOutputPower6AlarmState;
  final String temperatureAlarmState;
  final String voltageAlarmState;
  final String maxRFOutputPower4;
  final String minRFOutputPower4;
  final String splitOptionAlarmState;
  final String location;
  final String logInterval;
  final String dsVVA3;
  final String dsInSlope3;
  final String dsOutSlope3;
  final String usVCA3;
  final String dsVVA4;
  final String dsInSlope4;
  final String dsOutSlope4;
  final String usVCA4;
  final String dsVVA6;
  final String dsInSlope6;
  final String dsOutSlope6;
  final String usVCA6;
  final String maxRFOutputPower6;
  final String minRFOutputPower6;
}

class A1P8GCCorNode92 {
  const A1P8GCCorNode92({
    required this.biasCurrent1,
    required this.biasCurrent3,
    required this.biasCurrent4,
    required this.biasCurrent6,
  });

  final String biasCurrent1;
  final String biasCurrent3;
  final String biasCurrent4;
  final String biasCurrent6;
}

class A1P8GCCorNodeA1 {
  const A1P8GCCorNodeA1({
    required this.currentTemperatureC,
    required this.currentTemperatureF,
    required this.currentVoltage,
    required this.currentVoltageRipple,
    required this.currentRFOutputPower1,
    required this.currentRFOutputPower3,
    required this.currentRFOutputPower4,
    required this.currentRFOutputPower6,
    required this.currentDSVVA1,
    required this.currentDSInSlope1,
    required this.currentDSOutSlope1,
    required this.currentUSVCA1,
    required this.currentDSVVA3,
    required this.currentDSInSlope3,
    required this.currentDSOutSlope3,
    required this.currentUSVCA3,
    required this.currentDSVVA4,
    required this.currentDSInSlope4,
    required this.currentDSOutSlope4,
    required this.currentUSVCA4,
    required this.currentDSVVA6,
    required this.currentDSInSlope6,
    required this.currentDSOutSlope6,
    required this.currentUSVCA6,
    required this.currentWorkingMode,
    required this.currentDetectedSplitOption,
    required this.unitStatusAlarmSeverity,
    required this.temperatureAlarmSeverity,
    required this.voltageAlarmSeverity,
    required this.splitOptionAlarmSeverity,
    required this.voltageRippleAlarmSeverity,
    required this.rfOutputPower1AlarmSeverity,
    required this.rfOutputPower3AlarmSeverity,
    required this.rfOutputPower4AlarmSeverity,
    required this.rfOutputPower6AlarmSeverity,
  });

  final String currentTemperatureC;
  final String currentTemperatureF;
  final String currentVoltage;
  final String currentVoltageRipple;
  final String currentRFOutputPower1;
  final String currentRFOutputPower3;
  final String currentRFOutputPower4;
  final String currentRFOutputPower6;
  final String currentDSVVA1;
  final String currentDSInSlope1;
  final String currentDSOutSlope1;
  final String currentUSVCA1;
  final String currentDSVVA3;
  final String currentDSInSlope3;
  final String currentDSOutSlope3;
  final String currentUSVCA3;
  final String currentDSVVA4;
  final String currentDSInSlope4;
  final String currentDSOutSlope4;
  final String currentUSVCA4;
  final String currentDSVVA6;
  final String currentDSInSlope6;
  final String currentDSOutSlope6;
  final String currentUSVCA6;
  final String currentWorkingMode;
  final String currentDetectedSplitOption;
  final String unitStatusAlarmSeverity;
  final String temperatureAlarmSeverity;
  final String voltageAlarmSeverity;
  final String splitOptionAlarmSeverity;
  final String voltageRippleAlarmSeverity;
  final String rfOutputPower1AlarmSeverity;
  final String rfOutputPower3AlarmSeverity;
  final String rfOutputPower4AlarmSeverity;
  final String rfOutputPower6AlarmSeverity;
}

class A1P8GCCorNodeLogStatistic {
  const A1P8GCCorNodeLogStatistic({
    required this.historicalMinTemperatureC,
    required this.historicalMaxTemperatureC,
    required this.historicalMinTemperatureF,
    required this.historicalMaxTemperatureF,
    required this.historicalMinRFOutputPower1,
    required this.historicalMaxRFOutputPower1,
    required this.historicalMinRFOutputPower3,
    required this.historicalMaxRFOutputPower3,
    required this.historicalMinRFOutputPower4,
    required this.historicalMaxRFOutputPower4,
    required this.historicalMinRFOutputPower6,
    required this.historicalMaxRFOutputPower6,
  });

  final String historicalMinTemperatureC;
  final String historicalMaxTemperatureC;
  final String historicalMinTemperatureF;
  final String historicalMaxTemperatureF;
  final String historicalMinRFOutputPower1;
  final String historicalMaxRFOutputPower1;
  final String historicalMinRFOutputPower3;
  final String historicalMaxRFOutputPower3;
  final String historicalMinRFOutputPower4;
  final String historicalMaxRFOutputPower4;
  final String historicalMinRFOutputPower6;
  final String historicalMaxRFOutputPower6;
}
