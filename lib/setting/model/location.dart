import 'package:formz/formz.dart';

enum LocationValidationError { formatError }

class Location extends FormzInput<String, LocationValidationError> {
  const Location.pure() : super.pure('');
  const Location.dirty([String value = '']) : super.dirty(value);

  @override
  LocationValidationError? validator(String? value) {
    if (value == null) {
      return LocationValidationError.formatError;
    } else {
      if (value.isEmpty) {
        return LocationValidationError.formatError;
      } else {
        return null;
      }
    }
  }
}
