import 'package:aci_plus_app/app.dart';
import 'package:aci_plus_app/repositories/aci_device_repository.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/repositories/ble_client.dart';
import 'package:aci_plus_app/repositories/code_repository.dart';
import 'package:aci_plus_app/repositories/config_repository.dart';
import 'package:aci_plus_app/repositories/connection_client_factory.dart';
import 'package:aci_plus_app/repositories/distribution_config.dart';
import 'package:aci_plus_app/repositories/dsim_repository.dart';
import 'package:aci_plus_app/repositories/firmware_repository.dart';
import 'package:aci_plus_app/repositories/gps_repository.dart';
import 'package:aci_plus_app/repositories/mock/mock_client.dart';
import 'package:aci_plus_app/repositories/mock/mock_config_repository.dart';
import 'package:aci_plus_app/repositories/mock/sample_aci_device_repository.dart';
import 'package:aci_plus_app/repositories/mock/sample_amp18_repository.dart';
import 'package:aci_plus_app/repositories/mock/sample_dsim_repository.dart';
import 'package:aci_plus_app/repositories/node_config.dart';
import 'package:aci_plus_app/repositories/platform_streategy_factory.dart';
import 'package:aci_plus_app/repositories/trunk_config.dart';
import 'package:aci_plus_app/repositories/unit_repository.dart';
import 'package:aci_plus_app/repositories/usb_client.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock 客戶端
class MockBLEClient extends BLEClient {}

class MockUSBClient extends USBClient {}

// Fake 類別
class FakeTrunkConfig extends Fake implements TrunkConfig {}

class FakeDistributionConfig extends Fake implements DistributionConfig {}

class FakeNodeConfig extends Fake implements NodeConfig {}

/// 為所有測試設置 fallback 值
void setupMocktailFallbacks() {
  registerFallbackValue(FakeTrunkConfig());
  registerFallbackValue(FakeDistributionConfig());
  registerFallbackValue(FakeNodeConfig());
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    setupMocktailFallbacks();
  });

  group('Testing App', () {
    testWidgets('Test information', (tester) async {
      // Arrange
      final mockClient = MockClient();
      final testStrategy = TestStrategy(
        shouldMonitorUsb: false,
        mockClient: mockClient,
      );

      PlatformStrategyFactory.setTestStrategy(testStrategy);

      await ConnectionClientFactory.initialize();

      await tester.pumpWidget(App(
        savedAdaptiveThemeMode: AdaptiveThemeMode.light,
        aciDeviceRepository: SampleACIDeviceRepository(),
        dsimRepository: SampleDsimRepository(),
        amp18Repository: SampleAmp18Repository(),
        amp18CCorNodeRepository: Amp18CCorNodeRepository(),
        unitRepository: UnitRepository(),
        gpsRepository: GPSRepository(),
        configRepository: MockConfigRepository(),
        firmwareRepository: FirmwareRepository(),
        codeRepository: CodeRepository(),
      ));
    });
  });
}
