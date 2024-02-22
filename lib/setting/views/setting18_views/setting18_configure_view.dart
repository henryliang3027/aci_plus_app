import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/message_localization.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:aci_plus_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18_configure/setting18_configure_bloc.dart';
import 'package:aci_plus_app/setting/model/confirm_input_dialog.dart';
import 'package:aci_plus_app/setting/model/setting_wisgets.dart';
import 'package:aci_plus_app/setting/views/custom_setting_dialog.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_graph_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18ConfigureView extends StatelessWidget {
  Setting18ConfigureView({super.key});

  final TextEditingController locationTextEditingController =
      TextEditingController();
  final TextEditingController coordinateTextEditingController =
      TextEditingController();
  final TextEditingController
      firstChannelLoadingFrequencyTextEditingController =
      TextEditingController();
  final TextEditingController firstChannelLoadingLevelTextEditingController =
      TextEditingController();
  final TextEditingController lastChannelLoadingFrequencyTextEditingController =
      TextEditingController();
  final TextEditingController lastChannelLoadingLevelTextEditingController =
      TextEditingController();
  final TextEditingController pilotFrequency1TextEditingController =
      TextEditingController();
  final TextEditingController pilotFrequency2TextEditingController =
      TextEditingController();
  final TextEditingController
      manualModePilot1RFOutputPowerTextEditingController =
      TextEditingController();
  final TextEditingController
      manualModePilot2RFOutputPowerTextEditingController =
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
      if (item == DataKey.location.name) {
        return AppLocalizations.of(context)!.dialogMessageLocationSetting;
      } else if (item == DataKey.coordinates.name) {
        return AppLocalizations.of(context)!.dialogMessageCoordinatesSetting;
      } else if (item == DataKey.splitOption.name) {
        return AppLocalizations.of(context)!.dialogMessageSplitOptionSetting;
      } else if (item == DataKey.firstChannelLoadingFrequency.name) {
        return AppLocalizations.of(context)!
            .dialogMessageFirstChannelLoadingFrequencySetting;
      } else if (item == DataKey.firstChannelLoadingLevel.name) {
        return AppLocalizations.of(context)!
            .dialogMessageFirstChannelLoadingLevelSetting;
      } else if (item == DataKey.lastChannelLoadingFrequency.name) {
        return AppLocalizations.of(context)!
            .dialogMessageLastChannelLoadingFrequencySetting;
      } else if (item == DataKey.lastChannelLoadingLevel.name) {
        return AppLocalizations.of(context)!
            .dialogMessageLastChannelLoadingLevelSetting;
      } else if (item == DataKey.pilotFrequencyMode.name) {
        return AppLocalizations.of(context)!
            .dialogMessagePilotFrequencyModeSetting;
      } else if (item == DataKey.pilotFrequency1.name) {
        return AppLocalizations.of(context)!
            .dialogMessagePilotFrequency1Setting;
      } else if (item == DataKey.pilotFrequency2.name) {
        return AppLocalizations.of(context)!
            .dialogMessagePilotFrequency2Setting;
      } else if (item == DataKey.agcMode.name) {
        return AppLocalizations.of(context)!.dialogMessageAGCModeSetting;
      } else if (item == DataKey.alcMode.name) {
        return AppLocalizations.of(context)!.dialogMessageALCModeSetting;
      } else if (item == DataKey.logInterval.name) {
        return AppLocalizations.of(context)!.dialogMessageLogIntervalSetting;
      } else if (item == DataKey.tgcCableLength.name) {
        return AppLocalizations.of(context)!.dialogMessageTGCCableLengthSetting;
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

    Future<void> showFailureDialog(String msg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.dialogTitleError,
              style: const TextStyle(
                color: CustomStyle.customRed,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    getMessageLocalization(
                      msg: msg,
                      context: context,
                    ),
                  ),
                ],
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

    List<Widget> getConfigurationParameterWidgetsByPartId(String partId) {
      Map<Enum, bool> itemsMap = SettingItemTable.itemsMap[partId] ?? {};
      List<Widget> widgets = [];

      List<Enum> enabledItems =
          itemsMap.keys.where((key) => itemsMap[key] == true).toList();

      enabledItems = enabledItems
          .where((item) => item.runtimeType == SettingConfiruration)
          .toList();

      for (Enum name in enabledItems) {
        switch (name) {
          case SettingConfiruration.location:
            widgets.add(_Location(
              textEditingController: locationTextEditingController,
            ));
            break;
          case SettingConfiruration.coordinates:
            widgets.add(_Coordinates(
              textEditingController: coordinateTextEditingController,
            ));
            break;
          case SettingConfiruration.splitOptions:
            widgets.add(const _SplitOption());
            break;
          case SettingConfiruration.pilotFrequencySelect:
            widgets.add(const _PilotFrequencyMode());
            break;
          case SettingConfiruration.startFrequency:
            widgets.add(_FirstChannelLoading(
              firstChannelLoadingFrequencyTextEditingController:
                  firstChannelLoadingFrequencyTextEditingController,
              firstChannelLoadingLevelTextEditingController:
                  firstChannelLoadingLevelTextEditingController,
              currentDetectedSplitOption: currentDetectedSplitOption,
            ));
            break;
          case SettingConfiruration.stopFrequency:
            widgets.add(_LastChannelLoading(
              lastChannelLoadingFrequencyTextEditingController:
                  lastChannelLoadingFrequencyTextEditingController,
              lastChannelLoadingLevelTextEditingController:
                  lastChannelLoadingLevelTextEditingController,
            ));
            break;
          case SettingConfiruration.pilot1:
            widgets.add(_PilotFrequency1(
              pilotFrequency1TextEditingController:
                  pilotFrequency1TextEditingController,
              manualModePilot1RFOutputPowerTextEditingController:
                  manualModePilot1RFOutputPowerTextEditingController,
            ));
            break;
          case SettingConfiruration.pilot2:
            widgets.add(_PilotFrequency2(
              pilotFrequency2TextEditingController:
                  pilotFrequency2TextEditingController,
              manualModePilot2RFOutputPowerTextEditingController:
                  manualModePilot2RFOutputPowerTextEditingController,
            ));
            break;
          case SettingConfiruration.agcMode:
            widgets.add(const _FwdAGCMode());
            break;
          case SettingConfiruration.alcMode:
            widgets.add(const _AutoLevelControl());
            break;
          case SettingConfiruration.logInterval:
            widgets.add(const _LogInterval());
            break;
          case SettingConfiruration.cableLength:
            // widgets.add(const _TGCCableLength());
            break;
        }
      }
      return widgets.isNotEmpty
          ? widgets
          : [
              _Location(
                textEditingController: locationTextEditingController,
              ),
              _Coordinates(
                textEditingController: coordinateTextEditingController,
              ),
              const _SplitOption(),
              const _PilotFrequencyMode(),
              _FirstChannelLoading(
                firstChannelLoadingFrequencyTextEditingController:
                    firstChannelLoadingFrequencyTextEditingController,
                firstChannelLoadingLevelTextEditingController:
                    firstChannelLoadingLevelTextEditingController,
                currentDetectedSplitOption: '0', // null
              ),
              _LastChannelLoading(
                lastChannelLoadingFrequencyTextEditingController:
                    lastChannelLoadingFrequencyTextEditingController,
                lastChannelLoadingLevelTextEditingController:
                    lastChannelLoadingLevelTextEditingController,
              ),
              _PilotFrequency1(
                pilotFrequency1TextEditingController:
                    pilotFrequency1TextEditingController,
                manualModePilot1RFOutputPowerTextEditingController:
                    manualModePilot1RFOutputPowerTextEditingController,
              ),
              _PilotFrequency2(
                pilotFrequency2TextEditingController:
                    pilotFrequency2TextEditingController,
                manualModePilot2RFOutputPowerTextEditingController:
                    manualModePilot2RFOutputPowerTextEditingController,
              ),
              const _FwdAGCMode(),
              const _AutoLevelControl(),
              const _LogInterval(),
              // const _TGCCableLength(),
            ];
    }

    Widget buildConfigurationWidget(String partId) {
      List<Widget> configurationParameters =
          getConfigurationParameterWidgetsByPartId(partId);

      return Column(
        children: [
          ...configurationParameters,
          const SizedBox(
            height: 120,
          ),
        ],
      );
    }

    return BlocListener<Setting18ConfigureBloc, Setting18ConfigureState>(
      listener: (context, state) async {
        if (state.submissionStatus.isSubmissionInProgress) {
          await showInProgressDialog(context);
        } else if (state.submissionStatus.isSubmissionSuccess) {
          Navigator.of(context).pop();
          List<Widget> rows = getMessageRows(state.settingResult);
          showResultDialog(
            context: context,
            messageRows: rows,
          );
          context.read<Setting18ConfigureBloc>().add(const Initialized());
        } else if (state.gpsStatus.isRequestFailure) {
          showFailureDialog(
            getMessageLocalization(
                msg: state.gpsCoordinateErrorMessage, context: context),
          );
        } else if (state.gpsStatus.isRequestSuccess) {
          coordinateTextEditingController.text = state.coordinates;
        }

        if (state.isInitialize) {
          locationTextEditingController.text = state.location;
          coordinateTextEditingController.text = state.coordinates;
          firstChannelLoadingFrequencyTextEditingController.text =
              state.firstChannelLoadingFrequency.value;
          firstChannelLoadingLevelTextEditingController.text =
              state.firstChannelLoadingLevel.value;
          lastChannelLoadingFrequencyTextEditingController.text =
              state.lastChannelLoadingFrequency.value;
          lastChannelLoadingLevelTextEditingController.text =
              state.lastChannelLoadingLevel.value;
          pilotFrequency1TextEditingController.text =
              state.pilotFrequency1.value;
          pilotFrequency2TextEditingController.text =
              state.pilotFrequency2.value;
          manualModePilot1RFOutputPowerTextEditingController.text =
              state.manualModePilot1RFOutputPower;
          manualModePilot2RFOutputPowerTextEditingController.text =
              state.manualModePilot2RFOutputPower;
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: buildConfigurationWidget(partId),
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

class _Location extends StatelessWidget {
  const _Location({
    super.key,
    required this.textEditingController,
  });

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ConfigureBloc, Setting18ConfigureState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 40.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: CustomStyle.sizeL,
                ),
                child: Text(
                  '${AppLocalizations.of(context)!.location}:',
                  style: const TextStyle(
                    fontSize: CustomStyle.sizeXL,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextField(
                controller: textEditingController,
                key: const Key('setting18Form_locationInput_textField'),
                style: const TextStyle(
                  fontSize: CustomStyle.sizeXL,
                ),
                enabled: state.editMode,
                textInputAction: TextInputAction.done,
                onChanged: (location) {
                  context
                      .read<Setting18ConfigureBloc>()
                      .add(LocationChanged(location));
                },
                maxLength: 48,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  contentPadding: EdgeInsets.all(10.0),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  counterText: '',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Coordinates extends StatelessWidget {
  const _Coordinates({
    super.key,
    required this.textEditingController,
  });

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ConfigureBloc, Setting18ConfigureState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 40.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: CustomStyle.sizeL,
                ),
                child: Text(
                  '${AppLocalizations.of(context)!.coordinates}:',
                  style: const TextStyle(
                    fontSize: CustomStyle.sizeXL,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextField(
                controller: textEditingController,
                key: const Key('setting18Form_coordinatesInput_textField'),
                style: const TextStyle(
                  fontSize: CustomStyle.sizeXL,
                ),
                enabled: state.editMode,
                textInputAction: TextInputAction.done,
                onChanged: (coordinate) {
                  context
                      .read<Setting18ConfigureBloc>()
                      .add(CoordinatesChanged(coordinate));
                },
                maxLength: 39,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  counterText: '',
                  suffixIconConstraints: const BoxConstraints(
                    maxHeight: 48,
                    maxWidth: 56,
                    minHeight: 48,
                    minWidth: 56,
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Material(
                      // elevation: 5.0,
                      color: state.editMode
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.inversePrimary,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(4.0),
                              bottomRight: Radius.circular(4.0))),
                      // shadowColor: Colors.green,
                      child: state.gpsStatus.isRequestInProgress
                          ? Padding(
                              padding: const EdgeInsets.all(10),
                              child: CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            )
                          : IconButton(
                              iconSize: 26,
                              icon: Icon(
                                Icons.pin_drop,
                                color: Theme.of(context).colorScheme.onPrimary,
                                // size: 22,
                              ),
                              onPressed: state.editMode
                                  ? () {
                                      context
                                          .read<Setting18ConfigureBloc>()
                                          .add(const GPSCoordinatesRequested());
                                    }
                                  : null,
                            ),
                    ),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SplitOption extends StatelessWidget {
  const _SplitOption({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ConfigureBloc, Setting18ConfigureState>(
      buildWhen: (previous, current) =>
          previous.splitOption != current.splitOption ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return splitOptionGridViewButton(
          context: context,
          editMode: state.editMode,
          splitOption: state.splitOption,
          onGridPressed: (index) => context
              .read<Setting18ConfigureBloc>()
              .add(SplitOptionChanged(splitOptionValues[index])),
        );
      },
    );
  }
}

class _PilotFrequencyMode extends StatelessWidget {
  const _PilotFrequencyMode({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<String> pilotFrequencyModeTexts = [
      AppLocalizations.of(context)!.pilotFrequencyBandwidthSettings,
      AppLocalizations.of(context)!.pilotFrequencyUserSettings,
      //  AppLocalizations.of(context)!.pilotFrequencySmartSettings,
    ];

    return BlocBuilder<Setting18ConfigureBloc, Setting18ConfigureState>(
      buildWhen: (previous, current) =>
          previous.pilotFrequencyMode != current.pilotFrequencyMode ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return gridViewButton(
          context: context,
          crossAxisCount: 1,
          texts: pilotFrequencyModeTexts,
          values: pilotFrequencyModeValues,
          editMode: state.editMode,
          pilotFrequencyMode: state.pilotFrequencyMode,
          onGridPressed: (index) => context
              .read<Setting18ConfigureBloc>()
              .add(PilotFrequencyModeChanged(pilotFrequencyModeValues[index])),
        );
      },
    );
  }
}

class _FirstChannelLoading extends StatelessWidget {
  const _FirstChannelLoading({
    super.key,
    required this.firstChannelLoadingFrequencyTextEditingController,
    required this.firstChannelLoadingLevelTextEditingController,
    required this.currentDetectedSplitOption,
  });

  final TextEditingController firstChannelLoadingFrequencyTextEditingController;
  final TextEditingController firstChannelLoadingLevelTextEditingController;
  final String currentDetectedSplitOption;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ConfigureBloc, Setting18ConfigureState>(
      builder: (context, state) {
        return twoTextField(
          context: context,
          title: '${AppLocalizations.of(context)!.startFrequency}:',
          editMode1: state.editMode && state.pilotFrequencyMode != '2',
          editMode2: state.editMode && state.pilotFrequencyMode != '2',
          textEditingControllerName1:
              'setting18Form_firstChannelLoadingFrequencyInput_textField',
          textEditingControllerName2:
              'setting18Form_firstChannelLoadingLevelInput_textField',
          textEditingController1:
              firstChannelLoadingFrequencyTextEditingController,
          textEditingController2: firstChannelLoadingLevelTextEditingController,
          onChanged1: (firstChannelLoadingFrequency) {
            context
                .read<Setting18ConfigureBloc>()
                .add(FirstChannelLoadingFrequencyChanged(
                  firstChannelLoadingFrequency: firstChannelLoadingFrequency,
                  currentDetectedSplitOption: currentDetectedSplitOption,
                ));
          },
          onChanged2: (firstChannelLoadingLevel) {
            context
                .read<Setting18ConfigureBloc>()
                .add(FirstChannelLoadingLevelChanged(firstChannelLoadingLevel));
          },
          errorText1: !isValidFirstChannelLoadingFrequency(
            currentDetectedSplitOption: currentDetectedSplitOption,
            firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
          )
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          errorText2: state.firstChannelLoadingLevel.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
        );
      },
    );
  }
}

class _LastChannelLoading extends StatelessWidget {
  const _LastChannelLoading({
    super.key,
    required this.lastChannelLoadingFrequencyTextEditingController,
    required this.lastChannelLoadingLevelTextEditingController,
  });

  final TextEditingController lastChannelLoadingFrequencyTextEditingController;
  final TextEditingController lastChannelLoadingLevelTextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ConfigureBloc, Setting18ConfigureState>(
      builder: (context, state) {
        return twoTextField(
          context: context,
          title: '${AppLocalizations.of(context)!.stopFrequency}:',
          editMode1: state.editMode && state.pilotFrequencyMode != '2',
          editMode2: state.editMode && state.pilotFrequencyMode != '2',
          textEditingControllerName1:
              'setting18Form_lastChannelLoadingFrequencyInput_textField',
          textEditingControllerName2:
              'setting18Form_lastChannelLoadingLevelInput_textField',
          textEditingController1:
              lastChannelLoadingFrequencyTextEditingController,
          textEditingController2: lastChannelLoadingLevelTextEditingController,
          onChanged1: (lastChannelLoadingFrequency) {
            context.read<Setting18ConfigureBloc>().add(
                LastChannelLoadingFrequencyChanged(
                    lastChannelLoadingFrequency));
          },
          onChanged2: (lastChannelLoadingLevel) {
            context
                .read<Setting18ConfigureBloc>()
                .add(LastChannelLoadingLevelChanged(lastChannelLoadingLevel));
          },
          errorText1: state.lastChannelLoadingFrequency.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          errorText2: state.lastChannelLoadingLevel.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
        );
      },
    );
  }
}

class _PilotFrequency1 extends StatelessWidget {
  const _PilotFrequency1({
    super.key,
    required this.pilotFrequency1TextEditingController,
    required this.manualModePilot1RFOutputPowerTextEditingController,
  });

  final TextEditingController pilotFrequency1TextEditingController;
  final TextEditingController
      manualModePilot1RFOutputPowerTextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ConfigureBloc, Setting18ConfigureState>(
      builder: (context, state) {
        return twoTextField(
          context: context,
          title: '${AppLocalizations.of(context)!.pilotFrequency1}:',
          editMode1: state.editMode && state.pilotFrequencyMode == '1',
          editMode2: false,
          textEditingControllerName1:
              'setting18Form_pilotFrequency1Input_textField',
          textEditingControllerName2:
              'setting18Form_manualModePilot1RFOutputPowerInput_textField',
          textEditingController1: pilotFrequency1TextEditingController,
          textEditingController2:
              manualModePilot1RFOutputPowerTextEditingController,
          onChanged1: (frequency) {
            context
                .read<Setting18ConfigureBloc>()
                .add(PilotFrequency1Changed(frequency));
          },
          onChanged2: (_) {},
          errorText1: state.pilotFrequency1.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
        );
      },
    );
  }
}

class _PilotFrequency2 extends StatelessWidget {
  const _PilotFrequency2({
    super.key,
    required this.pilotFrequency2TextEditingController,
    required this.manualModePilot2RFOutputPowerTextEditingController,
  });

  final TextEditingController pilotFrequency2TextEditingController;
  final TextEditingController
      manualModePilot2RFOutputPowerTextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ConfigureBloc, Setting18ConfigureState>(
      builder: (context, state) {
        return twoTextField(
          context: context,
          title: '${AppLocalizations.of(context)!.pilotFrequency2}:',
          editMode1: state.editMode && state.pilotFrequencyMode == '1',
          editMode2: false,
          textEditingControllerName1:
              'setting18Form_pilotFrequency2Input_textField',
          textEditingControllerName2:
              'setting18Form_manualModePilot2RFOutputPowerInput_textField',
          textEditingController1: pilotFrequency2TextEditingController,
          textEditingController2:
              manualModePilot2RFOutputPowerTextEditingController,
          onChanged1: (frequency) {
            context
                .read<Setting18ConfigureBloc>()
                .add(PilotFrequency2Changed(frequency));
          },
          onChanged2: (_) {},
          errorText1: state.pilotFrequency2.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
        );
      },
    );
  }
}

class _FwdAGCMode extends StatelessWidget {
  const _FwdAGCMode({
    super.key,
  });

  final List<String> fwdAGCModeValues = const [
    '1',
    '0',
  ];

  List<bool> getSelectionState(String selectedFwdAGCMode) {
    Map<String, bool> fwdAGCModeMap = {
      '1': false,
      '0': false,
    };

    if (fwdAGCModeMap.containsKey(selectedFwdAGCMode)) {
      fwdAGCModeMap[selectedFwdAGCMode] = true;
    }

    return fwdAGCModeMap.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ConfigureBloc, Setting18ConfigureState>(
      buildWhen: (previous, current) =>
          previous.fwdAGCMode != current.fwdAGCMode ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 40.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: CustomStyle.sizeL,
                ),
                child: Text(
                  '${AppLocalizations.of(context)!.agcMode}:',
                  style: const TextStyle(
                    fontSize: CustomStyle.sizeXL,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) => ToggleButtons(
                  direction: Axis.horizontal,
                  onPressed: (int index) {
                    if (state.editMode) {
                      context
                          .read<Setting18ConfigureBloc>()
                          .add(FwdAGCModeChanged(fwdAGCModeValues[index]));
                    }
                  },
                  textStyle: const TextStyle(fontSize: 18.0),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: state.editMode
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context)
                          .colorScheme
                          .inversePrimary, // indigo border color
                  selectedColor: Theme.of(context)
                      .colorScheme
                      .onPrimary, // white text color

                  fillColor: state.editMode
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context)
                          .colorScheme
                          .inversePrimary, // selected
                  color:
                      Theme.of(context).colorScheme.secondary, // not selected
                  constraints: BoxConstraints.expand(
                    width: (constraints.maxWidth - 4) / fwdAGCModeValues.length,
                  ),
                  isSelected: getSelectionState(state.fwdAGCMode),
                  children: <Widget>[
                    Text(AppLocalizations.of(context)!.on),
                    Text(AppLocalizations.of(context)!.off),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AutoLevelControl extends StatelessWidget {
  const _AutoLevelControl({
    super.key,
  });

  final List<String> autoLevelControlValues = const [
    '1',
    '0',
  ];

  List<bool> getSelectionState(String selectedAutoLevelControl) {
    Map<String, bool> autoLevelControlMap = {
      '1': false,
      '0': false,
    };

    if (autoLevelControlMap.containsKey(selectedAutoLevelControl)) {
      autoLevelControlMap[selectedAutoLevelControl] = true;
    }

    return autoLevelControlMap.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ConfigureBloc, Setting18ConfigureState>(
      buildWhen: (previous, current) =>
          previous.autoLevelControl != current.autoLevelControl ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 40.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: CustomStyle.sizeL,
                ),
                child: Text(
                  '${AppLocalizations.of(context)!.alcMode}:',
                  style: const TextStyle(
                    fontSize: CustomStyle.sizeXL,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) => ToggleButtons(
                  direction: Axis.horizontal,
                  onPressed: (int index) {
                    if (state.editMode) {
                      context.read<Setting18ConfigureBloc>().add(
                          AutoLevelControlChanged(
                              autoLevelControlValues[index]));
                    }
                  },
                  textStyle: const TextStyle(fontSize: 18.0),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: state.editMode
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context)
                          .colorScheme
                          .inversePrimary, // indigo border color
                  selectedColor: Theme.of(context)
                      .colorScheme
                      .onPrimary, // white text color

                  fillColor: state.editMode
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context)
                          .colorScheme
                          .inversePrimary, // selected
                  color:
                      Theme.of(context).colorScheme.secondary, // not selected
                  constraints: BoxConstraints.expand(
                    width: (constraints.maxWidth - 4) /
                        autoLevelControlValues.length,
                  ),
                  isSelected: getSelectionState(state.autoLevelControl),
                  children: <Widget>[
                    Text(AppLocalizations.of(context)!.on),
                    Text(AppLocalizations.of(context)!.off),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LogInterval extends StatelessWidget {
  const _LogInterval({super.key});

  @override
  Widget build(BuildContext context) {
    double getValue(String logInterval) {
      if (logInterval.isNotEmpty) {
        return double.parse(logInterval);
      } else {
        return 1.0;
      }
    }

    return BlocBuilder<Setting18ConfigureBloc, Setting18ConfigureState>(
      buildWhen: (previous, current) =>
          previous.logInterval != current.logInterval ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 30.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: CustomStyle.sizeL,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${AppLocalizations.of(context)!.logInterval}: ${state.logInterval} ${AppLocalizations.of(context)!.minute}',
                        style: const TextStyle(
                          fontSize: CustomStyle.sizeXL,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    2,
                    (index) => Column(
                      children: [
                        Container(
                          alignment: Alignment.bottomCenter,
                          height: 22,
                          child: Text(
                            '${(List.from([1, 60])[index]).toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: CustomStyle.sizeM,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          height: 16,
                          child: VerticalDivider(
                            indent: 0,
                            thickness: 1.2,
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliderTheme(
                data: const SliderThemeData(
                  valueIndicatorColor: Colors.red,
                  showValueIndicator: ShowValueIndicator.always,
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 18),
                ),
                child: Slider(
                  min: 1.0,
                  max: 60.0,
                  divisions: 60,
                  value: getValue(state.logInterval),
                  onChanged: state.editMode
                      ? (double logInterval) {
                          context.read<Setting18ConfigureBloc>().add(
                              LogIntervalChanged(
                                  logInterval.toStringAsFixed(0)));
                        }
                      : null,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton.filled(
                    visualDensity: const VisualDensity(horizontal: -4.0),
                    icon: const Icon(
                      Icons.remove,
                    ),
                    onPressed: state.editMode
                        ? () {
                            context
                                .read<Setting18ConfigureBloc>()
                                .add(const LogIntervalDecreased());
                          }
                        : null,
                  ),
                  IconButton.filled(
                    visualDensity: const VisualDensity(horizontal: -4.0),
                    icon: const Icon(
                      Icons.add,
                    ),
                    onPressed: state.editMode
                        ? () {
                            context
                                .read<Setting18ConfigureBloc>()
                                .add(const LogIntervalIncreased());
                          }
                        : null,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TGCCableLength extends StatelessWidget {
  const _TGCCableLength({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> tgcCableLengthValues = [
      '9',
      '18',
      '27',
    ];

    return BlocBuilder<Setting18ConfigureBloc, Setting18ConfigureState>(
      buildWhen: (previous, current) =>
          previous.tgcCableLength != current.tgcCableLength ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return controlToggleButton(
          context: context,
          editMode: state.editMode,
          title: '${AppLocalizations.of(context)!.tgcCableLength}:',
          currentValue: state.tgcCableLength,
          onChanged: (int index) {
            context
                .read<Setting18ConfigureBloc>()
                .add(TGCCableLengthChanged(tgcCableLengthValues[index]));
          },
          values: tgcCableLengthValues,
          texts: [
            '9',
            '18',
            '27',
          ],
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
                        .read<Setting18ConfigureBloc>()
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
                                .read<Setting18ConfigureBloc>()
                                .add(const SettingSubmitted());
                          } else {
                            bool? isMatch =
                                await showConfirmInputDialog(context: context);

                            if (context.mounted) {
                              if (isMatch != null) {
                                if (isMatch) {
                                  context
                                      .read<Setting18ConfigureBloc>()
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
                                  .read<Setting18ConfigureBloc>()
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
                        .read<Setting18ConfigureBloc>()
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
      final Setting18ConfigureState setting18ConfigureState =
          context.watch<Setting18ConfigureBloc>().state;

      bool editable = getEditable(
        loadingStatus: homeState.loadingStatus,
      );
      return editable
          ? getEditTools(
              editMode: setting18ConfigureState.editMode,
              enableSubmission: setting18ConfigureState.enableSubmission,
            )
          : Container();
    });
  }
}
