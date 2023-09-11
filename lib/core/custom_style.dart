import 'dart:ui';

import 'package:flutter/material.dart';

class CustomStyle {
  static const double sizeS = 12.0;
  static const double sizeM = 14.0;
  static const double sizeL = 16.0;
  static const double sizeXL = 18.0;
  static const double sizeXXL = 20.0; // app bar title
  static const double diameter = 23;

  static const Color customRed = Color(0xffdc3545);
  static const Color customGreen = Color(0xff28a745);
  static const Color customGrey = Color(0xff6c757d);

  static const String fahrenheitUnit = 'ºF';
  static const String celciusUnit = 'ºC';
  static const String milliVolt = 'mV';
  static const String volt = 'V';
  static const String dBmV = 'dBmV';

  static const Map<String, Color> alarmColor = {
    'success': Color(0xff28a745), //success
    'danger': Color(0xffdc3545), //danger
    'medium': Color(0xff6c757d), //medium
    'default': Color(0xff6c757d), //default
  };
}
