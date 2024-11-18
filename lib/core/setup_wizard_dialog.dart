import 'package:aci_plus_app/core/custom_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> showSetupWizardDialog(
  BuildContext context,
  List<String> descriptions,
) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      var width = MediaQuery.of(context).size.width;
      // var height = MediaQuery.of(context).size.height;

      return AlertDialog(
        // insetPadding: EdgeInsets.symmetric(
        //   horizontal: width * 0.1,
        // ),
        title: Text(
          AppLocalizations.of(context)!.setupWizardFunctionDescription,
        ),
        content: SizedBox(
          width: width,
          child: Padding(
            padding: const EdgeInsets.only(top: CustomStyle.sizeL),
            child: SingleChildScrollView(
              child: ListBody(
                children: [
                  for (int i = 0; i < descriptions.length; i++) ...[
                    getInstructionRow(
                      context: context,
                      number: '${i + 1}.'.toString(),
                      description: descriptions[i],
                    ),
                  ]
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text(
              AppLocalizations.of(context)!.dialogMessageOk,
            ),
            onPressed: () {
              Navigator.of(context).pop(true); // pop dialog
            },
          ),
        ],
      );
    },
  );
}

Widget getInstructionRow({
  required BuildContext context,
  required String number,
  required String description,
}) {
  return Padding(
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
          number,
          style: const TextStyle(
            fontSize: CustomStyle.sizeL,
          ),
        ),
        Flexible(
          child: Text(
            description,
            style: const TextStyle(
              fontSize: CustomStyle.sizeL,
            ),
          ),
        ),
      ],
    ),
  );
}
