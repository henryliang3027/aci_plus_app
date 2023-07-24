import 'package:dsim_app/about/about_page.dart';
import 'package:dsim_app/chart/view/chart_page.dart';
import 'package:dsim_app/core/custom_style.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/core/message_localization.dart';
import 'package:dsim_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:dsim_app/information/views/information_page.dart';
import 'package:dsim_app/setting/views/setting_page.dart';
import 'package:dsim_app/status/views/status_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    Future<void> showFailureDialog(String msg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context).dialogTitleError,
              style: const TextStyle(
                color: CustomStyle.customRed,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    getMessageLocalization(
                      msg: msg,
                      context: context,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // pop dialog
                },
              ),
            ],
          );
        },
      );
    }

    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.scanStatus.isRequestFailure) {
          showFailureDialog(state.errorMassage);
        } else if (state.connectionStatus.isRequestFailure) {
          showFailureDialog(state.errorMassage);
        } else if (state.loadingStatus.isRequestFailure) {
          showFailureDialog(state.errorMassage);
        }
      },
      child: Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
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
      ),
    );
  }
}
