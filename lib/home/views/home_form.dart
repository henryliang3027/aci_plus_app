import 'package:dsim_app/home/views/home_bottom_navigation_bar.dart';
import 'package:dsim_app/information/views/information_form.dart';
import 'package:dsim_app/information/views/information_page.dart';
import 'package:dsim_app/setting/views/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HomeForm extends StatefulWidget {
  const HomeForm({super.key});

  @override
  State<HomeForm> createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {
  late final PageController _pageController;
  late int _sclectedIndex;

  @override
  void initState() {
    super.initState();
    _sclectedIndex = 0;
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: _pageController,
          children: const [
            InformationPage(),
            SettingPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'Information',
              tooltip: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Setting',
              tooltip: '',
            ),
          ],
          //if current page is account which is not list in bottom navigation bar, make all items grey color
          //assign a useless 0 as currentIndex for account page
          currentIndex: _sclectedIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Theme.of(context).hintColor,
          onTap: (index) {
            setState(() {
              _sclectedIndex = index;
              _pageController.animateToPage(
                _sclectedIndex,
                duration: const Duration(
                  milliseconds: 100,
                ),
                curve: Curves.linear,
              );
              print(_sclectedIndex);
            });
          },
        ));
  }
}
