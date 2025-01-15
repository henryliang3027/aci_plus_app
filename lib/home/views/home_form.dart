import 'package:aci_plus_app/about/about18_page.dart';
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
import 'package:aci_plus_app/home/views/peripheral_selector_page.dart';
import 'package:aci_plus_app/information/views/information18_ccor_node_page.dart';
import 'package:aci_plus_app/information/views/information18_page.dart';
import 'package:aci_plus_app/information/views/information_page.dart';
import 'package:aci_plus_app/repositories/ble_peripheral.dart';
import 'package:aci_plus_app/setting/views/custom_setting_dialog.dart';
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
              ElevatedButton(
                child: Text(
                  AppLocalizations.of(context)!.dialogMessageCancel,
                ),
                onPressed: () {
                  Navigator.of(context).pop(false); // pop dialog
                },
              ),
              ElevatedButton(
                child: Text(
                  AppLocalizations.of(context)!.dialogMessageExit,
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
              ElevatedButton(
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

    Future<Peripheral?> showSelectPeripheralDialog() async {
      return showDialog<Peripheral>(
        context: context,
        barrierDismissible: false, // user must tap button!

        builder: (BuildContext context) {
          var width = MediaQuery.of(context).size.width;
          var height = MediaQuery.of(context).size.height;

          return Dialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: width * 0.01,
            ),
            child: const PeripheralSelectorPage(),
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

    return MultiBlocListener(
      listeners: [
        BlocListener<HomeBloc, HomeState>(
          listenWhen: (previous, current) =>
              previous.peripherals != current.peripherals,
          listener: (context, state) {
            if (state.scanStatus.isRequestInProgress) {
              if (state.peripherals.isNotEmpty) {
                if (ModalRoute.of(context)?.isCurrent == true) {
                  showSelectPeripheralDialog();
                }
              }
            }
          },
        ),
        BlocListener<HomeBloc, HomeState>(
          listenWhen: (previous, current) =>
              previous.connectionStatus != current.connectionStatus ||
              previous.loadingStatus != current.loadingStatus,
          listener: (context, state) {
            if (state.connectionStatus.isRequestFailure ||
                state.loadingStatus.isRequestFailure) {
              if (ModalRoute.of(context)?.isCurrent == false) {
                Navigator.of(context).pop();
                setPreferredOrientation();
              }

              showFailureDialog(state.errorMassage).then((_) {
                // 如果是在 firmware update 過程中斷線, 就讀取 isDisconnectOnFirmwareUpdate flag
                // 如果為 true, 就重新連線, 並將 flag 設定回 false
                if (CrossPageFlag.isDisconnectOnFirmwareUpdate) {
                  CrossPageFlag.isDisconnectOnFirmwareUpdate = false;
                  _pageController.jumpToPage(2);
                  context.read<HomeBloc>().add(const DeviceRefreshed());
                }
              });
            } else if (state.loadingStatus.isRequestSuccess) {
              context
                  .read<HomeBloc>()
                  .add(const DevicePeriodicUpdateRequested());
            }
          },
        ),
        BlocListener<HomeBloc, HomeState>(
          listenWhen: (previous, current) =>
              previous.ceqStatus != current.ceqStatus,
          listener: (context, state) {
            if (state.ceqStatus != CEQStatus.none) {
              if (ModalRoute.of(context)?.isCurrent == true) {
                showCurrentForwardCEQChangedDialog(context);
              }
            }
          },
        )
      ],
      child: Scaffold(
        body: BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (previous, current) =>
              previous.aciDeviceType != current.aciDeviceType,
          builder: (context, state) => PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: buildPages(context.read<HomeBloc>().state.aciDeviceType),
          ),
        ),
      ),
    );
  }
}
