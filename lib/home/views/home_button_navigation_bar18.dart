import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeBottomNavigationBar18 extends StatelessWidget {
  const HomeBottomNavigationBar18({
    Key? key,
    required this.selectedIndex,
    required this.pageController,
    required this.onTap,
    this.enableTap = true,
  }) : super(key: key);

  final int selectedIndex;
  final PageController pageController;
  final ValueChanged<int> onTap;
  final bool enableTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).bottomAppBarTheme.color,

      type: BottomNavigationBarType.fixed,

      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(CustomIcons.setting),
          label: 'Setting',
          tooltip: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(CustomIcons.status),
          label: 'Status',
          tooltip: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(CustomIcons.home),
          label: 'Information',
          tooltip: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(CustomIcons.chart),
          label: 'Chart',
          tooltip: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(CustomIcons.advanced),
          label: 'About',
          tooltip: '',
        ),
      ],
      //if current page is account which is not list in bottom navigation bar, make all items grey color
      //assign a useless 0 as currentIndex for account page
      currentIndex: selectedIndex,
      selectedIconTheme: const IconThemeData(size: 36),
      selectedFontSize: 10.0,
      selectedItemColor:
          Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
      unselectedItemColor:
          Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
      onTap: enableTap ? onTap : null,
    );

    // Card(
    //   elevation: 10, // Adds shadow and elevation
    //   margin: const EdgeInsets.all(0), // Optional padding around the card

    //   child: Column(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       Container(
    //         decoration: BoxDecoration(
    //           color: Theme.of(context).bottomAppBarTheme.color,
    //         ),
    //         child: Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Indicator(
    //                 color: Colors.green,
    //                 name: AppLocalizations.of(context)!.unitStatusAlarm,
    //               ),
    //               Indicator(
    //                 color: Colors.green,
    //                 name: AppLocalizations.of(context)!.temperatureAlarm,
    //               ),
    //               Indicator(
    //                 color: Colors.green,
    //                 name: AppLocalizations.of(context)!.powerSupplyAlarm,
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //       BottomNavigationBar(
    //         elevation: 0,
    //         backgroundColor: Theme.of(context).bottomAppBarTheme.color,

    //         type: BottomNavigationBarType.fixed,

    //         showSelectedLabels: false,
    //         showUnselectedLabels: false,
    //         items: const [
    //           BottomNavigationBarItem(
    //             icon: Icon(CustomIcons.setting),
    //             label: 'Setting',
    //             tooltip: '',
    //           ),
    //           BottomNavigationBarItem(
    //             icon: Icon(CustomIcons.status),
    //             label: 'Status',
    //             tooltip: '',
    //           ),
    //           BottomNavigationBarItem(
    //             icon: Icon(CustomIcons.home),
    //             label: 'Information',
    //             tooltip: '',
    //           ),
    //           BottomNavigationBarItem(
    //             icon: Icon(CustomIcons.chart),
    //             label: 'Chart',
    //             tooltip: '',
    //           ),
    //           BottomNavigationBarItem(
    //             icon: Icon(CustomIcons.advanced),
    //             label: 'About',
    //             tooltip: '',
    //           ),
    //         ],
    //         //if current page is account which is not list in bottom navigation bar, make all items grey color
    //         //assign a useless 0 as currentIndex for account page
    //         currentIndex: selectedIndex,
    //         selectedIconTheme: const IconThemeData(size: 36),
    //         selectedFontSize: 10.0,
    //         selectedItemColor:
    //             Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
    //         unselectedItemColor:
    //             Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
    //         onTap: enableTap ? onTap : null,
    //       ),
    //     ],
    //   ),
    // );
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.name,
  });

  final Color color;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            color: color,
          ),
          const SizedBox(
            width: 6.0,
          ),
          Text(
            name,
            style: const TextStyle(
              fontSize: CustomStyle.sizeL,
            ),
          ),
        ],
      ),
    );
  }
}
