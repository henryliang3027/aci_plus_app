import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/message_localization.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18_regulation/setting18_regulation_bloc.dart';
import 'package:aci_plus_app/setting/model/card_color.dart';
import 'package:aci_plus_app/setting/model/confirm_input_dialog.dart';
import 'package:aci_plus_app/setting/model/custom_input.dart';
import 'package:aci_plus_app/setting/model/setting_widgets.dart';
import 'package:aci_plus_app/setting/shared/utils.dart';
import 'package:aci_plus_app/setting/views/custom_setting_dialog.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_graph_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18RegulationView extends StatelessWidget {
  Setting18RegulationView({super.key});

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
    // Setting18TabBarState setting18tabBarState =
    //     context.watch<Setting18TabBarBloc>().state;

    // print(
    //     'setting18 configure view ${setting18tabBarState.isForwardCEQIndexChanged}');
    // if (setting18tabBarState.isForwardCEQIndexChanged) {
    //   showCurrentForwardCEQChangedDialog(context).then((bool? isConfirm) {
    //     // 重新 Initialized, 讀取並顯示空值
    //     context
    //         .read<Setting18RegulationBloc>()
    //         .add(const Initialized(useCache: false));
    //   });
    // }

    HomeState homeState = context.watch<HomeBloc>().state;
    String partId = homeState.characteristicData[DataKey.partId] ?? '';
    String currentDetectedSplitOption =
        homeState.characteristicData[DataKey.currentDetectedSplitOption] ?? '0';

    if (homeState.connectionStatus.isRequestFailure) {
      // 重新 Initialized, 讀取並顯示空值
      context.read<Setting18RegulationBloc>().add(const Initialized());
    }

    // 當 emit 的內容有變時才會執行, 執行時判斷 ceq 是否有變, 如果沒有則代表其他內容有變,
    // 例如 ingress 有變則繼續判斷是否正在編輯模式, 如果不在編輯模式才更新
    if (homeState.ceqStatus != CEQStatus.none) {
      context.read<Setting18RegulationBloc>().add(const Initialized());
    } else {
      if (!context.read<Setting18RegulationBloc>().state.editMode) {
        context.read<Setting18RegulationBloc>().add(const Initialized());
      }
    }

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
      } else if (item == DataKey.rfOutputLogInterval.name) {
        return AppLocalizations.of(context)!
            .dialogMessageRFOutputLogIntervalSetting;
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
              ElevatedButton(
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
      List<Enum> items = SettingItemTable.itemsMap[partId] ?? [];
      List<Widget> widgets = [];

      items = items
          .where((item) => item.runtimeType == SettingConfiruration)
          .toList();

      for (Enum name in items) {
        switch (name) {
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
            widgets.add(const _AGCMode());
            break;
          // case SettingConfiruration.alcMode:
          //   widgets.add(const _ALCMode());
          //   break;
          case SettingConfiruration.logInterval:
            widgets.add(const _LogInterval());
            break;
          case SettingConfiruration.rfOutputLogInterval:
            widgets.add(const _RFOutputLogInterval());
            break;
          case SettingConfiruration.cableLength:
            // widgets.add(const _TGCCableLength());
            break;
        }
      }
      return widgets.isNotEmpty
          ? widgets
          : [
              // _Location(
              //   textEditingController: locationTextEditingController,
              // ),
              // _Coordinates(
              //   textEditingController: coordinateTextEditingController,
              // ),
              // const _SplitOption(),
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
              const _AGCMode(),
              // const _ALCMode(),
              const _LogInterval(),
              const _RFOutputLogInterval(),
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
            height: CustomStyle.formBottomSpacingL,
          ),
        ],
      );
    }

    return BlocListener<Setting18RegulationBloc, Setting18RegulationState>(
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
          context.read<Setting18RegulationBloc>().add(const Initialized());
        }

        if (state.isInitialize) {
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
        if (state.isInitialPilotFrequencyLevelValues) {
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
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: buildConfigurationWidget(partId),
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

class _SplitOption extends StatelessWidget {
  const _SplitOption();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18RegulationBloc, Setting18RegulationState>(
      buildWhen: (previous, current) =>
          previous.splitOption != current.splitOption ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return splitOptionGridViewButton(
          context: context,
          editMode: state.editMode,
          splitOption: state.splitOption,
          onGridPressed: (index) => context
              .read<Setting18RegulationBloc>()
              .add(SplitOptionChanged(splitOptionValues[index])),
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.splitOption),
          ),
        );
      },
    );
  }
}

class _PilotFrequencyMode extends StatelessWidget {
  const _PilotFrequencyMode();

  @override
  Widget build(BuildContext context) {
    List<String> pilotFrequencyModeTexts = [
      AppLocalizations.of(context)!.pilotFrequencyBandwidthSettings,
      AppLocalizations.of(context)!.pilotFrequencyUserSettings,
      //  AppLocalizations.of(context)!.pilotFrequencySmartSettings,
    ];

    return BlocBuilder<Setting18RegulationBloc, Setting18RegulationState>(
      buildWhen: (previous, current) =>
          previous.pilotFrequencyMode != current.pilotFrequencyMode ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return pilotFrequencyModeGridViewButton(
          context: context,
          crossAxisCount: 1,
          texts: pilotFrequencyModeTexts,
          values: pilotFrequencyModeValues,
          editMode: state.editMode,
          pilotFrequencyMode: state.pilotFrequencyMode,
          onGridPressed: (index) => context
              .read<Setting18RegulationBloc>()
              .add(PilotFrequencyModeChanged(pilotFrequencyModeValues[index])),
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.pilotFrequencyMode),
          ),
        );
      },
    );
  }
}

// 判斷在不同 pilotFrequencyMode 下要顯示哪些 error text,
// 只要有其中一個不符合, 所有相關的 frequency 欄位都會顯示 error text
bool _isNotValidFrequency({
  required String pilotFrequencyMode,
  required RangeIntegerInput firstChannelLoadingFrequency,
  required RangeIntegerInput lastChannelLoadingFrequency,
  required RangeIntegerInput pilotFrequency1,
  required RangeIntegerInput pilotFrequency2,
}) {
  if (pilotFrequencyMode == '0') {
    return firstChannelLoadingFrequency.isNotValid ||
        lastChannelLoadingFrequency.isNotValid;
  } else if (pilotFrequencyMode == '1') {
    return firstChannelLoadingFrequency.isNotValid ||
        lastChannelLoadingFrequency.isNotValid ||
        pilotFrequency1.isNotValid ||
        pilotFrequency2.isNotValid;
  } else {
    return false;
  }
}

class _FirstChannelLoading extends StatelessWidget {
  const _FirstChannelLoading({
    required this.firstChannelLoadingFrequencyTextEditingController,
    required this.firstChannelLoadingLevelTextEditingController,
    required this.currentDetectedSplitOption,
  });

  final TextEditingController firstChannelLoadingFrequencyTextEditingController;
  final TextEditingController firstChannelLoadingLevelTextEditingController;
  final String currentDetectedSplitOption;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18RegulationBloc, Setting18RegulationState>(
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
                .read<Setting18RegulationBloc>()
                .add(FirstChannelLoadingFrequencyChanged(
                  firstChannelLoadingFrequency: firstChannelLoadingFrequency,
                  currentDetectedSplitOption: currentDetectedSplitOption,
                ));
          },
          onChanged2: (firstChannelLoadingLevel) {
            context
                .read<Setting18RegulationBloc>()
                .add(FirstChannelLoadingLevelChanged(firstChannelLoadingLevel));
          },
          errorText1: _isNotValidFrequency(
            pilotFrequencyMode: state.pilotFrequencyMode,
            firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
            lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
            pilotFrequency1: state.pilotFrequency1,
            pilotFrequency2: state.pilotFrequency2,
          )
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          errorText2: state.firstChannelLoadingLevel.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet
                    .contains(DataKey.firstChannelLoadingFrequency) ||
                state.tappedSet.contains(DataKey.firstChannelLoadingLevel),
          ),
        );
      },
    );
  }
}

class _LastChannelLoading extends StatelessWidget {
  const _LastChannelLoading({
    required this.lastChannelLoadingFrequencyTextEditingController,
    required this.lastChannelLoadingLevelTextEditingController,
  });

  final TextEditingController lastChannelLoadingFrequencyTextEditingController;
  final TextEditingController lastChannelLoadingLevelTextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18RegulationBloc, Setting18RegulationState>(
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
            context.read<Setting18RegulationBloc>().add(
                LastChannelLoadingFrequencyChanged(
                    lastChannelLoadingFrequency));
          },
          onChanged2: (lastChannelLoadingLevel) {
            context
                .read<Setting18RegulationBloc>()
                .add(LastChannelLoadingLevelChanged(lastChannelLoadingLevel));
          },
          errorText1: _isNotValidFrequency(
            pilotFrequencyMode: state.pilotFrequencyMode,
            firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
            lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
            pilotFrequency1: state.pilotFrequency1,
            pilotFrequency2: state.pilotFrequency2,
          )
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          errorText2: state.lastChannelLoadingLevel.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
            context: context,
            isTap:
                state.tappedSet.contains(DataKey.lastChannelLoadingFrequency) ||
                    state.tappedSet.contains(DataKey.lastChannelLoadingLevel),
          ),
        );
      },
    );
  }
}

class _PilotFrequency1 extends StatelessWidget {
  const _PilotFrequency1({
    required this.pilotFrequency1TextEditingController,
    required this.manualModePilot1RFOutputPowerTextEditingController,
  });

  final TextEditingController pilotFrequency1TextEditingController;
  final TextEditingController
      manualModePilot1RFOutputPowerTextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18RegulationBloc, Setting18RegulationState>(
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
                .read<Setting18RegulationBloc>()
                .add(PilotFrequency1Changed(frequency));
          },
          onChanged2: (_) {},
          errorText1: _isNotValidFrequency(
            pilotFrequencyMode: state.pilotFrequencyMode,
            firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
            lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
            pilotFrequency1: state.pilotFrequency1,
            pilotFrequency2: state.pilotFrequency2,
          )
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.pilotFrequency1),
          ),
        );
      },
    );
  }
}

class _PilotFrequency2 extends StatelessWidget {
  const _PilotFrequency2({
    required this.pilotFrequency2TextEditingController,
    required this.manualModePilot2RFOutputPowerTextEditingController,
  });

  final TextEditingController pilotFrequency2TextEditingController;
  final TextEditingController
      manualModePilot2RFOutputPowerTextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18RegulationBloc, Setting18RegulationState>(
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
                .read<Setting18RegulationBloc>()
                .add(PilotFrequency2Changed(frequency));
          },
          onChanged2: (_) {},
          errorText1: _isNotValidFrequency(
            pilotFrequencyMode: state.pilotFrequencyMode,
            firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
            lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
            pilotFrequency1: state.pilotFrequency1,
            pilotFrequency2: state.pilotFrequency2,
          )
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.pilotFrequency2),
          ),
        );
      },
    );
  }
}

class _AGCMode extends StatelessWidget {
  const _AGCMode();

  final List<String> fwdAGCModeValues = const [
    '1',
    '0',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18RegulationBloc, Setting18RegulationState>(
      buildWhen: (previous, current) =>
          previous.agcMode != current.agcMode ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return controlToggleButton(
          context: context,
          editMode: state.editMode,
          title: '${AppLocalizations.of(context)!.agcMode}:',
          currentValue: state.agcMode,
          onChanged: (int index) {
            context
                .read<Setting18RegulationBloc>()
                .add(AGCModeChanged(fwdAGCModeValues[index]));
          },
          values: fwdAGCModeValues,
          texts: [
            AppLocalizations.of(context)!.on,
            AppLocalizations.of(context)!.off,
          ],
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.agcMode),
          ),
        );
        // Card(
        //   color: getSettingListCardColor(
        //     context: context,
        //     isTap: state.tappedSet.contains(DataKey.agcMode),
        //   ),
        //   child: Padding(
        //     padding: const EdgeInsets.all(CustomStyle.sizeXL),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Padding(
        //           padding: const EdgeInsets.only(
        //             bottom: CustomStyle.sizeL,
        //           ),
        //           child: Text(
        //             '${AppLocalizations.of(context)!.agcMode}:',
        //             style: const TextStyle(
        //               fontSize: CustomStyle.sizeXL,
        //               fontWeight: FontWeight.w500,
        //             ),
        //           ),
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.only(
        //             bottom: CustomStyle.sizeXS,
        //           ),
        //           child: LayoutBuilder(
        //             builder: (context, constraints) => ToggleButtons(
        //               direction: Axis.horizontal,
        //               onPressed: (int index) {
        //                 if (state.editMode) {
        //                   context
        //                       .read<Setting18RegulationBloc>()
        //                       .add(AGCModeChanged(fwdAGCModeValues[index]));
        //                 }
        //               },
        //               textStyle: const TextStyle(fontSize: 18.0),
        //               borderRadius: const BorderRadius.all(Radius.circular(8)),
        //               selectedBorderColor: state.editMode
        //                   ? Theme.of(context).colorScheme.primary
        //                   : Theme.of(context)
        //                       .colorScheme
        //                       .inversePrimary, // indigo border color
        //               selectedColor: Theme.of(context)
        //                   .colorScheme
        //                   .onPrimary, // white text color

        //               fillColor: state.editMode
        //                   ? Theme.of(context).colorScheme.primary
        //                   : Theme.of(context)
        //                       .colorScheme
        //                       .inversePrimary, // selected
        //               color: Theme.of(context)
        //                   .colorScheme
        //                   .secondary, // not selected
        //               constraints: BoxConstraints.expand(
        //                 width: (constraints.maxWidth - 4) /
        //                     fwdAGCModeValues.length,
        //               ),
        //               isSelected: getSelectionState(state.agcMode),
        //               children: <Widget>[
        //                 Text(AppLocalizations.of(context)!.on),
        //                 Text(AppLocalizations.of(context)!.off),
        //               ],
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // );
      },
    );
  }
}

// 2024/0419 ALC 為 read only 且 ALC 的動作跟 AGC 連動
class _ALCMode extends StatelessWidget {
  const _ALCMode();

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
    return BlocBuilder<Setting18RegulationBloc, Setting18RegulationState>(
      buildWhen: (previous, current) =>
          previous.alcMode != current.alcMode ||
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
                    // if (state.editMode) {
                    //   context.read<Setting18RegulationBloc>().add(
                    //       AutoLevelControlChanged(
                    //           autoLevelControlValues[index]));
                    // }
                  },
                  textStyle: const TextStyle(fontSize: 18.0),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: state.editMode && false
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context)
                          .colorScheme
                          .inversePrimary, // indigo border color
                  selectedColor: Theme.of(context)
                      .colorScheme
                      .onPrimary, // white text color

                  fillColor: state.editMode && false
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
                  isSelected: getSelectionState(state.alcMode),
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
  const _LogInterval();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18RegulationBloc, Setting18RegulationState>(
      buildWhen: (previous, current) =>
          previous.logInterval != current.logInterval ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return configurationIntervalSlider(
          context: context,
          editMode: state.editMode,
          title: AppLocalizations.of(context)!.logInterval,
          minValue: 5,
          currentValue: state.logInterval,
          maxValue: 240,
          interval: 5,
          onChanged: (double logInterval) {
            context
                .read<Setting18RegulationBloc>()
                .add(LogIntervalChanged(logInterval.toStringAsFixed(0)));
          },
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.logInterval),
          ),
        );
      },
    );
  }
}

class _RFOutputLogInterval extends StatelessWidget {
  const _RFOutputLogInterval();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18RegulationBloc, Setting18RegulationState>(
      buildWhen: (previous, current) =>
          previous.rfOutputLogInterval != current.rfOutputLogInterval ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return configurationIntervalSlider(
          context: context,
          editMode: state.editMode,
          title: AppLocalizations.of(context)!.rfOutputLogInterval,
          minValue: 30,
          currentValue: state.rfOutputLogInterval,
          maxValue: 240,
          interval: 30,
          onChanged: (double rfOutputLogInterval) {
            context.read<Setting18RegulationBloc>().add(
                RFOutputLogIntervalChanged(
                    rfOutputLogInterval.toStringAsFixed(0)));
          },
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.rfOutputLogInterval),
          ),
        );
      },
    );
  }
}

class _TGCCableLength extends StatelessWidget {
  const _TGCCableLength();

  @override
  Widget build(BuildContext context) {
    final List<String> tgcCableLengthValues = [
      '9',
      '18',
      '27',
    ];

    return BlocBuilder<Setting18RegulationBloc, Setting18RegulationState>(
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
                .read<Setting18RegulationBloc>()
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
      return SingleChildScrollView(
        clipBehavior: Clip.none,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            getConfigureSetupWizard(
              context: context,
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
                CustomIcons.cancel,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () {
                context
                    .read<Setting18RegulationBloc>()
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
                      bool shouldSubmit = false;

                      if (kDebugMode) {
                        // In debug mode, we always submit
                        shouldSubmit = true;
                      } else {
                        // In release mode, show the confirmation dialog
                        bool? isMatch =
                            await showConfirmInputDialog(context: context);
                        if (context.mounted) {
                          shouldSubmit = isMatch ?? false;
                        }
                      }

                      if (shouldSubmit) {
                        handleUpdateAction(
                          context: context,
                          targetBloc: context.read<Setting18RegulationBloc>(),
                          action: () {
                            context
                                .read<Setting18RegulationBloc>()
                                .add(const SettingSubmitted());
                          },
                          waitForState: (state) {
                            Setting18RegulationState setting18RegulationState =
                                state as Setting18RegulationState;

                            return setting18RegulationState
                                .submissionStatus.isSubmissionSuccess;
                          },
                        );
                      }
                    }
                  : null,
              child: Icon(
                Icons.check,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      );
    }

    Widget getDisabledEditModeTools() {
      String graphFilePath = settingGraphFilePath[partId] ?? '';
      return SingleChildScrollView(
        clipBehavior: Clip.none,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            getConfigureSetupWizard(
              context: context,
            ),
            const SizedBox(
              height: 10.0,
            ),
            graphFilePath.isNotEmpty
                ? FloatingActionButton(
                    // heroTag is used to solve exception: There are multiple heroes that share the same tag within a subtree.
                    heroTag: null,
                    shape: const CircleBorder(
                      side: BorderSide.none,
                    ),
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withAlpha(200),

                    onPressed: () {
                      // 當 Setting18GraphPage 被 pop 後, 不管有沒有設定參數都重新初始化
                      Navigator.push(
                          context,
                          Setting18GraphPage.route(
                            graphFilePath: graphFilePath,
                          )).then((value) {
                        context
                            .read<Setting18RegulationBloc>()
                            .add(const Initialized());
                      });
                    },
                    child: Icon(
                      Icons.settings_input_composite,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
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
                    .read<Setting18RegulationBloc>()
                    .add(const EditModeEnabled());
              },
            ),
          ],
        ),
      );
    }

    Widget getDisabledFloatingActionButtons() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          getConfigureSetupWizard(
            context: context,
          ),
          const SizedBox(
            height: 10.0,
          ),
          FloatingActionButton(
            // heroTag is used to solve exception: There are multiple heroes that share the same tag within a subtree.
            heroTag: null,
            shape: const CircleBorder(
              side: BorderSide.none,
            ),
            backgroundColor: Colors.grey.withAlpha(200),
            onPressed: null,
            child: Icon(
              Icons.settings_input_composite,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          FloatingActionButton(
              shape: const CircleBorder(
                side: BorderSide.none,
              ),
              backgroundColor: Colors.grey.withAlpha(200),
              onPressed: null,
              child: Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.onPrimary,
              )),
        ],
      );
    }

    Widget getFloatingActionButtons({
      required bool editMode,
      required bool enableSubmission,
    }) {
      return editMode
          ? getEnabledEditModeTools(
              enableSubmission: enableSubmission,
            )
          : getDisabledEditModeTools();
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
      final Setting18RegulationState setting18RegulationState =
          context.watch<Setting18RegulationBloc>().state;

      bool editable = getEditable(
        loadingStatus: homeState.loadingStatus,
      );
      return editable
          ? getFloatingActionButtons(
              editMode: setting18RegulationState.editMode,
              enableSubmission: setting18RegulationState.enableSubmission,
            )
          : getDisabledFloatingActionButtons();
    });
  }
}
