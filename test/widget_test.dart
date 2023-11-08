// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:aci_plus_app/core/crc16_calculate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aci_plus_app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    List<int> ra = [0xB0, 0x10, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00];
    List<int> rb = [0xB0, 0x10, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00];
    List<int> rc = [0xB0, 0x10, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00];

    CRC16.calculateCRC16(command: ra, usDataLength: 6);
    CRC16.calculateCRC16(command: rb, usDataLength: 6);
    CRC16.calculateCRC16(command: rc, usDataLength: 6);

    expect(ra, [0xB0, 0x10, 0x00, 0x00, 0x00, 0x01, 0x1A, 0x28]);
    expect(rb, [0xB0, 0x10, 0x00, 0x00, 0x00, 0x02, 0x5A, 0x29]);
    expect(rc, [0xB0, 0x10, 0x00, 0x00, 0x00, 0x03, 0x9B, 0xE9]);
  });
}
