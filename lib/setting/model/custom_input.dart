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
