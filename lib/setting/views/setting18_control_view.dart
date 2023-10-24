import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/custom_icons/custom_icons.dart';
import 'package:dsim_app/core/custom_style.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/core/setting_items_table.dart';
import 'package:dsim_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:dsim_app/setting/bloc/setting18_control/setting18_control_bloc.dart';
import 'package:dsim_app/setting/views/custom_setting_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18ControlView extends StatelessWidget {
  const Setting18ControlView({super.key});

  @override
  Widget build(BuildContext context) {
    HomeState homeState = context.watch<HomeBloc>().state;
    String partId = homeState.characteristicData[DataKey.partId] ?? '';
    String inputAttenuation =
        homeState.characteristicData[DataKey.inputAttenuation] ?? '';
    String inputEqualizer =
        homeState.characteristicData[DataKey.inputEqualizer] ?? '';
    String inputAttenuation2 =
        homeState.characteristicData[DataKey.inputAttenuation2] ?? '';
    String inputAttenuation3 =
        homeState.characteristicData[DataKey.inputAttenuation3] ?? '';
    String inputAttenuation4 =
        homeState.characteristicData[DataKey.inputAttenuation4] ?? '';
    String outputAttenuation =
        homeState.characteristicData[DataKey.outputAttenuation] ?? '';
    String outputEqualizer =
        homeState.characteristicData[DataKey.outputEqualizer] ?? '';
    String ingressSetting2 =
        homeState.characteristicData[DataKey.ingressSetting2] ?? '';
    String ingressSetting3 =
        homeState.characteristicData[DataKey.ingressSetting3] ?? '';
    String ingressSetting4 =
        homeState.characteristicData[DataKey.ingressSetting4] ?? '';
    String tgcCableLength =
        homeState.characteristicData[DataKey.tgcCableLength] ?? '';
    String dsVVA2 = homeState.characteristicData[DataKey.dsVVA2] ?? '';
    String dsSlope2 = homeState.characteristicData[DataKey.dsSlope2] ?? '';
    String dsVVA3 = homeState.characteristicData[DataKey.dsVVA3] ?? '';
    String dsVVA4 = homeState.characteristicData[DataKey.dsVVA4] ?? '';
    String usTGC = homeState.characteristicData[DataKey.usTGC] ?? '';

    context.read<Setting18ControlBloc>().add(Initialized(
          fwdInputAttenuation: inputAttenuation,
          fwdInputEQ: inputEqualizer,
          rtnInputAttenuation2: inputAttenuation2,
          rtnInputAttenuation3: inputAttenuation3,
          rtnInputAttenuation4: inputAttenuation4,
          rtnOutputLevelAttenuation: outputAttenuation,
          rtnOutputEQ: outputEqualizer,
          rtnIngressSetting2: ingressSetting2,
          rtnIngressSetting3: ingressSetting3,
          rtnIngressSetting4: ingressSetting4,
          tgcCableLength: tgcCableLength,
          dsVVA2: dsVVA2,
          dsSlope2: dsSlope2,
          dsVVA3: dsVVA3,
          dsVVA4: dsVVA4,
          usTGC: usTGC,
        ));

    String formatResultValue(String boolValue) {
      return boolValue == 'true'
          ? AppLocalizations.of(context).dialogMessageSuccessful
          : AppLocalizations.of(context).dialogMessageFailed;
    }

    String formatResultItem(String item) {
      if (item == DataKey.inputAttenuation.name) {
        return AppLocalizations.of(context)
            .dialogMessageForwardInputAttenuationSetting;
      } else if (item == DataKey.inputEqualizer.name) {
        return AppLocalizations.of(context)
            .dialogMessageForwardInputEqualizerSetting;
      } else if (item == DataKey.inputAttenuation2.name) {
        return AppLocalizations.of(context)
            .dialogMessageReturnInputAttenuation2Setting;
      } else if (item == DataKey.inputAttenuation3.name) {
        return AppLocalizations.of(context)
            .dialogMessageReturnInputAttenuation3Setting;
      } else if (item == DataKey.inputAttenuation4.name) {
        return AppLocalizations.of(context)
            .dialogMessageReturnInputAttenuation4Setting;
      } else if (item == DataKey.outputAttenuation.name) {
        return AppLocalizations.of(context)
            .dialogMessageReturnOutputAttenuationSetting;
      } else if (item == DataKey.outputEqualizer.name) {
        return AppLocalizations.of(context)
            .dialogMessageReturnOutputEqualizerSetting;
      } else if (item == DataKey.ingressSetting2.name) {
        return AppLocalizations.of(context).dialogMessageReturnIngress2Setting;
      } else if (item == DataKey.ingressSetting3.name) {
        return AppLocalizations.of(context).dialogMessageReturnIngress3Setting;
      } else if (item == DataKey.ingressSetting4.name) {
        return AppLocalizations.of(context).dialogMessageReturnIngress4Setting;
      } else if (item == DataKey.tgcCableLength.name) {
        return AppLocalizations.of(context).dialogMessageTGCCableLengthSetting;
      } else if (item == DataKey.dsVVA2.name) {
        return AppLocalizations.of(context).dialogMessageDSVVA2Setting;
      } else if (item == DataKey.dsSlope2.name) {
        return AppLocalizations.of(context).dialogMessageDSSlope2Setting;
      } else if (item == DataKey.dsVVA3.name) {
        return AppLocalizations.of(context).dialogMessageDSVVA3Setting;
      } else if (item == DataKey.dsVVA4.name) {
        return AppLocalizations.of(context).dialogMessageDSVVA4Setting;
      } else if (item == DataKey.usTGC.name) {
        return AppLocalizations.of(context).dialogMessageUSTGCSetting;
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
              const _FwdInputAttenuation(),
            );
            break;
          case SettingControl.forwardInputEqualizer:
            widgets.add(
              const _FwdInputEQ(),
            );
            break;
        }
      }

      return widgets.isNotEmpty
          ? widgets
          : [
              const _FwdInputAttenuation(),
              const _FwdInputEQ(),
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
          case SettingControl.returnInputAttenuation2and3:
            break;
          case SettingControl.returnInputAttenuation5and6:
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
          case SettingControl.returnIngressSetting5:
            break;
          case SettingControl.returnIngressSetting6:
            break;
          case SettingControl.returnIngressSetting2_3:
            break;
          case SettingControl.returnIngressSetting5_6:
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
                title: AppLocalizations.of(context).forwardControlParameters,
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
                title: AppLocalizations.of(context).returnControlParameters,
              )
            : Container(),
        ...returnControlParameters,
        // const _TGCCableLength(),
        // const _DSVVA2(),
        // const _DSSlope2(),
        // const _DSVVA3(),
        // const _DSVVA4(),
        // const _USTGC(),
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
        floatingActionButton: const _SettingFloatingActionButton(),
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

Widget controlParameterSlider({
  required BuildContext context,
  required bool editMode,
  required String title,
  required double minValue,
  required double currentValue,
  required double maxValue,
  required ValueChanged<double> onChanged,
  required VoidCallback onIncreased,
  required VoidCallback onDecreased,
}) {
  return Padding(
    padding: const EdgeInsets.only(
      bottom: 30.0,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 16.0,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              2,
              (index) => Column(
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: 22,
                    child: Text(
                      '${(List.from([0, 15])[index]).toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: CustomStyle.sizeM,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: 16,
                    child: VerticalDivider(
                      indent: 0,
                      thickness: 1.2,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliderTheme(
          data: const SliderThemeData(
            valueIndicatorColor: Colors.red,
            showValueIndicator: ShowValueIndicator.always,
            overlayShape: RoundSliderOverlayShape(overlayRadius: 18),
          ),
          child: Slider(
            min: 0.0,
            max: 15.0,
            divisions: 150,
            value: currentValue,
            onChanged: editMode ? onChanged : null,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton.filled(
              visualDensity: const VisualDensity(horizontal: -4.0),
              icon: const Icon(
                Icons.remove,
              ),
              onPressed: editMode ? onDecreased : null,
            ),
            IconButton.filled(
              visualDensity: const VisualDensity(horizontal: -4.0),
              icon: const Icon(
                Icons.add,
              ),
              onPressed: editMode ? onIncreased : null,
            ),
          ],
        ),
      ],
    ),
  );
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

Widget controlToggleButton({
  required BuildContext context,
  required bool editMode,
  required String title,
  required String currentValue,
  required ValueChanged<int> onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.only(
      bottom: 40.0,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 16.0,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => ToggleButtons(
            direction: Axis.horizontal,
            onPressed: editMode ? onChanged : (index) {},
            textStyle: const TextStyle(fontSize: 18.0),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            selectedBorderColor: editMode
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context)
                    .colorScheme
                    .inversePrimary, // indigo border color
            selectedColor:
                Theme.of(context).colorScheme.onPrimary, // white text color

            fillColor: editMode
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.inversePrimary, // selected
            color: Theme.of(context).colorScheme.secondary, // not selected
            constraints: BoxConstraints.expand(
              width: (constraints.maxWidth - 6) / rtnIngressValues.length,
            ),
            isSelected: getSelectionState(currentValue),
            children: <Widget>[
              const Text('0'),
              const Text('-3'),
              const Text('-6'),
              Text(AppLocalizations.of(context).ingressOpen),
            ],
          ),
        ),
      ],
    ),
  );
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
  const _FwdInputAttenuation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context).fwdInputAttenuation}: ${state.fwdInputAttenuation} dB',
          minValue: 0.0,
          maxValue: 15.0,
          currentValue: _getValue(state.fwdInputAttenuation),
          onChanged: (fwdInputAttenuation) {
            context.read<Setting18ControlBloc>().add(FwdInputAttenuationChanged(
                fwdInputAttenuation.toStringAsFixed(1)));
          },
          onDecreased: () => context
              .read<Setting18ControlBloc>()
              .add(const FwdInputAttenuationDecreased()),
          onIncreased: () => context
              .read<Setting18ControlBloc>()
              .add(const FwdInputAttenuationIncreased()),
        );
      },
    );
  }
}

class _FwdInputEQ extends StatelessWidget {
  const _FwdInputEQ({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      builder: (context, state) {
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context).fwdInputEQ}: ${state.fwdInputEQ} dB',
          minValue: 0.0,
          maxValue: 15.0,
          currentValue: _getValue(state.fwdInputEQ),
          onChanged: (fwdInputEQ) {
            context
                .read<Setting18ControlBloc>()
                .add(FwdInputEQChanged(fwdInputEQ.toStringAsFixed(1)));
          },
          onDecreased: () => context
              .read<Setting18ControlBloc>()
              .add(const FwdInputEQDecreased()),
          onIncreased: () => context
              .read<Setting18ControlBloc>()
              .add(const FwdInputEQIncreased()),
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
              '${AppLocalizations.of(context).rtnInputAttenuation2}: ${state.rtnInputAttenuation2} dB',
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
              '${AppLocalizations.of(context).rtnInputAttenuation3}: ${state.rtnInputAttenuation3} dB',
          minValue: 0.0,
          maxValue: 15.0,
          currentValue: _getValue(state.rtnInputAttenuation3),
          onChanged: (rtnInputAttenuation) {
            context.read<Setting18ControlBloc>().add(
                RtnInputAttenuation3Changed(
                    rtnInputAttenuation.toStringAsFixed(1)));
          },
          onDecreased: () => context
              .read<Setting18ControlBloc>()
              .add(const RtnInputAttenuation3Decreased()),
          onIncreased: () => context
              .read<Setting18ControlBloc>()
              .add(const RtnInputAttenuation3Increased()),
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
              '${AppLocalizations.of(context).rtnInputAttenuation4}: ${state.rtnInputAttenuation4} dB',
          minValue: 0.0,
          maxValue: 15.0,
          currentValue: _getValue(state.rtnInputAttenuation4),
          onChanged: (rtnInputAttenuation) {
            context.read<Setting18ControlBloc>().add(
                RtnInputAttenuation4Changed(
                    rtnInputAttenuation.toStringAsFixed(1)));
          },
          onDecreased: () => context
              .read<Setting18ControlBloc>()
              .add(const RtnInputAttenuation4Decreased()),
          onIncreased: () => context
              .read<Setting18ControlBloc>()
              .add(const RtnInputAttenuation4Increased()),
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
              '${AppLocalizations.of(context).rtnOutputLevelAttenuation}: ${state.rtnOutputLevelAttenuation} dB',
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
              '${AppLocalizations.of(context).rtnOutputEQ}: ${state.rtnOutputEQ} dB',
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
          title: '${AppLocalizations.of(context).rtnIngressSetting2}:',
          currentValue: state.rtnIngressSetting2,
          onChanged: (int index) {
            context
                .read<Setting18ControlBloc>()
                .add(RtnIngressSetting2Changed(rtnIngressValues[index]));
          },
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
          title: '${AppLocalizations.of(context).rtnIngressSetting3}:',
          currentValue: state.rtnIngressSetting3,
          onChanged: (int index) {
            context
                .read<Setting18ControlBloc>()
                .add(RtnIngressSetting3Changed(rtnIngressValues[index]));
          },
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
          title: '${AppLocalizations.of(context).rtnIngressSetting4}:',
          currentValue: state.rtnIngressSetting4,
          onChanged: (int index) {
            context
                .read<Setting18ControlBloc>()
                .add(RtnIngressSetting4Changed(rtnIngressValues[index]));
          },
        );
      },
    );
  }
}

class _TGCCableLength extends StatelessWidget {
  const _TGCCableLength({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<String> tgcCableLengthValues = const [
      '9',
      '18',
      '27',
    ];

    List<bool> getTGCCableLengthSelectionState(String selectedTGCCableLength) {
      Map<String, bool> selectedTGCCableLengthMap = {
        '9': false,
        '18': false,
        '27': false,
      };

      if (selectedTGCCableLengthMap.containsKey(selectedTGCCableLength)) {
        selectedTGCCableLengthMap[selectedTGCCableLength] = true;
      }

      return selectedTGCCableLengthMap.values.toList();
    }

    return BlocBuilder<Setting18ControlBloc, Setting18ControlState>(
      buildWhen: (previous, current) =>
          previous.tgcCableLength != current.tgcCableLength ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 40.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                ),
                child: Text(
                  '${AppLocalizations.of(context).tgcCableLength}:',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) => ToggleButtons(
                  direction: Axis.horizontal,
                  onPressed: state.editMode
                      ? (int index) {
                          context.read<Setting18ControlBloc>().add(
                              TGCCableLengthChanged(
                                  tgcCableLengthValues[index]));
                        }
                      : (index) {},
                  textStyle: const TextStyle(fontSize: 18.0),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: state.editMode
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context)
                          .colorScheme
                          .inversePrimary, // indigo border color
                  selectedColor: Theme.of(context)
                      .colorScheme
                      .onPrimary, // white text color

                  fillColor: state.editMode
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context)
                          .colorScheme
                          .inversePrimary, // selected
                  color:
                      Theme.of(context).colorScheme.secondary, // not selected
                  constraints: BoxConstraints.expand(
                    width: (constraints.maxWidth - 4) /
                        tgcCableLengthValues.length,
                  ),
                  isSelected:
                      getTGCCableLengthSelectionState(state.tgcCableLength),
                  children: const <Widget>[
                    Text('9'),
                    Text('18'),
                    Text('27'),
                  ],
                ),
              ),
            ],
          ),
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
  const _SettingFloatingActionButton({super.key});

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
                      ? () {
                          context
                              .read<Setting18ControlBloc>()
                              .add(const SettingSubmitted());
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
