import 'package:aci_plus_app/repositories/ble_client.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';

class MockFlutterReactiveBle extends Mock implements FlutterReactiveBle {}

class MockPermission extends Mock implements Permission {}

class MockBluetoothEnableWrapper extends Mock
    implements BluetoothEnableWrapper {}

class TestBLEClient extends BLEClient {
  @override
  Future<bool> requestPermission() async {
    return true; // 在測試中直接返回 true 或 false 以模擬不同情況
  }
}

void main() {
  late BLEClient bleClient;
  late MockFlutterReactiveBle mockFlutterReactiveBle;
  late MockBluetoothEnableWrapper mockBluetoothEnableWrapper;
  late MockPermission mockPermission;

  setUp(() {
    mockFlutterReactiveBle = MockFlutterReactiveBle();
    mockPermission = MockPermission();
    bleClient = BLEClient();
    mockBluetoothEnableWrapper = MockBluetoothEnableWrapper();
  });

  // 測試當藍牙已啟用且授權已授權時
  test('should check if Bluetooth is enabled and permissions are granted',
      () async {
    // 模擬 _requestPermission 返回 true
    when(() => bleClient.requestPermission()).thenAnswer((_) async => true);

    // 模擬 BluetoothEnable 返回 'true'
    when(() => mockBluetoothEnableWrapper.enableBluetooth())
        .thenAnswer((_) async => 'true');

    final result = await bleClient.checkBluetoothEnabled();

    expect(result, true);
  });

  // 測試當藍牙未啟用時
  test('should fail if Bluetooth is not enabled', () async {
    when(() => mockPermission.request())
        .thenAnswer((_) async => PermissionStatus.granted);
    when(() => BluetoothEnable.enableBluetooth)
        .thenAnswer((_) async => 'false');

    final result = await bleClient.checkBluetoothEnabled();

    expect(result, false);
  });

  // 測試當藍牙權限未授權時
  test('should fail if Bluetooth permissions are not granted', () async {
    when(() => mockPermission.request())
        .thenAnswer((_) async => PermissionStatus.denied);

    final result = await bleClient.checkBluetoothEnabled();

    expect(result, false);
  });
}
