import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dsim_app/core/custom_icons/custom_icons_icons.dart';
import 'package:dsim_app/core/custom_style.dart';
import 'package:dsim_app/setting/bloc/setting_bloc/setting_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingListView extends StatelessWidget {
  SettingListView({
    super.key,
    required this.locationTextEditionController,
    required this.userPilotTextEditingController,
    required this.userPilot2TextEditingController,
  });

  final TextEditingController locationTextEditionController;
  final TextEditingController userPilotTextEditingController;
  final TextEditingController userPilot2TextEditingController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(
              CustomStyle.sizeXL,
            ),
            child: Column(
              children: [
                _Location(
                  textEditingController: locationTextEditionController,
                ),
                const _TGCCabelLength(),
                const _LogIntervalDropDownMenu(),
                const _WorkingMode(),
                _UserPilot(
                  textEditingController: userPilotTextEditingController,
                ),
                _UserPilot2(
                  textEditingController: userPilot2TextEditingController,
                ),
                const _AGCPrepAttenator(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: const _SettingFloatingActionButton(),
    );
  }
}

class _SettingFloatingActionButton extends StatelessWidget {
  const _SettingFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
        builder: (context, state) => state.editMode
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
                      context.read<SettingBloc>().add(const EditModeDisabled());
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  FloatingActionButton(
                    shape: const CircleBorder(
                      side: BorderSide.none,
                    ),
                    backgroundColor: state.enableSubmission
                        ? Theme.of(context).colorScheme.primary.withAlpha(200)
                        : Colors.grey.withAlpha(200),
                    onPressed: state.enableSubmission
                        ? () {
                            context
                                .read<SettingBloc>()
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
            : FloatingActionButton(
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
                  context.read<SettingBloc>().add(const EditModeEnabled());
                },
              ));
  }
}

class _Location extends StatelessWidget {
  const _Location({
    super.key,
    required this.textEditingController,
  });

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
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
                  AppLocalizations.of(context).location,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextField(
                keyboardType: TextInputType.visiblePassword, // 限制只能輸入英文與標點符號
                controller: textEditingController,
                key: const Key('settingForm_locationInput_textField'),
                style: const TextStyle(
                  fontSize: CustomStyle.sizeXL,
                ),
                enabled: state.editMode,
                textInputAction: TextInputAction.done,
                onChanged: (location) {
                  context.read<SettingBloc>().add(LocationChanged(location));
                },
                maxLength: 40,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  contentPadding: EdgeInsets.all(10.0),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TGCCabelLength extends StatelessWidget {
  const _TGCCabelLength({
    super.key,
  });

  final List<String> tgcCableLengthTexts = const [
    '9',
    '18',
    '27',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      buildWhen: (previous, current) =>
          previous.selectedTGCCableLength != current.selectedTGCCableLength ||
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
                  AppLocalizations.of(context).tgcCableLength,
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
                      context.read<SettingBloc>().add(
                          TGCCableLengthChanged(tgcCableLengthTexts[index]));
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
                          3), //number 2 is number of toggle buttons
                  isSelected: state.selectedTGCCableLength.values.toList(),
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

class _LogIntervalDropDownMenu extends StatelessWidget {
  const _LogIntervalDropDownMenu({super.key});

  final Map<String, int> types = const {
    '1 min.- 4 hours': 1,
    '2 min.- 8 hours': 2,
    '3 min.- 12 hours': 3,
    '5 min.- 21 hours': 5,
    '10 min.- 1 day': 10,
    '15 min.- 2 days': 15,
    '30 min.- 5 days': 30,
    '1 hr.- 10 days': 60,
    '2 hrs.- 20 days': 120,
    '3 hrs.- 30 days': 180,
    '4 hrs.- 40 days': 240,
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
        buildWhen: (previous, current) =>
            previous.logIntervalId != current.logIntervalId ||
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
                    AppLocalizations.of(context).logInterval,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton2(
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
                      value: state.logIntervalId,
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
                          ? (int? value) {
                              if (value != null) {
                                context
                                    .read<SettingBloc>()
                                    .add(LogIntervalChanged(value));
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

class _WorkingMode extends StatelessWidget {
  const _WorkingMode({
    super.key,
  });

  final List<String> workingModeTexts = const [
    'MGC',
    'AGC',
    'TGC',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      buildWhen: (previous, current) =>
          previous.selectedWorkingMode != current.selectedWorkingMode ||
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
                  AppLocalizations.of(context).workingMode,
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
                          .read<SettingBloc>()
                          .add(WorkingModeChanged(workingModeTexts[index]));
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
                    width: (constraints.maxWidth - 4) / 3,
                  ),
                  isSelected: state.selectedWorkingMode.values.toList(),
                  children: const <Widget>[
                    Text('MGC'),
                    Text('AGC'),
                    Text('TGC'),
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

class _UserPilot extends StatelessWidget {
  const _UserPilot({
    super.key,
    required this.textEditingController,
  });

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
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
                child: Row(
                  children: [
                    Text(
                      '${AppLocalizations.of(context).userPilot}: ',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${state.pilotChannel} ${state.pilotMode}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              TextField(
                controller: textEditingController,
                key: const Key('settingForm_userPilotInput_textField'),
                style: const TextStyle(
                  fontSize: CustomStyle.sizeXL,
                ),
                enabled: state.editMode,
                textInputAction: TextInputAction.done,
                onChanged: (pilotCode) => context
                    .read<SettingBloc>()
                    .add(PilotCodeChanged(pilotCode)),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  contentPadding: const EdgeInsets.all(10.0),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: AppLocalizations.of(context).userPilot,
                  labelStyle: TextStyle(
                    fontSize: CustomStyle.sizeL,
                    color: Colors.grey.shade400,
                  ),
                  suffixIconConstraints: const BoxConstraints(
                      maxHeight: 30, maxWidth: 30, minHeight: 30, minWidth: 30),
                  suffixIcon: IconButton(
                    iconSize: 22,
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 12.0, 0.0),
                    icon: const Icon(Icons.search_outlined),
                    onPressed: () {
                      context
                          .read<SettingBloc>()
                          .add(const PilotChannelSearched());
                    },
                  ),
                  errorMaxLines: 2,
                  errorStyle: const TextStyle(fontSize: CustomStyle.sizeS),
                  errorText: state.pilotCode.isNotValid
                      ? AppLocalizations.of(context).pilotCodeFormatError
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _UserPilot2 extends StatelessWidget {
  const _UserPilot2({
    super.key,
    required this.textEditingController,
  });

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, state) {
        return state.hasDualPilot
            ? Padding(
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
                      child: Row(
                        children: [
                          Text(
                            '${AppLocalizations.of(context).userPilot2}: ',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${state.pilot2Channel} ${state.pilot2Mode}',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      controller: textEditingController,
                      key: const Key('settingForm_userPilotInput_textField'),
                      style: const TextStyle(
                        fontSize: CustomStyle.sizeXL,
                      ),
                      enabled: state.editMode,
                      textInputAction: TextInputAction.done,
                      onChanged: (pilotCode) => context
                          .read<SettingBloc>()
                          .add(Pilot2CodeChanged(pilotCode)),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0))),
                        contentPadding: const EdgeInsets.all(10.0),
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        labelText: AppLocalizations.of(context).userPilot,
                        labelStyle: TextStyle(
                          fontSize: CustomStyle.sizeL,
                          color: Colors.grey.shade400,
                        ),
                        suffixIconConstraints: const BoxConstraints(
                            maxHeight: 30,
                            maxWidth: 30,
                            minHeight: 30,
                            minWidth: 30),
                        suffixIcon: IconButton(
                          iconSize: 22,
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 12.0, 0.0),
                          icon: const Icon(Icons.search_outlined),
                          onPressed: () {
                            context
                                .read<SettingBloc>()
                                .add(const Pilot2ChannelSearched());
                          },
                        ),
                        errorMaxLines: 2,
                        errorStyle:
                            const TextStyle(fontSize: CustomStyle.sizeS),
                        errorText: state.pilot2Code.isNotValid
                            ? AppLocalizations.of(context).pilotCodeFormatError
                            : null,
                      ),
                    ),
                  ],
                ),
              )
            : Container();
      },
    );
  }
}

class _AGCPrepAttenator extends StatelessWidget {
  const _AGCPrepAttenator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 200.0,
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
                    Text(
                      '${AppLocalizations.of(context).agcPrepAttenuator}: ',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      state.currentAttenuation.toString(),
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
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
                  min: state.minAttenuation.toDouble(),
                  max: state.maxAttenuation.toDouble(),
                  divisions:
                      ((state.maxAttenuation - state.minAttenuation) ~/ 50)
                          .toInt(),
                  value: state.currentAttenuation.toDouble(),
                  onChanged: state.editMode
                      ? (attenuation) {
                          context.read<SettingBloc>().add(
                              AGCPrepAttenuationChanged(attenuation.toInt()));
                        }
                      : null,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton.filled(
                    icon: const Icon(
                      Icons.remove,
                    ),
                    onPressed: state.editMode
                        ? () {
                            context
                                .read<SettingBloc>()
                                .add(const AGCPrepAttenuationDecreased());
                          }
                        : null,
                  ),
                  IconButton.filled(
                    icon: const Icon(
                      Icons.circle_outlined,
                    ),
                    onPressed: state.editMode
                        ? () {
                            context
                                .read<SettingBloc>()
                                .add(const AGCPrepAttenuationCentered());
                          }
                        : null,
                  ),
                  IconButton.filled(
                    icon: const Icon(
                      Icons.add,
                    ),
                    onPressed: state.editMode
                        ? () {
                            context
                                .read<SettingBloc>()
                                .add(const AGCPrepAttenuationIncreased());
                          }
                        : null,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
