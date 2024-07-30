import 'package:flutter/material.dart';

ThemeData getSecondaryTabBarTheme(BuildContext context) {
  if (Theme.of(context).brightness == Brightness.light) {
    return ThemeData(
      tabBarTheme: TabBarTheme(
        dividerColor: Colors.grey,
        tabAlignment: TabAlignment.start,
        unselectedLabelColor: Colors.grey,
        labelColor: Colors.black,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          border: const Border(
              left: BorderSide(
                color: Colors.grey,
              ),
              top: BorderSide(
                color: Colors.grey,
              ),
              right: BorderSide(
                color: Colors.grey,
              )),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        labelPadding: const EdgeInsets.symmetric(horizontal: 24.0),
      ),
    );
  } else {
    return ThemeData(
      tabBarTheme: TabBarTheme(
        dividerColor: Colors.grey,
        tabAlignment: TabAlignment.start,
        unselectedLabelColor: Colors.grey,
        labelColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          border: const Border(
              left: BorderSide(
                color: Colors.grey,
              ),
              top: BorderSide(
                color: Colors.grey,
              ),
              right: BorderSide(
                color: Colors.grey,
              )),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        labelPadding: const EdgeInsets.symmetric(horizontal: 24.0),
      ),
    );
  }
}

Color getSecondaryTabBarPaddingColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.light
      ? Theme.of(context).colorScheme.onPrimary
      : Theme.of(context).colorScheme.surfaceContainerHighest;
}
