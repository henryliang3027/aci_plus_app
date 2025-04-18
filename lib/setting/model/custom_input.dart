import 'package:formz/formz.dart';

enum ValidationError { formatError }

class LocationInpput extends FormzInput<String, ValidationError> {
  const LocationInpput.pure() : super.pure('');
  const LocationInpput.dirty([String value = '']) : super.dirty(value);

  @override
  ValidationError? validator(String? value) {
    if (value == null) {
      return ValidationError.formatError;
    } else {
      if (value.isEmpty) {
        return ValidationError.formatError;
      } else {
        return null;
      }
    }
  }
}

class CoordinateInput extends FormzInput<String, ValidationError> {
  const CoordinateInput.pure() : super.pure('');
  const CoordinateInput.dirty([String value = '']) : super.dirty(value);

  @override
  ValidationError? validator(String? value) {
    RegExp coordinateRegex = RegExp(r'^-?(\d+(\.\d+)?)\s*,\s*-?(\d+(\.\d+)?)$');

    if (value == null) {
      return ValidationError.formatError;
    } else {
      // 如果 value 尚未被更改過(isPure), 則不會跑下列的格式檢查
      if (!coordinateRegex.hasMatch(value) && !isPure) {
        return ValidationError.formatError;
      } else {
        return null;
      }
    }
  }
}

/// 文字輸入框 整數格式
class IntegerInput extends FormzInput<String, ValidationError> {
  const IntegerInput.pure() : super.pure('');
  const IntegerInput.dirty([String value = '']) : super.dirty(value);

  @override
  ValidationError? validator(String value) {
    RegExp integerRegex = RegExp(r'^-?\d+$');

    // 如果 value 尚未被更改過(isPure), 則不會跑下列的格式檢查
    if (!integerRegex.hasMatch(value) && !isPure) {
      return ValidationError.formatError;
    } else {
      return null;
    }
  }

  @override
  String toString() {
    return value;
  }
}

/// 文字輸入框 整數格式有範圍限制
class RangeIntegerInput extends FormzInput<String, ValidationError> {
  const RangeIntegerInput.pure({
    this.minValue = 0,
    this.maxValue = 9999,
  }) : super.pure('');
  const RangeIntegerInput.dirty(
    String value, {
    this.minValue = 0,
    this.maxValue = 9999,
  }) : super.dirty(value);

  final int minValue;
  final int maxValue;

  @override
  ValidationError? validator(String value) {
    RegExp integerRegex = RegExp(r'^-?\d+$');

    // 如果 value 尚未被更改過(isPure), 則不會跑下列的格式檢查
    if (!isPure) {
      if (!integerRegex.hasMatch(value)) {
        return ValidationError.formatError;
      } else {
        // 轉換 value 成浮點數
        int? intValue = int.tryParse(value);

        if (intValue == null) {
          return ValidationError.formatError;
        } else {
          // 檢查值是否在指定範圍內
          if (intValue < minValue || intValue > maxValue) {
            return ValidationError.formatError;
          } else {
            return null;
          }
        }
      }
    } else {
      // isPure
      return null;
    }
  }

  @override
  String toString() {
    return value;
  }
}

/// 文字輸入框 浮點數格式
class FloatPointInput extends FormzInput<String, ValidationError> {
  const FloatPointInput.pure() : super.pure('');
  const FloatPointInput.dirty([String value = '']) : super.dirty(value);

  @override
  ValidationError? validator(String value) {
    RegExp floatPointRegex = RegExp(r'^[+-]?\d+(\.\d+)?$');

    // 如果 value 尚未被更改過(isPure), 則不會跑下列的格式檢查
    if (!floatPointRegex.hasMatch(value) && !isPure) {
      return ValidationError.formatError;
    } else {
      return null;
    }
  }

  @override
  String toString() {
    return value;
  }
}

/// 文字輸入框 浮點數格式有範圍限制
class RangeFloatPointInput extends FormzInput<String, ValidationError> {
  const RangeFloatPointInput.pure({
    this.minValue = double.negativeInfinity,
    this.maxValue = double.infinity,
  }) : super.pure('');
  const RangeFloatPointInput.dirty(
    String value, {
    this.minValue = double.negativeInfinity,
    this.maxValue = double.infinity,
  }) : super.dirty(value);

  final double minValue;
  final double maxValue;

  @override
  ValidationError? validator(String value) {
    RegExp floatPointRegex = RegExp(r'^[+-]?\d+(\.\d+)?$');

    // 如果 value 尚未被更改過(isPure), 則不會跑下列的格式檢查
    if (!isPure) {
      if (!floatPointRegex.hasMatch(value)) {
        return ValidationError.formatError;
      } else {
        // 轉換 value 成浮點數
        double? floatValue = double.tryParse(value);

        if (floatValue == null) {
          return ValidationError.formatError;
        } else {
          // 檢查值是否在指定範圍內
          if (floatValue < minValue || floatValue > maxValue) {
            return ValidationError.formatError;
          } else {
            return null;
          }
        }
      }
    } else {
      // isPure
      return null;
    }
  }

  @override
  String toString() {
    return value;
  }
}

class NameInput extends FormzInput<String, ValidationError> {
  const NameInput.pure() : super.pure('');
  const NameInput.dirty([String value = '']) : super.dirty(value);

  @override
  ValidationError? validator(String value) {
    RegExp nameRegex = RegExp(r'^[a-zA-Z0-9]{1,10}$');

    if (!nameRegex.hasMatch(value)) {
      return ValidationError.formatError;
    } else {
      return null;
    }
  }

  @override
  String toString() {
    return value;
  }
}
