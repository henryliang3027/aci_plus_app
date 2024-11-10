import 'package:aci_plus_app/core/custom_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> showSetupWizardDialog(
  BuildContext context,
) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      var width = MediaQuery.of(context).size.width;
      // var height = MediaQuery.of(context).size.height;

      return AlertDialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: width * 0.1,
        ),
        title: Text(
          AppLocalizations.of(context)!.dialogTitleSuccess,
        ),
        content: SizedBox(
          width: width,
          child: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  AppLocalizations.of(context)!.dialogMessageSaveSuccessful,
                  style: const TextStyle(
                    fontSize: CustomStyle.sizeL,
                  ),
                ),
              ],
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
