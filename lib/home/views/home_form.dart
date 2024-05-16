import 'package:aci_plus_app/about/about_page.dart';
import 'package:aci_plus_app/advanced/view/setting18_advanced_page.dart';
import 'package:aci_plus_app/chart/view/chart18_ccor_node_page.dart';
import 'package:aci_plus_app/chart/view/chart18_page.dart';
import 'package:aci_plus_app/chart/view/chart_page.dart';
import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/message_localization.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/information/views/information18_ccor_node_page.dart';
import 'package:aci_plus_app/information/views/information18_page.dart';
import 'package:aci_plus_app/information/views/information_page.dart';
import 'package:aci_plus_app/setting/views/setting18_ccor_node_views/setting18_ccor_node_page.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_page.dart';
import 'package:aci_plus_app/setting/views/setting_views/setting_page.dart';
import 'package:aci_plus_app/status/views/status18_ccor_node_page.dart';
import 'package:aci_plus_app/status/views/status18_page.dart';
import 'package:aci_plus_app/status/views/status_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    Future<bool?> showExitAppDialog({
      required BuildContext context,
    }) {
      return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.dialogTitleAskBeforeExitApp,
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  AppLocalizations.of(context)!.dialogMessageCancel,
                ),
                onPressed: () {
                  Navigator.of(context).pop(false); // pop dialog
                },
              ),
              TextButton(
                child: Text(
                  AppLocalizations.of(context)!.dialogMessageExit,
                  style: const TextStyle(color: CustomStyle.customRed),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true); // pop dialog
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> showFailureDialog(String msg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.dialogTitleError,
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

    List<Widget> buildPages(ACIDeviceType aciDeviceType) {
      if (aciDeviceType == ACIDeviceType.dsim1G1P2G) {
        // 適用 1G/1.2G 的頁面
        return [
          SettingPage(
            pageController: _pageController,
          ),
          StatusPage(
            pageController: _pageController,
          ),
          InformationPage(
            pageController: _pageController,
          ),
          ChartPage(
            pageController: _pageController,
          ),
          AboutPage(
            pageController: _pageController,
          ),
        ];
      } else if (aciDeviceType == ACIDeviceType.amp1P8G) {
        // 適用 1.8G Amplifier 的頁面
        return [
          Setting18Page(
            pageController: _pageController,
          ),
          Status18Page(
            pageController: _pageController,
          ),
          Information18Page(
            pageController: _pageController,
          ),
          Chart18Page(
            pageController: _pageController,
          ),
          Setting18AdvancedPage(
            pageController: _pageController,
          ),
        ];
      } else if (aciDeviceType == ACIDeviceType.ampCCorNode1P8G) {
        return [
          Setting18CCorNodePage(
            pageController: _pageController,
          ),
          Status18CCorNodePage(
            pageController: _pageController,
          ),
          Information18CCorNodePage(
            pageController: _pageController,
          ),
          Chart18CCorNodePage(
            pageController: _pageController,
          ),
          // AboutPage(
          //   pageController: _pageController,
          // ),
          Setting18AdvancedPage(
            pageController: _pageController,
          ),
        ];
      } else {
        return [
          Setting18Page(
            pageController: _pageController,
          ),
          Status18Page(
            pageController: _pageController,
          ),
          Information18Page(
            pageController: _pageController,
          ),
          Chart18Page(
            pageController: _pageController,
          ),
          // AboutPage(
          //   pageController: _pageController,
          // ),
          Setting18AdvancedPage(
            pageController: _pageController,
          ),
        ];
      }
    }

    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.scanStatus.isRequestFailure) {
          showFailureDialog(state.errorMassage);
        } else if (state.connectionStatus.isRequestFailure) {
          // 當斷線時, 關閉目前顯示的 dialog (下載全部 log (download all) 或 load preset)
          if (ModalRoute.of(context)?.isCurrent == false) {
            Navigator.of(context).pop();
            setPreferredOrientation();
          }

          showFailureDialog(state.errorMassage);
        } else if (state.loadingStatus.isRequestFailure) {
          showFailureDialog(state.errorMassage);
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          bool? isExit = await showExitAppDialog(context: context);
          if (isExit != null) {
            if (isExit) {
              SystemNavigator.pop();
            }
          }
        },
        child: Scaffold(
          body: BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (previous, current) =>
                previous.aciDeviceType != current.aciDeviceType,
            builder: (context, state) => PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children:
                  buildPages(context.read<HomeBloc>().state.aciDeviceType),
            ),
          ),
          // bottomNavigationBar: BottomNavigationBar(
          //   backgroundColor: Theme.of(context).colorScheme.onPrimary,
          //   type: BottomNavigationBarType.fixed,
          //   showSelectedLabels: false,
          //   showUnselectedLabels: false,
          //   items: const [
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.settings),
          //       label: 'Setting',
          //       tooltip: '',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.memory_outlined),
          //       label: 'Status',
          //       tooltip: '',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.info),
          //       label: 'Information',
          //       tooltip: '',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.area_chart_sharp),
          //       label: 'Chart',
          //       tooltip: '',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.contact_support),
          //       label: 'About',
          //       tooltip: '',
          //     ),
          //   ],
          //   //if current page is account which is not list in bottom navigation bar, make all items grey color
          //   //assign a useless 0 as currentIndex for account page
          //   currentIndex: _sclectedIndex,
          //   selectedItemColor: Theme.of(context).primaryColor,
          //   unselectedItemColor: Theme.of(context).hintColor,
          //   onTap: (int index) {
          //     setState(() {
          //       _sclectedIndex = index;
          //     });

          //     _pageController.jumpToPage(
          //       index,
          //     );
          //   },
          // ),
        ),
      ),
    );
  }
}
