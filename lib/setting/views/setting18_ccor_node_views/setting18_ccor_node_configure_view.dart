import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/message_localization.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18_ccor_node_configure/setting18_ccor_node_configure_bloc.dart';
import 'package:aci_plus_app/setting/model/card_color.dart';
import 'package:aci_plus_app/setting/model/confirm_input_dialog.dart';
import 'package:aci_plus_app/setting/model/setting_widgets.dart';
import 'package:aci_plus_app/setting/views/custom_setting_dialog.dart';
import 'package:aci_plus_app/setting/views/setting18_ccor_node_views/setting18_ccor_node_graph_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18CCorNodeConfigureView extends StatelessWidget {
  Setting18CCorNodeConfigureView({super.key});

  final TextEditingController locationTextEditingController =
      TextEditingController();
  final TextEditingController coordinateTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    HomeState homeState = context.watch<HomeBloc>().state;
    String partId = homeState.characteristicData[DataKey.partId] ?? '';

    if (homeState.connectionStatus.isRequestFailure) {
      // 重新 Initialized, 讀取並顯示空值
      context.read<Setting18CCorNodeConfigureBloc>().add(const Initialized());
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
      } else if (item == DataKey.forwardMode.name) {
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
              _Location(
                textEditingController: locationTextEditingController,
              ),
              _Coordinates(
                textEditingController: coordinateTextEditingController,
              ),
              const _ForwardMode(),
              const _ForwardConfig(),
              const _SplitOption(),
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
            height: 120,
          ),
        ],
      );
    }

    return BlocListener<Setting18CCorNodeConfigureBloc,
        Setting18CCorNodeConfigureState>(
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
              .read<Setting18CCorNodeConfigureBloc>()
              .add(const Initialized());
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

class _Location extends StatelessWidget {
  const _Location({
    required this.textEditingController,
  });

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeConfigureBloc,
        Setting18CCorNodeConfigureState>(
      builder: (context, state) {
        return Card(
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.location),
          ),
          child: Padding(
            padding: const EdgeInsets.all(CustomStyle.sizeXL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: CustomStyle.sizeL),
                  child: Text(
                    '${AppLocalizations.of(context)!.location}:',
                    style: const TextStyle(
                      fontSize: CustomStyle.sizeXL,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: CustomStyle.sizeXS,
                  ),
                  child: TextField(
                    controller: textEditingController,
                    key: const Key('setting18Form_locationInput_textField'),
                    style: const TextStyle(
                      fontSize: CustomStyle.sizeXL,
                    ),
                    enabled: state.editMode,
                    textInputAction: TextInputAction.done,
                    onChanged: (location) {
                      context
                          .read<Setting18CCorNodeConfigureBloc>()
                          .add(LocationChanged(location));
                    },
                    maxLength: 48,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0))),
                      contentPadding: const EdgeInsets.all(10.0),
                      isDense: true,
                      filled: true,
                      fillColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      counterText: '',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Coordinates extends StatelessWidget {
  const _Coordinates({
    required this.textEditingController,
  });

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeConfigureBloc,
        Setting18CCorNodeConfigureState>(
      builder: (context, state) {
        return Card(
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.coordinates),
          ),
          child: Padding(
            padding: const EdgeInsets.all(CustomStyle.sizeXL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: CustomStyle.sizeL),
                  child: Text(
                    '${AppLocalizations.of(context)!.coordinates}:',
                    style: const TextStyle(
                      fontSize: CustomStyle.sizeXL,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: CustomStyle.sizeXS,
                  ),
                  child: TextField(
                    controller: textEditingController,
                    key: const Key('setting18Form_coordinatesInput_textField'),
                    style: const TextStyle(
                      fontSize: CustomStyle.sizeXL,
                    ),
                    enabled: state.editMode,
                    textInputAction: TextInputAction.done,
                    onChanged: (coordinate) {
                      context
                          .read<Setting18CCorNodeConfigureBloc>()
                          .add(CoordinatesChanged(coordinate));
                    },
                    maxLength: 39,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10.0),
                      isDense: true,
                      filled: true,
                      fillColor:
                          Theme.of(context).colorScheme.secondaryContainer,
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
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                )
                              : IconButton(
                                  iconSize: 26,
                                  icon: Icon(
                                    Icons.pin_drop,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    // size: 22,
                                  ),
                                  onPressed: state.editMode
                                      ? () {
                                          context
                                              .read<
                                                  Setting18CCorNodeConfigureBloc>()
                                              .add(
                                                  const GPSCoordinatesRequested());
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ForwardMode extends StatelessWidget {
  const _ForwardMode();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeConfigureBloc,
        Setting18CCorNodeConfigureState>(
      buildWhen: (previous, current) =>
          previous.forwardMode != current.forwardMode ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        // return Padding(
        //   padding: const EdgeInsets.only(
        //     bottom: 40.0,
        //   ),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.only(
        //           bottom: CustomStyle.sizeL,
        //         ),
        //         child: Text(
        //           '${AppLocalizations.of(context)!.forwardMode}:',
        //           style: const TextStyle(
        //             fontSize: CustomStyle.sizeXL,
        //             fontWeight: FontWeight.w500,
        //           ),
        //         ),
        //       ),
        //       GridView.builder(
        //         physics: const NeverScrollableScrollPhysics(),
        //         shrinkWrap: true,
        //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //           crossAxisCount: 2,
        //           childAspectRatio: (MediaQuery.of(context).size.width / 110.0),
        //         ),
        //         itemCount: splitOptionValues.length,
        //         itemBuilder: (BuildContext childContext, int index) {
        //           return Padding(
        //             padding: const EdgeInsets.all(2.0),
        //             child: ElevatedButton(
        //               style: ElevatedButton.styleFrom(
        //                 padding: const EdgeInsets.symmetric(horizontal: 4.0),
        //                 elevation: 0.0,
        //                 disabledBackgroundColor: getDisabledBackgroundColor(
        //                   context: context,
        //                   targetValue: state.forwardMode,
        //                   value: '120',
        //                 ),
        //                 backgroundColor: getBackgroundColor(
        //                   context: context,
        //                   targetValue: state.forwardMode,
        //                   value: '120',
        //                 ),
        //                 shape: const RoundedRectangleBorder(
        //                     borderRadius:
        //                         BorderRadius.all(Radius.circular(10.0))),
        //               ),
        //               onPressed: state.editMode ? () {} : null,
        //               child: Text(
        //                 '123123123',
        //                 style: const TextStyle(
        //                   fontSize: CustomStyle.sizeXL,
        //                   fontWeight: FontWeight.normal,
        //                 ),
        //               ),
        //             ),
        //           );
        //         },
        //       ),
        //     ],
        //   ),
        // );

        return configureGridViewButton(
          context: context,
          editMode: state.editMode,
          title: '${AppLocalizations.of(context)!.forwardMode}:',
          targetValue: state.forwardMode,
          texts: forwardModeTexts,
          values: forwardModeValues,
          onGridPressed: (index) => context
              .read<Setting18CCorNodeConfigureBloc>()
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
    return BlocBuilder<Setting18CCorNodeConfigureBloc,
        Setting18CCorNodeConfigureState>(
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
              .read<Setting18CCorNodeConfigureBloc>()
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
    return BlocBuilder<Setting18CCorNodeConfigureBloc,
        Setting18CCorNodeConfigureState>(
      buildWhen: (previous, current) =>
          previous.splitOption != current.splitOption ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return splitOptionGridViewButton(
          context: context,
          editMode: state.editMode,
          splitOption: state.splitOption,
          onGridPressed: (index) => context
              .read<Setting18CCorNodeConfigureBloc>()
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
    return BlocBuilder<Setting18CCorNodeConfigureBloc,
        Setting18CCorNodeConfigureState>(
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
                .read<Setting18CCorNodeConfigureBloc>()
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
                  .read<Setting18CCorNodeConfigureBloc>()
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
                          .read<Setting18CCorNodeConfigureBloc>()
                          .add(const SettingSubmitted());
                    } else {
                      bool? isMatch =
                          await showConfirmInputDialog(context: context);

                      if (context.mounted) {
                        if (isMatch != null) {
                          if (isMatch) {
                            context
                                .read<Setting18CCorNodeConfigureBloc>()
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
                            .read<Setting18CCorNodeConfigureBloc>()
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
                  .read<Setting18CCorNodeConfigureBloc>()
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
      final Setting18CCorNodeConfigureState setting18CCorNodeConfigureState =
          context.watch<Setting18CCorNodeConfigureBloc>().state;

      bool editable = getEditable(loadingStatus: homeState.loadingStatus);
      return editable
          ? getFloatingActionButtons(
              editMode: setting18CCorNodeConfigureState.editMode,
              enableSubmission:
                  setting18CCorNodeConfigureState.enableSubmission,
            )
          : getDisabledFloatingActionButtons();
    });
  }
}
