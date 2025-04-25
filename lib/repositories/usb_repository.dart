import 'package:aci_plus_app/core/command.dart';
import 'package:aci_plus_app/core/crc16_calculate.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/repositories/amp18_parser.dart';
import 'package:aci_plus_app/repositories/ble_client_base.dart';
import 'package:aci_plus_app/repositories/ble_peripheral.dart';
import 'package:aci_plus_app/repositories/usb_client.dart';

class USBRepository {
  USBRepository()
      : _usbClient = USBClient(),
        _amp18Parser = Amp18Parser();

  final BLEClientBase _usbClient;
  final Amp18Parser _amp18Parser;

  Stream<ScanReport> get scanReport async* {
    yield* _usbClient.scanReport;
  }

  Stream<ConnectionReport> get connectionStateReport async* {
    yield* _usbClient.connectionStateReport;
  }

  Future<void> connectToDevice(Peripheral peripheral) {
    return _usbClient.connectToDevice(peripheral);
  }

  Future<dynamic> getInformation() async {
    CRC16.calculateCRC16(command: Command.req00Cmd, usDataLength: 6);

    try {
      List<int> rawData = await _usbClient.writeSetCommandToCharacteristic(
        commandIndex: -1,
        value: Command.req00Cmd,
      );

      A1P8G0 a1p8g0 = _amp18Parser.decodeA1P8G0(rawData);

      print('Device time: ${a1p8g0.nowDateTime}');

      Map<DataKey, String> characteristicDataCache = {
        DataKey.partName: a1p8g0.partName,
        DataKey.partNo: a1p8g0.partNo,
        DataKey.partId: a1p8g0.partId,
        DataKey.serialNumber: a1p8g0.serialNumber,
        DataKey.firmwareVersion: a1p8g0.firmwareVersion,
        DataKey.hardwareVersion: a1p8g0.hardwareVersion,
        DataKey.mfgDate: a1p8g0.mfgDate,
        DataKey.coordinates: a1p8g0.coordinate,
        DataKey.nowDateTime: a1p8g0.nowDateTime,
        DataKey.bluetoothDelayTime: a1p8g0.bluetoothDelayTime,
      };

      // _characteristicDataCache.addAll(characteristicDataCache);

      return [
        true,
        characteristicDataCache,
      ];
    } catch (e) {
      return [
        false,
      ];
    }
  }
}
