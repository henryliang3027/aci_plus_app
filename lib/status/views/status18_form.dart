import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/custom_style.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:dsim_app/repositories/unit_repository.dart';
import 'package:dsim_app/status/bloc/status18_bloc/status18_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Status18Form extends StatelessWidget {
  const Status18Form({super.key});

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
            _PowerSupplyCard(),
            _VoltageRippleCard(),
            _RFOutputPowerCard(),
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

// class _ModuleCard extends StatelessWidget {
//   const _ModuleCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeBloc, HomeState>(
//       builder: (context, state) => Card(
//         color: Theme.of(context).colorScheme.onPrimary,
//         surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 AppLocalizations.of(context).module,
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//               const SizedBox(
//                 height: 10.0,
//               ),
//               itemText(
//                 loadingStatus: state.loadingStatus,
//                 title: AppLocalizations.of(context).serialNumber,
//                 content: state.characteristicData[DataKey.serialNumber] ?? '',
//               ),
//               itemText(
//                 loadingStatus: state.loadingStatus,
//                 title: AppLocalizations.of(context).firmwareVersion,
//                 content:
//                     state.characteristicData[DataKey.firmwareVersion] ?? '',
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class _TemperatureCard extends StatelessWidget {
  const _TemperatureCard({super.key});

  @override
  Widget build(BuildContext context) {
    Color currentTemperatureColor({
      required String minTemperature,
      required String maxTemperature,
      required String currentTemperature,
    }) {
      double min = double.parse(minTemperature);
      double max = double.parse(maxTemperature);
      double current = double.parse(currentTemperature);

      return current >= min && current <= max
          ? CustomStyle.alarmColor['success']!
          : CustomStyle.alarmColor['danger']!;
    }

    Widget getCurrentTemperature({
      required FormStatus loadingStatus,
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
          '$currentTemperature $unit',
          style: TextStyle(
            fontSize: fontSize,
            color: currentTemperatureColor(
              minTemperature: minTemperature,
              maxTemperature: maxTemperature,
              currentTemperature: currentTemperature,
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

    Widget getMinTemperature({
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
          '$minTemperature $unit',
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

    Widget getMaxTemperature({
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
          '$maxTemperature $unit',
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
      required String currentTemperatureTitle,
      required String currentTemperature,
      required String minTemperatureTitle,
      required String minTemperature,
      required String maxTemperatureTitle,
      required String maxTemperature,
      required String unit,
    }) {
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
                      minTemperature: minTemperature,
                      maxTemperature: maxTemperature,
                      currentTemperature: currentTemperature,
                      unit: unit,
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
                      getMinTemperature(
                        loadingStatus: loadingStatus,
                        minTemperature: minTemperature,
                        unit: unit,
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
                      getMaxTemperature(
                        loadingStatus: loadingStatus,
                        maxTemperature: maxTemperature,
                        unit: unit,
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
        final Status18State status18State = context.watch<Status18Bloc>().state;
        String currentTemperature = '';
        String maxTemperature = '';
        String minTemperature = '';

        if (status18State.temperatureUnit == TemperatureUnit.celsius) {
          currentTemperature =
              homeState.characteristicData[DataKey.currentTemperatureC] ?? '';
          maxTemperature =
              homeState.characteristicData[DataKey.historicalMaxTemperatureC] ??
                  '';
          minTemperature =
              homeState.characteristicData[DataKey.historicalMinTemperatureC] ??
                  '';
        } else {
          currentTemperature =
              homeState.characteristicData[DataKey.currentTemperatureF] ?? '';
          maxTemperature =
              homeState.characteristicData[DataKey.historicalMaxTemperatureF] ??
                  '';
          minTemperature =
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
                        AppLocalizations.of(context).temperatureFC,
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
                  currentTemperatureTitle:
                      AppLocalizations.of(context).currentTemperature,
                  currentTemperature: currentTemperature,
                  minTemperatureTitle:
                      AppLocalizations.of(context).minTemperature,
                  minTemperature: minTemperature,
                  maxTemperatureTitle:
                      AppLocalizations.of(context).maxTemperature,
                  maxTemperature: maxTemperature,
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
  const _PowerSupplyCard({super.key});

  Color currentVoltageColor({
    required String minVoltage,
    required String maxVoltage,
    required String currentVoltage,
  }) {
    double min = double.parse(minVoltage);
    double max = double.parse(maxVoltage);
    double current = double.parse(currentVoltage);

    return current >= min && current <= max
        ? CustomStyle.alarmColor['success']!
        : CustomStyle.alarmColor['danger']!;
  }

  Widget getCurrentVoltage({
    required FormStatus loadingStatus,
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
        currentVoltage,
        style: TextStyle(
          fontSize: fontSize,
          color: currentVoltageColor(
            minVoltage: minVoltage,
            maxVoltage: maxVoltage,
            currentVoltage: currentVoltage,
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

  Widget getMinVoltage({
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
        minVoltage,
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

  Widget getMaxVoltage({
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
        maxVoltage,
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
                      minVoltage: minVoltage,
                      maxVoltage: maxVoltage,
                      currentVoltage: currentVoltage,
                      fontSize: 40,
                    ),
                    Text(
                      currentVoltageTitle,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getMinVoltage(
                      loadingStatus: loadingStatus,
                      minVoltage: minVoltage,
                      fontSize: 32,
                    ),
                    Text(
                      minVoltageTitle,
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
                    getMaxVoltage(
                      loadingStatus: loadingStatus,
                      maxVoltage: maxVoltage,
                      fontSize: 32,
                    ),
                    Text(
                      maxVoltageTitle,
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
                '${AppLocalizations.of(context).voltageLevel} (${CustomStyle.volt})',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            voltageBlock(
              loadingStatus: state.loadingStatus,
              currentVoltageTitle: AppLocalizations.of(context).currentVoltage,
              currentVoltage:
                  state.characteristicData[DataKey.currentVoltage] ?? '',
              minVoltageTitle: AppLocalizations.of(context).minVoltage,
              minVoltage:
                  state.characteristicData[DataKey.historicalMinVoltage] ?? '',
              maxVoltageTitle: AppLocalizations.of(context).maxVoltage,
              maxVoltage:
                  state.characteristicData[DataKey.historicalMaxVoltage] ?? '',
              borderColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}

class _VoltageRippleCard extends StatelessWidget {
  const _VoltageRippleCard({super.key});

  Color currentVoltageRippleColor({
    required String minVoltageRipple,
    required String maxVoltageRipple,
    required String currentVoltageRipple,
  }) {
    double min = double.parse(minVoltageRipple);
    double max = double.parse(maxVoltageRipple);
    double current = double.parse(currentVoltageRipple);

    return current >= min && current <= max
        ? CustomStyle.alarmColor['success']!
        : CustomStyle.alarmColor['danger']!;
  }

  Widget getCurrentVoltageRipple({
    required FormStatus loadingStatus,
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
        currentVoltageRipple,
        style: TextStyle(
          fontSize: fontSize,
          color: currentVoltageRippleColor(
            minVoltageRipple: minVoltageRipple,
            maxVoltageRipple: maxVoltageRipple,
            currentVoltageRipple: currentVoltageRipple,
          ),
        ),
      );
    } else {
      return Text(
        currentVoltageRipple.isEmpty ? 'N/A' : currentVoltageRipple,
        style: TextStyle(
          fontSize: fontSize,
        ),
      );
    }
  }

  Widget getMinVoltageRipple({
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
        minVoltageRipple,
        style: TextStyle(
          fontSize: fontSize,
        ),
      );
    } else {
      return Text(
        minVoltageRipple.isEmpty ? 'N/A' : minVoltageRipple,
        style: TextStyle(
          fontSize: fontSize,
        ),
      );
    }
  }

  Widget getMaxVoltageRipple({
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
        maxVoltageRipple,
        style: TextStyle(
          fontSize: fontSize,
        ),
      );
    } else {
      return Text(
        maxVoltageRipple.isEmpty ? 'N/A' : maxVoltageRipple,
        style: TextStyle(
          fontSize: fontSize,
        ),
      );
    }
  }

  Widget voltageRippleBlock({
    required FormStatus loadingStatus,
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
                      minVoltageRipple: minVoltageRipple,
                      maxVoltageRipple: maxVoltageRipple,
                      currentVoltageRipple: currentVoltageRipple,
                      fontSize: 40,
                    ),
                    Text(
                      currentVoltageRippleTitle,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getMinVoltageRipple(
                      loadingStatus: loadingStatus,
                      minVoltageRipple: minVoltageRipple,
                      fontSize: 32,
                    ),
                    Text(
                      minVoltageRippleTitle,
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
                    getMaxVoltageRipple(
                      loadingStatus: loadingStatus,
                      maxVoltageRipple: maxVoltageRipple,
                      fontSize: 32,
                    ),
                    Text(
                      maxVoltageRippleTitle,
                      style: const TextStyle(
                        fontSize: 16,
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
        color: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 36.0, 16.0, 16.0),
              child: Text(
                '${AppLocalizations.of(context).voltageRipple} (${CustomStyle.milliVolt})',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            voltageRippleBlock(
              loadingStatus: state.loadingStatus,
              currentVoltageRippleTitle:
                  AppLocalizations.of(context).currentVoltageRipple,
              currentVoltageRipple:
                  state.characteristicData[DataKey.currentVoltageRipple] ?? '',
              minVoltageRippleTitle: AppLocalizations.of(context).minVoltage,
              minVoltageRipple: state
                      .characteristicData[DataKey.historicalMinVoltageRipple] ??
                  '',
              maxVoltageRippleTitle:
                  AppLocalizations.of(context).maxVoltageRipple,
              maxVoltageRipple: state
                      .characteristicData[DataKey.historicalMaxVoltageRipple] ??
                  '',
              borderColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}

class _RFOutputPowerCard extends StatelessWidget {
  const _RFOutputPowerCard({super.key});

  Color currentRFOutputPowerColor({
    required String minRFOutputPower,
    required String maxRFOutputPower,
    required String currentRFOutputPower,
  }) {
    double min = double.parse(minRFOutputPower);
    double max = double.parse(maxRFOutputPower);
    double current = double.parse(currentRFOutputPower);

    return current >= min && current <= max
        ? CustomStyle.alarmColor['success']!
        : CustomStyle.alarmColor['danger']!;
  }

  Widget getCurrentRFOutputPower({
    required FormStatus loadingStatus,
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
        currentRFOutputPower,
        style: TextStyle(
          fontSize: fontSize,
          color: currentRFOutputPowerColor(
            minRFOutputPower: minRFOutputPower,
            maxRFOutputPower: maxRFOutputPower,
            currentRFOutputPower: currentRFOutputPower,
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
        minRFOutputPower,
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
        maxRFOutputPower,
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
    required String currentRFOutputPowerTitle,
    required String currentRFOutputPower,
    required String minRFOutputPowerTitle,
    required String minRFOutputPower,
    required String maxRFOutputPowerTitle,
    required String maxRFOutputPower,
    required Color borderColor,
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
                    getCurrentRFOutputPower(
                      loadingStatus: loadingStatus,
                      minRFOutputPower: minRFOutputPower,
                      maxRFOutputPower: maxRFOutputPower,
                      currentRFOutputPower: currentRFOutputPower,
                      fontSize: 40,
                    ),
                    Text(
                      currentRFOutputPowerTitle,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20.0,
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
                      minRFOutputPower: 'N/A',
                      fontSize: 32,
                    ),
                    Text(
                      minRFOutputPowerTitle,
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
                    getMaxRFOutputPower(
                      loadingStatus: loadingStatus,
                      maxRFOutputPower: 'N/A',
                      fontSize: 32,
                    ),
                    Text(
                      maxRFOutputPowerTitle,
                      style: const TextStyle(
                        fontSize: 16,
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
        color: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 36.0, 16.0, 16.0),
              child: Text(
                '${AppLocalizations.of(context).rfOutputPower} (${CustomStyle.dBmV})',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            rfOutputPowerBlock(
              loadingStatus: state.loadingStatus,
              currentRFOutputPowerTitle:
                  AppLocalizations.of(context).currentRFOutputPower,
              currentRFOutputPower:
                  state.characteristicData[DataKey.currentRFOutputPower] ?? '',
              minRFOutputPowerTitle: AppLocalizations.of(context).minVoltage,
              minRFOutputPower:
                  state.characteristicData[DataKey.minRFOutputPower] ?? '',
              maxRFOutputPowerTitle:
                  AppLocalizations.of(context).maxRFOutputPower,
              maxRFOutputPower:
                  state.characteristicData[DataKey.maxRFOutputPower] ?? '',
              borderColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
