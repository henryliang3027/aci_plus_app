import 'package:flutter/material.dart';

class CustomStyle {
  static const double sizeS = 12.0;
  static const double sizeM = 14.0;
  static const double sizeL = 16.0;
  static const double sizeXL = 18.0;
  static const double sizeXXL = 20.0; // app bar title
  static const double size32 = 32.0;
  static const double size36 = 36.0;
  static const double size4XL = 40.0;
  static const double diameter = 23;

  static const Color customRed = Color(0xffdc3545);
  static const Color customGreen = Color(0xff28a745);
  static const Color customGrey = Color(0xff6c757d);
  static const Color customYellow = Color(0xFFFFAA00);
  static const Color customBlue = Color.fromARGB(255, 220, 243, 255);
  static const Color customPink = Color.fromARGB(255, 255, 230, 222);

  static const String fahrenheitUnit = 'ºF';
  static const String celciusUnit = 'ºC';
  static const String milliAmps = 'mA';
  static const String milliVolt = 'mV';
  static const String volt = 'V';
  static const String dBmV = 'dBmV';
  static const String dB = 'dB';
  static const String mHz = 'MHz';
  static const String bytes = 'Bytes';

  static const Map<String, Color> alarmColor = {
    'success': Color(0xff28a745),
    'danger': Color(0xffdc3545),
    'medium': Color(0xff6c757d),
    'default': Color(0xff6c757d),
    'mask': Colors.black,
  };
}
