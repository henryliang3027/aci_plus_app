import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dsim_app/core/command.dart';
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
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.connectionStatus.isRequestSuccess) {
          context.read<SettingBloc>().add(AllItemInitialized(
                state.characteristicData[DataKey.location] ?? '',
                state.characteristicData[DataKey.tgcCableLength] ?? '',
                state.characteristicData[DataKey.dsimMode] ?? '',
                int.parse(state.characteristicData[DataKey.logInterval] ?? '1'),
                state.characteristicData[DataKey.currentPilot] ?? '',
              ));

          _locationTextEditingController.text =
              state.characteristicData[DataKey.location] ?? '';

          _userPilotTextEditingController.text = PilotChannel.channelCode[
                  state.characteristicData[DataKey.currentPilot] ?? ''] ??
              '';
        }

        return SafeArea(
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
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
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
              textInputAction: TextInputAction.done,
              onChanged: (location) {
                context.read<SettingBloc>().add(LocationChanged(location));
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                contentPadding: const EdgeInsets.all(10.0),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                labelText: AppLocalizations.of(context).location,
                labelStyle: TextStyle(
                  fontSize: CustomStyle.sizeL,
                  color: Colors.grey.shade400,
                ),
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
    double getWidth() {
      double padding = WidgetsBinding.instance.window.padding.right == 0
          ? 40 // portrait orientation padding
          : WidgetsBinding.instance.window.padding.right;
      return (MediaQuery.of(context).size.width - padding) / 3;
    }

    return BlocBuilder<SettingBloc, SettingState>(
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
            ToggleButtons(
              direction: Axis.horizontal,
              onPressed: (int index) {
                print(tgcCableLengthTexts[index]);
                context
                    .read<SettingBloc>()
                    .add(TGCCableLengthChanged(tgcCableLengthTexts[index]));
              },
              textStyle: const TextStyle(fontSize: 18.0),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: Colors.blue[700],
              selectedColor: Colors.white,
              fillColor: Colors.blue[200],
              color: Colors.black54,
              constraints: BoxConstraints(
                minHeight: 40.0,
                minWidth: getWidth(),
              ),
              isSelected: state.selectedTGCCableLength.values.toList(),
              children: const <Widget>[
                Text('9'),
                Text('18'),
                Text('27'),
              ],
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
    return BlocBuilder<SettingBloc, SettingState>(builder: (context, state) {
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
                    color: Colors.grey.shade700,
                  ),
                  borderRadius: BorderRadius.circular(4.0),
                  color: Colors.white,
                ),
                dropdownMaxHeight: 200,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down),
                iconDisabledColor: Colors.grey.shade700,
                value: state.logIntervalId,
                items: [
                  for (String k in types.keys)
                    DropdownMenuItem(
                      value: types[k],
                      child: Text(
                        k,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: CustomStyle.sizeXL,
                          color: Colors.black,
                        ),
                      ),
                    )
                ],
                onChanged: (int? value) {
                  if (value != null) {
                    context.read<SettingBloc>().add(LogIntervalChanged(value));
                  }
                }),
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
    double getWidth() {
      double padding = WidgetsBinding.instance.window.padding.right == 0
          ? 40 // portrait orientation padding
          : WidgetsBinding.instance.window.padding.right;
      return (MediaQuery.of(context).size.width - padding) / 3;
    }

    return BlocBuilder<SettingBloc, SettingState>(
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
            ToggleButtons(
              direction: Axis.horizontal,
              onPressed: (int index) {
                print(workingModeTexts[index]);
                context
                    .read<SettingBloc>()
                    .add(WorkingModeChanged(workingModeTexts[index]));
              },
              textStyle: const TextStyle(fontSize: 18.0),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: Colors.blue[700],
              selectedColor: Colors.white,
              fillColor: Colors.blue[200],
              color: Colors.black54,
              constraints: BoxConstraints(
                minHeight: 40.0,
                minWidth: getWidth(),
              ),
              isSelected: state.selectedWorkingMode.values.toList(),
              children: const <Widget>[
                Text('MGC'),
                Text('AGC'),
                Text('TGC'),
              ],
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
                    state.pilotChannel,
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
