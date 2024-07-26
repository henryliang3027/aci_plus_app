import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/information/views/warm_reset_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> showWarmResetDialog({
  required BuildContext context,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!

    builder: (BuildContext context) {
      return const Dialog(
        child: WarmResetPage(),
      );
    },
  );
}

Future<bool?> showWarmResetNoticeDialog({
  required BuildContext context,
}) async {
  return showDialog<bool?>(
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
          AppLocalizations.of(context)!.dialogTitleNotice,
          style: const TextStyle(
            color: CustomStyle.customYellow,
          ),
        ),
        content: SizedBox(
          width: width,
          child: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  AppLocalizations.of(context)!.dialogMessageWarmReset,
                  style: const TextStyle(
                    fontSize: CustomStyle.sizeL,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              AppLocalizations.of(context)!.dialogMessageCancel,
            ),
            onPressed: () {
              Navigator.of(context).pop(false); // pop dialog
            },
          ),
          TextButton(
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

Future<void> showWarmResetSuccessDialog({
  required BuildContext context,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (_) {
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
                AppLocalizations.of(context)!.dialogMessageWarmResetSeccessful,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
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
