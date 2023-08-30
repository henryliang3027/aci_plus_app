import 'package:dsim_app/repositories/unit_converter.dart';

enum TemperatureUnit {
  fahrenheit,
  celsius,
}

class UnitRepository {
  UnitRepository({required TemperatureUnit temperatureUnit})
      : _temperatureUnit = temperatureUnit,
        _unitConverter = UnitConverter();

  final UnitConverter _unitConverter;
  TemperatureUnit _temperatureUnit;

  TemperatureUnit get temperatureUnit => _temperatureUnit;

  set temperatureUnit(TemperatureUnit temperatureUnit) {
    _temperatureUnit = temperatureUnit;
  }

  double convertStrCelciusToFahrenheit(String strCelcius) {
    return _unitConverter.convertStrCelciusToFahrenheit(strCelcius);
  }

  double convertStrFahrenheitToCelcius(String strFahrenheit) {
    return _unitConverter.convertStrFahrenheitToCelcius(strFahrenheit);
  }
}
