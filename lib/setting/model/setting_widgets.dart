import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/setting/model/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';

double _getBondaryValue({
  required String value,
  required double minValue,
  required double maxValue,
}) {
  if (value.isNotEmpty) {
    double currentValue = double.parse(value).clamp(minValue, maxValue);
    return currentValue;
  } else {
    return minValue;
  }
}

class FineTuneSlider extends StatefulWidget {
  const FineTuneSlider({
    super.key,
    required this.initialValue,
    required this.minValue,
    required this.maxValue,
    required this.interval,
    required this.step,
    required this.enabled,
    required this.onChanged,
  });

  final double initialValue;
  final double minValue;
  final double maxValue;
  final int interval;
  final int step;
  final bool enabled;
  final ValueChanged<double> onChanged;

  @override
  State<FineTuneSlider> createState() => _FineTuneSliderState();
}

class _FineTuneSliderState extends State<FineTuneSlider> {
  late double _value;

  @override
  void initState() {
    _value = widget.initialValue;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FineTuneSlider oldWidget) {
    if (oldWidget.initialValue != widget.initialValue) {
      setState(() {
        _value = widget.initialValue;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  void _increaseValue() {
    setState(() {
      _value = _value + widget.step <= widget.maxValue
          ? _value + widget.step
          : _value;
    });
  }

  void _decreasedValue() {
    setState(() {
      _value = _value - widget.step >= widget.minValue
          ? _value - widget.step
          : _value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 6.0, 0.0),
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
                            widget.minValue,
                            widget.maxValue,
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
            min: widget.minValue,
            max: widget.maxValue,
            divisions: (widget.maxValue - widget.minValue) ~/ widget.interval,
            value: _value,
            onChanged: widget.enabled
                ? (double value) {
                    setState(() {
                      _value = value;
                    });
                    widget.onChanged(_value);
                  }
                : null,
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
              onPressed: widget.enabled
                  ? () {
                      _decreasedValue();
                      widget.onChanged(_value);
                    }
                  : null,
            ),
            IconButton.filled(
              visualDensity: const VisualDensity(horizontal: -4.0),
              icon: const Icon(
                Icons.add,
              ),
              onPressed: widget.enabled
                  ? () {
                      _increaseValue();
                      widget.onChanged(_value);
                    }
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}

class FineTuneTextSlider extends StatefulWidget {
  const FineTuneTextSlider({
    super.key,
    required this.initialValue,
    required this.minValue,
    required this.maxValue,
    required this.step,
    required this.enabled,
    required this.onChanged,
  });

  final String initialValue;
  final double minValue;
  final double maxValue;
  final double step;
  final bool enabled;
  final ValueChanged<String> onChanged;

  @override
  State<FineTuneTextSlider> createState() => _FineTuneTextSliderState();
}

class _FineTuneTextSliderState extends State<FineTuneTextSlider> {
  late double _value;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _value = _getBondaryValue(
      value: widget.initialValue,
      minValue: widget.minValue,
      maxValue: widget.maxValue,
    );

    _textEditingController = TextEditingController()
      ..text = widget.initialValue;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FineTuneTextSlider oldWidget) {
    if (oldWidget.initialValue != widget.initialValue) {
      setState(() {
        _value = _getBondaryValue(
          value: widget.initialValue,
          minValue: widget.minValue,
          maxValue: widget.maxValue,
        );

        _textEditingController.text = widget.initialValue;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  void _increaseValue() {
    setState(() {
      _value = _value + widget.step <= widget.maxValue
          ? _value + widget.step
          : _value;

      _textEditingController.text = _value.toString();
    });
  }

  void _decreasedValue() {
    setState(() {
      _value = _value - widget.step >= widget.minValue
          ? _value - widget.step
          : _value;

      _textEditingController.text = _value.toString();
    });
  }

  _adjustTextFieldValue({
    required String value,
  }) {
    if (value.isNotEmpty) {
      double doubleCurrentValue = double.parse(value);
      if (doubleCurrentValue > widget.maxValue) {
        _textEditingController.text = widget.maxValue.toStringAsFixed(1);
      } else if (doubleCurrentValue < widget.minValue) {
        _textEditingController.text = widget.minValue.toStringAsFixed(1);
      } else {
        // 維持目前 value;
      }
    } else {
      _textEditingController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 6.0, 0.0),
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
                            widget.minValue,
                            widget.maxValue,
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
            min: widget.minValue,
            max: widget.maxValue,
            divisions: (widget.maxValue - widget.minValue) ~/ widget.step,
            value: _value,
            onChanged: widget.enabled
                ? (double value) {
                    setState(() {
                      _value = value;
                    });
                    widget.onChanged(_value.toString());
                  }
                : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: IconButton.filled(
                  visualDensity: const VisualDensity(horizontal: -4.0),
                  icon: const Icon(
                    Icons.remove,
                  ),
                  onPressed: widget.enabled
                      ? () {
                          _decreasedValue();
                          widget.onChanged(_value.toString());
                        }
                      : null,
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0.0,
                  ),
                  child: TextField(
                    controller: _textEditingController,
                    // key: Key(textEditingControllerName1),
                    style: const TextStyle(
                      fontSize: CustomStyle.sizeXXL,
                    ),
                    textAlign: TextAlign.center,
                    enabled: widget.enabled,
                    textInputAction: TextInputAction.done,
                    onChanged: (value) {
                      _adjustTextFieldValue(value: value);
                      widget.onChanged(_textEditingController.text);
                    },
                    maxLength: 40,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      // ^：表示從起始開始匹配第一個符合的數字
                      // \d{1,2}：\d 表示匹配任何一個數字。{1,2} 表示前面的數字字符必須出現 1 次或 2 次
                      // (\.\d?)?：匹配一個小數點後跟著 0 到 1 位數字
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d{1,2}(\.\d?)?'))
                    ],
                    decoration: const InputDecoration(
                      // label: Text(
                      //     '${AppLocalizations.of(context)!.frequency} (${CustomStyle.mHz})'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0))),
                      contentPadding: EdgeInsets.all(8.0),
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      counterText: '',
                      errorMaxLines: 2,
                      errorStyle: TextStyle(fontSize: CustomStyle.sizeS),
                      // errorText: editMode1 ? errorText1 : null,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: IconButton.filled(
                  visualDensity: const VisualDensity(horizontal: -4.0),
                  icon: const Icon(
                    Icons.add,
                  ),
                  onPressed: widget.enabled
                      ? () {
                          _increaseValue();
                          widget.onChanged(_value.toString());
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget configurationIntervalSlider({
  required BuildContext context,
  required bool editMode,
  required String title,
  required double minValue,
  required String currentValue,
  required double maxValue,
  required int interval,
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
            bottom: CustomStyle.sizeL,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '$title: $currentValue ${AppLocalizations.of(context)!.minute}',
                  style: const TextStyle(
                    fontSize: CustomStyle.sizeXL,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        FineTuneSlider(
          initialValue: _getBondaryValue(
            value: currentValue,
            minValue: minValue,
            maxValue: maxValue,
          ),
          minValue: minValue,
          maxValue: maxValue,
          interval: interval,
          step: interval,
          enabled: editMode,
          onChanged: onChanged,
        )
      ],
    ),
  );
}

Widget controlTextSlider({
  required BuildContext context,
  required bool editMode,
  required String title,
  required double minValue,
  required String currentValue,
  required double maxValue,
  required ValueChanged<String> onChanged,
  double step = 0.5,
}) {
  // textEditingController.text = currentValue;
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
        FineTuneTextSlider(
          initialValue: currentValue,
          minValue: minValue,
          maxValue: maxValue,
          step: step,
          enabled: editMode,
          onChanged: onChanged,
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
  bool reaOnly1 = false,
  bool reaOnly2 = false,
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
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                enabled: editMode1,
                readOnly: reaOnly1,
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
                  errorText: editMode1 ? errorText1 : null,
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
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                enabled: editMode2,
                readOnly: reaOnly2,
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
                  errorText: editMode2 ? errorText2 : null,
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

Widget splitOptionGridViewButton({
  required BuildContext context,
  required bool editMode,
  required String splitOption,
  required ValueChanged onGridPressed,
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
            bottom: CustomStyle.sizeL,
          ),
          child: Text(
            '${AppLocalizations.of(context)!.splitOption}:',
            style: const TextStyle(
              fontSize: CustomStyle.sizeXL,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: (MediaQuery.of(context).size.width / 110.0),
          ),
          itemCount: splitOptionValues.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  elevation: 0.0,
                  foregroundColor: getForegroundColor(
                    context: context,
                    targetValue: splitOption,
                    value: splitOptionValues[index],
                  ),
                  backgroundColor: editMode
                      ? getBackgroundColor(
                          context: context,
                          targetValue: splitOption,
                          value: splitOptionValues[index],
                        )
                      : getDisabledBackgroundColor(
                          context: context,
                          targetValue: splitOption,
                          value: splitOptionValues[index],
                        ),
                  side: BorderSide(
                    color: editMode
                        ? getBorderColor(
                            context: context,
                            targetValue: splitOption,
                            value: splitOptionValues[index],
                          )
                        : getDisabledBorderColor(),
                    width: 1.0,
                  ),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
                onPressed: editMode
                    ? () {
                        onGridPressed(index);
                      }
                    : () {},
                child: Text(
                  '${splitBaseLine[splitOptionValues[index]]!.$1}/${splitBaseLine[splitOptionValues[index]]!.$2} ${CustomStyle.mHz}',
                  style: const TextStyle(
                    fontSize: CustomStyle.sizeXL,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    ),
  );
}

Widget gridViewButton({
  required BuildContext context,
  required int crossAxisCount,
  required List<String> values,
  required List<String> texts,
  required bool editMode,
  required String pilotFrequencyMode,
  required ValueChanged onGridPressed,
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
            bottom: CustomStyle.sizeL,
          ),
          child: Text(
            '${AppLocalizations.of(context)!.pilotFrequencySelect}:',
            style: const TextStyle(
              fontSize: CustomStyle.sizeXL,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: (MediaQuery.of(context).size.width / 56.0),
          ),
          itemCount: values.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  elevation: 0.0,
                  foregroundColor: getForegroundColor(
                    context: context,
                    targetValue: pilotFrequencyMode,
                    value: pilotFrequencyModeValues[index],
                  ),
                  backgroundColor: editMode
                      ? getBackgroundColor(
                          context: context,
                          targetValue: pilotFrequencyMode,
                          value: pilotFrequencyModeValues[index],
                        )
                      : getDisabledBackgroundColor(
                          context: context,
                          targetValue: pilotFrequencyMode,
                          value: pilotFrequencyModeValues[index],
                        ),
                  side: BorderSide(
                    color: editMode
                        ? getBorderColor(
                            context: context,
                            targetValue: pilotFrequencyMode,
                            value: pilotFrequencyModeValues[index],
                          )
                        : getDisabledBorderColor(),
                    width: 1.0,
                  ),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
                onPressed: editMode
                    ? () {
                        onGridPressed(index);
                      }
                    : () {},
                child: Text(
                  texts[index],
                  style: const TextStyle(
                    fontSize: CustomStyle.sizeXL,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    ),
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
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
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
                  errorText: editMode ? minValueErrorText : null,
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
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
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
                  errorText: editMode ? maxValueErrorText : null,
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
          flex: 4,
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
const Map<String, (int?, int?)> splitBaseLine = {
  // '0': (null, null),
  '1': (204, 258),
  // '2': (300, 372),
  '3': (396, 492),
  // '4': (492, 606),
  // '5': (684, 834),
};

const List<String> splitOptionValues = [
  // '0',
  '1',
  // '2',
  '3',
  // '4',
  // '5',
];

List<String> pilotFrequencyModeValues = const [
  '0',
  '1',
  // '2',
];

bool isValidFirstChannelLoadingFrequency({
  required String currentDetectedSplitOption,
  required IntegerInput firstChannelLoadingFrequency,
}) {
  int? forwardStartFrequency = splitBaseLine[currentDetectedSplitOption]?.$2;
  if (firstChannelLoadingFrequency.isNotValid) {
    return false;
  } else {
    if (forwardStartFrequency == null) {
      return true;
    } else if (firstChannelLoadingFrequency.value.isEmpty) {
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
  required String targetValue,
  required String value,
}) {
  return targetValue == value
      ? CustomStyle.customRed
      : Theme.of(context).colorScheme.onPrimary;
}

Color getNullBorderColor({
  required BuildContext context,
  required String targetValue,
  required String value,
}) {
  return targetValue == value ? CustomStyle.customRed : Colors.grey;
}

Color getBackgroundColor({
  required BuildContext context,
  required String targetValue,
  required String value,
}) {
  return targetValue == value
      ? Theme.of(context).colorScheme.primary
      : Theme.of(context).colorScheme.onPrimary;
}

Color getBorderColor({
  required BuildContext context,
  required String targetValue,
  required String value,
}) {
  return targetValue == value
      ? Theme.of(context).colorScheme.primary
      : Colors.grey;
}

Color getForegroundColor({
  required BuildContext context,
  required String targetValue,
  required String value,
}) {
  return targetValue == value
      ? Theme.of(context).colorScheme.onPrimary
      : Colors.grey;
}

Color getDisabledNullBackgroundColor({
  required BuildContext context,
  required String targetValue,
  required String value,
}) {
  return targetValue == value
      ? const Color.fromARGB(255, 215, 82, 95)
      : Theme.of(context).colorScheme.onPrimary;
}

Color getDisabledBackgroundColor({
  required BuildContext context,
  required String targetValue,
  required String value,
}) {
  return targetValue == value
      ? Theme.of(context).colorScheme.inversePrimary
      : Theme.of(context).colorScheme.onPrimary;
}

Color getDisabledBorderColor() {
  return Colors.grey;
}
