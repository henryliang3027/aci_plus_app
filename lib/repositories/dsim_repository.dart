import 'dart:async';
import 'dart:io';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

enum ScanStatus {
  success,
  failure,
}

class DsimRepository {
  DsimRepository() : _ble = FlutterReactiveBle();
  final FlutterReactiveBle _ble;
  final List<DiscoveredDevice> _devices = [];
  late DiscoveredDevice? _currentDevice;

  late StreamSubscription<DiscoveredDevice> _scanStreamSubscription;
  late StreamSubscription<ConnectionStateUpdate>? _connectionStreamSubscription;

  Stream<DiscoveredDevice> scanDevices() async* {
    yield* _ble.scanForDevices(withServices: []);
  }

  void connectDevice() {
    _connectionStreamSubscription = _ble
        .connectToDevice(
            id: _currentDevice!.id,
            connectionTimeout: const Duration(
              seconds: 3,
            ))
        .listen((connectionStateUpdate) async {
      if (connectionStateUpdate.connectionState ==
          DeviceConnectionState.connected) {
        List<DiscoveredService> deviceServices = await _ble.discoverServices(
          _currentDevice!.id,
        );

        for (DiscoveredService deviceService in deviceServices) {
          print('service id: ${deviceService.serviceId}');
          print('service id: ${deviceService.characteristicIds}');
          print('service id: ${deviceService.characteristics}');
        }
      }
    }, onError: (error) {
      print('Error: $error');
    });
  }
}
