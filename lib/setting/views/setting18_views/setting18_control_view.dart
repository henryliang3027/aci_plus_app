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
  Setting18ControlView({super.key});

  final TextEditingController forwardInputAttenuation1TextEditingController =
      TextEditingController();
  final TextEditingController forwardInputEqualizer1TextEditingController =
      TextEditingController();
  final TextEditingController
      forwardOutputAttenuation3And4TextEditingController =
      TextEditingController();
  final TextEditingController
      forwardOutputAttenuation2And3TextEditingController =
      TextEditingController();
  final TextEditingController
      forwardOutputAttenuation5And6TextEditingController =
      TextEditingController();
  final TextEditingController forwardOutputEqualizer3And4TextEditingController =
      TextEditingController();
  final TextEditingController forwardOutputEqualizer2And3TextEditingController =
      TextEditingController();
  final TextEditingController forwardOutputEqualizer5And6TextEditingController =
      TextEditingController();

  final TextEditingController returnInputAttenuation2TextEditingController =
      TextEditingController();
  final TextEditingController returnInputAttenuation3TextEditingController =
      TextEditingController();
  final TextEditingController returnInputAttenuation4TextEditingController =
      TextEditingController();
  final TextEditingController returnInputAttenuation2And3TextEditingController =
      TextEditingController();
  final TextEditingController returnInputAttenuation5And6TextEditingController =
      TextEditingController();
  final TextEditingController returnOutputAttenuation1TextEditingController =
      TextEditingController();
  final TextEditingController returnOutputEqualizer1TextEditingController =
      TextEditingController();

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
      } else {
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
                forwardInputAttenuation1TextEditingController:
                    forwardInputAttenuation1TextEditingController,
              ),
            );
            break;
          case SettingControl.forwardInputEqualizer1:
            widgets.add(
              _ForwardInputEqualizer(
                alcMode: alcMode,
                agcMode: agcMode,
                currentInputEqualizer: currentInputEqualizer,
                forwardInputEqualizer1TextEditingController:
                    forwardInputEqualizer1TextEditingController,
              ),
            );
            break;
          case SettingControl.forwardOutputAttenuation3And4:
            widgets.add(
              _ForwardOutputAttenuation3And4(
                forwardOutputAttenuation3And4TextEditingController:
                    forwardOutputAttenuation3And4TextEditingController,
              ),
            );
            break;
          case SettingControl.forwardOutputEqualizer3And4:
            widgets.add(
              _ForwardOutputEqualizer3And4(
                forwardOutputEqualizer3And4TextEditingController:
                    forwardOutputEqualizer3And4TextEditingController,
              ),
            );
            break;
          case SettingControl.forwardOutputAttenuation2And3:
            widgets.add(
              _ForwardOutputAttenuation2And3(
                forwardOutputAttenuation2And3TextEditingController:
                    forwardOutputAttenuation2And3TextEditingController,
              ),
            );
            break;
          case SettingControl.forwardOutputAttenuation5And6:
            widgets.add(
              _ForwardOutputAttenuation5And6(
                forwardOutputAttenuation5And6TextEditingController:
                    forwardOutputAttenuation5And6TextEditingController,
              ),
            );
            break;
          case SettingControl.forwardOutputEqualizer2And3:
            widgets.add(
              _ForwardOutputEqualizer2And3(
                forwardOutputEqualizer2And3TextEditingController:
                    forwardOutputEqualizer2And3TextEditingController,
              ),
            );
            break;
          case SettingControl.forwardOutputEqualizer5And6:
            widgets.add(
              _ForwardOutputEqualizer5And6(
                forwardOutputEqualizer5And6TextEditingController:
                    forwardOutputEqualizer5And6TextEditingController,
              ),
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
                forwardInputAttenuation1TextEditingController:
                    forwardInputAttenuation1TextEditingController,
              ),
              _ForwardInputEqualizer(
                alcMode: alcMode,
                agcMode: agcMode,
                currentInputEqualizer: currentInputEqualizer,
                forwardInputEqualizer1TextEditingController:
                    forwardInputEqualizer1TextEditingController,
              ),
              _ForwardOutputAttenuation3And4(
                forwardOutputAttenuation3And4TextEditingController:
                    forwardOutputAttenuation3And4TextEditingController,
              ),
              _ForwardOutputEqualizer3And4(
                forwardOutputEqualizer3And4TextEditingController:
                    forwardOutputEqualizer3And4TextEditingController,
              ),
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
              _RtnInputAttenuation2(
                returnInputAttenuation2TextEditingController:
                    returnInputAttenuation2TextEditingController,
              ),
            );
            break;
          case SettingControl.returnInputAttenuation3:
            widgets.add(
              _RtnInputAttenuation3(
                returnInputAttenuation3TextEditingController:
                    returnInputAttenuation3TextEditingController,
              ),
            );
            break;
          case SettingControl.returnInputAttenuation4:
            widgets.add(
              _RtnInputAttenuation4(
                partId: partId,
                returnInputAttenuation4TextEditingController:
                    returnInputAttenuation4TextEditingController,
              ),
            );
            break;
          case SettingControl.returnInputAttenuation5:
            break;
          case SettingControl.returnInputAttenuation6:
            break;
          case SettingControl.returnInputAttenuation2And3:
            widgets.add(
              _RtnInputAttenuation2And3(
                returnInputAttenuation2And3TextEditingController:
                    returnInputAttenuation2And3TextEditingController,
              ),
            );
            break;
          case SettingControl.returnInputAttenuation5And6:
            widgets.add(
              _RtnInputAttenuation5And6(
                returnInputAttenuation5And6TextEditingController:
                    returnInputAttenuation5And6TextEditingController,
              ),
            );
            break;
          case SettingControl.returnOutputAttenuation1:
            widgets.add(
              _RtnOutputLevelAttenuation(
                returnOutputAttenuation1TextEditingController:
                    returnOutputAttenuation1TextEditingController,
              ),
            );
            break;
          case SettingControl.returnOutputEqualizer1:
            widgets.add(
              _RtnOutputEQ(
                returnOutputEqualizer1TextEditingController:
                    returnOutputEqualizer1TextEditingController,
              ),
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
              _RtnInputAttenuation2(
                returnInputAttenuation2TextEditingController:
                    returnInputAttenuation2TextEditingController,
              ),
              _RtnInputAttenuation3(
                returnInputAttenuation3TextEditingController:
                    returnInputAttenuation3TextEditingController,
              ),
              _RtnInputAttenuation4(
                partId: partId,
                returnInputAttenuation4TextEditingController:
                    returnInputAttenuation4TextEditingController,
              ),
              _RtnOutputLevelAttenuation(
                returnOutputAttenuation1TextEditingController:
                    returnOutputAttenuation1TextEditingController,
              ),
              _RtnOutputEQ(
                returnOutputEqualizer1TextEditingController:
                    returnOutputEqualizer1TextEditingController,
              ),
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

        if (state.isInitialize) {
          forwardInputAttenuation1TextEditingController.text =
              getInputAttenuation(
            alcMode: alcMode,
            inputAttenuation: state.dsVVA1,
            currentInputAttenuation: currentInputAttenuation,
          );
          forwardInputEqualizer1TextEditingController.text = getInputEqualizer(
            alcMode: alcMode,
            agcMode: agcMode,
            inputEqualizer: state.dsSlope1,
            currentInputEqualizer: currentInputEqualizer,
          );
          forwardOutputAttenuation3And4TextEditingController.text =
              state.dsVVA4;
          forwardOutputAttenuation2And3TextEditingController.text =
              state.dsVVA4;
          forwardOutputAttenuation5And6TextEditingController.text =
              state.dsVVA5;
          forwardOutputEqualizer3And4TextEditingController.text =
              state.dsSlope3;
          forwardOutputEqualizer2And3TextEditingController.text =
              state.dsSlope3;
          forwardOutputEqualizer5And6TextEditingController.text =
              state.dsSlope4;

          returnInputAttenuation2TextEditingController.text = state.usVCA1;
          returnInputAttenuation3TextEditingController.text = state.usVCA3;
          returnInputAttenuation4TextEditingController.text = state.usVCA4;
          returnInputAttenuation2And3TextEditingController.text = state.usVCA3;
          returnInputAttenuation5And6TextEditingController.text = state.usVCA4;
          returnOutputAttenuation1TextEditingController.text = state.usVCA2;
          returnOutputEqualizer1TextEditingController.text = state.eREQ;
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

String getInputAttenuation({
  required String alcMode,
  required String inputAttenuation,
  required String currentInputAttenuation,
}) {
  return alcMode == '0' ? inputAttenuation : currentInputAttenuation;
}

String getInputEqualizer({
  required String alcMode,
  required String agcMode,
  required String inputEqualizer,
  required String currentInputEqualizer,
}) {
  return alcMode == '0' && agcMode == '0'
      ? inputEqualizer
      : currentInputEqualizer;
}

class _ForwardInputAttenuation extends StatelessWidget {
  const _ForwardInputAttenuation({
    super.key,
    required this.alcMode,
    required this.currentInputAttenuation,
    required this.forwardInputAttenuation1TextEditingController,
  });

  final String alcMode;
  final String currentInputAttenuation;
  final TextEditingController forwardInputAttenuation1TextEditingController;

  @override
  Widget build(BuildContext context) {
    // String getCurrentValue(String fwdInputAttenuation) {
    //   return alcMode == '0' ? fwdInputAttenuation : currentInputAttenuation;
    // }

    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        // forwardInputAttenuation1TextEditingController.text = state.dsVVA1;
        double minValue = 0.0;
        double maxValue = 25.0;
        String inputAttenuation = getInputAttenuation(
          alcMode: alcMode,
          inputAttenuation: state.dsVVA1,
          currentInputAttenuation: currentInputAttenuation,
        );
        return controlParameterSlider(
          context: context,
          editMode: state.editMode && alcMode == '0',
          title:
              '${AppLocalizations.of(context)!.forwardInputAttenuation1}: $inputAttenuation dB',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: inputAttenuation,
          onChanged: (dsVVA1) {
            context.read<Setting18ControlBloc>().add(DSVVA1Changed(
                  dsVVA1: dsVVA1.toStringAsFixed(1),
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      forwardInputAttenuation1TextEditingController,
                  isFromTextField: false,
                ));
          },
          textEditingController: forwardInputAttenuation1TextEditingController,
          onTextChanged: (dsVVA1) {
            context.read<Setting18ControlBloc>().add(DSVVA1Changed(
                  dsVVA1: dsVVA1,
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      forwardInputAttenuation1TextEditingController,
                  isFromTextField: true,
                ));
          },
          onDecreased: () =>
              context.read<Setting18ControlBloc>().add(DSVVA1Decreased(
                    minValue: minValue,
                    textEditingController:
                        forwardInputAttenuation1TextEditingController,
                  )),
          onIncreased: () =>
              context.read<Setting18ControlBloc>().add(DSVVA1Increased(
                    maxValue: maxValue,
                    textEditingController:
                        forwardInputAttenuation1TextEditingController,
                  )),
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
    required this.forwardInputEqualizer1TextEditingController,
  });

  final String alcMode;
  final String agcMode;
  final String currentInputEqualizer;
  final TextEditingController forwardInputEqualizer1TextEditingController;

  @override
  Widget build(BuildContext context) {
    // String getCurrentValue(String forwardInputEqualizer) {
    //   return alcMode == '0' && agcMode == '0'
    //       ? forwardInputEqualizer
    //       : currentInputEqualizer;
    // }

    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 27.0;
        String inputEqualizer = getInputEqualizer(
          alcMode: alcMode,
          agcMode: agcMode,
          inputEqualizer: state.dsSlope1,
          currentInputEqualizer: currentInputEqualizer,
        );
        return controlParameterSlider(
          context: context,
          editMode: state.editMode && alcMode == '0' && agcMode == '0',
          title:
              '${AppLocalizations.of(context)!.forwardInputEqualizer1}: $inputEqualizer dB',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: inputEqualizer,
          onChanged: (dsSlope1) {
            context.read<Setting18ControlBloc>().add(DSSlope1Changed(
                  dsSlope1: dsSlope1.toStringAsFixed(1),
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      forwardInputEqualizer1TextEditingController,
                  isFromTextField: false,
                ));
          },
          textEditingController: forwardInputEqualizer1TextEditingController,
          onTextChanged: (dsSlope1) {
            context.read<Setting18ControlBloc>().add(DSSlope1Changed(
                  dsSlope1: dsSlope1,
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      forwardInputEqualizer1TextEditingController,
                  isFromTextField: true,
                ));
          },
          onDecreased: () =>
              context.read<Setting18ControlBloc>().add(DSSlope1Decreased(
                    minValue: minValue,
                    textEditingController:
                        forwardInputEqualizer1TextEditingController,
                  )),
          onIncreased: () =>
              context.read<Setting18ControlBloc>().add(DSSlope1Increased(
                    maxValue: maxValue,
                    textEditingController:
                        forwardInputEqualizer1TextEditingController,
                  )),
        );
      },
    );
  }
}

class _ForwardOutputAttenuation2And3 extends StatelessWidget {
  const _ForwardOutputAttenuation2And3({
    super.key,
    required this.forwardOutputAttenuation2And3TextEditingController,
  });

  final TextEditingController
      forwardOutputAttenuation2And3TextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 25.0;
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputAttenuation2And3}: ${state.dsVVA4} dB',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsVVA4,
          onChanged: (dsVVA4) {
            context.read<Setting18ControlBloc>().add(DSVVA4Changed(
                  dsVVA4: dsVVA4.toStringAsFixed(1),
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      forwardOutputAttenuation2And3TextEditingController,
                  isFromTextField: false,
                ));
          },
          textEditingController:
              forwardOutputAttenuation2And3TextEditingController,
          onTextChanged: (dsVVA4) {
            context.read<Setting18ControlBloc>().add(DSVVA4Changed(
                  dsVVA4: dsVVA4,
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      forwardOutputAttenuation2And3TextEditingController,
                  isFromTextField: true,
                ));
          },
          onDecreased: () =>
              context.read<Setting18ControlBloc>().add(DSVVA4Decreased(
                    minValue: minValue,
                    textEditingController:
                        forwardOutputAttenuation2And3TextEditingController,
                  )),
          onIncreased: () =>
              context.read<Setting18ControlBloc>().add(DSVVA4Increased(
                    maxValue: maxValue,
                    textEditingController:
                        forwardOutputAttenuation2And3TextEditingController,
                  )),
        );
      },
    );
  }
}

class _ForwardOutputAttenuation3And4 extends StatelessWidget {
  const _ForwardOutputAttenuation3And4({
    super.key,
    required this.forwardOutputAttenuation3And4TextEditingController,
  });

  final TextEditingController
      forwardOutputAttenuation3And4TextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 25.0;
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputAttenuation3And4}: ${state.dsVVA4} dB',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsVVA4,
          onChanged: (dsVVA4) {
            context.read<Setting18ControlBloc>().add(DSVVA4Changed(
                  dsVVA4: dsVVA4.toStringAsFixed(1),
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      forwardOutputAttenuation3And4TextEditingController,
                  isFromTextField: false,
                ));
          },
          textEditingController:
              forwardOutputAttenuation3And4TextEditingController,
          onTextChanged: (dsVVA4) {
            context.read<Setting18ControlBloc>().add(DSVVA4Changed(
                  dsVVA4: dsVVA4,
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      forwardOutputAttenuation3And4TextEditingController,
                  isFromTextField: true,
                ));
          },
          onDecreased: () =>
              context.read<Setting18ControlBloc>().add(DSVVA4Decreased(
                    minValue: minValue,
                    textEditingController:
                        forwardOutputAttenuation3And4TextEditingController,
                  )),
          onIncreased: () =>
              context.read<Setting18ControlBloc>().add(DSVVA4Increased(
                    maxValue: maxValue,
                    textEditingController:
                        forwardOutputAttenuation3And4TextEditingController,
                  )),
        );
      },
    );
  }
}

class _ForwardOutputAttenuation5And6 extends StatelessWidget {
  const _ForwardOutputAttenuation5And6({
    super.key,
    required this.forwardOutputAttenuation5And6TextEditingController,
  });

  final TextEditingController
      forwardOutputAttenuation5And6TextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 25.0;
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputAttenuation5And6}: ${state.dsVVA5} dB',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsVVA5,
          onChanged: (dsVVA5) {
            context.read<Setting18ControlBloc>().add(DSVVA5Changed(
                  dsVVA5: dsVVA5.toStringAsFixed(1),
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      forwardOutputAttenuation5And6TextEditingController,
                  isFromTextField: false,
                ));
          },
          textEditingController:
              forwardOutputAttenuation5And6TextEditingController,
          onTextChanged: (dsVVA5) {
            context.read<Setting18ControlBloc>().add(DSVVA5Changed(
                  dsVVA5: dsVVA5,
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      forwardOutputAttenuation5And6TextEditingController,
                  isFromTextField: true,
                ));
          },
          onDecreased: () =>
              context.read<Setting18ControlBloc>().add(DSVVA5Decreased(
                    minValue: minValue,
                    textEditingController:
                        forwardOutputAttenuation5And6TextEditingController,
                  )),
          onIncreased: () =>
              context.read<Setting18ControlBloc>().add(DSVVA5Increased(
                    maxValue: maxValue,
                    textEditingController:
                        forwardOutputAttenuation5And6TextEditingController,
                  )),
        );
      },
    );
  }
}

class _ForwardOutputEqualizer2And3 extends StatelessWidget {
  const _ForwardOutputEqualizer2And3({
    super.key,
    required this.forwardOutputEqualizer2And3TextEditingController,
  });

  final TextEditingController forwardOutputEqualizer2And3TextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 15.0;
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer2And3}: ${state.dsSlope3} dB',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsSlope3,
          onChanged: (dsSlope3) {
            context.read<Setting18ControlBloc>().add(DSSlope3Changed(
                  dsSlope3: dsSlope3.toStringAsFixed(1),
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      forwardOutputEqualizer2And3TextEditingController,
                  isFromTextField: false,
                ));
          },
          textEditingController:
              forwardOutputEqualizer2And3TextEditingController,
          onTextChanged: (dsSlope3) {
            context.read<Setting18ControlBloc>().add(DSSlope3Changed(
                  dsSlope3: dsSlope3,
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      forwardOutputEqualizer2And3TextEditingController,
                  isFromTextField: true,
                ));
          },
          onDecreased: () =>
              context.read<Setting18ControlBloc>().add(DSSlope3Decreased(
                    minValue: minValue,
                    textEditingController:
                        forwardOutputEqualizer2And3TextEditingController,
                  )),
          onIncreased: () =>
              context.read<Setting18ControlBloc>().add(DSSlope3Increased(
                    maxValue: maxValue,
                    textEditingController:
                        forwardOutputEqualizer2And3TextEditingController,
                  )),
        );
      },
    );
  }
}

class _ForwardOutputEqualizer3And4 extends StatelessWidget {
  const _ForwardOutputEqualizer3And4({
    super.key,
    required this.forwardOutputEqualizer3And4TextEditingController,
  });

  final TextEditingController forwardOutputEqualizer3And4TextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 15.0;
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer3And4}: ${state.dsSlope3} dB',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsSlope3,
          onChanged: (dsSlope3) {
            context.read<Setting18ControlBloc>().add(DSSlope3Changed(
                  dsSlope3: dsSlope3.toStringAsFixed(1),
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      forwardOutputEqualizer3And4TextEditingController,
                  isFromTextField: false,
                ));
          },
          textEditingController:
              forwardOutputEqualizer3And4TextEditingController,
          onTextChanged: (dsSlope3) {
            context.read<Setting18ControlBloc>().add(DSSlope3Changed(
                  dsSlope3: dsSlope3,
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      forwardOutputEqualizer3And4TextEditingController,
                  isFromTextField: true,
                ));
          },
          onDecreased: () =>
              context.read<Setting18ControlBloc>().add(DSSlope3Decreased(
                    minValue: minValue,
                    textEditingController:
                        forwardOutputEqualizer3And4TextEditingController,
                  )),
          onIncreased: () =>
              context.read<Setting18ControlBloc>().add(DSSlope3Increased(
                    maxValue: maxValue,
                    textEditingController:
                        forwardOutputEqualizer3And4TextEditingController,
                  )),
        );
      },
    );
  }
}

class _ForwardOutputEqualizer5And6 extends StatelessWidget {
  const _ForwardOutputEqualizer5And6({
    super.key,
    required this.forwardOutputEqualizer5And6TextEditingController,
  });

  final TextEditingController forwardOutputEqualizer5And6TextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 15.0;
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardOutputEqualizer5And6}: ${state.dsSlope4} dB',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsSlope4,
          onChanged: (dsSlope4) {
            context.read<Setting18ControlBloc>().add(DSSlope4Changed(
                  dsSlope4: dsSlope4.toStringAsFixed(1),
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      forwardOutputEqualizer5And6TextEditingController,
                  isFromTextField: false,
                ));
          },
          textEditingController:
              forwardOutputEqualizer5And6TextEditingController,
          onTextChanged: (dsSlope4) {
            context.read<Setting18ControlBloc>().add(DSSlope4Changed(
                  dsSlope4: dsSlope4,
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      forwardOutputEqualizer5And6TextEditingController,
                  isFromTextField: true,
                ));
          },
          onDecreased: () =>
              context.read<Setting18ControlBloc>().add(DSSlope4Decreased(
                    minValue: minValue,
                    textEditingController:
                        forwardOutputEqualizer5And6TextEditingController,
                  )),
          onIncreased: () =>
              context.read<Setting18ControlBloc>().add(DSSlope4Increased(
                    maxValue: maxValue,
                    textEditingController:
                        forwardOutputEqualizer5And6TextEditingController,
                  )),
        );
      },
    );
  }
}

class _RtnInputAttenuation2 extends StatelessWidget {
  const _RtnInputAttenuation2({
    super.key,
    required this.returnInputAttenuation2TextEditingController,
  });

  final TextEditingController returnInputAttenuation2TextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 25.0;
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation2}: ${state.usVCA1} dB',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.usVCA1,
          onChanged: (usVCA1) {
            context.read<Setting18ControlBloc>().add(USVCA1Changed(
                  usVCA1: usVCA1.toStringAsFixed(1),
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      returnInputAttenuation2TextEditingController,
                  isFromTextField: false,
                ));
          },
          textEditingController: returnInputAttenuation2TextEditingController,
          onTextChanged: (usVCA1) {
            context.read<Setting18ControlBloc>().add(USVCA1Changed(
                  usVCA1: usVCA1,
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      returnInputAttenuation2TextEditingController,
                  isFromTextField: true,
                ));
          },
          onDecreased: () =>
              context.read<Setting18ControlBloc>().add(USVCA1Decreased(
                    minValue: minValue,
                    textEditingController:
                        returnInputAttenuation2TextEditingController,
                  )),
          onIncreased: () =>
              context.read<Setting18ControlBloc>().add(USVCA1Increased(
                    maxValue: maxValue,
                    textEditingController:
                        returnInputAttenuation2TextEditingController,
                  )),
        );
      },
    );
  }
}

class _RtnInputAttenuation3 extends StatelessWidget {
  const _RtnInputAttenuation3({
    super.key,
    required this.returnInputAttenuation3TextEditingController,
  });

  final TextEditingController returnInputAttenuation3TextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 25.0;
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation3}: ${state.usVCA3} dB',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.usVCA3,
          onChanged: (usVCA3) {
            context.read<Setting18ControlBloc>().add(USVCA3Changed(
                  usVCA3: usVCA3.toStringAsFixed(1),
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      returnInputAttenuation3TextEditingController,
                  isFromTextField: false,
                ));
          },
          textEditingController: returnInputAttenuation3TextEditingController,
          onTextChanged: (usVCA3) {
            context.read<Setting18ControlBloc>().add(USVCA3Changed(
                  usVCA3: usVCA3,
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      returnInputAttenuation3TextEditingController,
                  isFromTextField: true,
                ));
          },
          onDecreased: () =>
              context.read<Setting18ControlBloc>().add(USVCA3Decreased(
                    minValue: minValue,
                    textEditingController:
                        returnInputAttenuation3TextEditingController,
                  )),
          onIncreased: () =>
              context.read<Setting18ControlBloc>().add(USVCA3Increased(
                    maxValue: maxValue,
                    textEditingController:
                        returnInputAttenuation3TextEditingController,
                  )),
        );
      },
    );
  }
}

class _RtnInputAttenuation2And3 extends StatelessWidget {
  const _RtnInputAttenuation2And3({
    super.key,
    required this.returnInputAttenuation2And3TextEditingController,
  });

  final TextEditingController returnInputAttenuation2And3TextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 25.0;
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation2And3}: ${state.usVCA3} dB',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.usVCA3,
          onChanged: (usVCA3) {
            context.read<Setting18ControlBloc>().add(USVCA3Changed(
                  usVCA3: usVCA3.toStringAsFixed(1),
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      returnInputAttenuation2And3TextEditingController,
                  isFromTextField: false,
                ));
          },
          textEditingController:
              returnInputAttenuation2And3TextEditingController,
          onTextChanged: (usVCA3) {
            context.read<Setting18ControlBloc>().add(USVCA3Changed(
                  usVCA3: usVCA3,
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      returnInputAttenuation2And3TextEditingController,
                  isFromTextField: true,
                ));
          },
          onDecreased: () =>
              context.read<Setting18ControlBloc>().add(USVCA3Decreased(
                    minValue: minValue,
                    textEditingController:
                        returnInputAttenuation2And3TextEditingController,
                  )),
          onIncreased: () =>
              context.read<Setting18ControlBloc>().add(USVCA3Increased(
                    maxValue: maxValue,
                    textEditingController:
                        returnInputAttenuation2And3TextEditingController,
                  )),
        );
      },
    );
  }
}

class _RtnInputAttenuation4 extends StatelessWidget {
  const _RtnInputAttenuation4({
    super.key,
    required this.partId,
    required this.returnInputAttenuation4TextEditingController,
  });

  final String partId;
  final TextEditingController returnInputAttenuation4TextEditingController;

  @override
  Widget build(BuildContext context) {
    if (partId == '5') {
      return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
        builder: (context, state) {
          double minValue = 0.0;
          double maxValue = 25.0;
          return controlParameterSlider(
            context: context,
            editMode: state.editMode,
            title:
                '${AppLocalizations.of(context)!.returnInputAttenuation4}: ${state.usVCA1} dB',
            minValue: minValue,
            maxValue: maxValue,
            currentValue: state.usVCA1,
            onChanged: (usVCA1) {
              context.read<Setting18ControlBloc>().add(USVCA1Changed(
                    usVCA1: usVCA1.toStringAsFixed(1),
                    maxValue: maxValue,
                    minValue: minValue,
                    textEditingController:
                        returnInputAttenuation4TextEditingController,
                    isFromTextField: false,
                  ));
            },
            textEditingController: returnInputAttenuation4TextEditingController,
            onTextChanged: (usVCA1) {
              context.read<Setting18ControlBloc>().add(USVCA1Changed(
                    usVCA1: usVCA1,
                    maxValue: maxValue,
                    minValue: minValue,
                    textEditingController:
                        returnInputAttenuation4TextEditingController,
                    isFromTextField: true,
                  ));
            },
            onDecreased: () =>
                context.read<Setting18ControlBloc>().add(USVCA1Decreased(
                      minValue: minValue,
                      textEditingController:
                          returnInputAttenuation4TextEditingController,
                    )),
            onIncreased: () =>
                context.read<Setting18ControlBloc>().add(USVCA1Increased(
                      maxValue: maxValue,
                      textEditingController:
                          returnInputAttenuation4TextEditingController,
                    )),
          );
        },
      );
    } else {
      return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
        builder: (context, state) {
          double minValue = 0.0;
          double maxValue = 25.0;
          return controlParameterSlider(
            context: context,
            editMode: state.editMode,
            title:
                '${AppLocalizations.of(context)!.returnInputAttenuation4}: ${state.usVCA4} dB',
            minValue: minValue,
            maxValue: maxValue,
            currentValue: state.usVCA4,
            onChanged: (usVCA4) {
              context.read<Setting18ControlBloc>().add(USVCA4Changed(
                    usVCA4: usVCA4.toStringAsFixed(1),
                    maxValue: maxValue,
                    minValue: minValue,
                    textEditingController:
                        returnInputAttenuation4TextEditingController,
                    isFromTextField: false,
                  ));
            },
            textEditingController: returnInputAttenuation4TextEditingController,
            onTextChanged: (usVCA4) {
              context.read<Setting18ControlBloc>().add(USVCA4Changed(
                    usVCA4: usVCA4,
                    maxValue: maxValue,
                    minValue: minValue,
                    textEditingController:
                        returnInputAttenuation4TextEditingController,
                    isFromTextField: true,
                  ));
            },
            onDecreased: () =>
                context.read<Setting18ControlBloc>().add(USVCA4Decreased(
                      minValue: minValue,
                      textEditingController:
                          returnInputAttenuation4TextEditingController,
                    )),
            onIncreased: () =>
                context.read<Setting18ControlBloc>().add(USVCA4Increased(
                      maxValue: maxValue,
                      textEditingController:
                          returnInputAttenuation4TextEditingController,
                    )),
          );
        },
      );
    }
  }
}

class _RtnInputAttenuation5And6 extends StatelessWidget {
  const _RtnInputAttenuation5And6({
    super.key,
    required this.returnInputAttenuation5And6TextEditingController,
  });

  final TextEditingController returnInputAttenuation5And6TextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 25.0;
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation5And6}: ${state.usVCA4} dB',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.usVCA4,
          onChanged: (usVCA4) {
            context.read<Setting18ControlBloc>().add(USVCA4Changed(
                  usVCA4: usVCA4.toStringAsFixed(1),
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      returnInputAttenuation5And6TextEditingController,
                  isFromTextField: false,
                ));
          },
          textEditingController:
              returnInputAttenuation5And6TextEditingController,
          onTextChanged: (usVCA4) {
            context.read<Setting18ControlBloc>().add(USVCA4Changed(
                  usVCA4: usVCA4,
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      returnInputAttenuation5And6TextEditingController,
                  isFromTextField: true,
                ));
          },
          onDecreased: () =>
              context.read<Setting18ControlBloc>().add(USVCA4Decreased(
                    minValue: minValue,
                    textEditingController:
                        returnInputAttenuation5And6TextEditingController,
                  )),
          onIncreased: () =>
              context.read<Setting18ControlBloc>().add(USVCA4Increased(
                    maxValue: maxValue,
                    textEditingController:
                        returnInputAttenuation5And6TextEditingController,
                  )),
        );
      },
    );
  }
}

class _RtnOutputLevelAttenuation extends StatelessWidget {
  const _RtnOutputLevelAttenuation({
    super.key,
    required this.returnOutputAttenuation1TextEditingController,
  });

  final TextEditingController returnOutputAttenuation1TextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 25.0;
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnOutputAttenuation1}: ${state.usVCA2} dB',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.usVCA2,
          onChanged: (usVCA2) {
            context.read<Setting18ControlBloc>().add(USVCA2Changed(
                  usVCA2: usVCA2.toStringAsFixed(1),
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      returnOutputAttenuation1TextEditingController,
                  isFromTextField: false,
                ));
          },
          textEditingController: returnOutputAttenuation1TextEditingController,
          onTextChanged: (usVCA2) {
            context.read<Setting18ControlBloc>().add(USVCA2Changed(
                  usVCA2: usVCA2,
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      returnOutputAttenuation1TextEditingController,
                  isFromTextField: true,
                ));
          },
          onDecreased: () =>
              context.read<Setting18ControlBloc>().add(USVCA2Decreased(
                    minValue: minValue,
                    textEditingController:
                        returnOutputAttenuation1TextEditingController,
                  )),
          onIncreased: () =>
              context.read<Setting18ControlBloc>().add(USVCA2Increased(
                    maxValue: maxValue,
                    textEditingController:
                        returnOutputAttenuation1TextEditingController,
                  )),
        );
      },
    );
  }
}

class _RtnOutputEQ extends StatelessWidget {
  const _RtnOutputEQ({
    super.key,
    required this.returnOutputEqualizer1TextEditingController,
  });

  final TextEditingController returnOutputEqualizer1TextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 27.0;
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnOutputEqualizer1}: ${state.eREQ} dB',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.eREQ,
          onChanged: (eREQ) {
            context.read<Setting18ControlBloc>().add(EREQChanged(
                  eREQ: eREQ.toStringAsFixed(1),
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      returnOutputEqualizer1TextEditingController,
                  isFromTextField: false,
                ));
          },
          textEditingController: returnOutputEqualizer1TextEditingController,
          onTextChanged: (eREQ) {
            context.read<Setting18ControlBloc>().add(EREQChanged(
                  eREQ: eREQ,
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      returnOutputEqualizer1TextEditingController,
                  isFromTextField: true,
                ));
          },
          onDecreased: () =>
              context.read<Setting18ControlBloc>().add(EREQDecreased(
                    minValue: minValue,
                    textEditingController:
                        returnOutputEqualizer1TextEditingController,
                  )),
          onIncreased: () =>
              context.read<Setting18ControlBloc>().add(EREQIncreased(
                    maxValue: maxValue,
                    textEditingController:
                        returnOutputEqualizer1TextEditingController,
                  )),
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
