import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void setPreferredOrientation() {
  double screenWidth = WidgetsBinding
      .instance.platformDispatcher.views.first.physicalSize.shortestSide;

  print('screenWidth: $screenWidth');

  if (screenWidth <= 1290) {
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
