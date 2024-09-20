import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18_graph_module/setting18_graph_module_bloc.dart';
import 'package:aci_plus_app/setting/model/custom_input.dart';
import 'package:aci_plus_app/setting/model/graph_module_form_color.dart';
import 'package:aci_plus_app/setting/model/confirm_input_dialog.dart';
import 'package:aci_plus_app/setting/model/setting18_result_text.dart';
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

    String forwardCEQIndex =
        homeState.characteristicData[DataKey.currentForwardCEQIndex] ?? '';

    Map<String, List<Widget>> isolatedSettingWidgetsMap = {
      DataKey.splitOption.name: [const _SplitOption()],
    };

    Map<String, List<Widget>> forwardSettingWidgetsMap = {
      DataKey.agcMode.name: [
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
        // const _ALCMode(),
      ],
      DataKey.dsVVA1.name: [
        _ForwardInputAttenuation1(
          alcMode: alcMode,
          agcMode: agcMode,
          currentInputAttenuation: currentInputAttenuation,
        ),
      ],
      DataKey.dsVVA4.name: [
        if (partId == '5' || partId == '6') ...[
          const _ForwardOutputAttenuation2And3()
        ] else if (partId == '8') ...[
          const _ForwardOutputAttenuation3()
        ] else ...[
          const _ForwardOutputAttenuation3And4()
        ]
      ],
      DataKey.dsVVA5.name: [
        if (partId == '5') ...[
          const _ForwardOutputAttenuation5And6(),
        ] else ...[
          const _ForwardOutputAttenuation4()
        ]
      ],
      DataKey.dsSlope1.name: [
        _ForwardInputEqualizer1(
          forwardCEQIndex: forwardCEQIndex,
          alcMode: alcMode,
          agcMode: agcMode,
          currentInputEqualizer: currentInputEqualizer,
        ),
      ],
      DataKey.dsSlope3.name: [
        if (partId == '5' || partId == '6') ...[
          const _ForwardOutputEqualizer2And3(),
        ] else ...[
          const _ForwardOutputEqualizer3()
        ]
      ],
      DataKey.dsSlope4.name: [
        if (partId == '5' || partId == '6') ...[
          const _ForwardOutputEqualizer5And6(),
        ] else ...[
          const _ForwardOutputEqualizer4()
        ]
      ]
    };

    Map<String, List<Widget>> reverseSettingWidgetsMap = {
      DataKey.usVCA1.name: partId == '5'
          ? [
              _ReturnInputAttenuation4(partId: partId),
              _ReturnIngressSetting4(partId: partId),
            ]
          : [
              const _ReturnInputAttenuation2(),
              const _ReturnIngressSetting2(),
            ],
      DataKey.usVCA2.name: [const _ReturnOutputAttenuation1()],
      DataKey.usVCA3.name: partId == '5' || partId == '6'
          ? [
              const _ReturnInputAttenuation2And3(),
              const _ReturnIngressSetting2And3(),
            ]
          : [
              const _ReturnInputAttenuation3(),
              const _ReturnIngressSetting3(),
            ],
      DataKey.usVCA4.name: partId == '5' || partId == '6'
          ? [
              const _ReturnInputAttenuation5And6(),
              const _ReturnIngressSetting5And6(),
            ]
          : [
              _ReturnInputAttenuation4(
                partId: partId,
              ),
              _ReturnIngressSetting4(
                partId: partId,
              ),
            ],
      DataKey.eREQ.name: [const _ReturnOutputEqualizer1()],
    };

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

      List<Widget> isolatedSettingWidgets =
          isolatedSettingWidgetsMap[widget.moduleName] ?? [];
      List<Widget> forwardSettingWidgets =
          forwardSettingWidgetsMap[widget.moduleName] ?? [];
      List<Widget> reverseSettingWidgets =
          reverseSettingWidgetsMap[widget.moduleName] ?? [];
      Widget forwardSettingHeader = getSettingWidgetHeader(
          AppLocalizations.of(context)!.forwardControlParameters);
      Widget reverseSettingHeader = getSettingWidgetHeader(
          AppLocalizations.of(context)!.returnControlParameters);

      if (isolatedSettingWidgets.isNotEmpty) {
        settingWidgets.addAll(isolatedSettingWidgets);
      }

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

    Color getBackgroundColor() {
      bool isIsolatedWidget =
          isolatedSettingWidgetsMap.keys.contains(widget.moduleName);

      bool isForwardWidget =
          forwardSettingWidgetsMap.keys.contains(widget.moduleName);

      bool isReverseWidget =
          reverseSettingWidgetsMap.keys.contains(widget.moduleName);

      return getGraphModuleFormBackgroundColor(
        context: context,
        isIsolatedWidget: isIsolatedWidget,
        isForwardWidget: isForwardWidget,
        isReverseWidget: isReverseWidget,
      );
    }

    return BlocListener<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      listener: (context, state) async {
        if (state.submissionStatus.isSubmissionInProgress) {
          await showInProgressDialog(context);
        } else if (state.submissionStatus.isSubmissionSuccess) {
          if (ModalRoute.of(context)?.isCurrent != true) {
            Navigator.of(context).pop();
          }
          List<Widget> rows = get1P8GSettingMessageRows(
            context: context,
            partId: partId,
            settingResultList: state.settingResult,
          );
          showResultDialog(
            context: context,
            messageRows: rows,
          );

          context.read<Setting18GraphModuleBloc>().add(const Initialized());
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
      child: Container(
        decoration: BoxDecoration(
          color: getBackgroundColor(),
        ),
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
          ),
        ),
      ),
    );
  }
}

class _ForwardInputAttenuation1 extends StatelessWidget {
  const _ForwardInputAttenuation1({
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
        double minValue = state.dsVVA1.minValue;
        double maxValue = state.dsVVA1.maxValue;
        String inputAttenuation = getInputAttenuation(
          alcMode: alcMode,
          inputAttenuation: state.dsVVA1.value,
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
              errorText: state.dsVVA1.isNotValid
                  ? AppLocalizations.of(context)!.textFieldErrorMessage
                  : null,
              elevation: CustomStyle.graphSettingCardElevation,
              color: CustomStyle.graphSettingCardColor,
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

class _ForwardInputEqualizer1 extends StatelessWidget {
  const _ForwardInputEqualizer1({
    required this.forwardCEQIndex,
    required this.alcMode,
    required this.agcMode,
    required this.currentInputEqualizer,
  });

  final String forwardCEQIndex;
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
        double minValue = state.dsSlope1.minValue;
        double maxValue = state.dsSlope1.maxValue;
        String inputEqualizer = getInputEqualizer(
          alcMode: alcMode,
          agcMode: agcMode,
          inputEqualizer: state.dsSlope1.value,
          currentInputEqualizer: currentInputEqualizer,
        );
        return Column(
          children: [
            controlTextSlider(
              context: context,
              editMode: state.editMode && alcMode == '0' && agcMode == '0',
              title:
                  '${AppLocalizations.of(context)!.forwardInputEqualizer1} (${CustomStyle.dB}):',
              subTitle: getForwardCEQText(forwardCEQIndex),
              minValue: minValue,
              currentValue: inputEqualizer,
              maxValue: maxValue,
              onChanged: (dsSlope1) {
                context.read<Setting18GraphModuleBloc>().add(DSSlope1Changed(
                      dsSlope1: dsSlope1,
                    ));
              },
              errorText: state.dsSlope1.isNotValid
                  ? AppLocalizations.of(context)!.textFieldErrorMessage
                  : null,
              elevation: CustomStyle.graphSettingCardElevation,
              color: CustomStyle.graphSettingCardColor,
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

class _ForwardOutputEqualizer3 extends StatelessWidget {
  const _ForwardOutputEqualizer3();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = state.dsSlope3.minValue;
        double maxValue = state.dsSlope3.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsSlope3.value,
          onChanged: (dsSlope3) {
            context.read<Setting18GraphModuleBloc>().add(DSSlope3Changed(
                  dsSlope3: dsSlope3,
                ));
          },
          errorText: state.dsSlope3.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

class _ForwardOutputEqualizer4 extends StatelessWidget {
  const _ForwardOutputEqualizer4();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = state.dsSlope4.minValue;
        double maxValue = state.dsSlope4.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer4} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsSlope4.value,
          onChanged: (dsSlope4) {
            context.read<Setting18GraphModuleBloc>().add(DSSlope4Changed(
                  dsSlope4: dsSlope4,
                ));
          },
          errorText: state.dsSlope4.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

class _ForwardOutputAttenuation3 extends StatelessWidget {
  const _ForwardOutputAttenuation3();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = state.dsVVA4.minValue;
        double maxValue = state.dsVVA4.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputAttenuation3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsVVA4.value,
          onChanged: (dsVVA4) {
            context.read<Setting18GraphModuleBloc>().add(DSVVA4Changed(
                  dsVVA4: dsVVA4,
                ));
          },
          errorText: state.dsVVA4.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

class _ForwardOutputAttenuation4 extends StatelessWidget {
  const _ForwardOutputAttenuation4();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = state.dsVVA5.minValue;
        double maxValue = state.dsVVA5.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputAttenuation4} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsVVA5.value,
          onChanged: (dsVVA5) {
            context.read<Setting18GraphModuleBloc>().add(DSVVA5Changed(
                  dsVVA5: dsVVA5,
                ));
          },
          errorText: state.dsVVA5.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

class _ForwardOutputAttenuation2And3 extends StatelessWidget {
  const _ForwardOutputAttenuation2And3();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = state.dsVVA4.minValue;
        double maxValue = state.dsVVA4.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputAttenuation2And3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsVVA4.value,
          onChanged: (dsVVA4) {
            context.read<Setting18GraphModuleBloc>().add(DSVVA4Changed(
                  dsVVA4: dsVVA4,
                ));
          },
          errorText: state.dsVVA4.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

class _ForwardOutputAttenuation3And4 extends StatelessWidget {
  const _ForwardOutputAttenuation3And4();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = state.dsVVA4.minValue;
        double maxValue = state.dsVVA4.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputAttenuation3And4} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsVVA4.value,
          onChanged: (dsVVA4) {
            context.read<Setting18GraphModuleBloc>().add(DSVVA4Changed(
                  dsVVA4: dsVVA4,
                ));
          },
          errorText: state.dsVVA4.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

class _ForwardOutputAttenuation5And6 extends StatelessWidget {
  const _ForwardOutputAttenuation5And6();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = state.dsVVA5.minValue;
        double maxValue = state.dsVVA5.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputAttenuation5And6} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsVVA5.value,
          onChanged: (dsVVA5) {
            context.read<Setting18GraphModuleBloc>().add(DSVVA5Changed(
                  dsVVA5: dsVVA5,
                ));
          },
          errorText: state.dsVVA5.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

class _ForwardOutputEqualizer2And3 extends StatelessWidget {
  const _ForwardOutputEqualizer2And3();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = state.dsSlope3.minValue;
        double maxValue = state.dsSlope3.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer2And3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsSlope3.value,
          onChanged: (dsSlope3) {
            context.read<Setting18GraphModuleBloc>().add(DSSlope3Changed(
                  dsSlope3: dsSlope3,
                ));
          },
          errorText: state.dsSlope3.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

class _ForwardOutputEqualizer3And4 extends StatelessWidget {
  const _ForwardOutputEqualizer3And4();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = state.dsSlope3.minValue;
        double maxValue = state.dsSlope3.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer3And4} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsSlope3.value,
          onChanged: (dsSlope3) {
            context.read<Setting18GraphModuleBloc>().add(DSSlope3Changed(
                  dsSlope3: dsSlope3,
                ));
          },
          errorText: state.dsSlope3.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

class _ForwardOutputEqualizer5And6 extends StatelessWidget {
  const _ForwardOutputEqualizer5And6();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = state.dsSlope4.minValue;
        double maxValue = state.dsSlope4.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer5And6} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsSlope4.value,
          onChanged: (dsSlope4) {
            context.read<Setting18GraphModuleBloc>().add(DSSlope4Changed(
                  dsSlope4: dsSlope4,
                ));
          },
          errorText: state.dsSlope4.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

class _ReturnOutputAttenuation1 extends StatelessWidget {
  const _ReturnOutputAttenuation1();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = state.usVCA2.minValue;
        double maxValue = state.usVCA2.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnOutputAttenuation1} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.usVCA2.value,
          onChanged: (usVCA2) {
            context.read<Setting18GraphModuleBloc>().add(USVCA2Changed(
                  usVCA2: usVCA2,
                ));
          },
          errorText: state.usVCA2.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

class _ReturnOutputEqualizer1 extends StatelessWidget {
  const _ReturnOutputEqualizer1();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = state.eREQ.minValue;
        double maxValue = state.eREQ.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnOutputEqualizer1} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.eREQ.value,
          onChanged: (eREQ) {
            context.read<Setting18GraphModuleBloc>().add(EREQChanged(
                  eREQ: eREQ,
                ));
          },
          errorText: state.eREQ.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

class _ReturnInputAttenuation2 extends StatelessWidget {
  const _ReturnInputAttenuation2();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = state.usVCA1.minValue;
        double maxValue = state.usVCA1.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation2} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.usVCA1.value,
          onChanged: (usVCA1) {
            context.read<Setting18GraphModuleBloc>().add(USVCA1Changed(
                  usVCA1: usVCA1,
                ));
          },
          errorText: state.usVCA1.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

class _ReturnInputAttenuation3 extends StatelessWidget {
  const _ReturnInputAttenuation3();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = state.usVCA3.minValue;
        double maxValue = state.usVCA3.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.usVCA3.value,
          onChanged: (usVCA3) {
            context.read<Setting18GraphModuleBloc>().add(USVCA3Changed(
                  usVCA3: usVCA3,
                ));
          },
          errorText: state.usVCA3.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

class _ReturnInputAttenuation2And3 extends StatelessWidget {
  const _ReturnInputAttenuation2And3();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = state.usVCA3.minValue;
        double maxValue = state.usVCA3.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation2And3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.usVCA3.value,
          onChanged: (usVCA3) {
            context.read<Setting18GraphModuleBloc>().add(USVCA3Changed(
                  usVCA3: usVCA3,
                ));
          },
          errorText: state.usVCA3.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

class _ReturnInputAttenuation4 extends StatelessWidget {
  const _ReturnInputAttenuation4({
    required this.partId,
  });

  final String partId;

  @override
  Widget build(BuildContext context) {
    if (partId == '5') {
      return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
        builder: (context, state) {
          double minValue = state.usVCA1.minValue;
          double maxValue = state.usVCA1.maxValue;
          return controlTextSlider(
            context: context,
            editMode: state.editMode,
            title:
                '${AppLocalizations.of(context)!.returnInputAttenuation4} (${CustomStyle.dB}):',
            minValue: minValue,
            maxValue: maxValue,
            currentValue: state.usVCA1.value,
            onChanged: (usVCA1) {
              context.read<Setting18GraphModuleBloc>().add(USVCA1Changed(
                    usVCA1: usVCA1,
                  ));
            },
            errorText: state.usVCA1.isNotValid
                ? AppLocalizations.of(context)!.textFieldErrorMessage
                : null,
            elevation: CustomStyle.graphSettingCardElevation,
            color: CustomStyle.graphSettingCardColor,
          );
        },
      );
    } else {
      return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
        builder: (context, state) {
          double minValue = state.usVCA4.minValue;
          double maxValue = state.usVCA4.maxValue;
          return controlTextSlider(
            context: context,
            editMode: state.editMode,
            title:
                '${AppLocalizations.of(context)!.returnInputAttenuation4} (${CustomStyle.dB}):',
            minValue: minValue,
            maxValue: maxValue,
            currentValue: state.usVCA4.value,
            onChanged: (usVCA4) {
              context.read<Setting18GraphModuleBloc>().add(USVCA4Changed(
                    usVCA4: usVCA4,
                  ));
            },
            errorText: state.usVCA4.isNotValid
                ? AppLocalizations.of(context)!.textFieldErrorMessage
                : null,
            elevation: CustomStyle.graphSettingCardElevation,
            color: CustomStyle.graphSettingCardColor,
          );
        },
      );
    }
  }
}

class _ReturnInputAttenuation5And6 extends StatelessWidget {
  const _ReturnInputAttenuation5And6();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = state.usVCA4.minValue;
        double maxValue = state.usVCA4.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation5And6} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.usVCA4.value,
          onChanged: (usVCA4) {
            context.read<Setting18GraphModuleBloc>().add(USVCA4Changed(
                  usVCA4: usVCA4,
                ));
          },
          errorText: state.usVCA4.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

class _SplitOption extends StatelessWidget {
  const _SplitOption();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
        builder: (context, state) {
      return splitOptionGridViewButton(
        context: context,
        editMode: state.editMode,
        splitOption: state.splitOption,
        onGridPressed: (index) => context
            .read<Setting18GraphModuleBloc>()
            .add(SplitOptionChanged(splitOption: splitOptionValues[index])),
        elevation: CustomStyle.graphSettingCardElevation,
        color: CustomStyle.graphSettingCardColor,
      );
    });
  }
}

class _PilotFrequencyMode extends StatelessWidget {
  const _PilotFrequencyMode();

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
          editMode: state.editMode,
          pilotFrequencyMode: state.pilotFrequencyMode,
          onGridPressed: (index) => context
              .read<Setting18GraphModuleBloc>()
              .add(PilotFrequencyModeChanged(
                  pilotFrequencyMode: pilotFrequencyModeValues[index])),
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
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
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
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
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
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
          errorText1: _isNotValidFrequency(
            pilotFrequencyMode: state.pilotFrequencyMode,
            firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
            lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
            pilotFrequency1: state.pilotFrequency1,
            pilotFrequency2: state.pilotFrequency2,
          )
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
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
          errorText1: _isNotValidFrequency(
            pilotFrequencyMode: state.pilotFrequencyMode,
            firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
            lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
            pilotFrequency1: state.pilotFrequency1,
            pilotFrequency2: state.pilotFrequency2,
          )
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
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
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
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
                .read<Setting18GraphModuleBloc>()
                .add(AGCModeChanged(fwdAGCModeValues[index]));
          },
          values: fwdAGCModeValues,
          texts: [
            AppLocalizations.of(context)!.on,
            AppLocalizations.of(context)!.off,
          ],
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
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

class _ReturnIngressSetting2 extends StatelessWidget {
  const _ReturnIngressSetting2();

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
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

class _ReturnIngressSetting3 extends StatelessWidget {
  const _ReturnIngressSetting3();

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
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

class _ReturnIngressSetting4 extends StatelessWidget {
  const _ReturnIngressSetting4({
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
            elevation: CustomStyle.graphSettingCardElevation,
            color: CustomStyle.graphSettingCardColor,
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
            elevation: CustomStyle.graphSettingCardElevation,
            color: CustomStyle.graphSettingCardColor,
          );
        },
      );
    }
  }
}

class _ReturnIngressSetting2And3 extends StatelessWidget {
  const _ReturnIngressSetting2And3();

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
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

class _ReturnIngressSetting5And6 extends StatelessWidget {
  const _ReturnIngressSetting5And6();

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
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

class _SettingFloatingActionButton extends StatelessWidget {
  const _SettingFloatingActionButton();

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
