import 'dart:io';

import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/message_localization.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18_attribute/setting18_attribute_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18_tabbar/setting18_tabbar_bloc.dart';
import 'package:aci_plus_app/setting/model/card_color.dart';
import 'package:aci_plus_app/setting/model/confirm_input_dialog.dart';
import 'package:aci_plus_app/setting/shared/utils.dart';
import 'package:aci_plus_app/setting/views/custom_setting_dialog.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_graph_page.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18AttributeView extends StatelessWidget {
  Setting18AttributeView({super.key});

  final TextEditingController locationTextEditingController =
      TextEditingController();
  final TextEditingController coordinateTextEditingController =
      TextEditingController();
  final TextEditingController technicianIDTextEditingController =
      TextEditingController();
  final TextEditingController inputSignalLevelTextEditingController =
      TextEditingController();
  final TextEditingController inputAttenuationTextEditingController =
      TextEditingController();
  final TextEditingController inputEqualizerTextEditingController =
      TextEditingController();
  final TextEditingController cascadePositionTextEditingController =
      TextEditingController();
  final TextEditingController deviceNameTextEditingController =
      TextEditingController();
  final TextEditingController deviceNoteTextEditingController =
      TextEditingController();
  // final TextEditingController lastChannelLoadingLevelTextEditingController =
  //     TextEditingController();
  // final TextEditingController pilotFrequency1TextEditingController =
  //     TextEditingController();
  // final TextEditingController pilotFrequency2TextEditingController =
  //     TextEditingController();
  // final TextEditingController
  //     manualModePilot1RFOutputPowerTextEditingController =
  //     TextEditingController();
  // final TextEditingController
  //     manualModePilot2RFOutputPowerTextEditingController =
  //     TextEditingController();

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
    //         .read<Setting18AttributeBloc>()
    //         .add(const Initialized(useCache: false));
    //   });
    // }

    HomeState homeState = context.read<HomeBloc>().state;
    String partId = homeState.characteristicData[DataKey.partId] ?? '';
    int firmwareVersion = convertFirmwareVersionStringToInt(
        homeState.characteristicData[DataKey.firmwareVersion] ?? '0');
    // String currentDetectedSplitOption =
    //     homeState.characteristicData[DataKey.currentDetectedSplitOption] ?? '0';

    if (homeState.connectionStatus.isRequestFailure) {
      // 重新 Initialized, 讀取並顯示空值
      context.read<Setting18AttributeBloc>().add(const Initialized());
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
      } else if (item == DataKey.technicianID.name) {
        return AppLocalizations.of(context)!.dialogMessageTechnicianIDSetting;
      } else if (item == DataKey.inputSignalLevel.name) {
        return AppLocalizations.of(context)!
            .dialogMessageInputSignalLevelSetting;
      } else if (item == DataKey.inputAttenuation.name) {
        return AppLocalizations.of(context)!
            .dialogMessageInputAttenuationSetting;
      } else if (item == DataKey.inputEqualizer.name) {
        return AppLocalizations.of(context)!.dialogMessageInputEqualizerSetting;
      } else if (item == DataKey.cascadePosition.name) {
        return AppLocalizations.of(context)!
            .dialogMessageCascadePositionSetting;
      } else if (item == DataKey.deviceName.name) {
        return AppLocalizations.of(context)!.dialogMessageDeviceNameSetting;
      } else if (item == DataKey.deviceNote.name) {
        return AppLocalizations.of(context)!.dialogMessageDeviceNoteSetting;
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
            ];
    }

    Widget buildConfigurationWidget() {
      if (firmwareVersion >= 148) {
        return Column(
          children: [
            _Location(
              textEditingController: locationTextEditingController,
            ),
            _Coordinates(
              textEditingController: coordinateTextEditingController,
            ),
            _TechnicianID(
              textEditingController: technicianIDTextEditingController,
            ),
            _InputSignalLevel(
              textEditingController: inputSignalLevelTextEditingController,
            ),
            _InputAttenuation(
              textEditingController: inputAttenuationTextEditingController,
            ),
            _InputEqualizer(
              textEditingController: inputEqualizerTextEditingController,
            ),
            _CascadePosition(
              textEditingController: cascadePositionTextEditingController,
            ),
            _DeviceName(
              textEditingController: deviceNameTextEditingController,
            ),
            _DeviceNote(
              textEditingController: deviceNoteTextEditingController,
            ),
            const SizedBox(
              height: 120,
            ),
          ],
        );
      } else {
        return Column(
          children: [
            _Location(
              textEditingController: locationTextEditingController,
            ),
            _Coordinates(
              textEditingController: coordinateTextEditingController,
            ),
            const SizedBox(
              height: 120,
            ),
          ],
        );
      }
    }

    return BlocListener<Setting18AttributeBloc, Setting18AttributeState>(
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
          context.read<Setting18AttributeBloc>().add(const Initialized());

          // 重新啟動 CEQ 定時偵測
          // context
          //     .read<Setting18TabBarBloc>()
          //     .add(const CurrentForwardCEQPeriodicUpdateRequested());
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
          technicianIDTextEditingController.text = state.technicianID;
          inputSignalLevelTextEditingController.text = state.inputSignalLevel;
          inputAttenuationTextEditingController.text = state.inputAttenuation;
          inputEqualizerTextEditingController.text = state.inputEqualizer;
          cascadePositionTextEditingController.text = state.cascadePosition;
          deviceNameTextEditingController.text = state.deviceName;
          deviceNoteTextEditingController.text = state.deviceNote;
          // firstChannelLoadingFrequencyTextEditingController.text =
          //     state.firstChannelLoadingFrequency.value;
          // firstChannelLoadingLevelTextEditingController.text =
          //     state.firstChannelLoadingLevel.value;
          // lastChannelLoadingFrequencyTextEditingController.text =
          //     state.lastChannelLoadingFrequency.value;
          // lastChannelLoadingLevelTextEditingController.text =
          //     state.lastChannelLoadingLevel.value;
          // pilotFrequency1TextEditingController.text =
          //     state.pilotFrequency1.value;
          // pilotFrequency2TextEditingController.text =
          //     state.pilotFrequency2.value;
          // manualModePilot1RFOutputPowerTextEditingController.text =
          //     state.manualModePilot1RFOutputPower;
          // manualModePilot2RFOutputPowerTextEditingController.text =
          //     state.manualModePilot2RFOutputPower;
        }
        // if (state.isInitialPilotFrequencyLevelValues) {
        //   firstChannelLoadingFrequencyTextEditingController.text =
        //       state.firstChannelLoadingFrequency.value;
        //   firstChannelLoadingLevelTextEditingController.text =
        //       state.firstChannelLoadingLevel.value;
        //   lastChannelLoadingFrequencyTextEditingController.text =
        //       state.lastChannelLoadingFrequency.value;
        //   lastChannelLoadingLevelTextEditingController.text =
        //       state.lastChannelLoadingLevel.value;
        //   pilotFrequency1TextEditingController.text =
        //       state.pilotFrequency1.value;
        //   pilotFrequency2TextEditingController.text =
        //       state.pilotFrequency2.value;
        // }
      },
      child: PopScope(
        onPopInvoked: (didPop) {
          print('12123');
        },
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: buildConfigurationWidget(),
            ),
          ),
          floatingActionButton: _SettingFloatingActionButton(
            partId: partId,
            // currentDetectedSplitOption: currentDetectedSplitOption,
          ),
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
    return BlocBuilder<Setting18AttributeBloc, Setting18AttributeState>(
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
                          .read<Setting18AttributeBloc>()
                          .add(LocationChanged(location));
                    },
                    onTapOutside: (event) {
                      // 點擊其他區域關閉螢幕鍵盤
                      FocusManager.instance.primaryFocus?.unfocus();
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
    return BlocBuilder<Setting18AttributeBloc, Setting18AttributeState>(
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
                          .read<Setting18AttributeBloc>()
                          .add(CoordinatesChanged(coordinate));
                    },
                    onTapOutside: (event) {
                      // 點擊其他區域關閉螢幕鍵盤
                      FocusManager.instance.primaryFocus?.unfocus();
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
                                              .read<Setting18AttributeBloc>()
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

class _TechnicianID extends StatelessWidget {
  const _TechnicianID({
    required this.textEditingController,
  });

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18AttributeBloc, Setting18AttributeState>(
      builder: (context, state) {
        return Card(
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.technicianID),
          ),
          child: Padding(
            padding: const EdgeInsets.all(CustomStyle.sizeXL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: CustomStyle.sizeL,
                  ),
                  child: Text(
                    '${AppLocalizations.of(context)!.technicianID}:',
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
                    key: const Key('setting18Form_technicianIDInput_textField'),
                    style: const TextStyle(
                      fontSize: CustomStyle.sizeXL,
                    ),
                    enabled: state.editMode,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.done,
                    onChanged: (technicianID) {
                      context
                          .read<Setting18AttributeBloc>()
                          .add(TechnicianIDChanged(technicianID));
                    },
                    onTapOutside: (event) {
                      // 點擊其他區域關閉螢幕鍵盤
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    maxLength: 6,
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

class _InputSignalLevel extends StatelessWidget {
  const _InputSignalLevel({
    required this.textEditingController,
  });

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18AttributeBloc, Setting18AttributeState>(
      builder: (context, state) {
        return Card(
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.inputSignalLevel),
          ),
          child: Padding(
            padding: const EdgeInsets.all(CustomStyle.sizeXL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: CustomStyle.sizeL,
                  ),
                  child: Text(
                    '${AppLocalizations.of(context)!.inputSignalLevel}:',
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
                    key: const Key(
                        'setting18Form_inputSignalLevelInput_textField'),
                    style: const TextStyle(
                      fontSize: CustomStyle.sizeXL,
                    ),
                    enabled: state.editMode,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.done,
                    onChanged: (inputSignalLevel) {
                      context
                          .read<Setting18AttributeBloc>()
                          .add(InputSignalLevelChanged(inputSignalLevel));
                    },
                    onTapOutside: (event) {
                      // 點擊其他區域關閉螢幕鍵盤
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    maxLength: 6,
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

class _InputAttenuation extends StatelessWidget {
  const _InputAttenuation({
    required this.textEditingController,
  });

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18AttributeBloc, Setting18AttributeState>(
      builder: (context, state) {
        return Card(
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.inputAttenuation),
          ),
          child: Padding(
            padding: const EdgeInsets.all(CustomStyle.sizeXL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: CustomStyle.sizeL,
                  ),
                  child: Text(
                    '${AppLocalizations.of(context)!.inputAttenuation}:',
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
                    key: const Key('setting18Form_technicianIDInput_textField'),
                    style: const TextStyle(
                      fontSize: CustomStyle.sizeXL,
                    ),
                    enabled: state.editMode,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.done,
                    onChanged: (inputAttenuation) {
                      context
                          .read<Setting18AttributeBloc>()
                          .add(InputAttenuationChanged(inputAttenuation));
                    },
                    onTapOutside: (event) {
                      // 點擊其他區域關閉螢幕鍵盤
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    maxLength: 6,
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

class _InputEqualizer extends StatelessWidget {
  const _InputEqualizer({
    required this.textEditingController,
  });

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18AttributeBloc, Setting18AttributeState>(
      builder: (context, state) {
        return Card(
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.inputEqualizer),
          ),
          child: Padding(
            padding: const EdgeInsets.all(CustomStyle.sizeXL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: CustomStyle.sizeL,
                  ),
                  child: Text(
                    '${AppLocalizations.of(context)!.inputEqualizer}:',
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
                    key: const Key(
                        'setting18Form_inputEqualizerInput_textField'),
                    style: const TextStyle(
                      fontSize: CustomStyle.sizeXL,
                    ),
                    enabled: state.editMode,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.done,
                    onChanged: (inputEqualizer) {
                      context
                          .read<Setting18AttributeBloc>()
                          .add(InputEqualizerChanged(inputEqualizer));
                    },
                    onTapOutside: (event) {
                      // 點擊其他區域關閉螢幕鍵盤
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    maxLength: 6,
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

class _CascadePosition extends StatelessWidget {
  const _CascadePosition({
    required this.textEditingController,
  });

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18AttributeBloc, Setting18AttributeState>(
      builder: (context, state) {
        return Card(
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.cascadePosition),
          ),
          child: Padding(
            padding: const EdgeInsets.all(CustomStyle.sizeXL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: CustomStyle.sizeL,
                  ),
                  child: Text(
                    '${AppLocalizations.of(context)!.cascadePosition}:',
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
                    key: const Key('setting18Form_cascadePosition_textField'),
                    style: const TextStyle(
                      fontSize: CustomStyle.sizeXL,
                    ),
                    enabled: state.editMode,
                    textInputAction: TextInputAction.done,
                    onChanged: (cascadePosition) {
                      context
                          .read<Setting18AttributeBloc>()
                          .add(CascadePositionChanged(cascadePosition));
                    },
                    onTapOutside: (event) {
                      // 點擊其他區域關閉螢幕鍵盤
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    maxLength: 32,
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

class _DeviceName extends StatelessWidget {
  const _DeviceName({
    required this.textEditingController,
  });

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18AttributeBloc, Setting18AttributeState>(
      builder: (context, state) {
        return Card(
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.deviceName),
          ),
          child: Padding(
            padding: const EdgeInsets.all(CustomStyle.sizeXL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: CustomStyle.sizeL,
                  ),
                  child: Text(
                    '${AppLocalizations.of(context)!.deviceName}:',
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
                    key: const Key('setting18Form_deviceName_textField'),
                    style: const TextStyle(
                      fontSize: CustomStyle.sizeXL,
                    ),
                    enabled: state.editMode,
                    textInputAction: TextInputAction.done,
                    onChanged: (deviceName) {
                      context
                          .read<Setting18AttributeBloc>()
                          .add(DeviceNameChanged(deviceName));
                    },
                    onTapOutside: (event) {
                      // 點擊其他區域關閉螢幕鍵盤
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    maxLength: 32,
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

class _DeviceNote extends StatelessWidget {
  const _DeviceNote({
    required this.textEditingController,
  });

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18AttributeBloc, Setting18AttributeState>(
      builder: (context, state) {
        return Card(
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.deviceNote),
          ),
          child: Padding(
            padding: const EdgeInsets.all(CustomStyle.sizeXL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: CustomStyle.sizeL,
                  ),
                  child: Text(
                    '${AppLocalizations.of(context)!.deviceNote}:',
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
                  child: SizedBox(
                    height: 200, // Fixed height
                    child: TextField(
                      controller: textEditingController,
                      key: const Key('setting18Form_deviceNote_textField'),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: const TextStyle(
                        fontSize: CustomStyle.sizeXL,
                      ),
                      enabled: state.editMode,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      // textInputAction: TextInputAction.done,
                      onChanged: (deviceNote) {
                        context
                            .read<Setting18AttributeBloc>()
                            .add(DeviceNoteChanged(deviceNote));
                      },
                      onTapOutside: (event) {
                        // 點擊其他區域關閉螢幕鍵盤
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      maxLength: 400,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0))),
                        contentPadding: const EdgeInsets.all(10.0),
                        isDense: true,
                        filled: true,
                        fillColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                        counterText: '',
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
                  .read<Setting18AttributeBloc>()
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
                      // 停止 CEQ 定時偵測
                      // context
                      //     .read<Setting18TabBarBloc>()
                      //     .add(const CurrentForwardCEQPeriodicUpdateCanceled());
                      context
                          .read<Setting18AttributeBloc>()
                          .add(const SettingSubmitted());
                    } else {
                      bool? isMatch =
                          await showConfirmInputDialog(context: context);

                      if (context.mounted) {
                        if (isMatch != null) {
                          if (isMatch) {
                            // 停止 CEQ 定時偵測
                            // context.read<Setting18TabBarBloc>().add(
                            //     const CurrentForwardCEQPeriodicUpdateCanceled());
                            context
                                .read<Setting18AttributeBloc>()
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
                  backgroundColor: Platform.isWindows
                      ? winBeta >= 7
                          ? Theme.of(context).colorScheme.primary.withAlpha(200)
                          : Colors.grey.withAlpha(200)
                      : Theme.of(context).colorScheme.primary.withAlpha(200),
                  onPressed: Platform.isWindows
                      ? winBeta >= 7
                          ? () {
                              // 停止 CEQ 定時偵測
                              // context.read<Setting18TabBarBloc>().add(
                              //     const CurrentForwardCEQPeriodicUpdateCanceled());

                              // 當 Setting18GraphPage 被 pop 後, 不管有沒有設定參數都重新初始化
                              Navigator.push(
                                  context,
                                  Setting18GraphPage.route(
                                    graphFilePath: graphFilePath,
                                  )).then((value) {
                                context
                                    .read<Setting18AttributeBloc>()
                                    .add(const Initialized());

                                // 重新啟動 CEQ 定時偵測
                                // context.read<Setting18TabBarBloc>().add(
                                //     const CurrentForwardCEQPeriodicUpdateRequested());
                              });
                            }
                          : null
                      : () {
                          // 停止 CEQ 定時偵測
                          // context.read<Setting18TabBarBloc>().add(
                          //     const CurrentForwardCEQPeriodicUpdateCanceled());

                          // 當 Setting18GraphPage 被 pop 後, 不管有沒有設定參數都重新初始化
                          Navigator.push(
                              context,
                              Setting18GraphPage.route(
                                graphFilePath: graphFilePath,
                              )).then((value) {
                            context
                                .read<Setting18AttributeBloc>()
                                .add(const Initialized());

                            // 重新啟動 CEQ 定時偵測
                            // context.read<Setting18TabBarBloc>().add(
                            //     const CurrentForwardCEQPeriodicUpdateRequested());
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
                  .read<Setting18AttributeBloc>()
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
      final Setting18AttributeState setting18AttributeState =
          context.watch<Setting18AttributeBloc>().state;

      bool editable = getEditable(
        loadingStatus: homeState.loadingStatus,
      );
      return editable
          ? getFloatingActionButtons(
              editMode: setting18AttributeState.editMode,
              enableSubmission: setting18AttributeState.enableSubmission,
            )
          : getDisabledFloatingActionButtons();
    });
  }
}
