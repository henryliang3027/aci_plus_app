import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18_ccor_node_graph_module/setting18_ccor_node_graph_module_bloc.dart';
import 'package:aci_plus_app/setting/model/confirm_input_dialog.dart';
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
    String formatResultValue(String boolValue) {
      return boolValue == 'true'
          ? AppLocalizations.of(context)!.dialogMessageSuccessful
          : AppLocalizations.of(context)!.dialogMessageFailed;
    }

    String formatResultItem(String item) {
      if (item == DataKey.forwardConfig.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardConfigModeSetting;
      }
      if (item == DataKey.splitOption.name) {
        return AppLocalizations.of(context)!.dialogMessageSplitOptionSetting;
      } else if (item == DataKey.dsVVA1.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardInputAttenuation1Setting;
      } else if (item == DataKey.dsVVA3.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardInputAttenuation3Setting;
      } else if (item == DataKey.dsVVA4.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardInputAttenuation4Setting;
      } else if (item == DataKey.dsVVA6.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardInputAttenuation6Setting;
      } else if (item == DataKey.dsOutSlope1.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardOutputEqualizer1Setting;
      } else if (item == DataKey.dsOutSlope3.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardOutputEqualizer3Setting;
      } else if (item == DataKey.dsOutSlope4.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardOutputEqualizer4Setting;
      } else if (item == DataKey.dsOutSlope6.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardOutputEqualizer6Setting;
      } else if (item == DataKey.biasCurrent1.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardBiasCurrent1Setting;
      } else if (item == DataKey.biasCurrent3.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardBiasCurrent3Setting;
      } else if (item == DataKey.biasCurrent4.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardBiasCurrent4Setting;
      } else if (item == DataKey.biasCurrent6.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardBiasCurrent6Setting;
      } else if (item == DataKey.usVCA1.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnInputAttenuation1Setting;
      } else if (item == DataKey.usVCA3.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnInputAttenuation3Setting;
      } else if (item == DataKey.usVCA4.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnInputAttenuation4Setting;
      } else if (item == DataKey.usVCA6.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnInputAttenuation6Setting;
      } else if (item == DataKey.ingressSetting1.name) {
        return AppLocalizations.of(context)!.dialogMessageReturnIngress1Setting;
      } else if (item == DataKey.ingressSetting3.name) {
        return AppLocalizations.of(context)!.dialogMessageReturnIngress3Setting;
      } else if (item == DataKey.ingressSetting4.name) {
        return AppLocalizations.of(context)!.dialogMessageReturnIngress4Setting;
      } else if (item == DataKey.ingressSetting6.name) {
        return AppLocalizations.of(context)!.dialogMessageReturnIngress6Setting;
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

    Map<String, List<Widget>> forwardSettingWidgetsMap = {
      DataKey.forwardConfig.name: [const _ForwardConfig()],
      DataKey.splitOption.name: [const _SplitOption()],
      DataKey.dsVVA1.name: [const _ForwardInputAttenuation1()],
      DataKey.dsVVA3.name: [const _ForwardInputAttenuation3()],
      DataKey.dsVVA4.name: [const _ForwardInputAttenuation4()],
      DataKey.dsVVA6.name: [const _ForwardInputAttenuation6()],
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
      List<Widget> forwardSettingWidgets =
          forwardSettingWidgetsMap[widget.moduleName] ?? [];
      List<Widget> reverseSettingWidgets =
          reverseSettingWidgetsMap[widget.moduleName] ?? [];

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

    Color getBackgroundColor() {
      bool isForwardWidget =
          forwardSettingWidgetsMap.keys.contains(widget.moduleName);

      // 如果是下行模組, 就將背景設為淺藍色, 否則就視為上行模組, 設為粉紅色
      return isForwardWidget ? CustomStyle.customBlue : CustomStyle.customPink;
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

    return BlocListener<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
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
  const _SplitOption({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(builder: (context, state) {
      return splitOptionGridViewButton(
        context: context,
        editMode: true,
        splitOption: state.splitOption,
        onGridPressed: (index) => context
            .read<Setting18CCorNodeGraphModuleBloc>()
            .add(SplitOptionChanged(splitOption: splitOptionValues[index])),
      );
    });
  }
}

class _ForwardConfig extends StatelessWidget {
  const _ForwardConfig({super.key});

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
        );
      },
    );
  }
}

class _ForwardInputAttenuation1 extends StatelessWidget {
  const _ForwardInputAttenuation1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 25.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardInputAttenuation1} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsVVA1,
          onChanged: (dsVVA1) {
            context.read<Setting18CCorNodeGraphModuleBloc>().add(DSVVA1Changed(
                  dsVVA1: dsVVA1,
                ));
          },
        );
      },
    );
  }
}

class _ForwardInputAttenuation3 extends StatelessWidget {
  const _ForwardInputAttenuation3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 25.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardInputAttenuation3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsVVA3,
          onChanged: (dsVVA3) {
            context.read<Setting18CCorNodeGraphModuleBloc>().add(DSVVA3Changed(
                  dsVVA3: dsVVA3,
                ));
          },
        );
      },
    );
  }
}

class _ForwardInputAttenuation4 extends StatelessWidget {
  const _ForwardInputAttenuation4({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
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
          currentValue: state.dsVVA4,
          onChanged: (dsVVA4) {
            context.read<Setting18CCorNodeGraphModuleBloc>().add(DSVVA4Changed(
                  dsVVA4: dsVVA4,
                ));
          },
        );
      },
    );
  }
}

class _ForwardInputAttenuation6 extends StatelessWidget {
  const _ForwardInputAttenuation6({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 25.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation6} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsVVA6,
          onChanged: (dsVVA6) {
            context.read<Setting18CCorNodeGraphModuleBloc>().add(DSVVA6Changed(
                  dsVVA6: dsVVA6,
                ));
          },
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
  const _ForwardOutputEqualizer1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 8.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer1} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsOutSlope1,
          onChanged: (dsOutSlope1) {
            context
                .read<Setting18CCorNodeGraphModuleBloc>()
                .add(DSOutSlope1Changed(
                  dsOutSlope1: dsOutSlope1,
                ));
          },
        );
      },
    );
  }
}

class _ForwardOutputEqualizer3 extends StatelessWidget {
  const _ForwardOutputEqualizer3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 8.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsOutSlope3,
          onChanged: (dsOutSlope3) {
            context
                .read<Setting18CCorNodeGraphModuleBloc>()
                .add(DSOutSlope3Changed(
                  dsOutSlope3: dsOutSlope3,
                ));
          },
        );
      },
    );
  }
}

class _ForwardOutputEqualizer4 extends StatelessWidget {
  const _ForwardOutputEqualizer4({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 8.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer4} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsOutSlope4,
          onChanged: (dsOutSlope4) {
            context
                .read<Setting18CCorNodeGraphModuleBloc>()
                .add(DSOutSlope4Changed(
                  dsOutSlope4: dsOutSlope4,
                ));
          },
        );
      },
    );
  }
}

class _ForwardOutputEqualizer6 extends StatelessWidget {
  const _ForwardOutputEqualizer6({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 8.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer6} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsOutSlope6,
          onChanged: (dsOutSlope6) {
            context
                .read<Setting18CCorNodeGraphModuleBloc>()
                .add(DSOutSlope6Changed(
                  dsOutSlope6: dsOutSlope6,
                ));
          },
        );
      },
    );
  }
}

class _ForwardBiasCurrent1 extends StatelessWidget {
  const _ForwardBiasCurrent1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
      builder: (context, state) {
        double minValue = 320.0;
        double maxValue = 520.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardBiasCurrent1} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.biasCurrent1,
          onChanged: (biasCurrent1) {
            context
                .read<Setting18CCorNodeGraphModuleBloc>()
                .add(BiasCurrent1Changed(
                  biasCurrent1: biasCurrent1,
                ));
          },
        );
      },
    );
  }
}

class _ForwardBiasCurrent3 extends StatelessWidget {
  const _ForwardBiasCurrent3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
      builder: (context, state) {
        double minValue = 320.0;
        double maxValue = 520.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardBiasCurrent3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.biasCurrent3,
          onChanged: (biasCurrent3) {
            context
                .read<Setting18CCorNodeGraphModuleBloc>()
                .add(BiasCurrent3Changed(
                  biasCurrent3: biasCurrent3,
                ));
          },
        );
      },
    );
  }
}

class _ForwardBiasCurrent4 extends StatelessWidget {
  const _ForwardBiasCurrent4({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
      builder: (context, state) {
        double minValue = 320.0;
        double maxValue = 520.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardBiasCurrent4} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.biasCurrent4,
          onChanged: (biasCurrent4) {
            context
                .read<Setting18CCorNodeGraphModuleBloc>()
                .add(BiasCurrent4Changed(
                  biasCurrent4: biasCurrent4,
                ));
          },
        );
      },
    );
  }
}

class _ForwardBiasCurrent6 extends StatelessWidget {
  const _ForwardBiasCurrent6({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
      builder: (context, state) {
        double minValue = 320.0;
        double maxValue = 520.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardBiasCurrent6} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.biasCurrent6,
          onChanged: (biasCurrent6) {
            context
                .read<Setting18CCorNodeGraphModuleBloc>()
                .add(BiasCurrent6Changed(
                  biasCurrent6: biasCurrent6,
                ));
          },
        );
      },
    );
  }
}

class _ReturnInputAttenuation1 extends StatelessWidget {
  const _ReturnInputAttenuation1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 25.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation1} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.usVCA1,
          onChanged: (usVCA1) {
            context.read<Setting18CCorNodeGraphModuleBloc>().add(USVCA1Changed(
                  usVCA1: usVCA1,
                ));
          },
        );
      },
    );
  }
}

class _ReturnInputAttenuation3 extends StatelessWidget {
  const _ReturnInputAttenuation3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
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
            context.read<Setting18CCorNodeGraphModuleBloc>().add(USVCA3Changed(
                  usVCA3: usVCA3,
                ));
          },
        );
      },
    );
  }
}

class _ReturnInputAttenuation4 extends StatelessWidget {
  const _ReturnInputAttenuation4({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
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
            context.read<Setting18CCorNodeGraphModuleBloc>().add(USVCA4Changed(
                  usVCA4: usVCA4,
                ));
          },
        );
      },
    );
  }
}

class _ReturnInputAttenuation6 extends StatelessWidget {
  const _ReturnInputAttenuation6({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeGraphModuleBloc,
        Setting18CCorNodeGraphModuleState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 25.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation6} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.usVCA6,
          onChanged: (usVCA6) {
            context.read<Setting18CCorNodeGraphModuleBloc>().add(USVCA6Changed(
                  usVCA6: usVCA6,
                ));
          },
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
  const _ReturnIngressSetting1({
    super.key,
  });

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
        );
      },
    );
  }
}

class _ReturnIngressSetting3 extends StatelessWidget {
  const _ReturnIngressSetting3({
    super.key,
  });

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
        );
      },
    );
  }
}

class _ReturnIngressSetting4 extends StatelessWidget {
  const _ReturnIngressSetting4({
    super.key,
  });

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
        );
      },
    );
  }
}

class _ReturnIngressSetting6 extends StatelessWidget {
  const _ReturnIngressSetting6({
    super.key,
  });

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
