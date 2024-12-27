import 'dart:io';

import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:aci_plus_app/core/setup_wizard_dialog.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18_forward_control/setting18_forward_control_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18_tabbar/setting18_tabbar_bloc.dart';
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
        homeState.characteristicData[DataKey.currentForwardCEQIndex] ?? '';

    if (homeState.connectionStatus.isRequestFailure) {
      // 重新 Initialized, 讀取並顯示空值
      context.read<Setting18ForwardControlBloc>().add(const Initialized());
    }

    List<Widget> getForwardControlParameterWidgetsByPartId(String partId) {
      List<Enum> items = SettingItemTable.itemsMap[partId] ?? [];
      List<Widget> widgets = [];

      items =
          items.where((item) => item.runtimeType == SettingControl).toList();

      for (Enum name in items) {
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
          case SettingControl.forwardOutputAttenuation3:
            widgets.add(
              const _ForwardOutputAttenuation3(),
            );
          case SettingControl.forwardOutputEqualizer3:
            widgets.add(
              const _ForwardOutputEqualizer3(),
            );
          case SettingControl.forwardOutputAttenuation4:
            widgets.add(
              const _ForwardOutputAttenuation4(),
            );
          case SettingControl.forwardOutputEqualizer4:
            widgets.add(
              const _ForwardOutputEqualizer4(),
            );
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
          height: CustomStyle.formBottomSpacingL,
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
          List<Widget> rows = get1P8GSettingMessageRows(
            context: context,
            partId: partId,
            settingResultList: state.settingResult,
          );
          showResultDialog(
            context: context,
            messageRows: rows,
          );

          context.read<Setting18ForwardControlBloc>().add(const Initialized());

          // 重新啟動 CEQ 定時偵測
          context
              .read<Setting18TabBarBloc>()
              .add(const CurrentForwardCEQPeriodicUpdateRequested());
        } else if (state
            .resetForwardValuesSubmissionStatus.isSubmissionSuccess) {
          if (ModalRoute.of(context)?.isCurrent != true) {
            Navigator.of(context).pop();
          }
          showResetToDefaultSuccessDialog(context);
          context.read<Setting18ForwardControlBloc>().add(const Initialized());

          // 重新啟動 CEQ 定時偵測
          context
              .read<Setting18TabBarBloc>()
              .add(const CurrentForwardCEQPeriodicUpdateRequested());
        } else if (state
            .resetForwardValuesSubmissionStatus.isSubmissionFailure) {
          if (ModalRoute.of(context)?.isCurrent != true) {
            Navigator.of(context).pop();
          }
          showResetToDefaultFailureDialog(context);

          // 重新啟動 CEQ 定時偵測
          context
              .read<Setting18TabBarBloc>()
              .add(const CurrentForwardCEQPeriodicUpdateRequested());
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

class _ForwardControlHeader extends StatelessWidget {
  const _ForwardControlHeader({
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
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
                                      // 停止 CEQ 定時偵測
                                      context.read<Setting18TabBarBloc>().add(
                                          const CurrentForwardCEQPeriodicUpdateCanceled());
                                      context
                                          .read<Setting18ForwardControlBloc>()
                                          .add(
                                              const ResetForwardValuesRequested());
                                    } else {
                                      showConfirmInputDialog(context: context)
                                          .then((isMatch) {
                                        if (isMatch != null) {
                                          if (isMatch) {
                                            // 停止 CEQ 定時偵測
                                            context.read<Setting18TabBarBloc>().add(
                                                const CurrentForwardCEQPeriodicUpdateCanceled());
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
      buildWhen: (previous, current) =>
          previous.dsVVA1 != current.dsVVA1 ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        // forwardInputAttenuation1TextEditingController.text = state.dsVVA1;
        double minValue = state.dsVVA1.minValue;
        double maxValue = state.dsVVA1.maxValue;
        String inputAttenuation = getInputAttenuation(
          alcMode: alcMode,
          inputAttenuation: state.dsVVA1.value,
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
          errorText: state.dsVVA1.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.dsVVA1),
          ),
        );
      },
    );
  }
}

class _ForwardInputEqualizer1 extends StatelessWidget {
  const _ForwardInputEqualizer1({
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
      buildWhen: (previous, current) =>
          previous.dsSlope1 != current.dsSlope1 ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        double minValue = state.dsSlope1.minValue;
        double maxValue = state.dsSlope1.maxValue;
        String inputEqualizer = getInputEqualizer(
          alcMode: alcMode,
          agcMode: agcMode,
          inputEqualizer: state.dsSlope1.value,
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
          errorText: state.dsSlope1.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.dsSlope1),
          ),
        );
      },
    );
  }
}

class _ForwardOutputEqualizer3 extends StatelessWidget {
  const _ForwardOutputEqualizer3();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ForwardControlBloc,
        Setting18ForwardControlState>(
      buildWhen: (previous, current) =>
          previous.dsSlope3 != current.dsSlope3 ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        double minValue = state.dsSlope3.minValue;
        double maxValue = state.dsSlope3.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsSlope3.value,
          onChanged: (dsSlope3) {
            context.read<Setting18ForwardControlBloc>().add(DSSlope3Changed(
                  dsSlope3: dsSlope3,
                ));
          },
          errorText: state.dsSlope3.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.dsSlope3),
          ),
        );
      },
    );
  }
}

class _ForwardOutputEqualizer4 extends StatelessWidget {
  const _ForwardOutputEqualizer4();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ForwardControlBloc,
        Setting18ForwardControlState>(
      buildWhen: (previous, current) =>
          previous.dsSlope4 != current.dsSlope4 ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        double minValue = state.dsSlope4.minValue;
        double maxValue = state.dsSlope4.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer4} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsSlope4.value,
          onChanged: (dsSlope4) {
            context.read<Setting18ForwardControlBloc>().add(DSSlope4Changed(
                  dsSlope4: dsSlope4,
                ));
          },
          errorText: state.dsSlope4.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.dsSlope4),
          ),
        );
      },
    );
  }
}

class _ForwardOutputAttenuation3 extends StatelessWidget {
  const _ForwardOutputAttenuation3();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ForwardControlBloc,
        Setting18ForwardControlState>(
      buildWhen: (previous, current) =>
          previous.dsVVA4 != current.dsVVA4 ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        double minValue = state.dsVVA4.minValue;
        double maxValue = state.dsVVA4.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputAttenuation3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsVVA4.value,
          onChanged: (dsVVA4) {
            context.read<Setting18ForwardControlBloc>().add(DSVVA4Changed(
                  dsVVA4: dsVVA4,
                ));
          },
          errorText: state.dsVVA4.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.dsVVA4),
          ),
        );
      },
    );
  }
}

class _ForwardOutputAttenuation4 extends StatelessWidget {
  const _ForwardOutputAttenuation4();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ForwardControlBloc,
        Setting18ForwardControlState>(
      buildWhen: (previous, current) =>
          previous.dsVVA5 != current.dsVVA5 ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        double minValue = state.dsVVA5.minValue;
        double maxValue = state.dsVVA5.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputAttenuation4} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsVVA5.value,
          onChanged: (dsVVA5) {
            context.read<Setting18ForwardControlBloc>().add(DSVVA5Changed(
                  dsVVA5: dsVVA5,
                ));
          },
          errorText: state.dsVVA5.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.dsVVA5),
          ),
        );
      },
    );
  }
}

class _ForwardOutputAttenuation2And3 extends StatelessWidget {
  const _ForwardOutputAttenuation2And3();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ForwardControlBloc,
        Setting18ForwardControlState>(
      buildWhen: (previous, current) =>
          previous.dsVVA4 != current.dsVVA4 ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        double minValue = state.dsVVA4.minValue;
        double maxValue = state.dsVVA4.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputAttenuation2And3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsVVA4.value,
          onChanged: (dsVVA4) {
            context.read<Setting18ForwardControlBloc>().add(DSVVA4Changed(
                  dsVVA4: dsVVA4,
                ));
          },
          errorText: state.dsVVA4.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.dsVVA4),
          ),
        );
      },
    );
  }
}

class _ForwardOutputAttenuation3And4 extends StatelessWidget {
  const _ForwardOutputAttenuation3And4();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ForwardControlBloc,
        Setting18ForwardControlState>(
      buildWhen: (previous, current) =>
          previous.dsVVA4 != current.dsVVA4 ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        double minValue = state.dsVVA4.minValue;
        double maxValue = state.dsVVA4.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputAttenuation3And4} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsVVA4.value,
          onChanged: (dsVVA4) {
            context.read<Setting18ForwardControlBloc>().add(DSVVA4Changed(
                  dsVVA4: dsVVA4,
                ));
          },
          errorText: state.dsVVA4.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.dsVVA4),
          ),
        );
      },
    );
  }
}

class _ForwardOutputAttenuation5And6 extends StatelessWidget {
  const _ForwardOutputAttenuation5And6();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ForwardControlBloc,
        Setting18ForwardControlState>(
      buildWhen: (previous, current) =>
          previous.dsVVA5 != current.dsVVA5 ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        double minValue = state.dsVVA5.minValue;
        double maxValue = state.dsVVA5.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputAttenuation5And6} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsVVA5.value,
          onChanged: (dsVVA5) {
            context.read<Setting18ForwardControlBloc>().add(DSVVA5Changed(
                  dsVVA5: dsVVA5,
                ));
          },
          errorText: state.dsVVA5.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.dsVVA5),
          ),
        );
      },
    );
  }
}

class _ForwardOutputEqualizer2And3 extends StatelessWidget {
  const _ForwardOutputEqualizer2And3();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ForwardControlBloc,
        Setting18ForwardControlState>(
      buildWhen: (previous, current) =>
          previous.dsSlope3 != current.dsSlope3 ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        double minValue = state.dsSlope3.minValue;
        double maxValue = state.dsSlope3.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer2And3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsSlope3.value,
          onChanged: (dsSlope3) {
            context.read<Setting18ForwardControlBloc>().add(DSSlope3Changed(
                  dsSlope3: dsSlope3,
                ));
          },
          errorText: state.dsSlope3.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.dsSlope3),
          ),
        );
      },
    );
  }
}

class _ForwardOutputEqualizer3And4 extends StatelessWidget {
  const _ForwardOutputEqualizer3And4();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ForwardControlBloc,
        Setting18ForwardControlState>(
      buildWhen: (previous, current) =>
          previous.dsSlope3 != current.dsSlope3 ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        double minValue = state.dsSlope3.minValue;
        double maxValue = state.dsSlope3.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer3And4} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsSlope3.value,
          onChanged: (dsSlope3) {
            context.read<Setting18ForwardControlBloc>().add(DSSlope3Changed(
                  dsSlope3: dsSlope3,
                ));
          },
          errorText: state.dsSlope3.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.dsSlope3),
          ),
        );
      },
    );
  }
}

class _ForwardOutputEqualizer5And6 extends StatelessWidget {
  const _ForwardOutputEqualizer5And6();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ForwardControlBloc,
        Setting18ForwardControlState>(
      buildWhen: (previous, current) =>
          previous.dsSlope4 != current.dsSlope4 ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        double minValue = state.dsSlope4.minValue;
        double maxValue = state.dsSlope4.maxValue;
        return controlTextSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer5And6} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsSlope4.value,
          onChanged: (dsSlope4) {
            context.read<Setting18ForwardControlBloc>().add(DSSlope4Changed(
                  dsSlope4: dsSlope4,
                ));
          },
          errorText: state.dsSlope4.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          color: getSettingListCardColor(
            context: context,
            isTap: state.tappedSet.contains(DataKey.dsSlope4),
          ),
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
                  .read<Setting18ForwardControlBloc>()
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
                      // 停止 CEQ 定時偵測
                      context
                          .read<Setting18TabBarBloc>()
                          .add(const CurrentForwardCEQPeriodicUpdateCanceled());
                      context
                          .read<Setting18ForwardControlBloc>()
                          .add(const SettingSubmitted());
                    } else {
                      bool? isMatch =
                          await showConfirmInputDialog(context: context);

                      if (context.mounted) {
                        if (isMatch != null) {
                          if (isMatch) {
                            // 停止 CEQ 定時偵測
                            context.read<Setting18TabBarBloc>().add(
                                const CurrentForwardCEQPeriodicUpdateCanceled());
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
      );
    }

    Widget getDisabledEditModeTools() {
      String graphFilePath = settingGraphFilePath[partId] ?? '';
      return Column(
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
                  backgroundColor: Platform.isWindows
                      ? winBeta >= 7
                          ? Theme.of(context).colorScheme.primary.withAlpha(200)
                          : Colors.grey.withAlpha(200)
                      : Theme.of(context).colorScheme.primary.withAlpha(200),
                  onPressed: Platform.isWindows
                      ? winBeta >= 7
                          ? () {
                              // 停止 CEQ 定時偵測
                              context.read<Setting18TabBarBloc>().add(
                                  const CurrentForwardCEQPeriodicUpdateCanceled());

                              // 當 Setting18GraphPage 被 pop 後, 不管有沒有設定參數都重新初始化
                              Navigator.push(
                                  context,
                                  Setting18GraphPage.route(
                                    graphFilePath: graphFilePath,
                                  )).then((value) {
                                context
                                    .read<Setting18ForwardControlBloc>()
                                    .add(const Initialized());

                                // 重新啟動 CEQ 定時偵測
                                context.read<Setting18TabBarBloc>().add(
                                    const CurrentForwardCEQPeriodicUpdateRequested());
                              });
                            }
                          : null
                      : () {
                          // 停止 CEQ 定時偵測
                          context.read<Setting18TabBarBloc>().add(
                              const CurrentForwardCEQPeriodicUpdateCanceled());

                          // 當 Setting18GraphPage 被 pop 後, 不管有沒有設定參數都重新初始化
                          Navigator.push(
                              context,
                              Setting18GraphPage.route(
                                graphFilePath: graphFilePath,
                              )).then((value) {
                            context
                                .read<Setting18ForwardControlBloc>()
                                .add(const Initialized());

                            // 重新啟動 CEQ 定時偵測
                            context.read<Setting18TabBarBloc>().add(
                                const CurrentForwardCEQPeriodicUpdateRequested());
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
                  .read<Setting18ForwardControlBloc>()
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
      final Setting18ForwardControlState setting18ForwardControlState =
          context.watch<Setting18ForwardControlBloc>().state;

      bool editable = getEditable(
        loadingStatus: homeState.loadingStatus,
      );
      return editable
          ? getFloatingActionButtons(
              editMode: setting18ForwardControlState.editMode,
              enableSubmission: setting18ForwardControlState.enableSubmission,
            )
          : getDisabledFloatingActionButtons();
    });
  }
}
