import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/custom_icons/custom_icons_icons.dart';
import 'package:dsim_app/core/custom_style.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:dsim_app/repositories/unit_repository.dart';
import 'package:dsim_app/setting/bloc/setting18_threshold/setting18_threshold_bloc.dart';
import 'package:dsim_app/setting/views/custom_setting_dialog.dart';
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

  final TextEditingController minVoltageRippleTextEditingController =
      TextEditingController();
  final TextEditingController maxVoltageRippleTextEditingController =
      TextEditingController();

  final TextEditingController minRFOutputPowerTextEditingController =
      TextEditingController();
  final TextEditingController maxRFOutputPowerTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    HomeState homeState = context.watch<HomeBloc>().state;
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
    String minVoltageRipple =
        homeState.characteristicData[DataKey.minVoltageRipple] ?? '';
    String maxVoltageRipple =
        homeState.characteristicData[DataKey.maxVoltageRipple] ?? '';
    String minRFOutputPower =
        homeState.characteristicData[DataKey.minRFOutputPower] ?? '';
    String maxRFOutputPower =
        homeState.characteristicData[DataKey.maxRFOutputPower] ?? '';

    String strTemperatureAlarmState =
        homeState.characteristicData[DataKey.temperatureAlarmState] ?? '';
    bool temperatureAlarmState = strTemperatureAlarmState == '1' ? false : true;
    String strVoltageAlarmState =
        homeState.characteristicData[DataKey.voltageAlarmState] ?? '';
    bool voltageAlarmState = strVoltageAlarmState == '1' ? false : true;
    String strVoltageRippleAlarmState =
        homeState.characteristicData[DataKey.voltageRippleAlarmState] ?? '';
    bool voltageRippleAlarmState =
        strVoltageRippleAlarmState == '1' ? false : true;
    String strRFOutputPowerAlarmState =
        homeState.characteristicData[DataKey.rfOutputPowerAlarmState] ?? '';
    bool rfOutputPowerAlarmState =
        strRFOutputPowerAlarmState == '1' ? false : true;
    String strSplitOptionAlarmState =
        homeState.characteristicData[DataKey.splitOptionAlarmState] ?? '';
    bool splitOptionAlarmState = strSplitOptionAlarmState == '1' ? false : true;

    String strPilotFrequency1AlarmState =
        homeState.characteristicData[DataKey.pilotFrequency1AlarmState] ?? '';
    bool pilotFrequency1AlarmState =
        strPilotFrequency1AlarmState == '1' ? false : true;
    String strPilotFrequency2AlarmState =
        homeState.characteristicData[DataKey.pilotFrequency2AlarmState] ?? '';
    bool pilotFrequency2AlarmState =
        strPilotFrequency2AlarmState == '1' ? false : true;

    context.read<Setting18ThresholdBloc>().add(Initialized(
          temperatureAlarmState: temperatureAlarmState,
          minTemperature: minTemperature,
          maxTemperature: maxTemperature,
          minTemperatureF: minTemperatureF,
          maxTemperatureF: maxTemperatureF,
          voltageAlarmState: voltageAlarmState,
          minVoltage: minVoltage,
          maxVoltage: maxVoltage,
          voltageRippleAlarmState: voltageRippleAlarmState,
          minVoltageRipple: minVoltageRipple,
          maxVoltageRipple: maxVoltageRipple,
          rfOutputPowerAlarmState: rfOutputPowerAlarmState,
          minRFOutputPower: minRFOutputPower,
          maxRFOutputPower: maxRFOutputPower,
          splitOptionAlarmState: splitOptionAlarmState,
          pilotFrequency1AlarmState: pilotFrequency1AlarmState,
          pilotFrequency2AlarmState: pilotFrequency2AlarmState,
          firstChannelOutputLevelAlarmState: false,
          lastChannelOutputLevelAlarmState: false,
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
      } else if (item == DataKey.maxVoltageRipple.name) {
        return AppLocalizations.of(context)
            .dialogMessageMaxVoltageRippleSetting;
      } else if (item == DataKey.minVoltageRipple.name) {
        return AppLocalizations.of(context)
            .dialogMessageMinVoltageRippleSetting;
      } else if (item == DataKey.maxRFOutputPower.name) {
        return AppLocalizations.of(context)
            .dialogMessageMaxRFOutputPowerSetting;
      } else if (item == DataKey.minRFOutputPower.name) {
        return AppLocalizations.of(context)
            .dialogMessageMinRFOutputPowerSetting;
      } else if (item == DataKey.temperatureAlarmState.name) {
        return AppLocalizations.of(context)
            .dialogMessageTemperatureAlarmStateSetting;
      } else if (item == DataKey.voltageAlarmState.name) {
        return AppLocalizations.of(context)
            .dialogMessageVoltageAlarmStateSetting;
      } else if (item == DataKey.voltageRippleAlarmState.name) {
        return AppLocalizations.of(context)
            .dialogMessageVoltageRippleAlarmStateSetting;
      } else if (item == DataKey.rfOutputPowerAlarmState.name) {
        return AppLocalizations.of(context)
            .dialogMessageRFOutputPowerAlarmStateSetting;
      } else if (item == DataKey.splitOptionAlarmState.name) {
        return AppLocalizations.of(context)
            .dialogMessageSplitOptionAlarmStateSetting;
      } else if (item == DataKey.pilotFrequency1AlarmState.name) {
        return AppLocalizations.of(context)
            .dialogMessagePilotFrequency1AlarmStateSetting;
      } else if (item == DataKey.pilotFrequency2AlarmState.name) {
        return AppLocalizations.of(context)
            .dialogMessagePilotFrequency2AlarmStateSetting;
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
            bottom: 8.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatResultItem(item),
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                formatResultValue(value),
                style: TextStyle(
                  fontSize: 16,
                  color: valueColor,
                ),
              )
            ],
          ),
        ));
      }
      return rows;
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
        }

        if (state.isInitialize) {
          minTemperatureTextEditingController.text = state.minTemperature;
          maxTemperatureTextEditingController.text = state.maxTemperature;
          minVoltageTextEditingController.text = state.minVoltage;
          maxVoltageTextEditingController.text = state.maxVoltage;
          minVoltageRippleTextEditingController.text = state.minVoltageRipple;
          maxVoltageRippleTextEditingController.text = state.maxVoltageRipple;
          minRFOutputPowerTextEditingController.text = state.minRFOutputPower;
          maxRFOutputPowerTextEditingController.text = state.maxRFOutputPower;
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(
                CustomStyle.sizeXL,
              ),
              child: Column(
                children: [
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
                    minVoltageRippleTextEditingController:
                        minVoltageRippleTextEditingController,
                    maxVoltageRippleTextEditingController:
                        maxVoltageRippleTextEditingController,
                  ),
                  _RFOutputPowerAlarmControl(
                    minRFOutputPowerTextEditingController:
                        minRFOutputPowerTextEditingController,
                    maxRFOutputPowerTextEditingController:
                        maxRFOutputPowerTextEditingController,
                  ),
                  _ClusterTitle(
                    title: AppLocalizations.of(context).forwardSetting,
                  ),
                  const _SplitOptionAlarmControl(),
                  const _PilotFrequency1AlarmControl(),
                  const _PilotFrequency2AlarmControl(),
                  const _FirstChannelOutputLevelAlarmControl(),
                  const _LastChannelOutputLevelAlarmControl(),
                  const SizedBox(
                    height: 120,
                  ),
                ],
              ),
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

    return BlocBuilder<Setting18ThresholdBloc, Setting18ThresholdState>(
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
                                  .read<Setting18ThresholdBloc>()
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
                            .read<Setting18ThresholdBloc>()
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
                            .read<Setting18ThresholdBloc>()
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
    return BlocBuilder<Setting18ThresholdBloc, Setting18ThresholdState>(
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
                                  .read<Setting18ThresholdBloc>()
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
                            .read<Setting18ThresholdBloc>()
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
                            .read<Setting18ThresholdBloc>()
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

class _VoltageRippleAlarmControl extends StatelessWidget {
  const _VoltageRippleAlarmControl({
    super.key,
    required this.minVoltageRippleTextEditingController,
    required this.maxVoltageRippleTextEditingController,
  });

  final TextEditingController minVoltageRippleTextEditingController;
  final TextEditingController maxVoltageRippleTextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ThresholdBloc, Setting18ThresholdState>(
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
                    child: Text(
                      '${AppLocalizations.of(context).voltageRipple} (${CustomStyle.milliVolt})',
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
                bottom: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                    child: TextField(
                      controller: minVoltageRippleTextEditingController,
                      key: const Key(
                          'setting18Form_minVoltageRippleInput_textField'),
                      style: const TextStyle(
                        fontSize: CustomStyle.sizeXL,
                      ),
                      enabled: state.editMode,
                      textInputAction: TextInputAction.done,
                      onChanged: (minVoltageRipple) {
                        context
                            .read<Setting18ThresholdBloc>()
                            .add(MinVoltageRippleChanged(minVoltageRipple));
                      },
                      maxLength: 40,
                      decoration: InputDecoration(
                        label:
                            Text(AppLocalizations.of(context).minVoltageRipple),
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
                        label:
                            Text(AppLocalizations.of(context).maxVoltageRipple),
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
                    child: Text(
                      '${AppLocalizations.of(context).rfOutputPower} (${CustomStyle.dBmV})',
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
                      value: state.rfOutputPowerAlarmState,
                      onChanged: state.editMode
                          ? (bool value) {
                              context
                                  .read<Setting18ThresholdBloc>()
                                  .add(RFOutputPowerAlarmChanged(value));
                            }
                          : null,
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
                    controller: minRFOutputPowerTextEditingController,
                    key: const Key('setting18Form_minRFOutputPower_textField'),
                    style: const TextStyle(
                      fontSize: CustomStyle.sizeXL,
                    ),
                    enabled: state.editMode,
                    textInputAction: TextInputAction.done,
                    onChanged: (minRFOutputPower) {
                      context
                          .read<Setting18ThresholdBloc>()
                          .add(MinRFOutputPowerChanged(minRFOutputPower));
                    },
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
                    controller: maxRFOutputPowerTextEditingController,
                    key: const Key('setting18Form_maxRFOutputPower_textField'),
                    style: const TextStyle(
                      fontSize: CustomStyle.sizeXL,
                    ),
                    enabled: state.editMode,
                    textInputAction: TextInputAction.done,
                    onChanged: (maxRFOutputPower) {
                      context
                          .read<Setting18ThresholdBloc>()
                          .add(MaxRFOutputPowerChanged(maxRFOutputPower));
                    },
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
    return BlocBuilder<Setting18ThresholdBloc, Setting18ThresholdState>(
      builder: (context, state) {
        return controlParameterSwitch(
          context: context,
          editMode: state.editMode,
          title: AppLocalizations.of(context).splitOption,
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

class _PilotFrequency1AlarmControl extends StatelessWidget {
  const _PilotFrequency1AlarmControl({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ThresholdBloc, Setting18ThresholdState>(
      builder: (context, state) {
        return controlParameterSwitch(
          context: context,
          editMode: state.editMode,
          title: AppLocalizations.of(context).pilotFrequency1Status,
          value: state.pilotFrequency1AlarmState,
          onChanged: (bool value) {
            context
                .read<Setting18ThresholdBloc>()
                .add(PilotFrequency1AlarmChanged(value));
          },
        );
      },
    );
  }
}

class _PilotFrequency2AlarmControl extends StatelessWidget {
  const _PilotFrequency2AlarmControl({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ThresholdBloc, Setting18ThresholdState>(
      builder: (context, state) {
        return controlParameterSwitch(
          context: context,
          editMode: state.editMode,
          title: AppLocalizations.of(context).pilotFrequency2Status,
          value: state.pilotFrequency2AlarmState,
          onChanged: (bool value) {
            context
                .read<Setting18ThresholdBloc>()
                .add(PilotFrequency2AlarmChanged(value));
          },
        );
      },
    );
  }
}

class _FirstChannelOutputLevelAlarmControl extends StatelessWidget {
  const _FirstChannelOutputLevelAlarmControl({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ThresholdBloc, Setting18ThresholdState>(
      builder: (context, state) {
        return controlParameterSwitch(
          context: context,
          editMode: false,
          title: AppLocalizations.of(context).startFrequencyLoading,
          value: state.firstChannelOutputLevelAlarmState,
          onChanged: (bool value) {
            context
                .read<Setting18ThresholdBloc>()
                .add(FirstChannelOutputLevelAlarmChanged(value));
          },
        );
      },
    );
  }
}

class _LastChannelOutputLevelAlarmControl extends StatelessWidget {
  const _LastChannelOutputLevelAlarmControl({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ThresholdBloc, Setting18ThresholdState>(
      builder: (context, state) {
        return controlParameterSwitch(
          context: context,
          editMode: false,
          title: AppLocalizations.of(context).stopFrequencyLoading,
          value: state.lastChannelOutputLevelAlarmState,
          onChanged: (bool value) {
            context
                .read<Setting18ThresholdBloc>()
                .add(LastChannelOutputLevelAlarmChanged(value));
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
                      ? () {
                          context
                              .read<Setting18ThresholdBloc>()
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
                        .read<Setting18ThresholdBloc>()
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
      final Setting18ThresholdState setting18thresholdState =
          context.watch<Setting18ThresholdBloc>().state;

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
