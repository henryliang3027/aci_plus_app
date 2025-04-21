import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/home/bloc/alarm_description/alarm_description_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AlarmDescriptionForm extends StatelessWidget {
  const AlarmDescriptionForm({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> getDescriptions({
      required List<SeverityIndex> severityIndexList,
    }) {
      // List<String> alarmDescriptionList = [
      //   AppLocalizations.of(context)!.dialogMessageTemperatureAlarmDescription,
      //   AppLocalizations.of(context)!.dialogMessageVoltageAlarmDescription,
      //   AppLocalizations.of(context)!
      //       .dialogMessageVoltageRippleAlarmDescription,
      //   AppLocalizations.of(context)!
      //       .dialogMessageRFOutputPowerAlarmDescription,
      //   AppLocalizations.of(context)!
      //       .dialogMessageRFOutputPilotLowFrequencyDescription,
      //   AppLocalizations.of(context)!
      //       .dialogMessageRFOutputPilotHighFrequencyDescription,
      // ];
      List<String> alarmDescriptionList = [];
      for (SeverityIndex severityIndex in severityIndexList) {
        int index = severityIndex.index;
        String value = severityIndex.value;

        if (index == 0) {
          alarmDescriptionList.add(AppLocalizations.of(context)!
              .dialogMessageTemperatureAlarmDescription(value));
        } else if (index == 1) {
          alarmDescriptionList.add(AppLocalizations.of(context)!
              .dialogMessageVoltageAlarmDescription(value));
        } else if (index == 2) {
          alarmDescriptionList.add(AppLocalizations.of(context)!
              .dialogMessageVoltageRippleAlarmDescription(value));
        } else if (index == 3) {
          alarmDescriptionList.add(AppLocalizations.of(context)!
              .dialogMessageRFOutputPowerAlarmDescription(value));
        } else if (index == 4) {
          alarmDescriptionList.add(AppLocalizations.of(context)!
              .dialogMessageRFOutputPilotLowFrequencyDescription(value));
        } else if (index == 5) {
          alarmDescriptionList.add(AppLocalizations.of(context)!
              .dialogMessageRFOutputPilotHighFrequencyDescription(value));
        } else {}
      }

      return alarmDescriptionList;
    }

    return BlocBuilder<AlarmDescriptionBloc, AlarmDescriptionState>(
      builder: (context, state) {
        List<String> alarmDescriptions = getDescriptions(
          severityIndexList: state.severityIndexList,
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
                          // Text(state.temperatureUnit.name),
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
                                    child: Text(
                                      alarmDescriptions[i],
                                      style: const TextStyle(
                                        fontSize: CustomStyle.sizeL,
                                      ),
                                    ),
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
