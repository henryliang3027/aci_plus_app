import 'dart:async';
import 'dart:io';
import 'package:aci_plus_app/core/command18.dart';
import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/crc16_calculate.dart';
import 'package:aci_plus_app/repositories/unit_converter.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_speed_chart/speed_chart.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:geolocator/geolocator.dart';

class Dsim18Parser {
  Dsim18Parser() {
    calculate18CRCs();
  }

  final List<List<int>> _command18Collection = [];

  List<List<int>> get command18Collection => _command18Collection;

  // 刪除所有 Null character (0x00), 頭尾空白 character
  String _trimString(String s) {
    s = s.replaceAll('\x00', '');
    s = s.trim();
    return s;
  }

  A1P8G0 decodeA1P8G0(List<int> rawData) {
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

    return A1P8G0(
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
    String splitOptionAlarmState = '';
    String voltageRippleAlarmState = '';
    String outputPowerAlarmState = '';
    String inputAttenuation = '';
    String inputEqualizer = '';
    String dsVVA2 = '';
    String dsSlope2 = '';
    String inputAttenuation2 = '';
    String inputAttenuation3 = '';
    String inputAttenuation4 = '';
    String outputAttenuation = '';
    String outputEqualizer = '';
    String dsVVA3 = '';
    String dsVVA4 = '';
    String usTGC = '';
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

    // 解析 pilotFrequency1AlarmState
    rfOutputPilotLowFrequencyAlarmState = rawData[43].toString();

    // 解析 pilotFrequency2AlarmState
    rfOutputPilotHighFrequencyAlarmState = rawData[44].toString();

    // 解析 temperatureAlarmState
    temperatureAlarmState = rawData[45].toString();

    // 解析 voltageAlarmState
    voltageAlarmState = rawData[46].toString();

    // 解析 splitOptionAlarmState
    splitOptionAlarmState = rawData[51].toString();

    // 解析 voltageRippleAlarmState
    voltageRippleAlarmState = rawData[52].toString();

    // 解析 outputPowerAlarmState
    outputPowerAlarmState = rawData[53].toString();

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

    // 解析 inputAttenuation (0x94 DS VVA1 Set dB)
    List<int> rawInputAttenuation = rawData.sublist(151, 153);
    ByteData rawInputAttenuationByteData =
        ByteData.sublistView(Uint8List.fromList(rawInputAttenuation));
    inputAttenuation =
        (rawInputAttenuationByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 inputEqualizer (0x96 DS Slope1 Set dB)
    List<int> rawInputEqualizer = rawData.sublist(153, 155);
    ByteData rawInputEqualizerByteData =
        ByteData.sublistView(Uint8List.fromList(rawInputEqualizer));
    inputEqualizer = (rawInputEqualizerByteData.getInt16(0, Endian.little) / 10)
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

    // 解析 inputAttenuation2 (0x9C US VCA1 Set dB)
    List<int> rawInputAttenuation2 = rawData.sublist(159, 161);
    ByteData rawInputAttenuation2ByteData =
        ByteData.sublistView(Uint8List.fromList(rawInputAttenuation2));
    inputAttenuation2 =
        (rawInputAttenuation2ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 outputEqualizer (0x9E US E-REQ Set dB)
    List<int> rawOutputEqualizer = rawData.sublist(161, 163);
    ByteData rawOutputEqualizerByteData =
        ByteData.sublistView(Uint8List.fromList(rawOutputEqualizer));
    outputEqualizer =
        (rawOutputEqualizerByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

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

    // 解析 outputAttenuation (0xA4 US VCA2 Set dB)
    List<int> rawOutputAttenuation = rawData.sublist(167, 169);
    ByteData rawOutputAttenuationByteData =
        ByteData.sublistView(Uint8List.fromList(rawOutputAttenuation));
    outputAttenuation =
        (rawOutputAttenuationByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 inputAttenuation3 (0xA6 US VCA3 Set dB)
    List<int> rawInputAttenuation3 = rawData.sublist(169, 171);
    ByteData rawInputAttenuation3ByteData =
        ByteData.sublistView(Uint8List.fromList(rawInputAttenuation3));
    inputAttenuation3 =
        (rawInputAttenuation3ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 inputAttenuation4 (0xA8 US VCA4 Set dB)
    List<int> rawInputAttenuation4 = rawData.sublist(171, 173);
    ByteData rawInputAttenuation4ByteData =
        ByteData.sublistView(Uint8List.fromList(rawInputAttenuation4));
    inputAttenuation4 =
        (rawInputAttenuation4ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

    // 解析 usTGC (0xAA US TGC Set dB)
    List<int> rawUSTGC = rawData.sublist(173, 175);
    ByteData rawUSTGCByteData =
        ByteData.sublistView(Uint8List.fromList(rawUSTGC));
    usTGC =
        (rawUSTGCByteData.getInt16(0, Endian.little) / 10).toStringAsFixed(1);

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
      splitOptionAlarmState: splitOptionAlarmState,
      voltageRippleAlarmState: voltageRippleAlarmState,
      outputPowerAlarmState: outputPowerAlarmState,
      inputAttenuation: inputAttenuation,
      inputEqualizer: inputEqualizer,
      dsVVA2: dsVVA2,
      dsSlope2: dsSlope2,
      inputAttenuation2: inputAttenuation2,
      inputAttenuation3: inputAttenuation3,
      inputAttenuation4: inputAttenuation4,
      outputAttenuation: outputAttenuation,
      outputEqualizer: outputEqualizer,
      dsVVA3: dsVVA3,
      dsVVA4: dsVVA4,
      usTGC: usTGC,
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
    String currentWorkingMode = '';
    String currentDetectedSplitOption = '';
    String rfOutputOperatingSlope = '';
    String manualModePilot1RFOutputPower = '';
    String manualModePilot2RFOutputPower = '';
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

    // 解析 currentWorkingMode
    currentWorkingMode = rawData[70].toString();

    // 解析 currentDetectedSplitOption
    currentDetectedSplitOption = rawData[71].toString();

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
    List<int> rawRFOutputOperatingSlope = rawData.sublist(96, 98);
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

    return A1P8G2(
      currentTemperatureC: currentTemperatureC,
      currentTemperatureF: currentTemperatureF,
      currentVoltage: currentVoltage,
      currentVoltageRipple: currentVoltageRipple,
      currentRFInputPower: currentRFInputPower,
      currentRFOutputPower: currentRFOutputPower,
      currentWorkingMode: currentWorkingMode,
      currentDetectedSplitOption: currentDetectedSplitOption,
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
    required List<RFInOut> rfInOuts,
  }) async {
    Excel excel = Excel.createExcel();
    List<String> rfInOutHeader = [
      'Frequency (MHz)',
      'Level (dBmV)',
    ];

    Sheet rfInSheet = excel['Input Levels'];
    Sheet rfOutSheet = excel['Output Levels'];

    rfInSheet.insertRowIterables(rfInOutHeader, 0);
    for (int i = 0; i < rfInOuts.length; i++) {
      String frequency = rfInOuts[i].frequency.toString();
      String level = rfInOuts[i].input.toStringAsFixed(1);

      List<String> row = [frequency, level];
      rfInSheet.insertRowIterables(row, i + 1);
    }

    rfOutSheet.insertRowIterables(rfInOutHeader, 0);
    for (int i = 0; i < rfInOuts.length; i++) {
      String frequency = rfInOuts[i].frequency.toString();
      String level = rfInOuts[i].output.toStringAsFixed(1);

      List<String> row = [frequency, level];
      rfOutSheet.insertRowIterables(row, i + 1);
    }

    excel.unLink('Sheet1'); // Excel 預設會自動產生 Sheet1, 所以先unlink
    excel.delete('Sheet1'); // 再刪除 Sheet1
    excel.link('Input Levels', rfInSheet);
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

  Future<dynamic> export1p8GRecords({
    required List<Log1p8G> log1p8Gs,
    required List<Event1p8G> event1p8Gs,
  }) async {
    Excel excel = Excel.createExcel();
    List<String> log1p8GHeader = [
      'Time',
      'Temperature(C)',
      'RF Output Low Pilot',
      'RF Output High Pilot',
      '24V(V)',
      '24V Ripple(mV)',
    ];
    List<String> eventHeader = [
      '24V High Alarm(V)',
      '24V Low Alarm(V)',
      'Temperature High Alarm(C)',
      'Temperature Low Alarm(C)',
      'RF Input Pilot Low Frequency Unlock',
      'RF Input Pilot High Frequency Unlock',
      'RF Output Pilot Low Frequency Unlock',
      'RF Output Pilot High Frequency Unlock',
      'RF Input Total Power High Alarm',
      'RF Input Total Power Low Alarm',
      'RF Output Total Power High Alarm',
      'RF Output Total Power Low Alarm',
      '24V Ripple High Alarm',
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
      Log1p8G log1p8G = log1p8Gs[i];
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
    List<int> counts = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    List<List<String>> csvContent = List<List<String>>.generate(
      1024,
      (index) => List<String>.generate(
        14,
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
      }
    }

    return csvContent;
  }

  double _convertToFahrenheit(double celcius) {
    double fahrenheit = (celcius * 1.8) + 32;
    return fahrenheit;
  }

  Future<String> getGPSCoordinates() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 跳出打開定位的提示 dialog
      bool isEnableGPS = await Location().requestService();
      if (!isEnableGPS) {
        return Future.error(
            'Location services are disabled. Please enable location services.');
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error(
            'Location permissions are denied. Please provide permission.');
      }
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    String coordinate =
        '${position.latitude.toStringAsFixed(10)},${position.longitude.toStringAsFixed(10)}';

    return coordinate;
  }

  void calculate18CRCs() {
    CRC16.calculateCRC16(command: Command18.req00Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.req01Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.req02Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command18.req03Cmd, usDataLength: 6);
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

    _command18Collection.add(Command18.req00Cmd);
    _command18Collection.add(Command18.req01Cmd);
    _command18Collection.add(Command18.req02Cmd);
    _command18Collection.add(Command18.req03Cmd);
    _command18Collection.add(Command18.reqLog00Cmd);
    _command18Collection.add(Command18.reqLog01Cmd);
    _command18Collection.add(Command18.reqLog02Cmd);
    _command18Collection.add(Command18.reqLog03Cmd);
    _command18Collection.add(Command18.reqLog04Cmd);
    _command18Collection.add(Command18.reqLog05Cmd);
    _command18Collection.add(Command18.reqLog06Cmd);
    _command18Collection.add(Command18.reqLog07Cmd);
    _command18Collection.add(Command18.reqLog08Cmd);
    _command18Collection.add(Command18.reqLog09Cmd);
    _command18Collection.add(Command18.reqEvent00Cmd);
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

class A1P8G0 {
  const A1P8G0({
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
    required this.splitOptionAlarmState,
    required this.voltageRippleAlarmState,
    required this.outputPowerAlarmState,
    required this.inputAttenuation,
    required this.inputEqualizer,
    required this.dsVVA2,
    required this.dsSlope2,
    required this.inputAttenuation2,
    required this.inputAttenuation3,
    required this.inputAttenuation4,
    required this.outputAttenuation,
    required this.outputEqualizer,
    required this.dsVVA3,
    required this.dsVVA4,
    required this.usTGC,
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
  final String splitOptionAlarmState;
  final String voltageRippleAlarmState;
  final String outputPowerAlarmState;
  final String inputAttenuation;
  final String inputEqualizer;
  final String dsVVA2;
  final String dsSlope2;
  final String inputAttenuation2;
  final String inputAttenuation3;
  final String inputAttenuation4;
  final String outputAttenuation;
  final String outputEqualizer;
  final String dsVVA3;
  final String dsVVA4;
  final String usTGC;
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
    required this.currentWorkingMode,
    required this.currentDetectedSplitOption,
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
  });

  final String currentTemperatureC;
  final String currentTemperatureF;
  final String currentVoltage;
  final String currentVoltageRipple;
  final String currentRFInputPower;
  final String currentRFOutputPower;
  final String currentWorkingMode;
  final String currentDetectedSplitOption;
  final String rfOutputOperatingSlope;
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
}

class A1P8GAlarm {
  const A1P8GAlarm({
    required this.unitStatusAlarmSeverity,
    required this.temperatureAlarmSeverity,
    required this.powerAlarmSeverity,
  });

  final String unitStatusAlarmSeverity;
  final String temperatureAlarmSeverity;
  final String powerAlarmSeverity;
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
