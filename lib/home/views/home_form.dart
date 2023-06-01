import 'package:dsim_app/about/about_page.dart';
import 'package:dsim_app/chart/view/chart_page.dart';
import 'package:dsim_app/home/views/home_bottom_navigation_bar.dart';
import 'package:dsim_app/information/views/information_page.dart';
import 'package:dsim_app/setting/views/setting_page.dart';
import 'package:dsim_app/status/views/status_page.dart';
import 'package:flutter/material.dart';

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
    _sclectedIndex = 2;
    _pageController = PageController(
      initialPage: _sclectedIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: const [
          SettingPage(),
          StatusPage(),
          InformationPage(),
          ChartPage(),
          AboutPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
        currentIndex: _sclectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).hintColor,
        onTap: (int index) {
          setState(() {
            _sclectedIndex = index;
          });

          _pageController.jumpToPage(
            index,
          );
        },
      ),
    );
  }
}
