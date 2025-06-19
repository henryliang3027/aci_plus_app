import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';

import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18_reverse_control/setting18_reverse_control_bloc.dart';

import 'package:aci_plus_app/setting/model/card_color.dart';
import 'package:aci_plus_app/setting/model/confirm_input_dialog.dart';
import 'package:aci_plus_app/setting/model/setting18_result_text.dart';
import 'package:aci_plus_app/setting/model/setting_widgets.dart';
import 'package:aci_plus_app/setting/views/custom_setting_dialog.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_graph_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18ReverseControlView extends StatelessWidget {
  const Setting18ReverseControlView({super.key});

  @override
  Widget build(BuildContext context) {
    HomeState homeState = context.watch<HomeBloc>().state;

    String partId = homeState.characteristicData[DataKey.partId] ?? '';
    String factoryDefaultNumber =
        homeState.characteristicData[DataKey.factoryDefaultNumber] ?? '';

    if (homeState.connectionStatus.isRequestFailure) {
      // 重新 Initialized, 讀取並顯示空值
      context.read<Setting18ReverseControlBloc>().add(const Initialized());
    }

    // 當 emit 的 state 內容有變時才會執行
    // 設定項目有變則繼續判斷是否正在編輯模式, 如果不在編輯模式才更新
    if (!context.read<Setting18ReverseControlBloc>().state.editMode) {
      context.read<Setting18ReverseControlBloc>().add(const Initialized());
    }

    List<Widget> getReturnControlParameterWidgetsByPartId(String partId) {
      List<Enum> items = SettingItemTable.itemsMap[partId] ?? [];
      List<Widget> widgets = [];

      items =
          items.where((item) => item.runtimeType == SettingControl).toList();

      for (Enum name in items) {
        switch (name) {
          case SettingControl.returnInputAttenuation1:
            break;
          case SettingControl.returnInputAttenuation2:
            widgets.add(
              const _ReturnInputAttenuation2(),
            );
            break;
          case SettingControl.returnInputAttenuation3:
            widgets.add(
              const _ReturnInputAttenuation3(),
            );
            break;
          case SettingControl.returnInputAttenuation4:
            widgets.add(
              _ReturnInputAttenuation4(
                partId: partId,
              ),
            );
            break;
          case SettingControl.returnInputAttenuation5:
            break;
          case SettingControl.returnInputAttenuation6:
            break;
          case SettingControl.returnInputAttenuation2And3:
            widgets.add(
              const _ReturnInputAttenuation2And3(),
            );
            break;
          case SettingControl.returnInputAttenuation5And6:
            widgets.add(
              const _ReturnInputAttenuation5And6(),
            );
            break;
          case SettingControl.returnOutputAttenuation1:
            widgets.add(
              const _ReturnOutputAttenuation1(),
            );
            break;
          case SettingControl.returnOutputEqualizer1:
            widgets.add(
              const _ReturnOutputEqualizer1(),
            );
            break;
          // case SettingControl.returnIngressSetting1:
          //   break;
          // case SettingControl.returnIngressSetting2:
          //   widgets.add(
          //     const _ReturnIngressSetting2(),
          //   );
          //   break;
          // case SettingControl.returnIngressSetting3:
          //   widgets.add(
          //     const _ReturnIngressSetting3(),
          //   );
          //   break;
          // case SettingControl.returnIngressSetting4:
          //   widgets.add(
          //     _ReturnIngressSetting4(
          //       partId: partId,
          //     ),
          //   );
          //   break;
          // case SettingControl.returnIngressSetting5:
          //   break;
          // case SettingControl.returnIngressSetting6:
          //   break;
          // case SettingControl.returnIngressSetting2And3:
          //   widgets.add(
          //     const _ReturnIngressSetting2And3(),
          //   );
          //   break;
          // case SettingControl.returnIngressSetting5And6:
          //   widgets.add(
          //     const _ReturnIngressSetting5And6(),
          //   );
          //   break;
        }
      }
      return widgets.isNotEmpty
          ? widgets
          : [
              const _ReturnOutputAttenuation1(),
              const _ReturnOutputEqualizer1(),
              const _ReturnInputAttenuation2(),
              const _ReturnInputAttenuation3(),
              _ReturnInputAttenuation4(
                partId: partId,
              ),
              // const _ReturnIngressSetting2(),
              // const _ReturnIngressSetting3(),
              // _ReturnIngressSetting4(
              //   partId: partId,
              // ),
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

    return BlocListener<Setting18ReverseControlBloc,
        Setting18ReverseControlState>(
      listener: (context, state) async {
        if (state.submissionStatus.isSubmissionInProgress ||
            state.resetReverseValuesSubmissionStatus.isSubmissionInProgress) {
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

          context.read<Setting18ReverseControlBloc>().add(const Initialized());
        } else if (state
            .resetReverseValuesSubmissionStatus.isSubmissionSuccess) {
          if (ModalRoute.of(context)?.isCurrent != true) {
            Navigator.of(context).pop();
          }
          showResetToDefaultSuccessDialog(context);
          context.read<Setting18ReverseControlBloc>().add(const Initialized());
        } else if (state
            .resetReverseValuesSubmissionStatus.isSubmissionFailure) {
          if (ModalRoute.of(context)?.isCurrent != true) {
            Navigator.of(context).pop();
          }
          showResetToDefaultFailureDialog(context);
          context.read<Setting18ReverseControlBloc>().add(const Initialized());
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

class _ReverseControlHeader extends StatelessWidget {
  const _ReverseControlHeader({
    required this.factoryDefaultNumber,
  });

  final String factoryDefaultNumber;

  @override
  Widget build(BuildContext context) {
    Future<bool?> showNoticeDialog({
      required String message,
    }) async {
      return showDialog<bool?>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          var width = MediaQuery.of(context).size.width;
          // var height = MediaQuery.of(context).size.height;

          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: width * 0.1,
            ),
            title: Text(
              AppLocalizations.of(context)!.dialogTitleNotice,
              style: const TextStyle(
                color: CustomStyle.customYellow,
              ),
            ),
            content: SizedBox(
              width: width,
              child: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: CustomStyle.sizeL,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text(
                  AppLocalizations.of(context)!.dialogMessageCancel,
                ),
                onPressed: () {
                  Navigator.of(context).pop(false); // pop dialog
                },
              ),
              ElevatedButton(
                child: Text(
                  AppLocalizations.of(context)!.dialogMessageOk,
                ),
                onPressed: () {
                  Navigator.of(context).pop(true); // pop dialog
                },
              ),
            ],
          );
        },
      );
    }

    // '11' same as factory default
    // '12' up stream has changed
    // '21' down stream has changed
    // '22' not factory default
    bool isShowResetButton() {
      if (factoryDefaultNumber == '12' || factoryDefaultNumber == '22') {
        return true;
      } else {
        return false;
      }
    }

    return BlocBuilder<Setting18ReverseControlBloc,
        Setting18ReverseControlState>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.returnControlParameters,
                style: TextStyle(
                  fontSize: CustomStyle.sizeXL,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            isShowResetButton()
                ? ElevatedButton(
                    onPressed: state.editMode
                        ? () {
                            showNoticeDialog(
                              message: AppLocalizations.of(context)!
                                  .dialogMessageResetReverseToDefault,
                            ).then((isConfirm) async {
                              if (isConfirm != null) {
                                if (isConfirm) {
                                  bool shouldSubmit = false;

                                  if (kDebugMode) {
                                    // In debug mode, we always submit
                                    shouldSubmit = true;
                                  } else {
                                    // In release mode, show the confirmation dialog
                                    bool? isMatch =
                                        await showConfirmInputDialog(
                                            context: context);
                                    if (context.mounted) {
                                      shouldSubmit = isMatch ?? false;
                                    }
                                  }

                                  if (shouldSubmit) {
                                    handleUpdateAction(
                                      context: context,
                                      targetBloc: context
                                          .read<Setting18ReverseControlBloc>(),
                                      action: () {
                                        context
                                            .read<Setting18ReverseControlBloc>()
                                            .add(
                                                const ResetReverseValuesRequested());
                                      },
                                      waitForState: (state) {
                                        Setting18ReverseControlState
                                            setting18ReverseControlState = state
                                                as Setting18ReverseControlState;

                                        return setting18ReverseControlState
                                                .resetReverseValuesSubmissionStatus
                                                .isSubmissionSuccess ||
                                            setting18ReverseControlState
                                                .resetReverseValuesSubmissionStatus
                                                .isSubmissionFailure;
                                      },
                                    );
                                  }
                                }
                              }
                            });
                          }
                        : null,
                    child: Text(
                      AppLocalizations.of(context)!.reset,
                    ),
                  )
                : Container(),
          ],
        ),
      );
    });
  }
}

class _ReturnInputAttenuation2 extends StatelessWidget {
  const _ReturnInputAttenuation2();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ReverseControlBloc,
        Setting18ReverseControlState>(
      buildWhen: (previous, current) =>
          previous.targetValues[DataKey.usVCA1] !=
              current.targetValues[DataKey.usVCA1] ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        double minValue = state.targetValues[DataKey.usVCA1]?.minValue ?? 0.0;
        double maxValue = state.targetValues[DataKey.usVCA1]?.maxValue ?? 10.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation2} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.targetValues[DataKey.usVCA1]?.value ?? '0.0',
          onChanged: (usVCA1) {
            context.read<Setting18ReverseControlBloc>().add(ControlItemChanged(
                  dataKey: DataKey.usVCA1,
                  value: usVCA1,
                ));
          },
          errorText: state.targetValues[DataKey.usVCA1]?.isNotValid ?? false
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.usVCA1),
          ),
        );
      },
    );
  }
}

class _ReturnInputAttenuation3 extends StatelessWidget {
  const _ReturnInputAttenuation3();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ReverseControlBloc,
        Setting18ReverseControlState>(
      buildWhen: (previous, current) =>
          previous.targetValues[DataKey.usVCA3] !=
              current.targetValues[DataKey.usVCA3] ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        double minValue = state.targetValues[DataKey.usVCA3]?.minValue ?? 0.0;
        double maxValue = state.targetValues[DataKey.usVCA3]?.maxValue ?? 10.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.targetValues[DataKey.usVCA3]?.value ?? '0.0',
          onChanged: (usVCA3) {
            context.read<Setting18ReverseControlBloc>().add(ControlItemChanged(
                  dataKey: DataKey.usVCA3,
                  value: usVCA3,
                ));
          },
          errorText: state.targetValues[DataKey.usVCA3]?.isNotValid ?? false
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.usVCA3),
          ),
        );
      },
    );
  }
}

class _ReturnInputAttenuation2And3 extends StatelessWidget {
  const _ReturnInputAttenuation2And3();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ReverseControlBloc,
        Setting18ReverseControlState>(
      buildWhen: (previous, current) =>
          previous.targetValues[DataKey.usVCA3] !=
              current.targetValues[DataKey.usVCA3] ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        double minValue = state.targetValues[DataKey.usVCA3]?.minValue ?? 0.0;
        double maxValue = state.targetValues[DataKey.usVCA3]?.maxValue ?? 10.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation2And3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.targetValues[DataKey.usVCA3]?.value ?? '0.0',
          onChanged: (usVCA3) {
            context.read<Setting18ReverseControlBloc>().add(ControlItemChanged(
                  dataKey: DataKey.usVCA3,
                  value: usVCA3,
                ));
          },
          errorText: state.targetValues[DataKey.usVCA3]?.isNotValid ?? false
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.usVCA3),
          ),
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
      return BlocBuilder<Setting18ReverseControlBloc,
          Setting18ReverseControlState>(
        buildWhen: (previous, current) =>
            previous.targetValues[DataKey.usVCA1] !=
                current.targetValues[DataKey.usVCA1] ||
            previous.editMode != current.editMode,
        builder: (context, state) {
          double minValue = state.targetValues[DataKey.usVCA1]?.minValue ?? 0.0;
          double maxValue =
              state.targetValues[DataKey.usVCA1]?.maxValue ?? 10.0;
          return controlTextSlider(
            context: context,
            editMode: state.editMode,
            title:
                '${AppLocalizations.of(context)!.returnInputAttenuation4} (${CustomStyle.dB}):',
            minValue: minValue,
            maxValue: maxValue,
            currentValue: state.targetValues[DataKey.usVCA1]?.value ?? '0.0',
            onChanged: (usVCA1) {
              context
                  .read<Setting18ReverseControlBloc>()
                  .add(ControlItemChanged(
                    dataKey: DataKey.usVCA1,
                    value: usVCA1,
                  ));
            },
            errorText: state.targetValues[DataKey.usVCA1]?.isNotValid ?? false
                ? AppLocalizations.of(context)!.textFieldErrorMessage
                : null,
            color: getSettingListCardColor(
              context: context,
              isTap: state.tappedSet.contains(DataKey.usVCA1),
            ),
          );
        },
      );
    } else {
      return BlocBuilder<Setting18ReverseControlBloc,
          Setting18ReverseControlState>(
        buildWhen: (previous, current) =>
            previous.targetValues[DataKey.usVCA4] !=
                current.targetValues[DataKey.usVCA4] ||
            previous.editMode != current.editMode,
        builder: (context, state) {
          double minValue = state.targetValues[DataKey.usVCA4]?.minValue ?? 0.0;
          double maxValue =
              state.targetValues[DataKey.usVCA4]?.maxValue ?? 10.0;
          return controlTextSlider(
            context: context,
            editMode: state.editMode,
            title:
                '${AppLocalizations.of(context)!.returnInputAttenuation4} (${CustomStyle.dB}):',
            minValue: minValue,
            maxValue: maxValue,
            currentValue: state.targetValues[DataKey.usVCA4]?.value ?? '0.0',
            onChanged: (usVCA4) {
              context
                  .read<Setting18ReverseControlBloc>()
                  .add(ControlItemChanged(
                    dataKey: DataKey.usVCA4,
                    value: usVCA4,
                  ));
            },
            errorText: state.targetValues[DataKey.usVCA4]?.isNotValid ?? false
                ? AppLocalizations.of(context)!.textFieldErrorMessage
                : null,
            color: getSettingListCardColor(
              context: context,
              isTap: state.tappedSet.contains(DataKey.usVCA4),
            ),
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
    return BlocBuilder<Setting18ReverseControlBloc,
        Setting18ReverseControlState>(
      buildWhen: (previous, current) =>
          previous.targetValues[DataKey.usVCA4] !=
              current.targetValues[DataKey.usVCA4] ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        double minValue = state.targetValues[DataKey.usVCA4]?.minValue ?? 0.0;
        double maxValue = state.targetValues[DataKey.usVCA4]?.maxValue ?? 10.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation5And6} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.targetValues[DataKey.usVCA4]?.value ?? '0.0',
          onChanged: (usVCA4) {
            context.read<Setting18ReverseControlBloc>().add(ControlItemChanged(
                  dataKey: DataKey.usVCA4,
                  value: usVCA4,
                ));
          },
          errorText: state.targetValues[DataKey.usVCA4]?.isNotValid ?? false
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.usVCA4),
          ),
        );
      },
    );
  }
}

class _ReturnOutputAttenuation1 extends StatelessWidget {
  const _ReturnOutputAttenuation1();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ReverseControlBloc,
        Setting18ReverseControlState>(
      buildWhen: (previous, current) =>
          previous.targetValues[DataKey.usVCA2] !=
              current.targetValues[DataKey.usVCA2] ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        double minValue = state.targetValues[DataKey.usVCA2]?.minValue ?? 0.0;
        double maxValue = state.targetValues[DataKey.usVCA2]?.maxValue ?? 10.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnOutputAttenuation1} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.targetValues[DataKey.usVCA2]?.value ?? '0.0',
          onChanged: (usVCA2) {
            context.read<Setting18ReverseControlBloc>().add(ControlItemChanged(
                  dataKey: DataKey.usVCA2,
                  value: usVCA2,
                ));
          },
          errorText: state.targetValues[DataKey.usVCA2]?.isNotValid ?? false
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.usVCA2),
          ),
        );
      },
    );
  }
}

class _ReturnOutputEqualizer1 extends StatelessWidget {
  const _ReturnOutputEqualizer1();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ReverseControlBloc,
        Setting18ReverseControlState>(
      buildWhen: (previous, current) =>
          previous.targetValues[DataKey.eREQ] !=
              current.targetValues[DataKey.eREQ] ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        double minValue = state.targetValues[DataKey.eREQ]?.minValue ?? 0.0;
        double maxValue = state.targetValues[DataKey.eREQ]?.maxValue ?? 10.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnOutputEqualizer1} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.targetValues[DataKey.eREQ]?.value ?? '0.0',
          onChanged: (eREQ) {
            context.read<Setting18ReverseControlBloc>().add(ControlItemChanged(
                  dataKey: DataKey.eREQ,
                  value: eREQ,
                ));
          },
          errorText: state.targetValues[DataKey.eREQ]?.isNotValid ?? false
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.eREQ),
          ),
        );
      },
    );
  }
}

// const List<String> rtnIngressValues = [
//   '0',
//   '1',
//   '2',
//   '4',
// ];

// class _ReturnIngressSetting2 extends StatelessWidget {
//   const _ReturnIngressSetting2();

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<Setting18ReverseControlBloc,
//         Setting18ReverseControlState>(
//       buildWhen: (previous, current) =>
//           previous.targetIngressValues[DataKey.ingressSetting2] !=
//               current.targetIngressValues[DataKey.ingressSetting2] ||
//           previous.editMode != current.editMode,
//       builder: (context, state) {
//         return controlToggleButton(
//           context: context,
//           editMode: state.editMode,
//           title: '${AppLocalizations.of(context)!.returnIngressSetting2}:',
//           currentValue:
//               state.targetIngressValues[DataKey.ingressSetting2] ?? '0',
//           onChanged: (int index) {
//             context.read<Setting18ReverseControlBloc>().add(ControlItemChanged(
//                   dataKey: DataKey.ingressSetting2,
//                   value: rtnIngressValues[index],
//                 ));
//           },
//           values: rtnIngressValues,
//           texts: [
//             '0dB',
//             '-3dB',
//             '-6dB',
//             AppLocalizations.of(context)!.ingressOpen,
//           ],
//           color: getSettingListCardColor(
//             context: context,
//             isTap: state.tappedSet.contains(DataKey.ingressSetting2),
//           ),
//         );
//       },
//     );
//   }
// }

// class _ReturnIngressSetting3 extends StatelessWidget {
//   const _ReturnIngressSetting3();

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<Setting18ReverseControlBloc,
//         Setting18ReverseControlState>(
//       buildWhen: (previous, current) =>
//           previous.targetIngressValues[DataKey.ingressSetting3] !=
//               current.targetIngressValues[DataKey.ingressSetting3] ||
//           previous.editMode != current.editMode,
//       builder: (context, state) {
//         return controlToggleButton(
//           context: context,
//           editMode: state.editMode,
//           title: '${AppLocalizations.of(context)!.returnIngressSetting3}:',
//           currentValue:
//               state.targetIngressValues[DataKey.ingressSetting3] ?? '0',
//           onChanged: (int index) {
//             context.read<Setting18ReverseControlBloc>().add(ControlItemChanged(
//                   dataKey: DataKey.ingressSetting3,
//                   value: rtnIngressValues[index],
//                 ));
//           },
//           values: rtnIngressValues,
//           texts: [
//             '0dB',
//             '-3dB',
//             '-6dB',
//             AppLocalizations.of(context)!.ingressOpen,
//           ],
//           color: getSettingListCardColor(
//             context: context,
//             isTap: state.tappedSet.contains(DataKey.ingressSetting3),
//           ),
//         );
//       },
//     );
//   }
// }

// class _ReturnIngressSetting4 extends StatelessWidget {
//   const _ReturnIngressSetting4({
//     required this.partId,
//   });

//   final String partId;

//   @override
//   Widget build(BuildContext context) {
//     if (partId == '5') {
//       return BlocBuilder<Setting18ReverseControlBloc,
//           Setting18ReverseControlState>(
//         buildWhen: (previous, current) =>
//             previous.targetIngressValues[DataKey.ingressSetting2] !=
//                 current.targetIngressValues[DataKey.ingressSetting2] ||
//             previous.editMode != current.editMode,
//         builder: (context, state) {
//           return controlToggleButton(
//             context: context,
//             editMode: state.editMode,
//             title: '${AppLocalizations.of(context)!.returnIngressSetting4}:',
//             currentValue:
//                 state.targetIngressValues[DataKey.ingressSetting2] ?? '0',
//             onChanged: (int index) {
//               context
//                   .read<Setting18ReverseControlBloc>()
//                   .add(ControlItemChanged(
//                     dataKey: DataKey.ingressSetting2,
//                     value: rtnIngressValues[index],
//                   ));
//             },
//             values: rtnIngressValues,
//             texts: [
//               '0dB',
//               '-3dB',
//               '-6dB',
//               AppLocalizations.of(context)!.ingressOpen,
//             ],
//             color: getSettingListCardColor(
//               context: context,
//               isTap: state.tappedSet.contains(DataKey.ingressSetting2),
//             ),
//           );
//         },
//       );
//     } else {
//       return BlocBuilder<Setting18ReverseControlBloc,
//           Setting18ReverseControlState>(
//         buildWhen: (previous, current) =>
//             previous.targetIngressValues[DataKey.ingressSetting4] !=
//                 current.targetIngressValues[DataKey.ingressSetting4] ||
//             previous.editMode != current.editMode,
//         builder: (context, state) {
//           return controlToggleButton(
//             context: context,
//             editMode: state.editMode,
//             title: '${AppLocalizations.of(context)!.returnIngressSetting4}:',
//             currentValue:
//                 state.targetIngressValues[DataKey.ingressSetting4] ?? '0',
//             onChanged: (int index) {
//               context
//                   .read<Setting18ReverseControlBloc>()
//                   .add(ControlItemChanged(
//                     dataKey: DataKey.ingressSetting4,
//                     value: rtnIngressValues[index],
//                   ));
//             },
//             values: rtnIngressValues,
//             texts: [
//               '0dB',
//               '-3dB',
//               '-6dB',
//               AppLocalizations.of(context)!.ingressOpen,
//             ],
//             color: getSettingListCardColor(
//               context: context,
//               isTap: state.tappedSet.contains(DataKey.ingressSetting4),
//             ),
//           );
//         },
//       );
//     }
//   }
// }

// class _ReturnIngressSetting2And3 extends StatelessWidget {
//   const _ReturnIngressSetting2And3();

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<Setting18ReverseControlBloc,
//         Setting18ReverseControlState>(
//       buildWhen: (previous, current) =>
//           previous.targetIngressValues[DataKey.ingressSetting3] !=
//               current.targetIngressValues[DataKey.ingressSetting3] ||
//           previous.editMode != current.editMode,
//       builder: (context, state) {
//         return controlToggleButton(
//           context: context,
//           editMode: state.editMode,
//           title: '${AppLocalizations.of(context)!.returnIngressSetting2And3}:',
//           currentValue:
//               state.targetIngressValues[DataKey.ingressSetting3] ?? '0',
//           onChanged: (int index) {
//             context.read<Setting18ReverseControlBloc>().add(ControlItemChanged(
//                   dataKey: DataKey.ingressSetting3,
//                   value: rtnIngressValues[index],
//                 ));
//           },
//           values: rtnIngressValues,
//           texts: [
//             '0dB',
//             '-3dB',
//             '-6dB',
//             AppLocalizations.of(context)!.ingressOpen,
//           ],
//           color: getSettingListCardColor(
//             context: context,
//             isTap: state.tappedSet.contains(DataKey.ingressSetting3),
//           ),
//         );
//       },
//     );
//   }
// }

// class _ReturnIngressSetting5And6 extends StatelessWidget {
//   const _ReturnIngressSetting5And6();

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<Setting18ReverseControlBloc,
//         Setting18ReverseControlState>(
//       buildWhen: (previous, current) =>
//           previous.targetIngressValues[DataKey.ingressSetting4] !=
//               current.targetIngressValues[DataKey.ingressSetting4] ||
//           previous.editMode != current.editMode,
//       builder: (context, state) {
//         return controlToggleButton(
//           context: context,
//           editMode: state.editMode,
//           title: '${AppLocalizations.of(context)!.returnIngressSetting5And6}:',
//           currentValue:
//               state.targetIngressValues[DataKey.ingressSetting4] ?? '0',
//           onChanged: (int index) {
//             context.read<Setting18ReverseControlBloc>().add(ControlItemChanged(
//                   dataKey: DataKey.ingressSetting4,
//                   value: rtnIngressValues[index],
//                 ));
//           },
//           values: rtnIngressValues,
//           texts: [
//             '0dB',
//             '-3dB',
//             '-6dB',
//             AppLocalizations.of(context)!.ingressOpen,
//           ],
//           color: getSettingListCardColor(
//             context: context,
//             isTap: state.tappedSet.contains(DataKey.ingressSetting4),
//           ),
//         );
//       },
//     );
//   }
// }

// class _USTGC extends StatelessWidget {
//   const _USTGC({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<Setting18ReverseControlBloc, Setting18ReverseControlState>(
//       builder: (context, state) {
//         return controlTextSlider(
//           context: context,
//           editMode: state.editMode,
//           title: 'US TGC: ${state.usTGC} dB',
//           minValue: 0.0,
//           maxValue: 15.0,
//           currentValue: _getValue(state.usTGC),
//           onChanged: (value) {
//             context
//                 .read<Setting18ReverseControlBloc>()
//                 .add(USTGCChanged(value.toStringAsFixed(1)));
//           },
//         );
//       },
//     );
//   }
// }

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
      return SingleChildScrollView(
        clipBehavior: Clip.none,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // getControlSetupWizard(
            //   context: context,
            //   aciDeviceType: ACIDeviceType.amp1P8G,
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
                    .read<Setting18ReverseControlBloc>()
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
                              context.read<Setting18ReverseControlBloc>(),
                          action: () {
                            context
                                .read<Setting18ReverseControlBloc>()
                                .add(const SettingSubmitted());
                          },
                          waitForState: (state) {
                            Setting18ReverseControlState
                                setting18ReverseControlState =
                                state as Setting18ReverseControlState;

                            return setting18ReverseControlState
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

    Widget getDisabledEditModeTools({
      bool isExpertMode = false,
    }) {
      String graphFilePath = settingGraphFilePath[partId] ?? '';
      return SingleChildScrollView(
        clipBehavior: Clip.none,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // getControlSetupWizard(
            //   context: context,
            //   aciDeviceType: ACIDeviceType.amp1P8G,
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
                          Setting18GraphPage.route(
                            graphFilePath: graphFilePath,
                          )).then((value) {
                        context
                            .read<Setting18ReverseControlBloc>()
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
              backgroundColor: isExpertMode
                  ? Theme.of(context).colorScheme.primary.withAlpha(200)
                  : Colors.grey.withAlpha(200),
              onPressed: isExpertMode
                  ? () {
                      context
                          .read<Setting18ReverseControlBloc>()
                          .add(const EditModeEnabled());
                    }
                  : null,
              child: Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      );
    }

    Widget getDisabledFloatingActionButtons() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // getControlSetupWizard(
          //   context: context,
          //   aciDeviceType: ACIDeviceType.amp1P8G,
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
      if (ModeProperty.isExpertMode) {
        return editMode
            ? getEnabledEditModeTools(
                enableSubmission: enableSubmission,
              )
            : getDisabledEditModeTools(
                isExpertMode: true,
              );
      } else {
        return getDisabledEditModeTools();
      }
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
      final Setting18ReverseControlState setting18ReverseControlState =
          context.watch<Setting18ReverseControlBloc>().state;

      bool editable = getEditable(
        loadingStatus: homeState.loadingStatus,
      );
      return editable
          ? getFloatingActionButtons(
              editMode: setting18ReverseControlState.editMode,
              enableSubmission: setting18ReverseControlState.enableSubmission,
            )
          : getDisabledFloatingActionButtons();
    });
  }
}
