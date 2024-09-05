import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18_ccor_node_graph_module/setting18_ccor_node_graph_module_bloc.dart';
import 'package:aci_plus_app/setting/model/graph_module_form_color.dart';
import 'package:aci_plus_app/setting/model/confirm_input_dialog.dart';
import 'package:aci_plus_app/setting/model/setting18_result_text.dart';
import 'package:aci_plus_app/setting/model/setting_widgets.dart';
import 'package:aci_plus_app/setting/views/custom_setting_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18CCorNodeGraphModuleForm extends StatefulWidget {
  const Setting18CCorNodeGraphModuleForm({
    super.key,
    required this.moduleName,
  });

  final String moduleName;

  @override
  State<Setting18CCorNodeGraphModuleForm> createState() =>
      _Setting18CCorNodeGraphModuleFormState();
}

class _Setting18CCorNodeGraphModuleFormState
    extends State<Setting18CCorNodeGraphModuleForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

    Map<String, List<Widget>> isolatedSettingWidgetsMap = {
      DataKey.splitOption.name: [const _SplitOption()],
    };

    Map<String, List<Widget>> forwardSettingWidgetsMap = {
      DataKey.forwardConfig.name: [const _ForwardConfig()],
      DataKey.dsVVA1.name: [const _ForwardOutputAttenuation1()],
      DataKey.dsVVA3.name: [const _ForwardOutputAttenuation3()],
      DataKey.dsVVA4.name: [const _ForwardOutputAttenuation4()],
      DataKey.dsVVA6.name: [const _ForwardOutputAttenuation6()],
      DataKey.dsOutSlope1.name: [const _ForwardOutputEqualizer1()],
      DataKey.dsOutSlope3.name: [const _ForwardOutputEqualizer3()],
      DataKey.dsOutSlope4.name: [const _ForwardOutputEqualizer4()],
      DataKey.dsOutSlope6.name: [const _ForwardOutputEqualizer6()],
      DataKey.biasCurrent1.name: [const _ForwardBiasCurrent1()],
      DataKey.biasCurrent3.name: [const _ForwardBiasCurrent3()],
      DataKey.biasCurrent4.name: [const _ForwardBiasCurrent4()],
      DataKey.biasCurrent6.name: [const _ForwardBiasCurrent6()],
    };

    Map<String, List<Widget>> reverseSettingWidgetsMap = {
      DataKey.usVCA1.name: [
        const _ReturnInputAttenuation1(),
        const _ReturnIngressSetting1(),
      ],
      DataKey.usVCA3.name: [
        const _ReturnInputAttenuation3(),
        const _ReturnIngressSetting3(),
      ],
      DataKey.usVCA4.name: [
        const _ReturnInputAttenuation4(),
        const _ReturnIngressSetting4(),
      ],
      DataKey.usVCA6.name: [
        const _ReturnInputAttenuation6(),
        const _ReturnIngressSetting6(),
      ],
    };

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

    return BlocListener<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
      listener: (context, state) async {
        if (state.submissionStatus.isSubmissionInProgress) {
          await showInProgressDialog(context);
        } else if (state.submissionStatus.isSubmissionSuccess) {
          if (ModalRoute.of(context)?.isCurrent != true) {
            Navigator.of(context).pop();
          }
          List<Widget> rows = get1P8GCCorNodeSettingMessageRows(
            context: context,
            settingResultList: state.settingResult,
          );
          showResultDialog(
            context: context,
            messageRows: rows,
          );

          context
              .read<Setting18CCorNodeGraphModuleBloc>()
              .add(const Initialized());
        }

        if (state.isInitialize) {
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

class _SplitOption extends StatelessWidget {
  const _SplitOption();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(builder: (context, state) {
      return splitOptionGridViewButton(
        context: context,
        editMode: state.editMode,
        splitOption: state.splitOption,
        onGridPressed: (index) => context
            .read<Setting18CCorNodeGraphModuleBloc>()
            .add(SplitOptionChanged(splitOption: splitOptionValues[index])),
        elevation: CustomStyle.graphSettingCardElevation,
        color: CustomStyle.graphSettingCardColor,
      );
    });
  }
}

class _ForwardConfig extends StatelessWidget {
  const _ForwardConfig();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
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
              .read<Setting18CCorNodeGraphModuleBloc>()
              .add(ForwardConfigChanged(
                  forwardConfig: forwardConfigValues[index])),
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

class _ForwardOutputAttenuation1 extends StatelessWidget {
  const _ForwardOutputAttenuation1();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
      builder: (context, state) {
        double minValue = state.dsVVA1.minValue;
        double maxValue = state.dsVVA1.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputAttenuation1} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsVVA1.value,
          onChanged: (dsVVA1) {
            context.read<Setting18CCorNodeGraphModuleBloc>().add(DSVVA1Changed(
                  dsVVA1: dsVVA1,
                ));
          },
          errorText: state.dsVVA1.isNotValid
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
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
      builder: (context, state) {
        double minValue = state.dsVVA3.minValue;
        double maxValue = state.dsVVA3.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputAttenuation3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsVVA3.value,
          onChanged: (dsVVA3) {
            context.read<Setting18CCorNodeGraphModuleBloc>().add(DSVVA3Changed(
                  dsVVA3: dsVVA3,
                ));
          },
          errorText: state.dsVVA3.isNotValid
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
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
      builder: (context, state) {
        double minValue = state.dsVVA4.minValue;
        double maxValue = state.dsVVA4.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputAttenuation4} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsVVA4.value,
          onChanged: (dsVVA4) {
            context.read<Setting18CCorNodeGraphModuleBloc>().add(DSVVA4Changed(
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

class _ForwardOutputAttenuation6 extends StatelessWidget {
  const _ForwardOutputAttenuation6();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
      builder: (context, state) {
        double minValue = state.dsVVA6.minValue;
        double maxValue = state.dsVVA6.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputAttenuation6} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsVVA6.value,
          onChanged: (dsVVA6) {
            context.read<Setting18CCorNodeGraphModuleBloc>().add(DSVVA6Changed(
                  dsVVA6: dsVVA6,
                ));
          },
          errorText: state.dsVVA6.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

// class _ForwardInputEqualizer1 extends StatelessWidget {
//   const _ForwardInputEqualizer1({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
//         Setting18CCorNodeGraphModuleState>(
//       builder: (context, state) {
//         double minValue = 0.0;
//         double maxValue = 15.0;
//         return controlTextSlider(
//           context: context,
//           editMode: state.editMode,
//           title:
//               '${AppLocalizations.of(context)!.forwardInputEqualizer1} (${CustomStyle.dB}):',
//           minValue: minValue,
//           maxValue: maxValue,
//           currentValue: state.dsInSlope1,
//           onChanged: (dsInSlope1) {
//             context
//                 .read<Setting18CCorNodeGraphModuleBloc>()
//                 .add(DSInSlope1Changed(
//                   dsInSlope1: dsInSlope1,
//                 ));
//           },
//         );
//       },
//     );
//   }
// }

// class _ForwardInputEqualizer3 extends StatelessWidget {
//   const _ForwardInputEqualizer3({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
//         Setting18CCorNodeGraphModuleState>(
//       builder: (context, state) {
//         double minValue = 0.0;
//         double maxValue = 15.0;
//         return controlTextSlider(
//           context: context,
//           editMode: state.editMode,
//           title:
//               '${AppLocalizations.of(context)!.forwardInputEqualizer3} (${CustomStyle.dB}):',
//           minValue: minValue,
//           maxValue: maxValue,
//           currentValue: state.dsInSlope3,
//           onChanged: (dsInSlope3) {
//             context
//                 .read<Setting18CCorNodeGraphModuleBloc>()
//                 .add(DSInSlope3Changed(
//                   dsInSlope3: dsInSlope3,
//                 ));
//           },
//         );
//       },
//     );
//   }
// }

// class _ForwardInputEqualizer4 extends StatelessWidget {
//   const _ForwardInputEqualizer4({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
//         Setting18CCorNodeGraphModuleState>(
//       builder: (context, state) {
//         double minValue = 0.0;
//         double maxValue = 15.0;
//         return controlTextSlider(
//           context: context,
//           editMode: state.editMode,
//           title:
//               '${AppLocalizations.of(context)!.forwardInputEqualizer4} (${CustomStyle.dB}):',
//           minValue: minValue,
//           maxValue: maxValue,
//           currentValue: state.dsInSlope4,
//           onChanged: (dsInSlope4) {
//             context
//                 .read<Setting18CCorNodeGraphModuleBloc>()
//                 .add(DSInSlope4Changed(
//                   dsInSlope4: dsInSlope4,
//                 ));
//           },
//         );
//       },
//     );
//   }
// }

// class _ForwardInputEqualizer6 extends StatelessWidget {
//   const _ForwardInputEqualizer6({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
//         Setting18CCorNodeGraphModuleState>(
//       builder: (context, state) {
//         double minValue = 0.0;
//         double maxValue = 15.0;
//         return controlTextSlider(
//           context: context,
//           editMode: state.editMode,
//           title:
//               '${AppLocalizations.of(context)!.forwardInputEqualizer6} (${CustomStyle.dB}):',
//           minValue: minValue,
//           maxValue: maxValue,
//           currentValue: state.dsInSlope6,
//           onChanged: (dsInSlope6) {
//             context
//                 .read<Setting18CCorNodeGraphModuleBloc>()
//                 .add(DSInSlope6Changed(
//                   dsInSlope6: dsInSlope6,
//                 ));
//           },
//         );
//       },
//     );
//   }
// }

class _ForwardOutputEqualizer1 extends StatelessWidget {
  const _ForwardOutputEqualizer1();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
      builder: (context, state) {
        double minValue = state.dsOutSlope1.minValue;
        double maxValue = state.dsOutSlope1.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer1} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsOutSlope1.value,
          onChanged: (dsOutSlope1) {
            context
                .read<Setting18CCorNodeGraphModuleBloc>()
                .add(DSOutSlope1Changed(
                  dsOutSlope1: dsOutSlope1,
                ));
          },
          errorText: state.dsOutSlope1.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

class _ForwardOutputEqualizer3 extends StatelessWidget {
  const _ForwardOutputEqualizer3();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
      builder: (context, state) {
        double minValue = state.dsOutSlope3.minValue;
        double maxValue = state.dsOutSlope3.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsOutSlope3.value,
          onChanged: (dsOutSlope3) {
            context
                .read<Setting18CCorNodeGraphModuleBloc>()
                .add(DSOutSlope3Changed(
                  dsOutSlope3: dsOutSlope3,
                ));
          },
          errorText: state.dsOutSlope3.isNotValid
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
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
      builder: (context, state) {
        double minValue = state.dsOutSlope4.minValue;
        double maxValue = state.dsOutSlope4.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer4} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsOutSlope4.value,
          onChanged: (dsOutSlope4) {
            context
                .read<Setting18CCorNodeGraphModuleBloc>()
                .add(DSOutSlope4Changed(
                  dsOutSlope4: dsOutSlope4,
                ));
          },
          errorText: state.dsOutSlope4.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

class _ForwardOutputEqualizer6 extends StatelessWidget {
  const _ForwardOutputEqualizer6();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
      builder: (context, state) {
        double minValue = state.dsOutSlope6.minValue;
        double maxValue = state.dsOutSlope6.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer6} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsOutSlope6.value,
          onChanged: (dsOutSlope6) {
            context
                .read<Setting18CCorNodeGraphModuleBloc>()
                .add(DSOutSlope6Changed(
                  dsOutSlope6: dsOutSlope6,
                ));
          },
          errorText: state.dsOutSlope6.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

class _ForwardBiasCurrent1 extends StatelessWidget {
  const _ForwardBiasCurrent1();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
      builder: (context, state) {
        double minValue = state.biasCurrent1.minValue.toDouble();
        double maxValue = state.biasCurrent1.maxValue.toDouble();
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardBiasCurrent1} (${CustomStyle.milliAmps}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.biasCurrent1.value,
          step: 1.0,
          textPrecision: 0,
          onChanged: (biasCurrent1) {
            context
                .read<Setting18CCorNodeGraphModuleBloc>()
                .add(BiasCurrent1Changed(
                  biasCurrent1: biasCurrent1,
                ));
          },
          errorText: state.biasCurrent1.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

class _ForwardBiasCurrent3 extends StatelessWidget {
  const _ForwardBiasCurrent3();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
      builder: (context, state) {
        double minValue = state.biasCurrent3.minValue.toDouble();
        double maxValue = state.biasCurrent3.maxValue.toDouble();
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardBiasCurrent3} (${CustomStyle.milliAmps}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.biasCurrent3.value,
          step: 1.0,
          textPrecision: 0,
          onChanged: (biasCurrent3) {
            context
                .read<Setting18CCorNodeGraphModuleBloc>()
                .add(BiasCurrent3Changed(
                  biasCurrent3: biasCurrent3,
                ));
          },
          errorText: state.biasCurrent3.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

class _ForwardBiasCurrent4 extends StatelessWidget {
  const _ForwardBiasCurrent4();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
      builder: (context, state) {
        double minValue = state.biasCurrent4.minValue.toDouble();
        double maxValue = state.biasCurrent4.maxValue.toDouble();
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardBiasCurrent4} (${CustomStyle.milliAmps}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.biasCurrent4.value,
          step: 1.0,
          textPrecision: 0,
          onChanged: (biasCurrent4) {
            context
                .read<Setting18CCorNodeGraphModuleBloc>()
                .add(BiasCurrent4Changed(
                  biasCurrent4: biasCurrent4,
                ));
          },
          errorText: state.biasCurrent4.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

class _ForwardBiasCurrent6 extends StatelessWidget {
  const _ForwardBiasCurrent6();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
      builder: (context, state) {
        double minValue = state.biasCurrent6.minValue.toDouble();
        double maxValue = state.biasCurrent6.maxValue.toDouble();
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardBiasCurrent6} (${CustomStyle.milliAmps}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.biasCurrent6.value,
          step: 1.0,
          textPrecision: 0,
          onChanged: (biasCurrent6) {
            context
                .read<Setting18CCorNodeGraphModuleBloc>()
                .add(BiasCurrent6Changed(
                  biasCurrent6: biasCurrent6,
                ));
          },
          errorText: state.biasCurrent6.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

class _ReturnInputAttenuation1 extends StatelessWidget {
  const _ReturnInputAttenuation1();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
      builder: (context, state) {
        double minValue = state.usVCA1.minValue;
        double maxValue = state.usVCA1.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation1} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.usVCA1.value,
          onChanged: (usVCA1) {
            context.read<Setting18CCorNodeGraphModuleBloc>().add(USVCA1Changed(
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
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
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
            context.read<Setting18CCorNodeGraphModuleBloc>().add(USVCA3Changed(
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
  const _ReturnInputAttenuation4();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
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
            context.read<Setting18CCorNodeGraphModuleBloc>().add(USVCA4Changed(
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

class _ReturnInputAttenuation6 extends StatelessWidget {
  const _ReturnInputAttenuation6();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
      builder: (context, state) {
        double minValue = state.usVCA6.minValue;
        double maxValue = state.usVCA6.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation6} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.usVCA6.value,
          onChanged: (usVCA6) {
            context.read<Setting18CCorNodeGraphModuleBloc>().add(USVCA6Changed(
                  usVCA6: usVCA6,
                ));
          },
          errorText: state.usVCA6.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          elevation: CustomStyle.graphSettingCardElevation,
          color: CustomStyle.graphSettingCardColor,
        );
      },
    );
  }
}

List<String> rtnIngressValues = const [
  '0',
  '1',
  '2',
  '4',
];

class _ReturnIngressSetting1 extends StatelessWidget {
  const _ReturnIngressSetting1();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
      buildWhen: (previous, current) =>
          previous.returnIngressSetting1 != current.returnIngressSetting1 ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return controlToggleButton(
          context: context,
          editMode: state.editMode,
          title: '${AppLocalizations.of(context)!.returnIngressSetting1}:',
          currentValue: state.returnIngressSetting1,
          onChanged: (int index) {
            context
                .read<Setting18CCorNodeGraphModuleBloc>()
                .add(ReturnIngressSetting1Changed(rtnIngressValues[index]));
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
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
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
            context
                .read<Setting18CCorNodeGraphModuleBloc>()
                .add(ReturnIngressSetting3Changed(rtnIngressValues[index]));
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
  const _ReturnIngressSetting4();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
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
            context
                .read<Setting18CCorNodeGraphModuleBloc>()
                .add(ReturnIngressSetting4Changed(rtnIngressValues[index]));
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

class _ReturnIngressSetting6 extends StatelessWidget {
  const _ReturnIngressSetting6();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
      buildWhen: (previous, current) =>
          previous.returnIngressSetting6 != current.returnIngressSetting6 ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return controlToggleButton(
          context: context,
          editMode: state.editMode,
          title: '${AppLocalizations.of(context)!.returnIngressSetting6}:',
          currentValue: state.returnIngressSetting6,
          onChanged: (int index) {
            context
                .read<Setting18CCorNodeGraphModuleBloc>()
                .add(ReturnIngressSetting6Changed(rtnIngressValues[index]));
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
                    print(editable);
                    if (kDebugMode) {
                      context
                          .read<Setting18CCorNodeGraphModuleBloc>()
                          .add(const SettingSubmitted());
                    } else {
                      bool? isMatch =
                          await showConfirmInputDialog(context: context);

                      if (context.mounted) {
                        if (isMatch != null) {
                          if (isMatch) {
                            context
                                .read<Setting18CCorNodeGraphModuleBloc>()
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
      final Setting18CCorNodeGraphModuleState setting18graphModuleState =
          context.watch<Setting18CCorNodeGraphModuleBloc>().state;

      bool editable = getEditable(homeState.loadingStatus);
      return getEditTools(
        enableSubmission: setting18graphModuleState.enableSubmission,
        editable: editable,
      );
    });
  }
}
