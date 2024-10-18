import 'dart:async';

import 'package:aci_plus_app/core/command.dart';
import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/crc16_calculate.dart';
import 'package:aci_plus_app/repositories/aci_device_repository.dart';
import 'package:aci_plus_app/repositories/ble_client_base.dart';
import 'package:aci_plus_app/repositories/ble_factory.dart';
import 'package:aci_plus_app/repositories/ble_peripheral.dart';

class SampleACIDeviceRepository extends ACIDeviceRepository {
  SampleACIDeviceRepository() : _bleClient = BLEClientFactory.instance;

  final BLEClientBase _bleClient;
  final StreamController<ScanReport> _scanReportStreamController =
      StreamController<ScanReport>();

  final StreamController<ConnectionReport> _connectionReportStreamController =
      StreamController<ConnectionReport>();

  @override
  Stream<ScanReport> get scanReport async* {
    for (int i = 0; i < 1; i++) {
      await Future.delayed(Duration(milliseconds: 500));

      // _scanReportStreamController.add(
      //   ScanReport(
      //     scanStatus: ScanStatus.scanning,
      //     peripheral: Peripheral(
      //       id: '1234567',
      //       name: 'ACI1234567${i.toString()}',
      //       rssi: -60,
      //     ),
      //   ),
      // );

      yield ScanReport(
        scanStatus: ScanStatus.scanning,
        peripheral: Peripheral(
          id: '1234567',
          name: 'ACI1234567${i.toString()}',
          rssi: -60,
        ),
      );
    }

    yield* _scanReportStreamController.stream;
  }

  @override
  Stream<ConnectionReport> get connectionStateReport async* {
    _connectionReportStreamController.add(const ConnectionReport(
      connectStatus: ConnectStatus.connected,
    ));

    yield* _connectionReportStreamController.stream;
  }

  @override
  Future<void> connectToDevice(Peripheral peripheral) {
    return Future.delayed(Duration.zero);
  }

  @override
  Future<void> closeScanStream() async {
    if (!_scanReportStreamController.isClosed) {
      await _scanReportStreamController.close();
    }

    await Future.delayed(Duration.zero);
  }

  @override
  Future<void> closeConnectionStream() async {
    await Future.delayed(Duration.zero);
  }

  @override
  Future<dynamic> getACIDeviceType({
    required String deviceId,
    int mtu = 247,
  }) async {
    return Future.delayed(Duration.zero).then((_) {
      return [
        true,
        ACIDeviceType.amp1P8G,
      ];
    });
  }
}
