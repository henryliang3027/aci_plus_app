import 'package:aci_plus_app/core/custom_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> showInProgressDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        child: AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.dialogTitleProcessing,
          ),
          actionsAlignment: MainAxisAlignment.center,
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Center(
                    child: SizedBox(
                      width: CustomStyle.diameter,
                      height: CustomStyle.diameter,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Future<void> showResultDialog({
  required BuildContext context,
  required List<Widget> messageRows,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      var width = MediaQuery.of(context).size.width;
      // var height = MediaQuery.of(context).size.height;

      return AlertDialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: width * 0.08,
        ),
        title: Text(
          AppLocalizations.of(context)!.dialogTitleSettingResult,
        ),
        content: SizedBox(
          width: width,
          child: SingleChildScrollView(
            child: ListBody(
              children: messageRows,
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

Future<void> showSuccessDialog(
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
          style: const TextStyle(
            color: Colors.green,
          ),
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

Future<void> showResetToDefaultSuccessDialog(
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
          style: const TextStyle(
            color: Colors.green,
          ),
        ),
        content: SizedBox(
          width: width,
          child: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  AppLocalizations.of(context)!
                      .dialogMessageResetToDefaultSuccessful,
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

Future<void> showResetToDefaultFailureDialog(
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
          style: const TextStyle(
            color: Colors.green,
          ),
        ),
        content: SizedBox(
          width: width,
          child: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  AppLocalizations.of(context)!
                      .dialogMessageResetToDefaultFailed,
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

Future<bool?> showCurrentForwardCEQChangedDialog(
  BuildContext context,
) async {
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
                  AppLocalizations.of(context)!.dialogMessageForwardCEQChanged,
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
