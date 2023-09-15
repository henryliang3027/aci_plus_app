import 'package:flutter/material.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  const HomeBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.pageController,
    this.enableTap = true,
  }) : super(key: key);

  final int selectedIndex;
  final PageController pageController;
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
          icon: Icon(Icons.settings),
          label: 'Setting',
          tooltip: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.memory_outlined),
          label: 'Status',
          tooltip: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'Information',
          tooltip: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.area_chart_sharp),
          label: 'Chart',
          tooltip: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.contact_support),
          label: 'About',
          tooltip: '',
        ),
      ],
      //if current page is account which is not list in bottom navigation bar, make all items grey color
      //assign a useless 0 as currentIndex for account page
      currentIndex: selectedIndex,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Theme.of(context).hintColor,
      onTap: enableTap
          ? (int index) {
              pageController.jumpToPage(
                index,
              );
            }
          : null,
    );
  }
}
