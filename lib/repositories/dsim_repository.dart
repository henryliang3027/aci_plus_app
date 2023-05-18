import 'dart:async';
import 'dart:io';
import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/crc16_calculate.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';

enum ScanStatus {
  success,
  failure,
  disable,
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
  DsimRepository() : _ble = FlutterReactiveBle() {
    _calculateCRCs();
  }
  final FlutterReactiveBle _ble;
  final scanDuration = 3; // sec
  late StreamController<ScanReport> _scanReportStreamController;
  StreamSubscription<DiscoveredDevice>? _discoveredDeviceStreamSubscription;
  StreamSubscription<ConnectionStateUpdate>? _connectionStreamSubscription;
  StreamSubscription<List<int>>? _characteristicStreamSubscription;

  final _name1 = 'ACI03170078';
  final _name2 = 'ACI01160006';
  final _serviceId = 'ffe0';
  final _characteristicId = 'ffe1';

  Stream<ScanReport> get scannedDevices async* {
    bool isPermissionGranted = await requestPermission();
    if (isPermissionGranted) {
      await BluetoothEnable.enableBluetooth;
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
      }, onError: (_) {
        _scanReportStreamController.add(
          const ScanReport(
            scanStatus: ScanStatus.disable,
            discoveredDevice: null,
          ),
        );
      });
      yield* _scanReportStreamController.stream.timeout(
          Duration(
            seconds: scanDuration,
          ), onTimeout: (sink) {
        print('Stop Scanning');
        _scanReportStreamController.add(
          const ScanReport(
            scanStatus: ScanStatus.failure,
            discoveredDevice: null,
          ),
        );
      });
    } else {
      yield const ScanReport(
        scanStatus: ScanStatus.failure,
        discoveredDevice: null,
      );
    }
  }

  Future<void> closeScanStream() async {
    print('closeScanStream');
    _scanReportStreamController.close();
    await _discoveredDeviceStreamSubscription?.cancel();
    _discoveredDeviceStreamSubscription = null;
  }

  Future<void> closeConnectionStream() async {
    print('closeConnectionStream');

    await _characteristicStreamSubscription?.cancel();
    _characteristicStreamSubscription = null;
    await _connectionStreamSubscription?.cancel();
    _connectionStreamSubscription = null;
  }

  void connectDevice(DiscoveredDevice discoveredDevice) {
    print('connect to ${discoveredDevice.name}, ${discoveredDevice.id}');
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

        final qualifiedCharacteristic = QualifiedCharacteristic(
          serviceId: Uuid.parse(_serviceId),
          characteristicId: Uuid.parse(_characteristicId),
          deviceId: discoveredDevice.id,
        );

        _characteristicStreamSubscription = _ble
            .subscribeToCharacteristic(qualifiedCharacteristic)
            .listen((data) {
          print('-----data received-----');
          print(data);

          List<int> rawData = data;
          String strData = '';
          strData = rawData.map((e) => String.fromCharCode(e)).join('');
          print(strData);
        });

        _writeCommands(qualifiedCharacteristic);
      }
    }, onError: (error) {
      print('Error: $error');
    });
  }

  Future<void> _writeCommands(
    QualifiedCharacteristic qualifiedCharacteristic,
  ) async {
    await _ble.writeCharacteristicWithoutResponse(
      qualifiedCharacteristic,
      value: Command.req00Cmd,
    );

    // await _ble.writeCharacteristicWithoutResponse(
    //   qualifiedCharacteristic,
    //   value: Command.req01Cmd,
    // );

    // await _ble.writeCharacteristicWithoutResponse(
    //   qualifiedCharacteristic,
    //   value: Command.req02Cmd,
    // );
  }

  void _calculateCRCs() {
    CRC16.calculateCRC16(command: Command.req00Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.req01Cmd, usDataLength: 6);
    CRC16.calculateCRC16(command: Command.req02Cmd, usDataLength: 6);
    print('decrypted command');
    print(Command.req00Cmd);
    print(Command.req01Cmd);
    print(Command.req02Cmd);
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
