import 'package:aci_plus_app/core/custom_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> showInProgressDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return PopScope(
        canPop: false, // 避免 Android 使用者點擊系統返回鍵關閉 dialog
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
          horizontal: width * 0.1,
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
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(true); // pop dialog
            },
          ),
        ],
      );
    },
  );
}
