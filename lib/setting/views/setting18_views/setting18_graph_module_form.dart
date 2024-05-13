import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18_graph_module/setting18_graph_module_bloc.dart';
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

    List<Widget> getForwardSettingWidgetByModuleId() {
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
          const _AGCMode(),
          const _ALCMode(),
        ];
      } else if (moduleName == DataKey.dsVVA1.name) {
        return [
          _ForwardInputAttenuation(
            alcMode: alcMode,
            agcMode: agcMode,
            currentInputAttenuation: currentInputAttenuation,
          ),
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
      } else {
        return [];
      }
    }

    List<Widget> getReverseSettingWidgetByModuleId() {
      String moduleName = widget.moduleName;

      if (moduleName == DataKey.usVCA1.name) {
        if (partId == '5') {
          return [
            _RtnInputAttenuation4(partId: partId),
            _RtnIngressSetting4(partId: partId),
          ];
        } else {
          return [
            const _RtnInputAttenuation2(),
            const _RtnIngressSetting2(),
          ];
        }
      } else if (moduleName == DataKey.usVCA2.name) {
        return [const _RtnOutputLevelAttenuation()];
      } else if (moduleName == DataKey.usVCA3.name) {
        if (partId == '5' || partId == '6') {
          return [
            const _RtnInputAttenuation2And3(),
            const _RtnIngressSetting2And3(),
          ];
        } else {
          return [
            const _RtnInputAttenuation3(),
            const _RtnIngressSetting3(),
          ];
        }
      } else if (moduleName == DataKey.usVCA4.name) {
        if (partId == '5' || partId == '6') {
          return [
            const _RtnInputAttenuation5And6(),
            const _RtnIngressSetting5And6(),
          ];
        } else {
          return [
            _RtnInputAttenuation4(
              partId: partId,
            ),
            _RtnIngressSetting4(
              partId: partId,
            ),
          ];
        }
      } else if (moduleName == DataKey.eREQ.name) {
        return [const _RtnOutputEQ()];
      } else {
        return [];
      }
    }

    String formatResultValue(String boolValue) {
      return boolValue == 'true'
          ? AppLocalizations.of(context)!.dialogMessageSuccessful
          : AppLocalizations.of(context)!.dialogMessageFailed;
    }

    String formatResultItem(String item) {
      if (item == DataKey.splitOption.name) {
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
      } else if (item == DataKey.agcMode.name) {
        return AppLocalizations.of(context)!.dialogMessageAGCModeSetting;
      } else if (item == DataKey.alcMode.name) {
        return AppLocalizations.of(context)!.dialogMessageALCModeSetting;
      }
      if (item == DataKey.dsVVA1.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardInputAttenuation1Setting;
      } else if (item == DataKey.dsVVA4.name) {
        if (partId == '5' || partId == '6') {
          return AppLocalizations.of(context)!
              .dialogMessageForwardOutputAttenuation2And3Setting;
        } else {
          return AppLocalizations.of(context)!
              .dialogMessageForwardOutputEqualizer3And4Setting;
        }
      } else if (item == DataKey.dsVVA5.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardOutputAttenuation5And6Setting;
      } else if (item == DataKey.dsSlope1.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardInputEqualizer1Setting;
      } else if (item == DataKey.dsSlope3.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardInputEqualizer3Setting;
      } else if (item == DataKey.dsSlope4.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardInputEqualizer4Setting;
      } else if (item == DataKey.tgcCableLength.name) {
        return AppLocalizations.of(context)!.dialogMessageTGCCableLengthSetting;
      } else if (item == DataKey.usVCA1.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnInputAttenuation2Setting;
      } else if (item == DataKey.usVCA2.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnOutputAttenuation1Setting;
      } else if (item == DataKey.usVCA3.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnInputAttenuation3Setting;
      } else if (item == DataKey.usVCA4.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnInputAttenuation4Setting;
      } else if (item == DataKey.eREQ.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnOutputEqualizer1Setting;
      } else if (item == DataKey.ingressSetting2.name) {
        if (partId == '5' || partId == '6') {
          return AppLocalizations.of(context)!
              .dialogMessageReturnIngress4Setting;
        } else {
          return AppLocalizations.of(context)!
              .dialogMessageReturnIngress2Setting;
        }
      } else if (item == DataKey.ingressSetting3.name) {
        if (partId == '5' || partId == '6') {
          return AppLocalizations.of(context)!
              .dialogMessageReturnIngress2And3Setting;
        } else {
          return AppLocalizations.of(context)!
              .dialogMessageReturnIngress3Setting;
        }
      } else if (item == DataKey.ingressSetting4.name) {
        if (partId == '5' || partId == '6') {
          return AppLocalizations.of(context)!
              .dialogMessageReturnIngress5And6Setting;
        } else {
          return AppLocalizations.of(context)!
              .dialogMessageReturnIngress4Setting;
        }
      } else {
        return '';
      }
    }

    Widget getSettingWidgetHeader(String title) {
      return Padding(
        padding: const EdgeInsets.only(
          bottom: 16,
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: CustomStyle.sizeXL,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      );
    }

    List<Widget> getSettingWidgetByModuleId() {
      List<Widget> settingWidgets = [];
      List<Widget> forwardSettingWidgets = getForwardSettingWidgetByModuleId();
      List<Widget> reverseSettingWidgets = getReverseSettingWidgetByModuleId();
      Widget forwardSettingHeader = getSettingWidgetHeader(
          AppLocalizations.of(context)!.forwardControlParameters);
      Widget reverseSettingHeader = getSettingWidgetHeader(
          AppLocalizations.of(context)!.returnControlParameters);

      if (forwardSettingWidgets.isNotEmpty) {
        settingWidgets.add(forwardSettingHeader);
        settingWidgets.addAll(forwardSettingWidgets);
      }

      if (reverseSettingWidgets.isNotEmpty) {
        settingWidgets.add(reverseSettingHeader);
        settingWidgets.addAll(reverseSettingWidgets);
      }

      return settingWidgets;
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
    required this.agcMode,
    required this.currentInputAttenuation,
  });

  final String alcMode;
  final String agcMode;
  final String currentInputAttenuation;

  @override
  Widget build(BuildContext context) {
    Map<String, String> agcModeText = {
      '0': AppLocalizations.of(context)!.off,
      '1': AppLocalizations.of(context)!.on,
    };

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
        return Column(
          children: [
            controlTextSlider(
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
            ),
            Row(
              children: [
                Text(
                  '${AppLocalizations.of(context)!.agcMode}: ${agcModeText[agcMode]}',
                  style: const TextStyle(
                    fontSize: CustomStyle.sizeXL,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
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
    Map<String, String> agcModeText = {
      '0': AppLocalizations.of(context)!.off,
      '1': AppLocalizations.of(context)!.on,
    };

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
        return Column(
          children: [
            controlTextSlider(
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
            ),
            Row(
              children: [
                Text(
                  '${AppLocalizations.of(context)!.agcMode}: ${agcModeText[agcMode]}',
                  style: const TextStyle(
                    fontSize: CustomStyle.sizeXL,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
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
        return pilotFrequencyModeGridViewButton(
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

class _AGCMode extends StatelessWidget {
  const _AGCMode({
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
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      buildWhen: (previous, current) =>
          previous.agcMode != current.agcMode ||
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
                          .read<Setting18GraphModuleBloc>()
                          .add(AGCModeChanged(fwdAGCModeValues[index]));
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
                  isSelected: getSelectionState(state.agcMode),
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

// 2024/0419 ALC 為 read only 且 ALC 的動作跟 AGC 連動
class _ALCMode extends StatelessWidget {
  const _ALCMode({
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
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
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
                    //   context.read<Setting18GraphModuleBloc>().add(
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

const List<String> rtnIngressValues = [
  '0',
  '1',
  '2',
  '4',
];

const List<String> tgcCableLengthValues = [
  '9',
  '18',
  '27',
];

class _RtnIngressSetting2 extends StatelessWidget {
  const _RtnIngressSetting2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      buildWhen: (previous, current) =>
          previous.returnIngressSetting2 != current.returnIngressSetting2 ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return controlToggleButton(
          context: context,
          editMode: state.editMode,
          title: '${AppLocalizations.of(context)!.returnIngressSetting2}:',
          currentValue: state.returnIngressSetting2,
          onChanged: (int index) {
            context.read<Setting18GraphModuleBloc>().add(
                RtnIngressSetting2Changed(
                    returnIngressSetting2: rtnIngressValues[index]));
          },
          values: rtnIngressValues,
          texts: [
            '0dB',
            '-3dB',
            '-6dB',
            AppLocalizations.of(context)!.ingressOpen,
          ],
        );
      },
    );
  }
}

class _RtnIngressSetting3 extends StatelessWidget {
  const _RtnIngressSetting3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      buildWhen: (previous, current) =>
          previous.returnIngressSetting3 != current.returnIngressSetting3 ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return controlToggleButton(
          context: context,
          editMode: state.editMode,
          title: '${AppLocalizations.of(context)!.returnIngressSetting3}:',
          currentValue: state.returnIngressSetting3,
          onChanged: (int index) {
            context.read<Setting18GraphModuleBloc>().add(
                RtnIngressSetting3Changed(
                    returnIngressSetting3: rtnIngressValues[index]));
          },
          values: rtnIngressValues,
          texts: [
            '0dB',
            '-3dB',
            '-6dB',
            AppLocalizations.of(context)!.ingressOpen,
          ],
        );
      },
    );
  }
}

class _RtnIngressSetting4 extends StatelessWidget {
  const _RtnIngressSetting4({
    super.key,
    required this.partId,
  });

  final String partId;

  @override
  Widget build(BuildContext context) {
    if (partId == '5') {
      return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
        buildWhen: (previous, current) =>
            previous.returnIngressSetting2 != current.returnIngressSetting2 ||
            previous.editMode != current.editMode,
        builder: (context, state) {
          return controlToggleButton(
            context: context,
            editMode: state.editMode,
            title: '${AppLocalizations.of(context)!.returnIngressSetting4}:',
            currentValue: state.returnIngressSetting2,
            onChanged: (int index) {
              context.read<Setting18GraphModuleBloc>().add(
                  RtnIngressSetting2Changed(
                      returnIngressSetting2: rtnIngressValues[index]));
            },
            values: rtnIngressValues,
            texts: [
              '0dB',
              '-3dB',
              '-6dB',
              AppLocalizations.of(context)!.ingressOpen,
            ],
          );
        },
      );
    } else {
      return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
        buildWhen: (previous, current) =>
            previous.returnIngressSetting4 != current.returnIngressSetting4 ||
            previous.editMode != current.editMode,
        builder: (context, state) {
          return controlToggleButton(
            context: context,
            editMode: state.editMode,
            title: '${AppLocalizations.of(context)!.returnIngressSetting4}:',
            currentValue: state.returnIngressSetting4,
            onChanged: (int index) {
              context.read<Setting18GraphModuleBloc>().add(
                  RtnIngressSetting4Changed(
                      returnIngressSetting4: rtnIngressValues[index]));
            },
            values: rtnIngressValues,
            texts: [
              '0dB',
              '-3dB',
              '-6dB',
              AppLocalizations.of(context)!.ingressOpen,
            ],
          );
        },
      );
    }
  }
}

class _RtnIngressSetting2And3 extends StatelessWidget {
  const _RtnIngressSetting2And3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      buildWhen: (previous, current) =>
          previous.returnIngressSetting3 != current.returnIngressSetting3 ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return controlToggleButton(
          context: context,
          editMode: state.editMode,
          title: '${AppLocalizations.of(context)!.returnIngressSetting2And3}:',
          currentValue: state.returnIngressSetting3,
          onChanged: (int index) {
            context.read<Setting18GraphModuleBloc>().add(
                RtnIngressSetting3Changed(
                    returnIngressSetting3: rtnIngressValues[index]));
          },
          values: rtnIngressValues,
          texts: [
            '0dB',
            '-3dB',
            '-6dB',
            AppLocalizations.of(context)!.ingressOpen,
          ],
        );
      },
    );
  }
}

class _RtnIngressSetting5And6 extends StatelessWidget {
  const _RtnIngressSetting5And6({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      buildWhen: (previous, current) =>
          previous.returnIngressSetting4 != current.returnIngressSetting4 ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return controlToggleButton(
          context: context,
          editMode: state.editMode,
          title: '${AppLocalizations.of(context)!.returnIngressSetting5And6}:',
          currentValue: state.returnIngressSetting4,
          onChanged: (int index) {
            context.read<Setting18GraphModuleBloc>().add(
                RtnIngressSetting4Changed(
                    returnIngressSetting4: rtnIngressValues[index]));
          },
          values: rtnIngressValues,
          texts: [
            '0dB',
            '-3dB',
            '-6dB',
            AppLocalizations.of(context)!.ingressOpen,
          ],
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
