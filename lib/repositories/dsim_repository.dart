import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

enum ScanStatus {
  success,
  failure,
}

class ScanReport {
  const ScanReport({
    required this.scanStatus,
    this.discoveredDevice,
  });

  final ScanStatus scanStatus;
  final DiscoveredDevice? discoveredDevice;
}

class DsimRepository {
  DsimRepository() : _ble = FlutterReactiveBle();
  final FlutterReactiveBle _ble;

  late StreamController<ScanReport> _scanReportStreamController;

  late StreamSubscription<ConnectionStateUpdate>? _connectionStreamSubscription;
  late StreamSubscription<DiscoveredDevice>?
      _discoveredDeviceStreamSubscription;

  final _name1 = 'ACI03170078';
  final _name2 = 'ACI01160006';
  final _serviceId = 'ffe0';
  final _characteristicId = 'ffe1';
  final _req00Cmd = [0xB0, 0x03, 0x00, 0x00, 0x00, 0x06, 0xDE, 0x29]; //0

  Stream<ScanReport> get scannedDevices async* {
    bool isPermissionGranted = await requestPermission();
    if (isPermissionGranted) {
      _scanReportStreamController = StreamController<ScanReport>();
      _discoveredDeviceStreamSubscription =
          _ble.scanForDevices(withServices: []).listen((device) {
        if (device.name.startsWith(_name1)) {
          if (!_scanReportStreamController.isClosed) {
            _scanReportStreamController.add(
              ScanReport(
                scanStatus: ScanStatus.success,
                discoveredDevice: device,
              ),
            );
          }
        }
      });
      yield* _scanReportStreamController.stream;
    } else {
      yield const ScanReport(
        scanStatus: ScanStatus.success,
        discoveredDevice: null,
      );
    }
  }

  Future<void> closeScanStream() async {
    print('closeScanStream');
    _scanReportStreamController.close();
    _discoveredDeviceStreamSubscription?.cancel();
    _discoveredDeviceStreamSubscription = null;
  }

  Future<void> closeConnectionStream() async {
    print('closeConnectionStream');
    _connectionStreamSubscription?.cancel();
    _connectionStreamSubscription = null;
  }

  void connectDevice(DiscoveredDevice discoveredDevice) {
    _connectionStreamSubscription = _ble
        .connectToDevice(
            id: discoveredDevice.id,
            connectionTimeout: const Duration(
              seconds: 10,
            ))
        .listen((connectionStateUpdate) async {
      if (connectionStateUpdate.connectionState ==
          DeviceConnectionState.connected) {
        List<DiscoveredService> deviceServices = await _ble.discoverServices(
          discoveredDevice.id,
        );

        for (DiscoveredService deviceService in deviceServices) {
          print('-----------------');
          print('service id: ${deviceService.serviceId}');
          print('characteristicIds: ${deviceService.characteristicIds}');
          print('characteristics: ${deviceService.characteristics}');
        }

        final characteristic = QualifiedCharacteristic(
          serviceId: Uuid.parse(_serviceId),
          characteristicId: Uuid.parse(_characteristicId),
          deviceId: discoveredDevice.id,
        );

        _ble.subscribeToCharacteristic(characteristic).listen((data) {
          print(data);
        });

        _ble
            .writeCharacteristicWithResponse(characteristic, value: _req00Cmd)
            .then((_) async {
          print('write done');

          // final bytes = await _ble.readCharacteristic(characteristic);

          // print(bytes);
        });
      }
    }, onError: (error) {
      print('Error: $error');
    });
  }

  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
      ].request();

      if (statuses.values.contains(PermissionStatus.granted)) {
        return true;
      } else {
        return false;
      }
    } else if (Platform.isIOS) {
      return true;
    } else {
      // neither android nor ios
      return false;
    }
  }
}
