import 'package:aci_plus_app/setting/model/custom_input.dart';

RangeIntegerInput initialRangeIntegerInput(
  String value, {
  int minValue = 0,
  int maxValue = 9999,
}) {
  if (value.isEmpty) {
    // 在初始化的時候,若為空值則不進行內容判斷, 顯示 errorText
    return RangeIntegerInput.pure(
      minValue: minValue,
      maxValue: maxValue,
    );
  } else {
    return RangeIntegerInput.dirty(
      value,
      minValue: minValue,
      maxValue: maxValue,
    );
  }
}

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
    double? floatValue = double.tryParse(value) ?? 0.0;
    if (floatValue > maxValue || floatValue < minValue) {
      floatValue = 0.0;
    }

    return RangeFloatPointInput.dirty(
      floatValue.toString(),
      minValue: minValue,
      maxValue: maxValue,
    );
  }
}
