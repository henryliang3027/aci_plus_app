import 'dart:io';

import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18_ccor_node_reverse_control_dart/setting18_ccor_node_reverse_control_bloc.dart';
import 'package:aci_plus_app/setting/model/card_color.dart';
import 'package:aci_plus_app/setting/model/confirm_input_dialog.dart';
import 'package:aci_plus_app/setting/model/setting18_result_text.dart';
import 'package:aci_plus_app/setting/model/setting_widgets.dart';
import 'package:aci_plus_app/setting/shared/utils.dart';
import 'package:aci_plus_app/setting/views/custom_setting_dialog.dart';
import 'package:aci_plus_app/setting/views/setting18_ccor_node_views/setting18_ccor_node_graph_page.dart';
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

    if (homeState.connectionStatus.isRequestFailure) {
      // 重新 Initialized, 讀取並顯示空值
      context
          .read<Setting18CCorNodeReverseControlBloc>()
          .add(const Initialized());
    }

    List<Widget> getReturnControlParameterWidgetsByPartId(String partId) {
      List<Enum> items = SettingItemTable.itemsMap[partId] ?? [];
      List<Widget> widgets = [];

      items =
          items.where((item) => item.runtimeType == SettingControl).toList();

      for (Enum name in items) {
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
        }
      }
      return widgets.isNotEmpty
          ? widgets
          : [
              const _ReturnInputAttenuation1(),
              const _ReturnInputAttenuation3(),
              const _ReturnInputAttenuation4(),
              const _ReturnInputAttenuation6(),
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
          height: CustomStyle.formBottomSpacingL,
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

class _ReturnInputAttenuation1 extends StatelessWidget {
  const _ReturnInputAttenuation1();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeReverseControlBloc,
        Setting18CCorNodeReverseControlState>(
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
            context
                .read<Setting18CCorNodeReverseControlBloc>()
                .add(USVCA1Changed(
                  usVCA1: usVCA1,
                ));
          },
          errorText: state.usVCA1.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
              context: context,
              isTap: state.tappedSet.contains(DataKey.usVCA1)),
        );
      },
    );
  }
}

class _ReturnInputAttenuation3 extends StatelessWidget {
  const _ReturnInputAttenuation3();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeReverseControlBloc,
        Setting18CCorNodeReverseControlState>(
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
            context
                .read<Setting18CCorNodeReverseControlBloc>()
                .add(USVCA3Changed(
                  usVCA3: usVCA3,
                ));
          },
          errorText: state.usVCA3.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
              context: context,
              isTap: state.tappedSet.contains(DataKey.usVCA3)),
        );
      },
    );
  }
}

class _ReturnInputAttenuation4 extends StatelessWidget {
  const _ReturnInputAttenuation4();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeReverseControlBloc,
        Setting18CCorNodeReverseControlState>(
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
            context
                .read<Setting18CCorNodeReverseControlBloc>()
                .add(USVCA4Changed(
                  usVCA4: usVCA4,
                ));
          },
          errorText: state.usVCA4.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
              context: context,
              isTap: state.tappedSet.contains(DataKey.usVCA4)),
        );
      },
    );
  }
}

class _ReturnInputAttenuation6 extends StatelessWidget {
  const _ReturnInputAttenuation6();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeReverseControlBloc,
        Setting18CCorNodeReverseControlState>(
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
            context
                .read<Setting18CCorNodeReverseControlBloc>()
                .add(USVCA6Changed(
                  usVCA6: usVCA6,
                ));
          },
          errorText: state.usVCA6.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
              context: context,
              isTap: state.tappedSet.contains(DataKey.usVCA6)),
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
                  .read<Setting18CCorNodeReverseControlBloc>()
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
                            context.read<Setting18CCorNodeReverseControlBloc>(),
                        action: () {
                          context
                              .read<Setting18CCorNodeReverseControlBloc>()
                              .add(const SettingSubmitted());
                        },
                        waitForState: (state) {
                          Setting18CCorNodeReverseControlState
                              setting18CCorNodeReverseControlState =
                              state as Setting18CCorNodeReverseControlState;

                          return setting18CCorNodeReverseControlState
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

    Widget getDisabledEditModeTools() {
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
                            .read<Setting18CCorNodeReverseControlBloc>()
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

    Widget getFloatingActionButtons({
      required bool editMode,
      required bool enableSubmission,
    }) {
      return editMode
          ? getEnabledEditModeTools(
              enableSubmission: enableSubmission,
            )
          : getDisabledEditModeTools();
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
      final Setting18CCorNodeReverseControlState
          setting18CCorNodeReverseControlState =
          context.watch<Setting18CCorNodeReverseControlBloc>().state;

      bool editable = getEditable(loadingStatus: homeState.loadingStatus);
      return editable
          ? getFloatingActionButtons(
              editMode: setting18CCorNodeReverseControlState.editMode,
              enableSubmission:
                  setting18CCorNodeReverseControlState.enableSubmission,
            )
          : getDisabledFloatingActionButtons();
    });
  }
}
