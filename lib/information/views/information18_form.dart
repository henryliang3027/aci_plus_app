import 'package:aci_plus_app/about/about18_page.dart';
import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/home/views/home_button_navigation_bar18.dart';
import 'package:aci_plus_app/information/bloc/information18/information18_bloc.dart';
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
            _AlarmCard(),
            // _DataReloader(),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNavigationBar18(
        pageController: pageController,
        selectedIndex: 2,
        onTap: (int index) {
          if (index != 2) {
            context
                .read<Information18Bloc>()
                .add(const AlarmPeriodicUpdateCanceled());
          }

          pageController.jumpToPage(
            index,
          );
        },
      ),
    );
  }
}

enum HomeMenu {
  refresh,
  about,
}

class _PopupMenu extends StatefulWidget {
  const _PopupMenu({super.key});

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
            onSelected: (HomeMenu item) async {
              switch (item) {
                case HomeMenu.refresh:
                  context
                      .read<Information18Bloc>()
                      .add(const AlarmPeriodicUpdateCanceled());
                  context.read<HomeBloc>().add(const DeviceRefreshed());
                  break;
                case HomeMenu.about:
                  Navigator.push(
                    context,
                    About18Page.route(
                      appVersion:
                          context.read<Information18Bloc>().state.appVersion,
                    ),
                  );
                  break;
                default:
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<HomeMenu>>[
                PopupMenuItem<HomeMenu>(
                  value: HomeMenu.refresh,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.refresh,
                        size: 20.0,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Text(AppLocalizations.of(context)!.reconnect),
                    ],
                  ),
                ),
                !state.loadingStatus.isRequestInProgress &&
                        !state.connectionStatus.isRequestInProgress
                    ? PopupMenuItem<HomeMenu>(
                        value: HomeMenu.about,
                        enabled: true,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              CustomIcons.about,
                              size: 20.0,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(AppLocalizations.of(context)!.aboutUs),
                          ],
                        ),
                      )
                    : PopupMenuItem<HomeMenu>(
                        value: HomeMenu.about,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              CustomIcons.about,
                              size: 20.0,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(AppLocalizations.of(context)!.aboutUs),
                          ],
                        ),
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
  const _DeviceStatus({super.key});

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
        } else {
          return const Center(
            child: SizedBox(
              width: CustomStyle.diameter,
              height: CustomStyle.diameter,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        }
      },
    );
  }
}

class _DeviceRefresh extends StatelessWidget {
  const _DeviceRefresh({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (!state.loadingStatus.isRequestInProgress &&
            !state.connectionStatus.isRequestInProgress) {
          return IconButton(
              onPressed: () {
                context
                    .read<Information18Bloc>()
                    .add(const AlarmPeriodicUpdateCanceled());
                context.read<HomeBloc>().add(const DeviceRefreshed());
              },
              icon: Icon(
                Icons.refresh,
                color: Theme.of(context).colorScheme.onPrimary,
              ));
        } else {
          return Container();
        }
      },
    );
  }
}

class _VersionCard extends StatelessWidget {
  const _VersionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Information18Bloc, Information18State>(
      builder: (context, state) => Card(
        color: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.appVersion,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                state.appVersion,
                style: const TextStyle(
                  fontSize: CustomStyle.sizeL,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConnectionCard extends StatelessWidget {
  const _ConnectionCard({super.key});

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
    } else if (scanStatus == FormStatus.requestFailure) {
      return const Text(
        'N/A',
        style: TextStyle(
          fontSize: CustomStyle.sizeL,
        ),
      );
    } else {
      return Text(
        name,
        style: const TextStyle(
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
        color: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
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
                name: state.device != null ? state.device!.name : '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShortcutCard extends StatelessWidget {
  const _ShortcutCard({super.key});

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
          color: Theme.of(context).colorScheme.onPrimary,
          surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
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
    super.key,
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
                  // 要進行設定前先暫停 alarm 定期更新, 避免設定過程中同時要求 alarm 資訊
                  context
                      .read<Information18Bloc>()
                      .add(const AlarmPeriodicUpdateCanceled());

                  showSelectConfigDialog(
                    configs: state.configs,
                  ).then((value) {
                    // 設定結束後, 恢復 alarm 定期更新
                    context
                        .read<Information18Bloc>()
                        .add(const AlarmPeriodicUpdateRequested());
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

class _BlockDiagramCard extends StatelessWidget {
  const _BlockDiagramCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.loadingStatus != current.loadingStatus,
      builder: (context, state) {
        String partId = state.characteristicData[DataKey.partId] ?? '';

        // if (state.loadingStatus.isRequestSuccess) {
        //   context.read<Information18Bloc>().add(DiagramLoaded(partId));
        // }

        return Card(
          color: Theme.of(context).colorScheme.onPrimary,
          surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.blockDiagram,
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
                        AppLocalizations.of(context)!.showDiagram,
                        style: const TextStyle(
                          fontSize: CustomStyle.sizeL,
                        ),
                      ),
                      _ShowDiagramButton(
                        loadingStatus: state.loadingStatus,
                        partId: partId,
                      ),
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

class _ShowDiagramButton extends StatelessWidget {
  const _ShowDiagramButton({
    super.key,
    required this.loadingStatus,
    required this.partId,
  });

  final FormStatus loadingStatus;
  final String partId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Information18Bloc, Information18State>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: loadingStatus.isRequestSuccess
              ? () async {
                  Navigator.push(
                      context,
                      NamePlateView.route(
                        partId: partId,
                      ));
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          child: Text(
            AppLocalizations.of(context)!.show,
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
  const _BasicCard({super.key});

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
        color: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
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

class _AlarmIndicator extends StatelessWidget {
  const _AlarmIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Information18Bloc, Information18State>(
      builder: (context, state) {
        return buildAlarmCard(
          context: context,
          alarmUSeverity: state.alarmUSeverity,
          alarmTSeverity: state.alarmTSeverity,
          alarmPSeverity: state.alarmPSeverity,
        );
      },
    );
  }
}

class _AlarmCard extends StatelessWidget {
  const _AlarmCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      // 上一個狀態跟目前狀態的 loadingStatus 不一樣時才要rebuild,
      // 否則切到 status page 時會 HomeState 而重複觸發 AlarmPeriodicUpdateRequested
      buildWhen: (previous, current) =>
          previous.loadingStatus != current.loadingStatus,
      builder: (context, state) {
        if (state.loadingStatus.isRequestSuccess) {
          context
              .read<Information18Bloc>()
              .add(const AlarmPeriodicUpdateRequested());

          return const _AlarmIndicator();
        } else {
          context
              .read<Information18Bloc>()
              .add(const AlarmPeriodicUpdateCanceled());

          String alarmUSeverity =
              state.characteristicData[DataKey.unitStatusAlarmSeverity] ??
                  'default';
          String alarmTSeverity =
              state.characteristicData[DataKey.temperatureAlarmSeverity] ??
                  'default';
          String alarmPSeverity =
              state.characteristicData[DataKey.voltageAlarmSeverity] ??
                  'default';

          return buildAlarmCard(
            context: context,
            alarmUSeverity: alarmUSeverity,
            alarmTSeverity: alarmTSeverity,
            alarmPSeverity: alarmPSeverity,
          );
        }
      },
    );
  }
}

Widget alarmItem({
  required IconData iconData,
  required String title,
  Color? iconColor,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          iconData,
          color: iconColor,
        ),
        const SizedBox(
          width: 10.0,
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: CustomStyle.sizeL,
          ),
        ),
      ],
    ),
  );
}

Widget buildAlarmCard({
  required BuildContext context,
  required String alarmUSeverity,
  required String alarmTSeverity,
  required String alarmPSeverity,
}) {
  return Card(
    color: Theme.of(context).colorScheme.onPrimary,
    surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.alarmIndicator,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: 10.0,
          ),
          alarmItem(
            iconData: Icons.circle,
            iconColor: CustomStyle.alarmColor[alarmUSeverity],
            title: AppLocalizations.of(context)!.unitStatusAlarm,
          ),
          alarmItem(
            iconData: Icons.circle,
            iconColor: CustomStyle.alarmColor[alarmTSeverity],
            title: AppLocalizations.of(context)!.temperatureAlarm,
          ),
          alarmItem(
            iconData: Icons.circle,
            iconColor: CustomStyle.alarmColor[alarmPSeverity],
            title: AppLocalizations.of(context)!.powerSupplyAlarm,
          ),
        ],
      ),
    ),
  );
}

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
