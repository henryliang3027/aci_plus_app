import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/repositories/unit_repository.dart';
import 'package:aci_plus_app/setting/bloc/setting18_ccor_node_threshold/setting18_ccor_node_threshold_bloc.dart';
import 'package:aci_plus_app/setting/model/confirm_input_dialog.dart';
import 'package:aci_plus_app/setting/model/setting_widgets.dart';
import 'package:aci_plus_app/setting/views/custom_setting_dialog.dart';
import 'package:aci_plus_app/setting/views/setting18_ccor_node_views/setting18_ccor_node_graph_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18CCorNodeThresholdView extends StatelessWidget {
  Setting18CCorNodeThresholdView({super.key});

  final TextEditingController minTemperatureTextEditingController =
      TextEditingController();
  final TextEditingController maxTemperatureTextEditingController =
      TextEditingController();
  final TextEditingController minVoltageTextEditingController =
      TextEditingController();
  final TextEditingController maxVoltageTextEditingController =
      TextEditingController();

  final TextEditingController minRFOutputPower1TextEditingController =
      TextEditingController();
  final TextEditingController maxRFOutputPower1TextEditingController =
      TextEditingController();

  final TextEditingController minRFOutputPower3TextEditingController =
      TextEditingController();
  final TextEditingController maxRFOutputPower3TextEditingController =
      TextEditingController();

  final TextEditingController minRFOutputPower4TextEditingController =
      TextEditingController();
  final TextEditingController maxRFOutputPower4TextEditingController =
      TextEditingController();

  final TextEditingController minRFOutputPower6TextEditingController =
      TextEditingController();
  final TextEditingController maxRFOutputPower6TextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    HomeState homeState = context.watch<HomeBloc>().state;
    String partId = homeState.characteristicData[DataKey.partId] ?? '';
    // String currentDetectedSplitOption =
    //     homeState.characteristicData[DataKey.currentDetectedSplitOption] ?? '0';

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
      } else if (item == DataKey.temperatureAlarmState.name) {
        return AppLocalizations.of(context)!
            .dialogMessageTemperatureAlarmStateSetting;
      } else if (item == DataKey.voltageAlarmState.name) {
        return AppLocalizations.of(context)!
            .dialogMessageVoltageAlarmStateSetting;
      } else if (item == DataKey.splitOptionAlarmState.name) {
        return AppLocalizations.of(context)!
            .dialogMessageSplitOptionAlarmStateSetting;
      } else if (item == DataKey.maxRFOutputPower1.name) {
        return AppLocalizations.of(context)!
            .dialogMessageMaxRFOutputPower1Setting;
      } else if (item == DataKey.minRFOutputPower1.name) {
        return AppLocalizations.of(context)!
            .dialogMessageMinRFOutputPower1Setting;
      } else if (item == DataKey.rfOutputPower1AlarmState.name) {
        return AppLocalizations.of(context)!
            .dialogMessageRFOutputPower1AlarmStateSetting;
      } else if (item == DataKey.maxRFOutputPower3.name) {
        return AppLocalizations.of(context)!
            .dialogMessageMaxRFOutputPower3Setting;
      } else if (item == DataKey.minRFOutputPower3.name) {
        return AppLocalizations.of(context)!
            .dialogMessageMinRFOutputPower3Setting;
      } else if (item == DataKey.rfOutputPower3AlarmState.name) {
        return AppLocalizations.of(context)!
            .dialogMessageRFOutputPower3AlarmStateSetting;
      } else if (item == DataKey.maxRFOutputPower4.name) {
        return AppLocalizations.of(context)!
            .dialogMessageMaxRFOutputPower4Setting;
      } else if (item == DataKey.minRFOutputPower4.name) {
        return AppLocalizations.of(context)!
            .dialogMessageMinRFOutputPower4Setting;
      } else if (item == DataKey.rfOutputPower4AlarmState.name) {
        return AppLocalizations.of(context)!
            .dialogMessageRFOutputPower4AlarmStateSetting;
      } else if (item == DataKey.maxRFOutputPower6.name) {
        return AppLocalizations.of(context)!
            .dialogMessageMaxRFOutputPower6Setting;
      } else if (item == DataKey.minRFOutputPower6.name) {
        return AppLocalizations.of(context)!
            .dialogMessageMinRFOutputPower6Setting;
      } else if (item == DataKey.rfOutputPower6AlarmState.name) {
        return AppLocalizations.of(context)!
            .dialogMessageRFOutputPower6AlarmStateSetting;
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
              Text(
                formatResultValue(value),
                style: TextStyle(
                  fontSize: CustomStyle.sizeL,
                  color: valueColor,
                ),
                textAlign: TextAlign.end,
              ),
            ],
          ),
        ));
      }
      return rows;
    }

    List<Widget> getThresholdParameterWidgetsByPartId(String partId) {
      List<Enum> items = SettingItemTable.itemsMap[partId] ?? [];
      List<Widget> widgets = [];

      items =
          items.where((item) => item.runtimeType == SettingThreshold).toList();

      for (Enum name in items) {
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
          case SettingThreshold.outputPower1:
            widgets.add(_RFOutputPower1AlarmControl(
              minRFOutputPower1TextEditingController:
                  minRFOutputPower1TextEditingController,
              maxRFOutputPower1TextEditingController:
                  maxRFOutputPower1TextEditingController,
            ));
            break;

          case SettingThreshold.outputPower3:
            widgets.add(_RFOutputPower3AlarmControl(
              minRFOutputPower3TextEditingController:
                  minRFOutputPower3TextEditingController,
              maxRFOutputPower3TextEditingController:
                  maxRFOutputPower3TextEditingController,
            ));
            break;

          case SettingThreshold.outputPower4:
            widgets.add(_RFOutputPower4AlarmControl(
              minRFOutputPower4TextEditingController:
                  minRFOutputPower4TextEditingController,
              maxRFOutputPower4TextEditingController:
                  maxRFOutputPower4TextEditingController,
            ));
            break;

          case SettingThreshold.outputPower6:
            widgets.add(_RFOutputPower6AlarmControl(
              minRFOutputPower6TextEditingController:
                  minRFOutputPower6TextEditingController,
              maxRFOutputPower6TextEditingController:
                  maxRFOutputPower6TextEditingController,
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
              _RFOutputPower1AlarmControl(
                minRFOutputPower1TextEditingController:
                    minRFOutputPower1TextEditingController,
                maxRFOutputPower1TextEditingController:
                    maxRFOutputPower1TextEditingController,
              ),
              _RFOutputPower3AlarmControl(
                minRFOutputPower3TextEditingController:
                    minRFOutputPower3TextEditingController,
                maxRFOutputPower3TextEditingController:
                    maxRFOutputPower3TextEditingController,
              ),
              _RFOutputPower4AlarmControl(
                minRFOutputPower4TextEditingController:
                    minRFOutputPower4TextEditingController,
                maxRFOutputPower4TextEditingController:
                    maxRFOutputPower4TextEditingController,
              ),
              _RFOutputPower6AlarmControl(
                minRFOutputPower6TextEditingController:
                    minRFOutputPower6TextEditingController,
                maxRFOutputPower6TextEditingController:
                    maxRFOutputPower6TextEditingController,
              )
            ];
    }

    List<Widget> getForwardSettingWidgetsByPartId(String partId) {
      List<Enum> items = SettingItemTable.itemsMap[partId] ?? [];
      List<Widget> widgets = [];

      items =
          items.where((item) => item.runtimeType == SettingThreshold).toList();

      for (Enum name in items) {
        switch (name) {
          case SettingThreshold.splitOptions:
            widgets.add(const _SplitOptionAlarmControl());
            break;
        }
      }

      return widgets.isNotEmpty
          ? widgets
          : [
              const _SplitOptionAlarmControl(),
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

    return BlocListener<Setting18CCorNodeThresholdBloc,
        Setting18CCorNodeThresholdState>(
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

          context
              .read<Setting18CCorNodeThresholdBloc>()
              .add(const Initialized());
        }

        if (state.isInitialize) {
          minTemperatureTextEditingController.text = state.minTemperature.value;
          maxTemperatureTextEditingController.text = state.maxTemperature.value;
          minVoltageTextEditingController.text = state.minVoltage.value;
          maxVoltageTextEditingController.text = state.maxVoltage.value;
          minRFOutputPower1TextEditingController.text =
              state.minRFOutputPower1.value;
          maxRFOutputPower1TextEditingController.text =
              state.maxRFOutputPower1.value;
          minRFOutputPower3TextEditingController.text =
              state.minRFOutputPower3.value;
          maxRFOutputPower3TextEditingController.text =
              state.maxRFOutputPower3.value;
          minRFOutputPower4TextEditingController.text =
              state.minRFOutputPower4.value;
          maxRFOutputPower4TextEditingController.text =
              state.maxRFOutputPower4.value;
          minRFOutputPower6TextEditingController.text =
              state.minRFOutputPower6.value;
          maxRFOutputPower6TextEditingController.text =
              state.maxRFOutputPower6.value;
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
          // currentDetectedSplitOption: currentDetectedSplitOption,
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

    return BlocBuilder<Setting18CCorNodeThresholdBloc,
        Setting18CCorNodeThresholdState>(
      builder: (context, state) {
        return thresholdAlarmParameterWidget(
          context: context,
          minValueTextEditingControllerName:
              'setting18_ccor_node_temperature_minValue_textField',
          maxValueTextEditingControllerName:
              'setting18_ccor_node_temperature_maxValue_textField',
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
                .read<Setting18CCorNodeThresholdBloc>()
                .add(TemperatureAlarmChanged(value));
          },
          onChangedMinValue: (minTemperature) {
            context
                .read<Setting18CCorNodeThresholdBloc>()
                .add(MinTemperatureChanged(minTemperature));
          },
          onChangedMaxValue: (maxTemperature) {
            context
                .read<Setting18CCorNodeThresholdBloc>()
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
    return BlocBuilder<Setting18CCorNodeThresholdBloc,
        Setting18CCorNodeThresholdState>(
      builder: (context, state) {
        return thresholdAlarmParameterWidget(
          context: context,
          minValueTextEditingControllerName:
              'setting18_ccor_node_voltage_minValue_textField',
          maxValueTextEditingControllerName:
              'setting18_ccor_node_voltage_maxValue_textField',
          minValueTextEditingController: minVoltageTextEditingController,
          maxValueTextEditingController: maxVoltageTextEditingController,
          minValueLabel: AppLocalizations.of(context)!.minVoltage,
          maxValueLabel: AppLocalizations.of(context)!.maxVoltage,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.voltageLevel} (${CustomStyle.volt})',
          enabledAlarmState: state.voltageAlarmState,
          onChangedAlarmState: (value) {
            context
                .read<Setting18CCorNodeThresholdBloc>()
                .add(VoltageAlarmChanged(value));
          },
          onChangedMinValue: (minVoltage) {
            context
                .read<Setting18CCorNodeThresholdBloc>()
                .add(MinVoltageChanged(minVoltage));
          },
          onChangedMaxValue: (maxVoltage) {
            context
                .read<Setting18CCorNodeThresholdBloc>()
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

class _RFOutputPower1AlarmControl extends StatelessWidget {
  const _RFOutputPower1AlarmControl({
    super.key,
    required this.minRFOutputPower1TextEditingController,
    required this.maxRFOutputPower1TextEditingController,
  });

  final TextEditingController minRFOutputPower1TextEditingController;
  final TextEditingController maxRFOutputPower1TextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeThresholdBloc,
        Setting18CCorNodeThresholdState>(
      builder: (context, state) {
        return thresholdAlarmParameterWidget(
          context: context,
          minValueTextEditingControllerName:
              'setting18_ccor_node_rfOutputPower1_minValue_textField',
          maxValueTextEditingControllerName:
              'setting18_ccor_node_rfOutputPower1_maxValue_textField',
          minValueTextEditingController: minRFOutputPower1TextEditingController,
          maxValueTextEditingController: maxRFOutputPower1TextEditingController,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.rfOutputPower1} (${CustomStyle.dBmV})',
          minValueLabel: AppLocalizations.of(context)!.minRFOutputPower,
          maxValueLabel: AppLocalizations.of(context)!.maxRFOutputPower,
          enabledAlarmState: state.rfOutputPower1AlarmState,
          onChangedAlarmState: (value) {
            context
                .read<Setting18CCorNodeThresholdBloc>()
                .add(RFOutputPowerAlarmState1Changed(value));
          },
          onChangedMinValue: (value) {
            context
                .read<Setting18CCorNodeThresholdBloc>()
                .add(MinRFOutputPower1Changed(value));
          },
          onChangedMaxValue: (value) {
            context
                .read<Setting18CCorNodeThresholdBloc>()
                .add(MaxRFOutputPower1Changed(value));
          },
          minValueErrorText: state.minRFOutputPower1.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          maxValueErrorText: state.maxRFOutputPower1.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
        );
      },
    );
  }
}

class _RFOutputPower3AlarmControl extends StatelessWidget {
  const _RFOutputPower3AlarmControl({
    super.key,
    required this.minRFOutputPower3TextEditingController,
    required this.maxRFOutputPower3TextEditingController,
  });

  final TextEditingController minRFOutputPower3TextEditingController;
  final TextEditingController maxRFOutputPower3TextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeThresholdBloc,
        Setting18CCorNodeThresholdState>(
      builder: (context, state) {
        return thresholdAlarmParameterWidget(
          context: context,
          minValueTextEditingControllerName:
              'setting18_ccor_node_rfOutputPower3_minValue_textField',
          maxValueTextEditingControllerName:
              'setting18_ccor_node_rfOutputPower3_maxValue_textField',
          minValueTextEditingController: minRFOutputPower3TextEditingController,
          maxValueTextEditingController: maxRFOutputPower3TextEditingController,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.rfOutputPower3} (${CustomStyle.dBmV})',
          minValueLabel: AppLocalizations.of(context)!.minRFOutputPower,
          maxValueLabel: AppLocalizations.of(context)!.maxRFOutputPower,
          enabledAlarmState: state.rfOutputPower3AlarmState,
          onChangedAlarmState: (value) {
            context
                .read<Setting18CCorNodeThresholdBloc>()
                .add(RFOutputPowerAlarmState3Changed(value));
          },
          onChangedMinValue: (value) {
            context
                .read<Setting18CCorNodeThresholdBloc>()
                .add(MinRFOutputPower3Changed(value));
          },
          onChangedMaxValue: (value) {
            context
                .read<Setting18CCorNodeThresholdBloc>()
                .add(MaxRFOutputPower3Changed(value));
          },
          minValueErrorText: state.minRFOutputPower3.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          maxValueErrorText: state.maxRFOutputPower3.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
        );
      },
    );
  }
}

class _RFOutputPower4AlarmControl extends StatelessWidget {
  const _RFOutputPower4AlarmControl({
    super.key,
    required this.minRFOutputPower4TextEditingController,
    required this.maxRFOutputPower4TextEditingController,
  });

  final TextEditingController minRFOutputPower4TextEditingController;
  final TextEditingController maxRFOutputPower4TextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeThresholdBloc,
        Setting18CCorNodeThresholdState>(
      builder: (context, state) {
        return thresholdAlarmParameterWidget(
          context: context,
          minValueTextEditingControllerName:
              'setting18_ccor_node_rfOutputPower4_minValue_textField',
          maxValueTextEditingControllerName:
              'setting18_ccor_node_rfOutputPower4_maxValue_textField',
          minValueTextEditingController: minRFOutputPower4TextEditingController,
          maxValueTextEditingController: maxRFOutputPower4TextEditingController,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.rfOutputPower4} (${CustomStyle.dBmV})',
          minValueLabel: AppLocalizations.of(context)!.minRFOutputPower,
          maxValueLabel: AppLocalizations.of(context)!.maxRFOutputPower,
          enabledAlarmState: state.rfOutputPower4AlarmState,
          onChangedAlarmState: (value) {
            context
                .read<Setting18CCorNodeThresholdBloc>()
                .add(RFOutputPowerAlarmState4Changed(value));
          },
          onChangedMinValue: (value) {
            context
                .read<Setting18CCorNodeThresholdBloc>()
                .add(MinRFOutputPower4Changed(value));
          },
          onChangedMaxValue: (value) {
            context
                .read<Setting18CCorNodeThresholdBloc>()
                .add(MaxRFOutputPower4Changed(value));
          },
          minValueErrorText: state.minRFOutputPower4.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          maxValueErrorText: state.maxRFOutputPower4.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
        );
      },
    );
  }
}

class _RFOutputPower6AlarmControl extends StatelessWidget {
  const _RFOutputPower6AlarmControl({
    super.key,
    required this.minRFOutputPower6TextEditingController,
    required this.maxRFOutputPower6TextEditingController,
  });

  final TextEditingController minRFOutputPower6TextEditingController;
  final TextEditingController maxRFOutputPower6TextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeThresholdBloc,
        Setting18CCorNodeThresholdState>(
      builder: (context, state) {
        return thresholdAlarmParameterWidget(
          context: context,
          minValueTextEditingControllerName:
              'setting18_ccor_node_rfOutputPower6_minValue_textField',
          maxValueTextEditingControllerName:
              'setting18_ccor_node_rfOutputPower6_maxValue_textField',
          minValueTextEditingController: minRFOutputPower6TextEditingController,
          maxValueTextEditingController: maxRFOutputPower6TextEditingController,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.rfOutputPower6} (${CustomStyle.dBmV})',
          minValueLabel: AppLocalizations.of(context)!.minRFOutputPower,
          maxValueLabel: AppLocalizations.of(context)!.maxRFOutputPower,
          enabledAlarmState: state.rfOutputPower6AlarmState,
          onChangedAlarmState: (value) {
            context
                .read<Setting18CCorNodeThresholdBloc>()
                .add(RFOutputPowerAlarmState6Changed(value));
          },
          onChangedMinValue: (value) {
            context
                .read<Setting18CCorNodeThresholdBloc>()
                .add(MinRFOutputPower6Changed(value));
          },
          onChangedMaxValue: (value) {
            context
                .read<Setting18CCorNodeThresholdBloc>()
                .add(MaxRFOutputPower6Changed(value));
          },
          minValueErrorText: state.minRFOutputPower6.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          maxValueErrorText: state.maxRFOutputPower6.isNotValid
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
    return BlocBuilder<Setting18CCorNodeThresholdBloc,
        Setting18CCorNodeThresholdState>(
      builder: (context, state) {
        return thresholdAlarmSwitch(
          context: context,
          editMode: state.editMode,
          title: AppLocalizations.of(context)!.splitOption,
          value: state.splitOptionAlarmState,
          onChanged: (bool value) {
            context
                .read<Setting18CCorNodeThresholdBloc>()
                .add(SplitOptionAlarmChanged(value));
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
    // required this.currentDetectedSplitOption,
  });

  final String partId;
  // final String currentDetectedSplitOption;

  @override
  Widget build(BuildContext context) {
    Widget getEnabledEditModeTools({
      required bool enableSubmission,
    }) {
      return Column(
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
                  .read<Setting18CCorNodeThresholdBloc>()
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
                          .read<Setting18CCorNodeThresholdBloc>()
                          .add(const SettingSubmitted());
                    } else {
                      bool? isMatch =
                          await showConfirmInputDialog(context: context);

                      if (context.mounted) {
                        if (isMatch != null) {
                          if (isMatch) {
                            context
                                .read<Setting18CCorNodeThresholdBloc>()
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
      );
    }

    Widget getDisabledEditModeTools() {
      String graphFilePath = settingGraphFilePath[partId] ?? '';
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          graphFilePath.isNotEmpty
              ? FloatingActionButton(
                  // heroTag is used to solve exception: There are multiple heroes that share the same tag within a subtree.
                  heroTag: null,
                  shape: const CircleBorder(
                    side: BorderSide.none,
                  ),
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withAlpha(200),
                  child: Icon(
                    Icons.settings_input_composite,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    // 當 Setting18GraphPage 被 pop 後, 不管有沒有設定參數都重新初始化
                    Navigator.push(
                            context,
                            Setting18CCorNodeGraphPage.route(
                              graphFilePath: graphFilePath,
                            ))
                        .then((value) => context
                            .read<Setting18CCorNodeThresholdBloc>()
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
                  .read<Setting18CCorNodeThresholdBloc>()
                  .add(const EditModeEnabled());
            },
          ),
        ],
      );
    }

    Widget getEditTools({
      required bool editMode,
      required bool enableSubmission,
    }) {
      return editMode
          ? getEnabledEditModeTools(
              enableSubmission: enableSubmission,
            )
          : getDisabledEditModeTools();
    }

    Widget getDisabledGraphSettingTool() {
      String graphFilePath = settingGraphFilePath['4'] ?? '';
      return graphFilePath.isNotEmpty
          ? FloatingActionButton(
              // heroTag is used to solve exception: There are multiple heroes that share the same tag within a subtree.
              heroTag: null,
              shape: const CircleBorder(
                side: BorderSide.none,
              ),
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withAlpha(200),
              child: Icon(
                Icons.settings_input_composite,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () {
                // 當 Setting18GraphPage 被 pop 後, 不管有沒有設定參數都重新初始化
                Navigator.push(
                        context,
                        Setting18CCorNodeGraphPage.route(
                          graphFilePath: graphFilePath,
                          editable: false,
                        ))
                    .then((value) => context
                        .read<Setting18CCorNodeThresholdBloc>()
                        .add(const Initialized()));
              },
            )
          : const SizedBox(
              width: 0,
              height: 0,
            );
    }

    bool getEditable({
      required FormStatus loadingStatus,
    }) {
      if (loadingStatus.isRequestSuccess) {
        return true;
        // if (currentDetectedSplitOption != '0') {
        //   return true;
        // } else {
        //   return false;
        // }
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
      final Setting18CCorNodeThresholdState setting18CCorNodeThresholdState =
          context.watch<Setting18CCorNodeThresholdBloc>().state;

      bool editable = getEditable(loadingStatus: homeState.loadingStatus);
      return editable
          ? getEditTools(
              editMode: setting18CCorNodeThresholdState.editMode,
              enableSubmission:
                  setting18CCorNodeThresholdState.enableSubmission,
            )
          : getDisabledGraphSettingTool();
    });
  }
}
