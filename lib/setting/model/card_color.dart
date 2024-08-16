import 'package:flutter/material.dart';

Color? getSettingListCardColor({
  required BuildContext context,
  required bool isTap,
}) {
  if (isTap) {
    // 取得淺色模式與深色模式各自的顏色
    return Theme.of(context).cardColor;
  } else {
    // 回傳 null 的話 card 會使用預設顏色
    return null;
  }
}
