import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/custom_style.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/core/message_localization.dart';
import 'package:dsim_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatusForm extends StatelessWidget {
  const StatusForm({super.key});

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
          title: Text(AppLocalizations.of(context).status),
          centerTitle: true,
          leading: const _DeviceStatus(),
          actions: const [_DeviceRefresh()],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: const [
              _InfoCard(),
              _AttenuationCard(),
              _TemperatureCard(),
              _PowerSupplyCard(),
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

class _InfoCard extends StatelessWidget {
  const _InfoCard({super.key});

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
                AppLocalizations.of(context).information,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 10.0,
              ),
              itemText(
                title: AppLocalizations.of(context).serialNumber,
                content: state.characteristicData[DataKey.serialNumber] ?? '',
              ),
              itemText(
                title: AppLocalizations.of(context).softwareVersion,
                content:
                    state.characteristicData[DataKey.softwareVersion] ?? '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttenuationCard extends StatelessWidget {
  const _AttenuationCard({super.key});

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
                '${AppLocalizations.of(context).attenuation} ${AppLocalizations.of(context).range}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 30.0,
              ),
              Text(
                AppLocalizations.of(context).range,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              itemText(
                  title: AppLocalizations.of(context).currentAttenuation,
                  content:
                      state.characteristicData[DataKey.currentAttenuation] ??
                          ''),
              itemText(
                  title: AppLocalizations.of(context).minAttenuation,
                  content:
                      state.characteristicData[DataKey.minAttenuation] ?? ''),
              itemText(
                  title: AppLocalizations.of(context).normalAttenuation,
                  content:
                      state.characteristicData[DataKey.normalAttenuation] ??
                          ''),
              itemText(
                  title: AppLocalizations.of(context).maxAttenuation,
                  content:
                      state.characteristicData[DataKey.maxAttenuation] ?? ''),
              const SizedBox(
                height: 26.0,
              ),
              Text(
                AppLocalizations.of(context).historicalAttenuation,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              itemText(
                  title: AppLocalizations.of(context).historicalMinAttenuation,
                  content: state.characteristicData[
                          DataKey.historicalMinAttenuation] ??
                      ''),
              itemText(
                  title: AppLocalizations.of(context).historicalMaxAttenuation,
                  content: state.characteristicData[
                          DataKey.historicalMaxAttenuation] ??
                      ''),
            ],
          ),
        ),
      ),
    );
  }
}

class _TemperatureCard extends StatelessWidget {
  const _TemperatureCard({super.key});

  @override
  Widget build(BuildContext context) {
    Widget itemBlock({required String title, required String content}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                content == ''
                    ? const CircularProgressIndicator()
                    : Text(
                        content,
                        style: const TextStyle(
                          fontSize: 36,
                        ),
                      ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context).temperatureFC,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Material(
                    color: Colors.transparent,
                    elevation: 2.0,
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    child: InkWell(
                      child: Ink(
                        width: 46.0,
                        height: 46.0,
                        decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        child: const Center(
                          child: Text(
                            'ºF',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              itemBlock(
                  title: AppLocalizations.of(context).currentTemperature,
                  content:
                      state.characteristicData[DataKey.currentTemperatureF] ??
                          ''),
              itemBlock(
                  title: AppLocalizations.of(context).minTemperature,
                  content:
                      state.characteristicData[DataKey.minTemperatureF] ?? ''),
              itemBlock(
                  title: AppLocalizations.of(context).maxTemperature,
                  content:
                      state.characteristicData[DataKey.maxTemperatureF] ?? ''),
            ],
          ),
        ),
      ),
    );
  }
}

class _PowerSupplyCard extends StatelessWidget {
  const _PowerSupplyCard({super.key});

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
                AppLocalizations.of(context).powerSupplyVDC,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 30.0,
              ),
              Text(
                AppLocalizations.of(context).voltageLevel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              itemText(
                  title: AppLocalizations.of(context).currentVoltage,
                  content:
                      state.characteristicData[DataKey.currentVoltage] ?? ''),
              itemText(
                  title: AppLocalizations.of(context).minVoltage,
                  content: state.characteristicData[DataKey.minVoltage] ?? ''),
              itemText(
                  title: AppLocalizations.of(context).maxVoltage,
                  content: state.characteristicData[DataKey.maxVoltage] ?? ''),
              const SizedBox(
                height: 26.0,
              ),
              Text(
                AppLocalizations.of(context).voltageRipple,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              itemText(
                  title: AppLocalizations.of(context).currentVoltageRipple,
                  content:
                      state.characteristicData[DataKey.currentVoltageRipple] ??
                          ''),
              itemText(
                  title: AppLocalizations.of(context).minVoltageRipple,
                  content:
                      state.characteristicData[DataKey.minVoltageRipple] ?? ''),
              itemText(
                  title: AppLocalizations.of(context).maxVoltageRipple,
                  content:
                      state.characteristicData[DataKey.maxVoltageRipple] ?? ''),
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
