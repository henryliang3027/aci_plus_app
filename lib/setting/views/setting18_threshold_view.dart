import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/custom_icons/custom_icons_icons.dart';
import 'package:dsim_app/core/custom_style.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:dsim_app/setting/bloc/setting18_threshold/setting18_threshold_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    HomeState homeState = context.read<HomeBloc>().state;
    String minTemperature =
        homeState.characteristicData[DataKey.minTemperatureC] ?? '';
    String maxTemperature =
        homeState.characteristicData[DataKey.maxTemperatureC] ?? '';
    String minVoltage = homeState.characteristicData[DataKey.minVoltage] ?? '';
    String maxVoltage = homeState.characteristicData[DataKey.maxVoltage] ?? '';

    context.read<Setting18ThresholdBloc>().add(Initialized(
          enableTemperatureAlarm: false,
          minTemperature: minTemperature,
          maxTemperature: maxTemperature,
          enableVoltageAlarm: false,
          minVoltage: minVoltage,
          maxVoltage: maxVoltage,
          enableRFInputPowerAlarm: false,
          enableRFOutputPowerAlarm: false,
          enablePilotFrequency1Alarm: false,
          enablePilotFrequency2Alarm: false,
          enableFirstChannelOutputLevelAlarm: false,
          enableLastChannelOutputLevelAlarm: false,
        ));

    Future<void> showInProgressDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context).dialogTitleProcessing,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: const <Widget>[
              CircularProgressIndicator(),
            ],
          );
        },
      );
    }

    Future<void> showResultDialog(List<Widget> messageRows) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            titlePadding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 0.0),
            buttonPadding: const EdgeInsets.all(0.0),
            actionsPadding: const EdgeInsets.all(16.0),
            title: Text(
              AppLocalizations.of(context).dialogTitleSettingResult,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: messageRows,
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

    return BlocListener<Setting18ThresholdBloc, Setting18ThresholdState>(
      listener: (context, state) async {
        if (state.submissionStatus.isSubmissionInProgress) {
          await showInProgressDialog();
        } else if (state.submissionStatus.isSubmissionSuccess) {
          if (ModalRoute.of(context)?.isCurrent != true) {
            Navigator.of(context).pop();
          }
        } else {}
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
                        minTemperatureTextEditingController
                          ..text = minTemperature,
                    maxTemperatureTextEditingController:
                        maxTemperatureTextEditingController
                          ..text = maxTemperature,
                  ),
                  _VoltageAlarmControl(
                    minVoltageTextEditingController:
                        minVoltageTextEditingController..text = minVoltage,
                    maxVoltageTextEditingController:
                        maxVoltageTextEditingController..text = maxVoltage,
                  ),
                  const _RFInputPowerAlarmControl(),
                  const _RFOutputPowerAlarmControl(),
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
                      value: state.enableTemperatureAlarm,
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
                        label:
                            Text(AppLocalizations.of(context).minTemperature),
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
                        label:
                            Text(AppLocalizations.of(context).maxTemperature),
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
                      AppLocalizations.of(context).voltageLevel,
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
                      value: state.enableVoltageAlarm,
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
            Row(
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
                          borderRadius: BorderRadius.all(Radius.circular(4.0))),
                      contentPadding: EdgeInsets.all(8.0),
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      counterText: '',
                    ),
                  ),
                ),
                SizedBox(
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
            SizedBox(
              height: 40,
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

class _RFInputPowerAlarmControl extends StatelessWidget {
  const _RFInputPowerAlarmControl({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ThresholdBloc, Setting18ThresholdState>(
        builder: (context, state) {
      return controlParameterSwitch(
        context: context,
        editMode: state.editMode,
        title: AppLocalizations.of(context).rfInputPower,
        value: state.enableRFInputPowerAlarm,
        onChanged: (bool value) {
          context
              .read<Setting18ThresholdBloc>()
              .add(RFInputPowerAlarmChanged(value));
        },
      );
    });
  }
}

class _RFOutputPowerAlarmControl extends StatelessWidget {
  const _RFOutputPowerAlarmControl({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ThresholdBloc, Setting18ThresholdState>(
      builder: (context, state) {
        return controlParameterSwitch(
          context: context,
          editMode: state.editMode,
          title: AppLocalizations.of(context).rfOutputPower,
          value: state.enableRFOutputPowerAlarm,
          onChanged: (bool value) {
            context
                .read<Setting18ThresholdBloc>()
                .add(RFOutputPowerAlarmChanged(value));
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
          value: state.enablePilotFrequency1Alarm,
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
          value: state.enablePilotFrequency2Alarm,
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
          editMode: state.editMode,
          title: AppLocalizations.of(context).firstChannelOutputLevel,
          value: state.enableFirstChannelOutputLevelAlarm,
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
          editMode: state.editMode,
          title: AppLocalizations.of(context).lastChannelOutputLevel,
          value: state.enableLastChannelOutputLevelAlarm,
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

                    // 重新載入初始設定值
                    // context
                    //     .read<SettingListViewBloc>()
                    //     .add(const Initialized(true));
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
