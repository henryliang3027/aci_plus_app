import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18_graph_module_bloc/setting18_graph_module_bloc.dart';
import 'package:aci_plus_app/setting/model/confirm_input_dialog.dart';
import 'package:aci_plus_app/setting/model/setting_widgets.dart';
import 'package:aci_plus_app/setting/views/custom_setting_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18GraphModuleForm extends StatefulWidget {
  const Setting18GraphModuleForm({
    super.key,
    required this.moduleName,
  });

  final String moduleName;

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
    HomeState homeState = context.read<HomeBloc>().state;
    String partId = homeState.characteristicData[DataKey.partId] ?? '';
    String agcMode = homeState.characteristicData[DataKey.agcMode] ?? '0';
    String alcMode = homeState.characteristicData[DataKey.alcMode] ?? '0';
    String currentInputAttenuation =
        homeState.characteristicData[DataKey.currentDSVVA1] ?? '';
    String currentInputEqualizer =
        homeState.characteristicData[DataKey.currentDSSlope1] ?? '';
    String currentDetectedSplitOption =
        homeState.characteristicData[DataKey.currentDetectedSplitOption] ?? '0';

    List<Widget> getSettingWidgetByModuleId() {
      String moduleName = widget.moduleName;

      if (moduleName == DataKey.splitOption.name) {
        return [const _SplitOption()];
      } else if (moduleName == DataKey.agcMode.name) {
        return [
          const _PilotFrequencyMode(),
          _FirstChannelLoading(
            firstChannelLoadingFrequencyTextEditingController:
                firstChannelLoadingFrequencyTextEditingController,
            firstChannelLoadingLevelTextEditingController:
                firstChannelLoadingLevelTextEditingController,
            currentDetectedSplitOption: currentDetectedSplitOption,
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
      } else if (moduleName == DataKey.dsVVA1.name) {
        return [
          _ForwardInputAttenuation(
            alcMode: alcMode,
            currentInputAttenuation: currentInputAttenuation,
          )
        ];
      } else if (moduleName == DataKey.dsVVA4.name) {
        if (partId == '5') {
          return [const _ForwardOutputAttenuation2And3()];
        } else {
          return [const _ForwardOutputAttenuation3And4()];
        }
      } else if (moduleName == DataKey.dsVVA5.name) {
        return [const _ForwardOutputAttenuation5And6()];
      } else if (moduleName == DataKey.dsSlope1.name) {
        return [
          _ForwardInputEqualizer(
            alcMode: alcMode,
            agcMode: agcMode,
            currentInputEqualizer: currentInputEqualizer,
          )
        ];
      } else if (moduleName == DataKey.dsSlope3.name) {
        return [const _ForwardOutputEqualizer2And3()];
      } else if (moduleName == DataKey.dsSlope4.name) {
        return [const _ForwardOutputEqualizer5And6()];
      } else if (moduleName == DataKey.usVCA1.name) {
        if (partId == '5') {
          return [
            _RtnInputAttenuation4(
              partId: partId,
            )
          ];
        } else {
          return [const _RtnInputAttenuation2()];
        }
      } else if (moduleName == DataKey.usVCA2.name) {
        return [const _RtnOutputLevelAttenuation()];
      } else if (moduleName == DataKey.usVCA3.name) {
        if (partId == '5' || partId == '6') {
          return [const _RtnInputAttenuation2And3()];
        } else {
          return [const _RtnInputAttenuation3()];
        }
      } else if (moduleName == DataKey.usVCA4.name) {
        if (partId == '5' || partId == '6') {
          return [const _RtnInputAttenuation5And6()];
        } else {
          return [
            _RtnInputAttenuation4(
              partId: partId,
            )
          ];
        }
      } else if (moduleName == DataKey.eREQ.name) {
        return [const _RtnOutputEQ()];
      } else {
        return [];
      }

      // switch (widget.moduleName) {
      //   case DataKey.splitOption:
      //     return [const _SplitOption()];
      //   case 1:
      //     return [
      //       _ForwardInputAttenuation(
      //         forwardInputAttenuation1TextEditingController:
      //             forwardInputAttenuation1TextEditingController,
      //       )
      //     ];
      //   case 2:
      //     return [
      //       _ForwardInputEqualizer(
      //         forwardInputEqualizer1TextEditingController:
      //             forwardInputEqualizer1TextEditingController,
      //       )
      //     ];
      //   case 3:
      //     return [];
      //   case 4:
      //     return [];
      //   case 5:
      //     return [];
      //   case 6:
      //     return [];
      //   case 7:
      //     return [];
      //   case 8:
      //     return [];
      //   case 9:
      //     return [];
      //   case 10:
      //     return [
      //       const _PilotFrequencyMode(),
      //       _FirstChannelLoading(
      //         firstChannelLoadingFrequencyTextEditingController:
      //             firstChannelLoadingFrequencyTextEditingController,
      //         firstChannelLoadingLevelTextEditingController:
      //             firstChannelLoadingLevelTextEditingController,
      //       ),
      //       _LastChannelLoading(
      //         lastChannelLoadingFrequencyTextEditingController:
      //             lastChannelLoadingFrequencyTextEditingController,
      //         lastChannelLoadingLevelTextEditingController:
      //             lastChannelLoadingLevelTextEditingController,
      //       ),
      //       _PilotFrequency1(
      //         pilotFrequency1TextEditingController:
      //             pilotFrequency1TextEditingController,
      //         manualModePilot1RFOutputPowerTextEditingController:
      //             manualModePilot1RFOutputPowerTextEditingController,
      //       ),
      //       _PilotFrequency2(
      //         pilotFrequency2TextEditingController:
      //             pilotFrequency2TextEditingController,
      //         manualModePilot2RFOutputPowerTextEditingController:
      //             manualModePilot2RFOutputPowerTextEditingController,
      //       ),
      //     ];
      //   default:
      //     return [];
      // }
    }

    String formatResultValue(String boolValue) {
      return boolValue == 'true'
          ? AppLocalizations.of(context)!.dialogMessageSuccessful
          : AppLocalizations.of(context)!.dialogMessageFailed;
    }

    String formatResultItem(String item) {
      if (item == DataKey.dsVVA1.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardInputAttenuation1Setting;
      } else if (item == DataKey.dsSlope1.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardInputEqualizer1Setting;
      } else if (item == DataKey.usVCA1.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnInputAttenuation2Setting;
      } else if (item == DataKey.usVCA3.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnInputAttenuation3Setting;
      } else if (item == DataKey.usVCA4.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnInputAttenuation4Setting;
      } else if (item == DataKey.usVCA2.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnOutputAttenuation1Setting;
      } else if (item == DataKey.eREQ.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnOutputEqualizer1Setting;
      } else if (item == DataKey.ingressSetting2.name) {
        return AppLocalizations.of(context)!.dialogMessageReturnIngress2Setting;
      } else if (item == DataKey.ingressSetting3.name) {
        return AppLocalizations.of(context)!.dialogMessageReturnIngress3Setting;
      } else if (item == DataKey.ingressSetting4.name) {
        return AppLocalizations.of(context)!.dialogMessageReturnIngress4Setting;
      } else if (item == DataKey.tgcCableLength.name) {
        return AppLocalizations.of(context)!.dialogMessageTGCCableLengthSetting;
      } else if (item == DataKey.dsVVA4.name) {
        if (partId == '5' || partId == '6') {
          return AppLocalizations.of(context)!
              .dialogMessageForwardOutputEqualizer2And3Setting;
        } else {
          return AppLocalizations.of(context)!
              .dialogMessageForwardOutputEqualizer3And4Setting;
        }
      } else if (item == DataKey.splitOption.name) {
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
                right: 4.0,
                bottom: 4.0,
                child: _SettingFloatingActionButton(),
              ),
            ],
          )),
    );
  }
}

class _ForwardInputAttenuation extends StatelessWidget {
  const _ForwardInputAttenuation({
    super.key,
    required this.alcMode,
    required this.currentInputAttenuation,
  });

  final String alcMode;
  final String currentInputAttenuation;

  @override
  Widget build(BuildContext context) {
    // String getCurrentValue(String fwdInputAttenuation) {
    //   return alcMode == '0' ? fwdInputAttenuation : currentInputAttenuation;
    // }

    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        // forwardInputAttenuation1TextEditingController.text = state.dsVVA1;
        double minValue = 0.0;
        double maxValue = 30.0;
        String inputAttenuation = getInputAttenuation(
          alcMode: alcMode,
          inputAttenuation: state.dsVVA1,
          currentInputAttenuation: currentInputAttenuation,
        );
        return controlTextSlider(
          context: context,
          editMode: state.editMode && alcMode == '0',
          title:
              '${AppLocalizations.of(context)!.forwardInputAttenuation1} (${CustomStyle.dB}):',
          minValue: minValue,
          currentValue: inputAttenuation,
          maxValue: maxValue,
          onChanged: (dsVVA1) {
            context.read<Setting18GraphModuleBloc>().add(DSVVA1Changed(
                  dsVVA1: dsVVA1,
                ));
          },
        );
      },
    );
  }
}

class _ForwardInputEqualizer extends StatelessWidget {
  const _ForwardInputEqualizer({
    super.key,
    required this.alcMode,
    required this.agcMode,
    required this.currentInputEqualizer,
  });

  final String alcMode;
  final String agcMode;
  final String currentInputEqualizer;

  @override
  Widget build(BuildContext context) {
    // String getCurrentValue(String forwardInputEqualizer) {
    //   return alcMode == '0' && agcMode == '0'
    //       ? forwardInputEqualizer
    //       : currentInputEqualizer;
    // }

    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 12.0;
        String inputEqualizer = getInputEqualizer(
          alcMode: alcMode,
          agcMode: agcMode,
          inputEqualizer: state.dsSlope1,
          currentInputEqualizer: currentInputEqualizer,
        );
        return controlTextSlider(
          context: context,
          editMode: state.editMode && alcMode == '0' && agcMode == '0',
          title:
              '${AppLocalizations.of(context)!.forwardInputEqualizer1} (${CustomStyle.dB}):',
          minValue: minValue,
          currentValue: inputEqualizer,
          maxValue: maxValue,
          onChanged: (dsSlope1) {
            context.read<Setting18GraphModuleBloc>().add(DSSlope1Changed(
                  dsSlope1: dsSlope1,
                ));
          },
        );
      },
    );
  }
}

class _ForwardOutputAttenuation2And3 extends StatelessWidget {
  const _ForwardOutputAttenuation2And3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 10.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputAttenuation2And3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsVVA4,
          onChanged: (dsVVA4) {
            context.read<Setting18GraphModuleBloc>().add(DSVVA4Changed(
                  dsVVA4: dsVVA4,
                ));
          },
        );
      },
    );
  }
}

class _ForwardOutputAttenuation3And4 extends StatelessWidget {
  const _ForwardOutputAttenuation3And4({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 10.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputAttenuation3And4} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsVVA4,
          onChanged: (dsVVA4) {
            context.read<Setting18GraphModuleBloc>().add(DSVVA4Changed(
                  dsVVA4: dsVVA4,
                ));
          },
        );
      },
    );
  }
}

class _ForwardOutputAttenuation5And6 extends StatelessWidget {
  const _ForwardOutputAttenuation5And6({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 10.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputAttenuation5And6} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsVVA5,
          onChanged: (dsVVA5) {
            context.read<Setting18GraphModuleBloc>().add(DSVVA5Changed(
                  dsVVA5: dsVVA5,
                ));
          },
        );
      },
    );
  }
}

class _ForwardOutputEqualizer2And3 extends StatelessWidget {
  const _ForwardOutputEqualizer2And3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 10.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer2And3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsSlope3,
          onChanged: (dsSlope3) {
            context.read<Setting18GraphModuleBloc>().add(DSSlope3Changed(
                  dsSlope3: dsSlope3,
                ));
          },
        );
      },
    );
  }
}

class _ForwardOutputEqualizer3And4 extends StatelessWidget {
  const _ForwardOutputEqualizer3And4({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 10.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer3And4} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsSlope3,
          onChanged: (dsSlope3) {
            context.read<Setting18GraphModuleBloc>().add(DSSlope3Changed(
                  dsSlope3: dsSlope3,
                ));
          },
        );
      },
    );
  }
}

class _ForwardOutputEqualizer5And6 extends StatelessWidget {
  const _ForwardOutputEqualizer5And6({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 10.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer5And6} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsSlope4,
          onChanged: (dsSlope4) {
            context.read<Setting18GraphModuleBloc>().add(DSSlope4Changed(
                  dsSlope4: dsSlope4,
                ));
          },
        );
      },
    );
  }
}

class _RtnOutputLevelAttenuation extends StatelessWidget {
  const _RtnOutputLevelAttenuation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 15.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnOutputAttenuation1} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.usVCA2,
          onChanged: (usVCA2) {
            context.read<Setting18GraphModuleBloc>().add(USVCA2Changed(
                  usVCA2: usVCA2,
                ));
          },
        );
      },
    );
  }
}

class _RtnOutputEQ extends StatelessWidget {
  const _RtnOutputEQ({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 12.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnOutputEqualizer1} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.eREQ,
          onChanged: (eREQ) {
            context.read<Setting18GraphModuleBloc>().add(EREQChanged(
                  eREQ: eREQ,
                ));
          },
        );
      },
    );
  }
}

class _RtnInputAttenuation2 extends StatelessWidget {
  const _RtnInputAttenuation2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 25.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation2} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.usVCA1,
          onChanged: (usVCA1) {
            context.read<Setting18GraphModuleBloc>().add(USVCA1Changed(
                  usVCA1: usVCA1,
                ));
          },
        );
      },
    );
  }
}

class _RtnInputAttenuation3 extends StatelessWidget {
  const _RtnInputAttenuation3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 25.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.usVCA3,
          onChanged: (usVCA3) {
            context.read<Setting18GraphModuleBloc>().add(USVCA3Changed(
                  usVCA3: usVCA3,
                ));
          },
        );
      },
    );
  }
}

class _RtnInputAttenuation2And3 extends StatelessWidget {
  const _RtnInputAttenuation2And3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 25.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation2And3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.usVCA3,
          onChanged: (usVCA3) {
            context.read<Setting18GraphModuleBloc>().add(USVCA3Changed(
                  usVCA3: usVCA3,
                ));
          },
        );
      },
    );
  }
}

class _RtnInputAttenuation4 extends StatelessWidget {
  const _RtnInputAttenuation4({
    super.key,
    required this.partId,
  });

  final String partId;

  @override
  Widget build(BuildContext context) {
    if (partId == '5') {
      return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
        builder: (context, state) {
          double minValue = 0.0;
          double maxValue = 25.0;
          return controlTextSlider(
            context: context,
            editMode: state.editMode,
            title:
                '${AppLocalizations.of(context)!.returnInputAttenuation4} (${CustomStyle.dB}):',
            minValue: minValue,
            maxValue: maxValue,
            currentValue: state.usVCA1,
            onChanged: (usVCA1) {
              context.read<Setting18GraphModuleBloc>().add(USVCA1Changed(
                    usVCA1: usVCA1,
                  ));
            },
          );
        },
      );
    } else {
      return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
        builder: (context, state) {
          double minValue = 0.0;
          double maxValue = 25.0;
          return controlTextSlider(
            context: context,
            editMode: state.editMode,
            title:
                '${AppLocalizations.of(context)!.returnInputAttenuation4} (${CustomStyle.dB}):',
            minValue: minValue,
            maxValue: maxValue,
            currentValue: state.usVCA4,
            onChanged: (usVCA4) {
              context.read<Setting18GraphModuleBloc>().add(USVCA4Changed(
                    usVCA4: usVCA4,
                  ));
            },
          );
        },
      );
    }
  }
}

class _RtnInputAttenuation5And6 extends StatelessWidget {
  const _RtnInputAttenuation5And6({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 25.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation5And6} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.usVCA4,
          onChanged: (usVCA4) {
            context.read<Setting18GraphModuleBloc>().add(USVCA4Changed(
                  usVCA4: usVCA4,
                ));
          },
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
      return splitOptionGridViewButton(
        context: context,
        editMode: true,
        splitOption: state.splitOption,
        onGridPressed: (index) => context
            .read<Setting18GraphModuleBloc>()
            .add(SplitOptionChanged(splitOption: splitOptionValues[index])),
      );
    });
  }
}

class _PilotFrequencyMode extends StatelessWidget {
  const _PilotFrequencyMode({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<String> pilotFrequencyModeValues = const [
      '0',
      '1',
      // '2',
    ];

    List<String> pilotFrequencyModeTexts = [
      AppLocalizations.of(context)!.pilotFrequencyBandwidthSettings,
      AppLocalizations.of(context)!.pilotFrequencyUserSettings,
      //  AppLocalizations.of(context)!.pilotFrequencySmartSettings,
    ];

    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      buildWhen: (previous, current) =>
          previous.pilotFrequencyMode != current.pilotFrequencyMode ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return gridViewButton(
          context: context,
          crossAxisCount: 1,
          texts: pilotFrequencyModeTexts,
          values: pilotFrequencyModeValues,
          editMode: true,
          pilotFrequencyMode: state.pilotFrequencyMode,
          onGridPressed: (index) => context
              .read<Setting18GraphModuleBloc>()
              .add(PilotFrequencyModeChanged(
                  pilotFrequencyMode: pilotFrequencyModeValues[index])),
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
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
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
                .read<Setting18GraphModuleBloc>()
                .add(FirstChannelLoadingFrequencyChanged(
                  firstChannelLoadingFrequency: firstChannelLoadingFrequency,
                  currentDetectedSplitOption: currentDetectedSplitOption,
                ));
          },
          onChanged2: (firstChannelLoadingLevel) {
            context.read<Setting18GraphModuleBloc>().add(
                FirstChannelLoadingLevelChanged(
                    firstChannelLoadingLevel: firstChannelLoadingLevel));
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
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
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
            context.read<Setting18GraphModuleBloc>().add(
                LastChannelLoadingFrequencyChanged(
                    lastChannelLoadingFrequency: lastChannelLoadingFrequency));
          },
          onChanged2: (lastChannelLoadingLevel) {
            context.read<Setting18GraphModuleBloc>().add(
                LastChannelLoadingLevelChanged(
                    lastChannelLoadingLevel: lastChannelLoadingLevel));
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
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
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
          onChanged1: (pilotFrequency1) {
            context
                .read<Setting18GraphModuleBloc>()
                .add(PilotFrequency1Changed(pilotFrequency1: pilotFrequency1));
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
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
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
          onChanged1: (pilotFrequency2) {
            context
                .read<Setting18GraphModuleBloc>()
                .add(PilotFrequency2Changed(pilotFrequency2: pilotFrequency2));
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
