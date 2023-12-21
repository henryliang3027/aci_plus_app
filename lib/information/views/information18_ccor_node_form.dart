import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:aci_plus_app/home/views/home_bottom_navigation_bar.dart';
import 'package:aci_plus_app/information/bloc/information18_ccor_node_bloc/information18_ccor_node_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class Information18CCorNodeForm extends StatelessWidget {
  const Information18CCorNodeForm({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.information),
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
      bottomNavigationBar: HomeBottomNavigationBar(
        pageController: pageController,
        selectedIndex: 2,
        onTap: (int index) {
          if (index != 2) {
            context
                .read<Information18CCorNodeBloc>()
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
      return const SizedBox(
        width: CustomStyle.diameter,
        height: CustomStyle.diameter,
        child: CircularProgressIndicator(),
      );
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
                AppLocalizations.of(context)!.connection,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 10.0,
              ),
              itemLinkText(
                title: '',
                content: AppLocalizations.of(context)!.visitWebsite,
              ),
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
                AppLocalizations.of(context)!.basic,
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
    return BlocBuilder<Information18CCorNodeBloc, Information18CCorNodeState>(
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
      builder: (context, state) {
        if (state.loadingStatus.isRequestSuccess) {
          context
              .read<Information18CCorNodeBloc>()
              .add(const AlarmPeriodicUpdateRequested());

          return const _AlarmIndicator();
        } else {
          context
              .read<Information18CCorNodeBloc>()
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
            fontSize: 16,
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
            AppLocalizations.of(context)!.alarm,
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
                  //     fontSize: 16,
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
