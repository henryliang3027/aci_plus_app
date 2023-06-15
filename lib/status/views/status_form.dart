import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/custom_style.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/core/message_localization.dart';
import 'package:dsim_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:dsim_app/status/bloc/status_bloc/status_bloc.dart';
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
        if (state.scanStatus.isRequestFailure) {
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
        body: const SingleChildScrollView(
          child: Column(
            children: [
              _ModuleCard(),
              _TemperatureCard(),
              _AttenuationCard(),
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

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({super.key});

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
                AppLocalizations.of(context).module,
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
                title: AppLocalizations.of(context).firmwareVersion,
                content:
                    state.characteristicData[DataKey.firmwareVersion] ?? '',
              ),
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
                          fontWeight: FontWeight.w500,
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

    return Builder(
      builder: (context) {
        final homeState = context.watch<HomeBloc>().state;
        final statusState = context.watch<StatusBloc>().state;
        String currentTemperature = '';
        String maxTemperature = '';
        String minTemperature = '';

        if (homeState.connectionStatus == FormStatus.requestInProgress) {
          currentTemperature = '';
          maxTemperature = '';
          minTemperature = '';
        } else {
          if (statusState.temperatureUnit == TemperatureUnit.celsius) {
            currentTemperature =
                homeState.characteristicData[DataKey.currentTemperatureC] ?? '';
            maxTemperature =
                homeState.characteristicData[DataKey.maxTemperatureC] ?? '';
            minTemperature =
                homeState.characteristicData[DataKey.minTemperatureC] ?? '';
          } else {
            currentTemperature =
                homeState.characteristicData[DataKey.currentTemperatureF] ?? '';
            maxTemperature =
                homeState.characteristicData[DataKey.maxTemperatureF] ?? '';
            minTemperature =
                homeState.characteristicData[DataKey.minTemperatureF] ?? '';
          }
        }

        return Card(
          color: Theme.of(context).colorScheme.onPrimary,
          surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
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
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                      child: InkWell(
                        child: Ink(
                          width: 46.0,
                          height: 46.0,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8.0))),
                          child: Center(
                            child: Text(
                              statusState.temperatureUnit ==
                                      TemperatureUnit.fahrenheit
                                  ? CustomStyle.celciusUnit
                                  : CustomStyle.fahrenheitUnit,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          TemperatureUnit targetUnit =
                              statusState.temperatureUnit ==
                                      TemperatureUnit.fahrenheit
                                  ? TemperatureUnit.celsius
                                  : TemperatureUnit.fahrenheit;
                          context
                              .read<StatusBloc>()
                              .add(TemperatureUnitChanged(targetUnit));
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16.0,
                ),
                itemBlock(
                  title: AppLocalizations.of(context).currentTemperature,
                  content: currentTemperature,
                ),
                itemBlock(
                  title: AppLocalizations.of(context).minTemperature,
                  content: minTemperature,
                ),
                itemBlock(
                  title: AppLocalizations.of(context).maxTemperature,
                  content: maxTemperature,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AttenuationCard extends StatelessWidget {
  const _AttenuationCard({super.key});

  Widget tile({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          content == ''
              ? const CircularProgressIndicator()
              : Text(
                  content,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
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
    );
  }

  Widget rangeBlock({
    required String title,
    required String currentAttenuationTitle,
    required String currentAttenuation,
    required String centerAttenuationTitle,
    required String centerAttenuation,
    required String minAttenuationTitle,
    required String minAttenuation,
    required String maxAttenuationTitle,
    required String maxAttenuation,
    required Color borderColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColor,
              width: 4.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    tile(
                      title: currentAttenuationTitle,
                      content: currentAttenuation,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: tile(
                        title: minAttenuationTitle,
                        content: minAttenuation,
                      ),
                    ),
                    Expanded(
                      child: tile(
                        title: centerAttenuationTitle,
                        content: centerAttenuation,
                      ),
                    ),
                    Expanded(
                      child: tile(
                        title: maxAttenuationTitle,
                        content: maxAttenuation,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget historicalBlock({
    required String title,
    required String historicalMinAttenuationTitle,
    required String historicalMinAttenuation,
    required String historicalMaxAttenuationTitle,
    required String historicalMaxAttenuation,
    required Color borderColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColor,
              width: 4.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    tile(
                      title: historicalMinAttenuationTitle,
                      content: historicalMinAttenuation,
                    ),
                    tile(
                      title: historicalMaxAttenuationTitle,
                      content: historicalMaxAttenuation,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) => Card(
        color: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 36.0, 16.0, 16.0),
              child: Text(
                AppLocalizations.of(context).attenuation,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            rangeBlock(
              title: AppLocalizations.of(context).range,
              currentAttenuationTitle:
                  AppLocalizations.of(context).currentAttenuation,
              currentAttenuation:
                  state.characteristicData[DataKey.currentAttenuation] ?? '',
              centerAttenuationTitle:
                  AppLocalizations.of(context).centerAttenuation,
              centerAttenuation:
                  state.characteristicData[DataKey.centerAttenuation] ?? '',
              minAttenuationTitle: AppLocalizations.of(context).minAttenuation,
              minAttenuation:
                  state.characteristicData[DataKey.minAttenuation] ?? '',
              maxAttenuationTitle: AppLocalizations.of(context).maxAttenuation,
              maxAttenuation:
                  state.characteristicData[DataKey.maxAttenuation] ?? '',
              borderColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              height: 20.0,
            ),
            historicalBlock(
              title: AppLocalizations.of(context).historicalAttenuation,
              historicalMinAttenuationTitle:
                  AppLocalizations.of(context).historicalMinAttenuation,
              historicalMinAttenuation:
                  state.characteristicData[DataKey.historicalMinAttenuation] ??
                      '',
              historicalMaxAttenuationTitle:
                  AppLocalizations.of(context).historicalMaxAttenuation,
              historicalMaxAttenuation:
                  state.characteristicData[DataKey.historicalMaxAttenuation] ??
                      '',
              borderColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            const SizedBox(
              height: 30.0,
            ),
          ],
        ),
      ),
    );
  }
}

class _PowerSupplyCard extends StatelessWidget {
  const _PowerSupplyCard({super.key});

  Widget tile({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          content == ''
              ? const CircularProgressIndicator()
              : Text(
                  content,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
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
    );
  }

  Widget voltageBlock({
    required String title,
    required String currentVoltageTitle,
    required String currentVoltage,
    required String minVoltageTitle,
    required String minVoltage,
    required String maxVoltageTitle,
    required String maxVoltage,
    required Color borderColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColor,
              width: 4.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: tile(
                        title: minVoltageTitle,
                        content: minVoltage,
                      ),
                    ),
                    Expanded(
                      child: tile(
                        title: currentVoltageTitle,
                        content: currentVoltage,
                      ),
                    ),
                    Expanded(
                      child: tile(
                        title: maxVoltageTitle,
                        content: maxVoltage,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget voltageRippleBlock({
    required String title,
    required String currentVoltageRippleTitle,
    required String currentVoltageRipple,
    required String minVoltageRippleTitle,
    required String minVoltageRipple,
    required String maxVoltageRippleTitle,
    required String maxVoltageRipple,
    required Color borderColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColor,
              width: 4.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: tile(
                        title: minVoltageRippleTitle,
                        content: minVoltageRipple,
                      ),
                    ),
                    Expanded(
                      child: tile(
                        title: currentVoltageRippleTitle,
                        content: currentVoltageRipple,
                      ),
                    ),
                    Expanded(
                      child: tile(
                        title: maxVoltageRippleTitle,
                        content: maxVoltageRipple,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) => Card(
        color: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 36.0, 16.0, 16.0),
              child: Text(
                AppLocalizations.of(context).powerSupplyVDC,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            voltageBlock(
              title: AppLocalizations.of(context).voltageLevel,
              currentVoltageTitle: AppLocalizations.of(context).currentVoltage,
              currentVoltage:
                  state.characteristicData[DataKey.currentVoltage] ?? '',
              minVoltageTitle: AppLocalizations.of(context).minVoltage,
              minVoltage: state.characteristicData[DataKey.minVoltage] ?? '',
              maxVoltageTitle: AppLocalizations.of(context).maxVoltage,
              maxVoltage: state.characteristicData[DataKey.maxVoltage] ?? '',
              borderColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              height: 20.0,
            ),
            voltageRippleBlock(
              title: AppLocalizations.of(context).voltageRipple,
              currentVoltageRippleTitle:
                  AppLocalizations.of(context).currentVoltageRipple,
              currentVoltageRipple:
                  state.characteristicData[DataKey.currentVoltageRipple] ?? '',
              minVoltageRippleTitle:
                  AppLocalizations.of(context).minVoltageRipple,
              minVoltageRipple:
                  state.characteristicData[DataKey.minVoltageRipple] ?? '',
              maxVoltageRippleTitle:
                  AppLocalizations.of(context).maxVoltageRipple,
              maxVoltageRipple:
                  state.characteristicData[DataKey.maxVoltageRipple] ?? '',
              borderColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            const SizedBox(
              height: 30.0,
            ),
          ],
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
