import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/home/bloc/alarm_description/alarm_description_bloc.dart';
import 'package:aci_plus_app/repositories/unit_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AlarmDescriptionForm extends StatelessWidget {
  const AlarmDescriptionForm({super.key});

  @override
  Widget build(BuildContext context) {
    Text getText({
      required String text,
      required String value,
      required String unit,
    }) {
      return Text.rich(TextSpan(
        children: [
          TextSpan(
            text: '$text ($unit): ',
            style: const TextStyle(
              fontSize: CustomStyle.sizeL,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
                fontSize: CustomStyle.sizeL,
                color: CustomStyle.alarmColor[Alarm.danger.name]!),
          ),
        ],
      ));
    }

    List<Text> getAmpDescriptions({
      required TemperatureUnit temperatureUnit,
      required List<SeverityIndex> severityIndexValueList,
    }) {
      List<Text> alarmDescriptionList = [];
      for (SeverityIndex severityIndexValue in severityIndexValueList) {
        int index = severityIndexValue.index;
        String value = severityIndexValue.value;

        if (index == 0) {
          String unit = temperatureUnit == TemperatureUnit.celsius
              ? CustomStyle.celciusUnit
              : CustomStyle.fahrenheitUnit;
          Text text = getText(
              text: AppLocalizations.of(context)!
                  .dialogMessageTemperatureAlarmDescription,
              value: value,
              unit: unit);
          alarmDescriptionList.add(text);
        } else if (index == 1) {
          Text text = getText(
            text: AppLocalizations.of(context)!
                .dialogMessageVoltageAlarmDescription,
            value: value,
            unit: CustomStyle.volt,
          );
          alarmDescriptionList.add(text);
        } else if (index == 2) {
          Text text = getText(
            text: AppLocalizations.of(context)!
                .dialogMessageVoltageRippleAlarmDescription,
            value: value,
            unit: CustomStyle.milliVolt,
          );
          alarmDescriptionList.add(text);
        } else if (index == 3) {
          Text text = getText(
            text: AppLocalizations.of(context)!
                .dialogMessageRFOutputPowerAlarmDescription,
            value: value,
            unit: CustomStyle.dBmV,
          );
          alarmDescriptionList.add(text);
        } else if (index == 4) {
          String rfLevel = getRFLevelString(context: context, rfLevel: value);
          Text text = getText(
            text: AppLocalizations.of(context)!
                .dialogMessageRFOutputPilotLowFrequencyDescription,
            value: rfLevel,
            unit: CustomStyle.dBmV,
          );
          alarmDescriptionList.add(text);
        } else if (index == 5) {
          String rfLevel = getRFLevelString(context: context, rfLevel: value);
          Text text = getText(
            text: AppLocalizations.of(context)!
                .dialogMessageRFOutputPilotHighFrequencyDescription,
            value: rfLevel,
            unit: CustomStyle.dBmV,
          );
          alarmDescriptionList.add(text);
        } else {}
      }

      return alarmDescriptionList;
    }

    List<Text> getNodeDescriptions({
      required TemperatureUnit temperatureUnit,
      required List<SeverityIndex> severityIndexValueList,
    }) {
      List<Text> alarmDescriptionList = [];
      for (SeverityIndex severityIndexValue in severityIndexValueList) {
        int index = severityIndexValue.index;
        String value = severityIndexValue.value;

        if (index == 0) {
          String unit = temperatureUnit == TemperatureUnit.celsius
              ? CustomStyle.celciusUnit
              : CustomStyle.fahrenheitUnit;
          Text text = getText(
              text: AppLocalizations.of(context)!
                  .dialogMessageTemperatureAlarmDescription,
              value: value,
              unit: unit);
          alarmDescriptionList.add(text);
        } else if (index == 1) {
          Text text = getText(
            text: AppLocalizations.of(context)!
                .dialogMessageVoltageAlarmDescription,
            value: value,
            unit: CustomStyle.volt,
          );
          alarmDescriptionList.add(text);
        } else if (index == 2) {
          Text text = getText(
            text: AppLocalizations.of(context)!
                .dialogMessageRFOutputPower1AlarmDescription,
            value: value,
            unit: CustomStyle.dBmV,
          );
          alarmDescriptionList.add(text);
        } else if (index == 3) {
          Text text = getText(
            text: AppLocalizations.of(context)!
                .dialogMessageRFOutputPower3AlarmDescription,
            value: value,
            unit: CustomStyle.dBmV,
          );
          alarmDescriptionList.add(text);
        } else if (index == 4) {
          Text text = getText(
            text: AppLocalizations.of(context)!
                .dialogMessageRFOutputPower4AlarmDescription,
            value: value,
            unit: CustomStyle.dBmV,
          );
          alarmDescriptionList.add(text);
        } else if (index == 5) {
          Text text = getText(
            text: AppLocalizations.of(context)!
                .dialogMessageRFOutputPower6AlarmDescription,
            value: value,
            unit: CustomStyle.dBmV,
          );
          alarmDescriptionList.add(text);
        } else {}
      }

      return alarmDescriptionList;
    }

    return BlocBuilder<AlarmDescriptionBloc, AlarmDescriptionState>(
      builder: (context, state) {
        List<Text> alarmDescriptions = [];

        if (state.aciDeviceType == ACIDeviceType.amp1P8G) {
          alarmDescriptions = getAmpDescriptions(
            temperatureUnit: state.temperatureUnit,
            severityIndexValueList: state.severityIndexValueList,
          );
        } else {
          alarmDescriptions = getNodeDescriptions(
            temperatureUnit: state.temperatureUnit,
            severityIndexValueList: state.severityIndexValueList,
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.center,
              width: double.maxFinite,
              height: 58,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)),
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                AppLocalizations.of(context)!.dialogTitleAlarmDescription,
                style: TextStyle(
                  fontSize: CustomStyle.sizeXL,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 30, 24, 30),
                  child: Column(
                    children: [
                      ListBody(
                        children: [
                          for (int i = 0;
                              i < alarmDescriptions.length;
                              i++) ...[
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 10.0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                // crossAxisAlignment: CrossAxisAlignment
                                //     .baseline, // Align based on text baseline
                                // textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Flexible(
                                    child: alarmDescriptions[i],
                                  ),
                                ],
                              ),
                            ),
                          ]
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 0.0,
                                  horizontal: 20.0,
                                ),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.dialogMessageOk,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
