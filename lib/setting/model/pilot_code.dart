import 'package:formz/formz.dart';

enum PilotCodeValidationError { formatError }

class PilotCode extends FormzInput<String, PilotCodeValidationError> {
  const PilotCode.pure() : super.pure('');
  const PilotCode.dirty([String value = '']) : super.dirty(value);

  @override
  PilotCodeValidationError? validator(String? value) {
    RegExp pilotCodeRegex = RegExp(r'^[A-Z@?].*(<A|<@)(?!(<A|<@))$');

    if (value != null && value.isNotEmpty) {
      if (!pilotCodeRegex.hasMatch(value)) {
        return PilotCodeValidationError.formatError;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
