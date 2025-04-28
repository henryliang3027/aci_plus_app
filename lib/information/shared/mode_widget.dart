import 'package:aci_plus_app/information/shared/mode_Input_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<bool?> showEnterExpertModeDialog({
  required BuildContext context,
}) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return const ModeInputPage();
    },
  );
}

Future<bool?> showToggleBasicModeDialog({
  required BuildContext context,
}) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          AppLocalizations.of(context)!.dialogMessageToggleBasicMode,
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text(
              AppLocalizations.of(context)!.dialogMessageCancel,
            ),
            onPressed: () {
              Navigator.of(context).pop(false); // pop dialog
            },
          ),
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
