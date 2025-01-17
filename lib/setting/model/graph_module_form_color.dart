import 'package:aci_plus_app/core/custom_style.dart';
import 'package:flutter/material.dart';

Color getGraphModuleFormBackgroundColor({
  required BuildContext context,
  // required bool isIsolatedWidget,
  required bool isForwardWidget,
  required bool isReverseWidget,
}) {
  if (isForwardWidget) {
    // 如果是下行模組, 就將背景設為淺藍色,
    return Theme.of(context).brightness == Brightness.light
        ? CustomStyle.customBlue
        : CustomStyle.customDeepBlue;
  } else if (isReverseWidget) {
    // 如果是上行模組, 就將背景設為粉紅色
    return Theme.of(context).brightness == Brightness.light
        ? CustomStyle.customPink
        : CustomStyle.customDeepPink;
  }
  // else if (isIsolatedWidget) {
  //   // 如果是獨立的模組(split option), 就將背景設為預設
  //   return Theme.of(context).dialogBackgroundColor;
  // }
  else {
    // 其他情況都就將背景設為預設, 代表無任何控制項, 一般不會跑到這情況
    return Theme.of(context).dialogBackgroundColor;
  }
}
