import 'dart:async';
import 'dart:typed_data';

import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/repositories/usb_client_base.dart';
import 'package:usb_serial/usb_serial.dart';

class UsbClient extends UsbClientBase {
  UsbClient();

  UsbPort? _usbPort;
  int _currentCommandIndex = 0;

  Completer<dynamic>? _completer;
  Timer? _streamDataTimer;

  StreamController<bool>? _connectionStateController;
  Stream<bool> get connectionState => _connectionStateController!.stream;

  @override
  Future<bool> connectToDevice() async {
    List<UsbDevice> devices = await UsbSerial.listDevices();
    print(devices);

    if (devices.isEmpty) {
      return false;
    }

    _usbPort = await devices.first.create();

    if (_usbPort == null) {
      print("Port is null");
      return false;
    }

    bool openResult = await _usbPort!.open();
    if (!openResult) {
      print("Failed to open");
      return false;
    }

    await _usbPort!.setDTR(true);
    await _usbPort!.setRTS(true);

    _usbPort!.setPortParameters(
      115200,
      UsbPort.DATABITS_8,
      UsbPort.STOPBITS_1,
      UsbPort.PARITY_NONE,
    );

    // print first result and close port.
    _usbPort!.inputStream!.listen((Uint8List event) {
      print(event);
    });

    return true;
  }

  @override
  Future writeSetCommandToCharacteristic({
    required int commandIndex,
    required List<int> value,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    _currentCommandIndex = commandIndex;

    _completer = Completer<dynamic>();

    startCharacteristicDataTimer(
      timeout: timeout,
      commandIndex: commandIndex,
    );

    Future.microtask(() async {
      try {
        // 寫入資料到 USB
        await _usbPort!.write(Uint8List.fromList(value));
      } catch (e) {
        cancelCharacteristicDataTimer(
            name:
                'cmd $commandIndex, ${CharacteristicError.writeDataError.name}');
        if (!_completer!.isCompleted) {
          print('writeCharacteristic failed: ${e.toString()}');
          _completer!.completeError(CharacteristicError.writeDataError.name);
        }
      }
    });

    return _completer!.future;
  }

  void startCharacteristicDataTimer({
    required Duration timeout,
    required int commandIndex,
  }) {
    _streamDataTimer = Timer(timeout, () {
      if (!_completer!.isCompleted) {
        _completer!.completeError(CharacteristicError.timeoutOccured);
        print('cmd:$commandIndex Timeout occurred');
      }
    });
  }

  void cancelCharacteristicDataTimer({required String name}) {
    if (_streamDataTimer != null) {
      _streamDataTimer!.cancel();
    }

    print('$name CharacteristicDataTimer has been canceled');
  }

  void closeConnectionStream() {
    // _isConnected = false;
    // _connectionStateController?.close();
    _usbPort?.close();
    _usbPort = null;
  }
}
