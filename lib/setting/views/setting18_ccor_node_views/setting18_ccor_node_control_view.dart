import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:aci_plus_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18_ccor_node_control/setting18_ccor_node_control_bloc.dart';
import 'package:aci_plus_app/setting/model/confirm_input_dialog.dart';
import 'package:aci_plus_app/setting/model/setting_wisgets.dart';
import 'package:aci_plus_app/setting/views/custom_setting_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18CCorNodeControlView extends StatelessWidget {
  Setting18CCorNodeControlView({super.key});

  final TextEditingController forwardInputAttenuation1TextEditingController =
      TextEditingController();
  final TextEditingController forwardInputAttenuation3TextEditingController =
      TextEditingController();
  final TextEditingController forwardInputAttenuation4TextEditingController =
      TextEditingController();
  final TextEditingController forwardInputAttenuation6TextEditingController =
      TextEditingController();
  final TextEditingController forwardInputEqualizer1TextEditingController =
      TextEditingController();
  final TextEditingController forwardInputEqualizer3TextEditingController =
      TextEditingController();
  final TextEditingController forwardInputEqualizer4TextEditingController =
      TextEditingController();
  final TextEditingController forwardInputEqualizer6TextEditingController =
      TextEditingController();

  final TextEditingController returnInputAttenuation1TextEditingController =
      TextEditingController();
  final TextEditingController returnInputAttenuation3TextEditingController =
      TextEditingController();
  final TextEditingController returnInputAttenuation4TextEditingController =
      TextEditingController();
  final TextEditingController returnInputAttenuation6TextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    HomeState homeState = context.watch<HomeBloc>().state;
    String partId = homeState.characteristicData[DataKey.partId] ?? '';
    // String currentDetectedSplitOption =
    //     homeState.characteristicData[DataKey.currentDetectedSplitOption] ?? '0';

    String formatResultValue(String boolValue) {
      return boolValue == 'true'
          ? AppLocalizations.of(context)!.dialogMessageSuccessful
          : AppLocalizations.of(context)!.dialogMessageFailed;
    }

    String formatResultItem(String item) {
      if (item == DataKey.dsVVA1.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardInputAttenuation1Setting;
      } else if (item == DataKey.dsVVA3.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardInputAttenuation3Setting;
      } else if (item == DataKey.dsVVA4.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardInputAttenuation4Setting;
      } else if (item == DataKey.dsVVA6.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardInputAttenuation6Setting;
      } else if (item == DataKey.dsInSlope1.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardInputEqualizer1Setting;
      } else if (item == DataKey.dsInSlope3.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardInputEqualizer3Setting;
      } else if (item == DataKey.dsInSlope4.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardInputEqualizer4Setting;
      } else if (item == DataKey.dsInSlope6.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardInputEqualizer6Setting;
      } else if (item == DataKey.usVCA1.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnInputAttenuation1Setting;
      } else if (item == DataKey.usVCA3.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnInputAttenuation3Setting;
      } else if (item == DataKey.usVCA4.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnInputAttenuation4Setting;
      } else if (item == DataKey.usVCA6.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnInputAttenuation6Setting;
      } else if (item == DataKey.ingressSetting1.name) {
        return AppLocalizations.of(context)!.dialogMessageReturnIngress1Setting;
      } else if (item == DataKey.ingressSetting3.name) {
        return AppLocalizations.of(context)!.dialogMessageReturnIngress3Setting;
      } else if (item == DataKey.ingressSetting4.name) {
        return AppLocalizations.of(context)!.dialogMessageReturnIngress4Setting;
      } else if (item == DataKey.ingressSetting6.name) {
        return AppLocalizations.of(context)!.dialogMessageReturnIngress6Setting;
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
              _ForwardInputAttenuation1(
                forwardInputAttenuation1TextEditingController:
                    forwardInputAttenuation1TextEditingController,
              ),
            );
            break;
          case SettingControl.forwardInputAttenuation2:
            break;
          case SettingControl.forwardInputAttenuation3:
            widgets.add(
              _ForwardInputAttenuation3(
                forwardInputAttenuation3TextEditingController:
                    forwardInputAttenuation3TextEditingController,
              ),
            );
            break;
          case SettingControl.forwardInputAttenuation4:
            widgets.add(
              _ForwardInputAttenuation4(
                forwardInputAttenuation4TextEditingController:
                    forwardInputAttenuation4TextEditingController,
              ),
            );
            break;
          case SettingControl.forwardInputAttenuation5:
            break;
          case SettingControl.forwardInputAttenuation6:
            widgets.add(
              _ForwardInputAttenuation6(
                forwardInputAttenuation6TextEditingController:
                    forwardInputAttenuation6TextEditingController,
              ),
            );
            break;
          case SettingControl.forwardInputEqualizer1:
            widgets.add(
              _ForwardInputEqualizer1(
                forwardInputEqualizer1TextEditingController:
                    forwardInputEqualizer1TextEditingController,
              ),
            );
            break;
          case SettingControl.forwardInputEqualizer2:
            break;
          case SettingControl.forwardInputEqualizer3:
            widgets.add(
              _ForwardInputEqualizer3(
                forwardInputEqualizer3TextEditingController:
                    forwardInputEqualizer3TextEditingController,
              ),
            );
            break;
          case SettingControl.forwardInputEqualizer4:
            widgets.add(
              _ForwardInputEqualizer4(
                forwardInputEqualizer4TextEditingController:
                    forwardInputEqualizer4TextEditingController,
              ),
            );
            break;
          case SettingControl.forwardInputEqualizer5:
            break;
          case SettingControl.forwardInputEqualizer6:
            widgets.add(
              _ForwardInputEqualizer6(
                forwardInputEqualizer6TextEditingController:
                    forwardInputEqualizer6TextEditingController,
              ),
            );
            break;
        }
      }

      return widgets.isNotEmpty
          ? widgets
          : [
              _ForwardInputAttenuation1(
                forwardInputAttenuation1TextEditingController:
                    forwardInputAttenuation1TextEditingController,
              ),
              _ForwardInputAttenuation3(
                forwardInputAttenuation3TextEditingController:
                    forwardInputAttenuation3TextEditingController,
              ),
              _ForwardInputAttenuation4(
                forwardInputAttenuation4TextEditingController:
                    forwardInputAttenuation4TextEditingController,
              ),
              _ForwardInputAttenuation6(
                forwardInputAttenuation6TextEditingController:
                    forwardInputAttenuation6TextEditingController,
              ),
              _ForwardInputEqualizer1(
                forwardInputEqualizer1TextEditingController:
                    forwardInputEqualizer1TextEditingController,
              ),
              _ForwardInputEqualizer3(
                forwardInputEqualizer3TextEditingController:
                    forwardInputEqualizer3TextEditingController,
              ),
              _ForwardInputEqualizer4(
                forwardInputEqualizer4TextEditingController:
                    forwardInputEqualizer4TextEditingController,
              ),
              _ForwardInputEqualizer6(
                forwardInputEqualizer6TextEditingController:
                    forwardInputEqualizer6TextEditingController,
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
            widgets.add(
              _ReturnInputAttenuation1(
                returnInputAttenuation1TextEditingController:
                    returnInputAttenuation1TextEditingController,
              ),
            );
            break;
          case SettingControl.returnInputAttenuation2:
            break;
          case SettingControl.returnInputAttenuation3:
            widgets.add(
              _ReturnInputAttenuation3(
                returnInputAttenuation3TextEditingController:
                    returnInputAttenuation3TextEditingController,
              ),
            );
            break;
          case SettingControl.returnInputAttenuation4:
            widgets.add(
              _ReturnInputAttenuation4(
                returnInputAttenuation4TextEditingController:
                    returnInputAttenuation4TextEditingController,
              ),
            );
            break;
          case SettingControl.returnInputAttenuation5:
            break;
          case SettingControl.returnInputAttenuation6:
            widgets.add(
              _ReturnInputAttenuation6(
                returnInputAttenuation6TextEditingController:
                    returnInputAttenuation6TextEditingController,
              ),
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
              _ReturnInputAttenuation1(
                returnInputAttenuation1TextEditingController:
                    returnInputAttenuation1TextEditingController,
              ),
              _ReturnInputAttenuation3(
                returnInputAttenuation3TextEditingController:
                    returnInputAttenuation3TextEditingController,
              ),
              _ReturnInputAttenuation4(
                returnInputAttenuation4TextEditingController:
                    returnInputAttenuation4TextEditingController,
              ),
              _ReturnInputAttenuation6(
                returnInputAttenuation6TextEditingController:
                    returnInputAttenuation6TextEditingController,
              ),
              const _ReturnIngressSetting1(),
              const _ReturnIngressSetting3(),
              const _ReturnIngressSetting4(),
              const _ReturnIngressSetting6(),
            ];
    }

    Widget buildControlWidget(String partId) {
      List<Widget> forwardControlParameters =
          getForwardControlParameterWidgetsByPartId(partId);
      List<Widget> returnControlParameters =
          getReturnControlParameterWidgetsByPartId(partId);

      return Column(children: [
        forwardControlParameters.isNotEmpty
            ? _ClusterTitle(
                title: AppLocalizations.of(context)!.forwardControlParameters,
              )
            : Container(),
        ...forwardControlParameters,
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

    return BlocListener<Setting18CCorNodeControlBloc,
        Setting18CCorNodeControlState>(
      listener: (context, state) async {
        if (state.submissionStatus.isSubmissionInProgress) {
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

          context.read<Setting18CCorNodeControlBloc>().add(const Initialized());
        }

        if (state.isInitialize) {
          forwardInputAttenuation1TextEditingController.text = state.dsVVA1;
          forwardInputAttenuation3TextEditingController.text = state.dsVVA3;
          forwardInputAttenuation4TextEditingController.text = state.dsVVA4;
          forwardInputAttenuation6TextEditingController.text = state.dsVVA6;
          forwardInputEqualizer1TextEditingController.text = state.dsInSlope1;
          forwardInputEqualizer3TextEditingController.text = state.dsInSlope3;
          forwardInputEqualizer4TextEditingController.text = state.dsInSlope4;
          forwardInputEqualizer6TextEditingController.text = state.dsInSlope6;

          returnInputAttenuation1TextEditingController.text = state.usVCA1;
          returnInputAttenuation3TextEditingController.text = state.usVCA3;
          returnInputAttenuation4TextEditingController.text = state.usVCA4;
          returnInputAttenuation6TextEditingController.text = state.usVCA6;
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
    required this.forwardInputAttenuation1TextEditingController,
  });

  final TextEditingController forwardInputAttenuation1TextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeControlBloc,
        Setting18CCorNodeControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 25.0;
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardInputAttenuation1} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsVVA1,
          onChanged: (dsVVA1) {
            context.read<Setting18CCorNodeControlBloc>().add(DSVVA1Changed(
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
            context.read<Setting18CCorNodeControlBloc>().add(DSVVA1Changed(
                  dsVVA1: dsVVA1,
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      forwardInputAttenuation1TextEditingController,
                  isFromTextField: true,
                ));
          },
          onDecreased: () =>
              context.read<Setting18CCorNodeControlBloc>().add(DSVVA1Decreased(
                    minValue: minValue,
                    textEditingController:
                        forwardInputAttenuation1TextEditingController,
                  )),
          onIncreased: () =>
              context.read<Setting18CCorNodeControlBloc>().add(DSVVA1Increased(
                    maxValue: maxValue,
                    textEditingController:
                        forwardInputAttenuation1TextEditingController,
                  )),
        );
      },
    );
  }
}

class _ForwardInputAttenuation3 extends StatelessWidget {
  const _ForwardInputAttenuation3({
    super.key,
    required this.forwardInputAttenuation3TextEditingController,
  });

  final TextEditingController forwardInputAttenuation3TextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeControlBloc,
        Setting18CCorNodeControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 25.0;
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardInputAttenuation3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsVVA3,
          onChanged: (dsVVA3) {
            context.read<Setting18CCorNodeControlBloc>().add(DSVVA3Changed(
                  dsVVA3: dsVVA3.toStringAsFixed(1),
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      forwardInputAttenuation3TextEditingController,
                  isFromTextField: false,
                ));
          },
          textEditingController: forwardInputAttenuation3TextEditingController,
          onTextChanged: (dsVVA3) {
            context.read<Setting18CCorNodeControlBloc>().add(DSVVA3Changed(
                  dsVVA3: dsVVA3,
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      forwardInputAttenuation3TextEditingController,
                  isFromTextField: true,
                ));
          },
          onDecreased: () =>
              context.read<Setting18CCorNodeControlBloc>().add(DSVVA3Decreased(
                    minValue: minValue,
                    textEditingController:
                        forwardInputAttenuation3TextEditingController,
                  )),
          onIncreased: () =>
              context.read<Setting18CCorNodeControlBloc>().add(DSVVA3Increased(
                    maxValue: maxValue,
                    textEditingController:
                        forwardInputAttenuation3TextEditingController,
                  )),
        );
      },
    );
  }
}

class _ForwardInputAttenuation4 extends StatelessWidget {
  const _ForwardInputAttenuation4({
    super.key,
    required this.forwardInputAttenuation4TextEditingController,
  });

  final TextEditingController forwardInputAttenuation4TextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeControlBloc,
        Setting18CCorNodeControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 25.0;
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation4} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsVVA4,
          onChanged: (dsVVA4) {
            context.read<Setting18CCorNodeControlBloc>().add(DSVVA4Changed(
                  dsVVA4: dsVVA4.toStringAsFixed(1),
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      forwardInputAttenuation4TextEditingController,
                  isFromTextField: false,
                ));
          },
          textEditingController: forwardInputAttenuation4TextEditingController,
          onTextChanged: (dsVVA4) {
            context.read<Setting18CCorNodeControlBloc>().add(DSVVA4Changed(
                  dsVVA4: dsVVA4,
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      forwardInputAttenuation4TextEditingController,
                  isFromTextField: true,
                ));
          },
          onDecreased: () =>
              context.read<Setting18CCorNodeControlBloc>().add(DSVVA4Decreased(
                    minValue: minValue,
                    textEditingController:
                        forwardInputAttenuation4TextEditingController,
                  )),
          onIncreased: () =>
              context.read<Setting18CCorNodeControlBloc>().add(DSVVA4Increased(
                    maxValue: maxValue,
                    textEditingController:
                        forwardInputAttenuation4TextEditingController,
                  )),
        );
      },
    );
  }
}

class _ForwardInputAttenuation6 extends StatelessWidget {
  const _ForwardInputAttenuation6({
    super.key,
    required this.forwardInputAttenuation6TextEditingController,
  });

  final TextEditingController forwardInputAttenuation6TextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeControlBloc,
        Setting18CCorNodeControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 25.0;
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation6} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsVVA6,
          onChanged: (dsVVA6) {
            context.read<Setting18CCorNodeControlBloc>().add(DSVVA6Changed(
                  dsVVA6: dsVVA6.toStringAsFixed(1),
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      forwardInputAttenuation6TextEditingController,
                  isFromTextField: false,
                ));
          },
          textEditingController: forwardInputAttenuation6TextEditingController,
          onTextChanged: (dsVVA6) {
            context.read<Setting18CCorNodeControlBloc>().add(DSVVA6Changed(
                  dsVVA6: dsVVA6,
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      forwardInputAttenuation6TextEditingController,
                  isFromTextField: true,
                ));
          },
          onDecreased: () =>
              context.read<Setting18CCorNodeControlBloc>().add(DSVVA6Decreased(
                    minValue: minValue,
                    textEditingController:
                        forwardInputAttenuation6TextEditingController,
                  )),
          onIncreased: () =>
              context.read<Setting18CCorNodeControlBloc>().add(DSVVA6Increased(
                    maxValue: maxValue,
                    textEditingController:
                        forwardInputAttenuation6TextEditingController,
                  )),
        );
      },
    );
  }
}

class _ForwardInputEqualizer1 extends StatelessWidget {
  const _ForwardInputEqualizer1({
    super.key,
    required this.forwardInputEqualizer1TextEditingController,
  });

  final TextEditingController forwardInputEqualizer1TextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeControlBloc,
        Setting18CCorNodeControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 15.0;
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardInputEqualizer1} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsInSlope1,
          onChanged: (dsInSlope1) {
            context.read<Setting18CCorNodeControlBloc>().add(DSInSlope1Changed(
                  dsInSlope1: dsInSlope1.toStringAsFixed(1),
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      forwardInputEqualizer1TextEditingController,
                  isFromTextField: false,
                ));
          },
          textEditingController: forwardInputEqualizer1TextEditingController,
          onTextChanged: (dsInSlope1) {
            context.read<Setting18CCorNodeControlBloc>().add(DSInSlope1Changed(
                  dsInSlope1: dsInSlope1,
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      forwardInputEqualizer1TextEditingController,
                  isFromTextField: true,
                ));
          },
          onDecreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(DSInSlope1Decreased(
                minValue: minValue,
                textEditingController:
                    forwardInputEqualizer1TextEditingController,
              )),
          onIncreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(DSInSlope1Increased(
                maxValue: maxValue,
                textEditingController:
                    forwardInputEqualizer1TextEditingController,
              )),
        );
      },
    );
  }
}

class _ForwardInputEqualizer3 extends StatelessWidget {
  const _ForwardInputEqualizer3({
    super.key,
    required this.forwardInputEqualizer3TextEditingController,
  });

  final TextEditingController forwardInputEqualizer3TextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeControlBloc,
        Setting18CCorNodeControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 15.0;
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardInputEqualizer3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsInSlope3,
          onChanged: (dsInSlope3) {
            context.read<Setting18CCorNodeControlBloc>().add(DSInSlope3Changed(
                  dsInSlope3: dsInSlope3.toStringAsFixed(1),
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      forwardInputEqualizer3TextEditingController,
                  isFromTextField: false,
                ));
          },
          textEditingController: forwardInputEqualizer3TextEditingController,
          onTextChanged: (dsInSlope3) {
            context.read<Setting18CCorNodeControlBloc>().add(DSInSlope3Changed(
                  dsInSlope3: dsInSlope3,
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      forwardInputEqualizer3TextEditingController,
                  isFromTextField: true,
                ));
          },
          onDecreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(DSInSlope3Decreased(
                minValue: minValue,
                textEditingController:
                    forwardInputEqualizer3TextEditingController,
              )),
          onIncreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(DSInSlope3Increased(
                maxValue: maxValue,
                textEditingController:
                    forwardInputEqualizer3TextEditingController,
              )),
        );
      },
    );
  }
}

class _ForwardInputEqualizer4 extends StatelessWidget {
  const _ForwardInputEqualizer4({
    super.key,
    required this.forwardInputEqualizer4TextEditingController,
  });

  final TextEditingController forwardInputEqualizer4TextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeControlBloc,
        Setting18CCorNodeControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 15.0;
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardInputEqualizer4} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsInSlope4,
          onChanged: (dsInSlope4) {
            context.read<Setting18CCorNodeControlBloc>().add(DSInSlope4Changed(
                  dsInSlope4: dsInSlope4.toStringAsFixed(1),
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      forwardInputEqualizer4TextEditingController,
                  isFromTextField: false,
                ));
          },
          textEditingController: forwardInputEqualizer4TextEditingController,
          onTextChanged: (dsInSlope4) {
            context.read<Setting18CCorNodeControlBloc>().add(DSInSlope4Changed(
                  dsInSlope4: dsInSlope4,
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      forwardInputEqualizer4TextEditingController,
                  isFromTextField: true,
                ));
          },
          onDecreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(DSInSlope4Decreased(
                minValue: minValue,
                textEditingController:
                    forwardInputEqualizer4TextEditingController,
              )),
          onIncreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(DSInSlope4Increased(
                maxValue: maxValue,
                textEditingController:
                    forwardInputEqualizer4TextEditingController,
              )),
        );
      },
    );
  }
}

class _ForwardInputEqualizer6 extends StatelessWidget {
  const _ForwardInputEqualizer6({
    super.key,
    required this.forwardInputEqualizer6TextEditingController,
  });

  final TextEditingController forwardInputEqualizer6TextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeControlBloc,
        Setting18CCorNodeControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 15.0;
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.forwardInputEqualizer6} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.dsInSlope6,
          onChanged: (dsInSlope6) {
            context.read<Setting18CCorNodeControlBloc>().add(DSInSlope6Changed(
                  dsInSlope6: dsInSlope6.toStringAsFixed(1),
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      forwardInputEqualizer6TextEditingController,
                  isFromTextField: false,
                ));
          },
          textEditingController: forwardInputEqualizer6TextEditingController,
          onTextChanged: (dsInSlope6) {
            context.read<Setting18CCorNodeControlBloc>().add(DSInSlope6Changed(
                  dsInSlope6: dsInSlope6,
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      forwardInputEqualizer6TextEditingController,
                  isFromTextField: true,
                ));
          },
          onDecreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(DSInSlope6Decreased(
                minValue: minValue,
                textEditingController:
                    forwardInputEqualizer6TextEditingController,
              )),
          onIncreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(DSInSlope6Increased(
                maxValue: maxValue,
                textEditingController:
                    forwardInputEqualizer6TextEditingController,
              )),
        );
      },
    );
  }
}

class _ReturnInputAttenuation1 extends StatelessWidget {
  const _ReturnInputAttenuation1({
    super.key,
    required this.returnInputAttenuation1TextEditingController,
  });

  final TextEditingController returnInputAttenuation1TextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeControlBloc,
        Setting18CCorNodeControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 25.0;
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation1} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.usVCA1,
          onChanged: (usVCA1) {
            context.read<Setting18CCorNodeControlBloc>().add(USVCA1Changed(
                  usVCA1: usVCA1.toStringAsFixed(1),
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      returnInputAttenuation1TextEditingController,
                  isFromTextField: false,
                ));
          },
          textEditingController: returnInputAttenuation1TextEditingController,
          onTextChanged: (usVCA1) {
            context.read<Setting18CCorNodeControlBloc>().add(USVCA1Changed(
                  usVCA1: usVCA1,
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      returnInputAttenuation1TextEditingController,
                  isFromTextField: true,
                ));
          },
          onDecreased: () =>
              context.read<Setting18CCorNodeControlBloc>().add(USVCA1Decreased(
                    minValue: minValue,
                    textEditingController:
                        returnInputAttenuation1TextEditingController,
                  )),
          onIncreased: () =>
              context.read<Setting18CCorNodeControlBloc>().add(USVCA1Increased(
                    maxValue: maxValue,
                    textEditingController:
                        returnInputAttenuation1TextEditingController,
                  )),
        );
      },
    );
  }
}

class _ReturnInputAttenuation3 extends StatelessWidget {
  const _ReturnInputAttenuation3({
    super.key,
    required this.returnInputAttenuation3TextEditingController,
  });

  final TextEditingController returnInputAttenuation3TextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeControlBloc,
        Setting18CCorNodeControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 25.0;
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation3} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.usVCA3,
          onChanged: (usVCA3) {
            context.read<Setting18CCorNodeControlBloc>().add(USVCA3Changed(
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
            context.read<Setting18CCorNodeControlBloc>().add(USVCA3Changed(
                  usVCA3: usVCA3,
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      returnInputAttenuation3TextEditingController,
                  isFromTextField: true,
                ));
          },
          onDecreased: () =>
              context.read<Setting18CCorNodeControlBloc>().add(USVCA3Decreased(
                    minValue: minValue,
                    textEditingController:
                        returnInputAttenuation3TextEditingController,
                  )),
          onIncreased: () =>
              context.read<Setting18CCorNodeControlBloc>().add(USVCA3Increased(
                    maxValue: maxValue,
                    textEditingController:
                        returnInputAttenuation3TextEditingController,
                  )),
        );
      },
    );
  }
}

class _ReturnInputAttenuation4 extends StatelessWidget {
  const _ReturnInputAttenuation4({
    super.key,
    required this.returnInputAttenuation4TextEditingController,
  });

  final TextEditingController returnInputAttenuation4TextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeControlBloc,
        Setting18CCorNodeControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 25.0;
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation4} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.usVCA4,
          onChanged: (usVCA4) {
            context.read<Setting18CCorNodeControlBloc>().add(USVCA4Changed(
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
            context.read<Setting18CCorNodeControlBloc>().add(USVCA4Changed(
                  usVCA4: usVCA4,
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      returnInputAttenuation4TextEditingController,
                  isFromTextField: true,
                ));
          },
          onDecreased: () =>
              context.read<Setting18CCorNodeControlBloc>().add(USVCA4Decreased(
                    minValue: minValue,
                    textEditingController:
                        returnInputAttenuation4TextEditingController,
                  )),
          onIncreased: () =>
              context.read<Setting18CCorNodeControlBloc>().add(USVCA4Increased(
                    maxValue: maxValue,
                    textEditingController:
                        returnInputAttenuation4TextEditingController,
                  )),
        );
      },
    );
  }
}

class _ReturnInputAttenuation6 extends StatelessWidget {
  const _ReturnInputAttenuation6({
    super.key,
    required this.returnInputAttenuation6TextEditingController,
  });

  final TextEditingController returnInputAttenuation6TextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeControlBloc,
        Setting18CCorNodeControlState>(
      builder: (context, state) {
        double minValue = 0.0;
        double maxValue = 25.0;
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.returnInputAttenuation6} (${CustomStyle.dB}):',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: state.usVCA6,
          onChanged: (usVCA6) {
            context.read<Setting18CCorNodeControlBloc>().add(USVCA6Changed(
                  usVCA6: usVCA6.toStringAsFixed(1),
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      returnInputAttenuation6TextEditingController,
                  isFromTextField: false,
                ));
          },
          textEditingController: returnInputAttenuation6TextEditingController,
          onTextChanged: (usVCA6) {
            context.read<Setting18CCorNodeControlBloc>().add(USVCA6Changed(
                  usVCA6: usVCA6,
                  maxValue: maxValue,
                  minValue: minValue,
                  textEditingController:
                      returnInputAttenuation6TextEditingController,
                  isFromTextField: true,
                ));
          },
          onDecreased: () =>
              context.read<Setting18CCorNodeControlBloc>().add(USVCA6Decreased(
                    minValue: minValue,
                    textEditingController:
                        returnInputAttenuation6TextEditingController,
                  )),
          onIncreased: () =>
              context.read<Setting18CCorNodeControlBloc>().add(USVCA6Increased(
                    maxValue: maxValue,
                    textEditingController:
                        returnInputAttenuation6TextEditingController,
                  )),
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
    return BlocBuilder<Setting18CCorNodeControlBloc,
        Setting18CCorNodeControlState>(
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
                .read<Setting18CCorNodeControlBloc>()
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
    return BlocBuilder<Setting18CCorNodeControlBloc,
        Setting18CCorNodeControlState>(
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
                .read<Setting18CCorNodeControlBloc>()
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
    return BlocBuilder<Setting18CCorNodeControlBloc,
        Setting18CCorNodeControlState>(
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
                .read<Setting18CCorNodeControlBloc>()
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
    return BlocBuilder<Setting18CCorNodeControlBloc,
        Setting18CCorNodeControlState>(
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
                .read<Setting18CCorNodeControlBloc>()
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
                        .read<Setting18CCorNodeControlBloc>()
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
                                .read<Setting18CCorNodeControlBloc>()
                                .add(const SettingSubmitted());
                          } else {
                            bool? isMatch =
                                await showConfirmInputDialog(context: context);

                            if (context.mounted) {
                              if (isMatch != null) {
                                if (isMatch) {
                                  context
                                      .read<Setting18CCorNodeControlBloc>()
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
                // FloatingActionButton(
                //   shape: const CircleBorder(
                //     side: BorderSide.none,
                //   ),
                //   backgroundColor: Colors.grey.withAlpha(200),
                //   child: Icon(
                //     Icons.grain_sharp,
                //     color: Theme.of(context).colorScheme.onPrimary,
                //   ),
                //   onPressed: () {
                //     context.read<SettingBloc>().add(const GraphViewToggled());
                //   },
                // ),
                // const SizedBox(
                //   height: 10.0,
                // ),
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
                        .read<Setting18CCorNodeControlBloc>()
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
      final Setting18CCorNodeControlState setting18ListViewState =
          context.watch<Setting18CCorNodeControlBloc>().state;

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
