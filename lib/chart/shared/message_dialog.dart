import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/message_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<bool?> showNoMoreDataDialog({required BuildContext context}) async {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          AppLocalizations.of(context)!.dialogTitleSuccess,
          style: const TextStyle(
            color: CustomStyle.customGreen,
          ),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                AppLocalizations.of(context)!.dialogMessageNoMoreLogs,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text(
              AppLocalizations.of(context)!.dialogMessageOk,
            ),
            onPressed: () {
              Navigator.of(context).pop(); // pop dialog
            },
          ),
        ],
      );
    },
  );
}

Future<void> showFailureDialog({
  required BuildContext context,
  required String msg,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          AppLocalizations.of(context)!.dialogTitleError,
          style: const TextStyle(
            color: CustomStyle.customRed,
          ),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                getMessageLocalization(
                  msg: msg,
                  context: context,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(); // pop dialog
            },
          ),
        ],
      );
    },
  );
}
