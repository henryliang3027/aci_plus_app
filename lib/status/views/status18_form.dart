import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/status_items_table.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/core/working_mode_table.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/home/views/home_button_navigation_bar18.dart';
import 'package:aci_plus_app/repositories/unit_repository.dart';
import 'package:aci_plus_app/status/bloc/status18/status18_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Status18Form extends StatelessWidget {
  const Status18Form({
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
          if (index != 1) {
            context
                .read<Status18Bloc>()
                .add(const StatusPeriodicUpdateCanceled());
          }

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
      List<StatusItem> items = StatusItemTable.itemsMap[partId] ?? [];
      List<Widget> widgets = [];

      for (StatusItem name in items) {
        switch (name) {
          case StatusItem.operatingMode:
            widgets.add(const _OperatingModeCard());
            break;
          case StatusItem.workingMode:
            widgets.add(const _WorkingModeCard());
            break;
          case StatusItem.splitOptions:
            widgets.add(const _SplitOptionCard());
            break;
          case StatusItem.temperature:
            widgets.add(const _TemperatureCard());
            break;
          case StatusItem.inputVoltage24V:
            widgets.add(const _PowerSupplyCard());
            break;
          case StatusItem.inputVoltageRipple24V:
            widgets.add(const _VoltageRippleCard());
            break;
          case StatusItem.outputPower:
            widgets.add(const _RFOutputPowerCard());
            break;
          case StatusItem.inputPower1p8G:
            widgets.add(const _RFInputPower1p8GCard());
            break;
          case StatusItem.pilot1Status:
            widgets.add(const _PilotFrequency1Card());
            break;
          case StatusItem.pilot2Status:
            widgets.add(const _PilotFrequency2Card());
            break;
          case StatusItem.startFrequencyOutputLevel:
            widgets.add(const _FirstChannelPowerLevelCard());
            break;
          case StatusItem.stopFrequencyOutputLevel:
            widgets.add(const _LastChannelPowerLevelCard());
            break;
          case StatusItem.operatingSlope:
            widgets.add(const _OutputOperatingSlopeCard());
            break;
          case StatusItem.outputPower1:
            break;
          case StatusItem.outputPower3:
            break;
          case StatusItem.outputPower4:
            break;
          case StatusItem.outputPower6:
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
                  _OperatingModeCard(),
                  _WorkingModeCard(),
                  _SplitOptionCard(),
                  _TemperatureCard(),
                  _PowerSupplyCard(),
                  _VoltageRippleCard(),
                  _RFOutputPowerCard(),
                  _PilotFrequency1Card(),
                  _PilotFrequency2Card(),
                  _FirstChannelPowerLevelCard(),
                  _LastChannelPowerLevelCard(),
                  _OutputOperatingSlopeCard(),
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
              .read<Status18Bloc>()
              .add(const StatusPeriodicUpdateRequested());

          return getWidgetsByPartId(partId);
        } else {
          context
              .read<Status18Bloc>()
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

Color? _getCurrentValueColor({
  required String alarmState,
  required String alarmSeverity,
}) {
  return alarmState == '0' ? CustomStyle.alarmColor[alarmSeverity]! : null;
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
                    .read<Status18Bloc>()
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

class _OperatingModeCard extends StatelessWidget {
  const _OperatingModeCard();

  String getOperatingModeByForwardCEQIndexText(String index) {
    int intIndex = int.parse(index);

    if (intIndex >= 0 && intIndex <= 24) {
      return '1.8 ${CustomStyle.gHz}';
    } else if (intIndex == 120) {
      return '1.2 ${CustomStyle.gHz}';
    } else if (intIndex == 180) {
      return '1.8 ${CustomStyle.gHz}';
    } else if (intIndex == 255) {
      return 'N/A';
    } else {
      return 'N/A';
    }
  }

  Widget getCurrentOperatingMode({
    required FormStatus loadingStatus,
    required String currentOperatingMode,
    double fontSize = 16,
  }) {
    if (loadingStatus == FormStatus.requestInProgress) {
      return currentOperatingMode.isEmpty
          ? const Center(
              child: SizedBox(
                width: CustomStyle.diameter,
                height: CustomStyle.diameter,
                child: CircularProgressIndicator(),
              ),
            )
          : Text(
              currentOperatingMode,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize,
              ),
            );
    } else if (loadingStatus == FormStatus.requestSuccess) {
      return Text(
        currentOperatingMode.isEmpty ? 'N/A' : currentOperatingMode,
        textAlign: TextAlign.center,
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
        'N/A',
        style: TextStyle(
          fontSize: fontSize,
        ),
      );
    }
  }

  Widget operatingModeBlock({
    required FormStatus loadingStatus,
    required String currentOperatingMode,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.maxFinite,
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            getCurrentOperatingMode(
              loadingStatus: loadingStatus,
              currentOperatingMode: currentOperatingMode,
              fontSize: CustomStyle.size4XL,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      String currentOperatingMode =
          state.characteristicData[DataKey.currentForwardCEQIndex] ?? '';

      String operatingMode = currentOperatingMode == ''
          ? '' // 給空字串, 用來顯示 loading 效果
          : getOperatingModeByForwardCEQIndexText(currentOperatingMode);

      return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 36.0, 16.0, 16.0),
              child: Text(
                AppLocalizations.of(context)!.operatingMode,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            operatingModeBlock(
              loadingStatus: state.loadingStatus,
              currentOperatingMode: operatingMode,
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
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: currentWorkingMode.isEmpty
                    ? CustomStyle.size4XL
                    : CustomStyle.size28,
              ),
            );
    } else if (loadingStatus == FormStatus.requestSuccess) {
      return Text(
        currentWorkingMode.isEmpty ? 'N/A' : currentWorkingMode,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: currentWorkingMode.isEmpty
              ? CustomStyle.size4XL
              : CustomStyle.size28,
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
        'N/A',
        style: TextStyle(
          fontSize: currentWorkingMode.isEmpty
              ? CustomStyle.size4XL
              : CustomStyle.size28,
        ),
      );
    }
  }

  Widget workingModeBlock({
    required FormStatus loadingStatus,
    required String currentWorkingMode,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.maxFinite,
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            getCurrentWorkingMode(
              loadingStatus: loadingStatus,
              currentWorkingMode: currentWorkingMode,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      String currentWorkingMode =
          state.characteristicData[DataKey.currentWorkingMode] ?? '';

      String workingMode = currentWorkingMode == '0'
          ? 'N/A'
          : WorkingModeTable.workingModeMap[currentWorkingMode] ??
              currentWorkingMode;

      return Card(
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
          // 20240821 不顯示顏色
          // _getCurrentValueColor(
          //   alarmState: splitOptionAlarmState,
          //   alarmSeverity: splitOptionAlarmSeverity,
          // ),
        ),
      );
    } else {
      return Text(
        'N/A',
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
          currentSplitOption == '' ? '' : types[currentSplitOption] ?? 'N/A';

      String splitOptionAlarmState =
          state.characteristicData[DataKey.splitOptionAlarmState] ?? '1';

      String splitOptionAlarmSeverity =
          state.characteristicData[DataKey.splitOptionAlarmSeverity] ?? '1';

      return Card(
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
          'N/A',
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
          'N/A',
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
          'N/A',
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
        final Status18State status18State = context.watch<Status18Bloc>().state;
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
                            context.read<Status18Bloc>().add(
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
        'N/A',
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
        'N/A',
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
        'N/A',
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

class _VoltageRippleCard extends StatelessWidget {
  const _VoltageRippleCard();

  Widget getCurrentVoltageRipple({
    required FormStatus loadingStatus,
    required String voltageRippleAlarmState,
    required String voltageRippleAlarmSeverity,
    required String minVoltageRipple,
    required String maxVoltageRipple,
    required String currentVoltageRipple,
    double fontSize = 16,
  }) {
    if (loadingStatus == FormStatus.requestInProgress) {
      return currentVoltageRipple.isEmpty
          ? const Center(
              child: SizedBox(
                width: CustomStyle.diameter,
                height: CustomStyle.diameter,
                child: CircularProgressIndicator(),
              ),
            )
          : Text(
              currentVoltageRipple,
              style: TextStyle(
                fontSize: fontSize,
              ),
            );
    } else if (loadingStatus == FormStatus.requestSuccess) {
      return Text(
        currentVoltageRipple.isEmpty ? 'N/A' : currentVoltageRipple,
        style: TextStyle(
          fontSize: fontSize,
          color: _getCurrentValueColor(
            alarmState: voltageRippleAlarmState,
            alarmSeverity: voltageRippleAlarmSeverity,
          ),
        ),
      );
    } else {
      return Text(
        'N/A',
        style: TextStyle(
          fontSize: fontSize,
        ),
      );
    }
  }

  Widget getHistoricalMinVoltageRipple({
    required FormStatus loadingStatus,
    required String minVoltageRipple,
    double fontSize = 16,
  }) {
    if (loadingStatus == FormStatus.requestInProgress) {
      return minVoltageRipple.isEmpty
          ? const Center(
              child: SizedBox(
                width: CustomStyle.diameter,
                height: CustomStyle.diameter,
                child: CircularProgressIndicator(),
              ),
            )
          : Text(
              minVoltageRipple,
              style: TextStyle(
                fontSize: fontSize,
              ),
            );
    } else if (loadingStatus == FormStatus.requestSuccess) {
      return Text(
        minVoltageRipple.isEmpty ? 'N/A' : minVoltageRipple,
        style: TextStyle(
          fontSize: fontSize,
        ),
      );
    } else {
      return Text(
        'N/A',
        style: TextStyle(
          fontSize: fontSize,
        ),
      );
    }
  }

  Widget getHistoricalMaxVoltageRipple({
    required FormStatus loadingStatus,
    required String maxVoltageRipple,
    double fontSize = 16,
  }) {
    if (loadingStatus == FormStatus.requestInProgress) {
      return maxVoltageRipple.isEmpty
          ? const Center(
              child: SizedBox(
                width: CustomStyle.diameter,
                height: CustomStyle.diameter,
                child: CircularProgressIndicator(),
              ),
            )
          : Text(
              maxVoltageRipple,
              style: TextStyle(
                fontSize: fontSize,
              ),
            );
    } else if (loadingStatus == FormStatus.requestSuccess) {
      return Text(
        maxVoltageRipple.isEmpty ? 'N/A' : maxVoltageRipple,
        style: TextStyle(
          fontSize: fontSize,
        ),
      );
    } else {
      return Text(
        'N/A',
        style: TextStyle(
          fontSize: fontSize,
        ),
      );
    }
  }

  Widget voltageRippleBlock({
    required FormStatus loadingStatus,
    required String voltageRippleAlarmState,
    required String voltageRippleAlarmSeverity,
    required String currentVoltageRippleTitle,
    required String currentVoltageRipple,
    required String minVoltageRippleTitle,
    required String minVoltageRipple,
    required String maxVoltageRippleTitle,
    required String maxVoltageRipple,
    required String historicalMinVoltageRipple,
    required String historicalMaxVoltageRipple,
    required Color borderColor,
  }) {
    if (currentVoltageRipple != '' &&
        historicalMinVoltageRipple != '' &&
        historicalMaxVoltageRipple != '') {
      historicalMinVoltageRipple = adjustMinIntValue(
        current: currentVoltageRipple,
        min: historicalMinVoltageRipple,
      );
      historicalMaxVoltageRipple = adjustMaxIntValue(
        current: currentVoltageRipple,
        max: historicalMaxVoltageRipple,
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
                    getCurrentVoltageRipple(
                      loadingStatus: loadingStatus,
                      voltageRippleAlarmState: voltageRippleAlarmState,
                      voltageRippleAlarmSeverity: voltageRippleAlarmSeverity,
                      minVoltageRipple: minVoltageRipple,
                      maxVoltageRipple: maxVoltageRipple,
                      currentVoltageRipple: currentVoltageRipple,
                      fontSize: CustomStyle.size4XL,
                    ),
                    Text(
                      currentVoltageRippleTitle,
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
                    getHistoricalMinVoltageRipple(
                      loadingStatus: loadingStatus,
                      minVoltageRipple: historicalMinVoltageRipple,
                      fontSize: CustomStyle.size32,
                    ),
                    Text(
                      minVoltageRippleTitle,
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
                    getHistoricalMaxVoltageRipple(
                      loadingStatus: loadingStatus,
                      maxVoltageRipple: historicalMaxVoltageRipple,
                      fontSize: CustomStyle.size32,
                    ),
                    Text(
                      maxVoltageRippleTitle,
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) => Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 36.0, 16.0, 16.0),
              child: Text(
                '${AppLocalizations.of(context)!.voltageRipple} (${CustomStyle.milliVolt})',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            voltageRippleBlock(
              loadingStatus: state.loadingStatus,
              voltageRippleAlarmState:
                  state.characteristicData[DataKey.voltageRippleAlarmState] ??
                      '1',
              voltageRippleAlarmSeverity: state
                      .characteristicData[DataKey.voltageRippleAlarmSeverity] ??
                  '0',
              currentVoltageRippleTitle:
                  AppLocalizations.of(context)!.currentVoltageRipple,
              currentVoltageRipple:
                  state.characteristicData[DataKey.currentVoltageRipple] ?? '',
              minVoltageRippleTitle: AppLocalizations.of(context)!.minVoltage,
              minVoltageRipple:
                  state.characteristicData[DataKey.minVoltageRipple] ?? '',
              maxVoltageRippleTitle:
                  AppLocalizations.of(context)!.maxVoltageRipple,
              maxVoltageRipple:
                  state.characteristicData[DataKey.maxVoltageRipple] ?? '',
              historicalMinVoltageRipple: state
                      .characteristicData[DataKey.historicalMinVoltageRipple] ??
                  '',
              historicalMaxVoltageRipple: state
                      .characteristicData[DataKey.historicalMaxVoltageRipple] ??
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

class _RFOutputPowerCard extends StatelessWidget {
  const _RFOutputPowerCard();

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
        'N/A',
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
        'N/A',
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
        'N/A',
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) => Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 36.0, 16.0, 16.0),
              child: Text(
                '${AppLocalizations.of(context)!.rfOutputPower} (${CustomStyle.dBmV})',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            rfOutputPowerBlock(
              loadingStatus: state.loadingStatus,
              rfOutputPowerAlarmState:
                  state.characteristicData[DataKey.rfOutputPowerAlarmState] ??
                      '1',
              rfOutputPowerAlarmSeverity:
                  state.characteristicData[DataKey.outputPowerAlarmSeverity] ??
                      '0',
              currentRFOutputPowerTitle:
                  AppLocalizations.of(context)!.currentRFOutputPower,
              currentRFOutputPower:
                  state.characteristicData[DataKey.currentRFOutputPower] ?? '',
              minRFOutputPowerTitle: AppLocalizations.of(context)!.minVoltage,
              minRFOutputPower:
                  state.characteristicData[DataKey.minRFOutputPower] ?? '',
              maxRFOutputPowerTitle:
                  AppLocalizations.of(context)!.maxRFOutputPower,
              maxRFOutputPower:
                  state.characteristicData[DataKey.maxRFOutputPower] ?? '',
              historicalMinRFOutputPower: state
                      .characteristicData[DataKey.historicalMinRFOutputPower] ??
                  '',
              historicalMaxRFOutputPower: state
                      .characteristicData[DataKey.historicalMaxRFOutputPower] ??
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

class _RFInputPower1p8GCard extends StatelessWidget {
  const _RFInputPower1p8GCard();

  Widget getCurrentRFInputPower1p8G({
    required FormStatus loadingStatus,
    required String currentRFInputPower1p8G,
    double fontSize = 16,
  }) {
    if (loadingStatus == FormStatus.requestInProgress) {
      return const Center(
        child: SizedBox(
          width: CustomStyle.diameter,
          height: CustomStyle.diameter,
          child: CircularProgressIndicator(),
        ),
      );
    } else if (loadingStatus == FormStatus.requestSuccess) {
      return Text(
        currentRFInputPower1p8G.isEmpty ? 'N/A' : currentRFInputPower1p8G,
        style: TextStyle(
          fontSize: fontSize,
        ),
      );
    } else {
      return Text(
        'N/A',
        style: TextStyle(
          fontSize: fontSize,
        ),
      );
    }
  }

  Widget currentRFInputPower1p8GBlock({
    required FormStatus loadingStatus,
    required String currentRFInputPower1p8G,
    required String currentRFInputPower1p8GTitle,
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
                    getCurrentRFInputPower1p8G(
                      loadingStatus: loadingStatus,
                      currentRFInputPower1p8G: currentRFInputPower1p8G,
                      fontSize: CustomStyle.size4XL,
                    ),
                    Text(
                      currentRFInputPower1p8GTitle,
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
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      String currentRFInputPower1p8G =
          state.characteristicData[DataKey.currentRFInputPower1p8G] ?? '1';

      return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 36.0, 16.0, 16.0),
              child: Text(
                '${AppLocalizations.of(context)!.rfInputPower} @ 1794 MHz (${CustomStyle.dBmV})',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            currentRFInputPower1p8GBlock(
              loadingStatus: state.loadingStatus,
              currentRFInputPower1p8G: currentRFInputPower1p8G,
              currentRFInputPower1p8GTitle:
                  AppLocalizations.of(context)!.currentRFInputPower,
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

class _PilotFrequency1Card extends StatelessWidget {
  const _PilotFrequency1Card();

  Widget getCurrentPilotFrequency({
    required FormStatus loadingStatus,
    required String pilotFrequencyAlarmState,
    required String pilotFrequencyAlarmSeverity,
    required String currentPilotFrequency,
    double fontSize = 16,
  }) {
    if (loadingStatus == FormStatus.requestInProgress) {
      return currentPilotFrequency.isEmpty
          ? const Center(
              child: SizedBox(
                width: CustomStyle.diameter,
                height: CustomStyle.diameter,
                child: CircularProgressIndicator(),
              ),
            )
          : Text(
              currentPilotFrequency,
              style: TextStyle(
                fontSize: fontSize,
              ),
            );
    } else if (loadingStatus == FormStatus.requestSuccess) {
      return Text(
        currentPilotFrequency.isEmpty ? 'N/A' : currentPilotFrequency,
        style: TextStyle(
          fontSize: fontSize,
          color: _getCurrentValueColor(
            alarmState: pilotFrequencyAlarmState,
            alarmSeverity: pilotFrequencyAlarmSeverity,
          ),
        ),
      );
    } else {
      return Text(
        'N/A',
        style: TextStyle(
          fontSize: fontSize,
        ),
      );
    }
  }

  Widget pilotFrequencyBlock({
    required FormStatus loadingStatus,
    required String pilotFrequencyAlarmState,
    required String pilotFrequencyAlarmSeverity,
    required String currentPilotFrequency,
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
                    getCurrentPilotFrequency(
                      loadingStatus: loadingStatus,
                      pilotFrequencyAlarmState: pilotFrequencyAlarmState,
                      pilotFrequencyAlarmSeverity: pilotFrequencyAlarmSeverity,
                      currentPilotFrequency: currentPilotFrequency,
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
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      String pilotFrequency1AlarmState = state.characteristicData[
              DataKey.rfOutputPilotLowFrequencyAlarmState] ??
          '1';

      String pilotFrequency1AlarmSeverity = state.characteristicData[
              DataKey.rfOutputPilotLowFrequencyAlarmSeverity] ??
          '';

      String currentPilotFrequency1 =
          _getPilotFrequencyAlarmSeverityText(pilotFrequency1AlarmSeverity);

      return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 36.0, 16.0, 16.0),
              child: Text(
                AppLocalizations.of(context)!.pilotFrequency1Status,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            pilotFrequencyBlock(
              loadingStatus: state.loadingStatus,
              pilotFrequencyAlarmState: pilotFrequency1AlarmState,
              pilotFrequencyAlarmSeverity: pilotFrequency1AlarmSeverity,
              currentPilotFrequency: currentPilotFrequency1,
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

class _PilotFrequency2Card extends StatelessWidget {
  const _PilotFrequency2Card();

  Widget getCurrentPilotFrequency({
    required FormStatus loadingStatus,
    required String pilotFrequencyAlarmState,
    required String pilotFrequencyAlarmSeverity,
    required String currentPilotFrequency,
    double fontSize = 16,
  }) {
    if (loadingStatus == FormStatus.requestInProgress) {
      return currentPilotFrequency.isEmpty
          ? const Center(
              child: SizedBox(
                width: CustomStyle.diameter,
                height: CustomStyle.diameter,
                child: CircularProgressIndicator(),
              ),
            )
          : Text(
              currentPilotFrequency,
              style: TextStyle(
                fontSize: fontSize,
              ),
            );
    } else if (loadingStatus == FormStatus.requestSuccess) {
      return Text(
        currentPilotFrequency.isEmpty ? 'N/A' : currentPilotFrequency,
        style: TextStyle(
          fontSize: fontSize,
          color: _getCurrentValueColor(
            alarmState: pilotFrequencyAlarmState,
            alarmSeverity: pilotFrequencyAlarmSeverity,
          ),
        ),
      );
    } else {
      return Text(
        'N/A',
        style: TextStyle(
          fontSize: fontSize,
        ),
      );
    }
  }

  Widget pilotFrequencyBlock({
    required FormStatus loadingStatus,
    required String pilotFrequencyAlarmState,
    required String pilotFrequencyAlarmSeverity,
    required String currentPilotFrequency,
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
                    getCurrentPilotFrequency(
                      loadingStatus: loadingStatus,
                      pilotFrequencyAlarmState: pilotFrequencyAlarmState,
                      pilotFrequencyAlarmSeverity: pilotFrequencyAlarmSeverity,
                      currentPilotFrequency: currentPilotFrequency,
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
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      String pilotFrequency2AlarmState = state.characteristicData[
              DataKey.rfOutputPilotHighFrequencyAlarmState] ??
          '1';

      String pilotFrequency2AlarmSeverity = state.characteristicData[
              DataKey.rfOutputPilotHighFrequencyAlarmSeverity] ??
          '';

      String currentPilotFrequency2 =
          _getPilotFrequencyAlarmSeverityText(pilotFrequency2AlarmSeverity);

      return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 36.0, 16.0, 16.0),
              child: Text(
                AppLocalizations.of(context)!.pilotFrequency2Status,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            pilotFrequencyBlock(
              loadingStatus: state.loadingStatus,
              pilotFrequencyAlarmState: pilotFrequency2AlarmState,
              pilotFrequencyAlarmSeverity: pilotFrequency2AlarmSeverity,
              currentPilotFrequency: currentPilotFrequency2,
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

class _FirstChannelPowerLevelCard extends StatelessWidget {
  const _FirstChannelPowerLevelCard();

  Widget getFrequency({
    required FormStatus loadingStatus,
    // required String pilotFrequencyAlarmState,
    // required String pilotFrequencyAlarmSeverity,
    required String frequency,
    double fontSize = 16,
  }) {
    if (loadingStatus == FormStatus.requestInProgress) {
      return frequency.isEmpty
          ? const Center(
              child: SizedBox(
                width: CustomStyle.diameter,
                height: CustomStyle.diameter,
                child: CircularProgressIndicator(),
              ),
            )
          : Text(
              frequency,
              style: TextStyle(
                fontSize: fontSize,
              ),
            );
    } else if (loadingStatus == FormStatus.requestSuccess) {
      int intFrequency = int.parse(frequency);
      frequency = intFrequency >= 1209 ? '1785~1791' : frequency;

      return Text(
        frequency.isEmpty ? 'N/A' : frequency,
        style: TextStyle(
          fontSize: fontSize,
          // color: _getCurrentValueColor(
          //   alarmState: pilotFrequencyAlarmState,
          //   alarmSeverity: pilotFrequencyAlarmSeverity,
          // ),
        ),
      );
    } else {
      return Text(
        'N/A',
        style: TextStyle(
          fontSize: fontSize,
        ),
      );
    }
  }

  Widget getOutputPower({
    required FormStatus loadingStatus,
    required String pilotFrequencyAlarmState,
    required String pilotFrequencyAlarmSeverity,
    required String outputPower,
    double fontSize = 16,
  }) {
    if (loadingStatus == FormStatus.requestInProgress) {
      return outputPower.isEmpty
          ? const Center(
              child: SizedBox(
                width: CustomStyle.diameter,
                height: CustomStyle.diameter,
                child: CircularProgressIndicator(),
              ),
            )
          : Text(
              outputPower,
              style: TextStyle(
                fontSize: fontSize,
              ),
            );
    } else if (loadingStatus == FormStatus.requestSuccess) {
      return Text(
        outputPower.isEmpty ? 'N/A' : outputPower,
        style: TextStyle(
          fontSize: fontSize,
          color: _getCurrentValueColor(
            alarmState: pilotFrequencyAlarmState,
            alarmSeverity: pilotFrequencyAlarmSeverity,
          ),
        ),
      );
    } else {
      return Text(
        'N/A',
        style: TextStyle(
          fontSize: fontSize,
        ),
      );
    }
  }

  Widget pilotFrequencyBlock({
    required FormStatus loadingStatus,
    required String pilotFrequencyAlarmState,
    required String pilotFrequencyAlarmSeverity,
    required String firstChannelFrequency,
    required String rfOutputLowChannelPower,
    required String frequencyTitle,
    required String outputPowerTitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getFrequency(
                      loadingStatus: loadingStatus,
                      frequency: firstChannelFrequency,
                      fontSize: CustomStyle.size32,
                    ),
                    Text(
                      frequencyTitle,
                      style: const TextStyle(
                        fontSize: CustomStyle.sizeL,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getOutputPower(
                      loadingStatus: loadingStatus,
                      pilotFrequencyAlarmState: pilotFrequencyAlarmState,
                      pilotFrequencyAlarmSeverity: pilotFrequencyAlarmSeverity,
                      outputPower: rfOutputLowChannelPower,
                      fontSize: CustomStyle.size32,
                    ),
                    Text(
                      outputPowerTitle,
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
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      String firstChannelFrequency =
          state.characteristicData[DataKey.pilot1RFChannelFrequency] ?? '';
      String rfOutputLowChannelPower =
          state.characteristicData[DataKey.rfOutputLowChannelPower] ?? '';
      String pilotFrequency1AlarmState = state.characteristicData[
              DataKey.rfOutputPilotLowFrequencyAlarmState] ??
          '1';
      String pilotFrequency1AlarmSeverity = state.characteristicData[
              DataKey.rfOutputPilotLowFrequencyAlarmSeverity] ??
          '0';

      return Card(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 36.0, 16.0, 16.0),
            child: Text(
              AppLocalizations.of(context)!.rfOutputPilotLowFrequencyStatus,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          pilotFrequencyBlock(
            loadingStatus: state.loadingStatus,
            pilotFrequencyAlarmState: pilotFrequency1AlarmState,
            pilotFrequencyAlarmSeverity: pilotFrequency1AlarmSeverity,
            firstChannelFrequency: firstChannelFrequency,
            rfOutputLowChannelPower: rfOutputLowChannelPower,
            frequencyTitle:
                '${AppLocalizations.of(context)!.frequency} (${CustomStyle.mHz})',
            outputPowerTitle:
                '${AppLocalizations.of(context)!.level} (${CustomStyle.dBmV})',
          ),
        ],
      ));
    });
  }
}

class _LastChannelPowerLevelCard extends StatelessWidget {
  const _LastChannelPowerLevelCard();

  Widget getFrequency({
    required FormStatus loadingStatus,
    // required String pilotFrequencyAlarmState,
    // required String pilotFrequencyAlarmSeverity,
    required String frequency,
    double fontSize = 16,
  }) {
    if (loadingStatus == FormStatus.requestInProgress) {
      return frequency.isEmpty
          ? const Center(
              child: SizedBox(
                width: CustomStyle.diameter,
                height: CustomStyle.diameter,
                child: CircularProgressIndicator(),
              ),
            )
          : Text(
              frequency,
              style: TextStyle(
                fontSize: fontSize,
              ),
            );
    } else if (loadingStatus == FormStatus.requestSuccess) {
      int intFrequency = int.parse(frequency);

      return Text(
        frequency.isEmpty ? 'N/A' : '$frequency~${intFrequency + 6}',
        style: TextStyle(
          fontSize: fontSize,
          // color: _getCurrentValueColor(
          //   alarmState: pilotFrequencyAlarmState,
          //   alarmSeverity: pilotFrequencyAlarmSeverity,
          // ),
        ),
      );
    } else {
      return Text(
        'N/A',
        style: TextStyle(
          fontSize: fontSize,
        ),
      );
    }
  }

  Widget getOutputPower({
    required FormStatus loadingStatus,
    required String pilotFrequencyAlarmState,
    required String pilotFrequencyAlarmSeverity,
    required String outputPower,
    double fontSize = 16,
  }) {
    if (loadingStatus == FormStatus.requestInProgress) {
      return outputPower.isEmpty
          ? const Center(
              child: SizedBox(
                width: CustomStyle.diameter,
                height: CustomStyle.diameter,
                child: CircularProgressIndicator(),
              ),
            )
          : Text(
              outputPower,
              style: TextStyle(
                fontSize: fontSize,
              ),
            );
    } else if (loadingStatus == FormStatus.requestSuccess) {
      return Text(
        outputPower.isEmpty ? 'N/A' : outputPower,
        style: TextStyle(
          fontSize: fontSize,
          color: _getCurrentValueColor(
            alarmState: pilotFrequencyAlarmState,
            alarmSeverity: pilotFrequencyAlarmSeverity,
          ),
        ),
      );
    } else {
      return Text(
        'N/A',
        style: TextStyle(
          fontSize: fontSize,
        ),
      );
    }
  }

  Widget pilotFrequencyBlock({
    required FormStatus loadingStatus,
    required String pilotFrequencyAlarmState,
    required String pilotFrequencyAlarmSeverity,
    required String lastChannelFrequency,
    required String rfOutputHighChannelPower,
    required String frequencyTitle,
    required String outputPowerTitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getFrequency(
                      loadingStatus: loadingStatus,
                      frequency: lastChannelFrequency,
                      fontSize: CustomStyle.size32,
                    ),
                    Text(
                      frequencyTitle,
                      style: const TextStyle(
                        fontSize: CustomStyle.sizeL,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getOutputPower(
                      loadingStatus: loadingStatus,
                      pilotFrequencyAlarmState: pilotFrequencyAlarmState,
                      pilotFrequencyAlarmSeverity: pilotFrequencyAlarmSeverity,
                      outputPower: rfOutputHighChannelPower,
                      fontSize: CustomStyle.size32,
                    ),
                    Text(
                      outputPowerTitle,
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
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      String lastChannelFrequency =
          state.characteristicData[DataKey.pilot2RFChannelFrequency] ?? '';

      String rfOutputHighChannelPower =
          state.characteristicData[DataKey.rfOutputHighChannelPower] ?? '';

      String pilotFrequency2AlarmState = state.characteristicData[
              DataKey.rfOutputPilotHighFrequencyAlarmState] ??
          '1';
      String pilotFrequency2AlarmSeverity = state.characteristicData[
              DataKey.rfOutputPilotHighFrequencyAlarmSeverity] ??
          '0';

      return Card(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 36.0, 16.0, 16.0),
            child: Text(
              AppLocalizations.of(context)!.rfOutputPilotHighFrequencyStatus,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          pilotFrequencyBlock(
            loadingStatus: state.loadingStatus,
            pilotFrequencyAlarmState: pilotFrequency2AlarmState,
            pilotFrequencyAlarmSeverity: pilotFrequency2AlarmSeverity,
            lastChannelFrequency: lastChannelFrequency,
            rfOutputHighChannelPower: rfOutputHighChannelPower,
            frequencyTitle:
                '${AppLocalizations.of(context)!.frequency} (${CustomStyle.mHz})',
            outputPowerTitle:
                '${AppLocalizations.of(context)!.level} (${CustomStyle.dBmV})',
          ),
        ],
      ));
    });
  }
}

class _OutputOperatingSlopeCard extends StatelessWidget {
  const _OutputOperatingSlopeCard();

  Widget getOutputOperatingSlope({
    required FormStatus loadingStatus,
    required String outputOperatingSlope,
    double fontSize = 16,
  }) {
    if (loadingStatus == FormStatus.requestInProgress) {
      return outputOperatingSlope.isEmpty
          ? const Center(
              child: SizedBox(
                width: CustomStyle.diameter,
                height: CustomStyle.diameter,
                child: CircularProgressIndicator(),
              ),
            )
          : Text(
              outputOperatingSlope,
              style: TextStyle(
                fontSize: fontSize,
              ),
            );
    } else if (loadingStatus == FormStatus.requestSuccess) {
      return Text(
        outputOperatingSlope.isEmpty ? 'N/A' : outputOperatingSlope,
        style: TextStyle(
          fontSize: fontSize,
          // color: _getCurrentValueColor(
          //   alarmState: pilotFrequencyAlarmState,
          //   alarmSeverity: pilotFrequencyAlarmSeverity,
          // ),
        ),
      );
    } else {
      return Text(
        'N/A',
        style: TextStyle(
          fontSize: fontSize,
        ),
      );
    }
  }

  Widget outputOperatingSlopeBlock({
    required FormStatus loadingStatus,
    required String outputOperatingSlope,
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
                    getOutputOperatingSlope(
                      loadingStatus: loadingStatus,
                      outputOperatingSlope: outputOperatingSlope,
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
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      String outputOperatingSlope =
          state.characteristicData[DataKey.rfOutputOperatingSlope] ?? '';

      return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 36.0, 16.0, 16.0),
              child: Text(
                '${AppLocalizations.of(context)!.operatingSlope} (${CustomStyle.dB})',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            outputOperatingSlopeBlock(
              loadingStatus: state.loadingStatus,
              outputOperatingSlope: outputOperatingSlope,
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
