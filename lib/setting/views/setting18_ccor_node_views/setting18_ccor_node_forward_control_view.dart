import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18_ccor_node_forward_control/setting18_ccor_node_forward_control_bloc.dart';
import 'package:aci_plus_app/setting/model/card_color.dart';
import 'package:aci_plus_app/setting/model/confirm_input_dialog.dart';
import 'package:aci_plus_app/setting/model/setting18_result_text.dart';
import 'package:aci_plus_app/setting/model/setting_widgets.dart';
import 'package:aci_plus_app/setting/views/custom_setting_dialog.dart';
import 'package:aci_plus_app/setting/views/setting18_ccor_node_views/setting18_ccor_node_graph_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18CCorNodeForwardControlView extends StatelessWidget {
  const Setting18CCorNodeForwardControlView({super.key});

  @override
  Widget build(BuildContext context) {
    HomeState homeState = context.watch<HomeBloc>().state;
    String partId = homeState.characteristicData[DataKey.partId] ?? '';

    if (homeState.connectionStatus.isRequestFailure) {
      // 重新 Initialized, 讀取並顯示空值
      context
          .read<Setting18CCorNodeForwardControlBloc>()
          .add(const Initialized());
    }

    List<Widget> getForwardControlParameterWidgetsByPartId(String partId) {
      List<Enum> items = SettingItemTable.itemsMap[partId] ?? [];
      List<Widget> widgets = [];

      items =
          items.where((item) => item.runtimeType == SettingControl).toList();

      for (Enum name in items) {
        switch (name) {
          case SettingControl.forwardOutputAttenuation1:
            widgets.add(
              const _ForwardOutputAttenuation1(),
            );
            break;
          case SettingControl.forwardOutputAttenuation3:
            widgets.add(
              const _ForwardOutputAttenuation3(),
            );
            break;
          case SettingControl.forwardOutputAttenuation4:
            widgets.add(
              const _ForwardOutputAttenuation4(),
            );
            break;
          case SettingControl.forwardOutputAttenuation6:
            widgets.add(
              const _ForwardOutputAttenuation6(),
            );
            break;
          // case SettingControl.forwardInputEqualizer1:
          //   widgets.add(
          //     const _ForwardInputEqualizer1(),
          //   );
          //   break;
          // case SettingControl.forwardInputEqualizer2:
          //   break;
          // case SettingControl.forwardInputEqualizer3:
          //   widgets.add(
          //     const _ForwardInputEqualizer3(),
          //   );
          //   break;
          // case SettingControl.forwardInputEqualizer4:
          //   widgets.add(
          //     const _ForwardInputEqualizer4(),
          //   );
          //   break;
          // case SettingControl.forwardInputEqualizer5:
          //   break;
          // case SettingControl.forwardInputEqualizer6:
          //   widgets.add(
          //     const _ForwardInputEqualizer6(),
          //   );
          //   break;

          case SettingControl.forwardOutputEqualizer1:
            widgets.add(
              const _ForwardOutputEqualizer1(),
            );
            break;
          case SettingControl.forwardOutputEqualizer2:
            break;
          case SettingControl.forwardOutputEqualizer3:
            widgets.add(
              const _ForwardOutputEqualizer3(),
            );
            break;
          case SettingControl.forwardOutputEqualizer4:
            widgets.add(
              const _ForwardOutputEqualizer4(),
            );
            break;
          case SettingControl.forwardOutputEqualizer5:
            break;
          case SettingControl.forwardOutputEqualizer6:
            widgets.add(
              const _ForwardOutputEqualizer6(),
            );
            break;
          case SettingControl.forwardBiasCurrent1:
            widgets.add(
              const _ForwardBiasCurrent1(),
            );
            break;
          case SettingControl.forwardBiasCurrent3:
            widgets.add(
              const _ForwardBiasCurrent3(),
            );
            break;
          case SettingControl.forwardBiasCurrent4:
            widgets.add(
              const _ForwardBiasCurrent4(),
            );
            break;
          case SettingControl.forwardBiasCurrent6:
            widgets.add(
              const _ForwardBiasCurrent6(),
            );
            break;
        }
      }

      return widgets.isNotEmpty
          ? widgets
          : [
              const _ForwardOutputAttenuation1(),
              const _ForwardOutputAttenuation3(),
              const _ForwardOutputAttenuation4(),
              const _ForwardOutputAttenuation6(),
              const _ForwardOutputEqualizer1(),
              const _ForwardOutputEqualizer3(),
              const _ForwardOutputEqualizer4(),
              const _ForwardOutputEqualizer6(),
              const _ForwardBiasCurrent1(),
              const _ForwardBiasCurrent3(),
              const _ForwardBiasCurrent4(),
              const _ForwardBiasCurrent6(),
            ];
    }

    Widget buildControlWidget(String partId) {
      List<Widget> forwardControlParameters =
          getForwardControlParameterWidgetsByPartId(partId);

      return Column(children: [
        forwardControlParameters.isNotEmpty
            ? _ClusterTitle(
                title: AppLocalizations.of(context)!.forwardControlParameters,
              )
            : Container(),
        ...forwardControlParameters,
        const SizedBox(
          height: CustomStyle.formBottomSpacingL,
        ),
      ]);
    }

    return BlocListener<Setting18CCorNodeForwardControlBloc,
        Setting18CCorNodeForwardControlState>(
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
              .read<Setting18CCorNodeForwardControlBloc>()
              .add(const Initialized());
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: buildControlWidget(partId),
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

List<String> rtnIngressValues = const [
  '0',
  '1',
  '2',
  '4',
];

List<bool> getSelectionState(String selectedrtnIngress) {
  Map<String, bool> selectedrtnIngressMap = {
    '0': false,
    '1': false,
    '2': false,
    '4': false,
  };

  if (selectedrtnIngressMap.containsKey(selectedrtnIngress)) {
    selectedrtnIngressMap[selectedrtnIngress] = true;
  }

  return selectedrtnIngressMap.values.toList();
}

class _ClusterTitle extends StatelessWidget {
  const _ClusterTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: CustomStyle.sizeXL,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ForwardOutputAttenuation1 extends StatelessWidget {
  const _ForwardOutputAttenuation1();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeForwardControlBloc,
        Setting18CCorNodeForwardControlState>(
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
            context
                .read<Setting18CCorNodeForwardControlBloc>()
                .add(DSVVA1Changed(
                  dsVVA1: dsVVA1,
                ));
          },
          errorText: state.dsVVA1.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
              context: context,
              isTap: state.tappedSet.contains(DataKey.dsVVA1)),
        );
      },
    );
  }
}

class _ForwardOutputAttenuation3 extends StatelessWidget {
  const _ForwardOutputAttenuation3();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeForwardControlBloc,
        Setting18CCorNodeForwardControlState>(
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
            context
                .read<Setting18CCorNodeForwardControlBloc>()
                .add(DSVVA3Changed(
                  dsVVA3: dsVVA3,
                ));
          },
          errorText: state.dsVVA3.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
              context: context,
              isTap: state.tappedSet.contains(DataKey.dsVVA3)),
        );
      },
    );
  }
}

class _ForwardOutputAttenuation4 extends StatelessWidget {
  const _ForwardOutputAttenuation4();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeForwardControlBloc,
        Setting18CCorNodeForwardControlState>(
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
            context
                .read<Setting18CCorNodeForwardControlBloc>()
                .add(DSVVA4Changed(
                  dsVVA4: dsVVA4,
                ));
          },
          errorText: state.dsVVA4.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
              context: context,
              isTap: state.tappedSet.contains(DataKey.dsVVA4)),
        );
      },
    );
  }
}

class _ForwardOutputAttenuation6 extends StatelessWidget {
  const _ForwardOutputAttenuation6();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeForwardControlBloc,
        Setting18CCorNodeForwardControlState>(
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
            context
                .read<Setting18CCorNodeForwardControlBloc>()
                .add(DSVVA6Changed(
                  dsVVA6: dsVVA6,
                ));
          },
          errorText: state.dsVVA6.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
              context: context,
              isTap: state.tappedSet.contains(DataKey.dsVVA6)),
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
//     return BlocBuilder<Setting18CCorNodeForwardControlBloc,
//         Setting18CCorNodeForwardControlState>(
//       builder: (context, state) {
//         double minValue = state.dsInSlope1.minValue;
//         double maxValue = state.dsInSlope1.maxValue;
//         return controlTextSlider(
//           context: context,
//           editMode: state.editMode,
//           title:
//               '${AppLocalizations.of(context)!.forwardInputEqualizer1} (${CustomStyle.dB}):',
//           minValue: minValue,
//           maxValue: maxValue,
//           currentValue: state.dsInSlope1.value,
//           onChanged: (dsInSlope1) {
//             context
//                 .read<Setting18CCorNodeForwardControlBloc>()
//                 .add(DSInSlope1Changed(
//                   dsInSlope1: dsInSlope1,
//                 ));
//           },
//           errorText: state.dsInSlope1.isNotValid
//               ? AppLocalizations.of(context)!.textFieldErrorMessage
//               : null,
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
//     return BlocBuilder<Setting18CCorNodeForwardControlBloc,
//         Setting18CCorNodeForwardControlState>(
//       builder: (context, state) {
//         double minValue = state.dsInSlope3.minValue;
//         double maxValue = state.dsInSlope3.maxValue;
//         return controlTextSlider(
//           context: context,
//           editMode: state.editMode,
//           title:
//               '${AppLocalizations.of(context)!.forwardInputEqualizer3} (${CustomStyle.dB}):',
//           minValue: minValue,
//           maxValue: maxValue,
//           currentValue: state.dsInSlope3.value,
//           onChanged: (dsInSlope3) {
//             context
//                 .read<Setting18CCorNodeForwardControlBloc>()
//                 .add(DSInSlope3Changed(
//                   dsInSlope3: dsInSlope3,
//                 ));
//           },
//           errorText: state.dsInSlope3.isNotValid
//               ? AppLocalizations.of(context)!.textFieldErrorMessage
//               : null,
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
//     return BlocBuilder<Setting18CCorNodeForwardControlBloc,
//         Setting18CCorNodeForwardControlState>(
//       builder: (context, state) {
//         double minValue = state.dsInSlope4.minValue;
//         double maxValue = state.dsInSlope4.maxValue;
//         return controlTextSlider(
//           context: context,
//           editMode: state.editMode,
//           title:
//               '${AppLocalizations.of(context)!.forwardInputEqualizer4} (${CustomStyle.dB}):',
//           minValue: minValue,
//           maxValue: maxValue,
//           currentValue: state.dsInSlope4.value,
//           onChanged: (dsInSlope4) {
//             context
//                 .read<Setting18CCorNodeForwardControlBloc>()
//                 .add(DSInSlope4Changed(
//                   dsInSlope4: dsInSlope4,
//                 ));
//           },
//           errorText: state.dsInSlope4.isNotValid
//               ? AppLocalizations.of(context)!.textFieldErrorMessage
//               : null,
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
//     return BlocBuilder<Setting18CCorNodeForwardControlBloc,
//         Setting18CCorNodeForwardControlState>(
//       builder: (context, state) {
//         double minValue = state.dsInSlope6.minValue;
//         double maxValue = state.dsInSlope6.maxValue;
//         return controlTextSlider(
//           context: context,
//           editMode: state.editMode,
//           title:
//               '${AppLocalizations.of(context)!.forwardInputEqualizer6} (${CustomStyle.dB}):',
//           minValue: minValue,
//           maxValue: maxValue,
//           currentValue: state.dsInSlope6.value,
//           onChanged: (dsInSlope6) {
//             context
//                 .read<Setting18CCorNodeForwardControlBloc>()
//                 .add(DSInSlope6Changed(
//                   dsInSlope6: dsInSlope6,
//                 ));
//           },
//           errorText: state.dsInSlope6.isNotValid
//               ? AppLocalizations.of(context)!.textFieldErrorMessage
//               : null,
//         );
//       },
//     );
//   }
// }

class _ForwardOutputEqualizer1 extends StatelessWidget {
  const _ForwardOutputEqualizer1();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeForwardControlBloc,
        Setting18CCorNodeForwardControlState>(
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
                .read<Setting18CCorNodeForwardControlBloc>()
                .add(DSOutSlope1Changed(
                  dsOutSlope1: dsOutSlope1,
                ));
          },
          errorText: state.dsOutSlope1.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
              context: context,
              isTap: state.tappedSet.contains(DataKey.dsOutSlope1)),
        );
      },
    );
  }
}

class _ForwardOutputEqualizer3 extends StatelessWidget {
  const _ForwardOutputEqualizer3();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeForwardControlBloc,
        Setting18CCorNodeForwardControlState>(
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
                .read<Setting18CCorNodeForwardControlBloc>()
                .add(DSOutSlope3Changed(
                  dsOutSlope3: dsOutSlope3,
                ));
          },
          errorText: state.dsOutSlope3.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
              context: context,
              isTap: state.tappedSet.contains(DataKey.dsOutSlope3)),
        );
      },
    );
  }
}

class _ForwardOutputEqualizer4 extends StatelessWidget {
  const _ForwardOutputEqualizer4();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeForwardControlBloc,
        Setting18CCorNodeForwardControlState>(
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
                .read<Setting18CCorNodeForwardControlBloc>()
                .add(DSOutSlope4Changed(
                  dsOutSlope4: dsOutSlope4,
                ));
          },
          errorText: state.dsOutSlope4.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
              context: context,
              isTap: state.tappedSet.contains(DataKey.dsOutSlope4)),
        );
      },
    );
  }
}

class _ForwardOutputEqualizer6 extends StatelessWidget {
  const _ForwardOutputEqualizer6();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeForwardControlBloc,
        Setting18CCorNodeForwardControlState>(
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
                .read<Setting18CCorNodeForwardControlBloc>()
                .add(DSOutSlope6Changed(
                  dsOutSlope6: dsOutSlope6,
                ));
          },
          errorText: state.dsOutSlope6.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
              context: context,
              isTap: state.tappedSet.contains(DataKey.dsOutSlope6)),
        );
      },
    );
  }
}

class _ForwardBiasCurrent1 extends StatelessWidget {
  const _ForwardBiasCurrent1();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeForwardControlBloc,
        Setting18CCorNodeForwardControlState>(
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
                .read<Setting18CCorNodeForwardControlBloc>()
                .add(BiasCurrent1Changed(
                  biasCurrent1: biasCurrent1,
                ));
          },
          errorText: state.biasCurrent1.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
              context: context,
              isTap: state.tappedSet.contains(DataKey.biasCurrent1)),
        );
      },
    );
  }
}

class _ForwardBiasCurrent3 extends StatelessWidget {
  const _ForwardBiasCurrent3();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeForwardControlBloc,
        Setting18CCorNodeForwardControlState>(
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
                .read<Setting18CCorNodeForwardControlBloc>()
                .add(BiasCurrent3Changed(
                  biasCurrent3: biasCurrent3,
                ));
          },
          errorText: state.biasCurrent3.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
              context: context,
              isTap: state.tappedSet.contains(DataKey.biasCurrent3)),
        );
      },
    );
  }
}

class _ForwardBiasCurrent4 extends StatelessWidget {
  const _ForwardBiasCurrent4();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeForwardControlBloc,
        Setting18CCorNodeForwardControlState>(
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
                .read<Setting18CCorNodeForwardControlBloc>()
                .add(BiasCurrent4Changed(
                  biasCurrent4: biasCurrent4,
                ));
          },
          errorText: state.biasCurrent4.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
              context: context,
              isTap: state.tappedSet.contains(DataKey.biasCurrent4)),
        );
      },
    );
  }
}

class _ForwardBiasCurrent6 extends StatelessWidget {
  const _ForwardBiasCurrent6();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeForwardControlBloc,
        Setting18CCorNodeForwardControlState>(
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
                .read<Setting18CCorNodeForwardControlBloc>()
                .add(BiasCurrent6Changed(
                  biasCurrent6: biasCurrent6,
                ));
          },
          errorText: state.biasCurrent6.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
              context: context,
              isTap: state.tappedSet.contains(DataKey.biasCurrent6)),
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
          // getControlSetupWizard(
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
                  .read<Setting18CCorNodeForwardControlBloc>()
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
                            context.read<Setting18CCorNodeForwardControlBloc>(),
                        action: () {
                          context
                              .read<Setting18CCorNodeForwardControlBloc>()
                              .add(const SettingSubmitted());
                        },
                        waitForState: (state) {
                          Setting18CCorNodeForwardControlState
                              setting18CCorNodeForwardControlState =
                              state as Setting18CCorNodeForwardControlState;

                          return setting18CCorNodeForwardControlState
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

    Widget getDisabledEditModeTools({
      bool isExpertMode = false,
    }) {
      String graphFilePath = settingGraphFilePath[partId] ?? '';
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // getControlSetupWizard(
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
                            .read<Setting18CCorNodeForwardControlBloc>()
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
            backgroundColor: isExpertMode
                ? Theme.of(context).colorScheme.primary.withAlpha(200)
                : Colors.grey.withAlpha(200),
            onPressed: isExpertMode
                ? () {
                    context
                        .read<Setting18CCorNodeForwardControlBloc>()
                        .add(const EditModeEnabled());
                  }
                : null,
            child: Icon(
              Icons.edit,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      );
    }

    // 依照 ModeProperty 的狀態來決定是否顯示編輯模式的按鈕
    Widget getFloatingActionButtons({
      required bool editMode,
      required bool enableSubmission,
    }) {
      if (ModeProperty.isExpertMode) {
        return editMode
            ? getEnabledEditModeTools(
                enableSubmission: enableSubmission,
              )
            : getDisabledEditModeTools(isExpertMode: true);
      } else {
        return getDisabledEditModeTools();
      }
    }

    Widget getDisabledFloatingActionButtons() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // getControlSetupWizard(
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
      final Setting18CCorNodeForwardControlState
          setting18CCorNodeForwardControlState =
          context.watch<Setting18CCorNodeForwardControlBloc>().state;

      bool editable = getEditable(loadingStatus: homeState.loadingStatus);
      return editable
          ? getFloatingActionButtons(
              editMode: setting18CCorNodeForwardControlState.editMode,
              enableSubmission:
                  setting18CCorNodeForwardControlState.enableSubmission,
            )
          : getDisabledFloatingActionButtons();
    });
  }
}
