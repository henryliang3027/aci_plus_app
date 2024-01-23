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
  const Setting18CCorNodeControlView({super.key});

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
              const _ForwardInputAttenuation1(),
            );
            break;
          case SettingControl.forwardInputAttenuation2:
            break;
          case SettingControl.forwardInputAttenuation3:
            widgets.add(
              const _ForwardInputAttenuation3(),
            );
            break;
          case SettingControl.forwardInputAttenuation4:
            widgets.add(
              const _ForwardInputAttenuation4(),
            );
            break;
          case SettingControl.forwardInputAttenuation5:
            break;
          case SettingControl.forwardInputAttenuation6:
            widgets.add(
              const _ForwardInputAttenuation6(),
            );
            break;
          case SettingControl.forwardInputEqualizer1:
            widgets.add(
              const _ForwardInputEqualizer1(),
            );
            break;
          case SettingControl.forwardInputEqualizer2:
            break;
          case SettingControl.forwardInputEqualizer3:
            widgets.add(
              const _ForwardInputEqualizer3(),
            );
            break;
          case SettingControl.forwardInputEqualizer4:
            widgets.add(
              const _ForwardInputEqualizer4(),
            );
            break;
          case SettingControl.forwardInputEqualizer5:
            break;
          case SettingControl.forwardInputEqualizer6:
            widgets.add(
              const _ForwardInputEqualizer6(),
            );
            break;
        }
      }

      return widgets.isNotEmpty
          ? widgets
          : [
              const _ForwardInputAttenuation1(),
              const _ForwardInputAttenuation3(),
              const _ForwardInputAttenuation4(),
              const _ForwardInputAttenuation6(),
              const _ForwardInputEqualizer1(),
              const _ForwardInputEqualizer3(),
              const _ForwardInputEqualizer4(),
              const _ForwardInputEqualizer6(),
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
  const _ForwardInputAttenuation1({super.key});

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
              '${AppLocalizations.of(context)!.forwardInputAttenuation1}: ${state.dsVVA1} dB',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: _getValue(state.dsVVA1),
          onChanged: (dsVVA1) {
            context
                .read<Setting18CCorNodeControlBloc>()
                .add(DSVVA1Changed(dsVVA1.toStringAsFixed(1)));
          },
          onDecreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(DSVVA1Decreased(minValue)),
          onIncreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(DSVVA1Increased(maxValue)),
        );
      },
    );
  }
}

class _ForwardInputAttenuation3 extends StatelessWidget {
  const _ForwardInputAttenuation3({super.key});

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
              '${AppLocalizations.of(context)!.forwardInputAttenuation3}: ${state.dsVVA3} dB',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: _getValue(state.dsVVA3),
          onChanged: (dsVVA3) {
            context
                .read<Setting18CCorNodeControlBloc>()
                .add(DSVVA3Changed(dsVVA3.toStringAsFixed(1)));
          },
          onDecreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(DSVVA3Decreased(minValue)),
          onIncreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(DSVVA3Increased(maxValue)),
        );
      },
    );
  }
}

class _ForwardInputAttenuation4 extends StatelessWidget {
  const _ForwardInputAttenuation4({super.key});

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
              '${AppLocalizations.of(context)!.returnInputAttenuation4}: ${state.dsVVA4} dB',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: _getValue(state.dsVVA4),
          onChanged: (dsVVA4) {
            context
                .read<Setting18CCorNodeControlBloc>()
                .add(DSVVA4Changed(dsVVA4.toStringAsFixed(1)));
          },
          onDecreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(DSVVA4Decreased(minValue)),
          onIncreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(DSVVA4Increased(maxValue)),
        );
      },
    );
  }
}

class _ForwardInputAttenuation6 extends StatelessWidget {
  const _ForwardInputAttenuation6({super.key});

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
              '${AppLocalizations.of(context)!.returnInputAttenuation6}: ${state.dsVVA6} dB',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: _getValue(state.dsVVA6),
          onChanged: (dsVVA6) {
            context
                .read<Setting18CCorNodeControlBloc>()
                .add(DSVVA6Changed(dsVVA6.toStringAsFixed(1)));
          },
          onDecreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(DSVVA6Decreased(minValue)),
          onIncreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(DSVVA6Increased(maxValue)),
        );
      },
    );
  }
}

class _ForwardInputEqualizer1 extends StatelessWidget {
  const _ForwardInputEqualizer1({super.key});

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
              '${AppLocalizations.of(context)!.forwardInputEqualizer1}: ${state.dsInSlope1} dB',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: _getValue(state.dsInSlope1),
          onChanged: (dsInSlope1) {
            context
                .read<Setting18CCorNodeControlBloc>()
                .add(DSInSlope1Changed(dsInSlope1.toStringAsFixed(1)));
          },
          onDecreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(DSInSlope1Decreased(minValue)),
          onIncreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(DSInSlope1Increased(maxValue)),
        );
      },
    );
  }
}

class _ForwardInputEqualizer3 extends StatelessWidget {
  const _ForwardInputEqualizer3({super.key});

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
              '${AppLocalizations.of(context)!.forwardInputEqualizer3}: ${state.dsInSlope3} dB',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: _getValue(state.dsInSlope3),
          onChanged: (dsInSlope3) {
            context
                .read<Setting18CCorNodeControlBloc>()
                .add(DSInSlope3Changed(dsInSlope3.toStringAsFixed(1)));
          },
          onDecreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(DSInSlope3Decreased(minValue)),
          onIncreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(DSInSlope3Increased(maxValue)),
        );
      },
    );
  }
}

class _ForwardInputEqualizer4 extends StatelessWidget {
  const _ForwardInputEqualizer4({super.key});

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
              '${AppLocalizations.of(context)!.forwardInputEqualizer4}: ${state.dsInSlope4} dB',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: _getValue(state.dsInSlope4),
          onChanged: (dsInSlope4) {
            context
                .read<Setting18CCorNodeControlBloc>()
                .add(DSInSlope4Changed(dsInSlope4.toStringAsFixed(1)));
          },
          onDecreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(DSInSlope4Decreased(minValue)),
          onIncreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(DSInSlope4Increased(maxValue)),
        );
      },
    );
  }
}

class _ForwardInputEqualizer6 extends StatelessWidget {
  const _ForwardInputEqualizer6({super.key});

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
              '${AppLocalizations.of(context)!.forwardInputEqualizer6}: ${state.dsInSlope6} dB',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: _getValue(state.dsInSlope6),
          onChanged: (dsInSlope6) {
            context
                .read<Setting18CCorNodeControlBloc>()
                .add(DSInSlope6Changed(dsInSlope6.toStringAsFixed(1)));
          },
          onDecreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(DSInSlope6Decreased(minValue)),
          onIncreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(DSInSlope6Increased(maxValue)),
        );
      },
    );
  }
}

class _ReturnInputAttenuation1 extends StatelessWidget {
  const _ReturnInputAttenuation1({super.key});

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
              '${AppLocalizations.of(context)!.returnInputAttenuation1}: ${state.usVCA1} dB',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: _getValue(state.usVCA1),
          onChanged: (usVCA1) {
            context
                .read<Setting18CCorNodeControlBloc>()
                .add(USVCA1Changed(usVCA1.toStringAsFixed(1)));
          },
          onDecreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(USVCA1Decreased(minValue)),
          onIncreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(USVCA1Increased(maxValue)),
        );
      },
    );
  }
}

class _ReturnInputAttenuation3 extends StatelessWidget {
  const _ReturnInputAttenuation3({super.key});

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
              '${AppLocalizations.of(context)!.returnInputAttenuation3}: ${state.usVCA3} dB',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: _getValue(state.usVCA3),
          onChanged: (usVCA3) {
            context
                .read<Setting18CCorNodeControlBloc>()
                .add(USVCA3Changed(usVCA3.toStringAsFixed(1)));
          },
          onDecreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(USVCA3Decreased(minValue)),
          onIncreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(USVCA3Increased(maxValue)),
        );
      },
    );
  }
}

class _ReturnInputAttenuation4 extends StatelessWidget {
  const _ReturnInputAttenuation4({super.key});

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
              '${AppLocalizations.of(context)!.returnInputAttenuation4}: ${state.usVCA4} dB',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: _getValue(state.usVCA4),
          onChanged: (usVCA4) {
            context
                .read<Setting18CCorNodeControlBloc>()
                .add(USVCA4Changed(usVCA4.toStringAsFixed(1)));
          },
          onDecreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(USVCA4Decreased(minValue)),
          onIncreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(USVCA4Increased(maxValue)),
        );
      },
    );
  }
}

class _ReturnInputAttenuation6 extends StatelessWidget {
  const _ReturnInputAttenuation6({super.key});

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
              '${AppLocalizations.of(context)!.returnInputAttenuation6}: ${state.usVCA6} dB',
          minValue: minValue,
          maxValue: maxValue,
          currentValue: _getValue(state.usVCA6),
          onChanged: (usVCA6) {
            context
                .read<Setting18CCorNodeControlBloc>()
                .add(USVCA6Changed(usVCA6.toStringAsFixed(1)));
          },
          onDecreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(USVCA6Decreased(minValue)),
          onIncreased: () => context
              .read<Setting18CCorNodeControlBloc>()
              .add(USVCA6Increased(maxValue)),
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
