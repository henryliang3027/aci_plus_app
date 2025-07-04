import 'dart:async';
import 'dart:io';
import 'package:aci_plus_app/chart/shared/event1p8g_value.dart';
import 'package:aci_plus_app/core/command18.dart';
import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/crc16_calculate.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/repositories/unit_converter.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_speed_chart/speed_chart.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class Amp18Parser {
  Amp18Parser() {
    calculate18CRCs();
  }

  final List<List<int>> _command18Collection = [];

  List<List<int>> get command18Collection => _command18Collection;

  A1P8G0 decodeA1P8G0(List<int> rawData) {
    String partName = '';
    String partNo = '';
    String partId = '';
    String serialNumber = '';
    String firmwareVersion = '';
    String hardwareVersion = '';
    String mfgDate = '';
    String coordinate = '';
    String nowDateTime = '';
    String deviceMTU = '';
    String bluetoothDelayTime = '';

    // 解析 partName
    for (int i = 3; i <= 22; i++) {
      partName += String.fromCharCode(rawData[i]);
    }
    partName = trimString(partName);

    // 解析 partNo
    for (int i = 23; i <= 42; i++) {
      partNo += String.fromCharCode(rawData[i]);
    }
    partNo = trimString(partNo);

    // 解析 serialNumber
    for (int i = 43; i <= 58; i++) {
      serialNumber += String.fromCharCode(rawData[i]);
    }
    serialNumber = trimString(serialNumber);

    // 解析 hardwareVersion
    for (int i = 59; i <= 62; i++) {
      hardwareVersion += String.fromCharCode(rawData[i]);
    }
    hardwareVersion = trimString(hardwareVersion);

    // 舊版本為空自串, 所以加一個N/A表示無 hardware version
    hardwareVersion = hardwareVersion.isEmpty ? 'N/A' : hardwareVersion;

    // 解析 firmwareVersion
    for (int i = 63; i <= 66; i++) {
      firmwareVersion += String.fromCharCode(rawData[i]);
    }
    firmwareVersion = trimString(firmwareVersion);

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
    coordinate = trimString(coordinate);

    // 解析 device MTU
    List<int> rawDeviceMTU = rawData.sublist(143, 145);
    ByteData rawDeviceMTUByteData =
        ByteData.sublistView(Uint8List.fromList(rawDeviceMTU));
    deviceMTU = rawDeviceMTUByteData.getInt16(0, Endian.little).toString();

    // 解析 bluetoothDelayTime
    List<int> rawBluetoothDelayTime = rawData.sublist(145, 147);
    ByteData rawBluetoothDelayTimeByteData =
        ByteData.sublistView(Uint8List.fromList(rawBluetoothDelayTime));
    bluetoothDelayTime =
        rawBluetoothDelayTimeByteData.getInt16(0, Endian.little).toString();

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

    return A1P8G0(
      partName: partName,
      partNo: partNo,
      partId: partId,
      serialNumber: serialNumber,
      firmwareVersion: firmwareVersion,
      hardwareVersion: hardwareVersion,
      mfgDate: mfgDate,
      coordinate: coordinate,
      nowDateTime: nowDateTime,
      deviceMTU: deviceMTU,
      bluetoothDelayTime: bluetoothDelayTime,
    );
  }

  A1P8G1 decodeA1P8G1(List<int> rawData) {
    String maxTemperatureC = '';
    String minTemperatureC = '';
    String maxTemperatureF = '';
    String minTemperatureF = '';
    String maxVoltage = '';
    String minVoltage = '';
    String maxVoltageRipple = '';
    String minVoltageRipple = '';
    String maxRFOutputPower = '';
    String minRFOutputPower = '';
    String ingressSetting2 = '';
    String ingressSetting3 = '';
    String ingressSetting4 = '';
    String forwardCEQIndex = '';
    String rfOutputLogInterval = '';
    String tgcCableLength = '';
    String splitOption = '';
    String pilotFrequencyMode = '';
    String agcMode = '';
    String alcMode = '';
    String firstChannelLoadingFrequency = '';
    String lastChannelLoadingFrequency = '';
    String firstChannelLoadingLevel = '';
    String lastChannelLoadingLevel = '';
    String pilotFrequency1 = '';
    String pilotFrequency2 = '';
    String pilotFrequency1AlarmState = '';
    String pilotFrequency2AlarmState = '';
    String rfOutputPilotLowFrequencyAlarmState = '';
    String rfOutputPilotHighFrequencyAlarmState = '';
    String temperatureAlarmState = '';
    String voltageAlarmState = '';
    String factoryDefaultNumber = '';
    String splitOptionAlarmState = '';
    String voltageRippleAlarmState = '';
    String outputPowerAlarmState = '';
    String dsVVA1 = '';
    String dsSlope1 = '';
    String dsVVA2 = '';
    String dsSlope2 = '';
    String usVCA1 = '';
    String usVCA3 = '';
    String usVCA4 = '';
    String usVCA2 = '';
    String eREQ = '';
    String dsVVA3 = '';
    String dsVVA4 = '';
    String dsVVA5 = '';
    String dsSlope3 = '';
    String dsSlope4 = '';
    // String usTGC = '';

    String location = '';
    String logInterval = '';

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

    // 解析 maxVoltageRipple
    List<int> rawMaxVoltageRipple = rawData.sublist(11, 13);
    ByteData rawMaxVoltageRippleByteData =
        ByteData.sublistView(Uint8List.fromList(rawMaxVoltageRipple));
    maxVoltageRipple =
        rawMaxVoltageRippleByteData.getInt16(0, Endian.little).toString();

    // 解析 minVoltageRipple
    List<int> rawMinVoltageRipple = rawData.sublist(13, 15);
    ByteData rawMinVoltageRippleByteData =
        ByteData.sublistView(Uint8List.fromList(rawMinVoltageRipple));
    minVoltageRipple =
        rawMinVoltageRippleByteData.getInt16(0, Endian.little).toString();

    // 解析 maxRFOutputTotalPower
    List<int> rawMaxRFOutputTotalPower = rawData.sublist(15, 17);
    ByteData rawMaxRFOutputTotalPowerByteData =
        ByteData.sublistView(Uint8List.fromList(rawMaxRFOutputTotalPower));
    maxRFOutputPower =
        (rawMaxRFOutputTotalPowerByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 minRFOutputTotalPower
    List<int> rawMinRFOutputTotalPower = rawData.sublist(17, 19);
    ByteData rawMinRFOutputTotalPowerByteData =
        ByteData.sublistView(Uint8List.fromList(rawMinRFOutputTotalPower));
    minRFOutputPower =
        (rawMinRFOutputTotalPowerByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 ingress setting 2
    ingressSetting2 = rawData[19].toString();

    // 解析 ingress setting 3
    ingressSetting3 = rawData[20].toString();

    // 解析 ingress setting 4
    ingressSetting4 = rawData[21].toString();

    // 解析 forwardCEQIndex
    forwardCEQIndex = rawData[22].toString();

    // 解析 RF Output log interval
    rfOutputLogInterval = rawData[23].toString();

    // 解析 tgcCableLength
    tgcCableLength = rawData[24].toString();

    // 解析 splitOption
    splitOption = rawData[25].toString();

    // 解析 pilotFrequencyMode
    pilotFrequencyMode = rawData[26].toString();

    // 解析 agcMode
    agcMode = rawData[27].toString();

    // 解析 alcMode
    alcMode = rawData[28].toString();

    // 解析 firstChannelLoadingFrequency
    List<int> rawFirstChannelLoadingFrequency = rawData.sublist(29, 31);
    ByteData rawFirstChannelLoadingFrequencyByteData = ByteData.sublistView(
        Uint8List.fromList(rawFirstChannelLoadingFrequency));
    firstChannelLoadingFrequency = rawFirstChannelLoadingFrequencyByteData
        .getInt16(0, Endian.little)
        .toString();

    // 解析 lastChannelLoadingFrequency
    List<int> rawLastChannelLoadingFrequency = rawData.sublist(31, 33);
    ByteData rawLastChannelLoadingFrequencyByteData = ByteData.sublistView(
        Uint8List.fromList(rawLastChannelLoadingFrequency));
    lastChannelLoadingFrequency = rawLastChannelLoadingFrequencyByteData
        .getInt16(0, Endian.little)
        .toString();

    // 解析 firstChannelLoadingLevel
    List<int> rawFirstChannelLoadingLevel = rawData.sublist(33, 35);
    ByteData rawFirstChannelLoadingLevelByteData =
        ByteData.sublistView(Uint8List.fromList(rawFirstChannelLoadingLevel));
    firstChannelLoadingLevel =
        (rawFirstChannelLoadingLevelByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 lastChannelLoadingLevel
    List<int> rawLastChannelLoadingLevel = rawData.sublist(35, 37);
    ByteData rawLastChannelLoadingLevelByteData =
        ByteData.sublistView(Uint8List.fromList(rawLastChannelLoadingLevel));
    lastChannelLoadingLevel =
        (rawLastChannelLoadingLevelByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 pilotFrequency1
    List<int> rawPilotFrequency1 = rawData.sublist(37, 39);
    ByteData rawPilotFrequency1ByteData =
        ByteData.sublistView(Uint8List.fromList(rawPilotFrequency1));
    pilotFrequency1 =
        rawPilotFrequency1ByteData.getInt16(0, Endian.little).toString();

    // 解析 pilotFrequency2
    List<int> rawPilotFrequency2 = rawData.sublist(39, 41);
    ByteData rawPilotFrequency2ByteData =
        ByteData.sublistView(Uint8List.fromList(rawPilotFrequency2));
    pilotFrequency2 =
        rawPilotFrequency2ByteData.getInt16(0, Endian.little).toString();

    // 解析 pilotFrequency1AlarmState
    pilotFrequency1AlarmState = rawData[41].toString();

    // 解析 pilotFrequency2AlarmState
    pilotFrequency2AlarmState = rawData[42].toString();

    // 解析 rfOutputPilotLowFrequencyAlarmState
    rfOutputPilotLowFrequencyAlarmState = rawData[43].toString();

    // 解析 rfOutputPilotHighFrequencyAlarmState
    rfOutputPilotHighFrequencyAlarmState = rawData[44].toString();

    // 解析 temperatureAlarmState
    temperatureAlarmState = rawData[45].toString();

    // 解析 voltageAlarmState
    voltageAlarmState = rawData[46].toString();

    // 解析 factoryDefaultNumber
    factoryDefaultNumber = rawData[50].toString();

    // 解析 splitOptionAlarmState
    splitOptionAlarmState = rawData[51].toString();

    // 解析 voltageRippleAlarmState
    voltageRippleAlarmState = rawData[52].toString();

    // 解析 outputPowerAlarmState
    outputPowerAlarmState = rawData[53].toString();

    // 使用 unicode 解析 location

    location =
        decodeUnicodeToString(Uint8List.fromList(rawData.sublist(54, 150)));

    // for (int i = 54; i < 150; i += 2) {
    //   Uint8List bytes = Uint8List.fromList([rawData[i], rawData[i + 1]]);

    //   // Extract the bytes and create the Unicode code point
    //   int lowerByte = bytes[0];
    //   int upperByte = bytes[1];
    //   int unicodeCodePoint = (upperByte << 8) | lowerByte;

    //   // Convert the Unicode code point to a string
    //   String chineseCharacter = String.fromCharCode(unicodeCodePoint);
    //   location += chineseCharacter;
    // }

    location = trimString(location);

    // 解析 log interval
    logInterval = rawData[150].toString();
    print('LOG interval: $logInterval');

    // 解析 inputAttenuation (0x94 DS VVA1 Set dB)
    List<int> rawInputAttenuation = rawData.sublist(151, 153);
    ByteData rawInputAttenuationByteData =
        ByteData.sublistView(Uint8List.fromList(rawInputAttenuation));
    dsVVA1 = (rawInputAttenuationByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

    // 解析 dsSlope1 (0x96 DS Slope1 Set dB)
    List<int> rawDSSlope1 = rawData.sublist(153, 155);
    ByteData rawDSSlope1ByteData =
        ByteData.sublistView(Uint8List.fromList(rawDSSlope1));
    dsSlope1 = (rawDSSlope1ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

    // 解析 dsVVA2 (0x98 DS VVA2 Set dB)
    List<int> rawDSVVA2 = rawData.sublist(155, 157);
    ByteData rawDSVVA2ByteData =
        ByteData.sublistView(Uint8List.fromList(rawDSVVA2));
    dsVVA2 =
        (rawDSVVA2ByteData.getInt16(0, Endian.little) / 10).toStringAsFixed(1);

    // 解析 dsSlope2 (0x9A DS Slope2 Set dB)
    List<int> rawDSSlope2 = rawData.sublist(157, 159);
    ByteData rawDSSlope2ByteData =
        ByteData.sublistView(Uint8List.fromList(rawDSSlope2));
    dsSlope2 = (rawDSSlope2ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

    // 解析 usVCA1 (0x9C US VCA1 Set dB)
    List<int> rawUSVCA1 = rawData.sublist(159, 161);
    ByteData rawUSVCA1ByteData =
        ByteData.sublistView(Uint8List.fromList(rawUSVCA1));
    usVCA1 =
        (rawUSVCA1ByteData.getInt16(0, Endian.little) / 10).toStringAsFixed(1);

    // 解析 eREQ (0x9E US E-REQ Set dB)
    List<int> rawEREQ = rawData.sublist(161, 163);
    ByteData rawEREQByteData =
        ByteData.sublistView(Uint8List.fromList(rawEREQ));
    eREQ = (rawEREQByteData.getInt16(0, Endian.little) / 10).toStringAsFixed(1);

    // 解析 dsVVA3 (0xA0 DS VVA3 Set dB)
    List<int> rawDSVVA3 = rawData.sublist(163, 165);
    ByteData rawDSVVA3ByteData =
        ByteData.sublistView(Uint8List.fromList(rawDSVVA3));
    dsVVA3 =
        (rawDSVVA3ByteData.getInt16(0, Endian.little) / 10).toStringAsFixed(1);

    // 解析 dsVVA4 (0xA2 DS VVA4 Set dB)
    List<int> rawDSVVA4 = rawData.sublist(165, 167);
    ByteData rawDSVVA4ByteData =
        ByteData.sublistView(Uint8List.fromList(rawDSVVA4));
    dsVVA4 =
        (rawDSVVA4ByteData.getInt16(0, Endian.little) / 10).toStringAsFixed(1);

    // 解析 usVCA2 (0xA4 US VCA2 Set dB)
    List<int> rawUSVCA2 = rawData.sublist(167, 169);
    ByteData rawUSVCA2ByteData =
        ByteData.sublistView(Uint8List.fromList(rawUSVCA2));
    usVCA2 =
        (rawUSVCA2ByteData.getInt16(0, Endian.little) / 10).toStringAsFixed(1);

    // 解析 usVCA3 (0xA6 US VCA3 Set dB)
    List<int> rawUSVCA3 = rawData.sublist(169, 171);
    ByteData rawUSVCA3ByteData =
        ByteData.sublistView(Uint8List.fromList(rawUSVCA3));
    usVCA3 =
        (rawUSVCA3ByteData.getInt16(0, Endian.little) / 10).toStringAsFixed(1);

    // 解析 usVCA4 (0xA8 US VCA4 Set dB)
    List<int> rawUSVCA4 = rawData.sublist(171, 173);
    ByteData rawUSVCA4ByteData =
        ByteData.sublistView(Uint8List.fromList(rawUSVCA4));
    usVCA4 =
        (rawUSVCA4ByteData.getInt16(0, Endian.little) / 10).toStringAsFixed(1);

    // 解析 dsVVA5 (0xAA DS VVA5 Set dB)
    List<int> rawDSVVA5 = rawData.sublist(173, 175);
    ByteData rawDSVVA5ByteData =
        ByteData.sublistView(Uint8List.fromList(rawDSVVA5));
    dsVVA5 =
        (rawDSVVA5ByteData.getInt16(0, Endian.little) / 10).toStringAsFixed(1);

    // 解析 dsSlope3 (0xAC DS Slope3 Set dB)
    List<int> rawDSSlope3 = rawData.sublist(175, 177);
    ByteData rawDSSlope3ByteData =
        ByteData.sublistView(Uint8List.fromList(rawDSSlope3));
    dsSlope3 = (rawDSSlope3ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

    // 解析 dsSlope4 (0xAC DS Slope4 Set dB)
    List<int> rawDSSlope4 = rawData.sublist(177, 179);
    ByteData rawDSSlope4ByteData =
        ByteData.sublistView(Uint8List.fromList(rawDSSlope4));
    dsSlope4 = (rawDSSlope4ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

    return A1P8G1(
      maxTemperatureC: maxTemperatureC,
      minTemperatureC: minTemperatureC,
      maxTemperatureF: maxTemperatureF,
      minTemperatureF: minTemperatureF,
      maxVoltage: maxVoltage,
      minVoltage: minVoltage,
      maxVoltageRipple: maxVoltageRipple,
      minVoltageRipple: minVoltageRipple,
      maxRFOutputPower: maxRFOutputPower,
      minRFOutputPower: minRFOutputPower,
      ingressSetting2: ingressSetting2,
      ingressSetting3: ingressSetting3,
      ingressSetting4: ingressSetting4,
      forwardCEQIndex: forwardCEQIndex,
      rfOutputLogInterval: rfOutputLogInterval,
      tgcCableLength: tgcCableLength,
      splitOption: splitOption,
      pilotFrequencyMode: pilotFrequencyMode,
      agcMode: agcMode,
      alcMode: alcMode,
      firstChannelLoadingFrequency: firstChannelLoadingFrequency,
      lastChannelLoadingFrequency: lastChannelLoadingFrequency,
      firstChannelLoadingLevel: firstChannelLoadingLevel,
      lastChannelLoadingLevel: lastChannelLoadingLevel,
      pilotFrequency1: pilotFrequency1,
      pilotFrequency2: pilotFrequency2,
      pilotFrequency1AlarmState: pilotFrequency1AlarmState,
      pilotFrequency2AlarmState: pilotFrequency2AlarmState,
      rfOutputPilotLowFrequencyAlarmState: rfOutputPilotLowFrequencyAlarmState,
      rfOutputPilotHighFrequencyAlarmState:
          rfOutputPilotHighFrequencyAlarmState,
      temperatureAlarmState: temperatureAlarmState,
      voltageAlarmState: voltageAlarmState,
      factoryDefaultNumber: factoryDefaultNumber,
      splitOptionAlarmState: splitOptionAlarmState,
      voltageRippleAlarmState: voltageRippleAlarmState,
      outputPowerAlarmState: outputPowerAlarmState,
      dsVVA1: dsVVA1,
      dsSlope1: dsSlope1,
      dsVVA2: dsVVA2,
      dsSlope2: dsSlope2,
      usVCA1: usVCA1,
      usVCA3: usVCA3,
      usVCA4: usVCA4,
      usVCA2: usVCA2,
      eREQ: eREQ,
      dsVVA3: dsVVA3,
      dsVVA4: dsVVA4,
      dsVVA5: dsVVA5,
      dsSlope3: dsSlope3,
      dsSlope4: dsSlope4,
      // usTGC: usTGC,
      location: location,
      logInterval: logInterval,
    );
  }

  A1P8G2 decodeA1P8G2(List<int> rawData) {
    String currentTemperatureC = '';
    String currentTemperatureF = '';
    String currentVoltage = '';
    String currentVoltageRipple = '';
    String currentRFInputPower = '';
    String currentRFOutputPower = '';
    String currentDSVVA1;
    String currentDSSlope1;
    String currentWorkingMode = '';
    String currentDetectedSplitOption = '';
    String rfOutputOperatingSlope = '';
    String manualModePilot1RFOutputPower = '';
    String manualModePilot2RFOutputPower = '';
    String currentRFInputPower1p8G = '';
    String rfOutputLowChannelPower = '';
    String rfOutputHighChannelPower = '';
    String pilot1RFChannelFrequency = '';
    String pilot2RFChannelFrequency = '';
    Alarm unitStatusAlarmSeverity = Alarm.medium;
    Alarm rfInputPilotLowFrequencyAlarmSeverity = Alarm.medium;
    Alarm rfInputPilotHighFrequencyAlarmSeverity = Alarm.medium;
    Alarm rfOutputPilotLowFrequencyAlarmSeverity = Alarm.medium;
    Alarm rfOutputPilotHighFrequencyAlarmSeverity = Alarm.medium;
    Alarm temperatureAlarmSeverity = Alarm.medium;
    Alarm voltageAlarmSeverity = Alarm.medium;
    Alarm splitOptionAlarmSeverity = Alarm.medium;
    Alarm voltageRippleAlarmSeverity = Alarm.medium;
    Alarm outputPowerAlarmSeverity = Alarm.medium;
    String currentForwardCEQIndex = '';

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

    // 解析 currentRFInputPower
    List<int> rawCurrentRFInputPower = rawData.sublist(18, 20);
    ByteData rawCurrentRFInputPowerByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentRFInputPower));

    currentRFInputPower =
        (rawCurrentRFInputPowerByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 currentRFOutputPower
    List<int> rawCurrentRFOutputPower = rawData.sublist(20, 22);
    ByteData rawCurrentRFOutputPowerByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentRFOutputPower));

    currentRFOutputPower =
        (rawCurrentRFOutputPowerByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 currentDSVVA1
    List<int> rawCurrentDSVVA1 = rawData.sublist(34, 36);
    ByteData rawCurrentDSVVA1ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentDSVVA1));

    currentDSVVA1 = (rawCurrentDSVVA1ByteData.getInt16(0, Endian.little) / 10)
        .toStringAsFixed(1);

    // 解析 currentDSSlope1
    List<int> rawCurrentDSSlope1 = rawData.sublist(36, 38);
    ByteData rawCurrentDSSlope1ByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentDSSlope1));

    currentDSSlope1 =
        (rawCurrentDSSlope1ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 currentWorkingMode
    currentWorkingMode = rawData[70].toString();

    // 解析 currentDetectedSplitOption
    currentDetectedSplitOption = rawData[71].toString();

    // 解析 currentRFInputPower1p8G
    List<int> rawCurrentRFInputPower1p8G = rawData.sublist(76, 78);
    ByteData rawCurrentRFInputPower1p8GByteData =
        ByteData.sublistView(Uint8List.fromList(rawCurrentRFInputPower1p8G));

    currentRFInputPower1p8G =
        (rawCurrentRFInputPower1p8GByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 rfOutputLowChannelPower
    List<int> rawRFOutputLowChannelPower = rawData.sublist(92, 94);
    ByteData rawRFOutputLowChannelPowerByteData =
        ByteData.sublistView(Uint8List.fromList(rawRFOutputLowChannelPower));

    rfOutputLowChannelPower =
        (rawRFOutputLowChannelPowerByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 rfOutputHighChannelPower
    List<int> rawRFOutputHighChannelPower = rawData.sublist(94, 96);
    ByteData rawRFOutputHighChannelPowerByteData =
        ByteData.sublistView(Uint8List.fromList(rawRFOutputHighChannelPower));

    rfOutputHighChannelPower =
        (rawRFOutputHighChannelPowerByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 rfOutputOperatingSlope
    // [84, 85] for debug
    // [96, 97] now does not work
    List<int> rawRFOutputOperatingSlope = rawData.sublist(84, 86);
    ByteData rawRFOutputOperatingSlopeByteData =
        ByteData.sublistView(Uint8List.fromList(rawRFOutputOperatingSlope));

    rfOutputOperatingSlope =
        (rawRFOutputOperatingSlopeByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 manualModePilot1RFOutputPower
    List<int> rawManualModePilot1RFOutputPower = rawData.sublist(98, 100);
    ByteData rawManualModePilot1RFOutputPowerByteData = ByteData.sublistView(
        Uint8List.fromList(rawManualModePilot1RFOutputPower));

    manualModePilot1RFOutputPower =
        (rawManualModePilot1RFOutputPowerByteData.getInt16(0, Endian.little) /
                10)
            .toStringAsFixed(1);

    // 解析 manualModePilot2RFOutputPower
    List<int> rawManualModePilot2RFOutputPower = rawData.sublist(100, 102);
    ByteData rawManualModePilot2RFOutputPowerByteData = ByteData.sublistView(
        Uint8List.fromList(rawManualModePilot2RFOutputPower));

    manualModePilot2RFOutputPower =
        (rawManualModePilot2RFOutputPowerByteData.getInt16(0, Endian.little) /
                10)
            .toStringAsFixed(1);

    // 解析 pilot1RFChannelFrequency
    List<int> rawPilot1RFChannelFrequency = rawData.sublist(102, 104);
    ByteData rawPilot1RFChannelFrequencyByteData =
        ByteData.sublistView(Uint8List.fromList(rawPilot1RFChannelFrequency));

    pilot1RFChannelFrequency = rawPilot1RFChannelFrequencyByteData
        .getInt16(0, Endian.little)
        .toString();

    // 解析 pilot2RFChannelFrequency
    List<int> rawPilot2RFChannelFrequency = rawData.sublist(104, 106);
    ByteData rawPilot2RFChannelFrequencyByteData =
        ByteData.sublistView(Uint8List.fromList(rawPilot2RFChannelFrequency));

    pilot2RFChannelFrequency = rawPilot2RFChannelFrequencyByteData
        .getInt16(0, Endian.little)
        .toString();

    // 解析 rfInputPilotLowFrequencyAlarmSeverity
    int rfInputPilotLowFrequencyStatus = rawData[124];
    rfInputPilotLowFrequencyAlarmSeverity =
        rfInputPilotLowFrequencyStatus == 1 ? Alarm.danger : Alarm.success;

    // 解析 rfInputPilotHighFrequencyAlarmSeverity
    int rfInputPilotHighFrequencyStatus = rawData[125];
    rfInputPilotHighFrequencyAlarmSeverity =
        rfInputPilotHighFrequencyStatus == 1 ? Alarm.danger : Alarm.success;

    // 解析 rfOutputPilotLowFrequencyAlarmSeverity
    int rfOutputPilotLowFrequencyStatus = rawData[126];
    rfOutputPilotLowFrequencyAlarmSeverity =
        rfOutputPilotLowFrequencyStatus == 1 ? Alarm.danger : Alarm.success;

    // 解析 rfOutputPilotHighFrequencyAlarmSeverity
    int rfOutputPilotHighFrequencyStatus = rawData[127];
    rfOutputPilotHighFrequencyAlarmSeverity =
        rfOutputPilotHighFrequencyStatus == 1 ? Alarm.danger : Alarm.success;

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

    // 解析 outputPowerAlarmSeverity
    int outputPowerStatus = rawData[136];
    outputPowerAlarmSeverity =
        outputPowerStatus == 1 ? Alarm.danger : Alarm.success;

    // 解析 current Forward CEQ Index
    currentForwardCEQIndex = rawData[137].toString();

    return A1P8G2(
      currentTemperatureC: currentTemperatureC,
      currentTemperatureF: currentTemperatureF,
      currentVoltage: currentVoltage,
      currentVoltageRipple: currentVoltageRipple,
      currentRFInputPower: currentRFInputPower,
      currentRFOutputPower: currentRFOutputPower,
      currentDSVVA1: currentDSVVA1,
      currentDSSlope1: currentDSSlope1,
      currentWorkingMode: currentWorkingMode,
      currentDetectedSplitOption: currentDetectedSplitOption,
      currentRFInputPower1p8G: currentRFInputPower1p8G,
      rfOutputOperatingSlope: rfOutputOperatingSlope,
      manualModePilot1RFOutputPower: manualModePilot1RFOutputPower,
      manualModePilot2RFOutputPower: manualModePilot2RFOutputPower,
      rfOutputLowChannelPower: rfOutputLowChannelPower,
      rfOutputHighChannelPower: rfOutputHighChannelPower,
      pilot1RFChannelFrequency: pilot1RFChannelFrequency,
      pilot2RFChannelFrequency: pilot2RFChannelFrequency,
      unitStatusAlarmSeverity: unitStatusAlarmSeverity.name,
      rfInputPilotLowFrequencyAlarmSeverity:
          rfInputPilotLowFrequencyAlarmSeverity.name,
      rfInputPilotHighFrequencyAlarmSeverity:
          rfInputPilotHighFrequencyAlarmSeverity.name,
      rfOutputPilotLowFrequencyAlarmSeverity:
          rfOutputPilotLowFrequencyAlarmSeverity.name,
      rfOutputPilotHighFrequencyAlarmSeverity:
          rfOutputPilotHighFrequencyAlarmSeverity.name,
      temperatureAlarmSeverity: temperatureAlarmSeverity.name,
      voltageAlarmSeverity: voltageAlarmSeverity.name,
      splitOptionAlarmSeverity: splitOptionAlarmSeverity.name,
      voltageRippleAlarmSeverity: voltageRippleAlarmSeverity.name,
      outputPowerAlarmSeverity: outputPowerAlarmSeverity.name,
      currentForwardCEQIndex: currentForwardCEQIndex,
    );
  }

  A1P8GUserAttribute decodeA1P8GUserAttribute(List<int> rawData) {
    String technicianID = '';
    String inputSignalLevel = '';
    String inputAttenuation = '';
    String inputEqualizer = '';
    String cascadePosition = '';
    String deviceName = '';
    String deviceNote = '';

    List<List<int>> separatedGroups = [];
    List<int> currentGroup = [];

    List rawDataContent = rawData.sublist(3, 1027);

    if (rawDataContent.every((element) => element == rawDataContent[0])) {
      return A1P8GUserAttribute(
        technicianID: technicianID,
        inputSignalLevel: inputSignalLevel,
        inputAttenuation: inputAttenuation,
        inputEqualizer: inputEqualizer,
        cascadePosition: cascadePosition,
        deviceName: deviceName,
        deviceNote: deviceNote,
      );
    } else {
      // 因為前三個 byte 為 header, 後兩個 byte 為 crc, 所以迴圈從有內容的部分迭代
      for (int i = 0; i < rawDataContent.length; i += 2) {
        if (rawDataContent[i] == 0x00 && rawDataContent[i + 1] == 0x00) {
          // ASCII code for ','
          // If we hit a comma, save the current group if it's not empty
          separatedGroups.add(currentGroup);
          currentGroup = []; // Clear the current group for the next set
        } else {
          // Add non-comma ASCII codes to the current group
          currentGroup.addAll([rawDataContent[i], rawDataContent[i + 1]]);
        }
      }

      // After the loop, add any remaining currentGroup
      if (currentGroup.isNotEmpty) {
        separatedGroups.add(currentGroup);
      }

      // Print the separated groups
      // for (var group in separatedGroups) {
      //   print(group);
      // }

      for (int i = 0; i < separatedGroups.length; i++) {
        if (i == 0) {
          technicianID =
              decodeUnicodeToString(Uint8List.fromList(separatedGroups[i]));
          technicianID = trimString(technicianID);
        } else if (i == 1) {
          inputSignalLevel =
              decodeUnicodeToString(Uint8List.fromList(separatedGroups[i]));
          inputSignalLevel = trimString(inputSignalLevel);
        } else if (i == 2) {
          inputAttenuation =
              decodeUnicodeToString(Uint8List.fromList(separatedGroups[i]));
          inputAttenuation = trimString(inputAttenuation);
        } else if (i == 3) {
          inputEqualizer =
              decodeUnicodeToString(Uint8List.fromList(separatedGroups[i]));
          inputEqualizer = trimString(inputEqualizer);
        } else if (i == 4) {
          cascadePosition =
              decodeUnicodeToString(Uint8List.fromList(separatedGroups[i]));
          cascadePosition = trimString(cascadePosition);
        } else if (i == 5) {
          deviceName =
              decodeUnicodeToString(Uint8List.fromList(separatedGroups[i]));
          deviceName = trimString(deviceName);
        } else if (i == 6) {
          deviceNote =
              decodeUnicodeToString(Uint8List.fromList(separatedGroups[i]));
          deviceNote = trimString(deviceNote);
        }
      }

      return A1P8GUserAttribute(
        technicianID: technicianID,
        inputSignalLevel: inputSignalLevel,
        inputAttenuation: inputAttenuation,
        inputEqualizer: inputEqualizer,
        cascadePosition: cascadePosition,
        deviceName: deviceName,
        deviceNote: deviceNote,
      );
    }
  }

  // A1P8GAlarm decodeAlarmSeverity(List<int> rawData) {
  //   // 給 定期更新 information page 的 alarm 用
  //   Alarm unitStatusAlarmSeverity = Alarm.medium;
  //   Alarm temperatureAlarmSeverity = Alarm.medium;
  //   Alarm powerAlarmSeverity = Alarm.medium;

  //   int unitStatus = rawData[3];
  //   unitStatusAlarmSeverity = unitStatus == 1 ? Alarm.success : Alarm.danger;

  //   int temperatureStatus = rawData[128];
  //   temperatureAlarmSeverity =
  //       temperatureStatus == 1 ? Alarm.danger : Alarm.success;

  //   int powerStatus = rawData[129];
  //   powerAlarmSeverity = powerStatus == 1 ? Alarm.danger : Alarm.success;

  //   A1P8GAlarm a1p8gAlarm = A1P8GAlarm(
  //     unitStatusAlarmSeverity: unitStatusAlarmSeverity.name,
  //     temperatureAlarmSeverity: temperatureAlarmSeverity.name,
  //     powerAlarmSeverity: powerAlarmSeverity.name,
  //   );

  //   return a1p8gAlarm;
  // }

  A1P8GLogStatistic getA1p8GLogStatistics(List<Log1p8G> log1p8Gs) {
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

      // get min voltage
      double historicalMinVoltage = log1p8Gs
          .map((log1p8G) => log1p8G.voltage)
          .reduce((min, current) => min < current ? min : current);

      // get max voltage
      double historicalMaxVoltage = log1p8Gs
          .map((log1p8G) => log1p8G.voltage)
          .reduce((max, current) => max > current ? max : current);

      // get min voltage
      int historicalMinVoltageRipple = log1p8Gs
          .map((log1p8G) => log1p8G.voltageRipple)
          .reduce((min, current) => min < current ? min : current);

      // get max voltage
      int historicalMaxVoltageRipple = log1p8Gs
          .map((log1p8G) => log1p8G.voltageRipple)
          .reduce((max, current) => max > current ? max : current);

      String historicalMinTemperatureC = historicalMinTemperature.toString();

      String historicalMaxTemperatureC = historicalMaxTemperature.toString();

      String historicalMinTemperatureF = unitConverter
          .converCelciusToFahrenheit(historicalMinTemperature)
          .toStringAsFixed(1);

      String historicalMaxTemperatureF = unitConverter
          .converCelciusToFahrenheit(historicalMaxTemperature)
          .toStringAsFixed(1);

      String historicalMinVoltageStr = historicalMinVoltage.toStringAsFixed(1);
      String historicalMaxVoltageStr = historicalMaxVoltage.toStringAsFixed(1);
      String historicalMinVoltageRippleStr =
          historicalMinVoltageRipple.toString();
      String historicalMaxVoltageRippleStr =
          historicalMaxVoltageRipple.toString();

      A1P8GLogStatistic a1p8gLogStatistic = A1P8GLogStatistic(
        historicalMinTemperatureC: historicalMinTemperatureC,
        historicalMaxTemperatureC: historicalMaxTemperatureC,
        historicalMinTemperatureF: historicalMinTemperatureF,
        historicalMaxTemperatureF: historicalMaxTemperatureF,
        historicalMinVoltage: historicalMinVoltageStr,
        historicalMaxVoltage: historicalMaxVoltageStr,
        historicalMinVoltageRipple: historicalMinVoltageRippleStr,
        historicalMaxVoltageRipple: historicalMaxVoltageRippleStr,
      );

      return a1p8gLogStatistic;
    } else {
      A1P8GLogStatistic a1p8gLogStatistic = const A1P8GLogStatistic(
        historicalMinTemperatureC: '',
        historicalMaxTemperatureC: '',
        historicalMinTemperatureF: '',
        historicalMaxTemperatureF: '',
        historicalMinVoltage: '',
        historicalMaxVoltage: '',
        historicalMinVoltageRipple: '',
        historicalMaxVoltageRipple: '',
      );
      return a1p8gLogStatistic;
    }
  }

  List<RFInOut> parse1P8GRFInOut(List<int> rawData) {
    List<RFInOut> rfInOuts = [];
    rawData.removeRange(rawData.length - 2, rawData.length);
    rawData.removeRange(0, 3);

    for (var i = 0; i < 256; i++) {
      int frequency = 261 + 6 * i;
      // double outputValue = rfOutputs[frequency]!;
      // double inputValue = rfInputs[frequency]!;

      // 解析 input
      List<int> rawInput = rawData.sublist(i * 2, i * 2 + 2);
      ByteData rawInputByteData =
          ByteData.sublistView(Uint8List.fromList(rawInput));
      double input = rawInputByteData.getInt16(0, Endian.little) / 10;
      // double input = inputValue;

      // 解析 output
      List<int> rawOutput = rawData.sublist(i * 2 + 512, i * 2 + 2 + 512);
      ByteData rawOutputByteData =
          ByteData.sublistView(Uint8List.fromList(rawOutput));
      double output = rawOutputByteData.getInt16(0, Endian.little) / 10;

      // double output = outputValue;

      rfInOuts.add(RFInOut(
        frequency: frequency,
        input: input,
        output: output,
      ));
    }

    return rfInOuts;
  }

  // DFU = 6 (85/105) 時使用
  // RF In 有 26 筆, RF Out 有 26 筆
  List<RFInOut> parse1P8GRFInOutForDFU6(List<int> rawData) {
    List<RFInOut> rfInOuts = [];
    rawData.removeRange(rawData.length - 2, rawData.length);
    rawData.removeRange(0, 3);

    for (var i = 0; i < 26; i++) {
      int frequency = 105 + 6 * i;
      // double outputValue = rfOutputs[frequency]!;
      // double inputValue = rfInputs[frequency]!;

      // 解析 input
      List<int> rawInput = rawData.sublist(i * 2, i * 2 + 2);
      ByteData rawInputByteData =
          ByteData.sublistView(Uint8List.fromList(rawInput));
      double input = rawInputByteData.getInt16(0, Endian.little) / 10;
      // double input = inputValue;

      // 解析 output
      List<int> rawOutput = rawData.sublist(i * 2 + 52, i * 2 + 2 + 52);
      ByteData rawOutputByteData =
          ByteData.sublistView(Uint8List.fromList(rawOutput));
      double output = rawOutputByteData.getInt16(0, Endian.little) / 10;

      // double output = outputValue;

      rfInOuts.add(RFInOut(
        frequency: frequency,
        input: input,
        output: output,
      ));
    }

    return rfInOuts;
  }

  // DFU != 6 (85/105) 時使用
  // RF Log 最多有 30 筆, 每筆 log 有 546 bytes
  List<RFOutputLog> parse1P8GRFOutputLogs(List<int> rawData) {
    List<RFOutputLog> rfOutputLogs = [];
    int step = 546; // 每筆 log 的長度

    rawData.removeRange(rawData.length - 2, rawData.length);
    rawData.removeRange(0, 3);

    for (int i = 0; i < 30; i++) {
      List<RFOut> rfOuts = [];

      // 546 * 15 = 8190, 8190 和 8191 留空, 共 2 bytes
      int oi = i >= 15 ? 2 : 0;

      // 如果檢查到有一筆log 的內容全部是 255, 則視為沒有更多log資料了
      bool isEmptyLog = rawData
          .sublist(i * step, (i + 1) * step)
          .every((element) => element == 255);
      if (isEmptyLog) {
        break;
      }

      List<int> rawYear = rawData.sublist(i * step + oi, i * step + 2 + oi);
      ByteData rawYearByteData =
          ByteData.sublistView(Uint8List.fromList(rawYear));
      String strYear = rawYearByteData.getInt16(0, Endian.little).toString();

      String strMonth = rawData[i * step + 2 + oi].toString().padLeft(2, '0');
      String strDay = rawData[i * step + 3 + oi].toString().padLeft(2, '0');
      String strHour = rawData[i * step + 4 + oi].toString().padLeft(2, '0');
      String strMinute = rawData[i * step + 5 + oi].toString().padLeft(2, '0');

      final DateTime dateTime =
          DateTime.parse('$strYear-$strMonth-$strDay $strHour:$strMinute:00');

      // String timeStamp =
      //     DateFormat('yyyy_MM_dd_HH_mm_ss').format(dateTime).toString();

      // print('timeStamp: $timeStamp ');

      for (int j = 0; j < 256; j++) {
        int frequency = 261 + 6 * j;
        // 解析 rfOuts
        int rfIndex = (i * step + 6 + oi) + j * 2;
        // print('$rfIndex, ${rawData[rfIndex]}, ${rawData[rfIndex + 1]}');
        List<int> rawOutput = rawData.sublist(rfIndex, rfIndex + 2);
        ByteData rawOutputByteData =
            ByteData.sublistView(Uint8List.fromList(rawOutput));
        double output = rawOutputByteData.getInt16(0, Endian.little) / 10;

        rfOuts.add(RFOut(
          frequency: frequency,
          output: output,
        ));
      }

      rfOutputLogs.add(RFOutputLog(
        dateTime: dateTime,
        rfOuts: rfOuts,
      ));
    }

    return rfOutputLogs;
  }

  // DFU = 6 (85/105) 時使用
  // RF Log 最多有 27 筆, 每筆 log 有 606 bytes
  List<RFOutputLog> parse1P8GRFOutputLogsForDFU6(List<int> rawData) {
    List<RFOutputLog> rfOutputLogs = [];
    int step = 606; // 每筆 log 的長度

    rawData.removeRange(rawData.length - 2, rawData.length);
    rawData.removeRange(0, 3);

    for (int i = 0; i < 27; i++) {
      List<RFOut> rfOuts = [];

      // 如果檢查到有一筆log 的內容全部是 255, 則視為沒有更多log資料了
      bool isEmptyLog = rawData
          .sublist(i * step, (i + 1) * step)
          .every((element) => element == 255);
      if (isEmptyLog) {
        break;
      }

      List<int> rawYear = rawData.sublist(i * step, i * step + 2);
      ByteData rawYearByteData =
          ByteData.sublistView(Uint8List.fromList(rawYear));
      String strYear = rawYearByteData.getInt16(0, Endian.little).toString();

      String strMonth = rawData[i * step + 2].toString().padLeft(2, '0');
      String strDay = rawData[i * step + 3].toString().padLeft(2, '0');
      String strHour = rawData[i * step + 4].toString().padLeft(2, '0');
      String strMinute = rawData[i * step + 5].toString().padLeft(2, '0');

      final DateTime dateTime =
          DateTime.parse('$strYear-$strMonth-$strDay $strHour:$strMinute:00');

      // String timeStamp =
      //     DateFormat('yyyy_MM_dd_HH_mm_ss').format(dateTime).toString();

      // print('timeStamp: $timeStamp ');

      for (int j = 0; j < 256; j++) {
        int frequency = 105 + 6 * j;
        // 解析 rfOuts
        int rfIndex = (i * step + 6) + j * 2;
        // print('$rfIndex, ${rawData[rfIndex]}, ${rawData[rfIndex + 1]}');
        List<int> rawOutput = rawData.sublist(rfIndex, rfIndex + 2);
        ByteData rawOutputByteData =
            ByteData.sublistView(Uint8List.fromList(rawOutput));
        double output = rawOutputByteData.getInt16(0, Endian.little) / 10;

        rfOuts.add(RFOut(
          frequency: frequency,
          output: output,
        ));
      }

      rfOutputLogs.add(RFOutputLog(
        dateTime: dateTime,
        rfOuts: rfOuts,
      ));
    }

    return rfOutputLogs;
  }

  A1P8GRFOutputPowerStatistic getA1p8GRFOutputPowerStatistic(
      List<RFInOut> rfInOuts) {
    if (rfInOuts.isNotEmpty) {
      // get min rf output power
      double historicalMinRFOutputPower = rfInOuts
          .map((rfInOut) => rfInOut.output)
          .reduce((min, current) => min < current ? min : current);

      // get max rf output power
      double historicalMaxRFOutputPower = rfInOuts
          .map((rfInOut) => rfInOut.output)
          .reduce((max, current) => max > current ? max : current);

      String historicalMinRFOutputPowerStr =
          historicalMinRFOutputPower.toStringAsFixed(1);

      String historicalMaxRFOutputPowerStr =
          historicalMaxRFOutputPower.toStringAsFixed(1);

      A1P8GRFOutputPowerStatistic a1p8gRFOutputPowerStatistic =
          A1P8GRFOutputPowerStatistic(
        historicalMinRFOutputPower: historicalMinRFOutputPowerStr,
        historicalMaxRFOutputPower: historicalMaxRFOutputPowerStr,
      );

      return a1p8gRFOutputPowerStatistic;
    } else {
      A1P8GRFOutputPowerStatistic a1p8gRFOutputPowerStatistic =
          const A1P8GRFOutputPowerStatistic(
        historicalMinRFOutputPower: '',
        historicalMaxRFOutputPower: '',
      );

      return a1p8gRFOutputPowerStatistic;
    }
  }

  List<Log1p8G> parse1P8GLog(List<int> rawData) {
    List<Log1p8G> logChunks = [];
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

      List<int> rawVoltage = rawData.sublist(i * 16 + 8, i * 16 + 10);
      ByteData rawVoltageByteData =
          ByteData.sublistView(Uint8List.fromList(rawVoltage));
      double voltage = rawVoltageByteData.getInt16(0, Endian.little) / 10;

      List<int> rawRFOutputLowPilot = rawData.sublist(i * 16 + 10, i * 16 + 12);
      ByteData rawRFOutputLowPilotByteData =
          ByteData.sublistView(Uint8List.fromList(rawRFOutputLowPilot));
      double rfOutputLowPilot =
          rawRFOutputLowPilotByteData.getInt16(0, Endian.little) / 10;

      List<int> rawRFOutputHighPilot =
          rawData.sublist(i * 16 + 12, i * 16 + 14);
      ByteData rawRFOutputHighPilotByteData =
          ByteData.sublistView(Uint8List.fromList(rawRFOutputHighPilot));
      double rfOutputHighPilot =
          rawRFOutputHighPilotByteData.getInt16(0, Endian.little) / 10;

      List<int> rawVoltageRipple = rawData.sublist(i * 16 + 14, i * 16 + 16);
      ByteData rawVoltageRippleByteData =
          ByteData.sublistView(Uint8List.fromList(rawVoltageRipple));
      int voltageRipple = rawVoltageRippleByteData.getInt16(0, Endian.little);

      final DateTime dateTime =
          DateTime.parse('$strYear-$strMonth-$strDay $strHour:$strMinute:00');

      logChunks.add(Log1p8G(
        dateTime: dateTime,
        temperature: temperature,
        voltage: voltage,
        rfOutputLowPilot: rfOutputLowPilot,
        rfOutputHighPilot: rfOutputHighPilot,
        voltageRipple: voltageRipple,
      ));
    }

    return logChunks;
  }

  List<Event1p8G> parse1p8GEvent(List<int> rawData) {
    List<Event1p8G> event1p8Gs = [];

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

      event1p8Gs.add(Event1p8G(
        dateTime: dateTime,
        code: code,
        parameter: parameter,
      ));
    }

    return event1p8Gs;
  }

  Future<dynamic> export1p8GRFInOuts({
    required String code,
    required Map<String, String> attributeData,
    required Map<String, String> regulationData,
    required List<Map<String, String>> controlData,
    // required String coordinate,
    // required String location,
    required List<RFInOut> rfInOuts,
  }) async {
    Excel excel = Excel.createExcel();

    excel.rename('Sheet1', 'User Information');
    Sheet userInformationSheet = excel['User Information'];
    Sheet rfInSheet = excel['Input Levels'];
    Sheet rfOutSheet = excel['Output Levels'];

    userInformationSheet.insertRowIterables(
        [TextCellValue('Code Number'), TextCellValue(code)], 0);

    // 空兩行後再開始寫入 attribute data
    List<String> attributeDataKeys = attributeData.keys.toList();
    for (int i = 0; i < attributeDataKeys.length; i++) {
      String key = attributeDataKeys[i];
      String value = attributeData[key] ?? '';

      userInformationSheet.insertRowIterables(
        [
          TextCellValue(key),
          TextCellValue(value),
        ],
        i + 3,
      );
    }

    // 空兩行後再開始寫入 regulation data
    List<String> regulationDataKeys = regulationData.keys.toList();
    for (int i = 0; i < regulationDataKeys.length; i++) {
      String key = regulationDataKeys[i];
      String value = regulationData[key] ?? '';

      userInformationSheet.insertRowIterables(
        [
          TextCellValue(key),
          TextCellValue(value),
        ],
        i + attributeDataKeys.length + 4,
      );
    }

    // 空兩行後再開始寫入 control data
    for (int i = 0; i < controlData.length; i++) {
      MapEntry entry = controlData[i].entries.first;
      userInformationSheet.insertRowIterables(
        [
          TextCellValue(entry.key),
          TextCellValue(entry.value),
        ],
        i + attributeDataKeys.length + regulationDataKeys.length + 5,
      );
    }
    List<TextCellValue> rfInOutHeader = [
      TextCellValue('Frequency (MHz)'),
      TextCellValue('Level (dBmV)'),
    ];

    rfInSheet.insertRowIterables(rfInOutHeader, 0);
    for (int i = 0; i < rfInOuts.length; i++) {
      String frequency = rfInOuts[i].frequency.toString();
      String level = rfInOuts[i].input.toStringAsFixed(1);

      List<TextCellValue> row = [
        TextCellValue(frequency),
        TextCellValue(level),
      ];
      rfInSheet.insertRowIterables(row, i + 1);
    }

    rfOutSheet.insertRowIterables(rfInOutHeader, 0);
    for (int i = 0; i < rfInOuts.length; i++) {
      String frequency = rfInOuts[i].frequency.toString();
      String level = rfInOuts[i].output.toStringAsFixed(1);

      List<TextCellValue> row = [
        TextCellValue(frequency),
        TextCellValue(level),
      ];
      rfOutSheet.insertRowIterables(row, i + 1);
    }

    var fileBytes = excel.save();

    String timeStamp =
        DateFormat('yyyy_MM_dd_HH_mm_ss').format(DateTime.now()).toString();
    String filename = 'rf_levels_$timeStamp';
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
    } else if (Platform.isWindows) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      Directory appDocDirFolder = Directory('${appDocDir.path}/ACI+/');
      bool isExist = await appDocDirFolder.exists();
      if (!isExist) {
        await appDocDirFolder.create(recursive: true);
      }

      String appDocPath = appDocDirFolder.path;
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

  Future<dynamic> export1p8GAllRFOutputLogs({
    required String code,
    required Map<String, String> attributeData,
    required Map<String, String> regulationData,
    required List<Map<String, String>> controlData,
    required List<RFInOut> rfInOuts,
    required List<RFOutputLog> rfOutputLogs,
  }) async {
    Excel excel = Excel.createExcel();

    excel.rename('Sheet1', 'User Information');
    Sheet userInformationSheet = excel['User Information'];
    Sheet rfInSheet = excel['Input Levels'];
    Sheet rfOutSheet = excel['Output Levels'];
    Sheet rfOutputLogSheet = excel['Output Level Logs'];

    userInformationSheet.insertRowIterables(
      [
        TextCellValue('Code Number'),
        TextCellValue(code),
      ],
      0,
    );

    // 空兩行後再開始寫入 attribute data
    List<String> attributeDataKeys = attributeData.keys.toList();
    for (int i = 0; i < attributeDataKeys.length; i++) {
      String key = attributeDataKeys[i];
      String value = attributeData[key] ?? '';

      userInformationSheet.insertRowIterables(
        [
          TextCellValue(key),
          TextCellValue(value),
        ],
        i + 3,
      );
    }

    // 空兩行後再開始寫入 regulation data
    List<String> regulationDataKeys = regulationData.keys.toList();
    for (int i = 0; i < regulationDataKeys.length; i++) {
      String key = regulationDataKeys[i];
      String value = regulationData[key] ?? '';

      userInformationSheet.insertRowIterables(
        [
          TextCellValue(key),
          TextCellValue(value),
        ],
        i + attributeDataKeys.length + 4,
      );
    }

    // 空兩行後再開始寫入 control data
    for (int i = 0; i < controlData.length; i++) {
      MapEntry entry = controlData[i].entries.first;
      userInformationSheet.insertRowIterables(
        [
          TextCellValue(entry.key),
          TextCellValue(entry.value),
        ],
        i + attributeDataKeys.length + regulationDataKeys.length + 5,
      );
    }

    List<TextCellValue> rfHeader = [
      TextCellValue('Frequency (MHz)'),
      TextCellValue('Level (dBmV)'),
    ];

    rfInSheet.insertRowIterables(rfHeader, 0);
    for (int i = 0; i < rfInOuts.length; i++) {
      String frequency = rfInOuts[i].frequency.toString();
      String level = rfInOuts[i].input.toStringAsFixed(1);

      List<TextCellValue> row = [
        TextCellValue(frequency),
        TextCellValue(level),
      ];

      rfInSheet.insertRowIterables(row, i + 1);
    }

    rfOutSheet.insertRowIterables(rfHeader, 0);
    for (int i = 0; i < rfInOuts.length; i++) {
      String frequency = rfInOuts[i].frequency.toString();
      String level = rfInOuts[i].output.toStringAsFixed(1);

      List<TextCellValue> row = [
        TextCellValue(frequency),
        TextCellValue(level),
      ];

      rfOutSheet.insertRowIterables(row, i + 1);
    }

    // 寫入 rf output logs
    for (int i = 0; i < rfOutputLogs.length; i++) {
      DateTime dateTime = rfOutputLogs[i].dateTime;

      String timeStamp =
          DateFormat('yyyy_MM_dd_HH_mm_ss').format(dateTime).toString();

      List<TextCellValue> timeRow = [TextCellValue(timeStamp)];
      rfOutputLogSheet.insertRowIterables(
        timeRow,
        0,
        startingColumn: i * 3,
      );
      rfOutputLogSheet.insertRowIterables(
        rfHeader,
        1,
        startingColumn: i * 3,
      );

      List<RFOut> rfOuts = rfOutputLogs[i].rfOuts;

      // 寫入 256 組 rf output, [frequency, level]
      for (int j = 0; j < rfOuts.length; j++) {
        String frequency = rfOuts[j].frequency.toString();
        String level = rfOuts[j].output.toStringAsFixed(1);

        List<TextCellValue> outputRow = [
          TextCellValue(frequency),
          TextCellValue(level)
        ];

        rfOutputLogSheet.insertRowIterables(
          outputRow,
          j + 2,
          startingColumn: i * 3,
        );
      }
    }

    var fileBytes = excel.save();

    String timeStamp =
        DateFormat('yyyy_MM_dd_HH_mm_ss').format(DateTime.now()).toString();
    String filename = 'rf_levels_$timeStamp';
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
    } else if (Platform.isWindows) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      Directory appDocDirFolder = Directory('${appDocDir.path}/ACI+/');
      bool isExist = await appDocDirFolder.exists();
      if (!isExist) {
        await appDocDirFolder.create(recursive: true);
      }

      String appDocPath = appDocDirFolder.path;
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

  Future<dynamic> export1p8GRecords({
    required String code,
    required Map<String, String> attributeData,
    required Map<String, String> regulationData,
    required List<Map<String, String>> controlData,
    // required String coordinate,
    // required String location,
    required List<Log1p8G> log1p8Gs,
    required List<Event1p8G> event1p8Gs,
  }) async {
    Excel excel = Excel.createExcel();

    List<TextCellValue> log1p8GHeader = [
      TextCellValue('Time'),
      TextCellValue('Temperature(C)'),
      TextCellValue('RF Output Low Pilot(dBmV)'),
      TextCellValue('RF Output High Pilot(dBmV)'),
      TextCellValue('24V(V)'),
      TextCellValue('24V Ripple(mV)'),
    ];
    List<TextCellValue> eventHeader = [
      TextCellValue('24V High Alarm(V)'),
      TextCellValue('24V Low Alarm(V)'),
      TextCellValue('Temperature High Alarm(C)'),
      TextCellValue('Temperature Low Alarm(C)'),
      TextCellValue('RF Input Pilot Low Frequency Unlock'),
      TextCellValue('RF Input Pilot High Frequency Unlock'),
      TextCellValue('RF Output Pilot Low Frequency Unlock'),
      TextCellValue('RF Output Pilot High Frequency Unlock'),
      TextCellValue('RF Input Total Power High Alarm'),
      TextCellValue('RF Input Total Power Low Alarm'),
      TextCellValue('RF Output Total Power High Alarm'),
      TextCellValue('RF Output Total Power Low Alarm'),
      TextCellValue('24V Ripple High Alarm'),
      TextCellValue('Amplifier Power On'),
      TextCellValue('Firmware Updated'),
      TextCellValue('Equalizer Changed'),
      TextCellValue('DFU Changed'),
    ];

    excel.rename('Sheet1', 'User Information');
    Sheet userInformationSheet = excel['User Information'];
    Sheet log1p8GSheet = excel['Log'];
    Sheet eventSheet = excel['Event'];

    userInformationSheet.insertRowIterables([
      TextCellValue('Code Number'),
      TextCellValue(code),
    ], 0);

    // 空兩行後再開始寫入 attribute data
    List<String> attributeDataKeys = attributeData.keys.toList();
    for (int i = 0; i < attributeDataKeys.length; i++) {
      String key = attributeDataKeys[i];
      String value = attributeData[key] ?? '';

      userInformationSheet.insertRowIterables(
        [
          TextCellValue(key),
          TextCellValue(value),
        ],
        i + 3,
      );
    }

    // 空兩行後再開始寫入 regulation data
    List<String> regulationDataKeys = regulationData.keys.toList();
    for (int i = 0; i < regulationDataKeys.length; i++) {
      String key = regulationDataKeys[i];
      String value = regulationData[key] ?? '';

      userInformationSheet.insertRowIterables(
        [
          TextCellValue(key),
          TextCellValue(value),
        ],
        i + attributeDataKeys.length + 4,
      );
    }

    // 空兩行後再開始寫入 control data
    for (int i = 0; i < controlData.length; i++) {
      MapEntry entry = controlData[i].entries.first;
      userInformationSheet.insertRowIterables(
        [
          TextCellValue(entry.key),
          TextCellValue(entry.value),
        ],
        i + attributeDataKeys.length + regulationDataKeys.length + 5,
      );
    }

    eventSheet.insertRowIterables(eventHeader, 0);
    List<List<String>> eventContent = formatEvent1p8G(event1p8Gs);
    for (int i = 0; i < eventContent.length; i++) {
      List<String> row = eventContent[i];
      List<TextCellValue> eventRow =
          row.map((event) => TextCellValue(event)).toList();
      eventSheet.insertRowIterables(eventRow, i + 1);
    }

    log1p8GSheet.insertRowIterables(log1p8GHeader, 0);
    for (int i = 0; i < log1p8Gs.length; i++) {
      Log1p8G log1p8G = log1p8Gs[i];
      List<String> row = formatLog1p8G(log1p8G);
      List<TextCellValue> log1p8GRow =
          row.map((log) => TextCellValue(log)).toList();
      log1p8GSheet.insertRowIterables(log1p8GRow, i + 1);
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
    } else if (Platform.isWindows) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      Directory appDocDirFolder = Directory('${appDocDir.path}/ACI+/');
      bool isExist = await appDocDirFolder.exists();
      if (!isExist) {
        await appDocDirFolder.create(recursive: true);
      }

      String appDocPath = appDocDirFolder.path;
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
      RFInOut rfInOut = rfInOuts[i];

      rfOutputs.add(ValuePair(
        x: rfInOut.frequency,
        y: rfInOut.output,
      ));

      rfInputs.add(ValuePair(
        x: rfInOut.frequency,
        y: rfInOut.input,
      ));
    }

    return [
      rfOutputs,
      rfInputs,
    ];
  }

  List<String> formatLog1p8G(Log1p8G log1p8G) {
    String formattedDateTime =
        DateFormat('yyyy-MM-dd HH:mm').format(log1p8G.dateTime);
    String temperatureC = log1p8G.temperature.toString();
    String rfOutputLowPilot = log1p8G.rfOutputLowPilot.toString();
    String rfOutputHighPilot = log1p8G.rfOutputHighPilot.toString();
    String voltage = log1p8G.voltage.toString();
    String voltageRipple = log1p8G.voltageRipple.toString();
    List<String> row = [
      formattedDateTime,
      temperatureC,
      rfOutputLowPilot,
      rfOutputHighPilot,
      voltage,
      voltageRipple
    ];

    return row;
  }

  List<List<String>> formatEvent1p8G(List<Event1p8G> event1p8Gs) {
    List<int> counts = List.filled(18, 0);

    // 第一個參數 1024 表示要生成 1024 行
    // 第二個參數 14 表示每行要生成 14 個字串。
    List<List<String>> csvContent = List<List<String>>.generate(
      1024,
      (index) => List<String>.generate(
        18,
        (index) => '',
        growable: false,
      ),
      growable: false,
    );

    for (Event1p8G event1p8G in event1p8Gs) {
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
        // case 14: // 24V ripple low alarm 不顯示
        //   {
        //     if (event1p8G.parameter > 0) {
        //       csvContent[counts[index]][index] =
        //           '$formattedDateTime@${event1p8G.parameter / 10}';
        //     } else {
        //       csvContent[counts[index]][index] = formattedDateTime;
        //     }
        //     counts[index]++;
        //     break;
        //   }
        case 15:
          {
            int index = 13;
            if (event1p8G.parameter > 0) {
              csvContent[counts[index]][index] =
                  '$formattedDateTime@${event1p8G.parameter}';
            } else {
              csvContent[counts[index]][index] = formattedDateTime;
            }
            counts[index]++;
            break;
          }
        case 16:
          {
            int index = 14;
            csvContent[counts[index]][index] = formattedDateTime;
            counts[index]++;
            break;
          }
        case 17:
          {
            int index = 15;
            if (event1p8G.parameter > 0) {
              String equalizerDescription =
                  Event1p8GValue.equalizerValueMap[event1p8G.parameter] ?? '';
              csvContent[counts[index]][index] =
                  '$formattedDateTime@$equalizerDescription';
            } else {
              csvContent[counts[index]][index] = formattedDateTime;
            }
            counts[index]++;
            break;
          }
        case 18:
          {
            int index = 16;
            if (event1p8G.parameter > 0) {
              String splitOptionDescription =
                  Event1p8GValue.splitOptionValueMap[event1p8G.parameter] ?? '';
              csvContent[counts[index]][index] =
                  '$formattedDateTime@$splitOptionDescription';
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
    CRC16.calculateCRC16(command: Command18.req00Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.req90Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqA0Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqRFInOutCmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqRFInOutDFU6Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqLog00Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqLog01Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqLog02Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqLog03Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqLog04Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqLog05Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqLog06Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqLog07Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqLog08Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqLog09Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqEvent00Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqRFOutput00Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqRFOutput01Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqRFOutput02Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqRFOutput03Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqRFOutput04Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqRFOutput05Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqRFOutput06Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqRFOutput07Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqRFOutput08Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.reqRFOutput09Cmd, usDataLength: 6);
    CRC16.calculateCRC16(
        command: Command18.reqUserAttributeCmd, usDataLength: 6);
    CRC16.calculateCRC16(
        command: Command18.reqFirmwareUpdateLogCmd, usDataLength: 6);

    _command18Collection.add(Command18.req00Cmd); // #0
    _command18Collection.add(Command18.req90Cmd); // #1
    _command18Collection.add(Command18.reqA0Cmd); // #2
    _command18Collection.add(Command18.reqRFInOutCmd); // #3
    _command18Collection.add(Command18.reqLog00Cmd); // #4
    _command18Collection.add(Command18.reqLog01Cmd); // #5
    _command18Collection.add(Command18.reqLog02Cmd); // #6
    _command18Collection.add(Command18.reqLog03Cmd); // #7
    _command18Collection.add(Command18.reqLog04Cmd); // #8
    _command18Collection.add(Command18.reqLog05Cmd); // #9
    _command18Collection.add(Command18.reqLog06Cmd); // #10
    _command18Collection.add(Command18.reqLog07Cmd); // #11
    _command18Collection.add(Command18.reqLog08Cmd); // #12
    _command18Collection.add(Command18.reqLog09Cmd); // #13
    _command18Collection.add(Command18.reqEvent00Cmd); // #14
    _command18Collection.add(Command18.reqRFOutput00Cmd); // #15
    _command18Collection.add(Command18.reqRFOutput01Cmd); // #16
    _command18Collection.add(Command18.reqRFOutput02Cmd); // #17
    _command18Collection.add(Command18.reqRFOutput03Cmd); // #18
    _command18Collection.add(Command18.reqRFOutput04Cmd); // #19
    _command18Collection.add(Command18.reqRFOutput05Cmd); // #20
    _command18Collection.add(Command18.reqRFOutput06Cmd); // #21
    _command18Collection.add(Command18.reqRFOutput07Cmd); // #22
    _command18Collection.add(Command18.reqRFOutput08Cmd); // #23
    _command18Collection.add(Command18.reqRFOutput09Cmd); // #24
    _command18Collection.add(Command18.reqUserAttributeCmd); // #25
    _command18Collection.add(Command18.reqRFInOutDFU6Cmd); // #26
  }
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

class Event1p8G {
  const Event1p8G({
    required this.dateTime,
    required this.code,
    required this.parameter,
  });

  final DateTime dateTime;
  final int code;
  final int parameter;
}

class RFInOut {
  const RFInOut({
    required this.frequency,
    required this.input,
    required this.output,
  });

  final int frequency;
  final double input;
  final double output;
}

class RFOutputLog {
  const RFOutputLog({
    required this.dateTime,
    required this.rfOuts,
  });

  final DateTime dateTime;
  final List<RFOut> rfOuts; // 256 筆
}

class RFOut {
  const RFOut({
    required this.frequency,
    required this.output,
  });

  final int frequency;
  final double output;
}

class A1P8G0 {
  const A1P8G0({
    required this.partName,
    required this.partNo,
    required this.partId,
    required this.serialNumber,
    required this.firmwareVersion,
    required this.hardwareVersion,
    required this.mfgDate,
    required this.coordinate,
    required this.nowDateTime,
    required this.deviceMTU,
    required this.bluetoothDelayTime,
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
  final String deviceMTU;
  final String bluetoothDelayTime;
}

class A1P8G1 {
  const A1P8G1({
    required this.maxTemperatureC,
    required this.minTemperatureC,
    required this.maxTemperatureF,
    required this.minTemperatureF,
    required this.maxVoltage,
    required this.minVoltage,
    required this.maxVoltageRipple,
    required this.minVoltageRipple,
    required this.maxRFOutputPower,
    required this.minRFOutputPower,
    required this.ingressSetting2,
    required this.ingressSetting3,
    required this.ingressSetting4,
    required this.forwardCEQIndex,
    required this.rfOutputLogInterval,
    required this.tgcCableLength,
    required this.splitOption,
    required this.pilotFrequencyMode,
    required this.agcMode,
    required this.alcMode,
    required this.firstChannelLoadingFrequency,
    required this.lastChannelLoadingFrequency,
    required this.firstChannelLoadingLevel,
    required this.lastChannelLoadingLevel,
    required this.pilotFrequency1,
    required this.pilotFrequency2,
    required this.pilotFrequency1AlarmState,
    required this.pilotFrequency2AlarmState,
    required this.rfOutputPilotLowFrequencyAlarmState,
    required this.rfOutputPilotHighFrequencyAlarmState,
    required this.temperatureAlarmState,
    required this.voltageAlarmState,
    required this.factoryDefaultNumber,
    required this.splitOptionAlarmState,
    required this.voltageRippleAlarmState,
    required this.outputPowerAlarmState,
    required this.dsVVA1,
    required this.dsSlope1,
    required this.dsVVA2,
    required this.dsSlope2,
    required this.usVCA1,
    required this.usVCA3,
    required this.usVCA4,
    required this.usVCA2,
    required this.eREQ,
    required this.dsVVA3,
    required this.dsVVA4,
    required this.dsVVA5,
    required this.dsSlope3,
    required this.dsSlope4,
    // required this.usTGC,
    required this.location,
    required this.logInterval,
  });

  final String maxTemperatureC;
  final String minTemperatureC;
  final String maxTemperatureF;
  final String minTemperatureF;
  final String maxVoltage;
  final String minVoltage;
  final String maxVoltageRipple;
  final String minVoltageRipple;
  final String maxRFOutputPower;
  final String minRFOutputPower;
  final String ingressSetting2;
  final String ingressSetting3;
  final String ingressSetting4;
  final String forwardCEQIndex;
  final String rfOutputLogInterval;
  final String tgcCableLength;
  final String splitOption;
  final String pilotFrequencyMode;
  final String agcMode;
  final String alcMode;
  final String firstChannelLoadingFrequency;
  final String lastChannelLoadingFrequency;
  final String firstChannelLoadingLevel;
  final String lastChannelLoadingLevel;
  final String pilotFrequency1;
  final String pilotFrequency2;
  final String pilotFrequency1AlarmState;
  final String pilotFrequency2AlarmState;
  final String rfOutputPilotLowFrequencyAlarmState;
  final String rfOutputPilotHighFrequencyAlarmState;
  final String temperatureAlarmState;
  final String voltageAlarmState;
  final String factoryDefaultNumber;
  final String splitOptionAlarmState;
  final String voltageRippleAlarmState;
  final String outputPowerAlarmState;
  final String dsVVA1;
  final String dsSlope1;
  final String dsVVA2;
  final String dsSlope2;
  final String usVCA1;
  final String usVCA3;
  final String usVCA4;
  final String usVCA2;
  final String eREQ;
  final String dsVVA3;
  final String dsVVA4;
  final String dsVVA5;
  final String dsSlope3;
  final String dsSlope4;
  // final String usTGC;
  final String location;
  final String logInterval;
}

class A1P8G2 {
  const A1P8G2({
    required this.currentTemperatureC,
    required this.currentTemperatureF,
    required this.currentVoltage,
    required this.currentVoltageRipple,
    required this.currentRFInputPower,
    required this.currentRFOutputPower,
    required this.currentDSVVA1,
    required this.currentDSSlope1,
    required this.currentWorkingMode,
    required this.currentDetectedSplitOption,
    required this.currentRFInputPower1p8G,
    required this.rfOutputOperatingSlope,
    required this.manualModePilot1RFOutputPower,
    required this.manualModePilot2RFOutputPower,
    required this.rfOutputLowChannelPower,
    required this.rfOutputHighChannelPower,
    required this.pilot1RFChannelFrequency,
    required this.pilot2RFChannelFrequency,
    required this.unitStatusAlarmSeverity,
    required this.rfInputPilotLowFrequencyAlarmSeverity,
    required this.rfInputPilotHighFrequencyAlarmSeverity,
    required this.rfOutputPilotLowFrequencyAlarmSeverity,
    required this.rfOutputPilotHighFrequencyAlarmSeverity,
    required this.temperatureAlarmSeverity,
    required this.voltageAlarmSeverity,
    required this.splitOptionAlarmSeverity,
    required this.voltageRippleAlarmSeverity,
    required this.outputPowerAlarmSeverity,
    required this.currentForwardCEQIndex,
  });

  final String currentTemperatureC;
  final String currentTemperatureF;
  final String currentVoltage;
  final String currentVoltageRipple;
  final String currentRFInputPower;
  final String currentRFOutputPower;
  final String currentDSVVA1;
  final String currentDSSlope1;
  final String currentWorkingMode;
  final String currentDetectedSplitOption;
  final String rfOutputOperatingSlope;
  final String currentRFInputPower1p8G;
  final String manualModePilot1RFOutputPower;
  final String manualModePilot2RFOutputPower;
  final String rfOutputLowChannelPower;
  final String rfOutputHighChannelPower;
  final String pilot1RFChannelFrequency;
  final String pilot2RFChannelFrequency;
  final String unitStatusAlarmSeverity;
  final String rfInputPilotLowFrequencyAlarmSeverity;
  final String rfInputPilotHighFrequencyAlarmSeverity;
  final String rfOutputPilotLowFrequencyAlarmSeverity;
  final String rfOutputPilotHighFrequencyAlarmSeverity;
  final String temperatureAlarmSeverity;
  final String voltageAlarmSeverity;
  final String splitOptionAlarmSeverity;
  final String voltageRippleAlarmSeverity;
  final String outputPowerAlarmSeverity;
  final String currentForwardCEQIndex;
}

class A1P8GLogStatistic {
  const A1P8GLogStatistic({
    required this.historicalMinTemperatureC,
    required this.historicalMaxTemperatureC,
    required this.historicalMinTemperatureF,
    required this.historicalMaxTemperatureF,
    required this.historicalMinVoltage,
    required this.historicalMaxVoltage,
    required this.historicalMinVoltageRipple,
    required this.historicalMaxVoltageRipple,
  });

  final String historicalMinTemperatureC;
  final String historicalMaxTemperatureC;
  final String historicalMinTemperatureF;
  final String historicalMaxTemperatureF;
  final String historicalMinVoltage;
  final String historicalMaxVoltage;
  final String historicalMinVoltageRipple;
  final String historicalMaxVoltageRipple;
}

class A1P8GRFOutputPowerStatistic {
  const A1P8GRFOutputPowerStatistic({
    required this.historicalMinRFOutputPower,
    required this.historicalMaxRFOutputPower,
  });

  final String historicalMinRFOutputPower;
  final String historicalMaxRFOutputPower;
}

class A1P8GUserAttribute {
  const A1P8GUserAttribute({
    required this.technicianID,
    required this.inputSignalLevel,
    required this.inputAttenuation,
    required this.inputEqualizer,
    required this.cascadePosition,
    required this.deviceName,
    required this.deviceNote,
  });

  final String technicianID;
  final String inputSignalLevel;
  final String inputAttenuation;
  final String inputEqualizer;
  final String cascadePosition;
  final String deviceName;
  final String deviceNote;
}
