import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// 可重用的通用對話框組件
class ReusableNoticeDialog extends StatelessWidget {
  const ReusableNoticeDialog({
    Key? key,
    required this.title,
    required this.children,
    this.okButtonText,
    this.onOkPressed,
    this.showCancelButton = false,
    this.cancelButtonText,
    this.onCancelPressed,
    this.barrierDismissible = false,
  }) : super(key: key);

  final String title;
  final List<Widget> children;
  final String? okButtonText;
  final VoidCallback? onOkPressed;
  final bool showCancelButton;
  final String? cancelButtonText;
  final VoidCallback? onCancelPressed;
  final bool barrierDismissible;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: width * 0.08,
      ),
      title: Text(
        title,
        style: const TextStyle(color: CustomStyle.customYellow),
      ),
      content: SizedBox(
        width: width,
        child: SingleChildScrollView(
          child: ListBody(
            children: children,
          ),
        ),
      ),
      actions: <Widget>[
        if (showCancelButton)
          ElevatedButton(
            onPressed: onCancelPressed ??
                () {
                  Navigator.of(context).pop(false);
                },
            child: Text(
              cancelButtonText ??
                  AppLocalizations.of(context)!.dialogMessageCancel,
            ),
          ),
        ElevatedButton(
          onPressed: onOkPressed ??
              () {
                Navigator.of(context).pop(true);
              },
          child: Text(
            okButtonText ?? AppLocalizations.of(context)!.dialogMessageOk,
          ),
        ),
      ],
    );
  }
}

// 便利函數：顯示通用對話框
Future<bool?> showReusableNoticeDialog({
  required BuildContext context,
  required String title,
  required List<Widget> children,
  String? okButtonText,
  VoidCallback? onOkPressed,
  bool showCancelButton = false,
  String? cancelButtonText,
  VoidCallback? onCancelPressed,
  bool barrierDismissible = false,
}) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) {
      return ReusableNoticeDialog(
        title: title,
        okButtonText: okButtonText,
        onOkPressed: onOkPressed,
        showCancelButton: showCancelButton,
        cancelButtonText: cancelButtonText,
        onCancelPressed: onCancelPressed,
        barrierDismissible: barrierDismissible,
        children: children,
      );
    },
  );
}

List<String> getUnFilledItemNameAndDescriptions({
  required BuildContext context,
  required List<DataKey> unFilledItems,
}) {
  List<String> unFilledItemNames = [];
  for (DataKey dataKey in unFilledItems) {
    if (dataKey == DataKey.agcMode) {
      unFilledItemNames.add(
          '${AppLocalizations.of(context)!.agcMode},${AppLocalizations.of(context)!.dialogMessageItemAGCDisabled}');
    } else if (dataKey == DataKey.location) {
      unFilledItemNames.add(
          '${AppLocalizations.of(context)!.location},${AppLocalizations.of(context)!.dialogMessageItemUnFilled}');
    } else if (dataKey == DataKey.coordinates) {
      unFilledItemNames.add(
          '${AppLocalizations.of(context)!.coordinates},${AppLocalizations.of(context)!.dialogMessageItemUnFilled}');
    } else if (dataKey == DataKey.technicianID) {
      unFilledItemNames.add(
          '${AppLocalizations.of(context)!.technicianID},${AppLocalizations.of(context)!.dialogMessageItemUnFilled}');
    } else if (dataKey == DataKey.inputSignalLevel) {
      unFilledItemNames.add(
          '${AppLocalizations.of(context)!.inputSignalLevel},${AppLocalizations.of(context)!.dialogMessageItemUnFilled}');
    } else if (dataKey == DataKey.inputAttenuation) {
      unFilledItemNames.add(
          '${AppLocalizations.of(context)!.inputAttenuation},${AppLocalizations.of(context)!.dialogMessageItemUnFilled}');
    } else if (dataKey == DataKey.inputEqualizer) {
      unFilledItemNames.add(
          '${AppLocalizations.of(context)!.inputEqualizer},${AppLocalizations.of(context)!.dialogMessageItemUnFilled}');
    } else if (dataKey == DataKey.cascadePosition) {
      unFilledItemNames.add(
          '${AppLocalizations.of(context)!.cascadePosition},${AppLocalizations.of(context)!.dialogMessageItemUnFilled}');
    } else if (dataKey == DataKey.deviceName) {
      unFilledItemNames.add(
          '${AppLocalizations.of(context)!.deviceName},${AppLocalizations.of(context)!.dialogMessageItemUnFilled}');
    } else {}
  }

  return unFilledItemNames;
}

List<DataKey> getUnFilledItem({
  required BuildContext context,
  required Map<DataKey, String> characteristicData,
}) {
  String agcMode = characteristicData[DataKey.agcMode] ?? '';
  String location = characteristicData[DataKey.location] ?? '';
  String coordinate = characteristicData[DataKey.coordinates] ?? '';
  String technicianID = characteristicData[DataKey.technicianID] ?? '';
  String inputSignalLevel = characteristicData[DataKey.inputSignalLevel] ?? '';
  String inputAttenuation = characteristicData[DataKey.inputAttenuation] ?? '';
  String inputEqualizer = characteristicData[DataKey.inputEqualizer] ?? '';
  String cascadePosition = characteristicData[DataKey.cascadePosition] ?? '';
  String deviceName = characteristicData[DataKey.deviceName] ?? '';

  List<DataKey> unFilledItems = [];

  if (agcMode.isEmpty || agcMode == '0') {
    unFilledItems.add(DataKey.agcMode);
  }
  if (location.isEmpty) {
    unFilledItems.add(DataKey.location);
  }
  if (coordinate.isEmpty) {
    unFilledItems.add(DataKey.coordinates);
  }
  if (technicianID.isEmpty) {
    unFilledItems.add(DataKey.technicianID);
  }
  if (inputSignalLevel.isEmpty) {
    unFilledItems.add(DataKey.inputSignalLevel);
  }
  if (inputAttenuation.isEmpty) {
    unFilledItems.add(DataKey.inputAttenuation);
  }
  if (inputEqualizer.isEmpty) {
    unFilledItems.add(DataKey.inputEqualizer);
  }
  if (cascadePosition.isEmpty) {
    unFilledItems.add(DataKey.cascadePosition);
  }
  if (deviceName.isEmpty) {
    unFilledItems.add(DataKey.deviceName);
  }

  return unFilledItems;
}

List<Widget> getMessageRows({
  required BuildContext context,
  required List<DataKey> unFilledItems,
}) {
  List<String> unFilledItemNameAndDescriptions =
      getUnFilledItemNameAndDescriptions(
    context: context,
    unFilledItems: unFilledItems,
  );
  List<Widget> rows = [];
  for (String unFilledItemName in unFilledItemNameAndDescriptions) {
    String itemName = unFilledItemName.split(',')[0];
    String itemDescription = unFilledItemName.split(',')[1];

    rows.add(Padding(
      padding: const EdgeInsets.only(
        bottom: 14.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              itemName,
              style: const TextStyle(
                fontSize: CustomStyle.sizeL,
              ),
            ),
          ),
          Text(
            itemDescription,
            style: const TextStyle(
              fontSize: CustomStyle.sizeL,
              color: Colors.red,
            ),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    ));
  }
  return rows;
}

Future<void> showUnfilledItemDialog({
  required BuildContext context,
  required List<DataKey> unFilledItems,
}) async {
  List<Widget> messageRows = getMessageRows(
    context: context,
    unFilledItems: unFilledItems,
  );

  await showReusableNoticeDialog(
    context: context,
    title: AppLocalizations.of(context)!.dialogTitleNotice,
    children: messageRows,
    barrierDismissible: false,
  );
}

Future<void> showExpertModeReminderDialogDialog({
  required BuildContext context,
}) async {
  await showReusableNoticeDialog(
    context: context,
    title: AppLocalizations.of(context)!.dialogTitleNotice,
    children: [
      Row(
        children: [
          Flexible(
            child: Text(
              AppLocalizations.of(context)!
                  .dialogMessageExperthModeReminderMessage,
              style: const TextStyle(
                fontSize: CustomStyle.sizeL,
              ),
            ),
          )
        ],
      ),
    ],
    barrierDismissible: false,
  );
}
