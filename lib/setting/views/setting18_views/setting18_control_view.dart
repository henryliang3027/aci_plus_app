import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:aci_plus_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18_control/setting18_control_bloc.dart';
import 'package:aci_plus_app/setting/model/confirm_input_dialog.dart';
import 'package:aci_plus_app/setting/model/setting_wisgets.dart';
import 'package:aci_plus_app/setting/views/custom_setting_dialog.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_graph_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18ControlView extends StatelessWidget {
  const Setting18ControlView({super.key});

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

    String formatResultValue(String boolValue) {
      return boolValue == 'true'
          ? AppLocalizations.of(context)!.dialogMessageSuccessful
          : AppLocalizations.of(context)!.dialogMessageFailed;
    }

    String formatResultItem(String item) {
      if (item == DataKey.dsVVA1.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardInputAttenuation1Setting;
      } else if (item == DataKey.dsSlope1.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardInputEqualizer1Setting;
      } else if (item == DataKey.usVCA1.name) {
        if (partId == '5' || partId == '6') {
          return AppLocalizations.of(context)!
              .dialogMessageReturnInputAttenuation4Setting;
        } else {
          return AppLocalizations.of(context)!
              .dialogMessageReturnInputAttenuation2Setting;
        }
      } else if (item == DataKey.usVCA3.name) {
        if (partId == '5' || partId == '6') {
          return AppLocalizations.of(context)!
              .dialogMessageReturnInputAttenuation2And3Setting;
        } else {
          return AppLocalizations.of(context)!
              .dialogMessageReturnInputAttenuation3Setting;
        }
      } else if (item == DataKey.usVCA4.name) {
        if (partId == '5' || partId == '6') {
          return AppLocalizations.of(context)!
              .dialogMessageReturnInputAttenuation5And6Setting;
        } else {
          return AppLocalizations.of(context)!
              .dialogMessageReturnInputAttenuation4Setting;
        }
      } else if (item == DataKey.usVCA2.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnOutputAttenuation1Setting;
      } else if (item == DataKey.eREQ.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnOutputEqualizer1Setting;
      } else if (item == DataKey.ingressSetting2.name) {
        if (partId == '5' || partId == '6') {
          return AppLocalizations.of(context)!
              .dialogMessageReturnIngress4Setting;
        } else {
          return AppLocalizations.of(context)!
              .dialogMessageReturnIngress2Setting;
        }
      } else if (item == DataKey.ingressSetting3.name) {
        if (partId == '5' || partId == '6') {
          return AppLocalizations.of(context)!
              .dialogMessageReturnIngress2And3Setting;
        } else {
          return AppLocalizations.of(context)!
              .dialogMessageReturnIngress3Setting;
        }
      } else if (item == DataKey.ingressSetting4.name) {
        if (partId == '5' || partId == '6') {
          return AppLocalizations.of(context)!
              .dialogMessageReturnIngress5And6Setting;
        } else {
          return AppLocalizations.of(context)!
              .dialogMessageReturnIngress4Setting;
        }
      } else if (item == DataKey.tgcCableLength.name) {
        return AppLocalizations.of(context)!.dialogMessageTGCCableLengthSetting;
      } else if (item == DataKey.dsVVA4.name) {
        if (partId == '5' || partId == '6') {
          return AppLocalizations.of(context)!
              .dialogMessageForwardOutputAttenuation2And3Setting;
        } else {
          return AppLocalizations.of(context)!
              .dialogMessageForwardOutputAttenuation3And4Setting;
        }
      } else if (item == DataKey.dsVVA5.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardOutputAttenuation5And6Setting;
      } else if (item == DataKey.dsSlope3.name) {
        if (partId == '5' || partId == '6') {
          return AppLocalizations.of(context)!
              .dialogMessageForwardOutputEqualizer2And3Setting;
        } else {
          return AppLocalizations.of(context)!
              .dialogMessageForwardOutputEqualizer3And4Setting;
        }
      } else if (item == DataKey.dsSlope4.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardOutputEqualizer5And6Setting;
      }
      // else if (item == DataKey.usTGC.name) {
      //   return AppLocalizations.of(context)!.dialogMessageUSTGCSetting;
      // }
      else {
        return '';
      }
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
              Expanded(
                child: Text(
                  formatResultValue(value),
                  style: TextStyle(
                    fontSize: CustomStyle.sizeL,
                    color: valueColor,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ));
      }
      return rows;
    }

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
              _ForwardInputAttenuation(
                alcMode: alcMode,
                currentInputAttenuation: currentInputAttenuation,
              ),
            );
            break;
          case SettingControl.forwardInputEqualizer1:
            widgets.add(
              _ForwardInputEqualizer(
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
              _ForwardInputAttenuation(
                alcMode: alcMode,
                currentInputAttenuation: currentInputAttenuation,
              ),
              _ForwardInputEqualizer(
                alcMode: alcMode,
                agcMode: agcMode,
                currentInputEqualizer: currentInputEqualizer,
              ),
              const _ForwardOutputAttenuation3And4(),
              const _ForwardOutputEqualizer3And4(),
            ];
    }

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
            break;
          case SettingControl.returnInputAttenuation2:
            widgets.add(
              const _RtnInputAttenuation2(),
            );
            break;
          case SettingControl.returnInputAttenuation3:
            widgets.add(
              const _RtnInputAttenuation3(),
            );
            break;
          case SettingControl.returnInputAttenuation4:
            widgets.add(
              _RtnInputAttenuation4(
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
              const _RtnInputAttenuation2And3(),
            );
            break;
          case SettingControl.returnInputAttenuation5And6:
            widgets.add(
              const _RtnInputAttenuation5And6(),
            );
            break;
          case SettingControl.returnOutputAttenuation1:
            widgets.add(
              const _RtnOutputLevelAttenuation(),
            );
            break;
          case SettingControl.returnOutputEqualizer1:
            widgets.add(
              const _RtnOutputEQ(),
            );
            break;
          case SettingControl.returnIngressSetting1:
            break;
          case SettingControl.returnIngressSetting2:
            widgets.add(
              const _RtnIngressSetting2(),
            );
            break;
          case SettingControl.returnIngressSetting3:
            widgets.add(
              const _RtnIngressSetting3(),
            );
            break;
          case SettingControl.returnIngressSetting4:
            widgets.add(
              _RtnIngressSetting4(
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
              const _RtnIngressSetting2And3(),
            );
            break;
          case SettingControl.returnIngressSetting5And6:
            widgets.add(
              const _RtnIngressSetting5And6(),
            );
            break;
        }
      }
      return widgets.isNotEmpty
          ? widgets
          : [
              const _RtnInputAttenuation2(),
              const _RtnInputAttenuation3(),
              _RtnInputAttenuation4(
                partId: partId,
              ),
              const _RtnOutputLevelAttenuation(),
              const _RtnOutputEQ(),
              const _RtnIngressSetting2(),
              const _RtnIngressSetting3(),
              _RtnIngressSetting4(
                partId: partId,
              ),
            ];
    }

    Widget buildControlWidget(String partId) {
      List<Widget> forwardControlParameters =
          getForwardControlParameterWidgetsByPartId(partId);
      List<Widget> returnControlParameters =
          getReturnControlParameterWidgetsByPartId(partId);

      return Column(children: [
        forwardControlParameters.isNotEmpty
            ? _ForwardControlHeader(
                factoryDefaultNumber: factoryDefaultNumber,
              )
            : Container(),
        ...forwardControlParameters,
        forwardControlParameters.isNotEmpty
            ? const Padding(
                padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 20.0),
                child: Divider(
                  height: 10.0,
                ),
              )
            : Container(),
        returnControlParameters.isNotEmpty
            ? _ReverseControlHeader(
                factoryDefaultNumber: factoryDefaultNumber,
              )
            : Container(),
        ...returnControlParameters,
        const SizedBox(
          height: 120,
        ),
      ]);
    }

    return BlocListener<Setting18ControlBloc, Setting18ControlState>(
      listener: (context, state) async {
        if (state.submissionStatus.isSubmissionInProgress ||
            state.resetForwardValuesSubmissionStatus.isSubmissionInProgress ||
            state.resetReverseValuesSubmissionStatus.isSubmissionInProgress) {
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

          context.read<Setting18ControlBloc>().add(const Initialized());
        } else if (state
            .resetForwardValuesSubmissionStatus.isSubmissionSuccess) {
          if (ModalRoute.of(context)?.isCurrent != true) {
            Navigator.of(context).pop();
          }
          showResetToDefaultSuccessDialog(context);
          context.read<Setting18ControlBloc>().add(const Initialized());
        } else if (state
            .resetForwardValuesSubmissionStatus.isSubmissionFailure) {
          if (ModalRoute.of(context)?.isCurrent != true) {
            Navigator.of(context).pop();
          }
          showResetToDefaultFailureDialog(context);
        } else if (state
            .resetReverseValuesSubmissionStatus.isSubmissionSuccess) {
          if (ModalRoute.of(context)?.isCurrent != true) {
            Navigator.of(context).pop();
          }
          showResetToDefaultSuccessDialog(context);
          context.read<Setting18ControlBloc>().add(const Initialized());
        } else if (state
            .resetReverseValuesSubmissionStatus.isSubmissionFailure) {
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

double _getValue(String value) {
  if (value.isNotEmpty) {
    return double.parse(value);
  } else {
    return 0.0;
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
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  AppLocalizations.of(context)!.dialogMessageOk,
                ),
                onPressed: () {
                  Navigator.of(context).pop(true); // pop dialog
                },
              ),
              TextButton(
                child: Text(
                  AppLocalizations.of(context)!.dialogMessageCancel,
                ),
                onPressed: () {
                  Navigator.of(context).pop(false); // pop dialog
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

    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
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
                                      context.read<Setting18ControlBloc>().add(
                                          const ResetForwardValuesRequested());
                                    } else {
                                      showConfirmInputDialog(context: context)
                                          .then((isMatch) {
                                        if (isMatch != null) {
                                          if (isMatch) {
                                            context
                                                .read<Setting18ControlBloc>()
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

class _ReverseControlHeader extends StatelessWidget {
  const _ReverseControlHeader({
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
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  AppLocalizations.of(context)!.dialogMessageOk,
                ),
                onPressed: () {
                  Navigator.of(context).pop(true); // pop dialog
                },
              ),
              TextButton(
                child: Text(
                  AppLocalizations.of(context)!.dialogMessageCancel,
                ),
                onPressed: () {
                  Navigator.of(context).pop(false); // pop dialog
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

    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
        builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
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
                            ).then((isConfirm) {
                              if (isConfirm != null) {
                                if (isConfirm) {
                                  if (kDebugMode) {
                                    context.read<Setting18ControlBloc>().add(
                                        const ResetReverseValuesRequested());
                                  } else {
                                    showConfirmInputDialog(context: context)
                                        .then((isMatch) {
                                      if (isMatch != null) {
                                        if (isMatch) {
                                          context.read<Setting18ControlBloc>().add(
                                              const ResetReverseValuesRequested());
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
    });
  }
}

class _ForwardInputAttenuation extends StatelessWidget {
  const _ForwardInputAttenuation({
    super.key,
    required this.alcMode,
    required this.currentInputAttenuation,
  });

  final String alcMode;
  final String currentInputAttenuation;

  @override
  Widget build(BuildContext context) {
    double getCurrentValue(String fwdInputAttenuation) {
      return alcMode == '0'
          ? _getValue(fwdInputAttenuation)
          : _getValue(currentInputAttenuation);
    }

    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        return controlParameterSlider(
          context: context,
          editMode: state.editMode && alcMode == '0',
          title:
              '${AppLocalizations.of(context)!.forwardInputAttenuation1}: ${getCurrentValue(state.dsVVA1)} dB',
          minValue: 0.0,
          maxValue: 25.0,
          currentValue: getCurrentValue(state.dsVVA1),
          onChanged: (dsVVA1) {
            context
                .read<Setting18ControlBloc>()
                .add(DSVVA1Changed(dsVVA1.toStringAsFixed(1)));
          },
          onDecreased: () =>
              context.read<Setting18ControlBloc>().add(const DSVVA1Decreased()),
          onIncreased: () =>
              context.read<Setting18ControlBloc>().add(const DSVVA1Increased()),
        );
      },
    );
  }
}

class _ForwardInputEqualizer extends StatelessWidget {
  const _ForwardInputEqualizer({
    super.key,
    required this.alcMode,
    required this.agcMode,
    required this.currentInputEqualizer,
  });

  final String alcMode;
  final String agcMode;
  final String currentInputEqualizer;

  @override
  Widget build(BuildContext context) {
    double getCurrentValue(String forwardInputEqualizer) {
      return alcMode == '0' && agcMode == '0'
          ? _getValue(forwardInputEqualizer)
          : _getValue(currentInputEqualizer);
    }

    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        return controlParameterSlider(
          context: context,
          editMode: state.editMode && alcMode == '0' && agcMode == '0',
          title:
              '${AppLocalizations.of(context)!.forwardInputEqualizer1}: ${getCurrentValue(state.dsSlope1)} dB',
          minValue: 0.0,
          maxValue: 15.0,
          currentValue: getCurrentValue(state.dsSlope1),
          onChanged: (dsSlope1) {
            context
                .read<Setting18ControlBloc>()
                .add(DSSlope1Changed(dsSlope1.toStringAsFixed(1)));
          },
          onDecreased: () => context
              .read<Setting18ControlBloc>()
              .add(const DSSlope1Decreased()),
          onIncreased: () => context
              .read<Setting18ControlBloc>()
              .add(const DSSlope1Increased()),
        );
      },
    );
  }
}

class _ForwardOutputAttenuation2And3 extends StatelessWidget {
  const _ForwardOutputAttenuation2And3({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputAttenuation2And3}: ${state.dsVVA4} dB',
          minValue: 0.0,
          maxValue: 25.0,
          currentValue: _getValue(state.dsVVA4),
          onChanged: (dsVVA4) {
            context
                .read<Setting18ControlBloc>()
                .add(DSVVA4Changed(dsVVA4.toStringAsFixed(1)));
          },
          onDecreased: () =>
              context.read<Setting18ControlBloc>().add(const DSVVA4Decreased()),
          onIncreased: () =>
              context.read<Setting18ControlBloc>().add(const DSVVA4Increased()),
        );
      },
    );
  }
}

class _ForwardOutputAttenuation3And4 extends StatelessWidget {
  const _ForwardOutputAttenuation3And4({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputAttenuation3And4}: ${state.dsVVA4} dB',
          minValue: 0.0,
          maxValue: 25.0,
          currentValue: _getValue(state.dsVVA4),
          onChanged: (dsVVA4) {
            context
                .read<Setting18ControlBloc>()
                .add(DSVVA4Changed(dsVVA4.toStringAsFixed(1)));
          },
          onDecreased: () =>
              context.read<Setting18ControlBloc>().add(const DSVVA4Decreased()),
          onIncreased: () =>
              context.read<Setting18ControlBloc>().add(const DSVVA4Increased()),
        );
      },
    );
  }
}

class _ForwardOutputAttenuation5And6 extends StatelessWidget {
  const _ForwardOutputAttenuation5And6({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputAttenuation5And6}: ${state.dsVVA5} dB',
          minValue: 0.0,
          maxValue: 15.0,
          currentValue: _getValue(state.dsVVA5),
          onChanged: (dsVVA4) {
            context
                .read<Setting18ControlBloc>()
                .add(DSVVA5Changed(dsVVA4.toStringAsFixed(1)));
          },
          onDecreased: () =>
              context.read<Setting18ControlBloc>().add(const DSVVA5Decreased()),
          onIncreased: () =>
              context.read<Setting18ControlBloc>().add(const DSVVA5Increased()),
        );
      },
    );
  }
}

class _ForwardOutputEqualizer2And3 extends StatelessWidget {
  const _ForwardOutputEqualizer2And3({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer2And3}: ${state.dsSlope3} dB',
          minValue: 0.0,
          maxValue: 15.0,
          currentValue: _getValue(state.dsSlope3),
          onChanged: (dsSlope3) {
            context
                .read<Setting18ControlBloc>()
                .add(DSSlope3Changed(dsSlope3.toStringAsFixed(1)));
          },
          onDecreased: () => context
              .read<Setting18ControlBloc>()
              .add(const DSSlope3Decreased()),
          onIncreased: () => context
              .read<Setting18ControlBloc>()
              .add(const DSSlope3Increased()),
        );
      },
    );
  }
}

class _ForwardOutputEqualizer3And4 extends StatelessWidget {
  const _ForwardOutputEqualizer3And4({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer3And4}: ${state.dsSlope3} dB',
          minValue: 0.0,
          maxValue: 15.0,
          currentValue: _getValue(state.dsSlope3),
          onChanged: (dsSlope3) {
            context
                .read<Setting18ControlBloc>()
                .add(DSSlope3Changed(dsSlope3.toStringAsFixed(1)));
          },
          onDecreased: () => context
              .read<Setting18ControlBloc>()
              .add(const DSSlope3Decreased()),
          onIncreased: () => context
              .read<Setting18ControlBloc>()
              .add(const DSSlope3Increased()),
        );
      },
    );
  }
}

class _ForwardOutputEqualizer5And6 extends StatelessWidget {
  const _ForwardOutputEqualizer5And6({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer5And6}: ${state.dsSlope4} dB',
          minValue: 0.0,
          maxValue: 15.0,
          currentValue: _getValue(state.dsSlope4),
          onChanged: (dsSlope4) {
            context
                .read<Setting18ControlBloc>()
                .add(DSSlope4Changed(dsSlope4.toStringAsFixed(1)));
          },
          onDecreased: () => context
              .read<Setting18ControlBloc>()
              .add(const DSSlope4Decreased()),
          onIncreased: () => context
              .read<Setting18ControlBloc>()
              .add(const DSSlope4Increased()),
        );
      },
    );
  }
}

class _RtnInputAttenuation2 extends StatelessWidget {
  const _RtnInputAttenuation2({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation2}: ${state.usVCA1} dB',
          minValue: 0.0,
          maxValue: 25.0,
          currentValue: _getValue(state.usVCA1),
          onChanged: (usVCA1) {
            context
                .read<Setting18ControlBloc>()
                .add(USVCA1Changed(usVCA1.toStringAsFixed(1)));
          },
          onDecreased: () =>
              context.read<Setting18ControlBloc>().add(const USVCA1Decreased()),
          onIncreased: () =>
              context.read<Setting18ControlBloc>().add(const USVCA1Increased()),
        );
      },
    );
  }
}

class _RtnInputAttenuation3 extends StatelessWidget {
  const _RtnInputAttenuation3({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation3}: ${state.usVCA3} dB',
          minValue: 0.0,
          maxValue: 25.0,
          currentValue: _getValue(state.usVCA3),
          onChanged: (rtnInputAttenuation) {
            context
                .read<Setting18ControlBloc>()
                .add(USVCA3Changed(rtnInputAttenuation.toStringAsFixed(1)));
          },
          onDecreased: () =>
              context.read<Setting18ControlBloc>().add(const USVCA3Decreased()),
          onIncreased: () =>
              context.read<Setting18ControlBloc>().add(const USVCA3Increased()),
        );
      },
    );
  }
}

class _RtnInputAttenuation2And3 extends StatelessWidget {
  const _RtnInputAttenuation2And3({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation2And3}: ${state.usVCA3} dB',
          minValue: 0.0,
          maxValue: 25.0,
          currentValue: _getValue(state.usVCA3),
          onChanged: (rtnInputAttenuation) {
            context
                .read<Setting18ControlBloc>()
                .add(USVCA3Changed(rtnInputAttenuation.toStringAsFixed(1)));
          },
          onDecreased: () =>
              context.read<Setting18ControlBloc>().add(const USVCA3Decreased()),
          onIncreased: () =>
              context.read<Setting18ControlBloc>().add(const USVCA3Increased()),
        );
      },
    );
  }
}

class _RtnInputAttenuation4 extends StatelessWidget {
  const _RtnInputAttenuation4({
    super.key,
    required this.partId,
  });

  final String partId;

  @override
  Widget build(BuildContext context) {
    if (partId == '5') {
      return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
        builder: (context, state) {
          return controlParameterSlider(
            context: context,
            editMode: state.editMode,
            title:
                '${AppLocalizations.of(context)!.returnInputAttenuation4}: ${state.usVCA1} dB',
            minValue: 0.0,
            maxValue: 25.0,
            currentValue: _getValue(state.usVCA1),
            onChanged: (usVCA1) {
              context
                  .read<Setting18ControlBloc>()
                  .add(USVCA1Changed(usVCA1.toStringAsFixed(1)));
            },
            onDecreased: () => context
                .read<Setting18ControlBloc>()
                .add(const USVCA1Decreased()),
            onIncreased: () => context
                .read<Setting18ControlBloc>()
                .add(const USVCA1Increased()),
          );
        },
      );
    } else {
      return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
        builder: (context, state) {
          return controlParameterSlider(
            context: context,
            editMode: state.editMode,
            title:
                '${AppLocalizations.of(context)!.returnInputAttenuation4}: ${state.usVCA4} dB',
            minValue: 0.0,
            maxValue: 25.0,
            currentValue: _getValue(state.usVCA4),
            onChanged: (usVCA4) {
              context
                  .read<Setting18ControlBloc>()
                  .add(USVCA4Changed(usVCA4.toStringAsFixed(1)));
            },
            onDecreased: () => context
                .read<Setting18ControlBloc>()
                .add(const USVCA4Decreased()),
            onIncreased: () => context
                .read<Setting18ControlBloc>()
                .add(const USVCA4Increased()),
          );
        },
      );
    }
  }
}

class _RtnInputAttenuation5And6 extends StatelessWidget {
  const _RtnInputAttenuation5And6({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation5And6}: ${state.usVCA4} dB',
          minValue: 0.0,
          maxValue: 25.0,
          currentValue: _getValue(state.usVCA4),
          onChanged: (rtnInputAttenuation) {
            context
                .read<Setting18ControlBloc>()
                .add(USVCA4Changed(rtnInputAttenuation.toStringAsFixed(1)));
          },
          onDecreased: () =>
              context.read<Setting18ControlBloc>().add(const USVCA4Decreased()),
          onIncreased: () =>
              context.read<Setting18ControlBloc>().add(const USVCA4Increased()),
        );
      },
    );
  }
}

class _RtnOutputLevelAttenuation extends StatelessWidget {
  const _RtnOutputLevelAttenuation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnOutputAttenuation1}: ${state.usVCA2} dB',
          minValue: 0.0,
          maxValue: 25.0,
          currentValue: _getValue(state.usVCA2),
          onChanged: (rtnInputAttenuation) {
            context
                .read<Setting18ControlBloc>()
                .add(USVCA2Changed(rtnInputAttenuation.toStringAsFixed(1)));
          },
          onDecreased: () =>
              context.read<Setting18ControlBloc>().add(const USVCA2Decreased()),
          onIncreased: () =>
              context.read<Setting18ControlBloc>().add(const USVCA2Increased()),
        );
      },
    );
  }
}

class _RtnOutputEQ extends StatelessWidget {
  const _RtnOutputEQ({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnOutputEqualizer1}: ${state.eREQ} dB',
          minValue: 0.0,
          maxValue: 15.0,
          currentValue: _getValue(state.eREQ),
          onChanged: (returnOutputEqualizer1) {
            context
                .read<Setting18ControlBloc>()
                .add(EREQChanged(returnOutputEqualizer1.toStringAsFixed(1)));
          },
          onDecreased: () =>
              context.read<Setting18ControlBloc>().add(const EREQDecreased()),
          onIncreased: () =>
              context.read<Setting18ControlBloc>().add(const EREQIncreased()),
        );
      },
    );
  }
}

const List<String> rtnIngressValues = [
  '0',
  '1',
  '2',
  '4',
];

const List<String> tgcCableLengthValues = [
  '9',
  '18',
  '27',
];

class _RtnIngressSetting2 extends StatelessWidget {
  const _RtnIngressSetting2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      buildWhen: (previous, current) =>
          previous.returnIngressSetting2 != current.returnIngressSetting2 ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return controlToggleButton(
          context: context,
          editMode: state.editMode,
          title: '${AppLocalizations.of(context)!.returnIngressSetting2}:',
          currentValue: state.returnIngressSetting2,
          onChanged: (int index) {
            context
                .read<Setting18ControlBloc>()
                .add(RtnIngressSetting2Changed(rtnIngressValues[index]));
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

class _RtnIngressSetting3 extends StatelessWidget {
  const _RtnIngressSetting3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
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
                .read<Setting18ControlBloc>()
                .add(RtnIngressSetting3Changed(rtnIngressValues[index]));
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

class _RtnIngressSetting4 extends StatelessWidget {
  const _RtnIngressSetting4({
    super.key,
    required this.partId,
  });

  final String partId;

  @override
  Widget build(BuildContext context) {
    if (partId == '5') {
      return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
        buildWhen: (previous, current) =>
            previous.returnIngressSetting2 != current.returnIngressSetting2 ||
            previous.editMode != current.editMode,
        builder: (context, state) {
          return controlToggleButton(
            context: context,
            editMode: state.editMode,
            title: '${AppLocalizations.of(context)!.returnIngressSetting4}:',
            currentValue: state.returnIngressSetting2,
            onChanged: (int index) {
              context
                  .read<Setting18ControlBloc>()
                  .add(RtnIngressSetting2Changed(rtnIngressValues[index]));
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
    } else {
      return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
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
                  .read<Setting18ControlBloc>()
                  .add(RtnIngressSetting4Changed(rtnIngressValues[index]));
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
}

class _RtnIngressSetting2And3 extends StatelessWidget {
  const _RtnIngressSetting2And3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      buildWhen: (previous, current) =>
          previous.returnIngressSetting3 != current.returnIngressSetting3 ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return controlToggleButton(
          context: context,
          editMode: state.editMode,
          title: '${AppLocalizations.of(context)!.returnIngressSetting2And3}:',
          currentValue: state.returnIngressSetting3,
          onChanged: (int index) {
            context
                .read<Setting18ControlBloc>()
                .add(RtnIngressSetting3Changed(rtnIngressValues[index]));
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

class _RtnIngressSetting5And6 extends StatelessWidget {
  const _RtnIngressSetting5And6({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      buildWhen: (previous, current) =>
          previous.returnIngressSetting4 != current.returnIngressSetting4 ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return controlToggleButton(
          context: context,
          editMode: state.editMode,
          title: '${AppLocalizations.of(context)!.returnIngressSetting5And6}:',
          currentValue: state.returnIngressSetting4,
          onChanged: (int index) {
            context
                .read<Setting18ControlBloc>()
                .add(RtnIngressSetting4Changed(rtnIngressValues[index]));
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

// class _USTGC extends StatelessWidget {
//   const _USTGC({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
//       builder: (context, state) {
//         return controlParameterSlider(
//           context: context,
//           editMode: state.editMode,
//           title: 'US TGC: ${state.usTGC} dB',
//           minValue: 0.0,
//           maxValue: 15.0,
//           currentValue: _getValue(state.usTGC),
//           onChanged: (value) {
//             context
//                 .read<Setting18ControlBloc>()
//                 .add(USTGCChanged(value.toStringAsFixed(1)));
//           },
//         );
//       },
//     );
//   }
// }

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
                        .read<Setting18ControlBloc>()
                        .add(const EditModeDisabled());

                    // 重新載入初始設定值
                    // context
                    //     .read<SettingListViewBloc>()
                    //     .add(const Initialized(true));
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
                                .read<Setting18ControlBloc>()
                                .add(const SettingSubmitted());
                          } else {
                            bool? isMatch =
                                await showConfirmInputDialog(context: context);

                            if (context.mounted) {
                              if (isMatch != null) {
                                if (isMatch) {
                                  context
                                      .read<Setting18ControlBloc>()
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
                          Navigator.push(context, Setting18GraphPage.route())
                              .then((value) => context
                                  .read<Setting18ControlBloc>()
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
                        .read<Setting18ControlBloc>()
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
      final Setting18ControlState setting18ControlState =
          context.watch<Setting18ControlBloc>().state;

      bool editable = getEditable(
        loadingStatus: homeState.loadingStatus,
      );
      return editable
          ? getEditTools(
              editMode: setting18ControlState.editMode,
              enableSubmission: setting18ControlState.enableSubmission)
          : Container();
    });
  }
}
