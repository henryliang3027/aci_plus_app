import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
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
    // double.tryParse 如果字串格式錯誤則回傳 null, 在下列寫法中如果是 null, 則為 minValue
    // minValue 經過 clamp 則等於原來的值
    // 如果不是 null 則經過 clamp 會限制到 (minValue, maxValue)範圍裡, 讓 slider 不會超出顯示範圍
    double currentValue =
        (double.tryParse(value) ?? minValue).clamp(minValue, maxValue);

    // double currentValue = double.parse(value).clamp(minValue, maxValue);
    return currentValue;
  } else {
    return minValue;
  }
}

double _stringToDecimal({
  required String value,
}) {
  if (value.isNotEmpty) {
    return double.tryParse(value) ?? 0.0;
  } else {
    return 0.0;
  }
}

String getForwardCEQText(String index) {
  if (index.isNotEmpty) {
    int intIndex = int.parse(index);

    if (intIndex >= 0 && intIndex <= 24) {
      return '1.8G CEQ';
    } else if (intIndex == 120) {
      return '1.2G EQ';
    } else if (intIndex == 180) {
      return '1.8G EQ';
    } else if (intIndex == 255) {
      return '';
    } else {
      return '';
    }
  } else {
    return '';
  }
}

double getVVA1MaxValue(String partId) {
  if (partId == '1' || partId == '8' || partId == '9') {
    // SDLE, SDAT, SDAM

    return 20.0;
  } else {
    return 30.0;
  }
}

double getSlope1MaxValue(String index) {
  if (index.isNotEmpty) {
    int intIndex = int.parse(index);

    if (intIndex >= 0 && intIndex <= 24) {
      // 1.8G CEQ
      return 12.0;
    } else if (intIndex == 120) {
      // 1.2G EQ
      return 12.0;
    } else if (intIndex == 180) {
      // 1.8G EQ
      return 12.0;
    } else if (intIndex == 255) {
      // 未安裝
      return 12.0;
    } else {
      return 12.0;
    }
  } else {
    return 12.0;
  }
}

String getInputAttenuation({
  required String pilotFrequencyMode,
  required String agcMode,
  required String inputAttenuation,
  required String currentInputAttenuation,
}) {
  return pilotFrequencyMode == '3'
      ? inputAttenuation
      : agcMode == '0'
          ? inputAttenuation
          : currentInputAttenuation;
}

String getInputEqualizer({
  required String pilotFrequencyMode,
  required String agcMode,
  required String inputEqualizer,
  required String currentInputEqualizer,
}) {
  return pilotFrequencyMode == '3'
      ? inputEqualizer
      : agcMode == '0'
          ? inputEqualizer
          : currentInputEqualizer;
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
    required this.errorText1,
    this.textPrecision = 1,
  });

  final String initialValue;
  final double minValue;
  final double maxValue;
  final double step;
  final bool enabled;
  final ValueChanged<String> onChanged;
  final String? errorText1;
  final int textPrecision;

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
    super.didUpdateWidget(oldWidget);

    if (oldWidget != widget) {
      setState(() {
        _value = _getBondaryValue(
          value: widget.initialValue,
          minValue: widget.minValue,
          maxValue: widget.maxValue,
        );

        _textEditingController.value = TextEditingValue(
          text: widget.initialValue,
          selection: _textEditingController.selection,
        );
      });
    }
  }

  void _increaseValue() {
    setState(() {
      _value = _value + widget.step <= widget.maxValue
          ? _value + widget.step
          : _value;

      _textEditingController.text =
          _value.toStringAsFixed(widget.textPrecision);
    });
  }

  void _decreasedValue() {
    setState(() {
      _value = _value - widget.step >= widget.minValue
          ? _value - widget.step
          : _value;

      _textEditingController.text =
          _value.toStringAsFixed(widget.textPrecision);
    });
  }

  // _adjustTextFieldValue({
  //   required String value,
  // }) {
  //   if (value.isNotEmpty) {
  //     double doubleCurrentValue = double.parse(value);
  //     if (doubleCurrentValue > widget.maxValue) {
  //       _textEditingController.text = widget.maxValue.toStringAsFixed(1);
  //     } else if (doubleCurrentValue < widget.minValue) {
  //       _textEditingController.text = widget.minValue.toStringAsFixed(1);
  //     } else {
  //       // 維持目前 value;
  //     }
  //   } else {
  //     _textEditingController.text = '';
  //   }
  // }

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
                    widget.onChanged(
                        _value.toStringAsFixed(widget.textPrecision));
                  }
                : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                          widget.onChanged(
                              _value.toStringAsFixed(widget.textPrecision));
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
                      // _adjustTextFieldValue(value: value);
                      widget.onChanged(value);
                    },
                    onTapOutside: (event) {
                      // 點擊其他區域關閉螢幕鍵盤
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    maxLength: 40,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      if (widget.textPrecision == 1)
                        // ^：表示從起始開始匹配第一個符合的數字
                        // \d{1,3}：\d 表示匹配任何一個數字。{1,3} 表示前面的數字字符必須出現 1~3 次
                        // (\.\d?)?：匹配一個小數點後跟著 0 到 1 位數字
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d{1,3}(\.\d?)?'))
                      else
                        FilteringTextInputFormatter.allow(RegExp(r'^\d{1,3}'))
                    ],
                    decoration: InputDecoration(
                      // label: Text(
                      //     '${AppLocalizations.of(context)!.frequency} (${CustomStyle.mHz})'),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0))),
                      contentPadding: const EdgeInsets.all(8.0),
                      isDense: true,
                      filled: true,
                      fillColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      counterText: '',
                      errorMaxLines: 2,
                      // 暫時解法, 避免 errorText 出現時改變了 textfield 原來的高度
                      helperText: '',
                      error: widget.enabled
                          ? _validateText(
                              context: context,
                              errorText: widget.errorText1,
                            )
                          : null,
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
                          widget.onChanged(
                              _value.toStringAsFixed(widget.textPrecision));
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

class FineTuneInput extends StatefulWidget {
  const FineTuneInput({
    super.key,
    required this.labelText,
    required this.initialValue,
    required this.step,
    required this.maxDigit,
    required this.enabled,
    required this.onChanged,
    required this.onIncreased,
    required this.onDecreased,
    required this.errorText,
    this.textPrecision = 1,
  });

  final String labelText;
  final String initialValue;
  final double step;
  final int maxDigit;
  final bool enabled;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onIncreased;
  final ValueChanged<String> onDecreased;
  final String? errorText;
  final int textPrecision;

  @override
  State<FineTuneInput> createState() => _FineTuneInputState();
}

class _FineTuneInputState extends State<FineTuneInput> {
  late double _value;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _value = _stringToDecimal(value: widget.initialValue);

    _textEditingController = TextEditingController()
      ..text = widget.initialValue;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FineTuneInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget != widget) {
      setState(() {
        _value = _stringToDecimal(value: widget.initialValue);

        _textEditingController.value = TextEditingValue(
          text: widget.initialValue,
          selection: _textEditingController.selection,
        );
      });
    }
  }

  void _increaseValue() {
    setState(() {
      _value = _value + widget.step;

      _textEditingController.text =
          _value.toStringAsFixed(widget.textPrecision);
    });
  }

  void _decreasedValue() {
    setState(() {
      _value = _value - widget.step;

      _textEditingController.text =
          _value.toStringAsFixed(widget.textPrecision);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: CustomStyle.sizeXS,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
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

                          widget.onDecreased(
                              _value.toStringAsFixed(widget.textPrecision));
                        }
                      : null,
                ),
              ),
              Flexible(
                flex: 4,
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
                      // _adjustTextFieldValue(value: value);
                      widget.onChanged(value);
                    },
                    onTapOutside: (event) {
                      // 點擊其他區域關閉螢幕鍵盤
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    maxLength: 40,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      if (widget.textPrecision == 1)
                        // ^：表示從起始開始匹配第一個符合的數字
                        // \d{1,3}：\d 表示匹配任何一個數字。{1,3} 表示前面的數字字符必須出現 1~3 次
                        // (\.\d?)?：匹配一個小數點後跟著 0 到 1 位數字
                        FilteringTextInputFormatter.allow(RegExp(r'^\d{1,' +
                            widget.maxDigit.toString() +
                            r'}(\.\d?)?'))
                      else
                        FilteringTextInputFormatter.allow(RegExp(r'^\d{1,' +
                            widget.maxDigit.toString() +
                            r'}(\.\d?)?'))
                    ],
                    decoration: InputDecoration(
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      label: Text(widget.labelText),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0))),
                      contentPadding: const EdgeInsets.all(8.0),
                      isDense: true,
                      filled: true,
                      fillColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      counterText: '',
                      errorMaxLines: 2,
                      error: widget.enabled
                          ? _validateText(
                              context: context,
                              errorText: widget.errorText,
                            )
                          : null,
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
                          widget.onIncreased(
                              _value.toStringAsFixed(widget.textPrecision));
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

Widget? _validateText({
  required BuildContext context,
  String? errorText,
}) {
  if (errorText != null) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        errorText,
        style:
            TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
      ),
    );
  } else {
    return null;
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
  double elevation = 1.0,
  Color? color,
}) {
  return Card(
    elevation: elevation,
    color: color,
    child: Padding(
      padding: const EdgeInsets.all(CustomStyle.sizeXL),
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
  required String? errorText,
  int textPrecision = 1,
  double step = 0.5,
  String subTitle = '',
  double elevation = 1.0,
  Color? color,
}) {
  // textEditingController.text = currentValue;
  return Card(
    elevation: elevation,
    color: color,
    child: Padding(
      padding: const EdgeInsets.all(CustomStyle.sizeXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: CustomStyle.sizeL,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Text(
                  subTitle,
                  style: const TextStyle(
                    fontSize: CustomStyle.sizeXL,
                    fontWeight: FontWeight.w500,
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
            errorText1: errorText,
            textPrecision: textPrecision,
          ),
        ],
      ),
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
  double elevation = 1.0,
  Color? color,
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

  return Card(
    elevation: elevation,
    color: color,
    child: Padding(
      padding: const EdgeInsets.all(CustomStyle.sizeXL),
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
            builder: (context, constraints) => Container(
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: const BorderRadius.all(Radius.circular(9.0)),
              ),
              child: ToggleButtons(
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
                  height: 48,
                ),
                isSelected: getSelectionState(currentValue),
                children: <Widget>[
                  for (String text in texts) ...[Text(text)],
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget ingressGridViewButton({
  required BuildContext context,
  required String title,
  required List<String> values,
  required List<String> texts,
  required bool editMode,
  required String currentValue,
  required ValueChanged onChanged,
  double spacing = 8.0,
  double runSpacing = 0.0,
  double elevation = 1.0,
  Color? color,
}) {
  return SizedBox(
    width: double.maxFinite,
    child: Card(
      elevation: elevation,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(CustomStyle.sizeXL),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Decide how many items per row; for example, 3
            const itemsPerRow = 1;

            // Available width for the buttons in one row (excluding spacing).
            // Because we have (itemsPerRow - 1) gaps between items in the same row,
            // multiply spacing by (itemsPerRow - 1) to get total horizontal spacing for that row.
            final totalSpacing = (itemsPerRow - 1) * spacing;
            final itemWidth =
                (constraints.maxWidth - totalSpacing) / itemsPerRow;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: CustomStyle.sizeL,
                  ),
                  child: Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: CustomStyle.sizeXL,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: CustomStyle.sizeXS,
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    spacing:
                        spacing, // horizontal spacing between items in a row
                    runSpacing: runSpacing, // vertical spacing between rows
                    children: List.generate(
                      values.length,
                      (index) {
                        return SizedBox(
                          width:
                              itemWidth, // fixed width so they distribute evenly
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              // padding: const EdgeInsets.symmetric(horizontal: 6.0),
                              elevation: 0.0,
                              foregroundColor: getForegroundColor(
                                context: context,
                                targetValue: currentValue,
                                value: values[index],
                              ),
                              backgroundColor: editMode
                                  ? getBackgroundColor(
                                      context: context,
                                      targetValue: currentValue,
                                      value: values[index],
                                    )
                                  : getDisabledBackgroundColor(
                                      context: context,
                                      targetValue: currentValue,
                                      value: values[index],
                                    ),
                              side: BorderSide(
                                color: editMode
                                    ? getBorderColor(
                                        context: context,
                                        targetValue: currentValue,
                                        value: values[index],
                                      )
                                    : getDisabledBorderColor(),
                                width: 1.0,
                              ),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                            ),
                            onPressed: editMode
                                ? () {
                                    onChanged(index);
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
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ),
  );
}

class FineTuner extends StatefulWidget {
  const FineTuner({
    super.key,
    required this.labelText,
    required this.step,
    required this.enabled,
    required this.onIncreased,
    required this.onDecreased,
    required this.errorText,
  });

  final String labelText;
  final double step;
  final bool enabled;
  final VoidCallback onIncreased;
  final VoidCallback onDecreased;
  final String? errorText;

  @override
  State<FineTuner> createState() => _FineTunerState();
}

class _FineTunerState extends State<FineTuner> {
  // late double _value;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    // _value = _stringToDecimal(value: widget.initialValue);

    _textEditingController = TextEditingController()..text = widget.labelText;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FineTuner oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget != widget) {
      setState(() {
        _textEditingController = TextEditingController()
          ..text = widget.labelText;
        // _value = _stringToDecimal(value: widget.initialValue);

        // _textEditingController.value = TextEditingValue(
        //   text: widget.initialValue,
        //   selection: _textEditingController.selection,
        // );
      });
    }
  }

  // void _increaseValue() {
  //   setState(() {
  //     _value = _value + widget.step;

  //     _textEditingController.text =
  //         _value.toStringAsFixed(widget.textPrecision);
  //   });
  // }

  // void _decreasedValue() {
  //   setState(() {
  //     _value = _value - widget.step;

  //     _textEditingController.text =
  //         _value.toStringAsFixed(widget.textPrecision);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: CustomStyle.sizeXS,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                          // _decreasedValue();

                          widget.onDecreased();
                        }
                      : null,
                ),
              ),
              Flexible(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0.0,
                  ),
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                      border: Border.all(
                        color: widget.enabled
                            ? Theme.of(context).colorScheme.outline
                            : Colors.grey,
                      ),
                    ),
                    child: Text(
                      widget.labelText,
                      style: TextStyle(
                        fontSize: CustomStyle.sizeXL,
                        color: widget.enabled
                            ? Theme.of(context).textTheme.bodyLarge?.color
                            : Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // TextField(
                  //   controller: _textEditingController,
                  //   // key: Key(textEditingControllerName1),
                  //   style: const TextStyle(
                  //     fontSize: CustomStyle.sizeXXL,
                  //   ),

                  //   textAlign: TextAlign.center,

                  //   enabled: widget.enabled,
                  //   textInputAction: TextInputAction.done,
                  //   onChanged: (value) {
                  //     // _adjustTextFieldValue(value: value);
                  //     // widget.onChanged(value);
                  //   },
                  //   onTapOutside: (event) {
                  //     // 點擊其他區域關閉螢幕鍵盤
                  //     FocusManager.instance.primaryFocus?.unfocus();
                  //   },
                  //   maxLength: 40,
                  //   keyboardType: const TextInputType.numberWithOptions(
                  //     decimal: true,
                  //   ),
                  //   // inputFormatters: [
                  //   //   if (widget.textPrecision == 1)
                  //   //     // ^：表示從起始開始匹配第一個符合的數字
                  //   //     // \d{1,3}：\d 表示匹配任何一個數字。{1,3} 表示前面的數字字符必須出現 1~3 次
                  //   //     // (\.\d?)?：匹配一個小數點後跟著 0 到 1 位數字
                  //   //     FilteringTextInputFormatter.allow(RegExp(r'^\d{1,' +
                  //   //         widget.maxDigit.toString() +
                  //   //         r'}(\.\d?)?'))
                  //   //   else
                  //   //     FilteringTextInputFormatter.allow(RegExp(r'^\d{1,' +
                  //   //         widget.maxDigit.toString() +
                  //   //         r'}(\.\d?)?'))
                  //   // ],
                  //   decoration: InputDecoration(
                  //     floatingLabelAlignment: FloatingLabelAlignment.center,
                  //     // label: Text(widget.labelText),
                  //     border: const OutlineInputBorder(
                  //         borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  //     contentPadding: const EdgeInsets.all(8.0),
                  //     isDense: true,
                  //     filled: true,
                  //     fillColor:
                  //         Theme.of(context).colorScheme.secondaryContainer,
                  //     counterText: '',
                  //     errorMaxLines: 2,
                  //     error: widget.enabled
                  //         ? _validateText(
                  //             context: context,
                  //             errorText: widget.errorText,
                  //           )
                  //         : null,
                  //   ),
                  // ),
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
                          // _increaseValue();
                          widget.onIncreased();
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

Widget rfSlopeFinetune({
  required BuildContext context,
  required String title1,
  required String title2,
  required bool editMode1,
  required bool editMode2,
  required VoidCallback onIncreased1,
  required VoidCallback onDecreased1,
  required double step1,
  required VoidCallback onIncreased2,
  required VoidCallback onDecreased2,
  required double step2,
  bool reaOnly1 = false,
  bool reaOnly2 = false,
  String? errorText1,
  String? errorText2,
  double padding = CustomStyle.sizeXL,
  double elevation = 1.0,
  Color? color,
}) {
  return Card(
    elevation: elevation,
    color: color,
    child: Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        children: [
          FineTuner(
            labelText: title1,
            step: step1,
            enabled: editMode1,
            onIncreased: onIncreased1,
            onDecreased: onDecreased1,
            errorText: errorText1,
          ),
          const SizedBox(
            height: 0,
          ),
          FineTuner(
            labelText: title2,
            step: step2,
            enabled: editMode2,
            onIncreased: onIncreased2,
            onDecreased: onDecreased2,
            errorText: errorText2,
          ),
        ],
      ),
    ),
  );
}

Widget frequencyRFTextField({
  required BuildContext context,
  required String title1,
  required String title2,
  required bool editMode1,
  required bool editMode2,
  required String textEditingControllerName1,
  required String textEditingControllerName2,
  required String currentValue1,
  required String currentValue2,
  required ValueChanged onChanged1,
  required ValueChanged onIncreased1,
  required ValueChanged onDecreased1,
  required double step1,
  required ValueChanged onChanged2,
  required ValueChanged onIncreased2,
  required ValueChanged onDecreased2,
  required double step2,
  bool reaOnly1 = false,
  bool reaOnly2 = false,
  String? errorText1,
  String? errorText2,
  double padding = CustomStyle.sizeXL,
  double elevation = 1.0,
  Color? color,
}) {
  return Card(
    elevation: elevation,
    color: color,
    child: Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
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
                    title1,
                    style: const TextStyle(
                      fontSize: CustomStyle.sizeXL,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          FineTuneInput(
            labelText:
                '${AppLocalizations.of(context)!.frequency} (${CustomStyle.mHz})',
            initialValue: currentValue1,
            step: step1,
            maxDigit: 4,
            enabled: editMode1,
            onChanged: onChanged1,
            onIncreased: onIncreased1,
            onDecreased: onDecreased1,
            errorText: errorText1,
            textPrecision: 0,
          ),

          // TextField(
          //   controller: textEditingController1,
          //   key: Key(textEditingControllerName1),
          //   style: const TextStyle(
          //     fontSize: CustomStyle.sizeXL,
          //   ),
          //   keyboardType: const TextInputType.numberWithOptions(
          //     decimal: true,
          //   ),
          //   enabled: editMode1,
          //   readOnly: reaOnly1,
          //   textInputAction: TextInputAction.done,
          //   onChanged: onChanged1,
          //   onTapOutside: (event) {
          //     // 點擊其他區域關閉螢幕鍵盤
          //     FocusManager.instance.primaryFocus?.unfocus();
          //   },
          //   maxLength: 40,
          //   decoration: InputDecoration(
          //     label: Text(
          //         '${AppLocalizations.of(context)!.frequency} (${CustomStyle.mHz})'),
          //     border: const OutlineInputBorder(
          //         borderRadius: BorderRadius.all(Radius.circular(4.0))),
          //     contentPadding: const EdgeInsets.all(8.0),
          //     isDense: true,
          //     filled: true,
          //     fillColor: Theme.of(context).colorScheme.secondaryContainer,
          //     counterText: '',
          //     errorMaxLines: 2,
          //     errorStyle: const TextStyle(fontSize: CustomStyle.sizeS),
          //     errorText: editMode1 ? errorText1 : null,
          //   ),
          // ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: CustomStyle.sizeL,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    title2,
                    style: const TextStyle(
                      fontSize: CustomStyle.sizeXL,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          FineTuneInput(
            labelText:
                '${AppLocalizations.of(context)!.level} (${CustomStyle.dBmV})',
            initialValue: currentValue2,
            step: step2,
            maxDigit: 3,
            enabled: editMode2,
            onChanged: onChanged2,
            onIncreased: onIncreased2,
            onDecreased: onDecreased2,
            errorText: errorText2,
          ),

          // TextField(
          //   controller: textEditingController2,
          //   key: Key(textEditingControllerName2),
          //   style: const TextStyle(
          //     fontSize: CustomStyle.sizeXL,
          //   ),
          //   keyboardType: const TextInputType.numberWithOptions(
          //     decimal: true,
          //   ),
          //   enabled: editMode2,
          //   readOnly: reaOnly2,
          //   textInputAction: TextInputAction.done,
          //   onChanged: onChanged2,
          //   onTapOutside: (event) {
          //     // 點擊其他區域關閉螢幕鍵盤
          //     FocusManager.instance.primaryFocus?.unfocus();
          //   },
          //   maxLength: 40,
          //   decoration: InputDecoration(
          //     label: Text(
          //         '${AppLocalizations.of(context)!.level} (${CustomStyle.dBmV})'),
          //     border: const OutlineInputBorder(
          //         borderRadius: BorderRadius.all(Radius.circular(4.0))),
          //     contentPadding: const EdgeInsets.all(8.0),
          //     isDense: true,
          //     filled: true,
          //     fillColor: Theme.of(context).colorScheme.secondaryContainer,
          //     counterText: '',
          //     errorMaxLines: 2,
          //     errorStyle: const TextStyle(fontSize: CustomStyle.sizeS),
          //     errorText: editMode2 ? errorText2 : null,
          //   ),
          // ),
        ],
      ),
    ),
  );
}

class TwoInputs extends StatefulWidget {
  const TwoInputs({
    super.key,
    required this.title,
    required this.editMode1,
    required this.editMode2,
    required this.initialValue1,
    required this.initialValue2,
    required this.onChanged1,
    required this.onChanged2,
    this.readOnly1 = false,
    this.readOnly2 = false,
    this.errorText1,
    this.errorText2,
    this.padding = CustomStyle.sizeXL,
    this.elevation = 1.0,
    this.color,
  });

  final String title;
  final bool editMode1;
  final bool editMode2;
  final String initialValue1;
  final String initialValue2;
  final ValueChanged onChanged1;
  final ValueChanged onChanged2;
  final bool readOnly1;
  final bool readOnly2;
  final String? errorText1;
  final String? errorText2;
  final double padding;
  final double elevation;
  final Color? color;

  @override
  State<TwoInputs> createState() => _TwoInputsState();
}

class _TwoInputsState extends State<TwoInputs> {
  late TextEditingController _textEditingController1;
  late TextEditingController _textEditingController2;

  @override
  void initState() {
    _textEditingController1 = TextEditingController()
      ..text = widget.initialValue1;
    _textEditingController2 = TextEditingController()
      ..text = widget.initialValue2;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TwoInputs oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget != widget) {
      setState(() {
        _textEditingController1.value = TextEditingValue(
          text: widget.initialValue1,
          selection: _textEditingController1.selection,
        );
        _textEditingController2.value = TextEditingValue(
          text: widget.initialValue2,
          selection: _textEditingController2.selection,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: widget.elevation,
      color: widget.color,
      child: Padding(
        padding: EdgeInsets.all(widget.padding),
        child: Column(
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
                      widget.title,
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
                bottom: CustomStyle.sizeXS,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    child: TextField(
                      controller: _textEditingController1,
                      key: const Key('textEditingControllerName1'),
                      style: const TextStyle(
                        fontSize: CustomStyle.sizeXL,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      enabled: widget.editMode1,
                      textInputAction: TextInputAction.done,
                      onChanged: widget.onChanged1,
                      onTapOutside: (event) {
                        // 點擊其他區域關閉螢幕鍵盤
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      maxLength: 40,
                      decoration: InputDecoration(
                        label: Text(
                            '${AppLocalizations.of(context)!.frequency} (${CustomStyle.mHz})'),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0))),
                        contentPadding: const EdgeInsets.all(8.0),
                        isDense: true,
                        filled: true,
                        fillColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                        counterText: '',
                        errorMaxLines: 2,
                        errorStyle:
                            const TextStyle(fontSize: CustomStyle.sizeS),
                        errorText: widget.editMode1 ? widget.errorText1 : null,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    flex: 2,
                    child: TextField(
                      controller: _textEditingController2,
                      key: const Key('textEditingControllerName2'),
                      style: const TextStyle(
                        fontSize: CustomStyle.sizeXL,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      enabled: widget.editMode2,
                      textInputAction: TextInputAction.done,
                      onChanged: widget.onChanged2,
                      onTapOutside: (event) {
                        // 點擊其他區域關閉螢幕鍵盤
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      maxLength: 40,
                      decoration: InputDecoration(
                        label: Text(
                            '${AppLocalizations.of(context)!.level} (${CustomStyle.dBmV})'),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0))),
                        contentPadding: const EdgeInsets.all(8.0),
                        isDense: true,
                        filled: true,
                        fillColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                        counterText: '',
                        errorMaxLines: 2,
                        errorStyle:
                            const TextStyle(fontSize: CustomStyle.sizeS),
                        errorText: widget.editMode2 ? widget.errorText2 : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
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
  double padding = CustomStyle.sizeXL,
  double elevation = 1.0,
  Color? color,
}) {
  return Card(
    elevation: elevation,
    color: color,
    child: Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
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
              bottom: CustomStyle.sizeXS,
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
                    onTapOutside: (event) {
                      // 點擊其他區域關閉螢幕鍵盤
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    maxLength: 40,
                    decoration: InputDecoration(
                      label: Text(
                          '${AppLocalizations.of(context)!.frequency} (${CustomStyle.mHz})'),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0))),
                      contentPadding: const EdgeInsets.all(8.0),
                      isDense: true,
                      filled: true,
                      fillColor:
                          Theme.of(context).colorScheme.secondaryContainer,
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
                    onTapOutside: (event) {
                      // 點擊其他區域關閉螢幕鍵盤
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    maxLength: 40,
                    decoration: InputDecoration(
                      label: Text(
                          '${AppLocalizations.of(context)!.level} (${CustomStyle.dBmV})'),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0))),
                      contentPadding: const EdgeInsets.all(8.0),
                      isDense: true,
                      filled: true,
                      fillColor:
                          Theme.of(context).colorScheme.secondaryContainer,
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
        ],
      ),
    ),
  );
}

Widget configureGridViewButton({
  required BuildContext context,
  required bool editMode,
  required String title,
  required String targetValue,
  required Map<String, String> texts,
  required List<String> values,
  required ValueChanged onGridPressed,
  double padding = CustomStyle.sizeXL,
  double elevation = 1.0,
  Color? color,
}) {
  return Card(
    elevation: elevation,
    color: color,
    child: Padding(
      padding: EdgeInsets.all(padding),
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
          Padding(
            padding: const EdgeInsets.only(
              bottom: CustomStyle.sizeXS,
            ),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 6.0,
                childAspectRatio: MediaQuery.of(context).size.width / 110,
              ),
              itemCount: values.length,
              itemBuilder: (BuildContext itemContext, int index) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    elevation: 0.0,
                    foregroundColor: getForegroundColor(
                      context: context,
                      targetValue: targetValue,
                      value: values[index],
                    ),
                    backgroundColor: editMode
                        ? getBackgroundColor(
                            context: context,
                            targetValue: targetValue,
                            value: values[index],
                          )
                        : getDisabledBackgroundColor(
                            context: context,
                            targetValue: targetValue,
                            value: values[index],
                          ),
                    side: BorderSide(
                      color: editMode
                          ? getBorderColor(
                              context: context,
                              targetValue: targetValue,
                              value: values[index],
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
                    texts[index.toString()]!,
                    style: const TextStyle(
                      fontSize: CustomStyle.sizeXL,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

Widget splitOptionGridViewButton({
  required BuildContext context,
  required bool editMode,
  required String splitOption,
  required ValueChanged onGridPressed,
  double padding = CustomStyle.sizeXL,
  double elevation = 1.0,
  Color? color,
}) {
  return Card(
    elevation: elevation,
    color: color,
    child: Padding(
      padding: EdgeInsets.all(padding),
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
          Padding(
            padding: const EdgeInsets.only(
              bottom: CustomStyle.sizeXS,
            ),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 6.0,
                childAspectRatio: MediaQuery.of(context).size.width / 110,
              ),
              itemCount: splitOptionValues.length,
              itemBuilder: (BuildContext itemContext, int index) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    elevation: 0.0,
                    foregroundColor: getForegroundColor(
                      context: context,
                      targetValue: splitOption,
                      value: splitOptionValues[index],
                    ),
                    disabledBackgroundColor: getDisabledBackgroundColor(
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
                          if (index == 0) {
                            onGridPressed(index);
                          }
                        }
                      : () {},
                  child: Text(
                    '${splitBaseLine[splitOptionValues[index]]!.$1}/${splitBaseLine[splitOptionValues[index]]!.$2} ${CustomStyle.mHz}',
                    style: const TextStyle(
                      fontSize: CustomStyle.sizeXL,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

Widget pilotFrequencyModeGridViewButton({
  required BuildContext context,
  required int crossAxisCount,
  required List<String> values,
  required List<String> texts,
  required bool editMode,
  required String pilotFrequencyMode,
  required ValueChanged onGridPressed,
  double elevation = 1.0,
  Color? color,
}) {
  return Card(
    elevation: elevation,
    color: color,
    child: Padding(
      padding: const EdgeInsets.all(CustomStyle.sizeXL),
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
          Padding(
            padding: const EdgeInsets.only(
              bottom: CustomStyle.sizeXS,
            ),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 6.0,
                childAspectRatio: MediaQuery.of(context).size.width / 56,
              ),
              itemCount: values.length,
              itemBuilder: (BuildContext itemContext, int index) {
                return Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      elevation: 0.0,
                      foregroundColor: getForegroundColor(
                        context: context,
                        targetValue: pilotFrequencyMode,
                        value: values[index],
                      ),
                      backgroundColor: editMode
                          ? getBackgroundColor(
                              context: context,
                              targetValue: pilotFrequencyMode,
                              value: values[index],
                            )
                          : getDisabledBackgroundColor(
                              context: context,
                              targetValue: pilotFrequencyMode,
                              value: values[index],
                            ),
                      side: BorderSide(
                        color: editMode
                            ? getBorderColor(
                                context: context,
                                targetValue: pilotFrequencyMode,
                                value: values[index],
                              )
                            : getDisabledBorderColor(),
                        width: 1.0,
                      ),
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
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
          ),
        ],
      ),
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
  double elevation = 1.0,
  Color? color,
}) {
  return Card(
    elevation: elevation,
    color: color,
    child: Padding(
      padding: const EdgeInsets.all(
        CustomStyle.sizeXL,
      ),
      child: Column(
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
                    thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.selected)) {
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
                    onTapOutside: (event) {
                      // 點擊其他區域關閉螢幕鍵盤
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    maxLength: 40,
                    decoration: InputDecoration(
                      label: Text(minValueLabel),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0))),
                      contentPadding: const EdgeInsets.all(8.0),
                      isDense: true,
                      filled: true,
                      fillColor:
                          Theme.of(context).colorScheme.secondaryContainer,
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
                    onTapOutside: (event) {
                      // 點擊其他區域關閉螢幕鍵盤
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    maxLength: 40,
                    decoration: InputDecoration(
                      label: Text(maxValueLabel),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0))),
                      contentPadding: const EdgeInsets.all(8.0),
                      isDense: true,
                      filled: true,
                      fillColor:
                          Theme.of(context).colorScheme.secondaryContainer,
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
        ],
      ),
    ),
  );
}

Widget thresholdAlarmSwitch({
  required BuildContext context,
  required bool editMode,
  required String title,
  required bool value,
  required ValueChanged<bool> onChanged,
  double elevation = 1.0,
  Color? color,
}) {
  return Card(
    elevation: elevation,
    color: color,
    child: Padding(
      padding: const EdgeInsets.all(
        CustomStyle.sizeXL,
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
              thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
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
    ),
  );
}

const Map<String, int?> maxStopFrequencyByDFUType = {
  '0': null,
  '1': 1794,
  '2': 1794,
  '3': 1794,
  '4': 1794,
  '5': 1794,
  '6': 1218,
};

// List<Record>
// Record, a new variable type of Dart 3
const Map<String, (int?, int?)> splitBaseLine = {
  '0': (null, null),
  '1': (204, 258),
  // '2': (300, 372),
  '3': (396, 492),
  // '4': (492, 606),
  // '5': (684, 834),
  '6': (85, 105),
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
  '3',
];

List<String> onBoardPilotFrequencyModeValues = [
  '0',
  '1',
  // '2',
  BenchMode.frequency1p2G.name,
  BenchMode.frequency1p8G.name,
];

// MFT8 機種 DFU=85/105 時適用的 PilotFrequencyMode
List<String> onBoard1P2GPilotFrequencyModeValues = [
  '0',
  '1',
  BenchMode.frequency1p2G.name,
];

// 給 widget 用, 由 grid item index 找 text
const Map<String, String> forwardConfigTexts = {
  '0': '1 X 4',
  '1': '2 X 2',
};

// 給 data export 用 由 forwardConfig value 找 text
const Map<String, String> forwardConfigExportTexts = {
  '1': '1 X 4',
  '2': '2 X 2',
};

const List<String> forwardConfigValues = [
  '1',
  '2',
];

// 給 widget 用, 由 grid item index 找 text
const Map<String, String> forwardModeTexts = {
  '0': '1218 ${CustomStyle.mHz}',
  '1': '1794 ${CustomStyle.mHz}',
};

// 給 data export 用 由 forwardMode value 找 text
const Map<String, String> forwardModeExportTexts = {
  '120': '1218 ${CustomStyle.mHz}',
  '180': '1794 ${CustomStyle.mHz}',
};

const List<String> forwardModeValues = [
  '120',
  '180',
];

String getAgcModeText({
  required BuildContext context,
  required String agcMode,
}) {
  Map<String, String> agcModeTexts = {
    '0': AppLocalizations.of(context)!.off,
    '1': AppLocalizations.of(context)!.on,
  };

  return agcModeTexts[agcMode] ?? AppLocalizations.of(context)!.off;
}

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
      : Theme.of(context).colorScheme.secondaryContainer;
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
      : Theme.of(context).colorScheme.secondaryContainer;
}

Color getDisabledBorderColor() {
  return Colors.grey;
}
