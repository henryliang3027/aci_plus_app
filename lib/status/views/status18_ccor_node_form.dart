import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/home/views/home_button_navigation_bar18.dart';
import 'package:aci_plus_app/repositories/unit_repository.dart';
import 'package:aci_plus_app/status/bloc/status18_ccor_node/status18_ccor_node_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Status18CCorNodeForm extends StatelessWidget {
  const Status18CCorNodeForm({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.status),
        centerTitle: true,
        leading: const _DeviceStatus(),
        actions: const [_DeviceRefresh()],
      ),
      body: const _CardView(),
      bottomNavigationBar: HomeBottomNavigationBar18(
        pageController: pageController,
        selectedIndex: 1,
        onTap: (int index) {
          context
              .read<Status18CCorNodeBloc>()
              .add(const StatusPeriodicUpdateCanceled());

          pageController.jumpToPage(
            index,
          );
        },
      ),
    );
  }
}

class _CardView extends StatelessWidget {
  const _CardView();

  @override
  Widget build(BuildContext context) {
    Widget getWidgetsByPartId(String partId) {
      List<Enum> items = SettingItemTable.itemsMap[partId] ?? [];
      List<Widget> widgets = [];

      items =
          items.where((item) => item.runtimeType == SettingThreshold).toList();

      for (Enum name in items) {
        switch (name) {
          case SettingThreshold.workingMode:
            widgets.add(const _WorkingModeCard());
            break;
          case SettingThreshold.splitOptions:
            widgets.add(const _SplitOptionCard());
            break;
          case SettingThreshold.temperature:
            widgets.add(const _TemperatureCard());
            break;
          case SettingThreshold.inputVoltage24V:
            widgets.add(const _PowerSupplyCard());
            break;
          case SettingThreshold.outputPower1:
            widgets.add(const _RFOutputPower1Card());
            break;
          case SettingThreshold.outputPower3:
            widgets.add(const _RFOutputPower3Card());
            break;
          case SettingThreshold.outputPower4:
            widgets.add(const _RFOutputPower4Card());
            break;
          case SettingThreshold.outputPower6:
            widgets.add(const _RFOutputPower6Card());
            break;
        }
      }

      return widgets.isNotEmpty
          ? SingleChildScrollView(
              child: Column(
                children: [
                  ...widgets,
                ],
              ),
            )
          : const SingleChildScrollView(
              child: Column(
                children: [
                  _WorkingModeCard(),
                  _SplitOptionCard(),
                  _TemperatureCard(),
                  _PowerSupplyCard(),
                  _RFOutputPower1Card(),
                  _RFOutputPower3Card(),
                  _RFOutputPower4Card(),
                  _RFOutputPower6Card(),
                ],
              ),
            );
    }

    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.loadingStatus != current.loadingStatus,
      builder: (context, state) {
        String partId = state.characteristicData[DataKey.partId] ?? '';
        if (state.loadingStatus.isRequestSuccess) {
          context
              .read<Status18CCorNodeBloc>()
              .add(const StatusPeriodicUpdateRequested());

          return getWidgetsByPartId(partId);
        } else {
          context
              .read<Status18CCorNodeBloc>()
              .add(const StatusPeriodicUpdateCanceled());

          return getWidgetsByPartId(partId);
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

Color _getCurrentValueColor(
    {required String alarmState, required String alarmSeverity}) {
  return alarmState == '0'
      ? CustomStyle.alarmColor[alarmSeverity]!
      : CustomStyle.alarmColor['mask']!;
}

class _DeviceRefresh extends StatelessWidget {
  const _DeviceRefresh();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (!state.loadingStatus.isRequestInProgress &&
            !state.connectionStatus.isRequestInProgress) {
          return IconButton(
              onPressed: () {
                context
                    .read<Status18CCorNodeBloc>()
                    .add(const StatusPeriodicUpdateCanceled());
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

class _WorkingModeCard extends StatelessWidget {
  const _WorkingModeCard();

  // Color currentWorkingModeColor({
  //   required String currentVoltage,
  // }) {
  //   double min = double.parse(minVoltage);
  //   double max = double.parse(maxVoltage);
  //   double current = double.parse(currentVoltage);

  //   return _getCurrentValueColor(
  //     alarmStatus: voltageAlarmState,
  //     min: min,
  //     max: max,
  //     current: current,
  //   );
  // }

  Widget getCurrentWorkingMode({
    required FormStatus loadingStatus,
    required String currentWorkingMode,
    double fontSize = 16,
  }) {
    if (loadingStatus == FormStatus.requestInProgress) {
      return currentWorkingMode.isEmpty
          ? const Center(
              child: SizedBox(
                width: CustomStyle.diameter,
                height: CustomStyle.diameter,
                child: CircularProgressIndicator(),
              ),
            )
          : Text(
              currentWorkingMode,
              style: TextStyle(
                fontSize: fontSize,
              ),
            );
    } else if (loadingStatus == FormStatus.requestSuccess) {
      return Text(
        currentWorkingMode.isEmpty ? 'N/A' : currentWorkingMode,
        style: TextStyle(
          fontSize: fontSize,
          // color: currentWorkingModeColor(
          //   voltageAlarmState: voltageAlarmState,
          //   minVoltage: minVoltage,
          //   maxVoltage: maxVoltage,
          //   currentVoltage: currentVoltage,
          // ),
        ),
      );
    } else {
      return Text(
        currentWorkingMode.isEmpty ? 'N/A' : currentWorkingMode,
        style: TextStyle(
          fontSize: fontSize,
        ),
      );
    }
  }

  Widget workingModeBlock({
    required FormStatus loadingStatus,
    required String currentWorkingMode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getCurrentWorkingMode(
                      loadingStatus: loadingStatus,
                      currentWorkingMode: currentWorkingMode,
                      fontSize: CustomStyle.size4XL,
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

  String getWorkingModeText(String workingMode) {
    if (workingMode == '13') {
      return 'AGC';
    } else if (workingMode == '14') {
      return 'TGC';
    } else {
      return workingMode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      String currentWorkingMode =
          state.characteristicData[DataKey.currentWorkingMode] ?? '';

      String workingMode = currentWorkingMode == '0'
          ? 'N/A'
          : getWorkingModeText(currentWorkingMode);

      return Card(
        color: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 36.0, 16.0, 16.0),
              child: Text(
                AppLocalizations.of(context)!.workingMode,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            workingModeBlock(
              loadingStatus: state.loadingStatus,
              currentWorkingMode: workingMode,
            ),
            const SizedBox(
              height: CustomStyle.sizeXXL,
            ),
          ],
        ),
      );
    });
  }
}

class _SplitOptionCard extends StatelessWidget {
  const _SplitOptionCard();

  Widget getCurrentSplitOption({
    required FormStatus loadingStatus,
    required String splitOptionAlarmState,
    required String splitOptionAlarmSeverity,
    required String currentSplitOption,
    double fontSize = 16,
  }) {
    if (loadingStatus == FormStatus.requestInProgress) {
      return currentSplitOption.isEmpty
          ? const Center(
              child: SizedBox(
                width: CustomStyle.diameter,
                height: CustomStyle.diameter,
                child: CircularProgressIndicator(),
              ),
            )
          : Text(
              currentSplitOption,
              style: TextStyle(
                fontSize: fontSize,
              ),
            );
    } else if (loadingStatus == FormStatus.requestSuccess) {
      return Text(
        currentSplitOption.isEmpty ? 'N/A' : currentSplitOption,
        style: TextStyle(
          fontSize: fontSize,
          color: _getCurrentValueColor(
            alarmState: splitOptionAlarmState,
            alarmSeverity: splitOptionAlarmSeverity,
          ),
        ),
      );
    } else {
      return Text(
        currentSplitOption.isEmpty ? 'N/A' : currentSplitOption,
        style: TextStyle(
          fontSize: fontSize,
        ),
      );
    }
  }

  Widget splitOptionBlock({
    required FormStatus loadingStatus,
    required String splitOptionAlarmState,
    required String splitOptionAlarmSeverity,
    required String currentSplitOption,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getCurrentSplitOption(
                      loadingStatus: loadingStatus,
                      splitOptionAlarmState: splitOptionAlarmState,
                      splitOptionAlarmSeverity: splitOptionAlarmSeverity,
                      currentSplitOption: currentSplitOption,
                      fontSize: CustomStyle.size4XL,
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

  @override
  Widget build(BuildContext context) {
    Map<String, String> types = const {
      '0': 'N/A',
      '1': '204/258 MHz',
      '2': '300/372 MHz',
      '3': '396/492 MHz',
      '4': '492/606 MHz',
      '5': '684/834 MHz',
    };

    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      String currentSplitOption =
          state.characteristicData[DataKey.currentDetectedSplitOption] ?? '';

      String splitOption =
          currentSplitOption == '' ? 'N/A' : types[currentSplitOption] ?? 'N/A';

      String splitOptionAlarmState =
          state.characteristicData[DataKey.splitOptionAlarmState] ?? '1';

      String splitOptionAlarmSeverity =
          state.characteristicData[DataKey.splitOptionAlarmSeverity] ?? '1';

      return Card(
        color: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 36.0, 16.0, 16.0),
              child: Text(
                AppLocalizations.of(context)!.splitOption,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            splitOptionBlock(
              loadingStatus: state.loadingStatus,
              splitOptionAlarmState: splitOptionAlarmState,
              splitOptionAlarmSeverity: splitOptionAlarmSeverity,
              currentSplitOption: splitOption,
            ),
            const SizedBox(
              height: CustomStyle.sizeXXL,
            ),
          ],
        ),
      );
    });
  }
}

class _TemperatureCard extends StatelessWidget {
  const _TemperatureCard();

  @override
  Widget build(BuildContext context) {
    Widget getCurrentTemperature({
      required FormStatus loadingStatus,
      required String temperatureAlarmState,
      required String temperatureAlarmSeverity,
      required String minTemperature,
      required String maxTemperature,
      required String currentTemperature,
      required String unit,
      double fontSize = 16,
    }) {
      if (loadingStatus == FormStatus.requestInProgress) {
        return currentTemperature.isEmpty
            ? const Center(
                child: SizedBox(
                  width: CustomStyle.diameter,
                  height: CustomStyle.diameter,
                  child: CircularProgressIndicator(),
                ),
              )
            : Text(
                currentTemperature,
                style: TextStyle(
                  fontSize: fontSize,
                ),
              );
      } else if (loadingStatus == FormStatus.requestSuccess) {
        return Text(
          currentTemperature.isEmpty ? 'N/A' : currentTemperature,
          style: TextStyle(
            fontSize: fontSize,
            color: _getCurrentValueColor(
              alarmState: temperatureAlarmState,
              alarmSeverity: temperatureAlarmSeverity,
            ),
          ),
        );
      } else {
        return Text(
          currentTemperature.isEmpty ? 'N/A' : currentTemperature,
          style: TextStyle(
            fontSize: fontSize,
          ),
        );
      }
    }

    Widget getHistoricalMinTemperature({
      required FormStatus loadingStatus,
      required String minTemperature,
      required String unit,
      double fontSize = 16,
    }) {
      if (loadingStatus == FormStatus.requestInProgress) {
        return minTemperature.isEmpty
            ? const Center(
                child: SizedBox(
                  width: CustomStyle.diameter,
                  height: CustomStyle.diameter,
                  child: CircularProgressIndicator(),
                ),
              )
            : Text(
                minTemperature,
                style: TextStyle(
                  fontSize: fontSize,
                ),
              );
      } else if (loadingStatus == FormStatus.requestSuccess) {
        return Text(
          minTemperature.isEmpty ? 'N/A' : minTemperature,
          style: TextStyle(
            fontSize: fontSize,
          ),
        );
      } else {
        return Text(
          minTemperature.isEmpty ? 'N/A' : minTemperature,
          style: TextStyle(
            fontSize: fontSize,
          ),
        );
      }
    }

    Widget getHistoricalMaxTemperature({
      required FormStatus loadingStatus,
      required String maxTemperature,
      required String unit,
      double fontSize = 16,
    }) {
      if (loadingStatus == FormStatus.requestInProgress) {
        return maxTemperature.isEmpty
            ? const Center(
                child: SizedBox(
                  width: CustomStyle.diameter,
                  height: CustomStyle.diameter,
                  child: CircularProgressIndicator(),
                ),
              )
            : Text(
                maxTemperature,
                style: TextStyle(
                  fontSize: fontSize,
                ),
              );
      } else if (loadingStatus == FormStatus.requestSuccess) {
        return Text(
          maxTemperature.isEmpty ? 'N/A' : maxTemperature,
          style: TextStyle(
            fontSize: fontSize,
          ),
        );
      } else {
        return Text(
          maxTemperature.isEmpty ? 'N/A' : maxTemperature,
          style: TextStyle(
            fontSize: fontSize,
          ),
        );
      }
    }

    Widget temperatureBlock({
      required FormStatus loadingStatus,
      required FormStatus connectionStatus,
      required String temperatureAlarmState,
      required String temperatureAlarmSeverity,
      required String currentTemperatureTitle,
      required String currentTemperature,
      required String minTemperatureTitle,
      required String minTemperature,
      required String maxTemperatureTitle,
      required String maxTemperature,
      required String historicalMinTemperature,
      required String historicalMaxTemperature,
      required String unit,
    }) {
      if (currentTemperature != '' &&
          historicalMinTemperature != '' &&
          historicalMaxTemperature != '') {
        historicalMinTemperature = adjustMinDoubleValue(
          current: currentTemperature,
          min: historicalMinTemperature,
        );
        historicalMaxTemperature = adjustMaxDoubleValue(
          current: currentTemperature,
          max: historicalMaxTemperature,
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
                    getCurrentTemperature(
                      loadingStatus: loadingStatus,
                      temperatureAlarmState: temperatureAlarmState,
                      temperatureAlarmSeverity: temperatureAlarmSeverity,
                      minTemperature: minTemperature,
                      maxTemperature: maxTemperature,
                      currentTemperature: currentTemperature,
                      unit: unit,
                      fontSize: CustomStyle.size4XL,
                    ),
                    Text(
                      currentTemperatureTitle,
                      style: const TextStyle(
                        fontSize: CustomStyle.sizeL,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: CustomStyle.sizeXXL,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getHistoricalMinTemperature(
                        loadingStatus: loadingStatus,
                        minTemperature: historicalMinTemperature,
                        unit: unit,
                        fontSize: CustomStyle.size32,
                      ),
                      Text(
                        minTemperatureTitle,
                        style: const TextStyle(
                          fontSize: CustomStyle.sizeL,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getHistoricalMaxTemperature(
                        loadingStatus: loadingStatus,
                        maxTemperature: historicalMaxTemperature,
                        unit: unit,
                        fontSize: CustomStyle.size32,
                      ),
                      Text(
                        maxTemperatureTitle,
                        style: const TextStyle(
                          fontSize: CustomStyle.sizeL,
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
        final Status18CCorNodeState status18State =
            context.watch<Status18CCorNodeBloc>().state;
        String temperatureAlarmState =
            homeState.characteristicData[DataKey.temperatureAlarmState] ?? '1';
        String temperatureAlarmSeverity =
            homeState.characteristicData[DataKey.temperatureAlarmSeverity] ??
                '0';
        String currentTemperature = '';
        String maxTemperature = '';
        String minTemperature = '';
        String historicalMaxTemperature = '';
        String historicalMinTemperature = '';

        if (status18State.temperatureUnit == TemperatureUnit.celsius) {
          currentTemperature =
              homeState.characteristicData[DataKey.currentTemperatureC] ?? '';
          maxTemperature =
              homeState.characteristicData[DataKey.maxTemperatureC] ?? '';
          minTemperature =
              homeState.characteristicData[DataKey.minTemperatureC] ?? '';
          historicalMaxTemperature =
              homeState.characteristicData[DataKey.historicalMaxTemperatureC] ??
                  '';
          historicalMinTemperature =
              homeState.characteristicData[DataKey.historicalMinTemperatureC] ??
                  '';
        } else {
          currentTemperature =
              homeState.characteristicData[DataKey.currentTemperatureF] ?? '';
          maxTemperature =
              homeState.characteristicData[DataKey.maxTemperatureF] ?? '';
          minTemperature =
              homeState.characteristicData[DataKey.minTemperatureF] ?? '';
          historicalMaxTemperature =
              homeState.characteristicData[DataKey.historicalMaxTemperatureF] ??
                  '';
          historicalMinTemperature =
              homeState.characteristicData[DataKey.historicalMinTemperatureF] ??
                  '';
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
                        AppLocalizations.of(context)!.temperatureFC,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Flexible(
                      child: LayoutBuilder(
                        builder: (context, constraints) => ToggleButtons(
                          direction: Axis.horizontal,
                          onPressed: (int index) {
                            context.read<Status18CCorNodeBloc>().add(
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
                              getSelectionState(status18State.temperatureUnit),
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
                  temperatureAlarmState: temperatureAlarmState,
                  temperatureAlarmSeverity: temperatureAlarmSeverity,
                  currentTemperatureTitle:
                      AppLocalizations.of(context)!.currentTemperature,
                  currentTemperature: currentTemperature,
                  minTemperatureTitle:
                      AppLocalizations.of(context)!.minTemperature,
                  minTemperature: minTemperature,
                  maxTemperatureTitle:
                      AppLocalizations.of(context)!.maxTemperature,
                  maxTemperature: maxTemperature,
                  historicalMinTemperature: historicalMinTemperature,
                  historicalMaxTemperature: historicalMaxTemperature,
                  unit: status18State.temperatureUnit == TemperatureUnit.celsius
                      ? CustomStyle.celciusUnit
                      : CustomStyle.fahrenheitUnit,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PowerSupplyCard extends StatelessWidget {
  const _PowerSupplyCard();

  Widget getCurrentVoltage({
    required FormStatus loadingStatus,
    required String voltageAlarmState,
    required String voltageAlarmSeverity,
    required String minVoltage,
    required String maxVoltage,
    required String currentVoltage,
    double fontSize = 16,
  }) {
    if (loadingStatus == FormStatus.requestInProgress) {
      return currentVoltage.isEmpty
          ? const Center(
              child: SizedBox(
                width: CustomStyle.diameter,
                height: CustomStyle.diameter,
                child: CircularProgressIndicator(),
              ),
            )
          : Text(
              currentVoltage,
              style: TextStyle(
                fontSize: fontSize,
              ),
            );
    } else if (loadingStatus == FormStatus.requestSuccess) {
      return Text(
        currentVoltage.isEmpty ? 'N/A' : currentVoltage,
        style: TextStyle(
          fontSize: fontSize,
          color: _getCurrentValueColor(
            alarmState: voltageAlarmState,
            alarmSeverity: voltageAlarmSeverity,
          ),
        ),
      );
    } else {
      return Text(
        currentVoltage.isEmpty ? 'N/A' : currentVoltage,
        style: TextStyle(
          fontSize: fontSize,
        ),
      );
    }
  }

  Widget getHistoricalMinVoltage({
    required FormStatus loadingStatus,
    required String minVoltage,
    double fontSize = 16,
  }) {
    if (loadingStatus == FormStatus.requestInProgress) {
      return minVoltage.isEmpty
          ? const Center(
              child: SizedBox(
                width: CustomStyle.diameter,
                height: CustomStyle.diameter,
                child: CircularProgressIndicator(),
              ),
            )
          : Text(
              minVoltage,
              style: TextStyle(
                fontSize: fontSize,
              ),
            );
    } else if (loadingStatus == FormStatus.requestSuccess) {
      return Text(
        minVoltage.isEmpty ? 'N/A' : minVoltage,
        style: TextStyle(
          fontSize: fontSize,
        ),
      );
    } else {
      return Text(
        minVoltage.isEmpty ? 'N/A' : minVoltage,
        style: TextStyle(
          fontSize: fontSize,
        ),
      );
    }
  }

  Widget getHistoricalMaxVoltage({
    required FormStatus loadingStatus,
    required String maxVoltage,
    double fontSize = 16,
  }) {
    if (loadingStatus == FormStatus.requestInProgress) {
      return maxVoltage.isEmpty
          ? const Center(
              child: SizedBox(
                width: CustomStyle.diameter,
                height: CustomStyle.diameter,
                child: CircularProgressIndicator(),
              ),
            )
          : Text(
              maxVoltage,
              style: TextStyle(
                fontSize: fontSize,
              ),
            );
    } else if (loadingStatus == FormStatus.requestSuccess) {
      return Text(
        maxVoltage.isEmpty ? 'N/A' : maxVoltage,
        style: TextStyle(
          fontSize: fontSize,
        ),
      );
    } else {
      return Text(
        maxVoltage.isEmpty ? 'N/A' : maxVoltage,
        style: TextStyle(
          fontSize: fontSize,
        ),
      );
    }
  }

  Widget voltageBlock({
    required FormStatus loadingStatus,
    required String voltageAlarmState,
    required String voltageAlarmSeverity,
    required String currentVoltageTitle,
    required String currentVoltage,
    required String minVoltageTitle,
    required String minVoltage,
    required String maxVoltageTitle,
    required String maxVoltage,
    required String historicalMinVoltage,
    required String historicalMaxVoltage,
    required Color borderColor,
  }) {
    if (currentVoltage != '' &&
        historicalMinVoltage != '' &&
        historicalMaxVoltage != '') {
      historicalMinVoltage = adjustMinDoubleValue(
        current: currentVoltage,
        min: historicalMinVoltage,
      );
      historicalMaxVoltage = adjustMaxDoubleValue(
        current: currentVoltage,
        max: historicalMaxVoltage,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getCurrentVoltage(
                      loadingStatus: loadingStatus,
                      voltageAlarmState: voltageAlarmState,
                      voltageAlarmSeverity: voltageAlarmSeverity,
                      minVoltage: minVoltage,
                      maxVoltage: maxVoltage,
                      currentVoltage: currentVoltage,
                      fontSize: CustomStyle.size4XL,
                    ),
                    Text(
                      currentVoltageTitle,
                      style: const TextStyle(
                        fontSize: CustomStyle.sizeL,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: CustomStyle.sizeXXL,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getHistoricalMinVoltage(
                      loadingStatus: loadingStatus,
                      minVoltage: historicalMinVoltage,
                      fontSize: CustomStyle.size32,
                    ),
                    Text(
                      minVoltageTitle,
                      style: const TextStyle(
                        fontSize: CustomStyle.sizeL,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getHistoricalMaxVoltage(
                      loadingStatus: loadingStatus,
                      maxVoltage: historicalMaxVoltage,
                      fontSize: CustomStyle.size32,
                    ),
                    Text(
                      maxVoltageTitle,
                      style: const TextStyle(
                        fontSize: CustomStyle.sizeL,
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
                '${AppLocalizations.of(context)!.voltageLevel} (${CustomStyle.volt})',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            voltageBlock(
              loadingStatus: state.loadingStatus,
              voltageAlarmState:
                  state.characteristicData[DataKey.voltageAlarmState] ?? '1',
              voltageAlarmSeverity:
                  state.characteristicData[DataKey.voltageAlarmSeverity] ?? '0',
              currentVoltageTitle: AppLocalizations.of(context)!.currentVoltage,
              currentVoltage:
                  state.characteristicData[DataKey.currentVoltage] ?? '',
              minVoltageTitle: AppLocalizations.of(context)!.minVoltage,
              minVoltage: state.characteristicData[DataKey.minVoltage] ?? '',
              maxVoltageTitle: AppLocalizations.of(context)!.maxVoltage,
              maxVoltage: state.characteristicData[DataKey.maxVoltage] ?? '',
              historicalMinVoltage:
                  state.characteristicData[DataKey.historicalMinVoltage] ?? '',
              historicalMaxVoltage:
                  state.characteristicData[DataKey.historicalMaxVoltage] ?? '',
              borderColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              height: CustomStyle.sizeXXL,
            ),
          ],
        ),
      ),
    );
  }
}

Widget getCurrentRFOutputPower({
  required FormStatus loadingStatus,
  required String rfOutputPowerAlarmState,
  required String rfOutputPowerAlarmSeverity,
  required String minRFOutputPower,
  required String maxRFOutputPower,
  required String currentRFOutputPower,
  double fontSize = 16,
}) {
  if (loadingStatus == FormStatus.requestInProgress) {
    return currentRFOutputPower.isEmpty
        ? const Center(
            child: SizedBox(
              width: CustomStyle.diameter,
              height: CustomStyle.diameter,
              child: CircularProgressIndicator(),
            ),
          )
        : Text(
            currentRFOutputPower,
            style: TextStyle(
              fontSize: fontSize,
            ),
          );
  } else if (loadingStatus == FormStatus.requestSuccess) {
    return Text(
      currentRFOutputPower.isEmpty ? 'N/A' : currentRFOutputPower,
      style: TextStyle(
        fontSize: fontSize,
        color: _getCurrentValueColor(
          alarmState: rfOutputPowerAlarmState,
          alarmSeverity: rfOutputPowerAlarmSeverity,
        ),
      ),
    );
  } else {
    return Text(
      currentRFOutputPower.isEmpty ? 'N/A' : currentRFOutputPower,
      style: TextStyle(
        fontSize: fontSize,
      ),
    );
  }
}

Widget getMinRFOutputPower({
  required FormStatus loadingStatus,
  required String minRFOutputPower,
  double fontSize = 16,
}) {
  if (loadingStatus == FormStatus.requestInProgress) {
    return minRFOutputPower.isEmpty
        ? const Center(
            child: SizedBox(
              width: CustomStyle.diameter,
              height: CustomStyle.diameter,
              child: CircularProgressIndicator(),
            ),
          )
        : Text(
            minRFOutputPower,
            style: TextStyle(
              fontSize: fontSize,
            ),
          );
  } else if (loadingStatus == FormStatus.requestSuccess) {
    return Text(
      minRFOutputPower.isEmpty ? 'N/A' : minRFOutputPower,
      style: TextStyle(
        fontSize: fontSize,
      ),
    );
  } else {
    return Text(
      minRFOutputPower.isEmpty ? 'N/A' : minRFOutputPower,
      style: TextStyle(
        fontSize: fontSize,
      ),
    );
  }
}

Widget getMaxRFOutputPower({
  required FormStatus loadingStatus,
  required String maxRFOutputPower,
  double fontSize = 16,
}) {
  if (loadingStatus == FormStatus.requestInProgress) {
    return maxRFOutputPower.isEmpty
        ? const Center(
            child: SizedBox(
              width: CustomStyle.diameter,
              height: CustomStyle.diameter,
              child: CircularProgressIndicator(),
            ),
          )
        : Text(
            maxRFOutputPower,
            style: TextStyle(
              fontSize: fontSize,
            ),
          );
  } else if (loadingStatus == FormStatus.requestSuccess) {
    return Text(
      maxRFOutputPower.isEmpty ? 'N/A' : maxRFOutputPower,
      style: TextStyle(
        fontSize: fontSize,
      ),
    );
  } else {
    return Text(
      maxRFOutputPower.isEmpty ? 'N/A' : maxRFOutputPower,
      style: TextStyle(
        fontSize: fontSize,
      ),
    );
  }
}

Widget rfOutputPowerBlock({
  required FormStatus loadingStatus,
  required String rfOutputPowerAlarmState,
  required String rfOutputPowerAlarmSeverity,
  required String currentRFOutputPowerTitle,
  required String currentRFOutputPower,
  required String minRFOutputPowerTitle,
  required String minRFOutputPower,
  required String maxRFOutputPowerTitle,
  required String maxRFOutputPower,
  required String historicalMinRFOutputPower,
  required String historicalMaxRFOutputPower,
  required Color borderColor,
}) {
  if (currentRFOutputPower != '' &&
      historicalMinRFOutputPower != '' &&
      historicalMaxRFOutputPower != '') {
    historicalMinRFOutputPower = adjustMinDoubleValue(
      current: currentRFOutputPower,
      min: historicalMinRFOutputPower,
    );
    historicalMaxRFOutputPower = adjustMaxDoubleValue(
      current: currentRFOutputPower,
      max: historicalMaxRFOutputPower,
    );
  }

  return Padding(
    padding: const EdgeInsets.symmetric(
      vertical: 16.0,
    ),
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getCurrentRFOutputPower(
                    loadingStatus: loadingStatus,
                    rfOutputPowerAlarmState: rfOutputPowerAlarmState,
                    rfOutputPowerAlarmSeverity: rfOutputPowerAlarmSeverity,
                    minRFOutputPower: minRFOutputPower,
                    maxRFOutputPower: maxRFOutputPower,
                    currentRFOutputPower: currentRFOutputPower,
                    fontSize: CustomStyle.size4XL,
                  ),
                  Text(
                    currentRFOutputPowerTitle,
                    style: const TextStyle(
                      fontSize: CustomStyle.sizeL,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: CustomStyle.sizeXXL,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getMinRFOutputPower(
                    loadingStatus: loadingStatus,
                    minRFOutputPower: historicalMinRFOutputPower,
                    fontSize: CustomStyle.size32,
                  ),
                  Text(
                    minRFOutputPowerTitle,
                    style: const TextStyle(
                      fontSize: CustomStyle.sizeL,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getMaxRFOutputPower(
                    loadingStatus: loadingStatus,
                    maxRFOutputPower: historicalMaxRFOutputPower,
                    fontSize: CustomStyle.size32,
                  ),
                  Text(
                    maxRFOutputPowerTitle,
                    style: const TextStyle(
                      fontSize: CustomStyle.sizeL,
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    ),
  );
}

class _RFOutputPower1Card extends StatelessWidget {
  const _RFOutputPower1Card();

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
                '${AppLocalizations.of(context)!.rfOutputPower1} (${CustomStyle.dBmV})',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            rfOutputPowerBlock(
              loadingStatus: state.loadingStatus,
              rfOutputPowerAlarmState:
                  state.characteristicData[DataKey.rfOutputPower1AlarmState] ??
                      '1',
              rfOutputPowerAlarmSeverity: state.characteristicData[
                      DataKey.rfOutputPower1AlarmSeverity] ??
                  '0',
              currentRFOutputPowerTitle:
                  AppLocalizations.of(context)!.currentRFOutputPower,
              currentRFOutputPower:
                  state.characteristicData[DataKey.currentRFOutputPower1] ?? '',
              minRFOutputPowerTitle: AppLocalizations.of(context)!.minVoltage,
              minRFOutputPower:
                  state.characteristicData[DataKey.minRFOutputPower1] ?? '',
              maxRFOutputPowerTitle:
                  AppLocalizations.of(context)!.maxRFOutputPower,
              maxRFOutputPower:
                  state.characteristicData[DataKey.maxRFOutputPower1] ?? '',
              historicalMinRFOutputPower: state.characteristicData[
                      DataKey.historicalMinRFOutputPower1] ??
                  '',
              historicalMaxRFOutputPower: state.characteristicData[
                      DataKey.historicalMaxRFOutputPower1] ??
                  '',
              borderColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              height: CustomStyle.sizeXXL,
            ),
          ],
        ),
      ),
    );
  }
}

class _RFOutputPower3Card extends StatelessWidget {
  const _RFOutputPower3Card();

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
                '${AppLocalizations.of(context)!.rfOutputPower3} (${CustomStyle.dBmV})',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            rfOutputPowerBlock(
              loadingStatus: state.loadingStatus,
              rfOutputPowerAlarmState:
                  state.characteristicData[DataKey.rfOutputPower3AlarmState] ??
                      '1',
              rfOutputPowerAlarmSeverity: state.characteristicData[
                      DataKey.rfOutputPower3AlarmSeverity] ??
                  '0',
              currentRFOutputPowerTitle:
                  AppLocalizations.of(context)!.currentRFOutputPower,
              currentRFOutputPower:
                  state.characteristicData[DataKey.currentRFOutputPower3] ?? '',
              minRFOutputPowerTitle: AppLocalizations.of(context)!.minVoltage,
              minRFOutputPower:
                  state.characteristicData[DataKey.minRFOutputPower3] ?? '',
              maxRFOutputPowerTitle:
                  AppLocalizations.of(context)!.maxRFOutputPower,
              maxRFOutputPower:
                  state.characteristicData[DataKey.maxRFOutputPower3] ?? '',
              historicalMinRFOutputPower: state.characteristicData[
                      DataKey.historicalMinRFOutputPower3] ??
                  '',
              historicalMaxRFOutputPower: state.characteristicData[
                      DataKey.historicalMaxRFOutputPower3] ??
                  '',
              borderColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              height: CustomStyle.sizeXXL,
            ),
          ],
        ),
      ),
    );
  }
}

class _RFOutputPower4Card extends StatelessWidget {
  const _RFOutputPower4Card();

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
                '${AppLocalizations.of(context)!.rfOutputPower4} (${CustomStyle.dBmV})',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            rfOutputPowerBlock(
              loadingStatus: state.loadingStatus,
              rfOutputPowerAlarmState:
                  state.characteristicData[DataKey.rfOutputPower4AlarmState] ??
                      '1',
              rfOutputPowerAlarmSeverity: state.characteristicData[
                      DataKey.rfOutputPower4AlarmSeverity] ??
                  '0',
              currentRFOutputPowerTitle:
                  AppLocalizations.of(context)!.currentRFOutputPower,
              currentRFOutputPower:
                  state.characteristicData[DataKey.currentRFOutputPower4] ?? '',
              minRFOutputPowerTitle: AppLocalizations.of(context)!.minVoltage,
              minRFOutputPower:
                  state.characteristicData[DataKey.minRFOutputPower4] ?? '',
              maxRFOutputPowerTitle:
                  AppLocalizations.of(context)!.maxRFOutputPower,
              maxRFOutputPower:
                  state.characteristicData[DataKey.maxRFOutputPower4] ?? '',
              historicalMinRFOutputPower: state.characteristicData[
                      DataKey.historicalMinRFOutputPower4] ??
                  '',
              historicalMaxRFOutputPower: state.characteristicData[
                      DataKey.historicalMaxRFOutputPower4] ??
                  '',
              borderColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              height: CustomStyle.sizeXXL,
            ),
          ],
        ),
      ),
    );
  }
}

class _RFOutputPower6Card extends StatelessWidget {
  const _RFOutputPower6Card();

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
                '${AppLocalizations.of(context)!.rfOutputPower6} (${CustomStyle.dBmV})',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            rfOutputPowerBlock(
              loadingStatus: state.loadingStatus,
              rfOutputPowerAlarmState:
                  state.characteristicData[DataKey.rfOutputPower6AlarmState] ??
                      '1',
              rfOutputPowerAlarmSeverity: state.characteristicData[
                      DataKey.rfOutputPower6AlarmSeverity] ??
                  '0',
              currentRFOutputPowerTitle:
                  AppLocalizations.of(context)!.currentRFOutputPower,
              currentRFOutputPower:
                  state.characteristicData[DataKey.currentRFOutputPower6] ?? '',
              minRFOutputPowerTitle: AppLocalizations.of(context)!.minVoltage,
              minRFOutputPower:
                  state.characteristicData[DataKey.minRFOutputPower6] ?? '',
              maxRFOutputPowerTitle:
                  AppLocalizations.of(context)!.maxRFOutputPower,
              maxRFOutputPower:
                  state.characteristicData[DataKey.maxRFOutputPower6] ?? '',
              historicalMinRFOutputPower: state.characteristicData[
                      DataKey.historicalMinRFOutputPower6] ??
                  '',
              historicalMaxRFOutputPower: state.characteristicData[
                      DataKey.historicalMaxRFOutputPower6] ??
                  '',
              borderColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              height: CustomStyle.sizeXXL,
            ),
          ],
        ),
      ),
    );
  }
}

String _getPilotFrequencyAlarmSeverityText(String pilotFrequencyStatus) {
  if (pilotFrequencyStatus == Alarm.danger.name) {
    return 'Unlock';
  } else if (pilotFrequencyStatus == Alarm.success.name) {
    return 'Lock';
  } else {
    return pilotFrequencyStatus;
  }
}
