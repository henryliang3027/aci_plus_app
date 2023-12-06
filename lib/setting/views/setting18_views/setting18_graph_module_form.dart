import 'package:aci_plus_app/core/command.dart';
import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18_graph_module_bloc/setting18_graph_module_bloc.dart';
import 'package:aci_plus_app/setting/model/confirm_input_dialog.dart';
import 'package:aci_plus_app/setting/model/setting_wisgets.dart';
import 'package:aci_plus_app/setting/views/custom_setting_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18GraphModuleForm extends StatefulWidget {
  const Setting18GraphModuleForm({
    super.key,
    required this.moduleId,
  });

  final int moduleId;

  @override
  State<Setting18GraphModuleForm> createState() =>
      _Setting18GraphModuleFormState();
}

class _Setting18GraphModuleFormState extends State<Setting18GraphModuleForm> {
  late final TextEditingController
      firstChannelLoadingFrequencyTextEditingController;
  late final TextEditingController
      firstChannelLoadingLevelTextEditingController;
  late final TextEditingController
      lastChannelLoadingFrequencyTextEditingController;
  late final TextEditingController lastChannelLoadingLevelTextEditingController;
  late final TextEditingController pilotFrequency1TextEditingController;
  late final TextEditingController pilotFrequency2TextEditingController;
  late final TextEditingController
      manualModePilot1RFOutputPowerTextEditingController;
  late final TextEditingController
      manualModePilot2RFOutputPowerTextEditingController;

  @override
  void initState() {
    firstChannelLoadingFrequencyTextEditingController = TextEditingController();
    firstChannelLoadingLevelTextEditingController = TextEditingController();
    lastChannelLoadingFrequencyTextEditingController = TextEditingController();
    lastChannelLoadingLevelTextEditingController = TextEditingController();
    pilotFrequency1TextEditingController = TextEditingController();
    pilotFrequency2TextEditingController = TextEditingController();
    manualModePilot1RFOutputPowerTextEditingController =
        TextEditingController();
    manualModePilot2RFOutputPowerTextEditingController =
        TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    HomeState homeState = context.watch<HomeBloc>().state;
    String partId = homeState.characteristicData[DataKey.partId] ?? '';
    // String inputAttenuation =
    //     homeState.characteristicData[DataKey.inputAttenuation] ?? '';
    // String inputEqualizer =
    //     homeState.characteristicData[DataKey.inputEqualizer] ?? '';
    // String inputAttenuation2 =
    //     homeState.characteristicData[DataKey.inputAttenuation2] ?? '';
    // String inputAttenuation3 =
    //     homeState.characteristicData[DataKey.inputAttenuation3] ?? '';
    // String inputAttenuation4 =
    //     homeState.characteristicData[DataKey.inputAttenuation4] ?? '';
    // String outputAttenuation =
    //     homeState.characteristicData[DataKey.outputAttenuation] ?? '';
    // String outputEqualizer =
    //     homeState.characteristicData[DataKey.outputEqualizer] ?? '';
    // String ingressSetting2 =
    //     homeState.characteristicData[DataKey.ingressSetting2] ?? '';
    // String ingressSetting3 =
    //     homeState.characteristicData[DataKey.ingressSetting3] ?? '';
    // String ingressSetting4 =
    //     homeState.characteristicData[DataKey.ingressSetting4] ?? '';
    // String tgcCableLength =
    //     homeState.characteristicData[DataKey.tgcCableLength] ?? '';
    // String dsVVA2 = homeState.characteristicData[DataKey.dsVVA2] ?? '';
    // String dsSlope2 = homeState.characteristicData[DataKey.dsSlope2] ?? '';
    // String dsVVA3 = homeState.characteristicData[DataKey.dsVVA3] ?? '';
    // String dsVVA4 = homeState.characteristicData[DataKey.dsVVA4] ?? '';
    // String usTGC = homeState.characteristicData[DataKey.usTGC] ?? '';
    // String splitOption =
    //     homeState.characteristicData[DataKey.splitOption] ?? '';
    // String firstChannelLoadingFrequency =
    //     homeState.characteristicData[DataKey.firstChannelLoadingFrequency] ??
    //         '';
    // String lastChannelLoadingFrequency =
    //     homeState.characteristicData[DataKey.lastChannelLoadingFrequency] ?? '';
    // String firstChannelLoadingLevel =
    //     homeState.characteristicData[DataKey.firstChannelLoadingLevel] ?? '';
    // String lastChannelLoadingLevel =
    //     homeState.characteristicData[DataKey.lastChannelLoadingLevel] ?? '';
    // String pilotFrequencyMode =
    //     homeState.characteristicData[DataKey.pilotFrequencyMode] ?? '';
    // String pilotFrequency1 =
    //     homeState.characteristicData[DataKey.pilotFrequency1] ?? '';
    // String pilotFrequency2 =
    //     homeState.characteristicData[DataKey.pilotFrequency2] ?? '';

    // String manualModePilot1RFOutputPower =
    //     homeState.characteristicData[DataKey.manualModePilot1RFOutputPower] ??
    //         '';
    // String manualModePilot2RFOutputPower =
    //     homeState.characteristicData[DataKey.manualModePilot2RFOutputPower] ??
    //         '';

    // context.read<Setting18GraphModuleBloc>().add(Initialized(
    //       fwdInputAttenuation: inputAttenuation,
    //       fwdInputEQ: inputEqualizer,
    //       rtnInputAttenuation2: inputAttenuation2,
    //       rtnInputAttenuation3: inputAttenuation3,
    //       rtnInputAttenuation4: inputAttenuation4,
    //       rtnOutputLevelAttenuation: outputAttenuation,
    //       rtnOutputEQ: outputEqualizer,
    //       rtnIngressSetting2: ingressSetting2,
    //       rtnIngressSetting3: ingressSetting3,
    //       rtnIngressSetting4: ingressSetting4,
    //       tgcCableLength: tgcCableLength,
    //       dsVVA2: dsVVA2,
    //       dsSlope2: dsSlope2,
    //       dsVVA3: dsVVA3,
    //       dsVVA4: dsVVA4,
    //       usTGC: usTGC,
    //       splitOption: splitOption,
    //       firstChannelLoadingFrequency: firstChannelLoadingFrequency,
    //       firstChannelLoadingLevel: firstChannelLoadingLevel,
    //       lastChannelLoadingFrequency: lastChannelLoadingFrequency,
    //       lastChannelLoadingLevel: lastChannelLoadingLevel,
    //       pilotFrequencyMode: pilotFrequencyMode,
    //       pilotFrequency1: pilotFrequency1,
    //       pilotFrequency2: pilotFrequency2,
    //       manualModePilot1RFOutputPower: manualModePilot1RFOutputPower,
    //       manualModePilot2RFOutputPower: manualModePilot2RFOutputPower,
    //     ));

    List<Widget> getSettingWidgetByModuleId() {
      switch (widget.moduleId) {
        case 0:
          return [const _SplitOption()];
        case 1:
          return [const _FwdInputAttenuation()];
        case 2:
          return [const _FwdInputEQ()];
        case 3:
          return [const _FwdInputEQ()];
        case 4:
          return [const _FwdInputEQ()];
        case 5:
          return [const _FwdInputEQ()];
        case 6:
          return [const _FwdInputEQ()];
        case 7:
          return [const _FwdInputEQ()];
        case 8:
          return [const _FwdInputEQ()];
        case 9:
          return [const _FwdInputEQ()];
        case 10:
          return [
            const _PilotFrequencyMode(),
            _FirstChannelLoading(
              firstChannelLoadingFrequencyTextEditingController:
                  firstChannelLoadingFrequencyTextEditingController,
              firstChannelLoadingLevelTextEditingController:
                  firstChannelLoadingLevelTextEditingController,
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
          ];
        default:
          return [];
      }
    }

    String formatResultValue(String boolValue) {
      return boolValue == 'true'
          ? AppLocalizations.of(context)!.dialogMessageSuccessful
          : AppLocalizations.of(context)!.dialogMessageFailed;
    }

    String formatResultItem(String item) {
      if (item == DataKey.inputAttenuation.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardInputAttenuationSetting;
      } else if (item == DataKey.inputEqualizer.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardInputEqualizerSetting;
      } else if (item == DataKey.inputAttenuation2.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnInputAttenuation2Setting;
      } else if (item == DataKey.inputAttenuation3.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnInputAttenuation3Setting;
      } else if (item == DataKey.inputAttenuation4.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnInputAttenuation4Setting;
      } else if (item == DataKey.outputAttenuation.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnOutputAttenuationSetting;
      } else if (item == DataKey.outputEqualizer.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnOutputEqualizerSetting;
      } else if (item == DataKey.ingressSetting2.name) {
        return AppLocalizations.of(context)!.dialogMessageReturnIngress2Setting;
      } else if (item == DataKey.ingressSetting3.name) {
        return AppLocalizations.of(context)!.dialogMessageReturnIngress3Setting;
      } else if (item == DataKey.ingressSetting4.name) {
        return AppLocalizations.of(context)!.dialogMessageReturnIngress4Setting;
      } else if (item == DataKey.tgcCableLength.name) {
        return AppLocalizations.of(context)!.dialogMessageTGCCableLengthSetting;
      } else if (item == DataKey.dsVVA2.name) {
        return AppLocalizations.of(context)!.dialogMessageDSVVA2Setting;
      } else if (item == DataKey.dsSlope2.name) {
        return AppLocalizations.of(context)!.dialogMessageDSSlope2Setting;
      } else if (item == DataKey.dsVVA3.name) {
        return AppLocalizations.of(context)!.dialogMessageDSVVA3Setting;
      } else if (item == DataKey.dsVVA4.name) {
        if (partId == '5' || partId == '6') {
          return AppLocalizations.of(context)!
              .dialogMessageForwardOutputEqualizer2And3Setting;
        } else {
          return AppLocalizations.of(context)!
              .dialogMessageForwardOutputEqualizer3And4Setting;
        }
      }
      // else if (item == DataKey.usTGC.name) {
      //   return AppLocalizations.of(context)!.dialogMessageUSTGCSetting;
      // }
      else if (item == DataKey.splitOption.name) {
        return AppLocalizations.of(context)!.dialogMessageSplitOptionSetting;
      } else if (item == DataKey.pilotFrequencyMode.name) {
        return AppLocalizations.of(context)!
            .dialogMessagePilotFrequencyModeSetting;
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
      } else if (item == DataKey.pilotFrequency1.name) {
        return AppLocalizations.of(context)!
            .dialogMessagePilotFrequency1Setting;
      } else if (item == DataKey.pilotFrequency2.name) {
        return AppLocalizations.of(context)!
            .dialogMessagePilotFrequency2Setting;
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

    return BlocListener<Setting18GraphModuleBloc, Setting18GraphModuleState>(
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
          firstChannelLoadingFrequencyTextEditingController.text =
              state.firstChannelLoadingFrequency;
          firstChannelLoadingLevelTextEditingController.text =
              state.firstChannelLoadingLevel;
          lastChannelLoadingFrequencyTextEditingController.text =
              state.lastChannelLoadingFrequency;
          lastChannelLoadingLevelTextEditingController.text =
              state.lastChannelLoadingLevel;
          pilotFrequency1TextEditingController.text = state.pilotFrequency1;
          pilotFrequency2TextEditingController.text = state.pilotFrequency2;
          manualModePilot1RFOutputPowerTextEditingController.text =
              state.manualModePilot1RFOutputPower;
          manualModePilot2RFOutputPowerTextEditingController.text =
              state.manualModePilot2RFOutputPower;
        }
      },
      child: Padding(
          padding: const EdgeInsets.all(30),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...getSettingWidgetByModuleId(),
                    const SizedBox(
                      height: 60.0,
                    ),
                  ],
                ),
              ),
              const Positioned(
                right: 10,
                bottom: 10,
                child: _SettingFloatingActionButton(),
              ),
            ],
          )),
    );
  }
}

// class Setting18GraphModuleForm extends StatelessWidget {
//   Setting18GraphModuleForm({
//     super.key,
//     required this.moduleId,
//   });

//   final int moduleId;

//   final TextEditingController
//       firstChannelLoadingFrequencyTextEditingController =
//       TextEditingController();
//   final TextEditingController firstChannelLoadingLevelTextEditingController =
//       TextEditingController();
//   final TextEditingController lastChannelLoadingFrequencyTextEditingController =
//       TextEditingController();
//   final TextEditingController lastChannelLoadingLevelTextEditingController =
//       TextEditingController();
//   final TextEditingController pilotFrequency1TextEditingController =
//       TextEditingController();
//   final TextEditingController pilotFrequency2TextEditingController =
//       TextEditingController();
//   final TextEditingController
//       manualModePilot1RFOutputPowerTextEditingController =
//       TextEditingController();
//   final TextEditingController
//       manualModePilot2RFOutputPowerTextEditingController =
//       TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     HomeState homeState = context.watch<HomeBloc>().state;
//     String partId = homeState.characteristicData[DataKey.partId] ?? '';
//     String inputAttenuation =
//         homeState.characteristicData[DataKey.inputAttenuation] ?? '';
//     String inputEqualizer =
//         homeState.characteristicData[DataKey.inputEqualizer] ?? '';
//     String inputAttenuation2 =
//         homeState.characteristicData[DataKey.inputAttenuation2] ?? '';
//     String inputAttenuation3 =
//         homeState.characteristicData[DataKey.inputAttenuation3] ?? '';
//     String inputAttenuation4 =
//         homeState.characteristicData[DataKey.inputAttenuation4] ?? '';
//     String outputAttenuation =
//         homeState.characteristicData[DataKey.outputAttenuation] ?? '';
//     String outputEqualizer =
//         homeState.characteristicData[DataKey.outputEqualizer] ?? '';
//     String ingressSetting2 =
//         homeState.characteristicData[DataKey.ingressSetting2] ?? '';
//     String ingressSetting3 =
//         homeState.characteristicData[DataKey.ingressSetting3] ?? '';
//     String ingressSetting4 =
//         homeState.characteristicData[DataKey.ingressSetting4] ?? '';
//     String tgcCableLength =
//         homeState.characteristicData[DataKey.tgcCableLength] ?? '';
//     String dsVVA2 = homeState.characteristicData[DataKey.dsVVA2] ?? '';
//     String dsSlope2 = homeState.characteristicData[DataKey.dsSlope2] ?? '';
//     String dsVVA3 = homeState.characteristicData[DataKey.dsVVA3] ?? '';
//     String dsVVA4 = homeState.characteristicData[DataKey.dsVVA4] ?? '';
//     String usTGC = homeState.characteristicData[DataKey.usTGC] ?? '';
//     String splitOption =
//         homeState.characteristicData[DataKey.splitOption] ?? '';
//     String firstChannelLoadingFrequency =
//         homeState.characteristicData[DataKey.firstChannelLoadingFrequency] ??
//             '';
//     String lastChannelLoadingFrequency =
//         homeState.characteristicData[DataKey.lastChannelLoadingFrequency] ?? '';
//     String firstChannelLoadingLevel =
//         homeState.characteristicData[DataKey.firstChannelLoadingLevel] ?? '';
//     String lastChannelLoadingLevel =
//         homeState.characteristicData[DataKey.lastChannelLoadingLevel] ?? '';
//     String pilotFrequencyMode =
//         homeState.characteristicData[DataKey.pilotFrequencyMode] ?? '';
//     String pilotFrequency1 =
//         homeState.characteristicData[DataKey.pilotFrequency1] ?? '';
//     String pilotFrequency2 =
//         homeState.characteristicData[DataKey.pilotFrequency2] ?? '';

//     String manualModePilot1RFOutputPower =
//         homeState.characteristicData[DataKey.manualModePilot1RFOutputPower] ??
//             '';
//     String manualModePilot2RFOutputPower =
//         homeState.characteristicData[DataKey.manualModePilot2RFOutputPower] ??
//             '';

//     context.read<Setting18GraphModuleBloc>().add(Initialized(
//           fwdInputAttenuation: inputAttenuation,
//           fwdInputEQ: inputEqualizer,
//           rtnInputAttenuation2: inputAttenuation2,
//           rtnInputAttenuation3: inputAttenuation3,
//           rtnInputAttenuation4: inputAttenuation4,
//           rtnOutputLevelAttenuation: outputAttenuation,
//           rtnOutputEQ: outputEqualizer,
//           rtnIngressSetting2: ingressSetting2,
//           rtnIngressSetting3: ingressSetting3,
//           rtnIngressSetting4: ingressSetting4,
//           tgcCableLength: tgcCableLength,
//           dsVVA2: dsVVA2,
//           dsSlope2: dsSlope2,
//           dsVVA3: dsVVA3,
//           dsVVA4: dsVVA4,
//           usTGC: usTGC,
//           splitOption: splitOption,
//           firstChannelLoadingFrequency: firstChannelLoadingFrequency,
//           firstChannelLoadingLevel: firstChannelLoadingLevel,
//           lastChannelLoadingFrequency: lastChannelLoadingFrequency,
//           lastChannelLoadingLevel: lastChannelLoadingLevel,
//           pilotFrequencyMode: pilotFrequencyMode,
//           pilotFrequency1: pilotFrequency1,
//           pilotFrequency2: pilotFrequency2,
//           manualModePilot1RFOutputPower: manualModePilot1RFOutputPower,
//           manualModePilot2RFOutputPower: manualModePilot2RFOutputPower,
//         ));

//     List<Widget> getSettingWidgetByModuleId() {
//       switch (moduleId) {
//         case 0:
//           return [const _SplitOption()];
//         case 1:
//           return [const _FwdInputAttenuation()];
//         case 2:
//           return [const _FwdInputEQ()];
//         case 3:
//           return [const _FwdInputEQ()];
//         case 4:
//           return [const _FwdInputEQ()];
//         case 5:
//           return [const _FwdInputEQ()];
//         case 6:
//           return [const _FwdInputEQ()];
//         case 7:
//           return [const _FwdInputEQ()];
//         case 8:
//           return [const _FwdInputEQ()];
//         case 9:
//           return [const _FwdInputEQ()];
//         case 10:
//           return [
//             const _PilotFrequencyMode(),
//             _FirstChannelLoading(
//               firstChannelLoadingFrequencyTextEditingController:
//                   firstChannelLoadingFrequencyTextEditingController,
//               firstChannelLoadingLevelTextEditingController:
//                   firstChannelLoadingLevelTextEditingController,
//             ),
//             _LastChannelLoading(
//               lastChannelLoadingFrequencyTextEditingController:
//                   lastChannelLoadingFrequencyTextEditingController,
//               lastChannelLoadingLevelTextEditingController:
//                   lastChannelLoadingLevelTextEditingController,
//             ),
//             _PilotFrequency1(
//               pilotFrequency1TextEditingController:
//                   pilotFrequency1TextEditingController,
//               manualModePilot1RFOutputPowerTextEditingController:
//                   manualModePilot1RFOutputPowerTextEditingController,
//             ),
//             _PilotFrequency2(
//               pilotFrequency2TextEditingController:
//                   pilotFrequency2TextEditingController,
//               manualModePilot2RFOutputPowerTextEditingController:
//                   manualModePilot2RFOutputPowerTextEditingController,
//             ),
//           ];
//         default:
//           return [];
//       }
//     }

//     String formatResultValue(String boolValue) {
//       return boolValue == 'true'
//           ? AppLocalizations.of(context)!.dialogMessageSuccessful
//           : AppLocalizations.of(context)!.dialogMessageFailed;
//     }

//     String formatResultItem(String item) {
//       if (item == DataKey.inputAttenuation.name) {
//         return AppLocalizations.of(context)!
//             .dialogMessageForwardInputAttenuationSetting;
//       } else if (item == DataKey.inputEqualizer.name) {
//         return AppLocalizations.of(context)!
//             .dialogMessageForwardInputEqualizerSetting;
//       } else if (item == DataKey.inputAttenuation2.name) {
//         return AppLocalizations.of(context)!
//             .dialogMessageReturnInputAttenuation2Setting;
//       } else if (item == DataKey.inputAttenuation3.name) {
//         return AppLocalizations.of(context)!
//             .dialogMessageReturnInputAttenuation3Setting;
//       } else if (item == DataKey.inputAttenuation4.name) {
//         return AppLocalizations.of(context)!
//             .dialogMessageReturnInputAttenuation4Setting;
//       } else if (item == DataKey.outputAttenuation.name) {
//         return AppLocalizations.of(context)!
//             .dialogMessageReturnOutputAttenuationSetting;
//       } else if (item == DataKey.outputEqualizer.name) {
//         return AppLocalizations.of(context)!
//             .dialogMessageReturnOutputEqualizerSetting;
//       } else if (item == DataKey.ingressSetting2.name) {
//         return AppLocalizations.of(context)!.dialogMessageReturnIngress2Setting;
//       } else if (item == DataKey.ingressSetting3.name) {
//         return AppLocalizations.of(context)!.dialogMessageReturnIngress3Setting;
//       } else if (item == DataKey.ingressSetting4.name) {
//         return AppLocalizations.of(context)!.dialogMessageReturnIngress4Setting;
//       } else if (item == DataKey.tgcCableLength.name) {
//         return AppLocalizations.of(context)!.dialogMessageTGCCableLengthSetting;
//       } else if (item == DataKey.dsVVA2.name) {
//         return AppLocalizations.of(context)!.dialogMessageDSVVA2Setting;
//       } else if (item == DataKey.dsSlope2.name) {
//         return AppLocalizations.of(context)!.dialogMessageDSSlope2Setting;
//       } else if (item == DataKey.dsVVA3.name) {
//         return AppLocalizations.of(context)!.dialogMessageDSVVA3Setting;
//       } else if (item == DataKey.dsVVA4.name) {
//         return AppLocalizations.of(context)!.dialogMessageDSVVA4Setting;
//       } else if (item == DataKey.usTGC.name) {
//         return AppLocalizations.of(context)!.dialogMessageUSTGCSetting;
//       } else if (item == DataKey.splitOption.name) {
//         return AppLocalizations.of(context)!.dialogMessageSplitOptionSetting;
//       } else if (item == DataKey.pilotFrequencyMode.name) {
//         return AppLocalizations.of(context)!
//             .dialogMessagePilotFrequencyModeSetting;
//       } else if (item == DataKey.firstChannelLoadingFrequency.name) {
//         return AppLocalizations.of(context)!
//             .dialogMessageFirstChannelLoadingFrequencySetting;
//       } else if (item == DataKey.firstChannelLoadingLevel.name) {
//         return AppLocalizations.of(context)!
//             .dialogMessageFirstChannelLoadingLevelSetting;
//       } else if (item == DataKey.lastChannelLoadingFrequency.name) {
//         return AppLocalizations.of(context)!
//             .dialogMessageLastChannelLoadingFrequencySetting;
//       } else if (item == DataKey.lastChannelLoadingLevel.name) {
//         return AppLocalizations.of(context)!
//             .dialogMessageLastChannelLoadingLevelSetting;
//       } else if (item == DataKey.pilotFrequency1.name) {
//         return AppLocalizations.of(context)!
//             .dialogMessagePilotFrequency1Setting;
//       } else if (item == DataKey.pilotFrequency2.name) {
//         return AppLocalizations.of(context)!
//             .dialogMessagePilotFrequency2Setting;
//       } else {
//         return '';
//       }
//     }

//     Color getResultValueColor(String resultValue) {
//       return resultValue == 'true' ? Colors.green : Colors.red;
//     }

//     List<Widget> getMessageRows(List<String> settingResultList) {
//       List<Widget> rows = [];
//       for (String settingResult in settingResultList) {
//         String item = settingResult.split(',')[0];
//         String value = settingResult.split(',')[1];
//         Color valueColor = getResultValueColor(value);

//         rows.add(Padding(
//           padding: const EdgeInsets.only(
//             bottom: 14.0,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 flex: 3,
//                 child: Text(
//                   formatResultItem(item),
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               ),
//               Expanded(
//                 child: Text(
//                   formatResultValue(value),
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: valueColor,
//                   ),
//                   textAlign: TextAlign.end,
//                 ),
//               ),
//             ],
//           ),
//         ));
//       }
//       return rows;
//     }

//     return BlocListener<Setting18GraphModuleBloc, Setting18GraphModuleState>(
//       listener: (context, state) async {
//         if (state.submissionStatus.isSubmissionInProgress) {
//           await showInProgressDialog(context);
//         } else if (state.submissionStatus.isSubmissionSuccess) {
//           if (ModalRoute.of(context)?.isCurrent != true) {
//             Navigator.of(context).pop();
//           }
//           List<Widget> rows = getMessageRows(state.settingResult);
//           showResultDialog(
//             context: context,
//             messageRows: rows,
//           );
//         }

//         if (state.isInitialize) {
//           firstChannelLoadingFrequencyTextEditingController.text =
//               state.firstChannelLoadingFrequency;
//           firstChannelLoadingLevelTextEditingController.text =
//               state.firstChannelLoadingLevel;
//           lastChannelLoadingFrequencyTextEditingController.text =
//               state.lastChannelLoadingFrequency;
//           lastChannelLoadingLevelTextEditingController.text =
//               state.lastChannelLoadingLevel;
//           pilotFrequency1TextEditingController.text = state.pilotFrequency1;
//           pilotFrequency2TextEditingController.text = state.pilotFrequency2;
//           manualModePilot1RFOutputPowerTextEditingController.text =
//               state.manualModePilot1RFOutputPower;
//           manualModePilot2RFOutputPowerTextEditingController.text =
//               state.manualModePilot2RFOutputPower;
//         }
//       },
//       child: Padding(
//           padding: const EdgeInsets.all(30),
//           child: Stack(
//             children: [
//               SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     ...getSettingWidgetByModuleId(),
//                     const SizedBox(
//                       height: 60.0,
//                     ),
//                   ],
//                 ),
//               ),
//               const Positioned(
//                 right: 10,
//                 bottom: 10,
//                 child: _SettingFloatingActionButton(),
//               ),
//             ],
//           )),
//     );
//   }
// }

double _getValue(String value) {
  if (value.isNotEmpty) {
    return double.parse(value);
  } else {
    return 0.0;
  }
}

class _FwdInputAttenuation extends StatelessWidget {
  const _FwdInputAttenuation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        return controlParameterSlider(
          context: context,
          editMode: true,
          title:
              '${AppLocalizations.of(context)!.fwdInputAttenuation}: ${state.fwdInputAttenuation} dB',
          minValue: 0.0,
          maxValue: 15.0,
          currentValue: _getValue(state.fwdInputAttenuation),
          onChanged: (fwdInputAttenuation) {
            context.read<Setting18GraphModuleBloc>().add(
                FwdInputAttenuationChanged(
                    fwdInputAttenuation.toStringAsFixed(1)));
          },
          onDecreased: () => context
              .read<Setting18GraphModuleBloc>()
              .add(const FwdInputAttenuationDecreased()),
          onIncreased: () => context
              .read<Setting18GraphModuleBloc>()
              .add(const FwdInputAttenuationIncreased()),
        );
      },
    );
  }
}

class _FwdInputEQ extends StatelessWidget {
  const _FwdInputEQ({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        return controlParameterSlider(
          context: context,
          editMode: true,
          title:
              '${AppLocalizations.of(context)!.fwdInputEQ}: ${state.fwdInputEQ} dB',
          minValue: 0.0,
          maxValue: 15.0,
          currentValue: _getValue(state.fwdInputEQ),
          onChanged: (fwdInputEQ) {
            context
                .read<Setting18GraphModuleBloc>()
                .add(FwdInputEQChanged(fwdInputEQ.toStringAsFixed(1)));
          },
          onDecreased: () => context
              .read<Setting18GraphModuleBloc>()
              .add(const FwdInputEQDecreased()),
          onIncreased: () => context
              .read<Setting18GraphModuleBloc>()
              .add(const FwdInputEQIncreased()),
        );
      },
    );
  }
}

class _SplitOption extends StatelessWidget {
  const _SplitOption({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
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
                bottom: 16.0,
              ),
              child: Text(
                '${AppLocalizations.of(context)!.splitOption}:',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: (MediaQuery.of(context).size.width / 100.0),
              shrinkWrap: true,
              children: List.generate(6, (index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        elevation: 0.0,
                        foregroundColor: getForegroundColor(
                          context: context,
                          value: state.splitOption,
                          index: index,
                        ),
                        backgroundColor: getNullBackgroundColor(
                          context: context,
                          value: state.splitOption,
                          index: index,
                        ),
                        side: BorderSide(
                          color: getNullBorderColor(
                            context: context,
                            value: state.splitOption,
                            index: index,
                          ),
                          width: 1.0,
                        ),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                      ),
                      onPressed: () {},
                      child: Text(
                        splitOptionTexts[index],
                        style: const TextStyle(
                          fontSize: CustomStyle.sizeXL,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        elevation: 0.0,
                        foregroundColor: getForegroundColor(
                          context: context,
                          value: state.splitOption,
                          index: index,
                        ),
                        backgroundColor: getBackgroundColor(
                          context: context,
                          value: state.splitOption,
                          index: index,
                        ),
                        side: BorderSide(
                          color: getBorderColor(
                            context: context,
                            value: state.splitOption,
                            index: index,
                          ),
                          width: 1.0,
                        ),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                      ),
                      onPressed: index > 0 && index < 2
                          ? () {
                              context.read<Setting18GraphModuleBloc>().add(
                                  SplitOptionChanged(splitOptionValues[index]));
                            }
                          : () {},
                      child: Text(
                        splitOptionTexts[index],
                        style: const TextStyle(
                          fontSize: CustomStyle.sizeXL,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }
              }),
            ),
          ],
        ),
      );
    });
  }
}

class _PilotFrequencyMode extends StatelessWidget {
  const _PilotFrequencyMode({
    super.key,
  });

  final List<String> pilotFrequencyModeValues = const [
    '0',
    '1',
    '2',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      buildWhen: (previous, current) =>
          previous.pilotFrequencyMode != current.pilotFrequencyMode ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return controlToggleButton(
          context: context,
          editMode: true,
          title: '${AppLocalizations.of(context)!.pilotFrequencySelect}:',
          currentValue: state.pilotFrequencyMode,
          onChanged: (int index) {
            context.read<Setting18GraphModuleBloc>().add(
                PilotFrequencyModeChanged(pilotFrequencyModeValues[index]));
          },
          values: pilotFrequencyModeValues,
          texts: [
            AppLocalizations.of(context)!.pilotFrequencyFull,
            AppLocalizations.of(context)!.pilotFrequencyManual,
            AppLocalizations.of(context)!.pilotFrequencyScan,
          ],
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
  });

  final TextEditingController firstChannelLoadingFrequencyTextEditingController;
  final TextEditingController firstChannelLoadingLevelTextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        return twoTextField(
          context: context,
          title: '${AppLocalizations.of(context)!.startFrequency}:',
          editMode1: state.pilotFrequencyMode != '2',
          editMode2: state.pilotFrequencyMode != '2',
          textEditingControllerName1:
              'setting18Form_firstChannelLoadingFrequencyInput_textField',
          textEditingControllerName2:
              'setting18Form_firstChannelLoadingLevelInput_textField',
          textEditingController1:
              firstChannelLoadingFrequencyTextEditingController,
          textEditingController2: firstChannelLoadingLevelTextEditingController,
          onChanged1: (firstChannelLoadingFrequency) {
            context.read<Setting18GraphModuleBloc>().add(
                FirstChannelLoadingFrequencyChanged(
                    firstChannelLoadingFrequency));
          },
          onChanged2: (firstChannelLoadingLevel) {
            context
                .read<Setting18GraphModuleBloc>()
                .add(FirstChannelLoadingLevelChanged(firstChannelLoadingLevel));
          },
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
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        return twoTextField(
          context: context,
          title: '${AppLocalizations.of(context)!.stopFrequency}:',
          editMode1: state.pilotFrequencyMode != '2',
          editMode2: state.pilotFrequencyMode != '2',
          textEditingControllerName1:
              'setting18Form_lastChannelLoadingFrequencyInput_textField',
          textEditingControllerName2:
              'setting18Form_lastChannelLoadingLevelInput_textField',
          textEditingController1:
              lastChannelLoadingFrequencyTextEditingController,
          textEditingController2: lastChannelLoadingLevelTextEditingController,
          onChanged1: (lastChannelLoadingFrequency) {
            context.read<Setting18GraphModuleBloc>().add(
                LastChannelLoadingFrequencyChanged(
                    lastChannelLoadingFrequency));
          },
          onChanged2: (lastChannelLoadingLevel) {
            context
                .read<Setting18GraphModuleBloc>()
                .add(LastChannelLoadingLevelChanged(lastChannelLoadingLevel));
          },
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
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        return twoTextField(
          context: context,
          title: '${AppLocalizations.of(context)!.pilotFrequency1}:',
          editMode1: state.pilotFrequencyMode == '1',
          editMode2: false,
          textEditingControllerName1:
              'setting18Form_pilotFrequency1Input_textField',
          textEditingControllerName2:
              'setting18Form_manualModePilot1RFOutputPowerInput_textField',
          textEditingController1: pilotFrequency1TextEditingController,
          textEditingController2:
              manualModePilot1RFOutputPowerTextEditingController,
          onChanged1: (lastChannelLoadingFrequency) {
            context.read<Setting18GraphModuleBloc>().add(
                LastChannelLoadingFrequencyChanged(
                    lastChannelLoadingFrequency));
          },
          onChanged2: (lastChannelLoadingLevel) {
            context
                .read<Setting18GraphModuleBloc>()
                .add(LastChannelLoadingLevelChanged(lastChannelLoadingLevel));
          },
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
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        return twoTextField(
          context: context,
          title: '${AppLocalizations.of(context)!.pilotFrequency2}:',
          editMode1: state.pilotFrequencyMode == '1',
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
                .read<Setting18GraphModuleBloc>()
                .add(PilotFrequency2Changed(frequency));
          },
          onChanged2: (_) {},
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
      required bool enableSubmission,
      required bool editable,
    }) {
      return Row(
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
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(
            width: 10.0,
          ),
          FloatingActionButton(
            shape: const CircleBorder(
              side: BorderSide.none,
            ),
            backgroundColor: enableSubmission && editable
                ? Theme.of(context).colorScheme.primary.withAlpha(200)
                : Colors.grey.withAlpha(200),
            onPressed: enableSubmission && editable
                ? () async {
                    print(editable);
                    if (kDebugMode) {
                      context
                          .read<Setting18GraphModuleBloc>()
                          .add(const SettingSubmitted());
                    } else {
                      bool? isMatch =
                          await showConfirmInputDialog(context: context);

                      if (context.mounted) {
                        if (isMatch != null) {
                          if (isMatch) {
                            context
                                .read<Setting18GraphModuleBloc>()
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
      final Setting18GraphModuleState setting18graphModuleState =
          context.watch<Setting18GraphModuleBloc>().state;

      bool editable = getEditable(homeState.loadingStatus);
      return getEditTools(
        enableSubmission: setting18graphModuleState.enableSubmission,
        editable: editable,
      );
    });
  }
}
