import 'dart:async';
import 'dart:io';
import 'package:aci_plus_app/core/command18_c_core_node.dart';
import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/crc16_calculate.dart';
import 'package:aci_plus_app/repositories/dsim18_parser.dart';
import 'package:aci_plus_app/repositories/unit_converter.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class Dsim18CCorNodeParser {
  Dsim18CCorNodeParser() {
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
    for (int i = 43; i <= 62; i++) {
      serialNumber += String.fromCharCode(rawData[i]);
    }
    serialNumber = _trimString(serialNumber);

    // 解析 firmwareVersion
    for (int i = 63; i <= 66; i++) {
      firmwareVersion += String.fromCharCode(rawData[i]);
    }
    firmwareVersion = _trimString(firmwareVersion);

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
    String splitOption = '';
    String maxRFOutputPower3 = '';
    String minRFOutputPower3 = '';
    String forwardVVA1 = '';
    String forwardInSlope1 = '';
    String forwardOutSlope1 = '';
    String returnVCA1 = '';
    String rfOutputPowerAlarmState1 = '';
    String rfOutputPowerAlarmState3 = '';
    String rfOutputPowerAlarmState4 = '';
    String rfOutputPowerAlarmState6 = '';
    String temperatureAlarmState = '';
    String voltageAlarmState = '';
    String maxRFOutputPower4 = '';
    String minRFOutputPower4 = '';
    String splitOptionAlarmState = '';
    String location = '';
    String logInterval = '';
    String forwardVVA3 = '';
    String forwardInSlope3 = '';
    String forwardOutSlope3 = '';
    String returnVCA3 = '';
    String forwardVVA4 = '';
    String forwardInSlope4 = '';
    String forwardOutSlope4 = '';
    String returnVCA4 = '';
    String forwardVVA6 = '';
    String forwardInSlope6 = '';
    String forwardOutSlope6 = '';
    String returnVCA6 = '';
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

    // 解析 splitOption
    splitOption = rawData[25].toString();

    // 解析 maxRFOutputPower3
    List<int> rawMaxRFOutputPower3 = rawData.sublist(29, 31);
    ByteData rawMaxRFOutputPower3ByteData =
        ByteData.sublistView(Uint8List.fromList(rawMaxRFOutputPower3));
    maxRFOutputPower3 =
        rawMaxRFOutputPower3ByteData.getInt16(0, Endian.little).toString();

    // 解析 minRFOutputPower3
    List<int> rawMinRFOutputPower3 = rawData.sublist(31, 33);
    ByteData rawMinRFOutputPower3ByteData =
        ByteData.sublistView(Uint8List.fromList(rawMinRFOutputPower3));
    minRFOutputPower3 =
        rawMinRFOutputPower3ByteData.getInt16(0, Endian.little).toString();

    // 解析 fowwardVVA1
    List<int> rawForwardVVA1 = rawData.sublist(33, 35);
    ByteData rawForwardVVA1ByteData =
        ByteData.sublistView(Uint8List.fromList(rawForwardVVA1));
    forwardVVA1 = (rawForwardVVA1ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

    // 解析 fowwardInSlope1
    List<int> rawForwardInSlope1 = rawData.sublist(35, 37);
    ByteData rawForwardInSlope1ByteData =
        ByteData.sublistView(Uint8List.fromList(rawForwardInSlope1));
    forwardInSlope1 =
        (rawForwardInSlope1ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 forwardOutSlope1
    List<int> rawForwardOutSlope1 = rawData.sublist(37, 39);
    ByteData rawForwardOutSlope1ByteData =
        ByteData.sublistView(Uint8List.fromList(rawForwardOutSlope1));
    forwardOutSlope1 =
        rawForwardOutSlope1ByteData.getInt16(0, Endian.little).toString();

    // 解析 returnVCA1
    List<int> rawReturnVCA1 = rawData.sublist(39, 41);
    ByteData rawReturnVCA1ByteData =
        ByteData.sublistView(Uint8List.fromList(rawReturnVCA1));
    returnVCA1 = rawReturnVCA1ByteData.getInt16(0, Endian.little).toString();

    // 解析 rfOutputPowerAlarmState1
    rfOutputPowerAlarmState1 = rawData[41].toString();

    // 解析 rfOutputPowerAlarmState3
    rfOutputPowerAlarmState3 = rawData[42].toString();

    // 解析 rfOutputPowerAlarmState4
    rfOutputPowerAlarmState4 = rawData[43].toString();

    // 解析 rfOutputPowerAlarmState6
    rfOutputPowerAlarmState6 = rawData[44].toString();

    // 解析 temperatureAlarmState
    temperatureAlarmState = rawData[45].toString();

    // 解析 voltageAlarmState
    voltageAlarmState = rawData[46].toString();

    // 解析 maxRFOutputPower4
    List<int> rawMaxRFOutputPower4 = rawData.sublist(47, 49);
    ByteData rawMaxRFOutputPower4ByteData =
        ByteData.sublistView(Uint8List.fromList(rawMaxRFOutputPower4));
    maxRFOutputPower4 =
        rawMaxRFOutputPower4ByteData.getInt16(0, Endian.little).toString();

    // 解析 minRFOutputPower4
    List<int> rawMinRFOutputPower4 = rawData.sublist(49, 51);
    ByteData rawMinRFOutputPower4ByteData =
        ByteData.sublistView(Uint8List.fromList(rawMinRFOutputPower4));
    minRFOutputPower4 =
        rawMinRFOutputPower4ByteData.getInt16(0, Endian.little).toString();

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

    // 解析 forwardVVA3
    List<int> rawForwardVVA3 = rawData.sublist(151, 153);
    ByteData rawForwardVVA3ByteData =
        ByteData.sublistView(Uint8List.fromList(rawForwardVVA3));
    forwardVVA3 = (rawForwardVVA3ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

    // 解析 forwardInSlope3
    List<int> rawForwardInSlope3 = rawData.sublist(153, 155);
    ByteData rawForwardInSlope3ByteData =
        ByteData.sublistView(Uint8List.fromList(rawForwardInSlope3));
    forwardInSlope3 =
        (rawForwardInSlope3ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 forwardOutSlope3
    List<int> rawForwardOutSlope3 = rawData.sublist(155, 157);
    ByteData rawForwardOutSlope3ByteData =
        ByteData.sublistView(Uint8List.fromList(rawForwardOutSlope3));
    forwardOutSlope3 =
        (rawForwardOutSlope3ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 returnVCA3
    List<int> rawReturnVCA3 = rawData.sublist(157, 159);
    ByteData rawReturnVCA3ByteData =
        ByteData.sublistView(Uint8List.fromList(rawReturnVCA3));
    returnVCA3 = (rawReturnVCA3ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

    // 解析 forwardVVA4
    List<int> rawForwardVVA4 = rawData.sublist(159, 161);
    ByteData rawForwardVVA4ByteData =
        ByteData.sublistView(Uint8List.fromList(rawForwardVVA4));
    forwardVVA4 = (rawForwardVVA4ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

    // 解析 forwardInSlope4
    List<int> rawForwardInSlope4 = rawData.sublist(161, 163);
    ByteData rawForwardInSlope4ByteData =
        ByteData.sublistView(Uint8List.fromList(rawForwardInSlope4));
    forwardInSlope4 =
        (rawForwardInSlope4ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 forwardOutSlope4
    List<int> rawForwardOutSlope4 = rawData.sublist(163, 165);
    ByteData rawForwardOutSlope4ByteData =
        ByteData.sublistView(Uint8List.fromList(rawForwardOutSlope4));
    forwardOutSlope4 =
        (rawForwardOutSlope4ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 returnVCA4 (0xA2 DS VVA4 Set dB)
    List<int> rawReturnVCA4 = rawData.sublist(165, 167);
    ByteData rawReturnVCA4ByteData =
        ByteData.sublistView(Uint8List.fromList(rawReturnVCA4));
    returnVCA4 = (rawReturnVCA4ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

    // 解析 forwardVVA6
    List<int> rawForwardVVA6 = rawData.sublist(167, 169);
    ByteData rawForwardVVA6ByteData =
        ByteData.sublistView(Uint8List.fromList(rawForwardVVA6));
    forwardVVA6 = (rawForwardVVA6ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

    // 解析 forwardInSlope6
    List<int> rawForwardInSlope6 = rawData.sublist(169, 171);
    ByteData rawForwardInSlope6ByteData =
        ByteData.sublistView(Uint8List.fromList(rawForwardInSlope6));
    forwardInSlope6 =
        (rawForwardInSlope6ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 forwardOutSlope6
    List<int> rawForwardOutSlope6 = rawData.sublist(171, 173);
    ByteData rawForwardOutSlope6ByteData =
        ByteData.sublistView(Uint8List.fromList(rawForwardOutSlope6));
    forwardOutSlope6 =
        (rawForwardOutSlope6ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 returnVCA6
    List<int> rawReturnVCA6 = rawData.sublist(173, 175);
    ByteData rawReturnVCA6ByteData =
        ByteData.sublistView(Uint8List.fromList(rawReturnVCA6));
    returnVCA6 = (rawReturnVCA6ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

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
      splitOption: splitOption,
      maxRFOutputPower3: maxRFOutputPower3,
      minRFOutputPower3: minRFOutputPower3,
      forwardVVA1: forwardVVA1,
      forwardInSlope1: forwardInSlope1,
      forwardOutSlope1: forwardOutSlope1,
      returnVCA1: returnVCA1,
      rfOutputPowerAlarmState1: rfOutputPowerAlarmState1,
      rfOutputPowerAlarmState3: rfOutputPowerAlarmState3,
      rfOutputPowerAlarmState4: rfOutputPowerAlarmState4,
      rfOutputPowerAlarmState6: rfOutputPowerAlarmState6,
      temperatureAlarmState: temperatureAlarmState,
      voltageAlarmState: voltageAlarmState,
      maxRFOutputPower4: maxRFOutputPower4,
      minRFOutputPower4: minRFOutputPower4,
      splitOptionAlarmState: splitOptionAlarmState,
      location: location,
      logInterval: logInterval,
      forwardVVA3: forwardVVA3,
      forwardInSlope3: forwardInSlope3,
      forwardOutSlope3: forwardOutSlope3,
      returnVCA3: returnVCA3,
      forwardVVA4: forwardVVA4,
      forwardInSlope4: forwardInSlope4,
      forwardOutSlope4: forwardOutSlope4,
      returnVCA4: returnVCA4,
      forwardVVA6: forwardVVA6,
      forwardInSlope6: forwardInSlope6,
      forwardOutSlope6: forwardOutSlope6,
      returnVCA6: returnVCA6,
      maxRFOutputPower6: maxRFOutputPower6,
      minRFOutputPower6: minRFOutputPower6,
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
    String currentForwardVVA1;
    String currentForwardInSlope1;
    String currentForwardOutSlope1;
    String currentReturnVCA1;
    String currentForwardVVA3;
    String currentForwardInSlope3;
    String currentForwardOutSlope3;
    String currentReturnVCA3;
    String currentForwardVVA4;
    String currentForwardInSlope4;
    String currentForwardOutSlope4;
    String currentReturnVCA4;
    String currentForwardVVA6;
    String currentForwardInSlope6;
    String currentForwardOutSlope6;
    String currentReturnVCA6;
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

    // 解析 currentForwardVVA1
    List<int> rawCurrentForwardVVA1 = rawData.sublist(34, 36);
    ByteData rawCurrentForwardVVA1ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentForwardVVA1));

    currentForwardVVA1 =
        (rawCurrentForwardVVA1ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 currentForwardInSlope1
    List<int> rawCurrentForwardInSlope1 = rawData.sublist(36, 38);
    ByteData rawCurrentForwardInSlope1ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentForwardInSlope1));

    currentForwardInSlope1 =
        (rawCurrentForwardInSlope1ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 currentForwardOutSlope1
    List<int> rawCurrentForwardOutSlope1 = rawData.sublist(38, 40);
    ByteData rawCurrentForwardOutSlope1ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentForwardOutSlope1));

    currentForwardOutSlope1 =
        (rawCurrentForwardOutSlope1ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 currentReturnVCA1
    List<int> rawCurrentReturnVCA1 = rawData.sublist(40, 42);
    ByteData rawCurrentReturnVCA1ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentReturnVCA1));

    currentReturnVCA1 =
        (rawCurrentReturnVCA1ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 currentForwardVVA3
    List<int> rawCurrentForwardVVA3 = rawData.sublist(42, 44);
    ByteData rawCurrentForwardVVA3ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentForwardVVA3));

    currentForwardVVA3 =
        (rawCurrentForwardVVA3ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 currentForwardInSlope3
    List<int> rawCurrentForwardInSlope3 = rawData.sublist(44, 46);
    ByteData rawCurrentForwardInSlope3ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentForwardInSlope3));

    currentForwardInSlope3 =
        (rawCurrentForwardInSlope3ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 currentForwardOutSlope3
    List<int> rawCurrentForwardOutSlope3 = rawData.sublist(46, 48);
    ByteData rawCurrentForwardOutSlope3ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentForwardOutSlope3));

    currentForwardOutSlope3 =
        (rawCurrentForwardOutSlope3ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 currentReturnVCA3
    List<int> rawCurrentReturnVCA3 = rawData.sublist(48, 50);
    ByteData rawCurrentReturnVCA3ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentReturnVCA3));

    currentReturnVCA3 =
        (rawCurrentReturnVCA3ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 currentForwardVVA4
    List<int> rawCurrentForwardVVA4 = rawData.sublist(50, 52);
    ByteData rawCurrentForwardVVA4ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentForwardVVA4));

    currentForwardVVA4 =
        (rawCurrentForwardVVA4ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 currentForwardInSlope4
    List<int> rawCurrentForwardInSlope4 = rawData.sublist(52, 54);
    ByteData rawCurrentForwardInSlope4ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentForwardInSlope4));

    currentForwardInSlope4 =
        (rawCurrentForwardInSlope4ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 currentForwardOutSlope4
    List<int> rawCurrentForwardOutSlope4 = rawData.sublist(54, 56);
    ByteData rawCurrentForwardOutSlope4ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentForwardOutSlope4));

    currentForwardOutSlope4 =
        (rawCurrentForwardOutSlope4ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 currentReturnVCA4
    List<int> rawCurrentReturnVCA4 = rawData.sublist(56, 58);
    ByteData rawCurrentReturnVCA4ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentReturnVCA4));

    currentReturnVCA4 =
        (rawCurrentReturnVCA4ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 currentForwardVVA6
    List<int> rawCurrentForwardVVA6 = rawData.sublist(58, 60);
    ByteData rawCurrentForwardVVA6ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentForwardVVA6));

    currentForwardVVA6 =
        (rawCurrentForwardVVA6ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 currentForwardInSlope6
    List<int> rawCurrentForwardInSlope6 = rawData.sublist(60, 62);
    ByteData rawCurrentForwardInSlope6ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentForwardInSlope6));

    currentForwardInSlope6 =
        (rawCurrentForwardInSlope6ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 currentForwardOutSlope6
    List<int> rawCurrentForwardOutSlope6 = rawData.sublist(62, 64);
    ByteData rawCurrentForwardOutSlope6ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentForwardOutSlope6));

    currentForwardOutSlope6 =
        (rawCurrentForwardOutSlope6ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 currentReturnVCA6
    List<int> rawCurrentReturnVCA6 = rawData.sublist(64, 66);
    ByteData rawCurrentReturnVCA6ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentReturnVCA6));

    currentReturnVCA6 =
        (rawCurrentReturnVCA6ByteData.getInt16(0, Endian.little) / 10)
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
      currentForwardVVA1: currentForwardVVA1,
      currentForwardInSlope1: currentForwardInSlope1,
      currentForwardOutSlope1: currentForwardOutSlope1,
      currentReturnVCA1: currentReturnVCA1,
      currentForwardVVA3: currentForwardVVA3,
      currentForwardInSlope3: currentForwardInSlope3,
      currentForwardOutSlope3: currentForwardOutSlope3,
      currentReturnVCA3: currentReturnVCA3,
      currentForwardVVA4: currentForwardVVA4,
      currentForwardInSlope4: currentForwardInSlope4,
      currentForwardOutSlope4: currentForwardOutSlope4,
      currentReturnVCA4: currentReturnVCA4,
      currentForwardVVA6: currentForwardVVA6,
      currentForwardInSlope6: currentForwardInSlope6,
      currentForwardOutSlope6: currentForwardOutSlope6,
      currentReturnVCA6: currentReturnVCA6,
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

  A1P8GCCorNodeLogStatistic getA1p8GLogStatistics(
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

  List<Log1p8GCCorNode> parse1P8GLog(List<int> rawData) {
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

//   List<Event1p8G> parse1p8GEvent(List<int> rawData) {
//     List<Event1p8G> event1p8Gs = [];

//     rawData.removeRange(rawData.length - 2, rawData.length);
//     rawData.removeRange(0, 3);

//     for (var i = 0; i < 1024; i++) {
//       // 如果檢查到有一筆log 的內容全部是 255, 則視為沒有更多log資料了
//       bool isEmptyLog = rawData
//           .sublist(i * 16, i * 16 + 16)
//           .every((element) => element == 255);
//       if (isEmptyLog) {
//         break;
//       }

//       // 解析 strDateTime
//       List<int> rawYear = rawData.sublist(i * 16, i * 16 + 2);
//       ByteData rawYearByteData =
//           ByteData.sublistView(Uint8List.fromList(rawYear));
//       String strYear = rawYearByteData.getInt16(0, Endian.little).toString();

//       String strMonth = rawData[i * 16 + 2].toString().padLeft(2, '0');
//       String strDay = rawData[i * 16 + 3].toString().padLeft(2, '0');
//       String strHour = rawData[i * 16 + 4].toString().padLeft(2, '0');
//       String strMinute = rawData[i * 16 + 5].toString().padLeft(2, '0');

//       final DateTime dateTime =
//           DateTime.parse('$strYear-$strMonth-$strDay $strHour:$strMinute:00');

//       List<int> rawCode = rawData.sublist(i * 16 + 6, i * 16 + 8);
//       ByteData rawCodeByteData =
//           ByteData.sublistView(Uint8List.fromList(rawCode));
//       int code = rawCodeByteData.getInt16(0, Endian.little);

//       List<int> rawParameter = rawData.sublist(i * 16 + 8, i * 16 + 10);
//       ByteData rawParameterByteData =
//           ByteData.sublistView(Uint8List.fromList(rawParameter));
//       int parameter = rawParameterByteData.getInt16(0, Endian.little);

//       event1p8Gs.add(Event1p8G(
//         dateTime: dateTime,
//         code: code,
//         parameter: parameter,
//       ));
//     }

//     return event1p8Gs;
//   }

  Future<dynamic> export1p8GCCorNodeRecords({
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

    Sheet log1p8GSheet = excel['Log'];
    Sheet eventSheet = excel['Event'];

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

    excel.unLink('Sheet1'); // Excel 預設會自動產生 Sheet1, 所以先unlink
    excel.delete('Sheet1'); // 再刪除 Sheet1
    excel.link('Log', log1p8GSheet);
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

//   List<List<ValuePair>> get1p8GDateValueCollectionOfLogs(
//       List<Log1p8G> log1p8Gs) {
//     List<ValuePair> temperatureDataList = [];
//     List<ValuePair> rfOutputLowPilotDataList = [];
//     List<ValuePair> rfOutputHighPilotDataList = [];
//     List<ValuePair> voltageDataList = [];
//     List<ValuePair> voltageRippleDataList = [];

//     for (Log1p8G log1p8G in log1p8Gs.reversed) {
//       temperatureDataList.add(ValuePair(
//         x: log1p8G.dateTime,
//         y: log1p8G.temperature,
//       ));
//       rfOutputLowPilotDataList.add(ValuePair(
//         x: log1p8G.dateTime,
//         y: log1p8G.rfOutputLowPilot,
//       ));
//       rfOutputHighPilotDataList.add(ValuePair(
//         x: log1p8G.dateTime,
//         y: log1p8G.rfOutputHighPilot,
//       ));
//       voltageDataList.add(ValuePair(
//         x: log1p8G.dateTime,
//         y: log1p8G.voltage,
//       ));
//       voltageRippleDataList.add(ValuePair(
//         x: log1p8G.dateTime,
//         y: log1p8G.voltageRipple.toDouble(),
//       ));
//     }

//     return [
//       temperatureDataList,
//       rfOutputLowPilotDataList,
//       rfOutputHighPilotDataList,
//       voltageDataList,
//       voltageRippleDataList,
//     ];
//   }

//   List<List<ValuePair>> get1p8GValueCollectionOfRFInOut(
//       List<RFInOut> rfInOuts) {
//     List<ValuePair> rfInputs = [];
//     List<ValuePair> rfOutputs = [];

//     for (int i = 0; i < rfInOuts.length; i++) {
//       int frequency = 261 + 6 * i;

//       RFInOut rfInOut = rfInOuts[i];

//       rfOutputs.add(ValuePair(
//         x: frequency,
//         y: rfInOut.output,
//       ));

//       rfInputs.add(ValuePair(
//         x: frequency,
//         y: rfInOut.input,
//       ));
//     }

//     return [
//       rfOutputs,
//       rfInputs,
//     ];
//   }

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
        14,
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
    CRC16.calculateCRC16(command: Command18CCorNode.req01Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18CCorNode.req02Cmd, usDataLength: 6);
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
    _command18CCorNodeCollection.add(Command18CCorNode.req01Cmd);
    _command18CCorNodeCollection.add(Command18CCorNode.req02Cmd);
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
    required this.mfgDate,
    required this.coordinate,
    required this.nowDateTime,
  });

  final String partName;
  final String partNo;
  final String partId;
  final String serialNumber;
  final String firmwareVersion;
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
    required this.splitOption,
    required this.maxRFOutputPower3,
    required this.minRFOutputPower3,
    required this.forwardVVA1,
    required this.forwardInSlope1,
    required this.forwardOutSlope1,
    required this.returnVCA1,
    required this.rfOutputPowerAlarmState1,
    required this.rfOutputPowerAlarmState3,
    required this.rfOutputPowerAlarmState4,
    required this.rfOutputPowerAlarmState6,
    required this.temperatureAlarmState,
    required this.voltageAlarmState,
    required this.maxRFOutputPower4,
    required this.minRFOutputPower4,
    required this.splitOptionAlarmState,
    required this.location,
    required this.logInterval,
    required this.forwardVVA3,
    required this.forwardInSlope3,
    required this.forwardOutSlope3,
    required this.returnVCA3,
    required this.forwardVVA4,
    required this.forwardInSlope4,
    required this.forwardOutSlope4,
    required this.returnVCA4,
    required this.forwardVVA6,
    required this.forwardInSlope6,
    required this.forwardOutSlope6,
    required this.returnVCA6,
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
  final String splitOption;
  final String maxRFOutputPower3;
  final String minRFOutputPower3;
  final String forwardVVA1;
  final String forwardInSlope1;
  final String forwardOutSlope1;
  final String returnVCA1;
  final String rfOutputPowerAlarmState1;
  final String rfOutputPowerAlarmState3;
  final String rfOutputPowerAlarmState4;
  final String rfOutputPowerAlarmState6;
  final String temperatureAlarmState;
  final String voltageAlarmState;
  final String maxRFOutputPower4;
  final String minRFOutputPower4;
  final String splitOptionAlarmState;
  final String location;
  final String logInterval;
  final String forwardVVA3;
  final String forwardInSlope3;
  final String forwardOutSlope3;
  final String returnVCA3;
  final String forwardVVA4;
  final String forwardInSlope4;
  final String forwardOutSlope4;
  final String returnVCA4;
  final String forwardVVA6;
  final String forwardInSlope6;
  final String forwardOutSlope6;
  final String returnVCA6;
  final String maxRFOutputPower6;
  final String minRFOutputPower6;
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
    required this.currentForwardVVA1,
    required this.currentForwardInSlope1,
    required this.currentForwardOutSlope1,
    required this.currentReturnVCA1,
    required this.currentForwardVVA3,
    required this.currentForwardInSlope3,
    required this.currentForwardOutSlope3,
    required this.currentReturnVCA3,
    required this.currentForwardVVA4,
    required this.currentForwardInSlope4,
    required this.currentForwardOutSlope4,
    required this.currentReturnVCA4,
    required this.currentForwardVVA6,
    required this.currentForwardInSlope6,
    required this.currentForwardOutSlope6,
    required this.currentReturnVCA6,
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
  final String currentForwardVVA1;
  final String currentForwardInSlope1;
  final String currentForwardOutSlope1;
  final String currentReturnVCA1;
  final String currentForwardVVA3;
  final String currentForwardInSlope3;
  final String currentForwardOutSlope3;
  final String currentReturnVCA3;
  final String currentForwardVVA4;
  final String currentForwardInSlope4;
  final String currentForwardOutSlope4;
  final String currentReturnVCA4;
  final String currentForwardVVA6;
  final String currentForwardInSlope6;
  final String currentForwardOutSlope6;
  final String currentReturnVCA6;
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
