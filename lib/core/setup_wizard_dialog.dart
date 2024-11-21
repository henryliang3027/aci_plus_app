import 'package:aci_plus_app/core/custom_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum FunctionDescriptionType {
  device,
  threshold,
  balance,
  status,
  information,
  dataLog,
  rfLevel,
  deviceSetting,
  firmwareUpdate,
  userActivityLog,
}

Future<void> showSetupWizardDialog(
  BuildContext context,
  FunctionDescriptionType functionDescriptionType,
) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      var width = MediaQuery.of(context).size.width;
      // var height = MediaQuery.of(context).size.height;

      return Dialog(
        child: Column(
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
                AppLocalizations.of(context)!.setupWizardFunctionDescription,
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
                      getInstructionRow(
                        context: context,
                        functionDescriptionType: functionDescriptionType,
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
        ),
      );
    },
  );
}

List<String> getDescriptions({
  required BuildContext context,
  required FunctionDescriptionType functionDescriptionType,
}) {
  switch (functionDescriptionType) {
    case FunctionDescriptionType.device:
      return [
        AppLocalizations.of(context)!.devicePageSetupWizard1,
        AppLocalizations.of(context)!.devicePageSetupWizard2,
        AppLocalizations.of(context)!.devicePageSetupWizard3,
        AppLocalizations.of(context)!.devicePageSetupWizard4,
      ];
    case FunctionDescriptionType.threshold:
      return [
        AppLocalizations.of(context)!.thresholdPageSetupWizard1,
        AppLocalizations.of(context)!.thresholdPageSetupWizard2,
      ];
    case FunctionDescriptionType.balance:
      return [
        AppLocalizations.of(context)!.balancePageSetupWizard1,
        AppLocalizations.of(context)!.balancePageSetupWizard2,
        AppLocalizations.of(context)!.balancePageSetupWizard3,
      ];
    case FunctionDescriptionType.status:
      return [
        AppLocalizations.of(context)!.statusPageSetupWizard1,
        AppLocalizations.of(context)!.statusPageSetupWizard2,
        AppLocalizations.of(context)!.statusPageSetupWizard3,
      ];
    case FunctionDescriptionType.information:
      return [
        AppLocalizations.of(context)!.informationPageSetupWizard1,
        AppLocalizations.of(context)!.informationPageSetupWizard2,
        AppLocalizations.of(context)!.informationPageSetupWizard3,
        AppLocalizations.of(context)!.informationPageSetupWizard4,
        AppLocalizations.of(context)!.informationPageSetupWizard5,
      ];

    case FunctionDescriptionType.dataLog:
      return [
        AppLocalizations.of(context)!.dataLogPageSetupWizard1,
        AppLocalizations.of(context)!.dataLogPageSetupWizard2,
        AppLocalizations.of(context)!.dataLogPageSetupWizard3,
      ];
    case FunctionDescriptionType.rfLevel:
      return [
        AppLocalizations.of(context)!.rfLevelPageSetupWizard1,
        AppLocalizations.of(context)!.rfLevelPageSetupWizard2,
        AppLocalizations.of(context)!.rfLevelPageSetupWizard3,
      ];

    case FunctionDescriptionType.deviceSetting:
      return [
        AppLocalizations.of(context)!.deviceSettingPageSetupWizard1,
        AppLocalizations.of(context)!.deviceSettingPageSetupWizard2,
      ];

    case FunctionDescriptionType.firmwareUpdate:
      return [
        AppLocalizations.of(context)!.firmwareUpdatePageSetupWizard1,
        AppLocalizations.of(context)!.firmwareUpdatePageSetupWizard2,
        AppLocalizations.of(context)!.firmwareUpdatePageSetupWizard3,
      ];

    case FunctionDescriptionType.userActivityLog:
      return [
        AppLocalizations.of(context)!.userActivityLogPageSetupWizard1,
        AppLocalizations.of(context)!.userActivityLogPageSetupWizard2,
        AppLocalizations.of(context)!.userActivityLogPageSetupWizard3,
      ];

    default:
      return [];
  }
}

Widget getInstructionRow({
  required BuildContext context,
  required FunctionDescriptionType functionDescriptionType,
}) {
  List<String> descriptions = getDescriptions(
    context: context,
    functionDescriptionType: functionDescriptionType,
  );

  return ListBody(
    children: [
      for (int i = 0; i < descriptions.length; i++) ...[
        Padding(
          padding: const EdgeInsets.only(
            bottom: 10.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment:
                CrossAxisAlignment.baseline, // Align based on text baseline
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${i + 1}. ',
                style: const TextStyle(
                  fontSize: CustomStyle.sizeL,
                ),
              ),
              Flexible(
                child: Text(
                  descriptions[i],
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
  );
}
