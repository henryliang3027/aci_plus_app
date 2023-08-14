import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dsim_app/core/custom_icons/custom_icons_icons.dart';
import 'package:dsim_app/core/custom_style.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:dsim_app/setting/bloc/setting18_list_view_bloc/setting18_list_view_bloc.dart';
import 'package:dsim_app/setting/bloc/setting_bloc/setting_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18ConfigureView extends StatelessWidget {
  Setting18ConfigureView({super.key});

  final TextEditingController
      firstChannelLoadingFrequencyTextEditingController =
      TextEditingController();
  final TextEditingController firstChannelLoadingLevelTextEditingController =
      TextEditingController();
  final TextEditingController lastChannelLoadingFrequencyTextEditingController =
      TextEditingController();
  final TextEditingController lastChannelLoadingLevelTextEditingController =
      TextEditingController();
  final TextEditingController pilotFrequency1TextEditingController =
      TextEditingController();
  final TextEditingController pilotFrequency2TextEditingController =
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
                      const _SplitOptionDropDownMenu(),
                      _FirstChannelLoadingFrequency(
                        textEditingController:
                            firstChannelLoadingFrequencyTextEditingController,
                      ),
                      _FirstChannelLoadingLevel(
                        textEditingController:
                            firstChannelLoadingLevelTextEditingController,
                      ),
                      _LastChannelLoadingFrequency(
                        textEditingController:
                            lastChannelLoadingFrequencyTextEditingController,
                      ),
                      _LastChannelLoadingLevel(
                        textEditingController:
                            lastChannelLoadingLevelTextEditingController,
                      ),
                      const _PilotFrequencyMode(),
                      _PilotFrequency1(
                        textEditingController:
                            pilotFrequency1TextEditingController,
                      ),
                      _PilotFrequency2(
                        textEditingController:
                            pilotFrequency2TextEditingController,
                      ),
                      const _FwdAGCMode(),
                      const _AutoLevelControl(),
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

class _SplitOptionDropDownMenu extends StatelessWidget {
  const _SplitOptionDropDownMenu({super.key});

  final Map<String, String> types = const {
    '204/258': '1',
    '396/492': '2',
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ListViewBloc, Setting18ListViewState>(
        buildWhen: (previous, current) =>
            previous.splitOption != current.splitOption ||
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
                    '${AppLocalizations.of(context).splitOption}:',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton2<String?>(
                      buttonHeight: 40,
                      buttonDecoration: BoxDecoration(
                        border: Border.all(
                          color: state.editMode
                              ? Colors.grey.shade700
                              : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                        color: Colors.white,
                      ),
                      dropdownMaxHeight: 200,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      value: state.splitOption == '' ? null : state.splitOption,
                      items: [
                        for (String k in types.keys)
                          DropdownMenuItem(
                            value: types[k],
                            child: Text(
                              k,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: CustomStyle.sizeXL,
                                fontWeight: FontWeight.normal,
                                color:
                                    state.editMode ? Colors.black : Colors.grey,
                              ),
                            ),
                          )
                      ],
                      onChanged: state.editMode
                          ? (String? value) {
                              if (value != null) {
                                // context
                                //     .read<SettingListViewBloc>()
                                //     .add(LogIntervalChanged(value));
                              }
                            }
                          : null),
                ),
              ],
            ),
          );
        });
  }
}

class _FirstChannelLoadingFrequency extends StatelessWidget {
  const _FirstChannelLoadingFrequency({
    super.key,
    required this.textEditingController,
  });

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ListViewBloc, Setting18ListViewState>(
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
                  '${AppLocalizations.of(context).firstChannelLoading} ${AppLocalizations.of(context).frequency}:',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextField(
                controller: textEditingController,
                key: const Key(
                    'setting18Form_firstLoadingFrequencyInput_textField'),
                style: const TextStyle(
                  fontSize: CustomStyle.sizeXL,
                ),
                enabled: state.editMode,
                textInputAction: TextInputAction.done,
                onChanged: (location) {
                  // context
                  //     .read<Setting18ListViewBloc>()
                  //     .add(LocationChanged(location));
                },
                maxLength: 40,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  contentPadding: EdgeInsets.all(10.0),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  counterText: '',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FirstChannelLoadingLevel extends StatelessWidget {
  const _FirstChannelLoadingLevel({
    super.key,
    required this.textEditingController,
  });

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ListViewBloc, Setting18ListViewState>(
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
                  '${AppLocalizations.of(context).firstChannelLoading} ${AppLocalizations.of(context).level}:',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextField(
                controller: textEditingController,
                key:
                    const Key('setting18Form_firstLoadingLevelInput_textField'),
                style: const TextStyle(
                  fontSize: CustomStyle.sizeXL,
                ),
                enabled: state.editMode,
                textInputAction: TextInputAction.done,
                onChanged: (location) {
                  // context
                  //     .read<Setting18ListViewBloc>()
                  //     .add(LocationChanged(location));
                },
                maxLength: 40,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  contentPadding: EdgeInsets.all(10.0),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  counterText: '',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LastChannelLoadingFrequency extends StatelessWidget {
  const _LastChannelLoadingFrequency({
    super.key,
    required this.textEditingController,
  });

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ListViewBloc, Setting18ListViewState>(
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
                  '${AppLocalizations.of(context).lastChannelLoading} ${AppLocalizations.of(context).frequency}:',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextField(
                controller: textEditingController,
                key: const Key(
                    'setting18Form_lastLoadingFrequencyInput_textField'),
                style: const TextStyle(
                  fontSize: CustomStyle.sizeXL,
                ),
                enabled: state.editMode,
                textInputAction: TextInputAction.done,
                onChanged: (location) {
                  // context
                  //     .read<Setting18ListViewBloc>()
                  //     .add(LocationChanged(location));
                },
                maxLength: 40,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  contentPadding: EdgeInsets.all(10.0),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  counterText: '',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LastChannelLoadingLevel extends StatelessWidget {
  const _LastChannelLoadingLevel({
    super.key,
    required this.textEditingController,
  });

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ListViewBloc, Setting18ListViewState>(
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
                  '${AppLocalizations.of(context).lastChannelLoading} ${AppLocalizations.of(context).level}:',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextField(
                controller: textEditingController,
                key: const Key('setting18Form_lastLoadingLevelInput_textField'),
                style: const TextStyle(
                  fontSize: CustomStyle.sizeXL,
                ),
                enabled: state.editMode,
                textInputAction: TextInputAction.done,
                onChanged: (location) {
                  // context
                  //     .read<Setting18ListViewBloc>()
                  //     .add(LocationChanged(location));
                },
                maxLength: 40,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  contentPadding: EdgeInsets.all(10.0),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  counterText: '',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PilotFrequencyMode extends StatelessWidget {
  const _PilotFrequencyMode({
    super.key,
  });

  final List<String> pilotFrequencyModeTexts = const [
    'Auto',
    'Manual',
    'Test',
  ];

  List<bool> _getSelectionState(String selectedPilotFrequencyMode) {
    Map<String, bool> pilotFrequencyModeMap = {
      'Auto': false,
      'Manual': false,
      'Test': false,
    };

    if (pilotFrequencyModeMap.containsKey(selectedPilotFrequencyMode)) {
      pilotFrequencyModeMap[selectedPilotFrequencyMode] = true;
    }

    return pilotFrequencyModeMap.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ListViewBloc, Setting18ListViewState>(
      buildWhen: (previous, current) =>
          previous.pilotFrequencyMode != current.pilotFrequencyMode ||
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
                  '${AppLocalizations.of(context).pilotFrequencySelect}:',
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
                          PilotFrequencyModeChanged(
                              pilotFrequencyModeTexts[index]));
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
                    width: (constraints.maxWidth - 4) /
                        pilotFrequencyModeTexts.length,
                  ),
                  isSelected: _getSelectionState(state.pilotFrequencyMode),
                  children: <Widget>[
                    for (String text in pilotFrequencyModeTexts) ...[
                      Text(text)
                    ],
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

class _PilotFrequency1 extends StatelessWidget {
  const _PilotFrequency1({
    super.key,
    required this.textEditingController,
  });

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ListViewBloc, Setting18ListViewState>(
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
                  '${AppLocalizations.of(context).pilotFrequency1}:',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextField(
                controller: textEditingController,
                key: const Key('setting18Form_pilotFrequency1Input_textField'),
                style: const TextStyle(
                  fontSize: CustomStyle.sizeXL,
                ),
                enabled: state.editMode,
                textInputAction: TextInputAction.done,
                onChanged: (location) {
                  // context
                  //     .read<Setting18ListViewBloc>()
                  //     .add(LocationChanged(location));
                },
                maxLength: 40,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  contentPadding: EdgeInsets.all(10.0),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  counterText: '',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PilotFrequency2 extends StatelessWidget {
  const _PilotFrequency2({
    super.key,
    required this.textEditingController,
  });

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ListViewBloc, Setting18ListViewState>(
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
                  '${AppLocalizations.of(context).pilotFrequency2}:',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextField(
                controller: textEditingController,
                key: const Key('setting18Form_pilotFrequency2Input_textField'),
                style: const TextStyle(
                  fontSize: CustomStyle.sizeXL,
                ),
                enabled: state.editMode,
                textInputAction: TextInputAction.done,
                onChanged: (location) {
                  // context
                  //     .read<Setting18ListViewBloc>()
                  //     .add(LocationChanged(location));
                },
                maxLength: 40,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  contentPadding: EdgeInsets.all(10.0),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  counterText: '',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FwdAGCMode extends StatelessWidget {
  const _FwdAGCMode({
    super.key,
  });

  final List<String> fwdAGCModeTexts = const [
    'ON',
    'OFF',
  ];

  List<bool> _getSelectionState(String selectedFwdAGCMode) {
    Map<String, bool> fwdAGCModeMap = {
      'ON': false,
      'OFF': false,
    };

    if (fwdAGCModeMap.containsKey(selectedFwdAGCMode)) {
      fwdAGCModeMap[selectedFwdAGCMode] = true;
    }

    return fwdAGCModeMap.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ListViewBloc, Setting18ListViewState>(
      buildWhen: (previous, current) =>
          previous.fwdAGCMode != current.fwdAGCMode ||
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
                  '${AppLocalizations.of(context).fwdAGCMode}:',
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
                      context
                          .read<Setting18ListViewBloc>()
                          .add(FwdAGCModeChanged(fwdAGCModeTexts[index]));
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
                    width: (constraints.maxWidth - 4) / fwdAGCModeTexts.length,
                  ),
                  isSelected: _getSelectionState(state.fwdAGCMode),
                  children: <Widget>[
                    for (String text in fwdAGCModeTexts) ...[Text(text)],
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

class _AutoLevelControl extends StatelessWidget {
  const _AutoLevelControl({
    super.key,
  });

  final List<String> autoLevelControlTexts = const [
    'ON',
    'OFF',
  ];

  List<bool> _getSelectionState(String selectedAutoLevelControl) {
    Map<String, bool> autoLevelControlMap = {
      'ON': false,
      'OFF': false,
    };

    if (autoLevelControlMap.containsKey(selectedAutoLevelControl)) {
      autoLevelControlMap[selectedAutoLevelControl] = true;
    }

    return autoLevelControlMap.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ListViewBloc, Setting18ListViewState>(
      buildWhen: (previous, current) =>
          previous.autoLevelControl != current.autoLevelControl ||
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
                  '${AppLocalizations.of(context).autoLevelControl}:',
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
                          AutoLevelControlChanged(
                              autoLevelControlTexts[index]));
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
                    width: (constraints.maxWidth - 4) /
                        autoLevelControlTexts.length,
                  ),
                  isSelected: _getSelectionState(state.autoLevelControl),
                  children: <Widget>[
                    for (String text in autoLevelControlTexts) ...[Text(text)],
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
