import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/custom_style.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/core/message_localization.dart';
import 'package:dsim_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class InformationForm extends StatelessWidget {
  const InformationForm({super.key});

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
        }
      },
      child: Scaffold(
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
        if (!state.scanStatus.isRequestInProgress) {
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
              itemText(
                title: AppLocalizations.of(context).bluetooth,
                content: state.device != null ? state.device!.name : '',
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
      if (currentPilot == 'Loss') {
        return currentPilot;
      } else {
        return '$currentPilot $currentPilotMode';
      }
    }

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
                AppLocalizations.of(context).basic,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 10.0,
              ),
              itemText(
                title: AppLocalizations.of(context).typeNo,
                content: state.characteristicData[DataKey.typeNo] ?? '',
              ),
              itemText(
                title: AppLocalizations.of(context).partNo,
                content: state.characteristicData[DataKey.partNo] ?? '',
              ),
              itemMultipleLineText(
                title: AppLocalizations.of(context).location,
                content: state.characteristicData[DataKey.location] ?? '',
              ),
              itemText(
                title: AppLocalizations.of(context).dsimMode,
                content: state.characteristicData[DataKey.dsimMode] ?? '',
              ),
              itemText(
                title: AppLocalizations.of(context).currentPilot,
                content: getCurrentPilot(
                    currentPilot:
                        state.characteristicData[DataKey.currentPilot] ?? '',
                    currentPilotMode:
                        state.characteristicData[DataKey.currentPilotMode] ??
                            ''),
              ),
              itemText(
                title: AppLocalizations.of(context).logInterval,
                content:
                    '${state.characteristicData[DataKey.logInterval] ?? ''} minutes',
              ),
            ],
          ),
        ),
      ),
    );
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
                AppLocalizations.of(context).alarm,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 10.0,
              ),
              alarmItem(
                iconData: Icons.circle,
                iconColor: CustomStyle.alarmColor[
                    state.characteristicData[DataKey.alarmRServerity] ?? ''],
                title: AppLocalizations.of(context).rfPilotLevel,
              ),
              alarmItem(
                iconData: Icons.circle,
                iconColor: CustomStyle.alarmColor[
                    state.characteristicData[DataKey.alarmTServerity] ?? ''],
                title: AppLocalizations.of(context).temperature,
              ),
              alarmItem(
                iconData: Icons.circle,
                iconColor: CustomStyle.alarmColor[
                    state.characteristicData[DataKey.alarmPServerity] ?? ''],
                title: AppLocalizations.of(context).powerSupply,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget itemText({
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
        content == ''
            ? const CircularProgressIndicator()
            : Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                ),
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

Widget itemMultipleLineText({
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
            content == ''
                ? const CircularProgressIndicator()
                : Flexible(
                    child: Text(
                      content,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
          ],
        ),
      ],
    ),
  );
}
