import 'package:aci_plus_app/app.dart';
import 'package:aci_plus_app/repositories/aci_device_repository.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/repositories/code_repository.dart';
import 'package:aci_plus_app/repositories/config_repository.dart';
import 'package:aci_plus_app/repositories/dsim_repository.dart';
import 'package:aci_plus_app/repositories/firmware_repository.dart';
import 'package:aci_plus_app/repositories/gps_repository.dart';
import 'package:aci_plus_app/repositories/unit_repository.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Testing App', () {
    testWidgets('Favorites operations test', (tester) async {
      await tester.pumpWidget(App(
        savedAdaptiveThemeMode: AdaptiveThemeMode.light,
        aciDeviceRepository: ACIDeviceRepository(),
        dsimRepository: DsimRepository(),
        amp18Repository: Amp18Repository(),
        amp18CCorNodeRepository: Amp18CCorNodeRepository(),
        unitRepository: UnitRepository(),
        gpsRepository: GPSRepository(),
        configRepository: ConfigRepository(),
        firmwareRepository: FirmwareRepository(),
        codeRepository: CodeRepository(),
      ));

      // final iconKeys = [
      //   'icon_0',
      //   'icon_1',
      //   'icon_2',
      // ];

      // for (var icon in iconKeys) {
      //   await tester.tap(find.byKey(ValueKey(icon)));
      //   await tester.pumpAndSettle(const Duration(seconds: 1));

      //   expect(find.text('Added to favorites.'), findsOneWidget);
      // }

      // await tester.tap(find.text('Favorites'));
      // await tester.pumpAndSettle();

      // final removeIconKeys = [
      //   'remove_icon_0',
      //   'remove_icon_1',
      //   'remove_icon_2',
      // ];

      // for (final iconKey in removeIconKeys) {
      //   await tester.tap(find.byKey(ValueKey(iconKey)));
      //   await tester.pumpAndSettle(const Duration(seconds: 1));

      //   expect(find.text('Removed from favorites.'), findsOneWidget);
      // }
    });
  });
}
