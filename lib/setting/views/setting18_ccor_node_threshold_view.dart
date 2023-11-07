import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/custom_icons/custom_icons.dart';
import 'package:dsim_app/core/custom_style.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/core/setting_items_table.dart';
import 'package:dsim_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:dsim_app/repositories/unit_repository.dart';
import 'package:dsim_app/setting/bloc/setting18_ccor_node_threshold/setting18_ccor_node_threshold_bloc.dart';
import 'package:dsim_app/setting/views/custom_setting_dialog.dart';
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

    String minTemperature =
        homeState.characteristicData[DataKey.minTemperatureC] ?? '';
    String maxTemperature =
        homeState.characteristicData[DataKey.maxTemperatureC] ?? '';
    String minTemperatureF =
        homeState.characteristicData[DataKey.minTemperatureF] ?? '';
    String maxTemperatureF =
        homeState.characteristicData[DataKey.maxTemperatureF] ?? '';
    String minVoltage = homeState.characteristicData[DataKey.minVoltage] ?? '';
    String maxVoltage = homeState.characteristicData[DataKey.maxVoltage] ?? '';

    String strTemperatureAlarmState =
        homeState.characteristicData[DataKey.temperatureAlarmState] ?? '';
    bool temperatureAlarmState = strTemperatureAlarmState == '1' ? false : true;

    String strVoltageAlarmState =
        homeState.characteristicData[DataKey.voltageAlarmState] ?? '';
    bool voltageAlarmState = strVoltageAlarmState == '1' ? false : true;

    String strSplitOptionAlarmState =
        homeState.characteristicData[DataKey.splitOptionAlarmState] ?? '';
    bool splitOptionAlarmState = strSplitOptionAlarmState == '1' ? false : true;

    String strRFOutputPowerAlarmState1 =
        homeState.characteristicData[DataKey.rfOutputPowerAlarmState1] ?? '';
    bool rfOutputPowerAlarmState1 =
        strRFOutputPowerAlarmState1 == '1' ? false : true;

    String strRFOutputPowerAlarmState3 =
        homeState.characteristicData[DataKey.rfOutputPowerAlarmState3] ?? '';
    bool rfOutputPowerAlarmState3 =
        strRFOutputPowerAlarmState3 == '1' ? false : true;

    String strRFOutputPowerAlarmState4 =
        homeState.characteristicData[DataKey.rfOutputPowerAlarmState4] ?? '';
    bool rfOutputPowerAlarmState4 =
        strRFOutputPowerAlarmState4 == '1' ? false : true;

    String strRFOutputPowerAlarmState6 =
        homeState.characteristicData[DataKey.rfOutputPowerAlarmState6] ?? '';
    bool rfOutputPowerAlarmState6 =
        strRFOutputPowerAlarmState6 == '1' ? false : true;

    String minRFOutputPower1 =
        homeState.characteristicData[DataKey.minRFOutputPower1] ?? '';
    String maxRFOutputPower1 =
        homeState.characteristicData[DataKey.maxRFOutputPower1] ?? '';
    String minRFOutputPower3 =
        homeState.characteristicData[DataKey.minRFOutputPower3] ?? '';
    String maxRFOutputPower3 =
        homeState.characteristicData[DataKey.maxRFOutputPower3] ?? '';
    String minRFOutputPower4 =
        homeState.characteristicData[DataKey.minRFOutputPower4] ?? '';
    String maxRFOutputPower4 =
        homeState.characteristicData[DataKey.maxRFOutputPower4] ?? '';
    String minRFOutputPower6 =
        homeState.characteristicData[DataKey.minRFOutputPower6] ?? '';
    String maxRFOutputPower6 =
        homeState.characteristicData[DataKey.maxRFOutputPower6] ?? '';

    context.read<Setting18CCorNodeThresholdBloc>().add(Initialized(
          temperatureAlarmState: temperatureAlarmState,
          minTemperature: minTemperature,
          maxTemperature: maxTemperature,
          minTemperatureF: minTemperatureF,
          maxTemperatureF: maxTemperatureF,
          voltageAlarmState: voltageAlarmState,
          minVoltage: minVoltage,
          maxVoltage: maxVoltage,
          splitOptionAlarmState: splitOptionAlarmState,
          rfOutputPowerAlarmState1: rfOutputPowerAlarmState1,
          minRFOutputPower1: minRFOutputPower1,
          maxRFOutputPower1: maxRFOutputPower1,
          rfOutputPowerAlarmState3: rfOutputPowerAlarmState3,
          minRFOutputPower3: minRFOutputPower3,
          maxRFOutputPower3: maxRFOutputPower3,
          rfOutputPowerAlarmState4: rfOutputPowerAlarmState4,
          minRFOutputPower4: minRFOutputPower4,
          maxRFOutputPower4: maxRFOutputPower4,
          rfOutputPowerAlarmState6: rfOutputPowerAlarmState6,
          minRFOutputPower6: minRFOutputPower6,
          maxRFOutputPower6: maxRFOutputPower6,
        ));

    String formatResultValue(String boolValue) {
      return boolValue == 'true'
          ? AppLocalizations.of(context).dialogMessageSuccessful
          : AppLocalizations.of(context).dialogMessageFailed;
    }

    String formatResultItem(String item) {
      if (item == DataKey.maxTemperatureC.name) {
        return AppLocalizations.of(context).dialogMessageMaxTemperatureSetting;
      } else if (item == DataKey.minTemperatureC.name) {
        return AppLocalizations.of(context).dialogMessageMinTemperatureSetting;
      } else if (item == DataKey.maxVoltage.name) {
        return AppLocalizations.of(context).dialogMessageMaxVoltageSetting;
      } else if (item == DataKey.minVoltage.name) {
        return AppLocalizations.of(context).dialogMessageMinVoltageSetting;
      } else if (item == DataKey.maxRFOutputPower1.name) {
        return AppLocalizations.of(context)
            .dialogMessageMaxRFOutputPowerSetting;
      } else if (item == DataKey.minRFOutputPower1.name) {
        return AppLocalizations.of(context)
            .dialogMessageMinRFOutputPowerSetting;
      } else if (item == DataKey.temperatureAlarmState.name) {
        return AppLocalizations.of(context)
            .dialogMessageTemperatureAlarmStateSetting;
      } else if (item == DataKey.voltageAlarmState.name) {
        return AppLocalizations.of(context)
            .dialogMessageVoltageAlarmStateSetting;
      } else if (item == DataKey.splitOptionAlarmState.name) {
        return AppLocalizations.of(context)
            .dialogMessageSplitOptionAlarmStateSetting;
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
                    fontSize: 16,
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
                  title: AppLocalizations.of(context).forwardSetting,
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
        }

        if (state.isInitialize) {
          minTemperatureTextEditingController.text = state.minTemperature;
          maxTemperatureTextEditingController.text = state.maxTemperature;
          minVoltageTextEditingController.text = state.minVoltage;
          maxVoltageTextEditingController.text = state.maxVoltage;
          minRFOutputPower1TextEditingController.text = state.minRFOutputPower1;
          maxRFOutputPower1TextEditingController.text = state.maxRFOutputPower1;
          minRFOutputPower3TextEditingController.text = state.minRFOutputPower3;
          maxRFOutputPower3TextEditingController.text = state.maxRFOutputPower3;
          minRFOutputPower4TextEditingController.text = state.minRFOutputPower4;
          maxRFOutputPower4TextEditingController.text = state.maxRFOutputPower4;
          minRFOutputPower6TextEditingController.text = state.minRFOutputPower6;
          maxRFOutputPower6TextEditingController.text = state.maxRFOutputPower6;
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
        floatingActionButton: const _SettingFloatingActionButton(),
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
                fontSize: 16.0,
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
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: Text(
                      AppLocalizations.of(context).temperatureFC,
                      style: const TextStyle(
                        fontSize: 16.0,
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
                      value: state.temperatureAlarmState,
                      onChanged: state.editMode
                          ? (bool value) {
                              context
                                  .read<Setting18CCorNodeThresholdBloc>()
                                  .add(TemperatureAlarmChanged(value));
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                    child: TextField(
                      controller: minTemperatureTextEditingController,
                      key: const Key(
                          'setting18Form_minTemperatureInput_textField'),
                      style: const TextStyle(
                        fontSize: CustomStyle.sizeXL,
                      ),
                      enabled: state.editMode,
                      textInputAction: TextInputAction.done,
                      onChanged: (minTemperature) {
                        context
                            .read<Setting18CCorNodeThresholdBloc>()
                            .add(MinTemperatureChanged(minTemperature));
                      },
                      maxLength: 40,
                      decoration: InputDecoration(
                        label: Text(
                            '${AppLocalizations.of(context).minTemperature}(${getTemperatureUnit(state.temperatureUnit)})'),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0))),
                        contentPadding: const EdgeInsets.all(8.0),
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        counterText: '',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    flex: 2,
                    child: TextField(
                      controller: maxTemperatureTextEditingController,
                      key: const Key(
                          'setting18Form_maxTemperatureInput_textField'),
                      style: const TextStyle(
                        fontSize: CustomStyle.sizeXL,
                      ),
                      enabled: state.editMode,
                      textInputAction: TextInputAction.done,
                      onChanged: (maxTemperature) {
                        context
                            .read<Setting18CCorNodeThresholdBloc>()
                            .add(MaxTemperatureChanged(maxTemperature));
                      },
                      maxLength: 40,
                      decoration: InputDecoration(
                        label: Text(
                            '${AppLocalizations.of(context).maxTemperature}(${getTemperatureUnit(state.temperatureUnit)})'),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0))),
                        contentPadding: const EdgeInsets.all(8.0),
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        counterText: '',
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
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: Text(
                      '${AppLocalizations.of(context).voltageLevel} (${CustomStyle.volt})',
                      style: const TextStyle(
                        fontSize: 16.0,
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
                      value: state.voltageAlarmState,
                      onChanged: state.editMode
                          ? (bool value) {
                              context
                                  .read<Setting18CCorNodeThresholdBloc>()
                                  .add(VoltageAlarmChanged(value));
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                    child: TextField(
                      controller: minVoltageTextEditingController,
                      key: const Key('setting18Form_minVoltageInput_textField'),
                      style: const TextStyle(
                        fontSize: CustomStyle.sizeXL,
                      ),
                      enabled: state.editMode,
                      textInputAction: TextInputAction.done,
                      onChanged: (minVoltage) {
                        context
                            .read<Setting18CCorNodeThresholdBloc>()
                            .add(MinVoltageChanged(minVoltage));
                      },
                      maxLength: 40,
                      decoration: InputDecoration(
                        label: Text(AppLocalizations.of(context).minVoltage),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0))),
                        contentPadding: EdgeInsets.all(8.0),
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        counterText: '',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    flex: 2,
                    child: TextField(
                      controller: maxVoltageTextEditingController,
                      key: const Key('setting18Form_maxVoltageInput_textField'),
                      style: const TextStyle(
                        fontSize: CustomStyle.sizeXL,
                      ),
                      enabled: state.editMode,
                      textInputAction: TextInputAction.done,
                      onChanged: (maxVoltage) {
                        context
                            .read<Setting18CCorNodeThresholdBloc>()
                            .add(MaxVoltageChanged(maxVoltage));
                      },
                      maxLength: 40,
                      decoration: InputDecoration(
                        label: Text(AppLocalizations.of(context).maxVoltage),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0))),
                        contentPadding: EdgeInsets.all(8.0),
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        counterText: '',
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

Widget alarmControl({
  required BuildContext context,
  required TextEditingController minValueTextEditingController,
  required TextEditingController maxValueTextEditingController,
  required bool editMode,
  required String title,
  required bool enabledAlarmState,
  required String minValue,
  required String maxValue,
  required ValueChanged<bool> onChangedAlarmState,
  required ValueChanged<String> onChangedMinValue,
  required ValueChanged<String> onChangedMaxValue,
}) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(
          bottom: 16.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 3,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16.0,
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
                value: enabledAlarmState,
                onChanged: editMode ? onChangedAlarmState : null,
              ),
            ),
          ],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: TextField(
              controller: minValueTextEditingController,
              key: const Key('setting18CCorNodeForm_minValue_textField'),
              style: const TextStyle(
                fontSize: CustomStyle.sizeXL,
              ),
              enabled: editMode,
              textInputAction: TextInputAction.done,
              onChanged: onChangedMinValue,
              maxLength: 40,
              decoration: InputDecoration(
                label: Text(AppLocalizations.of(context).minVoltage),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                contentPadding: EdgeInsets.all(8.0),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                counterText: '',
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Flexible(
            flex: 2,
            child: TextField(
              controller: maxValueTextEditingController,
              key: const Key('setting18Form_maxValue_textField'),
              style: const TextStyle(
                fontSize: CustomStyle.sizeXL,
              ),
              enabled: editMode,
              textInputAction: TextInputAction.done,
              onChanged: onChangedMaxValue,
              maxLength: 40,
              decoration: InputDecoration(
                label: Text(AppLocalizations.of(context).maxVoltage),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                contentPadding: EdgeInsets.all(8.0),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                counterText: '',
              ),
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 60,
      ),
    ],
  );
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
        return alarmControl(
          context: context,
          minValueTextEditingController: minRFOutputPower1TextEditingController,
          maxValueTextEditingController: maxRFOutputPower1TextEditingController,
          editMode: state.editMode,
          title: '${AppLocalizations.of(context).rfOutputPower} 1',
          enabledAlarmState: state.rfOutputPowerAlarmState1,
          minValue: state.minRFOutputPower1,
          maxValue: state.maxRFOutputPower1,
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
        return alarmControl(
          context: context,
          minValueTextEditingController: minRFOutputPower3TextEditingController,
          maxValueTextEditingController: maxRFOutputPower3TextEditingController,
          editMode: state.editMode,
          title: '${AppLocalizations.of(context).rfOutputPower} 3',
          enabledAlarmState: state.rfOutputPowerAlarmState3,
          minValue: state.minRFOutputPower3,
          maxValue: state.maxRFOutputPower3,
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
        return alarmControl(
          context: context,
          minValueTextEditingController: minRFOutputPower4TextEditingController,
          maxValueTextEditingController: maxRFOutputPower4TextEditingController,
          editMode: state.editMode,
          title: '${AppLocalizations.of(context).rfOutputPower} 4',
          enabledAlarmState: state.rfOutputPowerAlarmState4,
          minValue: state.minRFOutputPower4,
          maxValue: state.maxRFOutputPower4,
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
        return alarmControl(
          context: context,
          minValueTextEditingController: minRFOutputPower6TextEditingController,
          maxValueTextEditingController: maxRFOutputPower6TextEditingController,
          editMode: state.editMode,
          title: '${AppLocalizations.of(context).rfOutputPower} 6',
          enabledAlarmState: state.rfOutputPowerAlarmState6,
          minValue: state.minRFOutputPower6,
          maxValue: state.maxRFOutputPower6,
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
        );
      },
    );
  }
}

Widget controlParameterSwitch({
  required BuildContext context,
  required bool editMode,
  required String title,
  required bool value,
  required ValueChanged<bool> onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.only(
      bottom: 16.0,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 2,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Flexible(
          child: Switch(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return const Icon(Icons.check);
                }
                return const Icon(Icons.close);
              },
            ),
            value: value,
            onChanged: editMode ? onChanged : null,
          ),
        ),
      ],
    ),
  );
}

class _SplitOptionAlarmControl extends StatelessWidget {
  const _SplitOptionAlarmControl({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeThresholdBloc,
        Setting18CCorNodeThresholdState>(
      builder: (context, state) {
        return controlParameterSwitch(
          context: context,
          editMode: state.editMode,
          title: AppLocalizations.of(context).splitOption,
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
  const _SettingFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    Widget getEditTools({
      required bool editMode,
      required bool enableSubmission,
    }) {
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
                      ? () {
                          context
                              .read<Setting18CCorNodeThresholdBloc>()
                              .add(const SettingSubmitted());
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
                // FloatingActionButton(
                //   shape: const CircleBorder(
                //     side: BorderSide.none,
                //   ),
                //   backgroundColor: Colors.grey.withAlpha(200),
                //   child: Icon(
                //     Icons.grain_sharp,
                //     color: Theme.of(context).colorScheme.onPrimary,
                //   ),
                //   onPressed: () {
                //     context.read<SettingBloc>().add(const GraphViewToggled());
                //   },
                // ),
                // const SizedBox(
                //   height: 10.0,
                // ),
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

    bool getEditable(FormStatus loadingStatus) {
      if (loadingStatus.isRequestSuccess) {
        return true;
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
      final Setting18CCorNodeThresholdState setting18thresholdState =
          context.watch<Setting18CCorNodeThresholdBloc>().state;

      bool editable = getEditable(homeState.loadingStatus);
      return editable
          ? getEditTools(
              editMode: setting18thresholdState.editMode,
              enableSubmission: setting18thresholdState.enableSubmission,
            )
          : Container();
    });
  }
}
