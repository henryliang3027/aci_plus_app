import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18_ccor_node_forward_control/setting18_ccor_node_forward_control_bloc.dart';
import 'package:aci_plus_app/setting/model/confirm_input_dialog.dart';
import 'package:aci_plus_app/setting/model/setting18_result_text.dart';
import 'package:aci_plus_app/setting/model/setting_widgets.dart';
import 'package:aci_plus_app/setting/views/custom_setting_dialog.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_graph_page.dart';
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

    List<Widget> getForwardControlParameterWidgetsByPartId(String partId) {
      Map<Enum, bool> itemsMap = SettingItemTable.itemsMap[partId] ?? {};
      List<Widget> widgets = [];

      List<Enum> enabledItems =
          itemsMap.keys.where((key) => itemsMap[key] == true).toList();

      enabledItems = enabledItems
          .where((item) => item.runtimeType == SettingControl)
          .toList();

      for (Enum name in enabledItems) {
        switch (name) {
          case SettingControl.forwardInputAttenuation1:
            widgets.add(
              const _ForwardInputAttenuation1(),
            );
            break;
          case SettingControl.forwardInputAttenuation2:
            break;
          case SettingControl.forwardInputAttenuation3:
            widgets.add(
              const _ForwardInputAttenuation3(),
            );
            break;
          case SettingControl.forwardInputAttenuation4:
            widgets.add(
              const _ForwardInputAttenuation4(),
            );
            break;
          case SettingControl.forwardInputAttenuation5:
            break;
          case SettingControl.forwardInputAttenuation6:
            widgets.add(
              const _ForwardInputAttenuation6(),
            );
            break;
          case SettingControl.forwardInputEqualizer1:
            widgets.add(
              const _ForwardInputEqualizer1(),
            );
            break;
          case SettingControl.forwardInputEqualizer2:
            break;
          case SettingControl.forwardInputEqualizer3:
            widgets.add(
              const _ForwardInputEqualizer3(),
            );
            break;
          case SettingControl.forwardInputEqualizer4:
            widgets.add(
              const _ForwardInputEqualizer4(),
            );
            break;
          case SettingControl.forwardInputEqualizer5:
            break;
          case SettingControl.forwardInputEqualizer6:
            widgets.add(
              const _ForwardInputEqualizer6(),
            );
            break;

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
              const _ForwardInputAttenuation1(),
              const _ForwardInputAttenuation3(),
              const _ForwardInputAttenuation4(),
              const _ForwardInputAttenuation6(),
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
          height: 120,
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
            child: Padding(
              padding: const EdgeInsets.all(
                CustomStyle.sizeXL,
              ),
              child: buildControlWidget(partId),
            ),
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
  const _ClusterTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
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

class _ForwardInputAttenuation1 extends StatelessWidget {
  const _ForwardInputAttenuation1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeForwardControlBloc,
        Setting18CCorNodeForwardControlState>(
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
            context
                .read<Setting18CCorNodeForwardControlBloc>()
                .add(DSVVA1Changed(
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
    return BlocBuilder<Setting18CCorNodeForwardControlBloc,
        Setting18CCorNodeForwardControlState>(
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
            context
                .read<Setting18CCorNodeForwardControlBloc>()
                .add(DSVVA3Changed(
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
    return BlocBuilder<Setting18CCorNodeForwardControlBloc,
        Setting18CCorNodeForwardControlState>(
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
            context
                .read<Setting18CCorNodeForwardControlBloc>()
                .add(DSVVA4Changed(
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
    return BlocBuilder<Setting18CCorNodeForwardControlBloc,
        Setting18CCorNodeForwardControlState>(
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
            context
                .read<Setting18CCorNodeForwardControlBloc>()
                .add(DSVVA6Changed(
                  dsVVA6: dsVVA6,
                ));
          },
        );
      },
    );
  }
}

class _ForwardInputEqualizer1 extends StatelessWidget {
  const _ForwardInputEqualizer1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeForwardControlBloc,
        Setting18CCorNodeForwardControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 15.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardInputEqualizer1} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsInSlope1,
          onChanged: (dsInSlope1) {
            context
                .read<Setting18CCorNodeForwardControlBloc>()
                .add(DSInSlope1Changed(
                  dsInSlope1: dsInSlope1,
                ));
          },
        );
      },
    );
  }
}

class _ForwardInputEqualizer3 extends StatelessWidget {
  const _ForwardInputEqualizer3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeForwardControlBloc,
        Setting18CCorNodeForwardControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 15.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardInputEqualizer3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsInSlope3,
          onChanged: (dsInSlope3) {
            context
                .read<Setting18CCorNodeForwardControlBloc>()
                .add(DSInSlope3Changed(
                  dsInSlope3: dsInSlope3,
                ));
          },
        );
      },
    );
  }
}

class _ForwardInputEqualizer4 extends StatelessWidget {
  const _ForwardInputEqualizer4({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeForwardControlBloc,
        Setting18CCorNodeForwardControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 15.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardInputEqualizer4} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsInSlope4,
          onChanged: (dsInSlope4) {
            context
                .read<Setting18CCorNodeForwardControlBloc>()
                .add(DSInSlope4Changed(
                  dsInSlope4: dsInSlope4,
                ));
          },
        );
      },
    );
  }
}

class _ForwardInputEqualizer6 extends StatelessWidget {
  const _ForwardInputEqualizer6({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeForwardControlBloc,
        Setting18CCorNodeForwardControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 15.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardInputEqualizer6} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsInSlope6,
          onChanged: (dsInSlope6) {
            context
                .read<Setting18CCorNodeForwardControlBloc>()
                .add(DSInSlope6Changed(
                  dsInSlope6: dsInSlope6,
                ));
          },
        );
      },
    );
  }
}

class _ForwardOutputEqualizer1 extends StatelessWidget {
  const _ForwardOutputEqualizer1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeForwardControlBloc,
        Setting18CCorNodeForwardControlState>(
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
                .read<Setting18CCorNodeForwardControlBloc>()
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
    return BlocBuilder<Setting18CCorNodeForwardControlBloc,
        Setting18CCorNodeForwardControlState>(
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
                .read<Setting18CCorNodeForwardControlBloc>()
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
    return BlocBuilder<Setting18CCorNodeForwardControlBloc,
        Setting18CCorNodeForwardControlState>(
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
                .read<Setting18CCorNodeForwardControlBloc>()
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
    return BlocBuilder<Setting18CCorNodeForwardControlBloc,
        Setting18CCorNodeForwardControlState>(
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
                .read<Setting18CCorNodeForwardControlBloc>()
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
    return BlocBuilder<Setting18CCorNodeForwardControlBloc,
        Setting18CCorNodeForwardControlState>(
      builder: (context, state) {
        double minValue = 320;
        double maxValue = 520;
        return biasCurrentTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardBiasCurrent1} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.biasCurrent1.value,
          onChanged: (biasCurrent1) {
            context
                .read<Setting18CCorNodeForwardControlBloc>()
                .add(BiasCurrent1Changed(
                  biasCurrent1: biasCurrent1,
                  maxValue: maxValue,
                  minValue: minValue,
                ));
          },
          errorText: state.biasCurrent1.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
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
    return BlocBuilder<Setting18CCorNodeForwardControlBloc,
        Setting18CCorNodeForwardControlState>(
      builder: (context, state) {
        double minValue = 320;
        double maxValue = 520;
        return biasCurrentTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardBiasCurrent3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.biasCurrent3.value,
          onChanged: (biasCurrent3) {
            context
                .read<Setting18CCorNodeForwardControlBloc>()
                .add(BiasCurrent3Changed(
                  biasCurrent3: biasCurrent3,
                  maxValue: maxValue,
                  minValue: minValue,
                ));
          },
          errorText: state.biasCurrent3.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
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
    return BlocBuilder<Setting18CCorNodeForwardControlBloc,
        Setting18CCorNodeForwardControlState>(
      builder: (context, state) {
        double minValue = 320;
        double maxValue = 520;
        return biasCurrentTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardBiasCurrent4} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.biasCurrent4.value,
          onChanged: (biasCurrent4) {
            context
                .read<Setting18CCorNodeForwardControlBloc>()
                .add(BiasCurrent4Changed(
                  biasCurrent4: biasCurrent4,
                  maxValue: maxValue,
                  minValue: minValue,
                ));
          },
          errorText: state.biasCurrent4.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
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
    return BlocBuilder<Setting18CCorNodeForwardControlBloc,
        Setting18CCorNodeForwardControlState>(
      builder: (context, state) {
        double minValue = 320;
        double maxValue = 520;
        return biasCurrentTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardBiasCurrent6} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.biasCurrent6.value,
          onChanged: (biasCurrent6) {
            context
                .read<Setting18CCorNodeForwardControlBloc>()
                .add(BiasCurrent6Changed(
                  biasCurrent6: biasCurrent6,
                  maxValue: maxValue,
                  minValue: minValue,
                ));
          },
          errorText: state.biasCurrent6.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
        );
      },
    );
  }
}

class _SettingFloatingActionButton extends StatelessWidget {
  const _SettingFloatingActionButton({
    super.key,
    required this.partId,
    // required this.currentDetectedSplitOption,
  });

  final String partId;
  // final String currentDetectedSplitOption;

  @override
  Widget build(BuildContext context) {
    Widget getEditTools({
      required bool editMode,
      required bool enableSubmission,
    }) {
      String graphFilePath = settingGraphFilePath[partId] ?? '';
      return editMode
          ? Column(
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
                        .read<Setting18CCorNodeForwardControlBloc>()
                        .add(const EditModeDisabled());
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
                                .read<Setting18CCorNodeForwardControlBloc>()
                                .add(const SettingSubmitted());
                          } else {
                            bool? isMatch =
                                await showConfirmInputDialog(context: context);

                            if (context.mounted) {
                              if (isMatch != null) {
                                if (isMatch) {
                                  context
                                      .read<
                                          Setting18CCorNodeForwardControlBloc>()
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
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                graphFilePath.isNotEmpty
                    ? FloatingActionButton(
                        // heroTag is used to solve exception: There are multiple heroes that share the same tag within a subtree.
                        heroTag: null,
                        shape: const CircleBorder(
                          side: BorderSide.none,
                        ),
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withAlpha(200),
                        child: Icon(
                          Icons.settings_input_composite,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        onPressed: () {
                          // 當 Setting18GraphPage 被 pop 後, 不管有沒有設定參數都重新初始化
                          Navigator.push(
                                  context,
                                  Setting18GraphPage.route(
                                    graphFilePath: graphFilePath,
                                  ))
                              .then((value) => context
                                  .read<Setting18CCorNodeForwardControlBloc>()
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
                        .read<Setting18CCorNodeForwardControlBloc>()
                        .add(const EditModeEnabled());
                  },
                ),
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
      final Setting18CCorNodeForwardControlState setting18ListViewState =
          context.watch<Setting18CCorNodeForwardControlBloc>().state;

      bool editable = getEditable(loadingStatus: homeState.loadingStatus);
      return editable
          ? getEditTools(
              editMode: setting18ListViewState.editMode,
              enableSubmission: setting18ListViewState.enableSubmission,
            )
          : Container();
    });
  }
}
