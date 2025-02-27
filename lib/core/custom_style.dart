import 'package:flutter/material.dart';

class CustomStyle {
  static const double sizeXS = 10.0;
  static const double sizeS = 12.0;
  static const double sizeM = 14.0;
  static const double sizeL = 16.0;
  static const double sizeXL = 18.0;
  static const double sizeXXL = 20.0; // app bar title
  static const double size24 = 24.0; // dialog title
  static const double size28 = 28.0;
  static const double size32 = 32.0;
  static const double size34 = 34.0;
  static const double size36 = 36.0;
  static const double size4XL = 40.0;
  static const double diameter = 23;
  static const double formBottomSpacingL = 220;
  static const double formBottomSpacingS = 120;

  static const Color customRed = Color(0xFFDC3545);
  static const Color customGreen = Color(0xFF28A745);
  static const Color customGrey = Color(0xFF6C757D);
  static const Color customYellow = Color(0xFFFFAA00);
  static const Color customSettingCardYellow =
      Color.fromARGB(255, 255, 165, 45);

  static const Color customBlue = Color.fromARGB(255, 220, 243, 255);
  static const Color customPink = Color.fromARGB(255, 255, 235, 235);
  static const Color customDeepBlue = Color.fromARGB(255, 4, 18, 53);
  static const Color customDeepPink = Color.fromARGB(255, 72, 0, 25);
  static const Color customSecondaryTileColor =
      Color.fromARGB(255, 239, 239, 239);
  static const Color customDeepSecondaryLileColor =
      Color.fromARGB(255, 59, 62, 68);

  static const double graphSettingCardElevation = 0.0;
  static const Color graphSettingCardColor = Colors.transparent;

  static const String fahrenheitUnit = 'ºF';
  static const String celciusUnit = 'ºC';
  static const String milliAmps = 'mA';
  static const String milliVolt = 'mV';
  static const String volt = 'V';
  static const String dBmV = 'dBmV';
  static const String dB = 'dB';
  static const String mHz = 'MHz';
  static const String gHz = 'GHz';
  static const String bytes = 'Bytes';

  static const Map<String, Color> alarmColor = {
    'success': Color(0xff28a745),
    'danger': Color(0xffdc3545),
    'medium': Color(0xff6c757d),
    'default': Color(0xff6c757d),
    'mask': Colors.black,
  };
}
