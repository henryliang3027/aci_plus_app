import 'dart:io';

import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/message_localization.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18_ccor_node_regulation/setting18_ccor_node_regulation_bloc.dart';
import 'package:aci_plus_app/setting/model/card_color.dart';
import 'package:aci_plus_app/setting/model/confirm_input_dialog.dart';
import 'package:aci_plus_app/setting/model/setting_widgets.dart';
import 'package:aci_plus_app/setting/shared/utils.dart';
import 'package:aci_plus_app/setting/views/custom_setting_dialog.dart';
import 'package:aci_plus_app/setting/views/setting18_ccor_node_views/setting18_ccor_node_graph_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18CCorNodeRegulationView extends StatelessWidget {
  const Setting18CCorNodeRegulationView({super.key});

  @override
  Widget build(BuildContext context) {
    HomeState homeState = context.watch<HomeBloc>().state;
    String partId = homeState.characteristicData[DataKey.partId] ?? '';

    if (homeState.connectionStatus.isRequestFailure) {
      // 重新 Initialized, 讀取並顯示空值
      context.read<Setting18CCorNodeRegulationBloc>().add(const Initialized());
    }

    String formatResultValue(String boolValue) {
      return boolValue == 'true'
          ? AppLocalizations.of(context)!.dialogMessageSuccessful
          : AppLocalizations.of(context)!.dialogMessageFailed;
    }

    String formatResultItem(String item) {
      if (item == DataKey.forwardMode.name) {
        return AppLocalizations.of(context)!.dialogMessageForwardModeSetting;
      } else if (item == DataKey.forwardConfig.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardConfigModeSetting;
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
          case SettingConfiruration.forwardMode:
            widgets.add(const _ForwardMode());
            break;
          case SettingConfiruration.forwardConfigMode:
            widgets.add(const _ForwardConfig());
            break;
          case SettingConfiruration.splitOptions:
            widgets.add(const _SplitOption());
            break;
          case SettingConfiruration.logInterval:
            widgets.add(const _LogInterval());
            break;
        }
      }
      return widgets.isNotEmpty
          ? widgets
          : [
              const _ForwardMode(),
              const _ForwardConfig(),
              // const _SplitOption(),
              const _LogInterval(),
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

    return BlocListener<Setting18CCorNodeRegulationBloc,
        Setting18CCorNodeRegulationState>(
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

          context
              .read<Setting18CCorNodeRegulationBloc>()
              .add(const Initialized());
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

class _ForwardMode extends StatelessWidget {
  const _ForwardMode();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeRegulationBloc,
        Setting18CCorNodeRegulationState>(
      buildWhen: (previous, current) =>
          previous.forwardMode != current.forwardMode ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return configureGridViewButton(
          context: context,
          editMode: state.editMode,
          title: '${AppLocalizations.of(context)!.forwardMode}:',
          targetValue: state.forwardMode,
          texts: forwardModeTexts,
          values: forwardModeValues,
          onGridPressed: (index) => context
              .read<Setting18CCorNodeRegulationBloc>()
              .add(ForwardModeChanged(forwardModeValues[index])),
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.forwardMode),
          ),
        );
      },
    );
  }
}

class _ForwardConfig extends StatelessWidget {
  const _ForwardConfig();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeRegulationBloc,
        Setting18CCorNodeRegulationState>(
      buildWhen: (previous, current) =>
          previous.forwardConfig != current.forwardConfig ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return configureGridViewButton(
          context: context,
          editMode: state.editMode,
          title: '${AppLocalizations.of(context)!.forwardConfigMode}:',
          targetValue: state.forwardConfig,
          texts: forwardConfigTexts,
          values: forwardConfigValues,
          onGridPressed: (index) => context
              .read<Setting18CCorNodeRegulationBloc>()
              .add(ForwardConfigChanged(forwardConfigValues[index])),
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.forwardConfig),
          ),
        );
      },
    );
  }
}

class _SplitOption extends StatelessWidget {
  const _SplitOption();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeRegulationBloc,
        Setting18CCorNodeRegulationState>(
      buildWhen: (previous, current) =>
          previous.splitOption != current.splitOption ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return splitOptionGridViewButton(
          context: context,
          editMode: state.editMode,
          splitOption: state.splitOption,
          onGridPressed: (index) => context
              .read<Setting18CCorNodeRegulationBloc>()
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

class _LogInterval extends StatelessWidget {
  const _LogInterval();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeRegulationBloc,
        Setting18CCorNodeRegulationState>(
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
                .read<Setting18CCorNodeRegulationBloc>()
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
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // getConfigureSetupWizard(
          //   context: context,
          //   aciDeviceType: ACIDeviceType.ampCCorNode1P8G,
          // ),
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
                  .read<Setting18CCorNodeRegulationBloc>()
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
                        targetBloc:
                            context.read<Setting18CCorNodeRegulationBloc>(),
                        action: () {
                          context
                              .read<Setting18CCorNodeRegulationBloc>()
                              .add(const SettingSubmitted());
                        },
                        waitForState: (state) {
                          Setting18CCorNodeRegulationState
                              setting18CCorNodeRegulationState =
                              state as Setting18CCorNodeRegulationState;

                          return setting18CCorNodeRegulationState
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
      );
    }

    Widget getDisabledEditModeTools() {
      String graphFilePath = settingGraphFilePath[partId] ?? '';
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // getConfigureSetupWizard(
          //   context: context,
          //   aciDeviceType: ACIDeviceType.ampCCorNode1P8G,
          // ),
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
                            Setting18CCorNodeGraphPage.route(
                              graphFilePath: graphFilePath,
                            ))
                        .then((value) => context
                            .read<Setting18CCorNodeRegulationBloc>()
                            .add(const Initialized()));
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
                  .read<Setting18CCorNodeRegulationBloc>()
                  .add(const EditModeEnabled());
            },
          ),
        ],
      );
    }

    Widget getDisabledFloatingActionButtons() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // getConfigureSetupWizard(
          //   context: context,
          //   aciDeviceType: ACIDeviceType.ampCCorNode1P8G,
          // ),
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
      final Setting18CCorNodeRegulationState setting18CCorNodeRegulationState =
          context.watch<Setting18CCorNodeRegulationBloc>().state;

      bool editable = getEditable(loadingStatus: homeState.loadingStatus);
      return editable
          ? getFloatingActionButtons(
              editMode: setting18CCorNodeRegulationState.editMode,
              enableSubmission:
                  setting18CCorNodeRegulationState.enableSubmission,
            )
          : getDisabledFloatingActionButtons();
    });
  }
}
