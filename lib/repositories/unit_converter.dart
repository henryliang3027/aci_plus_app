class UnitConverter {
  double convertStrCelciusToFahrenheit(String strCelcius) {
    double celcius = double.parse(strCelcius);
    double fahrenheit = (celcius * 1.8) + 32;
    return fahrenheit;
  }

  double convertStrFahrenheitToCelcius(String strFahrenheit) {
    double fahrenheit = double.parse(strFahrenheit);
    double celcius = (fahrenheit - 32) * 0.5555556;
    return celcius;
  }

  double converCelciusToFahrenheit(double celcius) {
    double fahrenheit = (celcius * 1.8) + 32;
    return fahrenheit;
  }

  double convertFahrenheitToCelcius(double fahrenheit) {
    double celcius = (fahrenheit - 32) * 0.5555556;
    return celcius;
  }
}
