import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/custom_style.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/core/utils.dart';
import 'package:dsim_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:dsim_app/home/views/home_bottom_navigation_bar.dart';
import 'package:dsim_app/repositories/unit_repository.dart';
import 'package:dsim_app/status/bloc/status_bloc/status_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatusForm extends StatelessWidget {
  const StatusForm({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).status),
        centerTitle: true,
        leading: const _DeviceStatus(),
        actions: const [_DeviceRefresh()],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            // _ModuleCard(),
            _TemperatureCard(),
            _AttenuationCard(),
            _PowerSupplyCard(),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNavigationBar(
        pageController: pageController,
        selectedIndex: 1,
        onTap: (int index) {
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
                loadingStatus: state.loadingStatus,
                title: AppLocalizations.of(context).serialNumber,
                content: state.characteristicData[DataKey.serialNumber] ?? '',
              ),
              itemText(
                loadingStatus: state.loadingStatus,
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
    Widget temperatureBlock({
      required FormStatus loadingStatus,
      required FormStatus connectionStatus,
      required String currentTemperatureTitle,
      required String currentTemperature,
      required String minTemperatureTitle,
      required String minTemperature,
      required String maxTemperatureTitle,
      required String maxTemperature,
    }) {
      if (currentTemperature != '' &&
          minTemperature != '' &&
          maxTemperature != '') {
        minTemperature = adjustMinDoubleValue(
          current: currentTemperature,
          min: minTemperature,
        );
        maxTemperature = adjustMaxDoubleValue(
          current: currentTemperature,
          max: maxTemperature,
        );
      }
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getContent(
                      loadingStatus: loadingStatus,
                      content: currentTemperature,
                      fontSize: 40,
                    ),
                    Text(
                      currentTemperatureTitle,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getContent(
                        loadingStatus: loadingStatus,
                        content: minTemperature,
                        fontSize: 32,
                      ),
                      Text(
                        minTemperatureTitle,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getContent(
                        loadingStatus: loadingStatus,
                        content: maxTemperature,
                        fontSize: 32,
                      ),
                      Text(
                        maxTemperatureTitle,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    const List<TemperatureUnit> temperatureUnitTexts = [
      TemperatureUnit.fahrenheit,
      TemperatureUnit.celsius,
    ];

    List<bool> getSelectionState(TemperatureUnit temperatureUnit) {
      Map<TemperatureUnit, bool> selectedTemperatureUnitMap = {
        TemperatureUnit.fahrenheit: false,
        TemperatureUnit.celsius: false,
      };

      if (selectedTemperatureUnitMap.containsKey(temperatureUnit)) {
        selectedTemperatureUnitMap[temperatureUnit] = true;
      }

      return selectedTemperatureUnitMap.values.toList();
    }

    return Builder(
      builder: (context) {
        final HomeState homeState = context.watch<HomeBloc>().state;
        final StatusState statusState = context.watch<StatusBloc>().state;
        String currentTemperature = '';
        String maxTemperature = '';
        String minTemperature = '';

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
                    Flexible(
                      child: Text(
                        AppLocalizations.of(context).temperatureFC,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Flexible(
                      child: LayoutBuilder(
                        builder: (context, constraints) => ToggleButtons(
                          direction: Axis.horizontal,
                          onPressed: (int index) {
                            context.read<StatusBloc>().add(
                                TemperatureUnitChanged(
                                    temperatureUnitTexts[index]));
                          },
                          textStyle: const TextStyle(fontSize: 18.0),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          selectedBorderColor:
                              Theme.of(context).colorScheme.primary,

                          selectedColor: Theme.of(context)
                              .colorScheme
                              .onPrimary, // white text color

                          fillColor:
                              Theme.of(context).colorScheme.primary, // selected
                          color: Theme.of(context)
                              .colorScheme
                              .secondary, // not selected
                          constraints: BoxConstraints.expand(
                              width: (constraints.maxWidth / 2 - 4) / 2),
                          isSelected:
                              getSelectionState(statusState.temperatureUnit),
                          children: const <Widget>[
                            Text(CustomStyle.fahrenheitUnit),
                            Text(CustomStyle.celciusUnit),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16.0,
                ),
                temperatureBlock(
                  loadingStatus: homeState.loadingStatus,
                  connectionStatus: homeState.connectionStatus,
                  currentTemperatureTitle:
                      AppLocalizations.of(context).currentTemperature,
                  currentTemperature: currentTemperature,
                  minTemperatureTitle:
                      AppLocalizations.of(context).minTemperature,
                  minTemperature: minTemperature,
                  maxTemperatureTitle:
                      AppLocalizations.of(context).maxTemperature,
                  maxTemperature: maxTemperature,
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

  Widget tile({
    required FormStatus loadingStatus,
    required String title,
    required String content,
    required double fontSize,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getContent(
            loadingStatus: loadingStatus,
            content: content,
            fontSize: fontSize,
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
    required FormStatus loadingStatus,
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
    if (currentAttenuation != '' &&
        minAttenuation != '' &&
        maxAttenuation != '') {
      minAttenuation = adjustMinIntValue(
        current: currentAttenuation,
        min: minAttenuation,
      );
      maxAttenuation = adjustMaxIntValue(
        current: currentAttenuation,
        max: maxAttenuation,
      );
    }

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
                      loadingStatus: loadingStatus,
                      title: currentAttenuationTitle,
                      content: currentAttenuation,
                      fontSize: 40,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: tile(
                        loadingStatus: loadingStatus,
                        title: minAttenuationTitle,
                        content: minAttenuation,
                        fontSize: 32,
                      ),
                    ),
                    Expanded(
                      child: tile(
                        loadingStatus: loadingStatus,
                        title: centerAttenuationTitle,
                        content: centerAttenuation,
                        fontSize: 32,
                      ),
                    ),
                    Expanded(
                      child: tile(
                        loadingStatus: loadingStatus,
                        title: maxAttenuationTitle,
                        content: maxAttenuation,
                        fontSize: 32,
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
    required FormStatus loadingStatus,
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
                      loadingStatus: loadingStatus,
                      title: historicalMinAttenuationTitle,
                      content: historicalMinAttenuation,
                      fontSize: 32,
                    ),
                    tile(
                      loadingStatus: loadingStatus,
                      title: historicalMaxAttenuationTitle,
                      content: historicalMaxAttenuation,
                      fontSize: 32,
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
              loadingStatus: state.loadingStatus,
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
              loadingStatus: state.loadingStatus,
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

  Widget tile({
    required FormStatus loadingStatus,
    required String title,
    required String content,
    required double fontSize,
    double? fontHeight,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getContent(
            loadingStatus: loadingStatus,
            content: content,
            fontSize: fontSize,
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
    required FormStatus loadingStatus,
    required String title,
    required String currentVoltageTitle,
    required String currentVoltage,
    required String minVoltageTitle,
    required String minVoltage,
    required String maxVoltageTitle,
    required String maxVoltage,
    required Color borderColor,
  }) {
    if (currentVoltage != '' && minVoltage != '' && maxVoltage != '') {
      minVoltage = adjustMinDoubleValue(
        current: currentVoltage,
        min: minVoltage,
      );
      maxVoltage = adjustMaxDoubleValue(
        current: currentVoltage,
        max: maxVoltage,
      );
    }

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
                  height: 6.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: tile(
                        loadingStatus: loadingStatus,
                        title: minVoltageTitle,
                        content: minVoltage,
                        fontSize: 32,
                      ),
                    ),
                    Expanded(
                      child: tile(
                        loadingStatus: loadingStatus,
                        title: currentVoltageTitle,
                        content: currentVoltage,
                        fontSize: 40,
                        fontHeight: 1.3,
                      ),
                    ),
                    Expanded(
                      child: tile(
                        loadingStatus: loadingStatus,
                        title: maxVoltageTitle,
                        content: maxVoltage,
                        fontSize: 32,
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
    required FormStatus loadingStatus,
    required String title,
    required String currentVoltageRippleTitle,
    required String currentVoltageRipple,
    required String minVoltageRippleTitle,
    required String minVoltageRipple,
    required String maxVoltageRippleTitle,
    required String maxVoltageRipple,
    required Color borderColor,
  }) {
    if (currentVoltageRipple != '' &&
        minVoltageRipple != '' &&
        maxVoltageRipple != '') {
      minVoltageRipple = adjustMinIntValue(
        current: currentVoltageRipple,
        min: minVoltageRipple,
      );
      maxVoltageRipple = adjustMaxIntValue(
        current: currentVoltageRipple,
        max: maxVoltageRipple,
      );
    }

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
                  height: 8.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: tile(
                        loadingStatus: loadingStatus,
                        title: minVoltageRippleTitle,
                        content: minVoltageRipple,
                        fontSize: 32,
                      ),
                    ),
                    Expanded(
                      child: tile(
                        loadingStatus: loadingStatus,
                        title: currentVoltageRippleTitle,
                        content: currentVoltageRipple,
                        fontSize: 40,
                        fontHeight: 1.3,
                      ),
                    ),
                    Expanded(
                      child: tile(
                        loadingStatus: loadingStatus,
                        title: maxVoltageRippleTitle,
                        content: maxVoltageRipple,
                        fontSize: 32,
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
              loadingStatus: state.loadingStatus,
              title:
                  '${AppLocalizations.of(context).voltageLevel} (${CustomStyle.volt})',
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
              loadingStatus: state.loadingStatus,
              title:
                  '${AppLocalizations.of(context).voltageRipple} (${CustomStyle.milliVolt})',
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

Widget getContent({
  required FormStatus loadingStatus,
  required String content,
  double fontSize = 16,
}) {
  if (loadingStatus == FormStatus.requestInProgress) {
    return content.isEmpty
        ? const Center(
            child: SizedBox(
              width: CustomStyle.diameter,
              height: CustomStyle.diameter,
              child: CircularProgressIndicator(),
            ),
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
