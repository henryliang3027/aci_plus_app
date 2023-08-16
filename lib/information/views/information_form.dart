import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/custom_style.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:dsim_app/information/bloc/information_bloc/information_bloc.dart';
import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class InformationForm extends StatelessWidget {
  const InformationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).information),
        centerTitle: true,
        leading: const _DeviceStatus(),
        actions: const [_DeviceRefresh()],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            _ConnectionCard(),
            _BasicCard(),
            _AlarmCard(),
          ],
        ),
      ),
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
                width: 20.0,
                height: 20.0,
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
              width: 20.0,
              height: 20.0,
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
        if (!state.connectionStatus.isRequestInProgress) {
          return IconButton(
              onPressed: () {
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

class _ConnectionCard extends StatelessWidget {
  const _ConnectionCard({super.key});

  Widget getBluetoothName({
    required FormStatus scanStatus,
    required String title,
    required String name,
  }) {
    if (scanStatus == FormStatus.requestInProgress) {
      return const CircularProgressIndicator();
    } else if (scanStatus == FormStatus.requestFailure) {
      return const Text(
        'N/A',
        style: TextStyle(
          fontSize: 16,
        ),
      );
    } else {
      return Text(
        name,
        style: const TextStyle(
          fontSize: 16,
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
              fontSize: 16,
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
                AppLocalizations.of(context).connection,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 10.0,
              ),
              bluetoothText(
                scanStatus: state.scanStatus,
                title: AppLocalizations.of(context).bluetooth,
                name: state.device != null ? state.device!.name : '',
              ),
              itemLinkText(
                title: 'DSIM',
                content: AppLocalizations.of(context).visitWebsite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BasicCard extends StatelessWidget {
  const _BasicCard({super.key});

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
        return '$logInterval minute';
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
                AppLocalizations.of(context).basic,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 10.0,
              ),
              itemText(
                loadingStatus: state.loadingStatus,
                title: AppLocalizations.of(context).typeNo,
                content: state.characteristicData[DataKey.partName] ?? '',
              ),
              itemText(
                loadingStatus: state.loadingStatus,
                title: AppLocalizations.of(context).partNo,
                content: state.characteristicData[DataKey.partNo] ?? '',
              ),
              itemMultipleLineText(
                loadingStatus: state.loadingStatus,
                title: AppLocalizations.of(context).location,
                content: state.characteristicData[DataKey.location] ?? '',
              ),
              itemText(
                loadingStatus: state.loadingStatus,
                title: AppLocalizations.of(context).dsimMode,
                content: state.characteristicData[DataKey.workingMode] ?? '',
              ),
              itemText(
                loadingStatus: state.loadingStatus,
                title: AppLocalizations.of(context).currentPilot,
                content: getCurrentPilot(
                    currentPilot:
                        state.characteristicData[DataKey.currentPilot] ?? '',
                    currentPilotMode:
                        state.characteristicData[DataKey.currentPilotMode] ??
                            ''),
              ),
              itemText(
                loadingStatus: state.loadingStatus,
                title: AppLocalizations.of(context).logInterval,
                content: getCurrentLogInterval(
                    state.characteristicData[DataKey.logInterval] ?? ''),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _AlarmCard extends StatelessWidget {
  const _AlarmCard({super.key});

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
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget buildAlarmCard({
      required String alarmRSeverity,
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
                AppLocalizations.of(context).alarm,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 10.0,
              ),
              alarmItem(
                iconData: Icons.circle,
                // iconColor: CustomStyle.alarmColor[
                //     state.characteristicData[DataKey.alarmRServerity] ??
                //         'default'],
                iconColor: CustomStyle.alarmColor[alarmRSeverity],
                title: AppLocalizations.of(context).rfPilotLevelAlarm,
              ),
              alarmItem(
                iconData: Icons.circle,
                // iconColor: CustomStyle.alarmColor[
                //     state.characteristicData[DataKey.alarmTServerity] ??
                //         'default'],
                iconColor: CustomStyle.alarmColor[alarmTSeverity],
                title: AppLocalizations.of(context).temperatureAlarm,
              ),
              alarmItem(
                iconData: Icons.circle,
                // iconColor: CustomStyle.alarmColor[
                //     state.characteristicData[DataKey.alarmPServerity] ??
                //         'default'],
                iconColor: CustomStyle.alarmColor[alarmPSeverity],
                title: AppLocalizations.of(context).powerSupplyAlarm,
              ),
            ],
          ),
        ),
      );
    }

    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      String alarmRSeverity =
          state.characteristicData[DataKey.alarmRSeverity] ?? 'default';
      String alarmTSeverity =
          state.characteristicData[DataKey.alarmTSeverity] ?? 'default';
      String alarmPSeverity =
          state.characteristicData[DataKey.alarmPSeverity] ?? 'default';

      if (state.loadingStatus.isRequestSuccess) {
        // informationState 的 alarmRSeverity, alarmTSeverity, alarmPSeverity 還是 'default' 時代表還沒有觸發定期讀取資料, 這時候用 homeState 讀到的值來顯示
        // 觸發定期更新後就持續顯示 informationState 的值
        return BlocProvider(
          create: (context) => InformationBloc(
              dsimRepository: RepositoryProvider.of<DsimRepository>(context)),
          child: BlocBuilder<InformationBloc, InformationState>(
            builder: (context, informationState) => buildAlarmCard(
              alarmRSeverity: informationState.alarmRSeverity == 'default'
                  ? alarmRSeverity
                  : informationState.alarmRSeverity,
              alarmTSeverity: informationState.alarmTSeverity == 'default'
                  ? alarmTSeverity
                  : informationState.alarmTSeverity,
              alarmPSeverity: informationState.alarmPSeverity == 'default'
                  ? alarmPSeverity
                  : informationState.alarmPSeverity,
            ),
          ),
        );
      } else {
        // homeState formStatus failure or inProgress 時都用 homeState 讀到的值來顯示
        return buildAlarmCard(
          alarmRSeverity: alarmRSeverity,
          alarmTSeverity: alarmTSeverity,
          alarmPSeverity: alarmPSeverity,
        );
      }
    });
  }
}

Widget getContent({
  required FormStatus loadingStatus,
  required String content,
  double fontSize = 16,
}) {
  if (loadingStatus == FormStatus.requestInProgress) {
    return content.isEmpty
        ? const CircularProgressIndicator()
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
            fontSize: 16,
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
                fontSize: 16,
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
            fontSize: 16,
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
              fontSize: 16,
            ),
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
