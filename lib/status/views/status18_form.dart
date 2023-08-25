import 'package:dsim_app/core/characteristic_data.dart';
import 'package:dsim_app/core/custom_style.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/core/temperature_unit.dart';
import 'package:dsim_app/home/bloc/home_bloc/home_bloc.dart';
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
            ? const CircularProgressIndicator()
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
            ? const CircularProgressIndicator()
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
            ? const CircularProgressIndicator()
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
                        minTemperature: 'N/A',
                        unit: '',
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
                        maxTemperature: 'N/A',
                        unit: '',
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
                              status18State.temperatureUnit ==
                                      TemperatureUnit.fahrenheit
                                  ? CustomStyle.celciusUnit
                                  : CustomStyle.fahrenheitUnit,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          TemperatureUnit targetUnit =
                              status18State.temperatureUnit ==
                                      TemperatureUnit.fahrenheit
                                  ? TemperatureUnit.celsius
                                  : TemperatureUnit.fahrenheit;
                          context
                              .read<Status18Bloc>()
                              .add(TemperatureUnitChanged(targetUnit));
                        },
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

  // Widget tile({
  //   required FormStatus loadingStatus,
  //   required String title,
  //   required String content,
  //   required double fontSize,
  //   Color color = Colors.black,
  //   double? fontHeight,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 16.0),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         getContent(
  //           loadingStatus: loadingStatus,
  //           content: content,
  //           color: color,
  //           fontSize: fontSize,
  //         ),
  //         Text(
  //           title,
  //           style: const TextStyle(
  //             fontSize: 16,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
          ? const CircularProgressIndicator()
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
          ? const CircularProgressIndicator()
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
          ? const CircularProgressIndicator()
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
          vertical: 16.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getMinVoltage(
                    loadingStatus: loadingStatus,
                    minVoltage: 'N/A',
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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getMaxVoltage(
                    loadingStatus: loadingStatus,
                    maxVoltage: 'N/A',
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
        ));
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
                AppLocalizations.of(context).voltageLevel,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            voltageBlock(
              loadingStatus: state.loadingStatus,
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
          ],
        ),
      ),
    );
  }
}

// Widget getContent({
//   required FormStatus loadingStatus,
//   required String content,
//   Color color = Colors.black,
//   double fontSize = 16,
// }) {
//   if (loadingStatus == FormStatus.requestInProgress) {
//     return content.isEmpty
//         ? const CircularProgressIndicator()
//         : Text(
//             content,
//             style: TextStyle(
//               fontSize: fontSize,
//             ),
//           );
//   } else if (loadingStatus == FormStatus.requestSuccess) {
//     return Text(
//       content,
//       style: TextStyle(
//         fontSize: fontSize,
//         color: color,
//       ),
//     );
//   } else {
//     return Text(
//       content.isEmpty ? 'N/A' : content,
//       style: TextStyle(
//         fontSize: fontSize,
//       ),
//     );
//   }
// }

// Widget itemText({
//   required FormStatus loadingStatus,
//   required String title,
//   required String content,
// }) {
//   return Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 16,
//           ),
//         ),
//         const SizedBox(
//           width: 30.0,
//         ),
//         Flexible(
//           child: getContent(loadingStatus: loadingStatus, content: content),
//         ),
//       ],
//     ),
//   );
// }
