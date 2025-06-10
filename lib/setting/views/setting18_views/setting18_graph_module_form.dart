import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18_graph_module/setting18_graph_module_bloc.dart';
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
  late final TextEditingController pilotFrequency1TextEditingController;
  late final TextEditingController pilotFrequency2TextEditingController;
  late final TextEditingController
      manualModePilot1RFOutputPowerTextEditingController;
  late final TextEditingController
      manualModePilot2RFOutputPowerTextEditingController;

  @override
  void initState() {
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
    String agcMode = homeState.characteristicData[DataKey.agcMode] ?? '0';
    String currentInputAttenuation =
        homeState.characteristicData[DataKey.currentDSVVA1] ?? '';
    String currentInputEqualizer =
        homeState.characteristicData[DataKey.currentDSSlope1] ?? '';
    String currentDetectedSplitOption =
        homeState.characteristicData[DataKey.currentDetectedSplitOption] ?? '0';

    String forwardCEQIndex =
        homeState.characteristicData[DataKey.currentForwardCEQIndex] ?? '';

    String pilotFrequencyMode =
        homeState.characteristicData[DataKey.pilotFrequencyMode] ?? '0';

    bool isEnableForwardSetting = getForwardSettingEditable(
      pilotFrequencyMode: pilotFrequencyMode,
      agcMode: agcMode,
    );

    // Map<String, List<Widget>> isolatedSettingWidgetsMap = {
    //   DataKey.splitOption.name: [const _SplitOption()],
    // };

    Map<String, List<Widget>> forwardSettingWidgetsMap = {
      DataKey.agcMode.name: [
        _PilotFrequencyMode(
          partId: partId,
          currentDetectedSplitOption: currentDetectedSplitOption,
        ),
        _FirstChannelLoading(
          currentDetectedSplitOption: currentDetectedSplitOption,
        ),
        const _LastChannelLoading(),

        const _RFLevelFineTuner(),

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
          pilotFrequencyMode: pilotFrequencyMode,
          agcMode: agcMode,
          currentInputAttenuation: currentInputAttenuation,
        ),
      ],
      DataKey.dsVVA4.name: [
        if (partId == '5' || partId == '6') ...[
          _ForwardOutputAttenuation2And3(
            isEnableForwardSetting: isEnableForwardSetting,
          )
        ] else if (partId == '8') ...[
          _ForwardOutputAttenuation3(
            isEnableForwardSetting: isEnableForwardSetting,
          )
        ] else ...[
          _ForwardOutputAttenuation3And4(
            isEnableForwardSetting: isEnableForwardSetting,
          )
        ]
      ],
      DataKey.dsVVA5.name: [
        if (partId == '5' || partId == '6') ...[
          _ForwardOutputAttenuation5And6(
            partId: partId,
            agcMode: agcMode,
            pilotFrequencyMode: pilotFrequencyMode,
            isEnableForwardSetting: isEnableForwardSetting,
          ),
        ] else ...[
          // SDAT
          _ForwardOutputAttenuation4(
            isEnableForwardSetting: isEnableForwardSetting,
          )
        ]
      ],
      DataKey.dsSlope1.name: [
        _ForwardInputEqualizer1(
          forwardCEQIndex: forwardCEQIndex,
          pilotFrequencyMode: pilotFrequencyMode,
          agcMode: agcMode,
          currentInputEqualizer: currentInputEqualizer,
        ),
      ],
      DataKey.dsSlope3.name: [
        if (partId == '5' || partId == '6') ...[
          _ForwardOutputEqualizer2And3(
            isEnableForwardSetting: isEnableForwardSetting,
          ),
        ] else ...[
          _ForwardOutputEqualizer3(
            isEnableForwardSetting: isEnableForwardSetting,
          )
        ]
      ],
      DataKey.dsSlope4.name: [
        if (partId == '5' || partId == '6') ...[
          _ForwardOutputEqualizer5And6(
            partId: partId,
            agcMode: agcMode,
            pilotFrequencyMode: pilotFrequencyMode,
            isEnableForwardSetting: isEnableForwardSetting,
          ),
        ] else ...[
          _ForwardOutputEqualizer4(
            isEnableForwardSetting: isEnableForwardSetting,
          )
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

      // List<Widget> isolatedSettingWidgets =
      //     isolatedSettingWidgetsMap[widget.moduleName] ?? [];
      List<Widget> forwardSettingWidgets =
          forwardSettingWidgetsMap[widget.moduleName] ?? [];
      List<Widget> reverseSettingWidgets =
          reverseSettingWidgetsMap[widget.moduleName] ?? [];
      Widget forwardSettingHeader = getSettingWidgetHeader(
          AppLocalizations.of(context)!.forwardControlParameters);
      Widget reverseSettingHeader = getSettingWidgetHeader(
          AppLocalizations.of(context)!.returnControlParameters);

      // if (isolatedSettingWidgets.isNotEmpty) {
      //   settingWidgets.addAll(isolatedSettingWidgets);
      // }

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
      // bool isIsolatedWidget =
      //     isolatedSettingWidgetsMap.keys.contains(widget.moduleName);

      bool isForwardWidget =
          forwardSettingWidgetsMap.keys.contains(widget.moduleName);

      bool isReverseWidget =
          reverseSettingWidgetsMap.keys.contains(widget.moduleName);

      return getGraphModuleFormBackgroundColor(
        context: context,
        // isIsolatedWidget: isIsolatedWidget,
        isForwardWidget: isForwardWidget,
        isReverseWidget: isReverseWidget,
      );
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<Setting18GraphModuleBloc, Setting18GraphModuleState>(
          listenWhen: (previous, current) =>
              previous.submissionStatus != current.submissionStatus,
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
          },
        ),
        BlocListener<Setting18GraphModuleBloc, Setting18GraphModuleState>(
          listenWhen: (previous, current) =>
              previous.isInitialize != current.isInitialize,
          listener: (context, state) {
            if (state.isInitialize) {
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
        ),
        BlocListener<Setting18GraphModuleBloc, Setting18GraphModuleState>(
          listenWhen: (previous, current) =>
              previous.isInitialPilotFrequencyLevelValues !=
              current.isInitialPilotFrequencyLevelValues,
          listener: (context, state) {
            if (state.isInitialPilotFrequencyLevelValues) {
              pilotFrequency1TextEditingController.text =
                  state.pilotFrequency1.value;
              pilotFrequency2TextEditingController.text =
                  state.pilotFrequency2.value;
            }
          },
        ),
        BlocListener<Setting18GraphModuleBloc, Setting18GraphModuleState>(
          listenWhen: (previous, current) =>
              previous.forwardCEQStatus != current.forwardCEQStatus,
          listener: (context, state) {
            // 向 device 取得 CEQ index 後, forwardCEQStatus 就會變成 isRequestSuccess,
            // 再判斷 isForwardCEQIndexChanged 是否為 true
            // 接者跳出 Dialog 前判斷 Dialog 是否還在畫面中, 還在畫面中就不重複跳, 否則會一直疊加到畫面上
            if (state.forwardCEQStatus.isRequestSuccess) {
              if (state.isForwardCEQIndexChanged) {
                if (ModalRoute.of(context)?.isCurrent == true) {
                  showCurrentForwardCEQChangedDialog(context).then((_) {
                    context
                        .read<Setting18GraphModuleBloc>()
                        .add(const Initialized(useCache: false));
                  });
                }
              }
            }
          },
        )
      ],
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
    required this.pilotFrequencyMode,
    required this.agcMode,
    required this.currentInputAttenuation,
  });

  final String pilotFrequencyMode;
  final String agcMode;
  final String currentInputAttenuation;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        // forwardInputAttenuation1TextEditingController.text = state.dsVVA1;
        double minValue = state.targetValues[DataKey.dsVVA1]?.minValue ?? 0.0;
        double maxValue = state.targetValues[DataKey.dsVVA1]?.maxValue ?? 10.0;
        String inputAttenuation = getInputAttenuation(
          pilotFrequencyMode: pilotFrequencyMode,
          agcMode: agcMode,
          inputAttenuation: state.targetValues[DataKey.dsVVA1]?.value ?? '0.0',
          currentInputAttenuation: currentInputAttenuation,
        );
        String agcModeText = getAgcModeText(
          context: context,
          agcMode: state.agcMode,
        );

        bool isEnableForwardInputSetting = getForwardInputSettingEditable(
          pilotFrequencyMode: pilotFrequencyMode,
          agcMode: agcMode,
        );

        return Column(
          children: [
            controlTextSlider(
              context: context,
              editMode: ModeProperty.isExpertMode
                  ? state.editMode && isEnableForwardInputSetting
                  : false,
              title:
                  '${AppLocalizations.of(context)!.forwardInputAttenuation1} (${CustomStyle.dB}):',
              minValue: minValue,
              currentValue: inputAttenuation,
              maxValue: maxValue,
              onChanged: (dsVVA1) {
                context.read<Setting18GraphModuleBloc>().add(ControlItemChanged(
                      dataKey: DataKey.dsVVA1,
                      value: dsVVA1,
                    ));
              },
              errorText: state.targetValues[DataKey.dsVVA1]?.isNotValid ?? false
                  ? AppLocalizations.of(context)!.textFieldErrorMessage
                  : null,
              elevation: CustomStyle.graphSettingCardElevation,
              color: CustomStyle.graphSettingCardColor,
            ),
            Row(
              children: [
                Text(
                  '${AppLocalizations.of(context)!.agcMode}: $agcModeText',
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
    required this.pilotFrequencyMode,
    required this.agcMode,
    required this.currentInputEqualizer,
  });

  final String forwardCEQIndex;
  final String pilotFrequencyMode;
  final String agcMode;
  final String currentInputEqualizer;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = state.targetValues[DataKey.dsSlope1]?.minValue ?? 0.0;
        double maxValue =
            state.targetValues[DataKey.dsSlope1]?.maxValue ?? 10.0;
        String inputEqualizer = getInputEqualizer(
          pilotFrequencyMode: pilotFrequencyMode,
          agcMode: agcMode,
          inputEqualizer: state.targetValues[DataKey.dsSlope1]?.value ?? '0.0',
          currentInputEqualizer: currentInputEqualizer,
        );
        String agcModeText = getAgcModeText(
          context: context,
          agcMode: state.agcMode,
        );

        bool isEnableForwardInputSetting = getForwardInputSettingEditable(
          pilotFrequencyMode: pilotFrequencyMode,
          agcMode: agcMode,
        );

        return Column(
          children: [
            controlTextSlider(
              context: context,
              editMode: ModeProperty.isExpertMode
                  ? state.editMode && isEnableForwardInputSetting
                  : false,
              title:
                  '${AppLocalizations.of(context)!.forwardInputEqualizer1} (${CustomStyle.dB}):',
              subTitle: getForwardCEQText(forwardCEQIndex),
              minValue: minValue,
              currentValue: inputEqualizer,
              maxValue: maxValue,
              onChanged: (dsSlope1) {
                context.read<Setting18GraphModuleBloc>().add(ControlItemChanged(
                      dataKey: DataKey.dsSlope1,
                      value: dsSlope1,
                    ));
              },
              errorText:
                  state.targetValues[DataKey.dsSlope1]?.isNotValid ?? false
                      ? AppLocalizations.of(context)!.textFieldErrorMessage
                      : null,
              elevation: CustomStyle.graphSettingCardElevation,
              color: CustomStyle.graphSettingCardColor,
            ),
            Row(
              children: [
                Text(
                  '${AppLocalizations.of(context)!.agcMode}: $agcModeText',
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
  const _ForwardOutputEqualizer3({
    required this.isEnableForwardSetting,
  });

  final bool isEnableForwardSetting;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = state.targetValues[DataKey.dsSlope3]?.minValue ?? 0.0;
        double maxValue =
            state.targetValues[DataKey.dsSlope3]?.maxValue ?? 10.0;
        return controlTextSlider(
          context: context,
          editMode: ModeProperty.isExpertMode ? isEnableForwardSetting : false,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.targetValues[DataKey.dsSlope3]?.value ?? '0.0',
          onChanged: (dsSlope3) {
            context.read<Setting18GraphModuleBloc>().add(ControlItemChanged(
                  dataKey: DataKey.dsSlope3,
                  value: dsSlope3,
                ));
          },
          errorText: state.targetValues[DataKey.dsSlope3]?.isNotValid ?? false
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
  const _ForwardOutputEqualizer4({
    required this.isEnableForwardSetting,
  });

  final bool isEnableForwardSetting;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = state.targetValues[DataKey.dsSlope4]?.minValue ?? 0.0;
        double maxValue =
            state.targetValues[DataKey.dsSlope4]?.maxValue ?? 10.0;
        return controlTextSlider(
          context: context,
          editMode: ModeProperty.isExpertMode ? isEnableForwardSetting : false,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer4} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.targetValues[DataKey.dsSlope4]?.value ?? '0.0',
          onChanged: (dsSlope4) {
            context.read<Setting18GraphModuleBloc>().add(ControlItemChanged(
                  dataKey: DataKey.dsSlope4,
                  value: dsSlope4,
                ));
          },
          errorText: state.targetValues[DataKey.dsSlope4]?.isNotValid ?? false
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
  const _ForwardOutputAttenuation3({
    required this.isEnableForwardSetting,
  });

  final bool isEnableForwardSetting;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = state.targetValues[DataKey.dsVVA4]?.minValue ?? 0.0;
        double maxValue = state.targetValues[DataKey.dsVVA4]?.maxValue ?? 10.0;
        return controlTextSlider(
          context: context,
          editMode: ModeProperty.isExpertMode ? isEnableForwardSetting : false,
          title:
              '${AppLocalizations.of(context)!.forwardOutputAttenuation3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.targetValues[DataKey.dsVVA4]?.value ?? '0.0',
          onChanged: (dsVVA4) {
            context.read<Setting18GraphModuleBloc>().add(ControlItemChanged(
                  dataKey: DataKey.dsVVA4,
                  value: dsVVA4,
                ));
          },
          errorText: state.targetValues[DataKey.dsVVA4]?.isNotValid ?? false
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
  const _ForwardOutputAttenuation4({
    required this.isEnableForwardSetting,
  });

  final bool isEnableForwardSetting;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = state.targetValues[DataKey.dsVVA5]?.minValue ?? 0.0;
        double maxValue = state.targetValues[DataKey.dsVVA5]?.maxValue ?? 10.0;
        return controlTextSlider(
          context: context,
          editMode: ModeProperty.isExpertMode ? isEnableForwardSetting : false,
          title:
              '${AppLocalizations.of(context)!.forwardOutputAttenuation4} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.targetValues[DataKey.dsVVA5]?.value ?? '0.0',
          onChanged: (dsVVA5) {
            context.read<Setting18GraphModuleBloc>().add(ControlItemChanged(
                  dataKey: DataKey.dsVVA5,
                  value: dsVVA5,
                ));
          },
          errorText: state.targetValues[DataKey.dsVVA5]?.isNotValid ?? false
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
  const _ForwardOutputAttenuation2And3({
    required this.isEnableForwardSetting,
  });

  final bool isEnableForwardSetting;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = state.targetValues[DataKey.dsVVA4]?.minValue ?? 0.0;
        double maxValue = state.targetValues[DataKey.dsVVA4]?.maxValue ?? 10.0;
        return controlTextSlider(
          context: context,
          editMode: ModeProperty.isExpertMode ? isEnableForwardSetting : false,
          title:
              '${AppLocalizations.of(context)!.forwardOutputAttenuation2And3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.targetValues[DataKey.dsVVA4]?.value ?? '0.0',
          onChanged: (dsVVA4) {
            context.read<Setting18GraphModuleBloc>().add(ControlItemChanged(
                  dataKey: DataKey.dsVVA4,
                  value: dsVVA4,
                ));
          },
          errorText: state.targetValues[DataKey.dsVVA4]?.isNotValid ?? false
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
  const _ForwardOutputAttenuation3And4({
    required this.isEnableForwardSetting,
  });
  final bool isEnableForwardSetting;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = state.targetValues[DataKey.dsVVA4]?.minValue ?? 0.0;
        double maxValue = state.targetValues[DataKey.dsVVA4]?.maxValue ?? 10.0;
        return controlTextSlider(
          context: context,
          editMode: ModeProperty.isExpertMode ? isEnableForwardSetting : false,
          title:
              '${AppLocalizations.of(context)!.forwardOutputAttenuation3And4} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.targetValues[DataKey.dsVVA4]?.value ?? '0.0',
          onChanged: (dsVVA4) {
            context.read<Setting18GraphModuleBloc>().add(ControlItemChanged(
                  dataKey: DataKey.dsVVA4,
                  value: dsVVA4,
                ));
          },
          errorText: state.targetValues[DataKey.dsVVA4]?.isNotValid ?? false
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
  const _ForwardOutputAttenuation5And6({
    required this.partId,
    required this.agcMode,
    required this.pilotFrequencyMode,
    required this.isEnableForwardSetting,
  });

  final String partId;
  final String agcMode;
  final String pilotFrequencyMode;
  final bool isEnableForwardSetting;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = state.targetValues[DataKey.dsVVA5]?.minValue ?? 0.0;
        double maxValue = state.targetValues[DataKey.dsVVA5]?.maxValue ?? 10.0;

        // BR 的機種在 AGC 開啟的情況下 而且不是 Bench mode 時, 這個參數是無法編輯的
        bool brFlag =
            partId == '6' && pilotFrequencyMode != '3' && agcMode == '1';

        return controlTextSlider(
          context: context,
          editMode: ModeProperty.isExpertMode
              ? brFlag
                  ? false
                  : true
              : false,
          title:
              '${AppLocalizations.of(context)!.forwardOutputAttenuation5And6} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.targetValues[DataKey.dsVVA5]?.value ?? '0.0',
          onChanged: (dsVVA5) {
            context.read<Setting18GraphModuleBloc>().add(ControlItemChanged(
                  dataKey: DataKey.dsVVA5,
                  value: dsVVA5,
                ));
          },
          errorText: state.targetValues[DataKey.dsVVA5]?.isNotValid ?? false
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
  const _ForwardOutputEqualizer2And3({required this.isEnableForwardSetting});
  final bool isEnableForwardSetting;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = state.targetValues[DataKey.dsSlope3]?.minValue ?? 0.0;
        double maxValue =
            state.targetValues[DataKey.dsSlope3]?.maxValue ?? 10.0;
        return controlTextSlider(
          context: context,
          editMode: ModeProperty.isExpertMode ? isEnableForwardSetting : false,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer2And3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.targetValues[DataKey.dsSlope3]?.value ?? '0.0',
          onChanged: (dsSlope3) {
            context.read<Setting18GraphModuleBloc>().add(ControlItemChanged(
                  dataKey: DataKey.dsSlope3,
                  value: dsSlope3,
                ));
          },
          errorText: state.targetValues[DataKey.dsSlope3]?.isNotValid ?? false
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
  const _ForwardOutputEqualizer5And6({
    required this.partId,
    required this.agcMode,
    required this.pilotFrequencyMode,
    required this.isEnableForwardSetting,
  });

  final bool isEnableForwardSetting;
  final String partId;
  final String agcMode;
  final String pilotFrequencyMode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double minValue = state.targetValues[DataKey.dsSlope4]?.minValue ?? 0.0;
        double maxValue =
            state.targetValues[DataKey.dsSlope4]?.maxValue ?? 10.0;

        // BR 的機種在 AGC 開啟的情況下 而且不是 Bench mode 時, 這個參數是無法編輯的
        bool brFlag =
            partId == '6' && pilotFrequencyMode != '3' && agcMode == '1';

        return controlTextSlider(
          context: context,
          editMode: ModeProperty.isExpertMode
              ? brFlag
                  ? false
                  : true
              : false,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer5And6} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.targetValues[DataKey.dsSlope4]?.value ?? '0.0',
          onChanged: (dsSlope4) {
            context.read<Setting18GraphModuleBloc>().add(ControlItemChanged(
                  dataKey: DataKey.dsSlope4,
                  value: dsSlope4,
                ));
          },
          errorText: state.targetValues[DataKey.dsSlope4]?.isNotValid ?? false
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
        double minValue = state.targetValues[DataKey.usVCA2]?.minValue ?? 0.0;
        double maxValue = state.targetValues[DataKey.usVCA2]?.maxValue ?? 10.0;
        return controlTextSlider(
          context: context,
          editMode: ModeProperty.isExpertMode ? state.editMode : false,
          title:
              '${AppLocalizations.of(context)!.returnOutputAttenuation1} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.targetValues[DataKey.usVCA2]?.value ?? '0.0',
          onChanged: (usVCA2) {
            context.read<Setting18GraphModuleBloc>().add(ControlItemChanged(
                  dataKey: DataKey.usVCA2,
                  value: usVCA2,
                ));
          },
          errorText: state.targetValues[DataKey.usVCA2]?.isNotValid ?? false
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
        double minValue = state.targetValues[DataKey.eREQ]?.minValue ?? 0.0;
        double maxValue = state.targetValues[DataKey.eREQ]?.maxValue ?? 10.0;
        return controlTextSlider(
          context: context,
          editMode: ModeProperty.isExpertMode ? state.editMode : false,
          title:
              '${AppLocalizations.of(context)!.returnOutputEqualizer1} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.targetValues[DataKey.eREQ]?.value ?? '0.0',
          onChanged: (eREQ) {
            context.read<Setting18GraphModuleBloc>().add(ControlItemChanged(
                  dataKey: DataKey.eREQ,
                  value: eREQ,
                ));
          },
          errorText: state.targetValues[DataKey.eREQ]?.isNotValid ?? false
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
        double minValue = state.targetValues[DataKey.usVCA1]?.minValue ?? 0.0;
        double maxValue = state.targetValues[DataKey.usVCA1]?.maxValue ?? 10.0;
        return controlTextSlider(
          context: context,
          editMode: ModeProperty.isExpertMode ? state.editMode : false,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation2} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.targetValues[DataKey.usVCA1]?.value ?? '0.0',
          onChanged: (usVCA1) {
            context.read<Setting18GraphModuleBloc>().add(ControlItemChanged(
                  dataKey: DataKey.usVCA1,
                  value: usVCA1,
                ));
          },
          errorText: state.targetValues[DataKey.usVCA1]?.isNotValid ?? false
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
        double minValue = state.targetValues[DataKey.usVCA3]?.minValue ?? 0.0;
        double maxValue = state.targetValues[DataKey.usVCA3]?.maxValue ?? 10.0;
        return controlTextSlider(
          context: context,
          editMode: ModeProperty.isExpertMode ? state.editMode : false,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.targetValues[DataKey.usVCA3]?.value ?? '0.0',
          onChanged: (usVCA3) {
            context.read<Setting18GraphModuleBloc>().add(ControlItemChanged(
                  dataKey: DataKey.usVCA3,
                  value: usVCA3,
                ));
          },
          errorText: state.targetValues[DataKey.usVCA3]?.isNotValid ?? false
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
        double minValue = state.targetValues[DataKey.usVCA3]?.minValue ?? 0.0;
        double maxValue = state.targetValues[DataKey.usVCA3]?.maxValue ?? 10.0;
        return controlTextSlider(
          context: context,
          editMode: ModeProperty.isExpertMode ? state.editMode : false,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation2And3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.targetValues[DataKey.usVCA3]?.value ?? '0.0',
          onChanged: (usVCA3) {
            context.read<Setting18GraphModuleBloc>().add(ControlItemChanged(
                  dataKey: DataKey.usVCA3,
                  value: usVCA3,
                ));
          },
          errorText: state.targetValues[DataKey.usVCA3]?.isNotValid ?? false
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
          double minValue = state.targetValues[DataKey.usVCA1]?.minValue ?? 0.0;
          double maxValue =
              state.targetValues[DataKey.usVCA1]?.maxValue ?? 10.0;
          return controlTextSlider(
            context: context,
            editMode: ModeProperty.isExpertMode ? state.editMode : false,
            title:
                '${AppLocalizations.of(context)!.returnInputAttenuation4} (${CustomStyle.dB}):',
            minValue: minValue,
            maxValue: maxValue,
            currentValue: state.targetValues[DataKey.usVCA1]?.value ?? '0.0',
            onChanged: (usVCA1) {
              context.read<Setting18GraphModuleBloc>().add(ControlItemChanged(
                    dataKey: DataKey.usVCA1,
                    value: usVCA1,
                  ));
            },
            errorText: state.targetValues[DataKey.usVCA1]?.isNotValid ?? false
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
          double minValue = state.targetValues[DataKey.usVCA4]?.minValue ?? 0.0;
          double maxValue =
              state.targetValues[DataKey.usVCA4]?.maxValue ?? 10.0;
          return controlTextSlider(
            context: context,
            editMode: ModeProperty.isExpertMode ? state.editMode : false,
            title:
                '${AppLocalizations.of(context)!.returnInputAttenuation4} (${CustomStyle.dB}):',
            minValue: minValue,
            maxValue: maxValue,
            currentValue: state.targetValues[DataKey.usVCA4]?.value ?? '0.0',
            onChanged: (usVCA4) {
              context.read<Setting18GraphModuleBloc>().add(ControlItemChanged(
                    dataKey: DataKey.usVCA4,
                    value: usVCA4,
                  ));
            },
            errorText: state.targetValues[DataKey.usVCA4]?.isNotValid ?? false
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
        double minValue = state.targetValues[DataKey.usVCA4]?.minValue ?? 0.0;
        double maxValue = state.targetValues[DataKey.usVCA4]?.maxValue ?? 10.0;
        return controlTextSlider(
          context: context,
          editMode: ModeProperty.isExpertMode ? state.editMode : false,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation5And6} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.targetValues[DataKey.usVCA4]?.value ?? '0.0',
          onChanged: (usVCA4) {
            context.read<Setting18GraphModuleBloc>().add(ControlItemChanged(
                  dataKey: DataKey.usVCA4,
                  value: usVCA4,
                ));
          },
          errorText: state.targetValues[DataKey.usVCA4]?.isNotValid ?? false
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

// class _SplitOption extends StatelessWidget {
//   const _SplitOption();

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
//         builder: (context, state) {
//       return splitOptionGridViewButton(
//         context: context,
//         editMode: ModeProperty.isExpertMode ? state.editMode : false,
//         splitOption: state.splitOption,
//         onGridPressed: (index) => context
//             .read<Setting18GraphModuleBloc>()
//             .add(SplitOptionChanged(splitOption: splitOptionValues[index])),
//         elevation: CustomStyle.graphSettingCardElevation,
//         color: CustomStyle.graphSettingCardColor,
//       );
//     });
//   }
// }

class _PilotFrequencyMode extends StatelessWidget {
  const _PilotFrequencyMode({
    required this.partId,
    required this.currentDetectedSplitOption,
  });

  final String partId;
  final String currentDetectedSplitOption;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      buildWhen: (previous, current) =>
          previous.pilotFrequencyMode != current.pilotFrequencyMode ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        List<String> texts = [];
        List<String> values = [];

        if (state.eqType == EQType.board) {
          texts = [
            AppLocalizations.of(context)!.pilotFrequencyBandwidthSettings,
            AppLocalizations.of(context)!.pilotFrequencyUserSettings,
            AppLocalizations.of(context)!.pilotFrequencyBenchMode1p8G,
            AppLocalizations.of(context)!.pilotFrequencyBenchMode1p2G,
          ];

          values = onBoardPilotFrequencyModeValues;
        } else {
          texts = [
            AppLocalizations.of(context)!.pilotFrequencyBandwidthSettings,
            AppLocalizations.of(context)!.pilotFrequencyUserSettings,
            AppLocalizations.of(context)!.pilotFrequencyBenchMode,
          ];
          values = pilotFrequencyModeValues;
        }

        return pilotFrequencyModeGridViewButton(
          context: context,
          crossAxisCount: 1,
          texts: texts,
          values: values,
          editMode: ModeProperty.isExpertMode ? state.editMode : false,
          pilotFrequencyMode: state.pilotFrequencyMode,
          onGridPressed: (index) => context
              .read<Setting18GraphModuleBloc>()
              .add(
                  PilotFrequencyModeChanged(pilotFrequencyMode: values[index])),
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

class _FirstChannelLoading extends StatelessWidget {
  const _FirstChannelLoading({
    required this.currentDetectedSplitOption,
  });

  final String currentDetectedSplitOption;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        return TwoInputs(
          title: '${AppLocalizations.of(context)!.startFrequency}:',
          editMode1: ModeProperty.isExpertMode
              ? state.editMode && state.pilotFrequencyMode != '2'
              : false,
          editMode2: ModeProperty.isExpertMode
              ? state.editMode && state.pilotFrequencyMode != '2'
              : false,
          readOnly1: true,
          readOnly2: true,
          initialValue1: state.firstChannelLoadingFrequency.value,
          initialValue2: state.firstChannelLoadingLevel.value,
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
          errorText1: isNotValidFrequency(
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

        // frequencyRFTextField(
        //   context: context,
        //   title1: '${AppLocalizations.of(context)!.startFrequency}:',
        //   title2: '${AppLocalizations.of(context)!.startFrequencyRFLevel}:',
        //   editMode1: state.editMode && state.pilotFrequencyMode != '2',
        //   editMode2: state.editMode && state.pilotFrequencyMode != '2',
        //   textEditingControllerName1:
        //       'setting18Form_firstChannelLoadingFrequencyInput_textField',
        //   textEditingControllerName2:
        //       'setting18Form_firstChannelLoadingLevelInput_textField',
        //   currentValue1: state.firstChannelLoadingFrequency.value,
        //   currentValue2: state.firstChannelLoadingLevel.value,
        //   step1: step1,
        //   step2: step2,
        //   onChanged1: (firstChannelLoadingFrequency) {
        //     context
        //         .read<Setting18GraphModuleBloc>()
        //         .add(FirstChannelLoadingFrequencyChanged(
        //           firstChannelLoadingFrequency: firstChannelLoadingFrequency,
        //           currentDetectedSplitOption: currentDetectedSplitOption,
        //         ));
        //   },
        //   onIncreased1: (firstChannelLoadingFrequency) {
        //     context
        //         .read<Setting18GraphModuleBloc>()
        //         .add(FirstChannelLoadingFrequencyChanged(
        //           firstChannelLoadingFrequency: firstChannelLoadingFrequency,
        //           currentDetectedSplitOption: currentDetectedSplitOption,
        //         ));
        //   },
        //   onDecreased1: (firstChannelLoadingFrequency) {
        //     context
        //         .read<Setting18GraphModuleBloc>()
        //         .add(FirstChannelLoadingFrequencyChanged(
        //           firstChannelLoadingFrequency: firstChannelLoadingFrequency,
        //           currentDetectedSplitOption: currentDetectedSplitOption,
        //         ));
        //   },
        //   onChanged2: (firstChannelLoadingLevel) {
        //     context.read<Setting18GraphModuleBloc>().add(
        //         FirstChannelLoadingLevelChanged(
        //             firstChannelLoadingLevel: firstChannelLoadingLevel));
        //   },
        //   onIncreased2: (firstChannelLoadingLevel) {
        //     context.read<Setting18GraphModuleBloc>().add(
        //         FirstChannelLoadingLevelChanged(
        //             firstChannelLoadingLevel: firstChannelLoadingLevel));

        //     // convert to double
        //     double lastChannelLoadingLevel =
        //         double.parse(state.lastChannelLoadingLevel.value) + step2;
        //     context.read<Setting18GraphModuleBloc>().add(
        //         LastChannelLoadingLevelChanged(
        //             lastChannelLoadingLevel:
        //                 lastChannelLoadingLevel.toStringAsFixed(1)));
        //   },
        //   onDecreased2: (firstChannelLoadingLevel) {
        //     context.read<Setting18GraphModuleBloc>().add(
        //         FirstChannelLoadingLevelChanged(
        //             firstChannelLoadingLevel: firstChannelLoadingLevel));

        //     // convert to double
        //     double lastChannelLoadingLevel =
        //         double.parse(state.lastChannelLoadingLevel.value) - step2;
        //     context.read<Setting18GraphModuleBloc>().add(
        //         LastChannelLoadingLevelChanged(
        //             lastChannelLoadingLevel:
        //                 lastChannelLoadingLevel.toStringAsFixed(1)));
        //   },
        //   errorText1: isNotValidFrequency(
        //     pilotFrequencyMode: state.pilotFrequencyMode,
        //     firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        //     lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        //     pilotFrequency1: state.pilotFrequency1,
        //     pilotFrequency2: state.pilotFrequency2,
        //   )
        //       ? AppLocalizations.of(context)!.textFieldErrorMessage
        //       : null,
        //   errorText2: state.firstChannelLoadingLevel.isNotValid
        //       ? AppLocalizations.of(context)!.textFieldErrorMessage
        //       : null,
        //   elevation: CustomStyle.graphSettingCardElevation,
        //   color: CustomStyle.graphSettingCardColor,
        // );
      },
    );
  }
}

class _LastChannelLoading extends StatelessWidget {
  const _LastChannelLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        double step1 = 6.0;
        double step2 = 0.5;
        return TwoInputs(
          title: '${AppLocalizations.of(context)!.stopFrequency}:',
          editMode1: ModeProperty.isExpertMode
              ? state.editMode && state.pilotFrequencyMode != '2'
              : false,
          editMode2: ModeProperty.isExpertMode
              ? state.editMode && state.pilotFrequencyMode != '2'
              : false,
          initialValue1: state.lastChannelLoadingFrequency.value,
          initialValue2: state.lastChannelLoadingLevel.value,
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
          errorText1: isNotValidFrequency(
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

        // frequencyRFTextField(
        //   context: context,
        //   title1: '${AppLocalizations.of(context)!.stopFrequency}:',
        //   title2: '${AppLocalizations.of(context)!.slope}:',
        //   editMode1: state.editMode && state.pilotFrequencyMode != '2',
        //   editMode2: state.editMode && state.pilotFrequencyMode != '2',
        //   textEditingControllerName1:
        //       'setting18Form_lastChannelLoadingFrequencyInput_textField',
        //   textEditingControllerName2:
        //       'setting18Form_lastChannelLoadingLevelInput_textField',
        //   currentValue1: state.lastChannelLoadingFrequency.value,
        //   currentValue2: state.lastChannelLoadingLevel.value,
        //   step1: step1,
        //   step2: step2,
        //   onChanged1: (lastChannelLoadingFrequency) {
        //     context.read<Setting18GraphModuleBloc>().add(
        //         LastChannelLoadingFrequencyChanged(
        //             lastChannelLoadingFrequency: lastChannelLoadingFrequency));
        //   },
        //   onIncreased1: (lastChannelLoadingFrequency) {
        //     context.read<Setting18GraphModuleBloc>().add(
        //         LastChannelLoadingFrequencyChanged(
        //             lastChannelLoadingFrequency: lastChannelLoadingFrequency));
        //   },
        //   onDecreased1: (lastChannelLoadingFrequency) {
        //     context.read<Setting18GraphModuleBloc>().add(
        //         LastChannelLoadingFrequencyChanged(
        //             lastChannelLoadingFrequency: lastChannelLoadingFrequency));
        //   },
        //   onChanged2: (lastChannelLoadingLevel) {
        //     context.read<Setting18GraphModuleBloc>().add(
        //         LastChannelLoadingLevelChanged(
        //             lastChannelLoadingLevel: lastChannelLoadingLevel));
        //   },
        //   onIncreased2: (lastChannelLoadingLevel) {
        //     context.read<Setting18GraphModuleBloc>().add(
        //         LastChannelLoadingLevelChanged(
        //             lastChannelLoadingLevel: lastChannelLoadingLevel));
        //   },
        //   onDecreased2: (lastChannelLoadingLevel) {
        //     context.read<Setting18GraphModuleBloc>().add(
        //         LastChannelLoadingLevelChanged(
        //             lastChannelLoadingLevel: lastChannelLoadingLevel));
        //   },
        //   errorText1: isNotValidFrequency(
        //     pilotFrequencyMode: state.pilotFrequencyMode,
        //     firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        //     lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        //     pilotFrequency1: state.pilotFrequency1,
        //     pilotFrequency2: state.pilotFrequency2,
        //   )
        //       ? AppLocalizations.of(context)!.textFieldErrorMessage
        //       : null,
        //   errorText2: state.lastChannelLoadingLevel.isNotValid
        //       ? AppLocalizations.of(context)!.textFieldErrorMessage
        //       : null,
        //   elevation: CustomStyle.graphSettingCardElevation,
        //   color: CustomStyle.graphSettingCardColor,
        // );
      },
    );
  }
}

class _RFLevelFineTuner extends StatelessWidget {
  const _RFLevelFineTuner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
        builder: (context, state) {
      double step = 0.5;
      return rfSlopeFinetune(
        context: context,
        title1: AppLocalizations.of(context)!.startFrequencyRFLevel,
        title2: AppLocalizations.of(context)!.slope,
        editMode1: ModeProperty.isExpertMode
            ? state.editMode && state.pilotFrequencyMode != '2'
            : false,
        editMode2: ModeProperty.isExpertMode
            ? state.editMode && state.pilotFrequencyMode != '2'
            : false,
        step1: step,
        step2: step,
        onIncreased1: () {
          // convert to double
          double firstChannelLoadingLevel =
              double.parse(state.firstChannelLoadingLevel.value) + step;
          context.read<Setting18GraphModuleBloc>().add(
              FirstChannelLoadingLevelChanged(
                  firstChannelLoadingLevel:
                      firstChannelLoadingLevel.toStringAsFixed(1)));

          double lastChannelLoadingLevel =
              double.parse(state.lastChannelLoadingLevel.value) + step;
          context.read<Setting18GraphModuleBloc>().add(
              LastChannelLoadingLevelChanged(
                  lastChannelLoadingLevel:
                      lastChannelLoadingLevel.toStringAsFixed(1)));
        },
        onDecreased1: () {
          // convert to double
          double firstChannelLoadingLevel =
              double.parse(state.firstChannelLoadingLevel.value) - step;
          context.read<Setting18GraphModuleBloc>().add(
              FirstChannelLoadingLevelChanged(
                  firstChannelLoadingLevel:
                      firstChannelLoadingLevel.toStringAsFixed(1)));

          double lastChannelLoadingLevel =
              double.parse(state.lastChannelLoadingLevel.value) - step;
          context.read<Setting18GraphModuleBloc>().add(
              LastChannelLoadingLevelChanged(
                  lastChannelLoadingLevel:
                      lastChannelLoadingLevel.toStringAsFixed(1)));
        },
        onIncreased2: () {
          // convert to double
          double firstChannelLoadingLevel =
              double.parse(state.firstChannelLoadingLevel.value) - step;
          context.read<Setting18GraphModuleBloc>().add(
              FirstChannelLoadingLevelChanged(
                  firstChannelLoadingLevel:
                      firstChannelLoadingLevel.toStringAsFixed(1)));
        },
        onDecreased2: () {
          // convert to double
          double firstChannelLoadingLevel =
              double.parse(state.firstChannelLoadingLevel.value) + step;
          context.read<Setting18GraphModuleBloc>().add(
              FirstChannelLoadingLevelChanged(
                  firstChannelLoadingLevel:
                      firstChannelLoadingLevel.toStringAsFixed(1)));
        },
        elevation: CustomStyle.graphSettingCardElevation,
        color: CustomStyle.graphSettingCardColor,
      );
    });
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
          editMode1: ModeProperty.isExpertMode
              ? state.editMode && state.pilotFrequencyMode == '1'
              : false,
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
          errorText1: isNotValidFrequency(
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
          editMode1: ModeProperty.isExpertMode
              ? state.editMode && state.pilotFrequencyMode == '1'
              : false,
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
          errorText1: isNotValidFrequency(
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
          editMode: ModeProperty.isExpertMode ? state.editMode : false,
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
// class _ALCMode extends StatelessWidget {
//   const _ALCMode();

//   final List<String> autoLevelControlValues = const [
//     '1',
//     '0',
//   ];

//   List<bool> getSelectionState(String selectedAutoLevelControl) {
//     Map<String, bool> autoLevelControlMap = {
//       '1': false,
//       '0': false,
//     };

//     if (autoLevelControlMap.containsKey(selectedAutoLevelControl)) {
//       autoLevelControlMap[selectedAutoLevelControl] = true;
//     }

//     return autoLevelControlMap.values.toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
//       buildWhen: (previous, current) =>
//           previous.alcMode != current.alcMode ||
//           previous.editMode != current.editMode,
//       builder: (context, state) {
//         return Padding(
//           padding: const EdgeInsets.only(
//             bottom: 40.0,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(
//                   bottom: CustomStyle.sizeL,
//                 ),
//                 child: Text(
//                   '${AppLocalizations.of(context)!.alcMode}:',
//                   style: const TextStyle(
//                     fontSize: CustomStyle.sizeXL,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//               LayoutBuilder(
//                 builder: (context, constraints) => ToggleButtons(
//                   direction: Axis.horizontal,
//                   onPressed: (int index) {
//                     // if (state.editMode) {
//                     //   context.read<Setting18GraphModuleBloc>().add(
//                     //       AutoLevelControlChanged(
//                     //           autoLevelControlValues[index]));
//                     // }
//                   },
//                   textStyle: const TextStyle(fontSize: 18.0),
//                   borderRadius: const BorderRadius.all(Radius.circular(8)),
//                   selectedBorderColor: state.editMode && false
//                       ? Theme.of(context).colorScheme.primary
//                       : Theme.of(context)
//                           .colorScheme
//                           .inversePrimary, // indigo border color
//                   selectedColor: Theme.of(context)
//                       .colorScheme
//                       .onPrimary, // white text color

//                   fillColor: state.editMode && false
//                       ? Theme.of(context).colorScheme.primary
//                       : Theme.of(context)
//                           .colorScheme
//                           .inversePrimary, // selected
//                   color:
//                       Theme.of(context).colorScheme.secondary, // not selected
//                   constraints: BoxConstraints.expand(
//                     width: (constraints.maxWidth - 4) /
//                         autoLevelControlValues.length,
//                   ),
//                   isSelected: getSelectionState(state.alcMode),
//                   children: <Widget>[
//                     Text(AppLocalizations.of(context)!.on),
//                     Text(AppLocalizations.of(context)!.off),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

const List<String> rtnIngressValues = [
  '0',
  // '1',
  '2',
  // '4',
  // '5',
];

List<String> _getIngressTexts(BuildContext context) {
  return [
    '0 ${CustomStyle.dB}',
    // AppLocalizations.of(context)!.ingressTemporary('-3 ${CustomStyle.dB}'),
    '-6 ${CustomStyle.dB}',
    // AppLocalizations.of(context)!.ingressOpenTemporary,
    // AppLocalizations.of(context)!.ingressOpenPermanent,
  ];
}

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
          previous.targetIngressValues[DataKey.ingressSetting2] !=
              current.targetIngressValues[DataKey.ingressSetting2] ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return controlToggleButton(
          context: context,
          editMode: ModeProperty.isExpertMode ? state.editMode : false,
          title: '${AppLocalizations.of(context)!.returnIngressSetting2}:',
          currentValue:
              state.targetIngressValues[DataKey.ingressSetting2] ?? '0',
          onChanged: (index) {
            context.read<Setting18GraphModuleBloc>().add(ControlItemChanged(
                  dataKey: DataKey.ingressSetting2,
                  value: rtnIngressValues[index],
                ));
          },
          values: rtnIngressValues,
          texts: _getIngressTexts(context),
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
          previous.targetIngressValues[DataKey.ingressSetting3] !=
              current.targetIngressValues[DataKey.ingressSetting3] ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return controlToggleButton(
          context: context,
          editMode: ModeProperty.isExpertMode ? state.editMode : false,
          title: '${AppLocalizations.of(context)!.returnIngressSetting3}:',
          currentValue:
              state.targetIngressValues[DataKey.ingressSetting3] ?? '0',
          onChanged: (index) {
            context.read<Setting18GraphModuleBloc>().add(ControlItemChanged(
                  dataKey: DataKey.ingressSetting3,
                  value: rtnIngressValues[index],
                ));
          },
          values: rtnIngressValues,
          texts: _getIngressTexts(context),
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
            previous.targetIngressValues[DataKey.ingressSetting2] !=
                current.targetIngressValues[DataKey.ingressSetting2] ||
            previous.editMode != current.editMode,
        builder: (context, state) {
          return controlToggleButton(
            context: context,
            editMode: ModeProperty.isExpertMode ? state.editMode : false,
            title: '${AppLocalizations.of(context)!.returnIngressSetting4}:',
            currentValue:
                state.targetIngressValues[DataKey.ingressSetting2] ?? '0',
            onChanged: (index) {
              context.read<Setting18GraphModuleBloc>().add(ControlItemChanged(
                    dataKey: DataKey.ingressSetting2,
                    value: rtnIngressValues[index],
                  ));
            },
            values: rtnIngressValues,
            texts: _getIngressTexts(context),
            elevation: CustomStyle.graphSettingCardElevation,
            color: CustomStyle.graphSettingCardColor,
          );
        },
      );
    } else {
      return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
        buildWhen: (previous, current) =>
            previous.targetIngressValues[DataKey.ingressSetting4] !=
                current.targetIngressValues[DataKey.ingressSetting4] ||
            previous.editMode != current.editMode,
        builder: (context, state) {
          return controlToggleButton(
            context: context,
            editMode: ModeProperty.isExpertMode ? state.editMode : false,
            title: '${AppLocalizations.of(context)!.returnIngressSetting4}:',
            currentValue:
                state.targetIngressValues[DataKey.ingressSetting4] ?? '0',
            onChanged: (index) {
              context.read<Setting18GraphModuleBloc>().add(ControlItemChanged(
                    dataKey: DataKey.ingressSetting4,
                    value: rtnIngressValues[index],
                  ));
            },
            values: rtnIngressValues,
            texts: _getIngressTexts(context),
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
          previous.targetIngressValues[DataKey.ingressSetting3] !=
              current.targetIngressValues[DataKey.ingressSetting3] ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return controlToggleButton(
          context: context,
          editMode: ModeProperty.isExpertMode ? state.editMode : false,
          title: '${AppLocalizations.of(context)!.returnIngressSetting2And3}:',
          currentValue:
              state.targetIngressValues[DataKey.ingressSetting3] ?? '0',
          onChanged: (index) {
            context.read<Setting18GraphModuleBloc>().add(ControlItemChanged(
                  dataKey: DataKey.ingressSetting3,
                  value: rtnIngressValues[index],
                ));
          },
          values: rtnIngressValues,
          texts: _getIngressTexts(context),
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
          previous.targetIngressValues[DataKey.ingressSetting4] !=
              current.targetIngressValues[DataKey.ingressSetting4] ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return controlToggleButton(
          context: context,
          editMode: ModeProperty.isExpertMode ? state.editMode : false,
          title: '${AppLocalizations.of(context)!.returnIngressSetting5And6}:',
          currentValue:
              state.targetIngressValues[DataKey.ingressSetting4] ?? '0',
          onChanged: (index) {
            context.read<Setting18GraphModuleBloc>().add(ControlItemChanged(
                  dataKey: DataKey.ingressSetting4,
                  value: rtnIngressValues[index],
                ));
          },
          values: rtnIngressValues,
          texts: _getIngressTexts(context),
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
                        targetBloc: context.read<Setting18GraphModuleBloc>(),
                        action: () {
                          context
                              .read<Setting18GraphModuleBloc>()
                              .add(const SettingSubmitted());
                        },
                        waitForState: (state) {
                          Setting18GraphModuleState setting18GraphModuleState =
                              state as Setting18GraphModuleState;

                          return setting18GraphModuleState
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
