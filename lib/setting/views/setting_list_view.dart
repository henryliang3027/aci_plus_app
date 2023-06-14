import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/custom_icons/custom_icons_icons.dart';
import 'package:dsim_app/core/custom_style.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/core/pilot_channel.dart';
import 'package:dsim_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:dsim_app/setting/bloc/setting_bloc/setting_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingListView extends StatelessWidget {
  SettingListView({super.key});

  final TextEditingController _locationTextEditingController =
      TextEditingController();

  final TextEditingController _userPilotTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> _showInProgressDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context).dialogTitleProcessing,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: const <Widget>[
              CircularProgressIndicator(),
            ],
          );
        },
      );
    }

    Future<void> _showSuccessDialog(
      String msg,
    ) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context).dialogTitleSuccess,
              style: const TextStyle(color: CustomStyle.customGreen),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    msg,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // pop dialog
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> _showFailureDialog(String msg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context).dialogTitleError,
              style: const TextStyle(
                color: CustomStyle.customRed,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    msg,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // pop dialog
                },
              ),
            ],
          );
        },
      );
    }

    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        bool editMode = context.read<SettingBloc>().state.editMode;

        if (editMode) {
          _showSuccessDialog('test');
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.connectionStatus.isRequestSuccess) {
            context.read<SettingBloc>().add(AllItemInitialized(
                  location: state.characteristicData[DataKey.location] ?? '',
                  tgcCableLength:
                      state.characteristicData[DataKey.tgcCableLength] ?? '',
                  workingMode: state.characteristicData[DataKey.dsimMode] ?? '',
                  logIntervalId: int.parse(
                      state.characteristicData[DataKey.logInterval] ?? '1'),
                  pilotChannel:
                      state.characteristicData[DataKey.currentPilot] ?? '',
                  pilotMode:
                      state.characteristicData[DataKey.currentPilotMode] ?? '',
                  maxAttenuation:
                      state.characteristicData[DataKey.maxAttenuation] ?? '',
                  minAttenuation:
                      state.characteristicData[DataKey.minAttenuation] ?? '',
                  currentAttenuation:
                      state.characteristicData[DataKey.currentAttenuation] ??
                          '',
                  centerAttenuation:
                      state.characteristicData[DataKey.centerAttenuation] ?? '',
                ));

            _locationTextEditingController.text =
                state.characteristicData[DataKey.location] ?? '';

            _userPilotTextEditingController.text = PilotChannel.channelCode[
                    state.characteristicData[DataKey.currentPilot] ?? ''] ??
                '';
          }

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
                        textEditingController: _locationTextEditingController,
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      const _TGCCabelLength(),
                      const SizedBox(
                        height: 40.0,
                      ),
                      const _LogIntervalDropDownMenu(),
                      const SizedBox(
                        height: 40.0,
                      ),
                      const _WorkingMode(),
                      const SizedBox(
                        height: 40.0,
                      ),
                      _UserPilot(
                        textEditingController: _userPilotTextEditingController,
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      const _AGCPrepAttenator(),
                      const SizedBox(
                        height: 160.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: const _SettingFloatingActionButton(),
          );
        },
      ),
    );
  }
}

class _SettingFloatingActionButton extends StatelessWidget {
  const _SettingFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
        buildWhen: (previous, current) => previous.editMode != current.editMode,
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
                      context.read<SettingBloc>().add(const EditModeChanged());
                    },
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
                      Icons.check,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      context.read<SettingBloc>().add(const SettingSubmitted());
                    },
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
                  context.read<SettingBloc>().add(const EditModeChanged());
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
      buildWhen: (previous, current) =>
          previous.location != current.location ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return Column(
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
        return Column(
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
                    context
                        .read<SettingBloc>()
                        .add(TGCCableLengthChanged(tgcCableLengthTexts[index]));
                  }
                },
                textStyle: const TextStyle(fontSize: 18.0),
                borderRadius: const BorderRadius.all(Radius.circular(8)),

                selectedBorderColor: state.editMode
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context)
                        .colorScheme
                        .inversePrimary, // indigo border color
                selectedColor:
                    Theme.of(context).colorScheme.onPrimary, // white text color

                fillColor: state.editMode
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.inversePrimary, // selected
                color: Theme.of(context).colorScheme.secondary, // not selected
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
          return Column(
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
                        color:
                            state.editMode ? Colors.grey.shade700 : Colors.grey,
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
        return Column(
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
                selectedColor:
                    Theme.of(context).colorScheme.onPrimary, // white text color

                fillColor: state.editMode
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.inversePrimary, // selected
                color: Theme.of(context).colorScheme.secondary, // not selected
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 16.0,
              ),
              child: Row(
                children: [
                  Text(
                    '${AppLocalizations.of(context).userPilot}:',
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
              onChanged: (pilotCode) =>
                  context.read<SettingBloc>().add(PilotCodeChanged(pilotCode)),
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
              ),
            ),
          ],
        );
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 16.0,
              ),
              child: Row(
                children: [
                  Text(
                    '${AppLocalizations.of(context).agcPrepAttenuator}:',
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
                divisions: ((state.maxAttenuation - state.minAttenuation) ~/ 50)
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
        );
      },
    );
  }
}
