import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:aci_plus_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:aci_plus_app/repositories/unit_repository.dart';
import 'package:aci_plus_app/setting/bloc/setting18_threshold/setting18_threshold_bloc.dart';
import 'package:aci_plus_app/setting/model/confirm_input_dialog.dart';
import 'package:aci_plus_app/setting/model/setting_wisgets.dart';
import 'package:aci_plus_app/setting/views/custom_setting_dialog.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_graph_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18ThresholdView extends StatelessWidget {
  Setting18ThresholdView({super.key});

  final TextEditingController minTemperatureTextEditingController =
      TextEditingController();
  final TextEditingController maxTemperatureTextEditingController =
      TextEditingController();
  final TextEditingController minVoltageTextEditingController =
      TextEditingController();
  final TextEditingController maxVoltageTextEditingController =
      TextEditingController();

  // final TextEditingController minVoltageRippleTextEditingController =
  //     TextEditingController();
  final TextEditingController maxVoltageRippleTextEditingController =
      TextEditingController();

  final TextEditingController minRFOutputPowerTextEditingController =
      TextEditingController();
  final TextEditingController maxRFOutputPowerTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    HomeState homeState = context.watch<HomeBloc>().state;
    String partId = homeState.characteristicData[DataKey.partId] ?? '';
    String currentDetectedSplitOption =
        homeState.characteristicData[DataKey.currentDetectedSplitOption] ?? '0';

    String formatResultValue(String boolValue) {
      return boolValue == 'true'
          ? AppLocalizations.of(context)!.dialogMessageSuccessful
          : AppLocalizations.of(context)!.dialogMessageFailed;
    }

    String formatResultItem(String item) {
      if (item == DataKey.maxTemperatureC.name) {
        return AppLocalizations.of(context)!.dialogMessageMaxTemperatureSetting;
      } else if (item == DataKey.minTemperatureC.name) {
        return AppLocalizations.of(context)!.dialogMessageMinTemperatureSetting;
      } else if (item == DataKey.maxVoltage.name) {
        return AppLocalizations.of(context)!.dialogMessageMaxVoltageSetting;
      } else if (item == DataKey.minVoltage.name) {
        return AppLocalizations.of(context)!.dialogMessageMinVoltageSetting;
      } else if (item == DataKey.maxVoltageRipple.name) {
        return AppLocalizations.of(context)!
            .dialogMessageMaxVoltageRippleSetting;
      } else if (item == DataKey.minVoltageRipple.name) {
        return AppLocalizations.of(context)!
            .dialogMessageMinVoltageRippleSetting;
      } else if (item == DataKey.maxRFOutputPower.name) {
        return AppLocalizations.of(context)!
            .dialogMessageMaxRFOutputPowerSetting;
      } else if (item == DataKey.minRFOutputPower.name) {
        return AppLocalizations.of(context)!
            .dialogMessageMinRFOutputPowerSetting;
      } else if (item == DataKey.temperatureAlarmState.name) {
        return AppLocalizations.of(context)!
            .dialogMessageTemperatureAlarmStateSetting;
      } else if (item == DataKey.voltageAlarmState.name) {
        return AppLocalizations.of(context)!
            .dialogMessageVoltageAlarmStateSetting;
      } else if (item == DataKey.voltageRippleAlarmState.name) {
        return AppLocalizations.of(context)!
            .dialogMessageVoltageRippleAlarmStateSetting;
      } else if (item == DataKey.rfOutputPowerAlarmState.name) {
        return AppLocalizations.of(context)!
            .dialogMessageRFOutputPowerAlarmStateSetting;
      } else if (item == DataKey.splitOptionAlarmState.name) {
        return AppLocalizations.of(context)!
            .dialogMessageSplitOptionAlarmStateSetting;
      } else if (item == DataKey.rfOutputPilotLowFrequencyAlarmState.name) {
        return AppLocalizations.of(context)!
            .dialogMessageRFOutputPilotLowFrequencyAlarmStateSetting;
      } else if (item == DataKey.rfOutputPilotHighFrequencyAlarmState.name) {
        return AppLocalizations.of(context)!
            .dialogMessageRFOutputPilotHighFrequencyAlarmStateSetting;
      } else {
        return '';
      }
    }

    Color getResultValueColor(String resultValue) {
      return resultValue == 'true' ? Colors.green : Colors.red;
    }

    List<Widget> getMessageRows(List<String> settingResultList) {
      List<Widget> rows = [];
      for (String settingResult in settingResultList) {
        String item = settingResult.split(',')[0];
        String value = settingResult.split(',')[1];
        Color valueColor = getResultValueColor(value);

        rows.add(Padding(
          padding: const EdgeInsets.only(
            bottom: 14.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  formatResultItem(item),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Expanded(
                child: Text(
                  formatResultValue(value),
                  style: TextStyle(
                    fontSize: CustomStyle.sizeL,
                    color: valueColor,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ));
      }
      return rows;
    }

    List<Widget> getThresholdParameterWidgetsByPartId(String partId) {
      Map<Enum, bool> itemsMap = SettingItemTable.itemsMap[partId] ?? {};
      List<Widget> widgets = [];

      List<Enum> enabledItems =
          itemsMap.keys.where((key) => itemsMap[key] == true).toList();

      enabledItems = enabledItems
          .where((item) => item.runtimeType == SettingThreshold)
          .toList();

      for (Enum name in enabledItems) {
        switch (name) {
          case SettingThreshold.temperature:
            widgets.add(_TemperatureAlarmControl(
              minTemperatureTextEditingController:
                  minTemperatureTextEditingController,
              maxTemperatureTextEditingController:
                  maxTemperatureTextEditingController,
            ));
            break;
          case SettingThreshold.inputVoltage24V:
            widgets.add(_VoltageAlarmControl(
              minVoltageTextEditingController: minVoltageTextEditingController,
              maxVoltageTextEditingController: maxVoltageTextEditingController,
            ));
            break;
          case SettingThreshold.inputVoltageRipple24V:
            widgets.add(_VoltageRippleAlarmControl(
              // minVoltageRippleTextEditingController:
              //     minVoltageRippleTextEditingController,
              maxVoltageRippleTextEditingController:
                  maxVoltageRippleTextEditingController,
            ));
            break;
          case SettingThreshold.outputPower:
            widgets.add(_RFOutputPowerAlarmControl(
              minRFOutputPowerTextEditingController:
                  minRFOutputPowerTextEditingController,
              maxRFOutputPowerTextEditingController:
                  maxRFOutputPowerTextEditingController,
            ));
            break;
        }
      }

      return widgets.isNotEmpty
          ? widgets
          : [
              _TemperatureAlarmControl(
                minTemperatureTextEditingController:
                    minTemperatureTextEditingController,
                maxTemperatureTextEditingController:
                    maxTemperatureTextEditingController,
              ),
              _VoltageAlarmControl(
                minVoltageTextEditingController:
                    minVoltageTextEditingController,
                maxVoltageTextEditingController:
                    maxVoltageTextEditingController,
              ),
              _VoltageRippleAlarmControl(
                // minVoltageRippleTextEditingController:
                //     minVoltageRippleTextEditingController,
                maxVoltageRippleTextEditingController:
                    maxVoltageRippleTextEditingController,
              ),
              _RFOutputPowerAlarmControl(
                minRFOutputPowerTextEditingController:
                    minRFOutputPowerTextEditingController,
                maxRFOutputPowerTextEditingController:
                    maxRFOutputPowerTextEditingController,
              ),
            ];
    }

    List<Widget> getForwardSettingWidgetsByPartId(String partId) {
      Map<Enum, bool> itemsMap = SettingItemTable.itemsMap[partId] ?? {};
      List<Widget> widgets = [];

      List<Enum> enabledItems =
          itemsMap.keys.where((key) => itemsMap[key] == true).toList();

      enabledItems = enabledItems
          .where((item) => item.runtimeType == SettingThreshold)
          .toList();

      for (Enum name in enabledItems) {
        switch (name) {
          case SettingThreshold.splitOptions:
            widgets.add(const _SplitOptionAlarmControl());
            break;
          // case SettingThreshold.pilot1Status:
          //   widgets.add(const _PilotFrequency1AlarmControl());
          //   break;
          // case SettingThreshold.pilot2Status:
          //   widgets.add(const _PilotFrequency2AlarmControl());
          //   break;
          case SettingThreshold.startFrequencyOutputLevel:
            widgets.add(const _StartFrequencyOutputLevelAlarmControl());
            break;
          case SettingThreshold.stopFrequencyOutputLevel:
            widgets.add(const _StopFrequencyOutputLevelAlarmControl());
            break;
        }
      }

      return widgets.isNotEmpty
          ? widgets
          : [
              const _SplitOptionAlarmControl(),
              // const _PilotFrequency1AlarmControl(),
              // const _PilotFrequency2AlarmControl(),
              const _StartFrequencyOutputLevelAlarmControl(),
              const _StopFrequencyOutputLevelAlarmControl(),
            ];
    }

    Widget buildThresholdWidget(String partId) {
      List<Widget> thresholdParameters =
          getThresholdParameterWidgetsByPartId(partId);
      List<Widget> forwardSettings = getForwardSettingWidgetsByPartId(partId);

      return Column(
        children: [
          ...thresholdParameters,
          forwardSettings.isNotEmpty
              ? _ClusterTitle(
                  title: AppLocalizations.of(context)!.forwardSetting,
                )
              : Container(),
          ...forwardSettings,
          const SizedBox(
            height: 120,
          ),
        ],
      );
    }

    return BlocListener<Setting18ThresholdBloc, Setting18ThresholdState>(
      listener: (context, state) async {
        if (state.submissionStatus.isSubmissionInProgress) {
          await showInProgressDialog(context);
        } else if (state.submissionStatus.isSubmissionSuccess) {
          if (ModalRoute.of(context)?.isCurrent != true) {
            Navigator.of(context).pop();
          }
          List<Widget> rows = getMessageRows(state.settingResult);
          showResultDialog(
            context: context,
            messageRows: rows,
          );

          context.read<Setting18ThresholdBloc>().add(const Initialized());
        }

        if (state.isInitialize) {
          minTemperatureTextEditingController.text = state.minTemperature.value;
          maxTemperatureTextEditingController.text = state.maxTemperature.value;
          minVoltageTextEditingController.text = state.minVoltage.value;
          maxVoltageTextEditingController.text = state.maxVoltage.value;
          // minVoltageRippleTextEditingController.text = state.minVoltageRipple;
          maxVoltageRippleTextEditingController.text =
              state.maxVoltageRipple.value;
          minRFOutputPowerTextEditingController.text =
              state.minRFOutputPower.value;
          maxRFOutputPowerTextEditingController.text =
              state.maxRFOutputPower.value;
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(
                CustomStyle.sizeXL,
              ),
              child: buildThresholdWidget(partId),
            ),
          ),
        ),
        floatingActionButton: _SettingFloatingActionButton(
          partId: partId,
          currentDetectedSplitOption: currentDetectedSplitOption,
        ),
      ),
    );
  }
}

class _ClusterTitle extends StatelessWidget {
  const _ClusterTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: CustomStyle.sizeXL,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TemperatureAlarmControl extends StatelessWidget {
  const _TemperatureAlarmControl({
    super.key,
    required this.minTemperatureTextEditingController,
    required this.maxTemperatureTextEditingController,
  });

  final TextEditingController minTemperatureTextEditingController;
  final TextEditingController maxTemperatureTextEditingController;

  @override
  Widget build(BuildContext context) {
    String getTemperatureUnit(TemperatureUnit temperatureUnit) {
      if (temperatureUnit == TemperatureUnit.celsius) {
        return CustomStyle.celciusUnit;
      } else {
        return CustomStyle.fahrenheitUnit;
      }
    }

    return BlocBuilder<Setting18ThresholdBloc, Setting18ThresholdState>(
      builder: (context, state) {
        return thresholdAlarmParameterWidget(
          context: context,
          minValueTextEditingControllerName:
              'setting18_temperature_minValue_textField',
          maxValueTextEditingControllerName:
              'setting18_temperature_maxValue_textField',
          minValueTextEditingController: minTemperatureTextEditingController,
          maxValueTextEditingController: maxTemperatureTextEditingController,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.temperatureFC} (${getTemperatureUnit(state.temperatureUnit)})',
          minValueLabel: AppLocalizations.of(context)!.minTemperature,
          maxValueLabel: AppLocalizations.of(context)!.maxTemperature,
          enabledAlarmState: state.temperatureAlarmState,
          onChangedAlarmState: (value) {
            context
                .read<Setting18ThresholdBloc>()
                .add(TemperatureAlarmChanged(value));
          },
          onChangedMinValue: (minTemperature) {
            context
                .read<Setting18ThresholdBloc>()
                .add(MinTemperatureChanged(minTemperature));
          },
          onChangedMaxValue: (maxTemperature) {
            context
                .read<Setting18ThresholdBloc>()
                .add(MaxTemperatureChanged(maxTemperature));
          },
          minValueErrorText: state.minTemperature.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          maxValueErrorText: state.maxTemperature.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
        );
      },
    );
  }
}

class _VoltageAlarmControl extends StatelessWidget {
  const _VoltageAlarmControl({
    super.key,
    required this.minVoltageTextEditingController,
    required this.maxVoltageTextEditingController,
  });

  final TextEditingController minVoltageTextEditingController;
  final TextEditingController maxVoltageTextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ThresholdBloc, Setting18ThresholdState>(
      builder: (context, state) {
        return thresholdAlarmParameterWidget(
          context: context,
          minValueTextEditingControllerName:
              'setting18_voltage_minValue_textField',
          maxValueTextEditingControllerName:
              'setting18_voltage_maxValue_textField',
          minValueTextEditingController: minVoltageTextEditingController,
          maxValueTextEditingController: maxVoltageTextEditingController,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.voltageLevel} (${CustomStyle.volt})',
          minValueLabel: AppLocalizations.of(context)!.minVoltage,
          maxValueLabel: AppLocalizations.of(context)!.maxVoltage,
          enabledAlarmState: state.voltageAlarmState,
          onChangedAlarmState: (value) {
            context
                .read<Setting18ThresholdBloc>()
                .add(VoltageAlarmChanged(value));
          },
          onChangedMinValue: (minVoltage) {
            context
                .read<Setting18ThresholdBloc>()
                .add(MinVoltageChanged(minVoltage));
          },
          onChangedMaxValue: (maxVoltage) {
            context
                .read<Setting18ThresholdBloc>()
                .add(MaxVoltageChanged(maxVoltage));
          },
          minValueErrorText: state.minVoltage.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          maxValueErrorText: state.maxVoltage.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
        );
      },
    );
  }
}

class _VoltageRippleAlarmControl extends StatelessWidget {
  const _VoltageRippleAlarmControl({
    super.key,
    // required this.minVoltageRippleTextEditingController,
    required this.maxVoltageRippleTextEditingController,
  });

  // final TextEditingController minVoltageRippleTextEditingController;
  final TextEditingController maxVoltageRippleTextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ThresholdBloc, Setting18ThresholdState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: CustomStyle.sizeL,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: Text(
                      '${AppLocalizations.of(context)!.voltageRipple} (${CustomStyle.milliVolt})',
                      style: const TextStyle(
                        fontSize: CustomStyle.sizeXL,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Switch(
                      thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return const Icon(Icons.check);
                          }
                          return const Icon(Icons.close);
                        },
                      ),
                      value: state.voltageRippleAlarmState,
                      onChanged: state.editMode
                          ? (bool value) {
                              context
                                  .read<Setting18ThresholdBloc>()
                                  .add(VoltageRippleAlarmChanged(value));
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: CustomStyle.sizeL,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Flexible(
                  //   flex: 2,
                  //   child: TextField(
                  //     controller: minVoltageRippleTextEditingController,
                  //     key: const Key(
                  //         'setting18Form_minVoltageRippleInput_textField'),
                  //     style: const TextStyle(
                  //       fontSize: CustomStyle.sizeXL,
                  //     ),
                  //     enabled: state.editMode,
                  //     textInputAction: TextInputAction.done,
                  //     onChanged: (minVoltageRipple) {
                  //       context
                  //           .read<Setting18ThresholdBloc>()
                  //           .add(MinVoltageRippleChanged(minVoltageRipple));
                  //     },
                  //     maxLength: 40,
                  //     decoration: InputDecoration(
                  //       label: Text(
                  //           AppLocalizations.of(context)!.minVoltageRipple),
                  //       border: const OutlineInputBorder(
                  //           borderRadius:
                  //               BorderRadius.all(Radius.circular(4.0))),
                  //       contentPadding: EdgeInsets.all(8.0),
                  //       isDense: true,
                  //       filled: true,
                  //       fillColor: Colors.white,
                  //       counterText: '',
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(
                  //   width: 20,
                  // ),
                  Flexible(
                    flex: 2,
                    child: TextField(
                      controller: maxVoltageRippleTextEditingController,
                      key: const Key(
                          'setting18Form_maxVoltageRippleInput_textField'),
                      style: const TextStyle(
                        fontSize: CustomStyle.sizeXL,
                      ),
                      enabled: state.editMode,
                      textInputAction: TextInputAction.done,
                      onChanged: (maxVoltageRipple) {
                        context
                            .read<Setting18ThresholdBloc>()
                            .add(MaxVoltageRippleChanged(maxVoltageRipple));
                      },
                      maxLength: 40,
                      decoration: InputDecoration(
                        label: Text(
                            AppLocalizations.of(context)!.maxVoltageRipple),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0))),
                        contentPadding: EdgeInsets.all(8.0),
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        counterText: '',
                        errorMaxLines: 2,
                        errorStyle:
                            const TextStyle(fontSize: CustomStyle.sizeS),
                        errorText: state.maxVoltageRipple.isNotValid
                            ? AppLocalizations.of(context)!
                                .textFieldErrorMessage
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      },
    );
  }
}

class _RFOutputPowerAlarmControl extends StatelessWidget {
  const _RFOutputPowerAlarmControl({
    super.key,
    required this.minRFOutputPowerTextEditingController,
    required this.maxRFOutputPowerTextEditingController,
  });

  final TextEditingController minRFOutputPowerTextEditingController;
  final TextEditingController maxRFOutputPowerTextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ThresholdBloc, Setting18ThresholdState>(
      builder: (context, state) {
        return thresholdAlarmParameterWidget(
          context: context,
          minValueTextEditingControllerName:
              'setting18_rfOutputPower_minValue_textField',
          maxValueTextEditingControllerName:
              'setting18_rfOutputPower_maxValue_textField',
          minValueTextEditingController: minRFOutputPowerTextEditingController,
          maxValueTextEditingController: maxRFOutputPowerTextEditingController,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.rfOutputPower} (${CustomStyle.dBmV})',
          minValueLabel: AppLocalizations.of(context)!.minRFOutputPower,
          maxValueLabel: AppLocalizations.of(context)!.maxRFOutputPower,
          enabledAlarmState: state.rfOutputPowerAlarmState,
          onChangedAlarmState: (value) {
            context
                .read<Setting18ThresholdBloc>()
                .add(RFOutputPowerAlarmChanged(value));
          },
          onChangedMinValue: (minRFOutputPower) {
            context
                .read<Setting18ThresholdBloc>()
                .add(MinRFOutputPowerChanged(minRFOutputPower));
          },
          onChangedMaxValue: (maxRFOutputPower) {
            context
                .read<Setting18ThresholdBloc>()
                .add(MaxRFOutputPowerChanged(maxRFOutputPower));
          },
          minValueErrorText: state.minRFOutputPower.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          maxValueErrorText: state.maxRFOutputPower.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
        );
      },
    );
  }
}

class _SplitOptionAlarmControl extends StatelessWidget {
  const _SplitOptionAlarmControl({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ThresholdBloc, Setting18ThresholdState>(
      builder: (context, state) {
        return thresholdAlarmSwitch(
          context: context,
          editMode: state.editMode,
          title: AppLocalizations.of(context)!.splitOption,
          value: state.splitOptionAlarmState,
          onChanged: (bool value) {
            context
                .read<Setting18ThresholdBloc>()
                .add(SplitOptionAlarmChanged(value));
          },
        );
      },
    );
  }
}

// class _PilotFrequency1AlarmControl extends StatelessWidget {
//   const _PilotFrequency1AlarmControl({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<Setting18ThresholdBloc, Setting18ThresholdState>(
//       builder: (context, state) {
//         return controlParameterSwitch(
//           context: context,
//           editMode: state.editMode,
//           title: AppLocalizations.of(context)!.pilotFrequency1Status,
//           value: state.pilotFrequency1AlarmState,
//           onChanged: (bool value) {
//             context
//                 .read<Setting18ThresholdBloc>()
//                 .add(PilotFrequency1AlarmChanged(value));
//           },
//         );
//       },
//     );
//   }
// }

// class _PilotFrequency2AlarmControl extends StatelessWidget {
//   const _PilotFrequency2AlarmControl({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<Setting18ThresholdBloc, Setting18ThresholdState>(
//       builder: (context, state) {
//         return controlParameterSwitch(
//           context: context,
//           editMode: state.editMode,
//           title: AppLocalizations.of(context)!.pilotFrequency2Status,
//           value: state.pilotFrequency2AlarmState,
//           onChanged: (bool value) {
//             context
//                 .read<Setting18ThresholdBloc>()
//                 .add(PilotFrequency2AlarmChanged(value));
//           },
//         );
//       },
//     );
//   }
// }

class _StartFrequencyOutputLevelAlarmControl extends StatelessWidget {
  const _StartFrequencyOutputLevelAlarmControl({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ThresholdBloc, Setting18ThresholdState>(
      builder: (context, state) {
        return thresholdAlarmSwitch(
          context: context,
          editMode: state.editMode,
          title: AppLocalizations.of(context)!.startFrequencyOutputLevelStatus,
          value: state.startFrequencyOutputLevelAlarmState,
          onChanged: (bool value) {
            context
                .read<Setting18ThresholdBloc>()
                .add(StartFrequencyOutputLevelAlarmStateChanged(value));
          },
        );
      },
    );
  }
}

class _StopFrequencyOutputLevelAlarmControl extends StatelessWidget {
  const _StopFrequencyOutputLevelAlarmControl({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ThresholdBloc, Setting18ThresholdState>(
      builder: (context, state) {
        return thresholdAlarmSwitch(
          context: context,
          editMode: state.editMode,
          title: AppLocalizations.of(context)!.stopFrequencyOutputLevelStatus,
          value: state.stopFrequencyOutputLevelAlarmState,
          onChanged: (bool value) {
            context
                .read<Setting18ThresholdBloc>()
                .add(StopFrequencyOutputLevelAlarmStateChanged(value));
          },
        );
      },
    );
  }
}

class _SettingFloatingActionButton extends StatelessWidget {
  const _SettingFloatingActionButton({
    super.key,
    required this.partId,
    required this.currentDetectedSplitOption,
  });

  final String partId;
  final String currentDetectedSplitOption;

  @override
  Widget build(BuildContext context) {
    Widget getEditTools({
      required bool editMode,
      required bool enableSubmission,
    }) {
      String graphFilePath = settingGraphFilePath[partId] ?? '';
      return editMode
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  shape: const CircleBorder(
                    side: BorderSide.none,
                  ),
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withAlpha(200),
                  child: Icon(
                    CustomIcons.cancel,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    context
                        .read<Setting18ThresholdBloc>()
                        .add(const EditModeDisabled());

                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.focusedChild?.unfocus();
                    }
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                FloatingActionButton(
                  shape: const CircleBorder(
                    side: BorderSide.none,
                  ),
                  backgroundColor: enableSubmission
                      ? Theme.of(context).colorScheme.primary.withAlpha(200)
                      : Colors.grey.withAlpha(200),
                  onPressed: enableSubmission
                      ? () async {
                          if (kDebugMode) {
                            context
                                .read<Setting18ThresholdBloc>()
                                .add(const SettingSubmitted());
                          } else {
                            bool? isMatch =
                                await showConfirmInputDialog(context: context);

                            if (context.mounted) {
                              if (isMatch != null) {
                                if (isMatch) {
                                  context
                                      .read<Setting18ThresholdBloc>()
                                      .add(const SettingSubmitted());
                                }
                              }
                            }
                          }
                        }
                      : null,
                  child: Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                graphFilePath.isNotEmpty
                    ? FloatingActionButton(
                        // heroTag is used to solve exception: There are multiple heroes that share the same tag within a subtree.
                        heroTag: null,
                        shape: const CircleBorder(
                          side: BorderSide.none,
                        ),
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withAlpha(200),
                        child: Icon(
                          Icons.settings_input_composite,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        onPressed: () {
                          // 當 Setting18GraphPage 被 pop 後, 不管有沒有設定參數都重新初始化
                          Navigator.push(context, Setting18GraphPage.route())
                              .then((value) => context
                                  .read<Setting18ThresholdBloc>()
                                  .add(const Initialized()));
                        },
                      )
                    : const SizedBox(
                        width: 0,
                        height: 0,
                      ),
                const SizedBox(
                  height: 10.0,
                ),
                FloatingActionButton(
                  shape: const CircleBorder(
                    side: BorderSide.none,
                  ),
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withAlpha(200),
                  child: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    context
                        .read<Setting18ThresholdBloc>()
                        .add(const EditModeEnabled());
                  },
                ),
              ],
            );
    }

    bool getEditable({
      required FormStatus loadingStatus,
    }) {
      if (loadingStatus.isRequestSuccess) {
        if (currentDetectedSplitOption != '0') {
          return true;
        } else {
          return false;
        }
      } else if (loadingStatus.isRequestFailure) {
        return false;
      } else {
        return false;
      }
    }

    // 同時 watch homeState 和 settingListViewState的變化
    // homeState 失去藍芽連線時會變更為不可編輯
    // settingListViewState 管理編輯模式或是觀看模式
    return Builder(builder: (context) {
      final HomeState homeState = context.watch<HomeBloc>().state;
      final Setting18ThresholdState setting18thresholdState =
          context.watch<Setting18ThresholdBloc>().state;

      bool editable = getEditable(
        loadingStatus: homeState.loadingStatus,
      );
      return editable
          ? getEditTools(
              editMode: setting18thresholdState.editMode,
              enableSubmission: setting18thresholdState.enableSubmission,
            )
          : Container();
    });
  }
}
