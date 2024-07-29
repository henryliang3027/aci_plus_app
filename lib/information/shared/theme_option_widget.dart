import 'package:aci_plus_app/information/shared/theme_option_page.dart';
import 'package:flutter/material.dart';

Future<String?> showThemeOptionDialog({
  required BuildContext context,
}) async {
  return showDialog<String?>(
    context: context,
    barrierDismissible: false, // user must tap button!
    barrierColor: Colors.black45,

    builder: (BuildContext context) {
      var width = MediaQuery.of(context).size.width;

      return Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: width * 0.01,
        ),
        backgroundColor: Theme.of(context).cardTheme.color,
        child: const ThemeOptionPage(),
      );
    },
  );
}
