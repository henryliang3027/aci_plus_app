import 'dart:io';
import 'dart:typed_data';

import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/notice_dialog.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

const int winBeta = int.fromEnvironment('WIN_BETA', defaultValue: 7);

enum CEQStatus {
  none,
  from1P2GTo1P8G,
  from1P8GTo1P2G,
}

class FirmwareUpdateProperty {
  static int previousVersion = 0;
}

// 用在 update firmware 時 disable android 的 system back button
class SystemBackButtonProperty {
  static bool isEnabled = true;
}

// 用在 update firmware 時判斷有沒有斷線
class CrossPageFlag {
  static bool isDisconnectOnFirmwareUpdate = false;
}

// 用在 setting 頁面的列表和圖形化介面, 判斷 EQ 模組是否有更換
class ForwardCEQFlag {
  static String forwardCEQType = 'N/A';
}

// 用在 setting 頁面的 device 子頁面, 紀錄是否離開了該頁面

class NoticeFlag {
  static bool leftDevicePage = false;
}

class RegexUtil {
  // (?:\{[^{}]*\}) matches one instance of the map pattern.
  // \{ matches the opening curly brace {.
  // [^{}]* matches any characters except { and } zero or more times.
  // \} matches the closing curly brace }.
  // (?:,\{[^{}]*\}){0,4} matches zero to four instances of the pattern preceded by a comma ,.
  static final RegExp configJsonRegex = RegExp(
      r'^((?:\{[^{}]*\})?(?:,\{[^{}]*\}){0,4})\s((?:\{[^{}]*\})?(?:,\{[^{}]*\}){0,4})\s((?:\{[^{}]*\})?(?:,\{[^{}]*\}){0,4})$');

  static final RegExp configJsonRegex220 = RegExp(
      r'^((?:\{[^{}]*\})?(?:,\{[^{}]*\}){0,4})\s((?:\{[^{}]*\})?(?:,\{[^{}]*\}){0,4})$');
}

class BLEUtils {
  // 取得藍牙 mtu size
  static Future<int> getChunkSize() async {
    // ios version < 16 mtu 為 182, 其餘為 244
    // android 為 247, 3 個 byte 用在 header, 所以實際可容納的量為 244

    if (Platform.isIOS) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;

      // ipad version ex: 16.6.1
      // ios version ex: 16.5
      double version = double.parse(iosDeviceInfo.systemVersion.split('.')[0]);

      if (version < 16) {
        return 182;
      } else {
        return 244;
      }
    } else {
      // android or windows
      return 244;
    }
  }

  // 將資料切割為每一塊都是 mtu size 的大小的數個區塊
  static List<List<int>> divideToChunkList({
    required List<int> binary,
    required int chunkSize,
  }) {
    List<List<int>> chunks = [];
    for (int i = 0; i < binary.length; i += chunkSize) {
      int end = (i + chunkSize < binary.length) ? i + chunkSize : binary.length;
      chunks.add(binary.sublist(i, end));
    }
    return chunks;
  }
}

void setPreferredOrientation() {
  double screenWidth = WidgetsBinding
      .instance.platformDispatcher.views.first.physicalSize.shortestSide;

  print('screenWidth: $screenWidth');

  if (screenWidth <= 1440) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  } else {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }
}

//  對 ipad 無作用, ipad 可以隨意旋轉
void setFullScreenOrientation() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
}

String adjustMinDoubleValue({
  required String current,
  required String min,
}) {
  double doubleCurrentValue = double.parse(current);
  double doubleMinValue = double.parse(min);
  return doubleMinValue < doubleCurrentValue
      ? doubleMinValue.toString()
      : doubleCurrentValue.toString();
}

String adjustMaxDoubleValue({
  required String current,
  required String max,
}) {
  double doubleCurrentValue = double.parse(current);
  double doubleMaxValue = double.parse(max);
  return doubleMaxValue > doubleCurrentValue
      ? doubleMaxValue.toString()
      : doubleCurrentValue.toString();
}

String adjustMinIntValue({
  required String current,
  required String min,
}) {
  int intCurrentValue = int.parse(current);
  int intMinValue = int.parse(min);
  return intMinValue < intCurrentValue
      ? intMinValue.toString()
      : intCurrentValue.toString();
}

String adjustMaxIntValue({
  required String current,
  required String max,
}) {
  int intCurrentValue = int.parse(current);
  int intMaxValue = int.parse(max);
  return intMaxValue > intCurrentValue
      ? intMaxValue.toString()
      : intCurrentValue.toString();
}

PopupMenuItem<T> menuItem<T>({
  required T value,
  required IconData iconData,
  required String title,
  required VoidCallback onTap,
  bool enabled = true,
}) {
  // 使用 Builder 來解決當 PopupMenu 開著的時候切換主題時能即時改變 Icon 顏色
  return PopupMenuItem<T>(
    value: value,
    enabled: enabled,
    onTap: onTap,
    child: Builder(
      builder: (context) => Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            iconData,
            size: 20.0,
            color: Theme.of(context).iconTheme.color,
          ),
          const SizedBox(
            width: 10.0,
          ),
          Text(title),
        ],
      ),
    ),
  );
}

String getOperatingModeFromForwardCEQIndex(String index) {
  int? intIndex = int.tryParse(index);

  if (intIndex != null) {
    if (intIndex >= 0 && intIndex <= 24) {
      return '1.8';
    } else if (intIndex == 120) {
      return '1.2';
    } else if (intIndex == 180) {
      return '1.8';
    } else if (intIndex == 255) {
      return '1.8'; // N/A
    } else {
      return '1.8'; // N/A
    }
  } else {
    return '1.8'; // N/A
  }
}

String getCEQTypeFromForwardCEQIndex(String index) {
  int intIndex = int.parse(index);

  if (intIndex >= 0 && intIndex <= 24) {
    return '1.8';
  } else if (intIndex == 120) {
    return '1.2';
  } else if (intIndex == 180) {
    return '1.8';
  } else if (intIndex == 255) {
    return 'N/A';
  } else {
    return 'N/A';
  }
}

Future<String> getAppVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  // 給部門內測試的版本會加 -beta版本文字, 例如V 2.1.2-beta2
  String appVersion = 'V ${packageInfo.version}';
  return appVersion;
}

int convertFirmwareVersionStringToInt(String strFirmwareVersion) {
  if (strFirmwareVersion.length == 3) {
    return int.tryParse(strFirmwareVersion) ?? 0;
  } else if (strFirmwareVersion.length > 3) {
    String number = strFirmwareVersion.substring(0, 3);
    return int.tryParse(number) ?? 0;
  } else {
    return 0;
  }
}

// 解碼以 2 個 byte 表示的字元
String decodeUnicodeToString(Uint8List byteValues) {
  // 使用 unicode 解析 byte 格式的字串
  String strValue = '';
  for (int i = 0; i < byteValues.length; i += 2) {
    Uint8List bytes = Uint8List.fromList([byteValues[i], byteValues[i + 1]]);

    // Extract the bytes and create the Unicode code point
    int lowerByte = bytes[0];
    int upperByte = bytes[1];
    int unicodeCodePoint = (upperByte << 8) | lowerByte;

    // Convert the Unicode code point to a string
    String chineseCharacter = String.fromCharCode(unicodeCodePoint);
    strValue += chineseCharacter;
  }

  return strValue;
}

// 刪除所有 Null character (0x00), 頭尾空白 character
String trimString(String s) {
  s = s.replaceAll('\x00', '');
  s = s.trim();
  return s;
}

// 編碼以 2 個 byte 表示的字元
List<int> convertStringToInt16List(String value) {
  List<int> int16bytes = [];

  for (int code in value.codeUnits) {
    // Create a ByteData object with a length of 2 bytes
    ByteData byteData = ByteData(2);

    // Set the Unicode code unit in the byte array
    byteData.setInt16(0, code, Endian.little);

    // Convert the ByteData to a Uint8List
    Uint8List bytes = Uint8List.view(byteData.buffer);

    int16bytes.addAll(bytes);
  }

  return int16bytes;
}

void checkUnfilledItem({
  required BuildContext context,
  required Map<DataKey, String> characteristicData,
}) {
  int firmwareVersion = convertFirmwareVersionStringToInt(
      characteristicData[DataKey.firmwareVersion] ?? '0');

  if (NoticeFlag.leftDevicePage && firmwareVersion >= 148) {
    List<DataKey> unFilledItems = getUnFilledItem(
      context: context,
      characteristicData: characteristicData,
    );

    if (unFilledItems.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 100), () {
        showUnfilledItemDialog(
          context: context,
          unFilledItems: unFilledItems,
        );

        NoticeFlag.leftDevicePage = false;
      });
    }
  }
}

Future<void> handleUpdateAction({
  required BuildContext context,
  required Bloc targetBloc,
  required VoidCallback action,
  required bool Function(dynamic state)? waitForState,
  bool isResumeUpdate = true,
}) async {
  final homeBloc = context.read<HomeBloc>();

  if (homeBloc.state.periodicUpdateEnabled) {
    // Dispatch the cancel event
    homeBloc.add(const DevicePeriodicUpdateCanceled());

    // Wait for the HomeBloc to emit the cancelled state

    await homeBloc.stream
        .firstWhere((state) => state.periodicUpdateEnabled == false);
  }

  action();

  if (isResumeUpdate) {
    if (waitForState != null) {
      await targetBloc.stream.firstWhere(waitForState);
      homeBloc.add(const DevicePeriodicUpdateRequested());
    }
  }
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
