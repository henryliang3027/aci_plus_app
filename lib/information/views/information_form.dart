import 'package:dsim_app/core/custom_style.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/core/message_localization.dart';
import 'package:dsim_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        if (state.status.isRequestFailure) {
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
        body: SingleChildScrollView(
          child: Column(
            children: const [
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
        if (state.status.isRequestSuccess) {
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
        } else if (state.status.isRequestFailure) {
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
        if (!state.status.isRequestInProgress) {
          return ElevatedButton(
              onPressed: () {
                context.read<HomeBloc>().add(const DeviceRefreshed());
              },
              child: const Icon(
                Icons.refresh,
                color: Colors.white,
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
    Widget connectionText({
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
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) => Card(
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
              connectionText(
                title: AppLocalizations.of(context).bluetooth,
                content: state.device != null ? state.device!.name : '',
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
    Widget basicText({
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
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    Widget basicTextMultipleLine({
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

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) => Card(
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
              basicText(
                title: AppLocalizations.of(context).typeNo,
                content: state.typeNo,
              ),
              basicText(
                title: AppLocalizations.of(context).partNo,
                content: state.partNo,
              ),
              basicTextMultipleLine(
                title: AppLocalizations.of(context).location,
                content: state.location,
              ),
              basicText(
                title: AppLocalizations.of(context).dsimMode,
                content: state.dsimMode,
              ),
              basicText(
                title: AppLocalizations.of(context).currentPilot,
                content: state.currentPilot,
              ),
              basicText(
                title: AppLocalizations.of(context).logInterval,
                content: state.logInterval,
              ),
              basicText(
                title: AppLocalizations.of(context).serialNumber,
                content: state.serialNumber,
              ),
              basicText(
                title: AppLocalizations.of(context).softwareVersion,
                content: state.softwareVersion,
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

  Widget _alarmItem({
    required IconData iconData,
    required Color iconColor,
    required String title,
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
              _alarmItem(
                iconData: Icons.circle,
                iconColor: Colors.green,
                title: AppLocalizations.of(context).rfPilotLevel,
              ),
              _alarmItem(
                iconData: Icons.circle,
                iconColor: Colors.green,
                title: AppLocalizations.of(context).temperature,
              ),
              _alarmItem(
                iconData: Icons.circle,
                iconColor: Colors.green,
                title: AppLocalizations.of(context).powerSupply,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
