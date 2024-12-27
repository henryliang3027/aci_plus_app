import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

const int winBeta = int.fromEnvironment('WIN_BETA', defaultValue: 7);

// 用在 update firmware 時 disable android 的 system back button
class SystemBackButtonProperty {
  static bool isEnabled = true;
}

// 用在 update firmware 時判斷有哪有斷線
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
  String appVersion = 'V ${packageInfo.version}-beta6';
  return appVersion;
}

int convertFirmwareVersionStringToInt(String strFirmwareVersion) {
  return int.tryParse(strFirmwareVersion) ?? 0;
}
