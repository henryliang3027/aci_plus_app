import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/information/bloc/information18_bloc/information18_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  const HomeBottomNavigationBar({
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
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
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
          icon: Icon(CustomIcons.information),
          label: 'Information',
          tooltip: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(CustomIcons.chart),
          label: 'Chart',
          tooltip: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(CustomIcons.about),
          label: 'About',
          tooltip: '',
        ),
      ],
      //if current page is account which is not list in bottom navigation bar, make all items grey color
      //assign a useless 0 as currentIndex for account page
      currentIndex: selectedIndex,
      selectedIconTheme: const IconThemeData(size: 36),
      selectedFontSize: 10.0,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Theme.of(context).hintColor,
      onTap: enableTap ? onTap : null,
    );
  }
}
