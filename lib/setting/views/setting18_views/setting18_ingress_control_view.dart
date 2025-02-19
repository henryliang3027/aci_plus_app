import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';

import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18/setting18_ingress_control/setting18_ingress_control_bloc.dart';

import 'package:aci_plus_app/setting/model/card_color.dart';
import 'package:aci_plus_app/setting/model/confirm_input_dialog.dart';
import 'package:aci_plus_app/setting/model/setting18_result_text.dart';
import 'package:aci_plus_app/setting/model/setting_widgets.dart';
import 'package:aci_plus_app/setting/shared/utils.dart';
import 'package:aci_plus_app/setting/views/custom_setting_dialog.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_graph_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18IngressControlView extends StatelessWidget {
  const Setting18IngressControlView({super.key});

  @override
  Widget build(BuildContext context) {
    HomeState homeState = context.watch<HomeBloc>().state;

    String partId = homeState.characteristicData[DataKey.partId] ?? '';
    String factoryDefaultNumber =
        homeState.characteristicData[DataKey.factoryDefaultNumber] ?? '';

    if (homeState.connectionStatus.isRequestFailure) {
      // 重新 Initialized, 讀取並顯示空值
      context.read<Setting18IngressControlBloc>().add(const Initialized());
    }

    // 當 emit 的內容有變時才會執行, 執行時判斷 ceq 是否有變, 如果沒有則代表其他內容有變,
    // 例如 ingress 有變則繼續判斷是否正在編輯模式, 如果不在編輯模式才更新
    if (homeState.ceqStatus != CEQStatus.none) {
      context.read<Setting18IngressControlBloc>().add(const Initialized());
    } else {
      if (!context.read<Setting18IngressControlBloc>().state.editMode) {
        context.read<Setting18IngressControlBloc>().add(const Initialized());
      }
    }

    List<Widget> getReturnControlParameterWidgetsByPartId(String partId) {
      List<Enum> items = SettingItemTable.itemsMap[partId] ?? [];
      List<Widget> widgets = [];

      items =
          items.where((item) => item.runtimeType == SettingControl).toList();

      for (Enum name in items) {
        switch (name) {
          case SettingControl.returnIngressSetting1:
            break;
          case SettingControl.returnIngressSetting2:
            widgets.add(
              const _ReturnIngressSetting2(),
            );
            break;
          case SettingControl.returnIngressSetting3:
            widgets.add(
              const _ReturnIngressSetting3(),
            );
            break;
          case SettingControl.returnIngressSetting4:
            widgets.add(
              _ReturnIngressSetting4(
                partId: partId,
              ),
            );
            break;
          case SettingControl.returnIngressSetting5:
            break;
          case SettingControl.returnIngressSetting6:
            break;
          case SettingControl.returnIngressSetting2And3:
            widgets.add(
              const _ReturnIngressSetting2And3(),
            );
            break;
          case SettingControl.returnIngressSetting5And6:
            widgets.add(
              const _ReturnIngressSetting5And6(),
            );
            break;
        }
      }
      return widgets.isNotEmpty
          ? widgets
          : [
              const _ReturnIngressSetting2(),
              const _ReturnIngressSetting3(),
              _ReturnIngressSetting4(
                partId: partId,
              ),
            ];
    }

    Widget buildControlWidget(String partId) {
      List<Widget> returnControlParameters =
          getReturnControlParameterWidgetsByPartId(partId);

      return Column(children: [
        ...returnControlParameters,
        const SizedBox(
          height: CustomStyle.formBottomSpacingL,
        ),
      ]);
    }

    return BlocListener<Setting18IngressControlBloc,
        Setting18IngressControlState>(
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

          context.read<Setting18IngressControlBloc>().add(const Initialized());
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

const List<String> rtnIngressValues = [
  '0',
  '1',
  '2',
  '4',
  '5',
];

List<String> _getIngressTexts(BuildContext context) {
  return [
    AppLocalizations.of(context)!.ingressDefault('0 ${CustomStyle.dB}'),
    AppLocalizations.of(context)!.ingressTemporary('-3 ${CustomStyle.dB}'),
    AppLocalizations.of(context)!.ingressTemporary('-6 ${CustomStyle.dB}'),
    AppLocalizations.of(context)!.ingressOpenTemporary,
    AppLocalizations.of(context)!.ingressOpenPermanent,
  ];
}

class _ReturnIngressSetting2 extends StatelessWidget {
  const _ReturnIngressSetting2();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18IngressControlBloc,
        Setting18IngressControlState>(
      buildWhen: (previous, current) =>
          previous.targetValues[DataKey.ingressSetting2] !=
              current.targetValues[DataKey.ingressSetting2] ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return ingressGridViewButton(
          context: context,
          editMode: state.editMode,
          title: '${AppLocalizations.of(context)!.returnIngressSetting2}:',
          currentValue: state.targetValues[DataKey.ingressSetting2] ?? '0',
          onChanged: (index) {
            context.read<Setting18IngressControlBloc>().add(ControlItemChanged(
                  dataKey: DataKey.ingressSetting2,
                  value: rtnIngressValues[index],
                ));
          },
          values: rtnIngressValues,
          texts: _getIngressTexts(context),
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.ingressSetting2),
          ),
        );
      },
    );
  }
}

class _ReturnIngressSetting3 extends StatelessWidget {
  const _ReturnIngressSetting3();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18IngressControlBloc,
        Setting18IngressControlState>(
      buildWhen: (previous, current) =>
          previous.targetValues[DataKey.ingressSetting3] !=
              current.targetValues[DataKey.ingressSetting3] ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return ingressGridViewButton(
          context: context,
          editMode: state.editMode,
          title: '${AppLocalizations.of(context)!.returnIngressSetting3}:',
          currentValue: state.targetValues[DataKey.ingressSetting3] ?? '0',
          onChanged: (index) {
            context.read<Setting18IngressControlBloc>().add(ControlItemChanged(
                  dataKey: DataKey.ingressSetting3,
                  value: rtnIngressValues[index],
                ));
          },
          values: rtnIngressValues,
          texts: _getIngressTexts(context),
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.ingressSetting3),
          ),
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
      return BlocBuilder<Setting18IngressControlBloc,
          Setting18IngressControlState>(
        buildWhen: (previous, current) =>
            previous.targetValues[DataKey.ingressSetting2] !=
                current.targetValues[DataKey.ingressSetting2] ||
            previous.editMode != current.editMode,
        builder: (context, state) {
          return ingressGridViewButton(
            context: context,
            editMode: state.editMode,
            title: '${AppLocalizations.of(context)!.returnIngressSetting4}:',
            currentValue: state.targetValues[DataKey.ingressSetting2] ?? '0',
            onChanged: (index) {
              context
                  .read<Setting18IngressControlBloc>()
                  .add(ControlItemChanged(
                    dataKey: DataKey.ingressSetting2,
                    value: rtnIngressValues[index],
                  ));
            },
            values: rtnIngressValues,
            texts: _getIngressTexts(context),
            color: getSettingListCardColor(
              context: context,
              isTap: state.tappedSet.contains(DataKey.ingressSetting2),
            ),
          );
        },
      );
    } else {
      return BlocBuilder<Setting18IngressControlBloc,
          Setting18IngressControlState>(
        buildWhen: (previous, current) =>
            previous.targetValues[DataKey.ingressSetting4] !=
                current.targetValues[DataKey.ingressSetting4] ||
            previous.editMode != current.editMode,
        builder: (context, state) {
          return ingressGridViewButton(
            context: context,
            editMode: state.editMode,
            title: '${AppLocalizations.of(context)!.returnIngressSetting4}:',
            currentValue: state.targetValues[DataKey.ingressSetting4] ?? '0',
            onChanged: (index) {
              context
                  .read<Setting18IngressControlBloc>()
                  .add(ControlItemChanged(
                    dataKey: DataKey.ingressSetting4,
                    value: rtnIngressValues[index],
                  ));
            },
            values: rtnIngressValues,
            texts: _getIngressTexts(context),
            color: getSettingListCardColor(
              context: context,
              isTap: state.tappedSet.contains(DataKey.ingressSetting4),
            ),
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
    return BlocBuilder<Setting18IngressControlBloc,
        Setting18IngressControlState>(
      buildWhen: (previous, current) =>
          previous.targetValues[DataKey.ingressSetting3] !=
              current.targetValues[DataKey.ingressSetting3] ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return ingressGridViewButton(
          context: context,
          editMode: state.editMode,
          title: '${AppLocalizations.of(context)!.returnIngressSetting2And3}:',
          currentValue: state.targetValues[DataKey.ingressSetting3] ?? '0',
          onChanged: (index) {
            context.read<Setting18IngressControlBloc>().add(ControlItemChanged(
                  dataKey: DataKey.ingressSetting3,
                  value: rtnIngressValues[index],
                ));
          },
          values: rtnIngressValues,
          texts: _getIngressTexts(context),
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.ingressSetting3),
          ),
        );
      },
    );
  }
}

class _ReturnIngressSetting5And6 extends StatelessWidget {
  const _ReturnIngressSetting5And6();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18IngressControlBloc,
        Setting18IngressControlState>(
      buildWhen: (previous, current) =>
          previous.targetValues[DataKey.ingressSetting4] !=
              current.targetValues[DataKey.ingressSetting4] ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return ingressGridViewButton(
          context: context,
          editMode: state.editMode,
          title: '${AppLocalizations.of(context)!.returnIngressSetting5And6}:',
          currentValue: state.targetValues[DataKey.ingressSetting4] ?? '0',
          onChanged: (index) {
            context.read<Setting18IngressControlBloc>().add(ControlItemChanged(
                  dataKey: DataKey.ingressSetting4,
                  value: rtnIngressValues[index],
                ));
          },
          values: rtnIngressValues,
          texts: _getIngressTexts(context),
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.ingressSetting4),
          ),
        );
      },
    );
  }
}

class _SettingFloatingActionButton extends StatelessWidget {
  const _SettingFloatingActionButton({
    required this.partId,
  });

  final String partId;

  @override
  Widget build(BuildContext context) {
    Widget getEnabledEditModeTools({
      required bool enableSubmission,
    }) {
      return SingleChildScrollView(
        clipBehavior: Clip.none,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            getControlSetupWizard(
              context: context,
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
                CustomIcons.cancel,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () {
                context
                    .read<Setting18IngressControlBloc>()
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
                              context.read<Setting18IngressControlBloc>(),
                          action: () {
                            context
                                .read<Setting18IngressControlBloc>()
                                .add(const SettingSubmitted());
                          },
                          waitForState: (state) {
                            Setting18IngressControlState
                                setting18IngressControlState =
                                state as Setting18IngressControlState;

                            return setting18IngressControlState
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
        ),
      );
    }

    Widget getDisabledEditModeTools() {
      String graphFilePath = settingGraphFilePath[partId] ?? '';
      return SingleChildScrollView(
        clipBehavior: Clip.none,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            getControlSetupWizard(
              context: context,
            ),
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
                          Setting18GraphPage.route(
                            graphFilePath: graphFilePath,
                          )).then((value) {
                        context
                            .read<Setting18IngressControlBloc>()
                            .add(const Initialized());
                      });
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
                    .read<Setting18IngressControlBloc>()
                    .add(const EditModeEnabled());
              },
            ),
          ],
        ),
      );
    }

    Widget getDisabledFloatingActionButtons() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          getControlSetupWizard(
            context: context,
          ),
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
      final Setting18IngressControlState setting18IngressControlState =
          context.watch<Setting18IngressControlBloc>().state;

      bool editable = getEditable(
        loadingStatus: homeState.loadingStatus,
      );
      return editable
          ? getFloatingActionButtons(
              editMode: setting18IngressControlState.editMode,
              enableSubmission: setting18IngressControlState.enableSubmission,
            )
          : getDisabledFloatingActionButtons();
    });
  }
}
