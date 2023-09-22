import 'dart:async';
import 'dart:io';
import 'package:dsim_app/core/command18.dart';
import 'package:dsim_app/core/crc16_calculate.dart';

import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:dsim_app/repositories/unit_converter.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class Dsim18Parser {
  Dsim18Parser() {
    calculate18CRCs();
  }

  final List<List<int>> _command18Collection = [];
  List<int> _rawLogs = [];
  List<int> _rawRFInOut = [];

  List<List<int>> get command18Collection => _command18Collection;

  // 刪除所有 Null character (0x00), 頭尾空白 character
  String _trimString(String s) {
    s = s.replaceAll('\x00', '');
    s = s.trim();
    return s;
  }

  void parseRawData({
    required int commandIndex,
    required List<int> rawData,
    required Completer completer,
  }) {
    switch (commandIndex) {
      case 180:
        String partName = '';
        String partNo = '';
        String serialNumber = '';
        String firmwareVersion = '';
        String mfgDate = '';
        String coordinate = '';

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

        for (int i = 72; i <= 110; i++) {
          coordinate += String.fromCharCode(rawData[i]);
        }
        coordinate = _trimString(coordinate);

        if (!completer.isCompleted) {
          completer.complete((
            partName,
            partNo,
            serialNumber,
            firmwareVersion,
            mfgDate,
            coordinate,
          ));
        }

        break;
      case 181:
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
        maxTemperatureF =
            _convertToFahrenheit(maxTemperature).toStringAsFixed(1);

        // 解析 minTemperatureC, minTemperatureF
        List<int> rawMinTemperatureC = rawData.sublist(5, 7);
        ByteData rawMinTemperatureCByteData =
            ByteData.sublistView(Uint8List.fromList(rawMinTemperatureC));

        double minTemperature =
            rawMinTemperatureCByteData.getInt16(0, Endian.little) / 10;
        minTemperatureC = minTemperature.toStringAsFixed(1);
        minTemperatureF =
            _convertToFahrenheit(minTemperature).toStringAsFixed(1);

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
        ByteData rawFirstChannelLoadingLevelByteData = ByteData.sublistView(
            Uint8List.fromList(rawFirstChannelLoadingLevel));
        firstChannelLoadingLevel =
            (rawFirstChannelLoadingLevelByteData.getInt16(0, Endian.little) /
                    10)
                .toStringAsFixed(1);

        // 解析 lastChannelLoadingLevel
        List<int> rawLastChannelLoadingLevel = rawData.sublist(35, 37);
        ByteData rawLastChannelLoadingLevelByteData = ByteData.sublistView(
            Uint8List.fromList(rawLastChannelLoadingLevel));
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
        inputEqualizer =
            (rawInputEqualizerByteData.getInt16(0, Endian.little) / 10)
                .toStringAsFixed(1);

        // 解析 dsVVA2 (0x98 DS VVA2 Set dB)
        List<int> rawDSVVA2 = rawData.sublist(155, 157);
        ByteData rawDSVVA2ByteData =
            ByteData.sublistView(Uint8List.fromList(rawDSVVA2));
        dsVVA2 = (rawDSVVA2ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

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
        dsVVA3 = (rawDSVVA3ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

        // 解析 dsVVA4 (0xA2 DS VVA4 Set dB)
        List<int> rawDSVVA4 = rawData.sublist(165, 167);
        ByteData rawDSVVA4ByteData =
            ByteData.sublistView(Uint8List.fromList(rawDSVVA4));
        dsVVA4 = (rawDSVVA4ByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

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
        usTGC = (rawUSTGCByteData.getInt16(0, Endian.little) / 10)
            .toStringAsFixed(1);

        if (!completer.isCompleted) {
          completer.complete((
            minTemperatureC,
            maxTemperatureC,
            minTemperatureF,
            maxTemperatureF,
            minVoltage,
            maxVoltage,
            minVoltageRipple,
            maxVoltageRipple,
            minRFOutputPower,
            maxRFOutputPower,
            ingressSetting2,
            ingressSetting3,
            ingressSetting4,
            tgcCableLength,
            splitOption,
            pilotFrequencyMode,
            agcMode,
            alcMode,
            firstChannelLoadingFrequency,
            lastChannelLoadingFrequency,
            firstChannelLoadingLevel,
            lastChannelLoadingLevel,
            pilotFrequency1,
            pilotFrequency2,
            pilotFrequency1AlarmState,
            pilotFrequency2AlarmState,
            rfOutputPilotLowFrequencyAlarmState,
            rfOutputPilotHighFrequencyAlarmState,
            temperatureAlarmState,
            voltageAlarmState,
            splitOptionAlarmState,
            voltageRippleAlarmState,
            outputPowerAlarmState,
            location,
            logInterval,
            inputAttenuation,
            inputEqualizer,
            dsVVA2,
            dsSlope2,
            inputAttenuation2,
            outputEqualizer,
            dsVVA3,
            dsVVA4,
            outputAttenuation,
            inputAttenuation3,
            inputAttenuation4,
            usTGC,
          ));
        }
        break;
      case 182:
        String currentTemperatureC = '';
        String currentTemperatureF = '';
        String currentVoltage = '';
        String currentVoltageRipple = '';
        String currentRFInputPower = '';
        String currentRFOutputPower = '';
        String currentWorkingMode = '';
        String currentDetectedSplitOption = '';
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
        unitStatusAlarmSeverity =
            unitStatus == 1 ? Alarm.success : Alarm.danger;

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

        currentVoltage =
            (rawCurrentVoltageByteData.getInt16(0, Endian.little) / 10)
                .toStringAsFixed(1);

        // 解析 currentVoltageRipple
        List<int> rawCurrentVoltageRipple = rawData.sublist(8, 10);
        ByteData rawCurrentVoltageRippleByteData =
            ByteData.sublistView(Uint8List.fromList(rawCurrentVoltageRipple));

        currentVoltageRipple = rawCurrentVoltageRippleByteData
            .getInt16(0, Endian.little)
            .toString();

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
            rfOutputPilotHighFrequencyStatus == 1
                ? Alarm.danger
                : Alarm.success;

        // 解析 temperatureAlarmSeverity
        int temperatureStatus = rawData[128];
        temperatureAlarmSeverity =
            temperatureStatus == 1 ? Alarm.danger : Alarm.success;

        // 解析 voltageAlarmSeverity
        int voltageStatus = rawData[129];
        voltageAlarmSeverity =
            voltageStatus == 1 ? Alarm.danger : Alarm.success;

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

        if (!completer.isCompleted) {
          completer.complete((
            currentTemperatureC,
            currentTemperatureF,
            currentVoltage,
            currentVoltageRipple,
            currentRFInputPower,
            currentRFOutputPower,
            currentWorkingMode,
            currentDetectedSplitOption,
            unitStatusAlarmSeverity.name,
            rfInputPilotLowFrequencyAlarmSeverity.name,
            rfInputPilotHighFrequencyAlarmSeverity.name,
            rfOutputPilotLowFrequencyAlarmSeverity.name,
            rfOutputPilotHighFrequencyAlarmSeverity.name,
            temperatureAlarmSeverity.name,
            voltageAlarmSeverity.name,
            splitOptionAlarmSeverity.name,
            voltageRippleAlarmSeverity.name,
            outputPowerAlarmSeverity.name,
          ));
        }
        break;
      case 183:
        List<int> header = [0xB0, 0x03, 0x16];
        if (listEquals(rawData.sublist(0, 3), header)) {
          _rawRFInOut.clear();
        }

        _rawRFInOut.addAll(rawData);
        print(_rawRFInOut.length);

        if (_rawRFInOut.length == 1029) {
          _rawRFInOut.removeRange(_rawRFInOut.length - 2, _rawRFInOut.length);
          _rawRFInOut.removeRange(0, 3);
          List<RFInOut> rfInOuts = _parseRFInOut(_rawRFInOut);

          if (!completer.isCompleted) {
            completer.complete(rfInOuts);
          }
        }
        break;
      case 184:
        List<int> header = [0xB0, 0x03, 0x00];
        if (listEquals(rawData.sublist(0, 3), header)) {
          _rawLogs.clear();
        }

        _rawLogs.addAll(rawData);
        print(_rawLogs.length);

        if (_rawLogs.length == 16389) {
          _rawLogs.removeRange(_rawLogs.length - 2, _rawLogs.length);
          _rawLogs.removeRange(0, 3);
          print(_rawLogs);
          List<Log1p8G> log1p8Gs = _parse1p8GLog(_rawLogs);
          var (
            historicalMinTemperatureC,
            historicalMaxTemperatureC,
            historicalMinTemperatureF,
            historicalMaxTemperatureF,
            historicalMinVoltageStr,
            historicalMaxVoltageStr,
            historicalMinVoltageRippleStr,
            historicalMaxVoltageRippleStr,
          ) = _get1p8GLogStatistics(log1p8Gs);

          if (!completer.isCompleted) {
            completer.complete((
              historicalMinTemperatureC,
              historicalMaxTemperatureC,
              historicalMinTemperatureF,
              historicalMaxTemperatureF,
              historicalMinVoltageStr,
              historicalMaxVoltageStr,
              historicalMinVoltageRippleStr,
              historicalMaxVoltageRippleStr,
              log1p8Gs,
            ));
          }
        }
        break;
      case 185:
      case 186:
      case 187:
      case 188:
      case 189:
      case 190:
      case 191:
      case 192:
      case 193:
        List<int> header = [0xB0, 0x03, 0x00];
        if (listEquals(rawData.sublist(0, 3), header)) {
          _rawLogs.clear();
        }
        _rawLogs.addAll(rawData);
        print('${_rawLogs.length}');

        if (_rawLogs.length == 16389) {
          _rawLogs.removeRange(_rawLogs.length - 2, _rawLogs.length);
          _rawLogs.removeRange(0, 3);
          print(_rawLogs);
          List<Log1p8G> log1p8Gs = _parse1p8GLog(_rawLogs);

          if (!completer.isCompleted) {
            completer.complete(log1p8Gs);
          }
        }

        break;
      case 194:
      case 195:
      case 196:
      case 197:
      case 198:
      case 199:
      case 200:
      case 201:
      case 202:
      case 203:
        break;
      case 204:
        // 給 定期更新 information page 的 alarm 用
        Alarm alarmUSeverity = Alarm.medium;
        Alarm alarmTServerity = Alarm.medium;
        Alarm alarmPServerity = Alarm.medium;

        int unitStatus = rawData[3];
        alarmUSeverity = unitStatus == 1 ? Alarm.success : Alarm.danger;

        int temperatureStatus = rawData[128];
        alarmTServerity = temperatureStatus == 1 ? Alarm.danger : Alarm.success;

        int powerStatus = rawData[129];
        alarmPServerity = powerStatus == 1 ? Alarm.danger : Alarm.success;

        if (!completer.isCompleted) {
          completer.complete((
            alarmUSeverity.name,
            alarmTServerity.name,
            alarmPServerity.name,
          ));
        }

        break;
      case 300:
      case 301:
      case 302:
      case 303:
      case 304:
      case 305:
      case 306:
      case 307:
      case 308:
      case 309:
      case 310:
      case 311:
      case 312:
      case 313:
      case 314:
      case 315:
      case 316:
      case 317:
      case 318:
      case 319:
      case 320:
      case 321:
      case 322:
      case 323:
      case 324:
      case 325:
      case 326:
      case 327:
      case 328:
      case 329:
      case 330:
      case 331:
      case 332:
      case 333:
      case 334:
      case 335:
      case 336:
      case 337:
      case 338:
      case 339:
      case 340:
      case 341:
      case 342:
      case 343:
      case 344:
      case 345:
      case 346:
      case 347:
      case 348:
      case 349:
      case 350:
      case 351:
      case 352:
      case 353:
      case 354:
        if (!completer.isCompleted) {
          bool result = _parseSettingResult(rawData);
          completer.complete(result);
        }
        break;

      default:
        break;
    }
  }

  (String, String, String, String, String, String, String, String)
      _get1p8GLogStatistics(List<Log1p8G> log1p8Gs) {
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

      return (
        historicalMinTemperatureC,
        historicalMaxTemperatureC,
        historicalMinTemperatureF,
        historicalMaxTemperatureF,
        historicalMinVoltageStr,
        historicalMaxVoltageStr,
        historicalMinVoltageRippleStr,
        historicalMaxVoltageRippleStr,
      );
    } else {
      return (
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
      );
    }
  }

  List<RFInOut> _parseRFInOut(List<int> rawData) {
    List<RFInOut> rfInOuts = [];
    for (var i = 0; i < 256; i++) {
      // 解析 input
      List<int> rawInput = rawData.sublist(i * 2, i * 2 + 2);
      ByteData rawInputByteData =
          ByteData.sublistView(Uint8List.fromList(rawInput));
      double input = rawInputByteData.getInt16(0, Endian.little).toDouble();

      // 解析 output
      List<int> rawOutput = rawData.sublist(i * 2 + 512, i * 2 + 2 + 512);
      ByteData rawOutputByteData =
          ByteData.sublistView(Uint8List.fromList(rawOutput));
      double output = rawOutputByteData.getInt16(0, Endian.little).toDouble();

      rfInOuts.add(RFInOut(
        input: input,
        output: output,
      ));
    }

    return rfInOuts;
  }

  List<Log1p8G> _parse1p8GLog(List<int> rawData) {
    List<Log1p8G> logChunks = [];
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

  Future<dynamic> export1p8GRecords(List<Log1p8G> log1p8Gs) async {
    Excel excel = Excel.createExcel();
    List<String> log1p8GHeader = [
      'Time',
      'Temperature(C)',
      'RF Output Low Pilot',
      'RF Output High Pilot',
      '24V(V)',
      '24V Ripple(mV)',
    ];
    // List<String> eventHeader = [
    //   'Power On',
    //   'Power Off',
    //   '24V High(V)',
    //   '24V Low(V)',
    //   'Temperature High(C)',
    //   'Temperature Low(C)',
    //   'Input RF Power High(dBuV)',
    //   'Input RF Power Low(dBuV)',
    //   '24V Ripple High(mV)',
    //   'Align Loss Pilot',
    //   'AGC Loss Pilot',
    //   'Controll Plug in',
    //   'Controll Plug out',
    // ];

    Sheet log1p8GSheet = excel['Log'];
    // Sheet eventSheet = excel['Event'];

    // eventSheet.insertRowIterables(eventHeader, 0);
    // List<List<String>> eventContent = formatEvent();
    // for (int i = 0; i < eventContent.length; i++) {
    //   List<String> row = eventContent[i];
    //   eventSheet.insertRowIterables(row, i + 1);
    // }

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

  bool _parseSettingResult(List<int> rawData) {
    if (rawData ==
        [
          0xB0,
          0x10,
          0x00,
          0x00,
          0x00,
          0x01,
          0x1A,
          0x28,
        ]) {
      return false;
    } else if (rawData ==
        [
          0xB0,
          0x10,
          0x00,
          0x00,
          0x00,
          0x02,
          0x5A,
          0x29,
        ]) {
      return false;
    } else if (rawData ==
        [
          0xB0,
          0x10,
          0x00,
          0x90,
          0x00,
          0x03,
          0x9B,
          0xE9,
        ]) {
      return false;
    } else {
      return true;
    }
  }

  double _convertToFahrenheit(double celcius) {
    double fahrenheit = (celcius * 1.8) + 32;
    return fahrenheit;
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
  }
}
