import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18_reverse_control/setting18_reverse_control_bloc.dart';
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
              const _ReturnOutputAttenuation1(),
              const _ReturnOutputEqualizer1(),
              const _ReturnInputAttenuation2(),
              const _ReturnInputAttenuation3(),
              _ReturnInputAttenuation4(
                partId: partId,
              ),
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
      if (factoryDefaultNumber == '12' || factoryDefaultNumber == '22') {
        return true;
      } else {
        return false;
      }
    }

    return BlocBuilder<Setting18ReverseControlBloc,
        Setting18ReverseControlState>(builder: (context, state) {
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
                                    context
                                        .read<Setting18ReverseControlBloc>()
                                        .add(
                                            const ResetReverseValuesRequested());
                                  } else {
                                    showConfirmInputDialog(context: context)
                                        .then((isMatch) {
                                      if (isMatch != null) {
                                        if (isMatch) {
                                          context
                                              .read<
                                                  Setting18ReverseControlBloc>()
                                              .add(
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

class _ReturnInputAttenuation2 extends StatelessWidget {
  const _ReturnInputAttenuation2();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ReverseControlBloc,
        Setting18ReverseControlState>(
      builder: (context, state) {
        double minValue = state.usVCA1.minValue;
        double maxValue = state.usVCA1.maxValue;
        return controlTextSlider2(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation2} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.usVCA1.value,
          onChanged: (usVCA1) {
            context.read<Setting18ReverseControlBloc>().add(USVCA1Changed(
                  usVCA1: usVCA1,
                ));
          },
          errorText: state.usVCA1.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
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
      builder: (context, state) {
        double minValue = state.usVCA3.minValue;
        double maxValue = state.usVCA3.maxValue;
        return controlTextSlider2(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.usVCA3.value,
          onChanged: (usVCA3) {
            context.read<Setting18ReverseControlBloc>().add(USVCA3Changed(
                  usVCA3: usVCA3,
                ));
          },
          errorText: state.usVCA3.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
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
      builder: (context, state) {
        double minValue = state.usVCA3.minValue;
        double maxValue = state.usVCA3.maxValue;
        return controlTextSlider2(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation2And3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.usVCA3.value,
          onChanged: (usVCA3) {
            context.read<Setting18ReverseControlBloc>().add(USVCA3Changed(
                  usVCA3: usVCA3,
                ));
          },
          errorText: state.usVCA3.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
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
        builder: (context, state) {
          double minValue = state.usVCA1.minValue;
          double maxValue = state.usVCA1.maxValue;
          return controlTextSlider2(
            context: context,
            editMode: state.editMode,
            title:
                '${AppLocalizations.of(context)!.returnInputAttenuation4} (${CustomStyle.dB}):',
            minValue: minValue,
            maxValue: maxValue,
            currentValue: state.usVCA1.value,
            onChanged: (usVCA1) {
              context.read<Setting18ReverseControlBloc>().add(USVCA1Changed(
                    usVCA1: usVCA1,
                  ));
            },
            errorText: state.usVCA1.isNotValid
                ? AppLocalizations.of(context)!.textFieldErrorMessage
                : null,
          );
        },
      );
    } else {
      return BlocBuilder<Setting18ReverseControlBloc,
          Setting18ReverseControlState>(
        builder: (context, state) {
          double minValue = state.usVCA4.minValue;
          double maxValue = state.usVCA4.maxValue;
          return controlTextSlider2(
            context: context,
            editMode: state.editMode,
            title:
                '${AppLocalizations.of(context)!.returnInputAttenuation4} (${CustomStyle.dB}):',
            minValue: minValue,
            maxValue: maxValue,
            currentValue: state.usVCA4.value,
            onChanged: (usVCA4) {
              context.read<Setting18ReverseControlBloc>().add(USVCA4Changed(
                    usVCA4: usVCA4,
                  ));
            },
            errorText: state.usVCA4.isNotValid
                ? AppLocalizations.of(context)!.textFieldErrorMessage
                : null,
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
      builder: (context, state) {
        double minValue = state.usVCA4.minValue;
        double maxValue = state.usVCA4.maxValue;
        return controlTextSlider2(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation5And6} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.usVCA4.value,
          onChanged: (usVCA4) {
            context.read<Setting18ReverseControlBloc>().add(USVCA4Changed(
                  usVCA4: usVCA4,
                ));
          },
          errorText: state.usVCA4.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
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
      builder: (context, state) {
        double minValue = state.usVCA2.minValue;
        double maxValue = state.usVCA2.maxValue;
        return controlTextSlider2(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnOutputAttenuation1} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.usVCA2.value,
          onChanged: (usVCA2) {
            context.read<Setting18ReverseControlBloc>().add(USVCA2Changed(
                  usVCA2: usVCA2,
                ));
          },
          errorText: state.usVCA2.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
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
      builder: (context, state) {
        double minValue = state.eREQ.minValue;
        double maxValue = state.eREQ.maxValue;
        return controlTextSlider2(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnOutputEqualizer1} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.eREQ.value,
          onChanged: (eREQ) {
            context.read<Setting18ReverseControlBloc>().add(EREQChanged(
                  eREQ: eREQ,
                ));
          },
          errorText: state.eREQ.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
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

class _ReturnIngressSetting2 extends StatelessWidget {
  const _ReturnIngressSetting2();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ReverseControlBloc,
        Setting18ReverseControlState>(
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
                .read<Setting18ReverseControlBloc>()
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

class _ReturnIngressSetting3 extends StatelessWidget {
  const _ReturnIngressSetting3();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ReverseControlBloc,
        Setting18ReverseControlState>(
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
                .read<Setting18ReverseControlBloc>()
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

class _ReturnIngressSetting4 extends StatelessWidget {
  const _ReturnIngressSetting4({
    required this.partId,
  });

  final String partId;

  @override
  Widget build(BuildContext context) {
    if (partId == '5') {
      return BlocBuilder<Setting18ReverseControlBloc,
          Setting18ReverseControlState>(
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
                  .read<Setting18ReverseControlBloc>()
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
      return BlocBuilder<Setting18ReverseControlBloc,
          Setting18ReverseControlState>(
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
                  .read<Setting18ReverseControlBloc>()
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

class _ReturnIngressSetting2And3 extends StatelessWidget {
  const _ReturnIngressSetting2And3();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ReverseControlBloc,
        Setting18ReverseControlState>(
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
                .read<Setting18ReverseControlBloc>()
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

class _ReturnIngressSetting5And6 extends StatelessWidget {
  const _ReturnIngressSetting5And6();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ReverseControlBloc,
        Setting18ReverseControlState>(
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
                .read<Setting18ReverseControlBloc>()
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
      return Column(
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
                    if (kDebugMode) {
                      context
                          .read<Setting18ReverseControlBloc>()
                          .add(const SettingSubmitted());
                    } else {
                      bool? isMatch =
                          await showConfirmInputDialog(context: context);

                      if (context.mounted) {
                        if (isMatch != null) {
                          if (isMatch) {
                            context
                                .read<Setting18ReverseControlBloc>()
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

    Widget getDisabledEditModeTools() {
      String graphFilePath = settingGraphFilePath[partId] ?? '';
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          graphFilePath.isNotEmpty
              ? FloatingActionButton(
                  // heroTag is used to solve exception: There are multiple heroes that share the same tag within a subtree.
                  heroTag: null,
                  shape: const CircleBorder(
                    side: BorderSide.none,
                  ),
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withAlpha(200),
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
                            .read<Setting18ReverseControlBloc>()
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
                  .read<Setting18ReverseControlBloc>()
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
