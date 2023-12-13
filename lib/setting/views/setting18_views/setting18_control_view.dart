import 'package:aci_plus_app/core/command.dart';
import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
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
    String agcMode = homeState.characteristicData[DataKey.agcMode] ?? '0';
    String alcMode = homeState.characteristicData[DataKey.alcMode] ?? '0';
    String currentInputAttenuation =
        homeState.characteristicData[DataKey.currentDSVVA1] ?? '';
    String currentInputEqualizer =
        homeState.characteristicData[DataKey.currentDSSlope1] ?? '';

    String formatResultValue(String boolValue) {
      return boolValue == 'true'
          ? AppLocalizations.of(context)!.dialogMessageSuccessful
          : AppLocalizations.of(context)!.dialogMessageFailed;
    }

    String formatResultItem(String item) {
      if (item == DataKey.dsVVA1.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardInputAttenuationSetting;
      } else if (item == DataKey.dsSlope1.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardInputEqualizerSetting;
      } else if (item == DataKey.inputAttenuation2.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnInputAttenuation2Setting;
      } else if (item == DataKey.usVCA3.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnInputAttenuation3Setting;
      } else if (item == DataKey.usVCA4.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnInputAttenuation4Setting;
      } else if (item == DataKey.outputAttenuation.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnOutputAttenuationSetting;
      } else if (item == DataKey.outputEqualizer.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnOutputEqualizerSetting;
      } else if (item == DataKey.ingressSetting2.name) {
        return AppLocalizations.of(context)!.dialogMessageReturnIngress2Setting;
      } else if (item == DataKey.ingressSetting3.name) {
        return AppLocalizations.of(context)!.dialogMessageReturnIngress3Setting;
      } else if (item == DataKey.ingressSetting4.name) {
        return AppLocalizations.of(context)!.dialogMessageReturnIngress4Setting;
      } else if (item == DataKey.tgcCableLength.name) {
        return AppLocalizations.of(context)!.dialogMessageTGCCableLengthSetting;
      } else if (item == DataKey.dsVVA2.name) {
        return AppLocalizations.of(context)!.dialogMessageDSVVA2Setting;
      } else if (item == DataKey.dsSlope2.name) {
        return AppLocalizations.of(context)!.dialogMessageDSSlope2Setting;
      } else if (item == DataKey.dsVVA3.name) {
        return AppLocalizations.of(context)!.dialogMessageDSVVA3Setting;
      } else if (item == DataKey.dsVVA4.name) {
        if (partId == '5' || partId == '6') {
          return AppLocalizations.of(context)!
              .dialogMessageForwardOutputAttenuation2And3Setting;
        } else {
          return AppLocalizations.of(context)!
              .dialogMessageForwardOutputAttenuation3And4Setting;
        }
      } else if (item == DataKey.dsSlope3.name) {
        if (partId == '5' || partId == '6') {
          return AppLocalizations.of(context)!
              .dialogMessageForwardOutputEqualizer2And3Setting;
        } else {
          return AppLocalizations.of(context)!
              .dialogMessageForwardOutputEqualizer3And4Setting;
        }
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
                    fontSize: 16,
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
          case SettingControl.forwardInputAttenuation:
            widgets.add(
              _FwdInputAttenuation(
                alcMode: alcMode,
                currentInputAttenuation: currentInputAttenuation,
              ),
            );
            break;
          case SettingControl.forwardInputEqualizer:
            widgets.add(
              _FwdInputEQ(
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
              _FwdInputAttenuation(
                alcMode: alcMode,
                currentInputAttenuation: currentInputAttenuation,
              ),
              _FwdInputEQ(
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
              const _RtnInputAttenuation4(),
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
          case SettingControl.returnOutputAttenuation:
            widgets.add(
              const _RtnOutputLevelAttenuation(),
            );
            break;
          case SettingControl.returnOutputEqualizer:
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
              const _RtnIngressSetting4(),
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
              const _RtnInputAttenuation4(),
              const _RtnOutputLevelAttenuation(),
              const _RtnOutputEQ(),
              const _RtnIngressSetting2(),
              const _RtnIngressSetting3(),
              const _RtnIngressSetting4(),
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
        forwardControlParameters.isNotEmpty
            ? const SizedBox(
                height: 30,
              )
            : Container(),
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

    return BlocListener<Setting18ControlBloc, Setting18ControlState>(
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

          context.read<Setting18ControlBloc>().add(const Initialized());
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
        floatingActionButton: _SettingFloatingActionButton(partId: partId),
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
                fontSize: 16.0,
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

class _FwdInputAttenuation extends StatelessWidget {
  const _FwdInputAttenuation({
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
              '${AppLocalizations.of(context)!.fwdInputAttenuation}: ${getCurrentValue(state.dsVVA1)} dB',
          minValue: 0.0,
          maxValue: 15.0,
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

class _FwdInputEQ extends StatelessWidget {
  const _FwdInputEQ({
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
    double getCurrentValue(String fwdInputEQ) {
      return alcMode == '0' && agcMode == '0'
          ? _getValue(fwdInputEQ)
          : _getValue(currentInputEqualizer);
    }

    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        return controlParameterSlider(
          context: context,
          editMode: state.editMode && alcMode == '0' && agcMode == '0',
          title:
              '${AppLocalizations.of(context)!.fwdInputEQ}: ${getCurrentValue(state.dsSlope1)} dB',
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
          maxValue: 15.0,
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
          maxValue: 15.0,
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
              '${AppLocalizations.of(context)!.rtnInputAttenuation2}: ${state.rtnInputAttenuation2} dB',
          minValue: 0.0,
          maxValue: 15.0,
          currentValue: _getValue(state.rtnInputAttenuation2),
          onChanged: (rtnInputAttenuation) {
            context.read<Setting18ControlBloc>().add(
                RtnInputAttenuation2Changed(
                    rtnInputAttenuation.toStringAsFixed(1)));
          },
          onDecreased: () => context
              .read<Setting18ControlBloc>()
              .add(const RtnInputAttenuation2Decreased()),
          onIncreased: () => context
              .read<Setting18ControlBloc>()
              .add(const RtnInputAttenuation2Increased()),
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
              '${AppLocalizations.of(context)!.rtnInputAttenuation3}: ${state.usVCA3} dB',
          minValue: 0.0,
          maxValue: 15.0,
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
              '${AppLocalizations.of(context)!.rtnInputAttenuation2And3}: ${state.usVCA3} dB',
          minValue: 0.0,
          maxValue: 15.0,
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
  const _RtnInputAttenuation4({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context)!.rtnInputAttenuation4}: ${state.usVCA4} dB',
          minValue: 0.0,
          maxValue: 15.0,
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
              '${AppLocalizations.of(context)!.rtnInputAttenuation5And6}: ${state.usVCA4} dB',
          minValue: 0.0,
          maxValue: 15.0,
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
              '${AppLocalizations.of(context)!.rtnOutputLevelAttenuation}: ${state.rtnOutputLevelAttenuation} dB',
          minValue: 0.0,
          maxValue: 15.0,
          currentValue: _getValue(state.rtnOutputLevelAttenuation),
          onChanged: (rtnInputAttenuation) {
            context.read<Setting18ControlBloc>().add(
                RtnOutputLevelAttenuationChanged(
                    rtnInputAttenuation.toStringAsFixed(1)));
          },
          onDecreased: () => context
              .read<Setting18ControlBloc>()
              .add(const RtnOutputLevelAttenuationDecreased()),
          onIncreased: () => context
              .read<Setting18ControlBloc>()
              .add(const RtnOutputLevelAttenuationIncreased()),
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
              '${AppLocalizations.of(context)!.rtnOutputEQ}: ${state.rtnOutputEQ} dB',
          minValue: 0.0,
          maxValue: 15.0,
          currentValue: _getValue(state.rtnOutputEQ),
          onChanged: (rtnOutputEQ) {
            context
                .read<Setting18ControlBloc>()
                .add(RtnOutputEQChanged(rtnOutputEQ.toStringAsFixed(1)));
          },
          onDecreased: () => context
              .read<Setting18ControlBloc>()
              .add(const RtnOutputEQDecreased()),
          onIncreased: () => context
              .read<Setting18ControlBloc>()
              .add(const RtnOutputEQIncreased()),
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
          previous.rtnIngressSetting2 != current.rtnIngressSetting2 ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return controlToggleButton(
          context: context,
          editMode: state.editMode,
          title: '${AppLocalizations.of(context)!.rtnIngressSetting2}:',
          currentValue: state.rtnIngressSetting2,
          onChanged: (int index) {
            context
                .read<Setting18ControlBloc>()
                .add(RtnIngressSetting2Changed(rtnIngressValues[index]));
          },
          values: rtnIngressValues,
          texts: [
            '0',
            '-3',
            '-6',
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
          previous.rtnIngressSetting3 != current.rtnIngressSetting3 ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return controlToggleButton(
          context: context,
          editMode: state.editMode,
          title: '${AppLocalizations.of(context)!.rtnIngressSetting3}:',
          currentValue: state.rtnIngressSetting3,
          onChanged: (int index) {
            context
                .read<Setting18ControlBloc>()
                .add(RtnIngressSetting3Changed(rtnIngressValues[index]));
          },
          values: rtnIngressValues,
          texts: [
            '0',
            '-3',
            '-6',
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
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      buildWhen: (previous, current) =>
          previous.rtnIngressSetting4 != current.rtnIngressSetting4 ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return controlToggleButton(
          context: context,
          editMode: state.editMode,
          title: '${AppLocalizations.of(context)!.rtnIngressSetting4}:',
          currentValue: state.rtnIngressSetting4,
          onChanged: (int index) {
            context
                .read<Setting18ControlBloc>()
                .add(RtnIngressSetting4Changed(rtnIngressValues[index]));
          },
          values: rtnIngressValues,
          texts: [
            '0',
            '-3',
            '-6',
            AppLocalizations.of(context)!.ingressOpen,
          ],
        );
      },
    );
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
          previous.rtnIngressSetting3 != current.rtnIngressSetting3 ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return controlToggleButton(
          context: context,
          editMode: state.editMode,
          title: '${AppLocalizations.of(context)!.rtnIngressSetting2And3}:',
          currentValue: state.rtnIngressSetting3,
          onChanged: (int index) {
            context
                .read<Setting18ControlBloc>()
                .add(RtnIngressSetting3Changed(rtnIngressValues[index]));
          },
          values: rtnIngressValues,
          texts: [
            '0',
            '-3',
            '-6',
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
          previous.rtnIngressSetting4 != current.rtnIngressSetting4 ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return controlToggleButton(
          context: context,
          editMode: state.editMode,
          title: '${AppLocalizations.of(context)!.rtnIngressSetting5And6}:',
          currentValue: state.rtnIngressSetting4,
          onChanged: (int index) {
            context
                .read<Setting18ControlBloc>()
                .add(RtnIngressSetting4Changed(rtnIngressValues[index]));
          },
          values: rtnIngressValues,
          texts: [
            '0',
            '-3',
            '-6',
            AppLocalizations.of(context)!.ingressOpen,
          ],
        );
      },
    );
  }
}

// class _DSVVA2 extends StatelessWidget {
//   const _DSVVA2({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
//       builder: (context, state) {
//         return controlParameterSlider(
//           context: context,
//           editMode: state.editMode,
//           title: 'DS VVA2: ${state.dsVVA2} dB',
//           minValue: 0.0,
//           maxValue: 15.0,
//           currentValue: _getValue(state.dsVVA2),
//           onChanged: (value) {
//             context
//                 .read<Setting18ControlBloc>()
//                 .add(DSVVA2Changed(value.toStringAsFixed(1)));
//           },

//         );
//       },
//     );
//   }
// }

// class _DSSlope2 extends StatelessWidget {
//   const _DSSlope2({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
//       builder: (context, state) {
//         return controlParameterSlider(
//           context: context,
//           editMode: state.editMode,
//           title: 'DS Slope2: ${state.dsSlope2} dB',
//           minValue: 0.0,
//           maxValue: 15.0,
//           currentValue: _getValue(state.dsSlope2),
//           onChanged: (value) {
//             context
//                 .read<Setting18ControlBloc>()
//                 .add(DSSlope2Changed(value.toStringAsFixed(1)));
//           },
//         );
//       },
//     );
//   }
// }

// class _DSVVA3 extends StatelessWidget {
//   const _DSVVA3({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
//       builder: (context, state) {
//         return controlParameterSlider(
//           context: context,
//           editMode: state.editMode,
//           title: 'DS VVA3: ${state.dsVVA3} dB',
//           minValue: 0.0,
//           maxValue: 15.0,
//           currentValue: _getValue(state.dsVVA3),
//           onChanged: (value) {
//             context
//                 .read<Setting18ControlBloc>()
//                 .add(DSVVA3Changed(value.toStringAsFixed(1)));
//           },
//         );
//       },
//     );
//   }
// }

// class _DSVVA4 extends StatelessWidget {
//   const _DSVVA4({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
//       builder: (context, state) {
//         return controlParameterSlider(
//           context: context,
//           editMode: state.editMode,
//           title: 'DS VVA4: ${state.dsVVA4} dB',
//           minValue: 0.0,
//           maxValue: 15.0,
//           currentValue: _getValue(state.dsVVA4),
//           onChanged: (value) {
//             context
//                 .read<Setting18ControlBloc>()
//                 .add(DSVVA4Changed(value.toStringAsFixed(1)));
//           },
//         );
//       },
//     );
//   }
// }

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
  });

  final String partId;

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

    bool getEditable(FormStatus loadingStatus) {
      if (loadingStatus.isRequestSuccess) {
        return true;
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
      final Setting18ControlState setting18ListViewState =
          context.watch<Setting18ControlBloc>().state;

      bool editable = getEditable(homeState.loadingStatus);
      return editable
          ? getEditTools(
              editMode: setting18ListViewState.editMode,
              enableSubmission: setting18ListViewState.enableSubmission,
            )
          : Container();
    });
  }
}
