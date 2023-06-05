import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/custom_style.dart';
import 'package:dsim_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:dsim_app/setting/bloc/setting_bloc/setting_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingListView extends StatelessWidget {
  SettingListView({super.key});

  final TextEditingController _locationTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                children: [
                  _Location(
                    initialValue:
                        state.characteristicData[DataKey.location] ?? '',
                    textEditingController: _locationTextEditingController
                      ..text = state.characteristicData[DataKey.location] ?? '',
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  _TGCCabelLength(
                    initialValue:
                        state.characteristicData[DataKey.tgcCableLength] ?? '',
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  _LogIntervalDropDownMenu(),
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
    this.initialValue = '',
    required this.textEditingController,
  });

  final String initialValue;
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
              style: const TextStyle(fontSize: 16.0),
              textInputAction: TextInputAction.done,
              onChanged: (location) =>
                  context.read<SettingBloc>().add(LocationChanged(location)),
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                contentPadding: const EdgeInsets.all(8.0),
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
    required this.initialValue,
  });

  final String initialValue;
  final List<Widget> tgcCableLength = const <Widget>[
    Text('9'),
    Text('18'),
    Text('27'),
  ];

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

    List<bool> getSelectionList(Map<String, bool> currentMap) {
      int initialIndex = tgcCableLengthTexts.indexOf(initialValue);
      List<bool> selectedList = [
        false,
        false,
        false,
      ];

      // 如果沒有選擇任何選項的情況下, 就讀取初始值
      if (!currentMap.values.contains(true)) {
        if (initialIndex > -1) {
          selectedList[initialIndex] = true;
          return selectedList;
        } else {
          return selectedList;
        }
      } else {
        // 反之, 就讀取目前選擇的選項
        String currentTGC = currentMap.keys
            .firstWhere((k) => currentMap[k] == true, orElse: () => '');

        // 如果目前也沒有選任何選項, 就回傳全部 false
        if (currentTGC == '') {
          return selectedList;
        } else {
          int selectedIndex = tgcCableLengthTexts.indexOf(currentTGC);
          selectedList[selectedIndex] = true;

          return selectedList;
        }
      }
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
              isSelected: getSelectionList(state.selectedTGCCableLength),
              children: tgcCableLength,
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
                buttonHeight: 32,
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
                          fontSize: CustomStyle.sizeL,
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
