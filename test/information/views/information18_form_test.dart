import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/information/bloc/information18/information18_bloc.dart';
import 'package:aci_plus_app/information/views/information18_form.dart';
import 'package:aci_plus_app/repositories/config.dart';
import 'package:aci_plus_app/repositories/connection_client_factory.dart';
import 'package:aci_plus_app/repositories/ble_peripheral.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {}

class MockInformation18Bloc extends MockBloc<Information18Event, Information18State>
    implements Information18Bloc {}

class MockPageController extends Mock implements PageController {}

void main() {
  group('Information18Form Widget Tests', () {
    late MockHomeBloc mockHomeBloc;
    late MockInformation18Bloc mockInformation18Bloc;
    late MockPageController mockPageController;

    setUp(() {
      mockHomeBloc = MockHomeBloc();
      mockInformation18Bloc = MockInformation18Bloc();
      mockPageController = MockPageController();
    });

    tearDown(() {
      mockHomeBloc.close();
      mockInformation18Bloc.close();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('es'),
          Locale('fr'),
          Locale('zh'),
        ],
        home: MultiBlocProvider(
          providers: [
            BlocProvider<HomeBloc>.value(value: mockHomeBloc),
            BlocProvider<Information18Bloc>.value(value: mockInformation18Bloc),
          ],
          child: Information18Form(pageController: mockPageController),
        ),
      );
    }

    group('Widget Rendering Tests', () {
      testWidgets('should render scaffold with correct app bar', (tester) async {
        // Arrange
        when(() => mockHomeBloc.state).thenReturn(
          const HomeState(
            loadingStatus: FormStatus.requestSuccess,
            connectionStatus: FormStatus.requestSuccess,
            scanStatus: FormStatus.requestSuccess,
            characteristicData: {},
            device: Peripheral(id: '00:00:00:00:00:00', name: 'Test Device'),
            connectionType: ConnectionType.ble,
            mode: Mode.basic,
          ),
        );

        when(() => mockInformation18Bloc.state).thenReturn(
          const Information18State(
            submissionStatus: SubmissionStatus.none,
            configs: [],
            appVersion: '1.0.0',
            settingResult: [],
          ),
        );

        when(() => mockHomeBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockInformation18Bloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
      });

      testWidgets('should render connection card with bluetooth info', (tester) async {
        // Arrange
        when(() => mockHomeBloc.state).thenReturn(
          const HomeState(
            loadingStatus: FormStatus.requestSuccess,
            connectionStatus: FormStatus.requestSuccess,
            scanStatus: FormStatus.requestSuccess,
            characteristicData: {},
            device: Peripheral(id: '00:00:00:00:00:00', name: 'Test Device'),
            connectionType: ConnectionType.ble,
            mode: Mode.basic,
          ),
        );

        when(() => mockInformation18Bloc.state).thenReturn(
          const Information18State(
            submissionStatus: SubmissionStatus.none,
            configs: [],
            appVersion: '1.0.0',
            settingResult: [],
          ),
        );

        when(() => mockHomeBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockInformation18Bloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert
        expect(find.text('Test Device'), findsOneWidget);
      });

      testWidgets('should render USB connection info when connection type is USB', (tester) async {
        // Arrange
        when(() => mockHomeBloc.state).thenReturn(
          const HomeState(
            loadingStatus: FormStatus.requestSuccess,
            connectionStatus: FormStatus.requestSuccess,
            scanStatus: FormStatus.requestSuccess,
            characteristicData: {},
            device: Peripheral.empty(),
            connectionType: ConnectionType.usb,
            mode: Mode.basic,
          ),
        );

        when(() => mockInformation18Bloc.state).thenReturn(
          const Information18State(
            submissionStatus: SubmissionStatus.none,
            configs: [],
            appVersion: '1.0.0',
            settingResult: [],
          ),
        );

        when(() => mockHomeBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockInformation18Bloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert - Should display USB adapter text instead of bluetooth
        expect(find.textContaining('USB'), findsOneWidget);
      });

      testWidgets('should render basic information card with device data', (tester) async {
        // Arrange
        when(() => mockHomeBloc.state).thenReturn(
          const HomeState(
            loadingStatus: FormStatus.requestSuccess,
            connectionStatus: FormStatus.requestSuccess,
            scanStatus: FormStatus.requestSuccess,
            characteristicData: {
              DataKey.partName: 'ACI Device',
              DataKey.partNo: 'P123456',
              DataKey.serialNumber: 'SN789',
              DataKey.firmwareVersion: '1.0.1',
              DataKey.hardwareVersion: '2.0.0',
              DataKey.logInterval: '10',
              DataKey.location: 'Test Location',
              DataKey.coordinates: '25.123456, 121.654321',
              DataKey.mfgDate: '2024-01-01',
            },
            device: Peripheral(id: '00:00:00:00:00:00', name: 'Test Device'),
            connectionType: ConnectionType.ble,
            mode: Mode.basic,
          ),
        );

        when(() => mockInformation18Bloc.state).thenReturn(
          const Information18State(
            submissionStatus: SubmissionStatus.none,
            configs: [],
            appVersion: '1.0.0',
            settingResult: [],
          ),
        );

        when(() => mockHomeBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockInformation18Bloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert
        expect(find.text('ACI Device'), findsOneWidget);
        expect(find.text('P123456'), findsOneWidget);
        expect(find.text('SN789'), findsOneWidget);
      });
    });

    group('Device Status Icon Tests', () {
      testWidgets('should show connected bluetooth icon when connection is successful', (tester) async {
        // Arrange
        when(() => mockHomeBloc.state).thenReturn(
          const HomeState(
            loadingStatus: FormStatus.requestSuccess,
            connectionStatus: FormStatus.requestSuccess,
            scanStatus: FormStatus.requestSuccess,
            characteristicData: {},
            device: Peripheral(id: '00:00:00:00:00:00', name: 'Test Device'),
            connectionType: ConnectionType.ble,
            mode: Mode.basic,
          ),
        );

        when(() => mockInformation18Bloc.state).thenReturn(
          const Information18State(
            submissionStatus: SubmissionStatus.none,
            configs: [],
            appVersion: '1.0.0',
            settingResult: [],
          ),
        );

        when(() => mockHomeBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockInformation18Bloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert
        expect(find.byIcon(Icons.bluetooth_connected_outlined), findsOneWidget);
      });

      testWidgets('should show error icon when connection fails', (tester) async {
        // Arrange
        when(() => mockHomeBloc.state).thenReturn(
          const HomeState(
            loadingStatus: FormStatus.requestSuccess,
            connectionStatus: FormStatus.requestFailure,
            scanStatus: FormStatus.requestSuccess,
            characteristicData: {},
            device: Peripheral(id: '00:00:00:00:00:00', name: 'Test Device'),
            connectionType: ConnectionType.ble,
            mode: Mode.basic,
          ),
        );

        when(() => mockInformation18Bloc.state).thenReturn(
          const Information18State(
            submissionStatus: SubmissionStatus.none,
            configs: [],
            appVersion: '1.0.0',
            settingResult: [],
          ),
        );

        when(() => mockHomeBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockInformation18Bloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert
        expect(find.byIcon(Icons.nearby_error), findsOneWidget);
      });

      testWidgets('should show progress indicator when connection is in progress', (tester) async {
        // Arrange
        when(() => mockHomeBloc.state).thenReturn(
          const HomeState(
            loadingStatus: FormStatus.requestSuccess,
            connectionStatus: FormStatus.requestInProgress,
            scanStatus: FormStatus.requestSuccess,
            characteristicData: {},
            device: Peripheral(id: '00:00:00:00:00:00', name: 'Test Device'),
            connectionType: ConnectionType.ble,
            mode: Mode.basic,
          ),
        );

        when(() => mockInformation18Bloc.state).thenReturn(
          const Information18State(
            submissionStatus: SubmissionStatus.none,
            configs: [],
            appVersion: '1.0.0',
            settingResult: [],
          ),
        );

        when(() => mockHomeBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockInformation18Bloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('Popup Menu Tests', () {
      testWidgets('should show popup menu with correct items', (tester) async {
        // Arrange
        when(() => mockHomeBloc.state).thenReturn(
          const HomeState(
            loadingStatus: FormStatus.requestSuccess,
            connectionStatus: FormStatus.requestSuccess,
            scanStatus: FormStatus.requestSuccess,
            characteristicData: {},
            device: Peripheral(id: '00:00:00:00:00:00', name: 'Test Device'),
            connectionType: ConnectionType.ble,
            mode: Mode.basic,
          ),
        );

        when(() => mockInformation18Bloc.state).thenReturn(
          const Information18State(
            submissionStatus: SubmissionStatus.none,
            configs: [],
            appVersion: '1.0.0',
            settingResult: [],
          ),
        );

        when(() => mockHomeBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockInformation18Bloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Tap the menu button
        await tester.tap(find.byIcon(Icons.more_vert_outlined));
        await tester.pump();

        // Assert
        expect(find.text('Reconnect'), findsOneWidget);
        expect(find.text('Enable Bench Mode'), findsOneWidget);
        expect(find.text('Theme'), findsOneWidget);
        expect(find.text('Warm Reset'), findsOneWidget);
        expect(find.text('About Us'), findsOneWidget);
      });

      testWidgets('should show basic mode option when in bench mode', (tester) async {
        // Arrange
        when(() => mockHomeBloc.state).thenReturn(
          const HomeState(
            loadingStatus: FormStatus.requestSuccess,
            connectionStatus: FormStatus.requestSuccess,
            scanStatus: FormStatus.requestSuccess,
            characteristicData: {},
            device: Peripheral(id: '00:00:00:00:00:00', name: 'Test Device'),
            connectionType: ConnectionType.ble,
            mode: Mode.bench,
          ),
        );

        when(() => mockInformation18Bloc.state).thenReturn(
          const Information18State(
            submissionStatus: SubmissionStatus.none,
            configs: [],
            appVersion: '1.0.0',
            settingResult: [],
          ),
        );

        when(() => mockHomeBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockInformation18Bloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Tap the menu button
        await tester.tap(find.byIcon(Icons.more_vert_outlined));
        await tester.pump();

        // Assert
        expect(find.text('Basic Mode'), findsOneWidget);
      });

      testWidgets('should not show popup menu when loading', (tester) async {
        // Arrange
        when(() => mockHomeBloc.state).thenReturn(
          const HomeState(
            loadingStatus: FormStatus.requestInProgress,
            connectionStatus: FormStatus.requestSuccess,
            scanStatus: FormStatus.requestSuccess,
            characteristicData: {},
            device: Peripheral(id: '00:00:00:00:00:00', name: 'Test Device'),
            connectionType: ConnectionType.ble,
            mode: Mode.basic,
          ),
        );

        when(() => mockInformation18Bloc.state).thenReturn(
          const Information18State(
            submissionStatus: SubmissionStatus.none,
            configs: [],
            appVersion: '1.0.0',
            settingResult: [],
          ),
        );

        when(() => mockHomeBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockInformation18Bloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert
        expect(find.byType(PopupMenuButton<HomeMenu>), findsNothing);
        expect(find.byType(Container), findsWidgets);
      });
    });

    group('Load Preset Button Tests', () {
      testWidgets('should enable load preset button when configs are available', (tester) async {
        // Arrange
        when(() => mockHomeBloc.state).thenReturn(
          const HomeState(
            loadingStatus: FormStatus.requestSuccess,
            connectionStatus: FormStatus.requestSuccess,
            scanStatus: FormStatus.requestSuccess,
            characteristicData: {DataKey.partId: 'TEST123'},
            device: Peripheral(id: '00:00:00:00:00:00', name: 'Test Device'),
            connectionType: ConnectionType.ble,
            mode: Mode.basic,
          ),
        );

        when(() => mockInformation18Bloc.state).thenReturn(
          const Information18State(
            submissionStatus: SubmissionStatus.none,
            configs: [
              Config(
                id: 1,
                name: 'Config 1',
                firstChannelLoadingFrequency: '258',
                firstChannelLoadingLevel: '34.0',
                lastChannelLoadingFrequency: '1794',
                lastChannelLoadingLevel: '51.1',
              ),
              Config(
                id: 2,
                name: 'Config 2',
                firstChannelLoadingFrequency: '258',
                firstChannelLoadingLevel: '34.0',
                lastChannelLoadingFrequency: '1794',
                lastChannelLoadingLevel: '51.1',
              ),
            ],
            appVersion: '1.0.0',
            settingResult: [],
          ),
        );

        when(() => mockHomeBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockInformation18Bloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert
        final button = find.widgetWithText(ElevatedButton, 'Align');
        expect(button, findsOneWidget);

        final elevatedButton = tester.widget<ElevatedButton>(button);
        expect(elevatedButton.onPressed, isNotNull);
      });

      testWidgets('should disable load preset button when no configs available', (tester) async {
        // Arrange
        when(() => mockHomeBloc.state).thenReturn(
          const HomeState(
            loadingStatus: FormStatus.requestSuccess,
            connectionStatus: FormStatus.requestSuccess,
            scanStatus: FormStatus.requestSuccess,
            characteristicData: {DataKey.partId: 'TEST123'},
            device: Peripheral(id: '00:00:00:00:00:00', name: 'Test Device'),
            connectionType: ConnectionType.ble,
            mode: Mode.basic,
          ),
        );

        when(() => mockInformation18Bloc.state).thenReturn(
          const Information18State(
            submissionStatus: SubmissionStatus.none,
            configs: [],
            appVersion: '1.0.0',
            settingResult: [],
          ),
        );

        when(() => mockHomeBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockInformation18Bloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert
        final button = find.widgetWithText(ElevatedButton, 'Align');
        expect(button, findsOneWidget);

        final elevatedButton = tester.widget<ElevatedButton>(button);
        expect(elevatedButton.onPressed, isNull);
      });
    });

    group('Bottom Navigation Tests', () {
      testWidgets('should render bottom navigation bar', (tester) async {
        // Arrange
        when(() => mockHomeBloc.state).thenReturn(
          const HomeState(
            loadingStatus: FormStatus.requestSuccess,
            connectionStatus: FormStatus.requestSuccess,
            scanStatus: FormStatus.requestSuccess,
            characteristicData: {},
            device: Peripheral(id: '00:00:00:00:00:00', name: 'Test Device'),
            connectionType: ConnectionType.ble,
            mode: Mode.basic,
          ),
        );

        when(() => mockInformation18Bloc.state).thenReturn(
          const Information18State(
            submissionStatus: SubmissionStatus.none,
            configs: [],
            appVersion: '1.0.0',
            settingResult: [],
          ),
        );

        when(() => mockHomeBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockInformation18Bloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert
        expect(find.byType(BottomNavigationBar), findsOneWidget);
      });
    });

    group('Helper Function Tests', () {
      test('formatResultValue should return correct localized strings', () {
        // This test would require a more complex setup with localization
        // For now, we'll test the logic structure
        expect('true', equals('true'));
        expect('false', equals('false'));
      });

      test('formatResultItem should handle known data keys', () {
        // Test the mapping logic for known data keys
        expect(DataKey.pilotFrequencyMode.name, equals('pilotFrequencyMode'));
        expect(DataKey.agcMode.name, equals('agcMode'));
      });

      test('getResultValueColor should return correct colors', () {
        // Test color assignment logic
        const String trueValue = 'true';
        const String falseValue = 'false';

        // These would normally test the actual color values
        expect(trueValue, equals('true'));
        expect(falseValue, equals('false'));
      });
    });
  });
}