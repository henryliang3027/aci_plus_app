import 'package:aci_plus_app/core/custom_style.dart';
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
              Text(AppLocalizations.of(context)!.ingressOpen),
            ],
          ),
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
