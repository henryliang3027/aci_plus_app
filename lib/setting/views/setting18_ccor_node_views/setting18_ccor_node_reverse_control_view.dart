import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18_ccor_node_reverse_control_dart/setting18_ccor_node_reverse_control_bloc.dart';
import 'package:aci_plus_app/setting/model/confirm_input_dialog.dart';
import 'package:aci_plus_app/setting/model/setting18_result_text.dart';
import 'package:aci_plus_app/setting/model/setting_widgets.dart';
import 'package:aci_plus_app/setting/views/custom_setting_dialog.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_graph_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Seting18CCorNodeReverseControlView extends StatelessWidget {
  const Seting18CCorNodeReverseControlView({super.key});

  @override
  Widget build(BuildContext context) {
    HomeState homeState = context.watch<HomeBloc>().state;
    String partId = homeState.characteristicData[DataKey.partId] ?? '';

    List<Widget> getReturnControlParameterWidgetsByPartId(String partId) {
      Map<Enum, bool> itemsMap = SettingItemTable.itemsMap[partId] ?? {};
      List<Widget> widgets = [];

      List<Enum> enabledItems =
          itemsMap.keys.where((key) => itemsMap[key] == true).toList();

      enabledItems = enabledItems
          .where((item) => item.runtimeType == SettingControl)
          .toList();

      for (Enum name in enabledItems) {
        switch (name) {
          case SettingControl.returnInputAttenuation1:
            widgets.add(
              const _ReturnInputAttenuation1(),
            );
            break;
          case SettingControl.returnInputAttenuation2:
            break;
          case SettingControl.returnInputAttenuation3:
            widgets.add(
              const _ReturnInputAttenuation3(),
            );
            break;
          case SettingControl.returnInputAttenuation4:
            widgets.add(
              const _ReturnInputAttenuation4(),
            );
            break;
          case SettingControl.returnInputAttenuation5:
            break;
          case SettingControl.returnInputAttenuation6:
            widgets.add(
              const _ReturnInputAttenuation6(),
            );
            break;
          case SettingControl.returnInputAttenuation2And3:
            break;
          case SettingControl.returnInputAttenuation5And6:
            break;
          case SettingControl.returnOutputAttenuation1:
            break;
          case SettingControl.returnOutputEqualizer1:
            break;
          case SettingControl.returnIngressSetting1:
            widgets.add(
              const _ReturnIngressSetting1(),
            );
            break;
          case SettingControl.returnIngressSetting2:
            break;
          case SettingControl.returnIngressSetting3:
            widgets.add(
              const _ReturnIngressSetting3(),
            );
            break;
          case SettingControl.returnIngressSetting4:
            widgets.add(
              const _ReturnIngressSetting4(),
            );
            break;
          case SettingControl.returnIngressSetting5:
            break;
          case SettingControl.returnIngressSetting6:
            widgets.add(
              const _ReturnIngressSetting6(),
            );
            break;
          case SettingControl.returnIngressSetting2And3:
            break;
          case SettingControl.returnIngressSetting5And6:
            break;
        }
      }
      return widgets.isNotEmpty
          ? widgets
          : [
              const _ReturnInputAttenuation1(),
              const _ReturnInputAttenuation3(),
              const _ReturnInputAttenuation4(),
              const _ReturnInputAttenuation6(),
              const _ReturnIngressSetting1(),
              const _ReturnIngressSetting3(),
              const _ReturnIngressSetting4(),
              const _ReturnIngressSetting6(),
            ];
    }

    Widget buildControlWidget(String partId) {
      List<Widget> returnControlParameters =
          getReturnControlParameterWidgetsByPartId(partId);

      return Column(children: [
        returnControlParameters.isNotEmpty
            ? _ClusterTitle(
                title: AppLocalizations.of(context)!.returnControlParameters,
              )
            : Container(),
        ...returnControlParameters,
        const SizedBox(
          height: 120,
        ),
      ]);
    }

    return BlocListener<Setting18CCorNodeReverseControlBloc,
        Setting18CCorNodeReverseControlState>(
      listener: (context, state) async {
        if (state.submissionStatus.isSubmissionInProgress) {
          await showInProgressDialog(context);
        } else if (state.submissionStatus.isSubmissionSuccess) {
          if (ModalRoute.of(context)?.isCurrent != true) {
            Navigator.of(context).pop();
          }
          List<Widget> rows = get1P8GCCorNodeSettingMessageRows(
              context: context, settingResultList: state.settingResult);
          showResultDialog(
            context: context,
            messageRows: rows,
          );

          context
              .read<Setting18CCorNodeReverseControlBloc>()
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

class _ReturnInputAttenuation1 extends StatelessWidget {
  const _ReturnInputAttenuation1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeReverseControlBloc,
        Setting18CCorNodeReverseControlState>(
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
            context
                .read<Setting18CCorNodeReverseControlBloc>()
                .add(USVCA1Changed(
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
    return BlocBuilder<Setting18CCorNodeReverseControlBloc,
        Setting18CCorNodeReverseControlState>(
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
            context
                .read<Setting18CCorNodeReverseControlBloc>()
                .add(USVCA3Changed(
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
    return BlocBuilder<Setting18CCorNodeReverseControlBloc,
        Setting18CCorNodeReverseControlState>(
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
            context
                .read<Setting18CCorNodeReverseControlBloc>()
                .add(USVCA4Changed(
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
    return BlocBuilder<Setting18CCorNodeReverseControlBloc,
        Setting18CCorNodeReverseControlState>(
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
            context
                .read<Setting18CCorNodeReverseControlBloc>()
                .add(USVCA6Changed(
                  usVCA6: usVCA6,
                ));
          },
        );
      },
    );
  }
}

class _ReturnIngressSetting1 extends StatelessWidget {
  const _ReturnIngressSetting1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeReverseControlBloc,
        Setting18CCorNodeReverseControlState>(
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
                .read<Setting18CCorNodeReverseControlBloc>()
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
    return BlocBuilder<Setting18CCorNodeReverseControlBloc,
        Setting18CCorNodeReverseControlState>(
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
                .read<Setting18CCorNodeReverseControlBloc>()
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
    return BlocBuilder<Setting18CCorNodeReverseControlBloc,
        Setting18CCorNodeReverseControlState>(
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
                .read<Setting18CCorNodeReverseControlBloc>()
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
    return BlocBuilder<Setting18CCorNodeReverseControlBloc,
        Setting18CCorNodeReverseControlState>(
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
                .read<Setting18CCorNodeReverseControlBloc>()
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
                        .read<Setting18CCorNodeReverseControlBloc>()
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
                                .read<Setting18CCorNodeReverseControlBloc>()
                                .add(const SettingSubmitted());
                          } else {
                            bool? isMatch =
                                await showConfirmInputDialog(context: context);

                            if (context.mounted) {
                              if (isMatch != null) {
                                if (isMatch) {
                                  context
                                      .read<
                                          Setting18CCorNodeReverseControlBloc>()
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
                                  .read<Setting18CCorNodeReverseControlBloc>()
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
                        .read<Setting18CCorNodeReverseControlBloc>()
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
      final Setting18CCorNodeReverseControlState setting18ListViewState =
          context.watch<Setting18CCorNodeReverseControlBloc>().state;

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
