import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18_forward_control/setting18_forward_control_bloc.dart';
import 'package:aci_plus_app/setting/model/confirm_input_dialog.dart';
import 'package:aci_plus_app/setting/model/setting18_result_text.dart';
import 'package:aci_plus_app/setting/model/setting_widgets.dart';
import 'package:aci_plus_app/setting/views/custom_setting_dialog.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_graph_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18ForwardControlView extends StatelessWidget {
  const Setting18ForwardControlView({super.key});

  @override
  Widget build(BuildContext context) {
    HomeState homeState = context.watch<HomeBloc>().state;

    String partId = homeState.characteristicData[DataKey.partId] ?? '';
    // String currentDetectedSplitOption =
    //     homeState.characteristicData[DataKey.currentDetectedSplitOption] ?? '0';
    String agcMode = homeState.characteristicData[DataKey.agcMode] ?? '0';
    String alcMode = homeState.characteristicData[DataKey.alcMode] ?? '0';
    String currentInputAttenuation =
        homeState.characteristicData[DataKey.currentDSVVA1] ?? '';
    String currentInputEqualizer =
        homeState.characteristicData[DataKey.currentDSSlope1] ?? '';

    String factoryDefaultNumber =
        homeState.characteristicData[DataKey.factoryDefaultNumber] ?? '';

    String forwardCEQIndex =
        homeState.characteristicData[DataKey.forwardCEQIndex] ?? '';

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
              _ForwardInputAttenuation1(
                alcMode: alcMode,
                currentInputAttenuation: currentInputAttenuation,
              ),
            );
            break;
          case SettingControl.forwardInputEqualizer1:
            widgets.add(
              _ForwardInputEqualizer1(
                forwardCEQIndex: forwardCEQIndex,
                alcMode: alcMode,
                agcMode: agcMode,
                currentInputEqualizer: currentInputEqualizer,
              ),
            );
            break;
          case SettingControl.forwardOutputAttenuation3And4:
            widgets.add(
              const _ForwardOutputAttenuation3And4(),
            );
            break;
          case SettingControl.forwardOutputEqualizer3And4:
            widgets.add(
              const _ForwardOutputEqualizer3And4(),
            );
            break;
          case SettingControl.forwardOutputAttenuation2And3:
            widgets.add(
              const _ForwardOutputAttenuation2And3(),
            );
            break;
          case SettingControl.forwardOutputAttenuation5And6:
            widgets.add(
              const _ForwardOutputAttenuation5And6(),
            );
            break;
          case SettingControl.forwardOutputEqualizer2And3:
            widgets.add(
              const _ForwardOutputEqualizer2And3(),
            );
            break;
          case SettingControl.forwardOutputEqualizer5And6:
            widgets.add(
              const _ForwardOutputEqualizer5And6(),
            );
            break;
        }
      }

      return widgets.isNotEmpty
          ? widgets
          : [
              _ForwardInputAttenuation1(
                alcMode: alcMode,
                currentInputAttenuation: currentInputAttenuation,
              ),
              _ForwardInputEqualizer1(
                forwardCEQIndex: forwardCEQIndex,
                alcMode: alcMode,
                agcMode: agcMode,
                currentInputEqualizer: currentInputEqualizer,
              ),
              const _ForwardOutputAttenuation3And4(),
              const _ForwardOutputEqualizer3And4(),
              const _ForwardOutputAttenuation2And3(),
              const _ForwardOutputAttenuation5And6(),
              const _ForwardOutputEqualizer2And3(),
              const _ForwardOutputEqualizer5And6(),
            ];
    }

    Widget buildControlWidget(String partId) {
      List<Widget> forwardControlParameters =
          getForwardControlParameterWidgetsByPartId(partId);

      return Column(children: [
        forwardControlParameters.isNotEmpty
            ? _ForwardControlHeader(
                factoryDefaultNumber: factoryDefaultNumber,
              )
            : Container(),
        ...forwardControlParameters,
        const SizedBox(
          height: 120,
        ),
      ]);
    }

    return BlocListener<Setting18ForwardControlBloc,
        Setting18ForwardControlState>(
      listener: (context, state) async {
        if (state.submissionStatus.isSubmissionInProgress ||
            state.resetForwardValuesSubmissionStatus.isSubmissionInProgress) {
          await showInProgressDialog(context);
        } else if (state.submissionStatus.isSubmissionSuccess) {
          if (ModalRoute.of(context)?.isCurrent != true) {
            Navigator.of(context).pop();
          }
          List<Widget> rows = getMessageRows(
            context: context,
            partId: partId,
            settingResultList: state.settingResult,
          );
          showResultDialog(
            context: context,
            messageRows: rows,
          );

          context.read<Setting18ForwardControlBloc>().add(const Initialized());
        } else if (state
            .resetForwardValuesSubmissionStatus.isSubmissionSuccess) {
          if (ModalRoute.of(context)?.isCurrent != true) {
            Navigator.of(context).pop();
          }
          showResetToDefaultSuccessDialog(context);
          context.read<Setting18ForwardControlBloc>().add(const Initialized());
        } else if (state
            .resetForwardValuesSubmissionStatus.isSubmissionFailure) {
          if (ModalRoute.of(context)?.isCurrent != true) {
            Navigator.of(context).pop();
          }
          showResetToDefaultFailureDialog(context);
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

class _ForwardControlHeader extends StatelessWidget {
  const _ForwardControlHeader({
    super.key,
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
              TextButton(
                child: Text(
                  AppLocalizations.of(context)!.dialogMessageCancel,
                ),
                onPressed: () {
                  Navigator.of(context).pop(false); // pop dialog
                },
              ),
              TextButton(
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
      if (factoryDefaultNumber == '21' || factoryDefaultNumber == '22') {
        return true;
      } else {
        return false;
      }
    }

    return BlocBuilder<Setting18ForwardControlBloc,
        Setting18ForwardControlState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  AppLocalizations.of(context)!.forwardControlParameters,
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
                                    .dialogMessageResetForwardToDefault,
                              ).then((isConfirm) {
                                if (isConfirm != null) {
                                  if (isConfirm) {
                                    if (kDebugMode) {
                                      context
                                          .read<Setting18ForwardControlBloc>()
                                          .add(
                                              const ResetForwardValuesRequested());
                                    } else {
                                      showConfirmInputDialog(context: context)
                                          .then((isMatch) {
                                        if (isMatch != null) {
                                          if (isMatch) {
                                            context
                                                .read<
                                                    Setting18ForwardControlBloc>()
                                                .add(
                                                    const ResetForwardValuesRequested());
                                          }
                                        }
                                      });
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
      },
    );
  }
}

class _ForwardInputAttenuation1 extends StatelessWidget {
  const _ForwardInputAttenuation1({
    super.key,
    required this.alcMode,
    required this.currentInputAttenuation,
  });

  final String alcMode;
  final String currentInputAttenuation;

  @override
  Widget build(BuildContext context) {
    // String getCurrentValue(String fwdInputAttenuation) {
    //   return alcMode == '0' ? fwdInputAttenuation : currentInputAttenuation;
    // }

    return BlocBuilder<Setting18ForwardControlBloc,
        Setting18ForwardControlState>(
      builder: (context, state) {
        // forwardInputAttenuation1TextEditingController.text = state.dsVVA1;
        double minValue = 0.0;
        double maxValue = 30.0;
        String inputAttenuation = getInputAttenuation(
          alcMode: alcMode,
          inputAttenuation: state.dsVVA1,
          currentInputAttenuation: currentInputAttenuation,
        );
        return controlTextSlider(
          context: context,
          editMode: state.editMode && alcMode == '0',
          title:
              '${AppLocalizations.of(context)!.forwardInputAttenuation1} (${CustomStyle.dB}):',
          minValue: minValue,
          currentValue: inputAttenuation,
          maxValue: maxValue,
          onChanged: (dsVVA1) {
            context.read<Setting18ForwardControlBloc>().add(DSVVA1Changed(
                  dsVVA1: dsVVA1,
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
    // String getCurrentValue(String forwardInputEqualizer) {
    //   return alcMode == '0' && agcMode == '0'
    //       ? forwardInputEqualizer
    //       : currentInputEqualizer;
    // }

    return BlocBuilder<Setting18ForwardControlBloc,
        Setting18ForwardControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = getSlope1MaxValue(forwardCEQIndex);
        String inputEqualizer = getInputEqualizer(
          alcMode: alcMode,
          agcMode: agcMode,
          inputEqualizer: state.dsSlope1,
          currentInputEqualizer: currentInputEqualizer,
        );
        return controlTextSlider(
          context: context,
          editMode: state.editMode && alcMode == '0' && agcMode == '0',
          title:
              '${AppLocalizations.of(context)!.forwardInputEqualizer1} (${CustomStyle.dB}):',
          subTitle: getForwardCEQText(forwardCEQIndex),
          minValue: minValue,
          currentValue: inputEqualizer,
          maxValue: maxValue,
          onChanged: (dsSlope1) {
            context.read<Setting18ForwardControlBloc>().add(DSSlope1Changed(
                  dsSlope1: dsSlope1,
                ));
          },
        );
      },
    );
  }
}

class _ForwardOutputAttenuation2And3 extends StatelessWidget {
  const _ForwardOutputAttenuation2And3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ForwardControlBloc,
        Setting18ForwardControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 10.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputAttenuation2And3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsVVA4,
          onChanged: (dsVVA4) {
            context.read<Setting18ForwardControlBloc>().add(DSVVA4Changed(
                  dsVVA4: dsVVA4,
                ));
          },
        );
      },
    );
  }
}

class _ForwardOutputAttenuation3And4 extends StatelessWidget {
  const _ForwardOutputAttenuation3And4({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ForwardControlBloc,
        Setting18ForwardControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 10.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputAttenuation3And4} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsVVA4,
          onChanged: (dsVVA4) {
            context.read<Setting18ForwardControlBloc>().add(DSVVA4Changed(
                  dsVVA4: dsVVA4,
                ));
          },
        );
      },
    );
  }
}

class _ForwardOutputAttenuation5And6 extends StatelessWidget {
  const _ForwardOutputAttenuation5And6({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ForwardControlBloc,
        Setting18ForwardControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 10.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputAttenuation5And6} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsVVA5,
          onChanged: (dsVVA5) {
            context.read<Setting18ForwardControlBloc>().add(DSVVA5Changed(
                  dsVVA5: dsVVA5,
                ));
          },
        );
      },
    );
  }
}

class _ForwardOutputEqualizer2And3 extends StatelessWidget {
  const _ForwardOutputEqualizer2And3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ForwardControlBloc,
        Setting18ForwardControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 10.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer2And3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsSlope3,
          onChanged: (dsSlope3) {
            context.read<Setting18ForwardControlBloc>().add(DSSlope3Changed(
                  dsSlope3: dsSlope3,
                ));
          },
        );
      },
    );
  }
}

class _ForwardOutputEqualizer3And4 extends StatelessWidget {
  const _ForwardOutputEqualizer3And4({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ForwardControlBloc,
        Setting18ForwardControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 10.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer3And4} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsSlope3,
          onChanged: (dsSlope3) {
            context.read<Setting18ForwardControlBloc>().add(DSSlope3Changed(
                  dsSlope3: dsSlope3,
                ));
          },
        );
      },
    );
  }
}

class _ForwardOutputEqualizer5And6 extends StatelessWidget {
  const _ForwardOutputEqualizer5And6({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ForwardControlBloc,
        Setting18ForwardControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 10.0;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer5And6} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsSlope4,
          onChanged: (dsSlope4) {
            context.read<Setting18ForwardControlBloc>().add(DSSlope4Changed(
                  dsSlope4: dsSlope4,
                ));
          },
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
                        .read<Setting18ForwardControlBloc>()
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
                                .read<Setting18ForwardControlBloc>()
                                .add(const SettingSubmitted());
                          } else {
                            bool? isMatch =
                                await showConfirmInputDialog(context: context);

                            if (context.mounted) {
                              if (isMatch != null) {
                                if (isMatch) {
                                  context
                                      .read<Setting18ForwardControlBloc>()
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
                                  .read<Setting18ForwardControlBloc>()
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
                        .read<Setting18ForwardControlBloc>()
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
      final Setting18ForwardControlState setting18ForwardControlState =
          context.watch<Setting18ForwardControlBloc>().state;

      bool editable = getEditable(
        loadingStatus: homeState.loadingStatus,
      );
      return editable
          ? getEditTools(
              editMode: setting18ForwardControlState.editMode,
              enableSubmission: setting18ForwardControlState.enableSubmission,
            )
          : Container();
    });
  }
}
