import 'package:dsim_app/core/custom_icons/custom_icons_icons.dart';
import 'package:dsim_app/core/custom_style.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:dsim_app/setting/bloc/setting18_list_view_bloc/setting18_list_view_bloc.dart';
import 'package:dsim_app/setting/bloc/setting_bloc/setting_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18ControlView extends StatelessWidget {
  Setting18ControlView({super.key});

  final TextEditingController minTemperatureTextEditingController =
      TextEditingController();
  final TextEditingController maxTemperatureTextEditingController =
      TextEditingController();
  final TextEditingController minVoltageTextEditingController =
      TextEditingController();
  final TextEditingController maxVoltageTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<Setting18ListViewBloc, Setting18ListViewState>(
      listener: (context, state) {},
      child: BlocBuilder<SettingBloc, SettingState>(
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(
                    CustomStyle.sizeXL,
                  ),
                  child: Column(
                    children: [
                      _ControlTitle(
                        title: AppLocalizations.of(context)
                            .forwardControlParameters,
                      ),
                      const _FwdInputAttenuation(),
                      const _FwdInputEQ(),
                      const SizedBox(
                        height: 20,
                      ),
                      _ControlTitle(
                        title: AppLocalizations.of(context)
                            .returnControlParameters,
                      ),
                      const _RtnInputAttenuation2(),
                      const _RtnInputAttenuation3(),
                      const _RtnInputAttenuation4(),
                      const _RtnOutputLevelAttenuation(),
                      const _RtnOutputEQ(),
                      const _RtnIngressSetting2(),
                      const _RtnIngressSetting3(),
                      const _RtnIngressSetting4(),
                      const SizedBox(
                        height: 120,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: _SettingFloatingActionButton(),
          );
        },
      ),
    );
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
        SliderTheme(
          data: const SliderThemeData(
            valueIndicatorColor: Colors.red,
            showValueIndicator: ShowValueIndicator.always,
          ),
          child: Slider(
            min: 0.0,
            max: 15.0,
            divisions: 150,
            value: currentValue,
            onChanged: editMode ? onChanged : null,
            // onChangeEnd: state.editMode
            //     ? (attenuation) {
            //         print(attenuation);
            //       }
            //     : null,
          ),
        ),
      ],
    ),
  );
}

class _ControlTitle extends StatelessWidget {
  const _ControlTitle({super.key, required this.title});

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
    return BlocBuilder<Setting18ListViewBloc, Setting18ListViewState>(
      builder: (context, state) {
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context).fwdInputAttenuation}: ${state.fwdInputAttenuation.toStringAsFixed(1)} dB',
          minValue: 0.0,
          maxValue: 15.0,
          currentValue: state.fwdInputAttenuation,
          onChanged: (fwdInputAttenuation) {
            context
                .read<Setting18ListViewBloc>()
                .add(FwdInputAttenuationChanged(fwdInputAttenuation));
          },
        );
      },
    );
  }
}

class _FwdInputEQ extends StatelessWidget {
  const _FwdInputEQ({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ListViewBloc, Setting18ListViewState>(
      builder: (context, state) {
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context).fwdInputEQ}: ${state.fwdInputEQ.toStringAsFixed(1)} dB',
          minValue: 0.0,
          maxValue: 15.0,
          currentValue: state.fwdInputEQ,
          onChanged: (fwdInputEQ) {
            context
                .read<Setting18ListViewBloc>()
                .add(FwdInputEQChanged(fwdInputEQ));
          },
        );
      },
    );
  }
}

class _RtnInputAttenuation2 extends StatelessWidget {
  const _RtnInputAttenuation2({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ListViewBloc, Setting18ListViewState>(
      builder: (context, state) {
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context).rtnInputAttenuation2}: ${state.rtnInputAttenuation2.toStringAsFixed(1)} dB',
          minValue: 0.0,
          maxValue: 15.0,
          currentValue: state.rtnInputAttenuation2,
          onChanged: (rtnInputAttenuation) {
            context
                .read<Setting18ListViewBloc>()
                .add(RtnInputAttenuation2Changed(rtnInputAttenuation));
          },
        );
      },
    );
  }
}

class _RtnInputAttenuation3 extends StatelessWidget {
  const _RtnInputAttenuation3({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ListViewBloc, Setting18ListViewState>(
      builder: (context, state) {
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context).rtnInputAttenuation3}: ${state.rtnInputAttenuation3.toStringAsFixed(1)} dB',
          minValue: 0.0,
          maxValue: 15.0,
          currentValue: state.rtnInputAttenuation3,
          onChanged: (rtnInputAttenuation) {
            context
                .read<Setting18ListViewBloc>()
                .add(RtnInputAttenuation3Changed(rtnInputAttenuation));
          },
        );
      },
    );
  }
}

class _RtnInputAttenuation4 extends StatelessWidget {
  const _RtnInputAttenuation4({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ListViewBloc, Setting18ListViewState>(
      builder: (context, state) {
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context).rtnInputAttenuation4}: ${state.rtnInputAttenuation4.toStringAsFixed(1)} dB',
          minValue: 0.0,
          maxValue: 15.0,
          currentValue: state.rtnInputAttenuation4,
          onChanged: (rtnInputAttenuation) {
            context
                .read<Setting18ListViewBloc>()
                .add(RtnInputAttenuation4Changed(rtnInputAttenuation));
          },
        );
      },
    );
  }
}

class _RtnOutputLevelAttenuation extends StatelessWidget {
  const _RtnOutputLevelAttenuation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ListViewBloc, Setting18ListViewState>(
      builder: (context, state) {
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context).rtnOutputLevelAttenuation}: ${state.rtnOutputLevelAttenuation.toStringAsFixed(1)} dB',
          minValue: 0.0,
          maxValue: 15.0,
          currentValue: state.rtnOutputLevelAttenuation,
          onChanged: (rtnInputAttenuation) {
            context
                .read<Setting18ListViewBloc>()
                .add(RtnOutputLevelAttenuationChanged(rtnInputAttenuation));
          },
        );
      },
    );
  }
}

class _RtnOutputEQ extends StatelessWidget {
  const _RtnOutputEQ({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ListViewBloc, Setting18ListViewState>(
      builder: (context, state) {
        return controlParameterSlider(
          context: context,
          editMode: state.editMode,
          title:
              '${AppLocalizations.of(context).rtnOutputEQ}: ${state.rtnOutputEQ.toStringAsFixed(1)} dB',
          minValue: 0.0,
          maxValue: 15.0,
          currentValue: state.rtnOutputEQ,
          onChanged: (rtnOutputEQ) {
            context
                .read<Setting18ListViewBloc>()
                .add(RtnOutputEQChanged(rtnOutputEQ));
          },
        );
      },
    );
  }
}

class _RtnIngressSetting2 extends StatelessWidget {
  const _RtnIngressSetting2({
    super.key,
  });

  final List<String> rtnIngressTexts = const [
    '0',
    '-3',
    '-6',
    'Open',
  ];

  List<bool> _getSelectionState(String selectedrtnIngress) {
    Map<String, bool> selectedrtnIngressMap = {
      '0': false,
      '-3': false,
      '-6': false,
      'Open': false,
    };

    if (selectedrtnIngressMap.containsKey(selectedrtnIngress)) {
      selectedrtnIngressMap[selectedrtnIngress] = true;
    }

    return selectedrtnIngressMap.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ListViewBloc, Setting18ListViewState>(
      buildWhen: (previous, current) =>
          previous.rtnIngressSetting2 != current.rtnIngressSetting2 ||
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
                  '${AppLocalizations.of(context).rtnIngressSetting2}:',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) => ToggleButtons(
                  direction: Axis.horizontal,
                  onPressed: (int index) {
                    if (state.editMode) {
                      context.read<Setting18ListViewBloc>().add(
                          RtnIngressSetting2Changed(rtnIngressTexts[index]));
                    }
                  },
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
                    width: (constraints.maxWidth - 6) / rtnIngressTexts.length,
                  ),
                  isSelected: _getSelectionState(state.rtnIngressSetting2),
                  children: <Widget>[
                    for (String text in rtnIngressTexts) ...[Text(text)],
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

class _RtnIngressSetting3 extends StatelessWidget {
  const _RtnIngressSetting3({
    super.key,
  });

  final List<String> rtnIngressTexts = const [
    '0',
    '-3',
    '-6',
    'Open',
  ];

  List<bool> _getSelectionState(String selectedrtnIngress) {
    Map<String, bool> selectedrtnIngressMap = {
      '0': false,
      '-3': false,
      '-6': false,
      'Open': false,
    };

    if (selectedrtnIngressMap.containsKey(selectedrtnIngress)) {
      selectedrtnIngressMap[selectedrtnIngress] = true;
    }

    return selectedrtnIngressMap.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ListViewBloc, Setting18ListViewState>(
      buildWhen: (previous, current) =>
          previous.rtnIngressSetting3 != current.rtnIngressSetting3 ||
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
                  '${AppLocalizations.of(context).rtnIngressSetting3}:',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) => ToggleButtons(
                  direction: Axis.horizontal,
                  onPressed: (int index) {
                    if (state.editMode) {
                      context.read<Setting18ListViewBloc>().add(
                          RtnIngressSetting3Changed(rtnIngressTexts[index]));
                    }
                  },
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
                    width: (constraints.maxWidth - 6) / rtnIngressTexts.length,
                  ),
                  isSelected: _getSelectionState(state.rtnIngressSetting3),
                  children: <Widget>[
                    for (String text in rtnIngressTexts) ...[Text(text)],
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

class _RtnIngressSetting4 extends StatelessWidget {
  const _RtnIngressSetting4({
    super.key,
  });

  final List<String> rtnIngressTexts = const [
    '0',
    '-3',
    '-6',
    'Open',
  ];

  List<bool> _getSelectionState(String selectedrtnIngress) {
    Map<String, bool> selectedrtnIngressMap = {
      '0': false,
      '-3': false,
      '-6': false,
      'Open': false,
    };

    if (selectedrtnIngressMap.containsKey(selectedrtnIngress)) {
      selectedrtnIngressMap[selectedrtnIngress] = true;
    }

    return selectedrtnIngressMap.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ListViewBloc, Setting18ListViewState>(
      buildWhen: (previous, current) =>
          previous.rtnIngressSetting4 != current.rtnIngressSetting4 ||
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
                  '${AppLocalizations.of(context).rtnIngressSetting4}:',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) => ToggleButtons(
                  direction: Axis.horizontal,
                  onPressed: (int index) {
                    if (state.editMode) {
                      context.read<Setting18ListViewBloc>().add(
                          RtnIngressSetting4Changed(rtnIngressTexts[index]));
                    }
                  },
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
                    width: (constraints.maxWidth - 6) / rtnIngressTexts.length,
                  ),
                  isSelected: _getSelectionState(state.rtnIngressSetting4),
                  children: <Widget>[
                    for (String text in rtnIngressTexts) ...[Text(text)],
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

// class _FwdInputAttenuation extends StatelessWidget {
//   const _FwdInputAttenuation({
//     super.key,
//     required this.textEditingController,
//   });

//   final TextEditingController textEditingController;

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<Setting18ListViewBloc, Setting18ListViewState>(
//       builder: (context, state) {
//         return Padding(
//           padding: const EdgeInsets.only(
//             bottom: 40.0,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(
//                   bottom: 16.0,
//                 ),
//                 child: Text(
//                   '${AppLocalizations.of(context).fwdInputAttenuation}:',
//                   style: const TextStyle(
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//               TextField(
//                 controller: textEditingController,
//                 key: const Key(
//                     'setting18Form_fwdInputAttenuationInput_textField'),
//                 style: const TextStyle(
//                   fontSize: CustomStyle.sizeXL,
//                 ),
//                 enabled: state.editMode,
//                 textInputAction: TextInputAction.done,
//                 onChanged: (location) {
//                   // context
//                   //     .read<Setting18ListViewBloc>()
//                   //     .add(LocationChanged(location));
//                 },
//                 maxLength: 40,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(4.0))),
//                   contentPadding: EdgeInsets.all(10.0),
//                   isDense: true,
//                   filled: true,
//                   fillColor: Colors.white,
//                   counterText: '',
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class _FwdInputEQ extends StatelessWidget {
//   const _FwdInputEQ({
//     super.key,
//     required this.textEditingController,
//   });

//   final TextEditingController textEditingController;

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<Setting18ListViewBloc, Setting18ListViewState>(
//       builder: (context, state) {
//         return Padding(
//           padding: const EdgeInsets.only(
//             bottom: 40.0,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(
//                   bottom: 16.0,
//                 ),
//                 child: Text(
//                   '${AppLocalizations.of(context).fwdInputEQ}:',
//                   style: const TextStyle(
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//               TextField(
//                 controller: textEditingController,
//                 key: const Key('setting18Form_fwdInputEQInput_textField'),
//                 style: const TextStyle(
//                   fontSize: CustomStyle.sizeXL,
//                 ),
//                 enabled: state.editMode,
//                 textInputAction: TextInputAction.done,
//                 onChanged: (location) {
//                   // context
//                   //     .read<Setting18ListViewBloc>()
//                   //     .add(LocationChanged(location));
//                 },
//                 maxLength: 40,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(4.0))),
//                   contentPadding: EdgeInsets.all(10.0),
//                   isDense: true,
//                   filled: true,
//                   fillColor: Colors.white,
//                   counterText: '',
//                 ),
//               ),
//             ],
//           ),
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
                        .read<Setting18ListViewBloc>()
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
                          // context
                          //     .read<SettingListViewBloc>()
                          //     .add(const SettingSubmitted());
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
                        .read<Setting18ListViewBloc>()
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
      final Setting18ListViewState setting18ListViewState =
          context.watch<Setting18ListViewBloc>().state;

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
