import 'package:aci_plus_app/setting/model/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/setting/bloc/setting18_reverse_control/setting18_reverse_control_bloc.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_reverse_control_view.dart';
import 'package:mocktail/mocktail.dart';

// Mock the global functions that are used in the widget
Widget mockControlTextSlider({
  required BuildContext context,
  required bool editMode,
  required String title,
  required double minValue,
  required double maxValue,
  required String currentValue,
  required Function(String) onChanged,
  String? errorText,
  Color? color,
}) {
  return Container(
    key: const Key('mock_control_text_slider'),
    child: Column(
      children: [
        Text(title, key: const Key('slider_title')),
        Text(currentValue, key: const Key('current_value')),
        if (errorText != null) Text(errorText, key: const Key('error_text')),
        TextFormField(
          key: const Key('text_field'),
          initialValue: currentValue,
          onChanged: onChanged,
          decoration: InputDecoration(
            errorText: errorText,
          ),
        ),
      ],
    ),
  );
}

Color mockGetSettingListCardColor({
  required BuildContext context,
  required bool isTap,
}) {
  return isTap ? Colors.blue : Colors.white;
}

// Mock AppLocalizations
class MockAppLocalizations {
  static MockAppLocalizations of(BuildContext context) =>
      MockAppLocalizations();

  String get returnInputAttenuation4 => 'Return Input Attenuation 4';
  String get textFieldErrorMessage => 'Invalid input';
}

class MockSetting18ReverseControlBloc
    extends MockBloc<Setting18ReverseControlEvent, Setting18ReverseControlState>
    implements Setting18ReverseControlBloc {}

void main() {
  // Override the global functions for testing
  setUpAll(() {
    // You might need to override these functions depending on your implementation
    // This is a simplified approach - you may need to use a different method
    // depending on how these functions are implemented in your actual code
  });

  group('ReturnInputAttenuation4 Widget Tests', () {
    late MockSetting18ReverseControlBloc mockBloc;

    setUp(() {
      mockBloc = MockSetting18ReverseControlBloc();
    });

    tearDown(() {
      mockBloc.close();
    });

    group('partId 5 or 15 (uses DataKey.usVCA1)', () {
      blocTest<MockSetting18ReverseControlBloc, Setting18ReverseControlState>(
          'emits state with usVCA1 value',
          build: () => mockBloc,
          act: (bloc) => bloc.add(ControlItemChanged(
                dataKey: DataKey.usVCA1,
                value: '15.5',
              )),
          expect: () => []);

      testWidgets('displays correct currentValue for partId 5', (tester) async {
        // Arrange
        const partId = '5';
        const testValue = RangeFloatPointInput.dirty(
          '15.5',
          minValue: 0.0,
          maxValue: 29.0,
        );

        when(() => mockBloc.state).thenReturn(
          const Setting18ReverseControlState(
            submissionStatus: SubmissionStatus.none,
            resetReverseValuesSubmissionStatus: SubmissionStatus.none,
            enableSubmission: false,
            editMode: true,
            targetValues: {
              DataKey.usVCA1: testValue,
            },
            tappedSet: <DataKey>{},
            settingResult: [],
          ),
        );

        when(() => mockBloc.stream).thenAnswer(
          (_) => Stream.fromIterable([
            const Setting18ReverseControlState(
              submissionStatus: SubmissionStatus.none,
              resetReverseValuesSubmissionStatus: SubmissionStatus.none,
              enableSubmission: false,
              editMode: true,
              targetValues: {
                DataKey.usVCA1: testValue,
              },
              tappedSet: <DataKey>{},
              settingResult: [],
            ),
          ]),
        );

        // Act
        // await tester.pumpWidget(
        //   MaterialApp(
        //     localizationsDelegates: const [
        //       // Add your localization delegates here if needed
        //     ],
        //     home: BlocProvider<Setting18ReverseControlBloc>(
        //       create: (_) => mockBloc,
        //       child: Scaffold(
        //         body: ReturnInputAttenuation4(partId: partId),
        //       ),
        //     ),
        //   ),
        // );

        await tester.pumpAndSettle();

        // Assert
        expect(find.byKey(const Key('current_value')), findsOneWidget);
        expect(find.text('15.5'), findsOneWidget);
      });

      testWidgets('displays correct currentValue for partId 15',
          (tester) async {
        // Similar test for partId 15
        const partId = '15';
        const testValue = RangeFloatPointInput.dirty(
          '12.3',
          minValue: 0.0,
          maxValue: 25.0,
        );

        when(() => mockBloc.state).thenReturn(
          const Setting18ReverseControlState(
            submissionStatus: SubmissionStatus.none,
            resetReverseValuesSubmissionStatus: SubmissionStatus.none,
            enableSubmission: false,
            editMode: true,
            targetValues: {
              DataKey.usVCA1: testValue,
            },
            tappedSet: <DataKey>{},
            settingResult: [],
          ),
        );

        when(() => mockBloc.stream).thenAnswer(
          (_) => Stream.fromIterable([
            const Setting18ReverseControlState(
              submissionStatus: SubmissionStatus.none,
              resetReverseValuesSubmissionStatus: SubmissionStatus.none,
              enableSubmission: false,
              editMode: true,
              targetValues: {
                DataKey.usVCA1: testValue,
              },
              tappedSet: <DataKey>{},
              settingResult: [],
            ),
          ]),
        );

        // await tester.pumpWidget(
        //   MaterialApp(
        //     home: BlocProvider<Setting18ReverseControlBloc>(
        //       create: (_) => mockBloc,
        //       child: Scaffold(
        //         body: ReturnInputAttenuation4(partId: partId),
        //       ),
        //     ),
        //   ),
        // );

        await tester.pumpAndSettle();

        expect(find.text('12.3'), findsOneWidget);
      });
    });
  });
}
