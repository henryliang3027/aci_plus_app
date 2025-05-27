import 'dart:async';

import 'package:aci_plus_app/core/command.dart';
import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/crc16_calculate.dart';
import 'package:aci_plus_app/repositories/aci_device_repository.dart';
import 'package:aci_plus_app/repositories/connection_client.dart';
import 'package:aci_plus_app/repositories/connection_client_factory.dart';
import 'package:aci_plus_app/repositories/ble_peripheral.dart';

class SampleACIDeviceRepository extends ACIDeviceRepository {
  SampleACIDeviceRepository()
      : _connectionClient = ConnectionClientFactory.instance;

  final ConnectionClient _connectionClient;
  StreamController<ScanReport>? _scanReportStreamController;

  StreamController<ConnectionReport>? _connectionReportStreamController;

  @override
  Stream<ScanReport> get scanReport async* {
    _scanReportStreamController = StreamController<ScanReport>();
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

    yield* _scanReportStreamController!.stream;
  }

  @override
  Stream<ConnectionReport> get connectionStateReport async* {
    _connectionReportStreamController = StreamController<ConnectionReport>();

    yield const ConnectionReport(
      connectStatus: ConnectStatus.connected,
    );

    yield* _connectionReportStreamController!.stream;
  }

  @override
  Future<void> connectToDevice(Peripheral peripheral) {
    return Future.delayed(Duration.zero);
  }

  @override
  Future<void> closeScanStream() async {
    if (_scanReportStreamController != null) {
      if (!_scanReportStreamController!.isClosed) {
        await _scanReportStreamController!.close();
        _scanReportStreamController = null;
      }
    }

    await Future.delayed(Duration.zero);
  }

  @override
  Future<void> closeConnectionStream() async {
    if (_connectionReportStreamController != null) {
      if (!_connectionReportStreamController!.isClosed) {
        await _connectionReportStreamController!.close();
        _connectionReportStreamController = null;
      }
    }

    await Future.delayed(Duration.zero);
  }

  @override
  Future<dynamic> getACIDeviceType({
    required String deviceId,
    int mtu = 244,
  }) async {
    return Future.delayed(Duration.zero).then((_) {
      return [
        true,
        ACIDeviceType.amp1P8G,
      ];
    });
  }
}
