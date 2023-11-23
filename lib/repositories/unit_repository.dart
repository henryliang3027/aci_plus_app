import 'package:aci_plus_app/repositories/unit_converter.dart';

enum TemperatureUnit {
  fahrenheit,
  celsius,
}

class UnitRepository {
  UnitRepository()
      : _temperatureUnit = TemperatureUnit.fahrenheit, // 預設顯示華氏溫度
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
