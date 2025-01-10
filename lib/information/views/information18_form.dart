import 'dart:math';

import 'package:aci_plus_app/about/about18_page.dart';
import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/notice_dialog.dart';
import 'package:aci_plus_app/core/setup_wizard_dialog.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/home/views/home_button_navigation_bar18.dart';
import 'package:aci_plus_app/information/bloc/information18/information18_bloc.dart';
import 'package:aci_plus_app/information/shared/theme_option_widget.dart';
import 'package:aci_plus_app/information/shared/utils.dart';
import 'package:aci_plus_app/information/shared/warm_reset_widget.dart';
import 'package:aci_plus_app/information/views/information18_config_list_view.dart';
import 'package:aci_plus_app/information/views/name_plate_view.dart';
import 'package:aci_plus_app/repositories/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class Information18Form extends StatelessWidget {
  const Information18Form({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    HomeState homeState = context.read<HomeBloc>().state;
    int firmwareVersion = convertFirmwareVersionStringToInt(
        homeState.characteristicData[DataKey.firmwareVersion] ?? '0');
    if (homeState.loadingStatus.isRequestSuccess) {
      if (NoticeFlag.leftDevicePage && firmwareVersion >= 148) {
        List<DataKey> unFilledItems = getUnFilledItem(
          context: context,
          characteristicData: homeState.characteristicData,
        );

        if (unFilledItems.isNotEmpty) {
          Future.delayed(const Duration(milliseconds: 100), () {
            showUnFilledItemDialog(
              context: context,
              unFilledItems: unFilledItems,
            );

            NoticeFlag.leftDevicePage = false;
          });
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.home),
        centerTitle: true,
        leading: const _DeviceStatus(),
        actions: const [_PopupMenu()],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            // _VersionCard(),
            _ConnectionCard(),
            _ShortcutCard(),
            // _BlockDiagramCard(),
            _BasicCard(),
            // _AlarmCard(),
            // _DataReloader(),
            SizedBox(
              height: CustomStyle.formBottomSpacingS,
            ),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNavigationBar18(
        pageController: pageController,
        selectedIndex: 2,
        onTap: (int index) {
          // if (index != 2) {
          //   context
          //       .read<Information18Bloc>()
          //       .add(const AlarmPeriodicUpdateCanceled());
          // }

          pageController.jumpToPage(
            index,
          );
        },
      ),
      floatingActionButton: const Information18SetupWizard(),
    );
  }
}

enum HomeMenu {
  refresh,
  theme,
  warmReset,
  about,
}

class _PopupMenu extends StatefulWidget {
  const _PopupMenu();

  @override
  State<_PopupMenu> createState() => __PopupMenuState();
}

class __PopupMenuState extends State<_PopupMenu> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (!state.loadingStatus.isRequestInProgress &&
            !state.connectionStatus.isRequestInProgress) {
          return PopupMenuButton<HomeMenu>(
            icon: const Icon(
              Icons.more_vert_outlined,
              color: Colors.white,
            ),
            tooltip: '',
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<HomeMenu>>[
                menuItem(
                  value: HomeMenu.refresh,
                  iconData: Icons.refresh,
                  title: AppLocalizations.of(context)!.reconnect,
                  onTap: () {
                    // 暫停定期更新, 避免設定過程中同時要求資訊
                    context
                        .read<HomeBloc>()
                        .add(const DevicePeriodicUpdateCanceled());
                    context.read<HomeBloc>().add(const DeviceRefreshed());
                  },
                ),
                menuItem(
                  value: HomeMenu.theme,
                  iconData: Icons.colorize_rounded,
                  title: AppLocalizations.of(context)!.theme,
                  onTap: () {
                    showThemeOptionDialog(context: context).then(
                      (String? theme) {
                        if (theme != null) {
                          changeThemeByThemeString(
                            context: context,
                            theme: theme,
                          );
                        }
                      },
                    );
                  },
                ),
                menuItem(
                  value: HomeMenu.warmReset,
                  iconData: Icons.restart_alt_outlined,
                  title: AppLocalizations.of(context)!.warmReset,
                  enabled: state.connectionStatus.isNone ||
                          state.connectionStatus.isRequestFailure ||
                          state.loadingStatus.isNone ||
                          state.loadingStatus.isRequestFailure
                      ? false
                      : true,
                  onTap: () {
                    // 暫停定期更新, 避免設定過程中同時要求資訊
                    context
                        .read<HomeBloc>()
                        .add(const DevicePeriodicUpdateCanceled());

                    showWarmResetNoticeDialog(context: context).then(
                      (isConfirm) {
                        if (isConfirm != null) {
                          if (isConfirm) {
                            showWarmResetDialog(context: context).then((_) {
                              showWarmResetSuccessDialog(context: context)
                                  .then((_) {
                                context
                                    .read<HomeBloc>()
                                    .add(const Data18Requested());
                              });
                            });
                          }
                        }
                      },
                    );
                  },
                ),
                menuItem(
                  value: HomeMenu.about,
                  iconData: CustomIcons.about,
                  title: AppLocalizations.of(context)!.aboutUs,
                  onTap: () {
                    Navigator.push(
                      context,
                      About18Page.route(
                        appVersion:
                            context.read<Information18Bloc>().state.appVersion,
                      ),
                    );
                  },
                ),
              ];
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class _DeviceStatus extends StatelessWidget {
  const _DeviceStatus();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.scanStatus.isRequestSuccess) {
          if (state.connectionStatus.isRequestSuccess) {
            return const Icon(
              Icons.bluetooth_connected_outlined,
            );
          } else if (state.connectionStatus.isRequestFailure) {
            return const Icon(
              Icons.nearby_error,
              color: Colors.amber,
            );
          } else {
            return const Center(
              child: SizedBox(
                width: CustomStyle.diameter,
                height: CustomStyle.diameter,
                child: CircularProgressIndicator(
                  color: Colors.amber,
                ),
              ),
            );
          }
        } else if (state.scanStatus.isRequestFailure) {
          return const Icon(
            Icons.nearby_error_outlined,
          );
        } else if (state.scanStatus.isRequestInProgress) {
          return const Center(
            child: SizedBox(
              width: CustomStyle.diameter,
              height: CustomStyle.diameter,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        } else {
          return const Center();
        }
      },
    );
  }
}

class _ConnectionCard extends StatelessWidget {
  const _ConnectionCard();

  Widget getBluetoothName({
    required FormStatus scanStatus,
    required String title,
    required String name,
  }) {
    if (scanStatus == FormStatus.requestInProgress) {
      return const SizedBox(
        width: CustomStyle.diameter,
        height: CustomStyle.diameter,
        child: CircularProgressIndicator(),
      );
    } else if (scanStatus == FormStatus.requestSuccess) {
      return Text(
        name,
        style: const TextStyle(
          fontSize: CustomStyle.sizeL,
        ),
      );
    } else {
      return const Text(
        'N/A',
        style: TextStyle(
          fontSize: CustomStyle.sizeL,
        ),
      );
    }
  }

  Widget bluetoothText({
    required FormStatus scanStatus,
    required String title,
    required String name,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: CustomStyle.sizeL,
            ),
          ),
          getBluetoothName(
            scanStatus: scanStatus,
            title: title,
            name: name,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.connection,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 10.0,
              ),
              // itemLinkText(
              //   title: '',
              //   content: AppLocalizations.of(context)!.visitWebsite,
              // ),
              bluetoothText(
                scanStatus: state.scanStatus,
                title: AppLocalizations.of(context)!.bluetooth,
                name: state.device.name.isNotEmpty ? state.device.name : '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShortcutCard extends StatelessWidget {
  const _ShortcutCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.loadingStatus != current.loadingStatus,
      builder: (context, state) {
        String partId = state.characteristicData[DataKey.partId] ?? '';

        if (state.loadingStatus.isRequestSuccess) {
          context.read<Information18Bloc>().add(ConfigLoaded(partId));
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.shortcut,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.loadPreset,
                        style: const TextStyle(
                          fontSize: CustomStyle.sizeL,
                        ),
                      ),
                      _LoadPresetButton(
                        loadingStatus: state.loadingStatus,
                        partId: partId,
                      ),
                      // ElevatedButton(
                      //   onPressed: state.loadingStatus.isRequestSuccess
                      //       ? () async {
                      //           // 要進行設定前先暫停 alarm 定期更新, 避免設定過程中同時要求 alarm 資訊
                      //           context
                      //               .read<Information18Bloc>()
                      //               .add(const AlarmPeriodicUpdateCanceled());

                      //           context
                      //               .read<Information18Bloc>()
                      //               .add(ConfigLoaded(partId));
                      //         }
                      //       : null,
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor:
                      //         Theme.of(context).colorScheme.primary,
                      //     foregroundColor: Colors.white,
                      //   ),
                      //   child: Text(
                      //     AppLocalizations.of(context)!.load,
                      //     style: const TextStyle(
                      //       fontSize: CustomStyle.sizeL,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LoadPresetButton extends StatelessWidget {
  const _LoadPresetButton({
    required this.loadingStatus,
    required this.partId,
  });

  final FormStatus loadingStatus;
  final String partId;

  @override
  Widget build(BuildContext context) {
    Future<void> showSelectConfigDialog({
      required List<Config> configs,
    }) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!

        builder: (BuildContext context) {
          var width = MediaQuery.of(context).size.width;
          // var height = MediaQuery.of(context).size.height;

          return Dialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: width * 0.01,
            ),
            child: Informtion18ConfigListView(
              configs: configs,
            ),
          );
        },
      );
    }

    return BlocBuilder<Information18Bloc, Information18State>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: loadingStatus.isRequestSuccess && state.configs.isNotEmpty
              ? () async {
                  // 要進行設定前先暫定期更新, 避免設定過程中同時要求資訊
                  context
                      .read<HomeBloc>()
                      .add(const DevicePeriodicUpdateCanceled());

                  showSelectConfigDialog(
                    configs: state.configs,
                  ).then((value) {
                    // 設定結束後, 恢復定期更新
                    context
                        .read<HomeBloc>()
                        .add(const DevicePeriodicUpdateRequested());
                  });
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          child: Text(
            AppLocalizations.of(context)!.load,
            style: const TextStyle(
              fontSize: CustomStyle.sizeL,
            ),
          ),
        );
      },
    );
  }
}

class _BasicCard extends StatelessWidget {
  const _BasicCard();

  @override
  Widget build(BuildContext context) {
    String getCurrentLogInterval(String logInterval) {
      if (logInterval.isEmpty) {
        return '';
      } else {
        return '$logInterval ${AppLocalizations.of(context)!.minute}';
      }
    }

    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.basicInformation,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 10.0,
              ),
              itemText(
                loadingStatus: state.loadingStatus,
                title: AppLocalizations.of(context)!.typeNo,
                content: state.characteristicData[DataKey.partName] ?? '',
              ),
              itemText(
                loadingStatus: state.loadingStatus,
                title: AppLocalizations.of(context)!.partNo,
                content: state.characteristicData[DataKey.partNo] ?? '',
              ),
              itemText(
                loadingStatus: state.loadingStatus,
                title: AppLocalizations.of(context)!.serialNumber,
                content: state.characteristicData[DataKey.serialNumber] ?? '',
              ),
              itemText(
                loadingStatus: state.loadingStatus,
                title: AppLocalizations.of(context)!.firmwareVersion,
                content:
                    state.characteristicData[DataKey.firmwareVersion] ?? '',
              ),
              itemText(
                loadingStatus: state.loadingStatus,
                title: AppLocalizations.of(context)!.hardwareVersion,
                content:
                    state.characteristicData[DataKey.hardwareVersion] ?? '',
              ),
              itemText(
                loadingStatus: state.loadingStatus,
                title: AppLocalizations.of(context)!.logInterval,
                content: getCurrentLogInterval(
                    state.characteristicData[DataKey.logInterval] ?? ''),
              ),
              itemMultipleLineText(
                loadingStatus: state.loadingStatus,
                title: AppLocalizations.of(context)!.location,
                content: state.characteristicData[DataKey.location] ?? '',
              ),
              itemMultipleLineText(
                loadingStatus: state.loadingStatus,
                title: AppLocalizations.of(context)!.coordinates,
                content: state.characteristicData[DataKey.coordinates] ?? '',
              ),
              itemText(
                loadingStatus: state.loadingStatus,
                title: AppLocalizations.of(context)!.mfgDate,
                content: state.characteristicData[DataKey.mfgDate] ?? '',
              ),
            ],
          ),
        ),
      );
    });
  }
}

// class _AlarmIndicator extends StatelessWidget {
//   const _AlarmIndicator();

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<Information18Bloc, Information18State>(
//       builder: (context, state) {
//         return buildAlarmCard(
//           context: context,
//           alarmUSeverity: state.alarmUSeverity,
//           alarmTSeverity: state.alarmTSeverity,
//           alarmPSeverity: state.alarmPSeverity,
//         );
//       },
//     );
//   }
// }

// class _AlarmCard extends StatelessWidget {
//   const _AlarmCard();

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeBloc, HomeState>(
//       // 上一個狀態跟目前狀態的 loadingStatus 不一樣時才要rebuild,
//       // 否則切到 status page 時會 HomeState 而重複觸發 AlarmPeriodicUpdateRequested
//       buildWhen: (previous, current) =>
//           previous.loadingStatus != current.loadingStatus,
//       builder: (context, state) {
//         if (state.loadingStatus.isRequestSuccess) {
//           context
//               .read<Information18Bloc>()
//               .add(const AlarmPeriodicUpdateRequested());

//           return const _AlarmIndicator();
//         } else {
//           context
//               .read<Information18Bloc>()
//               .add(const AlarmPeriodicUpdateCanceled());

//           String alarmUSeverity =
//               state.characteristicData[DataKey.unitStatusAlarmSeverity] ??
//                   'default';
//           String alarmTSeverity =
//               state.characteristicData[DataKey.temperatureAlarmSeverity] ??
//                   'default';
//           String alarmPSeverity =
//               state.characteristicData[DataKey.voltageAlarmSeverity] ??
//                   'default';

//           return buildAlarmCard(
//             context: context,
//             alarmUSeverity: alarmUSeverity,
//             alarmTSeverity: alarmTSeverity,
//             alarmPSeverity: alarmPSeverity,
//           );
//         }
//       },
//     );
//   }
// }

// Widget alarmItem({
//   required IconData iconData,
//   required String title,
//   Color? iconColor,
// }) {
//   return Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Icon(
//           iconData,
//           color: iconColor,
//         ),
//         const SizedBox(
//           width: 10.0,
//         ),
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: CustomStyle.sizeL,
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget buildAlarmCard({
//   required BuildContext context,
//   required String alarmUSeverity,
//   required String alarmTSeverity,
//   required String alarmPSeverity,
// }) {
//   return Card(
//     child: Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             AppLocalizations.of(context)!.alarmIndicator,
//             style: Theme.of(context).textTheme.titleLarge,
//           ),
//           const SizedBox(
//             height: 10.0,
//           ),
//           alarmItem(
//             iconData: Icons.circle,
//             iconColor: CustomStyle.alarmColor[alarmUSeverity],
//             title: AppLocalizations.of(context)!.unitStatusAlarm,
//           ),
//           alarmItem(
//             iconData: Icons.circle,
//             iconColor: CustomStyle.alarmColor[alarmTSeverity],
//             title: AppLocalizations.of(context)!.temperatureAlarm,
//           ),
//           alarmItem(
//             iconData: Icons.circle,
//             iconColor: CustomStyle.alarmColor[alarmPSeverity],
//             title: AppLocalizations.of(context)!.powerSupplyAlarm,
//           ),
//         ],
//       ),
//     ),
//   );
// }

Widget getContent({
  required FormStatus loadingStatus,
  required String content,
  double fontSize = 16,
}) {
  if (loadingStatus == FormStatus.requestInProgress) {
    return content.isEmpty
        ? const SizedBox(
            width: CustomStyle.diameter,
            height: CustomStyle.diameter,
            child: CircularProgressIndicator(),
          )
        : Text(
            content,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: fontSize,
            ),
          );
  } else if (loadingStatus == FormStatus.requestSuccess) {
    return Text(
      content,
      textAlign: TextAlign.right,
      style: TextStyle(
        fontSize: fontSize,
      ),
    );
  } else {
    return Text(
      content.isEmpty ? 'N/A' : content,
      textAlign: TextAlign.right,
      style: TextStyle(
        fontSize: fontSize,
      ),
    );
  }
}

Widget itemText({
  required FormStatus loadingStatus,
  required String title,
  required String content,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: CustomStyle.sizeL,
          ),
        ),
        const SizedBox(
          width: 30.0,
        ),
        Flexible(
          child: getContent(loadingStatus: loadingStatus, content: content),
        ),
      ],
    ),
  );
}

Widget itemMultipleLineText({
  required FormStatus loadingStatus,
  required String title,
  required String content,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: CustomStyle.sizeL,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // const SizedBox(
            //   width: 30,
            // ),
            Flexible(
              child: RichText(
                text: WidgetSpan(
                  child: getContent(
                      loadingStatus: loadingStatus, content: content),
                  // Text(
                  //   content,
                  //   textAlign: TextAlign.right,
                  //   // textDirection: TextDirection.rtl,
                  //   style: TextStyle(
                  //     fontSize: CustomStyle.sizeL,
                  //   ),
                  // ),
                ),
              ),
            )
          ],
        )
      ],
    ),
  );
}

Widget itemLinkText({
  required String title,
  required String content,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: CustomStyle.sizeL,
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            visualDensity:
                const VisualDensity(vertical: -4.0, horizontal: -4.0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const EdgeInsets.all(1.0),
          ),
          child: Text(
            content,
            style: const TextStyle(
              fontSize: CustomStyle.sizeL,
            ),
            textAlign: TextAlign.end,
          ),
          onPressed: () async {
            Uri uri = Uri.parse('http://acicomms.com/products/line-amplifier');
            launchUrl(
              uri,
              mode: LaunchMode.externalApplication,
            );
          },
        ),
      ],
    ),
  );
}
