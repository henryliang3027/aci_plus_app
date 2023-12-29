import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/setting/model/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            bottom: CustomStyle.sizeL,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: CustomStyle.sizeXL,
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
                      '${(List.from([
                            minValue,
                            maxValue
                          ])[index]).toStringAsFixed(0)}',
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
            min: minValue,
            max: maxValue,
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

Widget controlToggleButton({
  required BuildContext context,
  required bool editMode,
  required String title,
  required String currentValue,
  required ValueChanged<int> onChanged,
  required List<String> values,
  required List<String> texts,
}) {
  List<bool> getSelectionState(String selectedValue) {
    Map<String, bool> selectedValueMap = {};
    for (String value in values) {
      selectedValueMap[value] = false;
    }

    if (selectedValueMap.containsKey(selectedValue)) {
      selectedValueMap[selectedValue] = true;
    }

    return selectedValueMap.values.toList();
  }

  return Padding(
    padding: const EdgeInsets.only(
      bottom: CustomStyle.size4XL,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: CustomStyle.sizeL,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: CustomStyle.sizeXL,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => ToggleButtons(
            direction: Axis.horizontal,
            onPressed: editMode ? onChanged : (index) {},
            textStyle: const TextStyle(
              fontSize: CustomStyle.sizeL,
            ),
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
              width: (constraints.maxWidth - 6) / values.length,
            ),
            isSelected: getSelectionState(currentValue),
            children: <Widget>[
              for (String text in texts) ...[Text(text)],
            ],
          ),
        ),
      ],
    ),
  );
}

Widget twoTextField({
  required BuildContext context,
  required String title,
  required bool editMode1,
  required bool editMode2,
  required String textEditingControllerName1,
  required String textEditingControllerName2,
  required TextEditingController textEditingController1,
  required TextEditingController textEditingController2,
  required ValueChanged onChanged1,
  required ValueChanged onChanged2,
  String? errorText1,
  String? errorText2,
}) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(
          bottom: CustomStyle.sizeL,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: CustomStyle.sizeXL,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
          bottom: CustomStyle.sizeL,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 2,
              child: TextField(
                controller: textEditingController1,
                key: Key(textEditingControllerName1),
                style: const TextStyle(
                  fontSize: CustomStyle.sizeXL,
                ),
                enabled: editMode1,
                textInputAction: TextInputAction.done,
                onChanged: onChanged1,
                maxLength: 40,
                decoration: InputDecoration(
                  label: Text(
                      '${AppLocalizations.of(context)!.frequency} (${CustomStyle.mHz})'),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  contentPadding: const EdgeInsets.all(8.0),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  counterText: '',
                  errorMaxLines: 2,
                  errorStyle: const TextStyle(fontSize: CustomStyle.sizeS),
                  errorText: errorText1,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Flexible(
              flex: 2,
              child: TextField(
                controller: textEditingController2,
                key: Key(textEditingControllerName2),
                style: const TextStyle(
                  fontSize: CustomStyle.sizeXL,
                ),
                enabled: editMode2,
                textInputAction: TextInputAction.done,
                onChanged: onChanged2,
                maxLength: 40,
                decoration: InputDecoration(
                  label: Text(
                      '${AppLocalizations.of(context)!.level} (${CustomStyle.dBmV})'),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  contentPadding: const EdgeInsets.all(8.0),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  counterText: '',
                  errorMaxLines: 2,
                  errorStyle: const TextStyle(fontSize: CustomStyle.sizeS),
                  errorText: errorText2,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 20,
      ),
    ],
  );
}

Widget thresholdAlarmParameterWidget({
  required BuildContext context,
  required String minValueTextEditingControllerName,
  required String maxValueTextEditingControllerName,
  required TextEditingController minValueTextEditingController,
  required TextEditingController maxValueTextEditingController,
  required bool editMode,
  required String title,
  required String minValueLabel,
  required String maxValueLabel,
  required bool enabledAlarmState,
  required ValueChanged<bool> onChangedAlarmState,
  required ValueChanged<String> onChangedMinValue,
  required ValueChanged<String> onChangedMaxValue,
  String? minValueErrorText,
  String? maxValueErrorText,
}) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(
          bottom: CustomStyle.sizeL,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 3,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: CustomStyle.sizeXL,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Flexible(
              child: Switch(
                thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return const Icon(Icons.check);
                    }
                    return const Icon(Icons.close);
                  },
                ),
                value: enabledAlarmState,
                onChanged: editMode ? onChangedAlarmState : null,
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
          bottom: CustomStyle.sizeL,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 2,
              child: TextField(
                controller: minValueTextEditingController,
                key: Key(minValueTextEditingControllerName),
                style: const TextStyle(
                  fontSize: CustomStyle.sizeXL,
                ),
                enabled: editMode,
                textInputAction: TextInputAction.done,
                onChanged: onChangedMinValue,
                maxLength: 40,
                decoration: InputDecoration(
                  label: Text(minValueLabel),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  contentPadding: const EdgeInsets.all(8.0),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  counterText: '',
                  errorMaxLines: 2,
                  errorStyle: const TextStyle(fontSize: CustomStyle.sizeS),
                  errorText: minValueErrorText,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Flexible(
              flex: 2,
              child: TextField(
                controller: maxValueTextEditingController,
                key: Key(maxValueTextEditingControllerName),
                style: const TextStyle(
                  fontSize: CustomStyle.sizeXL,
                ),
                enabled: editMode,
                textInputAction: TextInputAction.done,
                onChanged: onChangedMaxValue,
                maxLength: 40,
                decoration: InputDecoration(
                  label: Text(maxValueLabel),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  contentPadding: const EdgeInsets.all(8.0),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  counterText: '',
                  errorMaxLines: 2,
                  errorStyle: const TextStyle(fontSize: CustomStyle.sizeS),
                  errorText: maxValueErrorText,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 20,
      ),
    ],
  );
}

Widget thresholdAlarmSwitch({
  required BuildContext context,
  required bool editMode,
  required String title,
  required bool value,
  required ValueChanged<bool> onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.only(
      bottom: CustomStyle.sizeL,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 2,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: CustomStyle.sizeXL,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Flexible(
          child: Switch(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return const Icon(Icons.check);
                }
                return const Icon(Icons.close);
              },
            ),
            value: value,
            onChanged: editMode ? onChanged : null,
          ),
        ),
      ],
    ),
  );
}

// List<Record>
// Record, a new variable type of Dart 3
const List<(int?, int?)> splitBaseLine = [
  (null, null), // 0
  (204, 258), // 1
  (300, 372), // 2
  (396, 492), // 3
  (492, 606), // 4
  (684, 834), // 5
];

const List<String> splitOptionValues = [
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
];

bool isValidFirstChannelLoadingFrequency({
  required int currentDetectedSplitOption,
  required IntegerInput firstChannelLoadingFrequency,
}) {
  int? forwardStartFrequency = splitBaseLine[currentDetectedSplitOption].$2;
  if (firstChannelLoadingFrequency.isNotValid) {
    return false;
  } else {
    if (forwardStartFrequency == null) {
      return true;
    } else {
      int intFirstChannelLoadingFrequency =
          int.parse(firstChannelLoadingFrequency.value);
      return intFirstChannelLoadingFrequency >= forwardStartFrequency
          ? true
          : false;
    }
  }
}

Color getNullBackgroundColor({
  required BuildContext context,
  required String value,
  required int index,
}) {
  String strIndex = index.toString();
  return strIndex == value
      ? CustomStyle.customRed
      : Theme.of(context).colorScheme.onPrimary;
}

Color getNullBorderColor({
  required BuildContext context,
  required String value,
  required int index,
}) {
  String strIndex = index.toString();
  return strIndex == value ? CustomStyle.customRed : Colors.grey;
}

Color getBackgroundColor({
  required BuildContext context,
  required String value,
  required int index,
}) {
  String strIndex = index.toString();

  return strIndex == value
      ? Theme.of(context).colorScheme.primary
      : Theme.of(context).colorScheme.onPrimary;
}

Color getBorderColor({
  required BuildContext context,
  required String value,
  required int index,
}) {
  String strIndex = index.toString();

  return strIndex == value
      ? Theme.of(context).colorScheme.primary
      : Colors.grey;
}

Color getForegroundColor({
  required BuildContext context,
  required String value,
  required int index,
}) {
  String strIndex = index.toString();
  return strIndex == value
      ? Theme.of(context).colorScheme.onPrimary
      : Colors.grey;
}

Color getDisabledNullBackgroundColor({
  required BuildContext context,
  required String value,
  required int index,
}) {
  String strIndex = index.toString();

  return strIndex == value
      ? const Color.fromARGB(255, 215, 82, 95)
      : Theme.of(context).colorScheme.onPrimary;
}

Color getDisabledBackgroundColor({
  required BuildContext context,
  required String value,
  required int index,
}) {
  String strIndex = index.toString();

  return strIndex == value
      ? Theme.of(context).colorScheme.inversePrimary
      : Theme.of(context).colorScheme.onPrimary;
}

Color getDisabledBorderColor() {
  return Colors.grey;
}
