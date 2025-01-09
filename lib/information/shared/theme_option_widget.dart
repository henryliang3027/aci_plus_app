import 'package:aci_plus_app/information/shared/theme_option_page.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
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
        child: const ThemeOptionPage(),
      );
    },
  );
}

void changeThemeByThemeString({
  required BuildContext context,
  required String theme,
}) {
  switch (theme) {
    case 'light':
      AdaptiveTheme.of(context).setLight();
      break;
    case 'dark':
      AdaptiveTheme.of(context).setDark();
      break;
    case 'system':
      AdaptiveTheme.of(context).setSystem();
      break;
    default:
      AdaptiveTheme.of(context).setLight();
  }
}
