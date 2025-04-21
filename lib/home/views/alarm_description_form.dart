import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/home/bloc/alarm_description/alarm_description_bloc.dart';
import 'package:aci_plus_app/repositories/unit_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AlarmDescriptionForm extends StatelessWidget {
  const AlarmDescriptionForm({super.key});

  @override
  Widget build(BuildContext context) {
    RichText getRichText({
      required String text,
      required String value,
      required String unit,
    }) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$text ($unit): ',
              style: const TextStyle(
                fontSize: CustomStyle.sizeL,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                  fontSize: CustomStyle.sizeL,
                  color: CustomStyle.alarmColor[Alarm.danger.name]!),
            ),
          ],
        ),
      );
    }

    List<RichText> getDescriptions({
      required TemperatureUnit temperatureUnit,
      required List<SeverityIndex> severityIndexValueList,
    }) {
      List<RichText> alarmDescriptionList = [];
      for (SeverityIndex severityIndexValue in severityIndexValueList) {
        int index = severityIndexValue.index;
        String value = severityIndexValue.value;

        if (index == 0) {
          String unit = temperatureUnit == TemperatureUnit.celsius
              ? CustomStyle.celciusUnit
              : CustomStyle.fahrenheitUnit;
          RichText richText = getRichText(
              text: AppLocalizations.of(context)!
                  .dialogMessageTemperatureAlarmDescription,
              value: value,
              unit: unit);
          alarmDescriptionList.add(richText);
        } else if (index == 1) {
          RichText richText = getRichText(
            text: AppLocalizations.of(context)!
                .dialogMessageVoltageAlarmDescription,
            value: value,
            unit: CustomStyle.volt,
          );
          alarmDescriptionList.add(richText);
        } else if (index == 2) {
          RichText richText = getRichText(
            text: AppLocalizations.of(context)!
                .dialogMessageVoltageRippleAlarmDescription,
            value: value,
            unit: CustomStyle.milliVolt,
          );
          alarmDescriptionList.add(richText);
        } else if (index == 3) {
          RichText richText = getRichText(
            text: AppLocalizations.of(context)!
                .dialogMessageRFOutputPowerAlarmDescription,
            value: value,
            unit: CustomStyle.dBmV,
          );
          alarmDescriptionList.add(richText);
        } else if (index == 4) {
          RichText richText = getRichText(
            text: AppLocalizations.of(context)!
                .dialogMessageRFOutputPilotLowFrequencyDescription,
            value: value,
            unit: CustomStyle.dBmV,
          );
          alarmDescriptionList.add(richText);
        } else if (index == 5) {
          RichText richText = getRichText(
            text: AppLocalizations.of(context)!
                .dialogMessageRFOutputPilotHighFrequencyDescription,
            value: value,
            unit: CustomStyle.dBmV,
          );
          alarmDescriptionList.add(richText);
        } else {}
      }

      return alarmDescriptionList;
    }

    return BlocBuilder<AlarmDescriptionBloc, AlarmDescriptionState>(
      builder: (context, state) {
        List<RichText> alarmDescriptions = getDescriptions(
          temperatureUnit: state.temperatureUnit,
          severityIndexValueList: state.severityIndexValueList,
        );
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
                                crossAxisAlignment: CrossAxisAlignment
                                    .baseline, // Align based on text baseline
                                textBaseline: TextBaseline.alphabetic,
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
