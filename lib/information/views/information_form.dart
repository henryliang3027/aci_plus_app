import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/home/views/home_bottom_navigation_bar.dart';
import 'package:aci_plus_app/information/bloc/information/information_bloc.dart';
import 'package:aci_plus_app/information/shared/theme_option_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class InformationForm extends StatelessWidget {
  const InformationForm({
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
            _BasicCard(),
            _AlarmCard(),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNavigationBar(
        pageController: pageController,
        selectedIndex: 2,
        onTap: (int index) {
          if (index != 2) {
            context
                .read<InformationBloc>()
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

enum HomeMenu {
  refresh,
  theme,
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
                    context
                        .read<InformationBloc>()
                        .add(const AlarmPeriodicUpdateCanceled());
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

// class _DeviceRefresh extends StatelessWidget {
//   const _DeviceRefresh();

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeBloc, HomeState>(
//       builder: (context, state) {
//         if (!state.loadingStatus.isRequestInProgress &&
//             !state.connectionStatus.isRequestInProgress) {
//           return IconButton(
//               onPressed: () {
//                 context.read<HomeBloc>().add(const DeviceRefreshed());
//               },
//               icon: Icon(
//                 Icons.refresh,
//                 color: Theme.of(context).colorScheme.onPrimary,
//               ));
//         } else {
//           return Container();
//         }
//       },
//     );
//   }
// }

class _VersionCard extends StatelessWidget {
  const _VersionCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InformationBloc, InformationState>(
      builder: (context, state) => Card(
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
              // ElevatedButton(
              //     onPressed: () {
              //       context.read<HomeBloc>().add(testTimeout());
              //     },
              //     child: Icon(Icons.abc)),
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

class _BasicCard extends StatelessWidget {
  const _BasicCard();

  @override
  Widget build(BuildContext context) {
    String getCurrentPilot({
      required String currentPilot,
      required String currentPilotMode,
    }) {
      if (currentPilot.isEmpty) {
        return '';
      } else if (currentPilot == 'Loss') {
        return currentPilot;
      } else if (currentPilotMode.isEmpty) {
        return '';
      } else {
        return '$currentPilot $currentPilotMode';
      }
    }

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
                title: AppLocalizations.of(context)!.logInterval,
                content: getCurrentLogInterval(
                    state.characteristicData[DataKey.logInterval] ?? ''),
              ),
              itemMultipleLineText(
                loadingStatus: state.loadingStatus,
                title: AppLocalizations.of(context)!.location,
                content: state.characteristicData[DataKey.location] ?? '',
              ),
              itemText(
                loadingStatus: state.loadingStatus,
                title: AppLocalizations.of(context)!.dsimMode,
                content: state.characteristicData[DataKey.workingMode] ?? '',
              ),
              itemText(
                loadingStatus: state.loadingStatus,
                title: AppLocalizations.of(context)!.currentPilot,
                content: getCurrentPilot(
                    currentPilot:
                        state.characteristicData[DataKey.currentPilot] ?? '',
                    currentPilotMode:
                        state.characteristicData[DataKey.currentPilotMode] ??
                            ''),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _AlarmIndicator extends StatelessWidget {
  const _AlarmIndicator();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InformationBloc, InformationState>(
      builder: (context, state) {
        return buildAlarmCard(
          context: context,
          alarmRSeverity: state.alarmRSeverity,
          alarmTSeverity: state.alarmTSeverity,
          alarmPSeverity: state.alarmPSeverity,
        );
      },
    );
  }
}

class _AlarmCard extends StatelessWidget {
  const _AlarmCard();

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
              .read<InformationBloc>()
              .add(const AlarmPeriodicUpdateRequested());

          return const _AlarmIndicator();
        } else {
          context
              .read<InformationBloc>()
              .add(const AlarmPeriodicUpdateCanceled());

          String alarmRSeverity =
              state.characteristicData[DataKey.alarmRSeverity] ?? 'default';
          String alarmTSeverity =
              state.characteristicData[DataKey.alarmTSeverity] ?? 'default';
          String alarmPSeverity =
              state.characteristicData[DataKey.alarmPSeverity] ?? 'default';

          return buildAlarmCard(
            context: context,
            alarmRSeverity: alarmRSeverity,
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
  required String alarmRSeverity,
  required String alarmTSeverity,
  required String alarmPSeverity,
}) {
  return Card(
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
            iconColor: CustomStyle.alarmColor[alarmRSeverity],
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
            style: TextStyle(
              fontSize: fontSize,
            ),
          );
  } else if (loadingStatus == FormStatus.requestSuccess) {
    return Text(
      content,
      style: TextStyle(
        fontSize: fontSize,
      ),
    );
  } else {
    return Text(
      content.isEmpty ? 'N/A' : content,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            Flexible(
              child: getContent(
                loadingStatus: loadingStatus,
                content: content,
              ),
            ),
          ],
        ),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            Uri uri =
                Uri.parse('http://acicomms.com/support/aci-dsim-setup-videos');
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
