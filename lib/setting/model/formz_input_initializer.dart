import 'package:aci_plus_app/setting/model/custom_input.dart';

RangeFloatPointInput initialRangeFloatPointInput(
  String value, {
  double minValue = double.negativeInfinity,
  double maxValue = double.infinity,
}) {
  if (value.isEmpty) {
    // 在初始化的時候,若為空值則不進行內容判斷, 顯示 errorText
    return RangeFloatPointInput.pure(
      minValue: minValue,
      maxValue: maxValue,
    );
  } else {
    return RangeFloatPointInput.dirty(
      value,
      minValue: minValue,
      maxValue: maxValue,
    );
  }
}
